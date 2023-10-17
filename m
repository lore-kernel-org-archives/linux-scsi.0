Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0746ECDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 07:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbjJQHVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjJQHVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 03:21:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028D18E
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 00:21:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 96C6B1FF01;
        Tue, 17 Oct 2023 07:21:46 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 34CED2D3AB;
        Tue, 17 Oct 2023 07:21:46 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 526FB51EBE70; Tue, 17 Oct 2023 09:21:46 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] pmcraid: add missing scsi_device_put() in pmcraid_eh_target_reset_handler()
Date:   Tue, 17 Oct 2023 09:21:45 +0200
Message-Id: <20231017072145.120795-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Queue-Id: 96C6B1FF01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(Re-sending as a separate patch:)
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

