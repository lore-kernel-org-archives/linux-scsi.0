Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E20C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F54D60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhHIXFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:13 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:39582 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbhHIXFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:09 -0400
Received: by mail-pj1-f44.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so1415668pjn.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SoiNTGiEf535C6Cyx6x5fA9h5Kw7hd5u9wxDfAjjiS4=;
        b=LeBTF1VRxjIa9ovAED/GORnEaiARn2cSNT/qeWcNPVVJEjcDU0UTYI0UvCi9hvKAli
         JuwcSDE9Sohnig7plGMkdoAmL4hq9PIOreNlqEtbo1pbdOy4kN1HMlmkKLhgtezUNsbv
         siuH2877GJWjR6GF+JKnr1/NiY/6/8bjMRCi70AIWVbdFay+RqQdJZtbPvVkMakGZfHk
         JLXphAqYES32V3D1eozXjQJd0TSi+znq4ydMnxPf53jTXYKYZpJugrn/Oimy6Q7y6Du9
         944J9BeH3nrw2AbtWAFK3XB76loFxnjiLcTSGSV3Mmk/XhDA2MRGa4bjfB2tFwiuw4rI
         NZpA==
X-Gm-Message-State: AOAM533CjA03dkYMBaQALGqMgAo0pI2JcPnoF2JqRz1WNodGuBKBdteK
        QSBcMq5l7HeS3RduifqnEg8=
X-Google-Smtp-Source: ABdhPJwQ0CvGc0SddTNM4BX9OMmjKmmYHXukXoeCfbu8Qr6kgEobxm+youvQZ6/SiAImDGDmuekqCg==
X-Received: by 2002:a17:902:eb52:b029:12c:3265:26a with SMTP id i18-20020a170902eb52b029012c3265026amr22464715pli.34.1628550287992;
        Mon, 09 Aug 2021 16:04:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 28/52] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:31 -0700
Message-Id: <20210809230355.8186-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index ec10b2497310..e4298bf4a482 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1451,10 +1451,10 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
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
index 06399c026a8d..26d0cf9353dd 100644
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
@@ -3023,7 +3023,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		io_request->DevHandle = cpu_to_le16(device_id);
 		io_request->LUN[1] = scmd->device->lun;
 		pRAID_Context->timeout_value =
-			cpu_to_le16 (scmd->request->timeout / HZ);
+			cpu_to_le16(scsi_cmd_to_rq(scmd)->timeout / HZ);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
 			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -3086,7 +3086,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 
 	device_id = MEGASAS_DEV_INDEX(scmd);
 	pd_index = MEGASAS_PD_INDEX(scmd);
-	os_timeout_value = scmd->request->timeout / HZ;
+	os_timeout_value = scsi_cmd_to_rq(scmd)->timeout / HZ;
 	mr_device_priv_data = scmd->device->hostdata;
 	cmd->pd_interface = mr_device_priv_data->interface_type;
 
@@ -3381,7 +3381,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	cmd = megasas_get_cmd_fusion(instance, scsi_cmd_to_rq(scmd)->tag);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3422,7 +3422,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+				scsi_cmd_to_rq(scmd)->tag + instance->max_fw_cmds);
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
