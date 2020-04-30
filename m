Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464B3C8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278BC2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgD3NUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:60762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgD3NUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2A04AAF22;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 19/41] megaraid_sas: avoid using megaraid_lookup_instance()
Date:   Thu, 30 Apr 2020 15:18:42 +0200
Message-Id: <20200430131904.5847-20-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a scsi device is given we can dereference the hostdata
pointer directly from the scsi host, no need to painstakingly
looking it up.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b241a0ae9955..43a179fc91f2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2004,9 +2004,7 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 						 bool is_target_prop)
 {
 	u32 max_io_size_kb = MR_DEFAULT_NVME_MDTS_KB;
-	struct megasas_instance *instance;
-
-	instance = megasas_lookup_instance(sdev->host->host_no);
+	struct megasas_instance *instance = shost_priv(sdev->host);
 
 	/*
 	 * The RAID firmware may require extended timeouts.
@@ -2029,11 +2027,10 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = shost_priv(sdev->host);
 	int ret_target_prop = DCMD_FAILED;
 	bool is_target_prop = false;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (instance->pd_list_not_supported) {
 		if (!MEGASAS_IS_LOGICAL(sdev) && sdev->type == TYPE_DISK) {
 			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
@@ -2069,10 +2066,9 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 static int megasas_slave_alloc(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
-	struct megasas_instance *instance ;
+	struct megasas_instance *instance = shost_priv(sdev->host);
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (!MEGASAS_IS_LOGICAL(sdev)) {
 		/*
 		 * Open the OS scan to the SYSTEM PD
-- 
2.16.4

