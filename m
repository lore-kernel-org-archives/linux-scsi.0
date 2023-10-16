Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD3ECDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjJPJZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjJPJYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30A2E5
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD22621C46;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1C7E22D10A;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E32E351EBDD1; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/17] scsi_transport_iscsi: use session as argument for iscsi_block_scsi_eh()
Date:   Mon, 16 Oct 2023 11:24:23 +0200
Message-Id: <20231016092430.55557-11-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [8.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: AD22621C46
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We should be passing in the session directly instead of deriving it
from the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla4xxx/ql4_os.c       | 34 ++++++++++++++++++-----------
 drivers/scsi/scsi_transport_iscsi.c |  6 ++---
 include/scsi/scsi_transport_iscsi.h |  2 +-
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 675332e49a7b..961fe65bbe65 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9272,15 +9272,18 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
  **/
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
-	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct scsi_device *sdev = cmd->device;
+	struct scsi_qla_host *ha = to_qla_host(sdev->host);
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry = sdev->hostdata;
 	int ret = FAILED, stat;
 	int rval;
 
 	if (!ddb_entry)
 		return ret;
 
-	ret = iscsi_block_scsi_eh(cmd);
+	session = starget_to_session(scsi_target(sdev));
+	ret = iscsi_block_scsi_eh(session);
 	if (ret)
 		return ret;
 	ret = FAILED;
@@ -9341,19 +9344,25 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
  **/
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
-	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct scsi_target *starget = scsi_target(cmd->device);
+	struct iscsi_cls_session *cls_session = starget_to_session(starget);
+	struct iscsi_session *sess;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry;
 	int stat, ret;
 	int rval;
 
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
 	if (!ddb_entry)
 		return FAILED;
+	ha = ddb_entry->ha;
 
-	ret = iscsi_block_scsi_eh(cmd);
+	ret = iscsi_block_scsi_eh(cls_session);
 	if (ret)
 		return ret;
 
-	starget_printk(KERN_INFO, scsi_target(cmd->device),
+	starget_printk(KERN_INFO, starget,
 		       "WARM TARGET RESET ISSUED.\n");
 
 	DEBUG2(printk(KERN_INFO
@@ -9370,14 +9379,13 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 
 	stat = qla4xxx_reset_target(ha, ddb_entry);
 	if (stat != QLA_SUCCESS) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET RESET FAILED.\n");
 		return FAILED;
 	}
 
-	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
-					 NULL)) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+	if (qla4xxx_eh_wait_for_commands(ha, starget, NULL)) {
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
 			       "waiting for commands.\n");
 		return FAILED;
@@ -9386,13 +9394,13 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	/* Send marker. */
 	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
 		MM_TGT_WARM_RESET) != QLA_SUCCESS) {
-		starget_printk(KERN_INFO, scsi_target(cmd->device),
+		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
 			       "marker iocb failed.\n");
 		return FAILED;
 	}
 
-	starget_printk(KERN_INFO, scsi_target(cmd->device),
+	starget_printk(KERN_INFO, starget,
 		       "WARM TARGET RESET SUCCEEDED.\n");
 	return SUCCESS;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3075b2ddf7a6..4e81ef882a49 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1838,17 +1838,15 @@ static void iscsi_scan_session(struct work_struct *work)
 
 /**
  * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
- * @cmd: scsi cmd passed to scsi eh handler
+ * @session: iscsi session derived from scsi eh handler argument
  *
  * If the session is down this function will wait for the recovery
  * timer to fire or for the session to be logged back in. If the
  * recovery timer fires then FAST_IO_FAIL is returned. The caller
  * should pass this error value to the scsi eh.
  */
-int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
+int iscsi_block_scsi_eh(struct iscsi_cls_session *session)
 {
-	struct iscsi_cls_session *session =
-			starget_to_session(scsi_target(cmd->device));
 	unsigned long flags;
 	int ret = 0;
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fb3399e4cd29..8ec36de5d236 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -466,7 +466,7 @@ extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
 extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
-extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
+extern int iscsi_block_scsi_eh(struct iscsi_cls_session *session);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
 					      uint32_t iface_type,
-- 
2.35.3

