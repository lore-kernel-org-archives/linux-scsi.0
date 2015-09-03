From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Attach EXTENDED_COPY local I/O descriptors to xcopy_pt_sess
Date: Thu,  3 Sep 2015 06:58:25 +0000
Message-ID: <1441263505-19277-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33921 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbICHEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 03:04:24 -0400
Received: by oiev17 with SMTP id v17so20590399oie.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2015 00:04:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Alex Gorbachev <ag@iss-integration.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch is a >= v4.1 regression bug-fix where control CDB
emulation logic in commit 38b57f82 now expects a se_cmd->se_sess
pointer to exist when determining T10-PI support is to be exposed
for initiator host ports.

To address this bug, go ahead and add locally generated se_cmd
descriptors for copy-offload block-copy to it's own stand-alone
se_session nexus, while the parent EXTENDED_COPY se_cmd descriptor
remains associated with it's originating se_cmd->se_sess nexus.

Note a valid se_cmd->se_sess is also required for future support
of WRITE_INSERT and READ_STRIP software emulation when submitting
backend I/O to se_device that exposes T10-PI suport.

Reported-by: Alex Gorbachev <ag@iss-integration.com>
Cc: Alex Gorbachev <ag@iss-integration.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 4515f52..47fe94e 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -450,6 +450,8 @@ int target_xcopy_setup_pt(void)
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
 	INIT_LIST_HEAD(&xcopy_pt_sess.sess_list);
 	INIT_LIST_HEAD(&xcopy_pt_sess.sess_acl_list);
+	INIT_LIST_HEAD(&xcopy_pt_sess.sess_cmd_list);
+	spin_lock_init(&xcopy_pt_sess.sess_cmd_lock);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -644,7 +646,7 @@ static int target_xcopy_read_source(
 	pr_debug("XCOPY: Built READ_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)src_lba, src_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
+	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
 			      DMA_FROM_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->src_pt_cmd = xpt_cmd;
 
@@ -704,7 +706,7 @@ static int target_xcopy_write_destination(
 	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)dst_lba, dst_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
+	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
 			      DMA_TO_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->dst_pt_cmd = xpt_cmd;
 
-- 
1.7.10.4

