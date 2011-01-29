From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less
	operation
Date: Sat, 29 Jan 2011 14:38:22 -0800
Message-ID: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34098 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1A2Wi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jan 2011 17:38:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Stephen and Co,

Attached is a quick patch to enable modern SCSI host_lock' less
operation for the HPSA SCSI LLD driver on >= .37 kernels.  After an
initial LLD conversion and review, I would like to verify with you that
the following calls are currently protected by HPDA LLD internal locks
that disable interrupts from the newly renamed hpsa_scsi_queue_command()
dispatcher below..

*) For cmd_alloc(), struct ctlr_info *h->lock + spin_lock_irqsave() is
obtained and released.

*) For enqueue_cmd_and_start_io(), struct ctlr_info *h->lock +
spin_lock_irqsave() is obtained for addQ() + start_io() and released.

So the one new piece wrt to host_lock less mode that is *not* protected
in hpsa_scsi_queue_command() is the call to hpsa_scatter_gather().  This
should be OK to get called without h->lock held w/ spin_lock_irqsave(),
yes..?

So far this patch has been compile tested only.  Please have a look and
comment.

Thanks!

--nab

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 12deffc..e205f33 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1906,9 +1906,11 @@ sglist_finished:
        return 0;
 }
 
-
-static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
-       void (*done)(struct scsi_cmnd *))
+/*
+ * Running in struct Scsi_Host->host_lock less mode using LLD internal
+ * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
+ */
+static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
        struct ctlr_info *h;
        struct hpsa_scsi_dev_t *dev;
@@ -1921,7 +1923,7 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
        dev = cmd->device->hostdata;
        if (!dev) {
                cmd->result = DID_NO_CONNECT << 16;
-               done(cmd);
+               cmd->scsi_done(cmd);
                return 0;
        }
        memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
@@ -1936,9 +1938,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
        }
 
        /* Fill in the command list header */
-
-       cmd->scsi_done = done;    /* save this for use by completion code */
-
        /* save c in case we have to abort it  */
        cmd->host_scribble = (unsigned char *) c;
 
@@ -2001,8 +2000,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
        return 0;
 }
 
-static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
-
 static void hpsa_scan_start(struct Scsi_Host *sh)
 {
        struct ctlr_info *h = shost_to_hba(sh);


