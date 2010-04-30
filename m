From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH] megaraid_sas: fix NULL pointer dereference in case of command
 via ioctl timeout
Date: Fri, 30 Apr 2010 19:34:23 +0900
Message-ID: <4BDAB22F.7090103@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:41194 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab0D3RNB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 13:13:01 -0400
Received: from fgwmail7.fujitsu.co.jp (fgwmail7.fujitsu.co.jp [192.51.44.37])
	by fgwmail8.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o3UAbLeg011246
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Fri, 30 Apr 2010 19:37:21 +0900
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o3UAZ6Lx009464
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Fri, 30 Apr 2010 19:35:07 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A36F45DE6E
	for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 19:35:06 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 21ADE45DE4D
	for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 19:35:06 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0C3AB1DB803A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 19:35:06 +0900 (JST)
Received: from m024.s.css.fujitsu.com (m024.s.css.fujitsu.com [10.0.81.64])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C006D1DB8037
	for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 19:35:05 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, Bo Yang <bo.yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi,

A NULL pointer dereference occurs if a command via ioctl times
out.

When a command is submitted via ioctl to megaraid_sas firmware,
the processing goes through like this:

  megasas_mgmt_ioctl()
    megasas_mgmt_ioctl_fw()
      megasas_mgmt_fw_ioctl()
        cmd->sync_cmd = 1
        megasas_issue_blocked_cmd()
          instance->instancet->fire_cmd() // command submitted
          wait_event_timeout(instance->int_cmd_wait_q,
                             cmd->cmd_status != ENODATA, ...)<--+
                                                                |
Normally, the firmware sends back a reply to the driver and it  |
wakes up the waiting processing (above) like this:              |
                                                                |
  interrupt                                                     |
    |                                                           |
    V                                                           |
  megasas_isr()                                                 |
    megasas_deplete_reply_queue()                               |
      tasklet_schedule(&instance->isr_tasklet)                  |
        |                                                       |
        V                                                       |
      megasas_complete_cmd_dpc()                                |
        megasas_complete_cmd()                                  |
          case MFI_CMD_PD_SCSI_IO:                              |
            if (cmd->sync_cmd)                                  |
              megasas_complete_int_cmd()                        |
                cmd->cmd_status = cmd->frame->io.cmd_status     |
                wake_up(&instance->int_cmd_wait_q) -------------+

If the command times out for some reason, however, it wakes up
and restarts the processing forward like this:

  wakes up and returns from megasas_issue_blocked_cmd()
  cmd->sync_cmd = 0
  ...
  megasas_return_cmd()

After that, if the command is executed and the firmware sends a
reply to the driver, since cmd->sync_cmd has been set to 0, the
processing goes like below (READ/WRITE command handling) and the
NULL pointer deference occurs, causing an Oops.

  interrupt
    |
    V
  megasas_isr()
    megasas_deplete_reply_queue()
      tasklet_schedule(&instance->isr_tasklet)
        |
        V
      megasas_complete_cmd_dpc()
        megasas_complete_cmd()
          case MFI_CMD_PD_SCSI_IO:
            // does nothing and falls through
          case MFI_CMD_LD_READ/WRITE:
            dereference to cmd->scmd that is NULL

I think something like the following patch should fix the issue.

Thanks,
Kei


Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 99e4478..4127790 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -594,13 +594,21 @@ static int
 megasas_issue_blocked_cmd(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd)
 {
+	long timeleft;
+
 	cmd->cmd_status = ENODATA;
 
 	instance->instancet->fire_cmd(instance,
 			cmd->frame_phys_addr, 0, instance->reg_set);
 
-	wait_event_timeout(instance->int_cmd_wait_q, (cmd->cmd_status != ENODATA),
-		MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+	timeleft = wait_event_timeout(instance->int_cmd_wait_q,
+				      (cmd->cmd_status != ENODATA),
+				      MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+
+	if (!timeleft) {
+		printk(KERN_ERR "megasas: command timed out\n");
+		cmd->cmd_status = ETIME;
+	}
 
 	return 0;
 }
@@ -1671,6 +1679,10 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	case MFI_CMD_PD_SCSI_IO:
 	case MFI_CMD_LD_SCSI_IO:
 
+		/* command timed out and there is nothing to do. */
+		if (unlikely(cmd->cmd_status == ETIME))
+			break;
+
 		/*
 		 * MFI_CMD_PD_SCSI_IO and MFI_CMD_LD_SCSI_IO could have been
 		 * issued either through an IO path or an IOCTL path. If it
@@ -3718,6 +3730,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	megasas_issue_blocked_cmd(instance, cmd);
 	cmd->sync_cmd = 0;
 
+	/* command timed out */
+	if (cmd->cmd_status == ETIME) {
+		error = -ETIME;
+		goto out;
+	}
+
 	/*
 	 * copy out the kernel buffers to user buffers
 	 */



