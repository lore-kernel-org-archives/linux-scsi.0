Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732E0CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjJPJYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjJPJYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C92395
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:45 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 46B5721884;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C61772CB3C;
        Mon, 16 Oct 2023 09:24:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C37D251EBDC2; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/17] pmcraid: add missing scsi_device_put() in pmcraid_eh_target_reset_handler()
Date:   Mon, 16 Oct 2023 11:24:14 +0200
Message-Id: <20231016092430.55557-2-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [11.49 / 50.00];
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
         BAYES_HAM(-0.00)[20.75%]
X-Rspamd-Queue-Id: 46B5721884
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When breaking out of a shost_for_each_device() loop one need to do
an explicit scsi_device_put(). And while at it convert to use
shost_priv() instead of a direct reference to ->hostdata.

Fixes: c2a14ab3b9b3 ("scsi: pmcraid: Select device in pmcraid_eh_target_reset_handler()")
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pmcraid.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a831b34c08a4..d946fb014474 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2702,8 +2702,7 @@ static int pmcraid_reset_device(
 	unsigned long lock_flags;
 	u32 ioasc;
 
-	pinstance =
-		(struct pmcraid_instance *)scsi_dev->host->hostdata;
+	pinstance = shost_priv(scsi_dev->host);
 	res = scsi_dev->hostdata;
 
 	if (!res) {
@@ -3026,8 +3025,7 @@ static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *host = scmd->device->host;
-	struct pmcraid_instance *pinstance =
-		(struct pmcraid_instance *)host->hostdata;
+	struct pmcraid_instance *pinstance = shost_priv(host);
 	struct pmcraid_resource_entry *res = NULL;
 	struct pmcraid_resource_entry *temp;
 	struct scsi_device *sdev = NULL;
@@ -3066,6 +3064,7 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	struct scsi_device *scsi_dev = NULL, *tmp;
+	int ret;
 
 	shost_for_each_device(tmp, shost) {
 		if ((tmp->channel == scmd->device->channel) &&
@@ -3078,9 +3077,11 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 		return FAILED;
 	sdev_printk(KERN_INFO, scsi_dev,
 		    "Doing target reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scsi_dev,
-				    PMCRAID_INTERNAL_TIMEOUT,
-				    RESET_DEVICE_TARGET);
+	ret = pmcraid_reset_device(scsi_dev,
+				   PMCRAID_INTERNAL_TIMEOUT,
+				   RESET_DEVICE_TARGET);
+	scsi_device_put(scsi_dev);
+	return ret;
 }
 
 /**
-- 
2.35.3

