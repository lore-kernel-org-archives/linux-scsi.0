Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60036C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47CF6611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351276AbhERRqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:55 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39530 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351303AbhERRqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:50 -0400
Received: by mail-pg1-f179.google.com with SMTP id v14so4802422pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRcW7fYONM+w3bVDCwMWIkVeHIeN0190AU0T7r8uy0Q=;
        b=Z5FN+6iJXz8zj8odIvDxqxqeNo9FVDcj+PSJkBbZKzcdeh/rD9HJkRWzRaZ8e6Rbc2
         NTLJm4xf0Dj+dCXr23W/in9pMp9A1H9Z4cARFY73KUPiZQyRDJbVAwYCoeu7h0AcVJ33
         +mfe18/XMCEIOXxpQH+XTIGu5xx1zUDXBauDYAVHhRSFqPIcPYloarp7L0UE1E3dGbOB
         mbFZfJhyS8XjGIWSlGx06l/h8mSyh3HBJxQG4AZr5NfrxkwLdjp3XEJvPw9vnsCJWDQM
         TX+7lK3Ww/eMQ0Uj1zHBlusn5PtfVEmga+bYZFm0U7qQLIM2mLdirx6kiudizxrOXf7W
         vQfQ==
X-Gm-Message-State: AOAM5317fUnyZwNNrFSHJyZt18OHAZ5yEFG32xpPxvU6FPn9BTIbqPvf
        9URXG/gMz8FtlFRxnoqRciE=
X-Google-Smtp-Source: ABdhPJxOMouk6phtrcjuytuH6Y7KpSkaZ7a/0+A+ll5BBP3recV8fKXFUcPZmAxoLhc43O31d4WmaQ==
X-Received: by 2002:a63:4662:: with SMTP id v34mr6220660pgk.266.1621359931545;
        Tue, 18 May 2021 10:45:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 27/50] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:27 -0700
Message-Id: <20210518174450.20664-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8ed347eebf07..8fc7a3074a21 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1443,10 +1443,10 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	 * pthru timeout to the os layer timeout value.
 	 */
 	if (scp->device->type == TYPE_TAPE) {
-		if ((scp->request->timeout / HZ) > 0xFFFF)
+		if (scsi_cmd_to_rq(scp)->timeout / HZ > 0xFFFF)
 			pthru->timeout = cpu_to_le16(0xFFFF);
 		else
-			pthru->timeout = cpu_to_le16(scp->request->timeout / HZ);
+			pthru->timeout = cpu_to_le16(scsi_cmd_to_rq(scp)->timeout / HZ);
 	}
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175ae051..b894451a3e09 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -402,7 +402,7 @@ megasas_get_msix_index(struct megasas_instance *instance,
 			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
 				instance->msix_vectors));
 	} else if (instance->host->nr_hw_queues > 1) {
-		u32 tag = blk_mq_unique_tag(scmd->request);
+		u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 
 		cmd->request_desc->SCSIIO.MSIxIndex = blk_mq_unique_tag_to_hwq(tag) +
 			instance->low_latency_index_start;
@@ -3024,7 +3024,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		io_request->DevHandle = cpu_to_le16(device_id);
 		io_request->LUN[1] = scmd->device->lun;
 		pRAID_Context->timeout_value =
-			cpu_to_le16 (scmd->request->timeout / HZ);
+			cpu_to_le16(scsi_cmd_to_rq(scmd)->timeout / HZ);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
 			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -3087,7 +3087,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 
 	device_id = MEGASAS_DEV_INDEX(scmd);
 	pd_index = MEGASAS_PD_INDEX(scmd);
-	os_timeout_value = scmd->request->timeout / HZ;
+	os_timeout_value = scsi_cmd_to_rq(scmd)->timeout / HZ;
 	mr_device_priv_data = scmd->device->hostdata;
 	cmd->pd_interface = mr_device_priv_data->interface_type;
 
@@ -3376,7 +3376,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	cmd = megasas_get_cmd_fusion(instance, scsi_cmd_to_rq(scmd)->tag);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3417,7 +3417,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+				scsi_cmd_to_rq(scmd)->tag + instance->max_fw_cmds);
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
