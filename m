Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2410C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BAE613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhENVgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:08 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:37567 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhENVgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:06 -0400
Received: by mail-pj1-f54.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so2316005pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tnpr5ZI5CEPQwncjPhMvgusGoxvKu/oYRb+BORLty1A=;
        b=b1+TreBxRve6drmZzTds3W2RmPn7y0ltnb8TXZn4L86xmcIYB51lrETu6Mu+YWzTx1
         7IXVVs4sbdMBcTzcO0tXWpf8irfLnAiiRVJMpIq/2cKKicL/jwdeUshGs+mDd7YsG9na
         QWGfIulKXQJyp4Oh8mjSbEQw1iFzG2fWhHYgo0BcwSAcy4MaY8M8IuWufONzn+teB4Fr
         +1kFFKwiAzJ+QCXrb6NBg7zp66+BIqkScIrQuKDDV/jFphALYcpTndqk2K43gsogD89R
         IRh9x/r/IKQmJpCNeqqF6srAHlEF3mMymJPMn3D5NRIXzpq8/FXohi/xiLnYBJTOHaPW
         DPOQ==
X-Gm-Message-State: AOAM531OhC6uFNbx10voWA4QdpaPcUpI42zlTFpAifxcyBRP8p0FC36O
        V030bpiaOjc8W5XrHhK+CiA=
X-Google-Smtp-Source: ABdhPJwg9dskad7gD0LH6FEpO0YBPVkBVrMwj/nedP1E3iOFRThhkJWHTcq3slYdeISfn8GoakqxZg==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr54205825pjt.197.1621028093856;
        Fri, 14 May 2021 14:34:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 27/50] megaraid: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:42 -0700
Message-Id: <20210514213356.5264-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8ed347eebf07..94218c573c0e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1443,10 +1443,10 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	 * pthru timeout to the os layer timeout value.
 	 */
 	if (scp->device->type == TYPE_TAPE) {
-		if ((scp->request->timeout / HZ) > 0xFFFF)
+		if (blk_req(scp)->timeout / HZ > 0xFFFF)
 			pthru->timeout = cpu_to_le16(0xFFFF);
 		else
-			pthru->timeout = cpu_to_le16(scp->request->timeout / HZ);
+			pthru->timeout = cpu_to_le16(blk_req(scp)->timeout / HZ);
 	}
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175ae051..5a28d6b96eb2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -402,7 +402,7 @@ megasas_get_msix_index(struct megasas_instance *instance,
 			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
 				instance->msix_vectors));
 	} else if (instance->host->nr_hw_queues > 1) {
-		u32 tag = blk_mq_unique_tag(scmd->request);
+		u32 tag = blk_mq_unique_tag(blk_req(scmd));
 
 		cmd->request_desc->SCSIIO.MSIxIndex = blk_mq_unique_tag_to_hwq(tag) +
 			instance->low_latency_index_start;
@@ -3024,7 +3024,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		io_request->DevHandle = cpu_to_le16(device_id);
 		io_request->LUN[1] = scmd->device->lun;
 		pRAID_Context->timeout_value =
-			cpu_to_le16 (scmd->request->timeout / HZ);
+			cpu_to_le16(blk_req(scmd)->timeout / HZ);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
 			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -3087,7 +3087,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 
 	device_id = MEGASAS_DEV_INDEX(scmd);
 	pd_index = MEGASAS_PD_INDEX(scmd);
-	os_timeout_value = scmd->request->timeout / HZ;
+	os_timeout_value = blk_req(scmd)->timeout / HZ;
 	mr_device_priv_data = scmd->device->hostdata;
 	cmd->pd_interface = mr_device_priv_data->interface_type;
 
@@ -3376,7 +3376,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	cmd = megasas_get_cmd_fusion(instance, blk_req(scmd)->tag);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3417,7 +3417,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+				blk_req(scmd)->tag + instance->max_fw_cmds);
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
