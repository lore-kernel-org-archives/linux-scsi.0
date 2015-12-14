From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 4/6] cxlflash: Fix to resolve cmd leak after host reset
Date: Mon, 14 Dec 2015 15:07:02 -0600
Message-ID: <1450127222-48145-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:37988 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbbLNVIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 16:08:12 -0500
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 14:08:11 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E72A83E40044
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:07:46 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEL7kwS30081196
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:07:46 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEL7iwm030889
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:07:46 -0700
In-Reply-To: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

From: Manoj Kumar <manoj@linux.vnet.ibm.com>

After a few iterations of resetting the card, either during EEH
recovery, or a host_reset the following is seen in the logs.
cxlflash 0008:00: cxlflash_queuecommand: could not get a free command

At every reset of the card, the commands that are outstanding are
being leaked.  No effort is being made to reap these commands.  A few
more resets later, the above error message floods the logs and the
card is rendered totally unusable as no free commands are available.

Iterated through the 'cmd' queue and printed out the 'free' counter
and found that on each reset certain commands were in-use and
stayed in-use through subsequent resets.

To resolve this issue, when the card is reset, reap all the commands
that are active/outstanding.

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 35a3202..ac39856 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -632,15 +632,30 @@ static void free_mem(struct cxlflash_cfg *cfg)
  * @cfg:	Internal structure associated with the host.
  *
  * Safe to call with AFU in a partially allocated/initialized state.
+ *
+ * Cleans up all state associated with the command queue, and unmaps
+ * the MMIO space.
+ *
+ *  - complete() will take care of commands we initiated (they'll be checked
+ *  in as part of the cleanup that occurs after the completion)
+ *
+ *  - cmd_checkin() will take care of entries that we did not initiate and that
+ *  have not (and will not) complete because they are sitting on a [now stale]
+ *  hardware queue
  */
 static void stop_afu(struct cxlflash_cfg *cfg)
 {
 	int i;
 	struct afu *afu = cfg->afu;
+	struct afu_cmd *cmd;
 
 	if (likely(afu)) {
-		for (i = 0; i < CXLFLASH_NUM_CMDS; i++)
-			complete(&afu->cmd[i].cevent);
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+			cmd = &afu->cmd[i];
+			complete(&cmd->cevent);
+			if (!atomic_read(&cmd->free))
+				cmd_checkin(cmd);
+		}
 
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
-- 
2.1.0

