Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEB9C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1E161159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhEXDLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:22 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:42577 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhEXDLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:21 -0400
Received: by mail-pj1-f52.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10316994pjv.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLOXmbkXRNeeP/UFiIiEMptFEfRvTpiTtB/FcoDb2+s=;
        b=MfDqQRUTWPeh1WhgaisVcyEWVHy1c1P7tdElYrBKa0vIsLNsmo4C5XWP7vJk2bEJaj
         i2e+UnZXXJPiqQPZHCO8jBam/9QyUiWsfXCObtRUV2EAOqNrSZXIwAJmIf23aeLwf0q5
         Rvz0pkwRoSBlgg8pzA2Mvks29qflChTzx4ZVpv7PvqVl78qfIk78uUki1NWiRieRS4dt
         qxAELXmo4NYwXZ4ml82h0pQ6L0qNMzrqrJPx1JtvpTZv4nYGRv9W7Jm829d1YIediW4K
         /xtdGR+tFGXjG5h8+4FECpCz8ZrJQbAqaB5okSFfo5B6Q5sYouuDbto1owZfFFxyLMMP
         oZRg==
X-Gm-Message-State: AOAM5320RwVn99NEGxZ6DQPTcQrzoxvgS72ZvK1AVGJOioCgjlZoujOn
        FxyeV/hIVvRH4vkptApYshU=
X-Google-Smtp-Source: ABdhPJwbyDbcU5t1J8ngOB2ems1R6A/wht5QqFz9+sPDo/kLoYrxOTSlYLknnC5e9xrh4V328rJuLQ==
X-Received: by 2002:a17:903:30c4:b029:f0:ad43:4ca with SMTP id s4-20020a17090330c4b02900f0ad4304camr22913896plc.70.1621825793161;
        Sun, 23 May 2021 20:09:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 28/51] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:33 -0700
Message-Id: <20210524030856.2824-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
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
 
