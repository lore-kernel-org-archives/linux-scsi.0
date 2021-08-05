Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14492C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F034C61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242858AbhHETTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:52 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:41766 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbhHETTt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:49 -0400
Received: by mail-pj1-f44.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so2729993pjy.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SoiNTGiEf535C6Cyx6x5fA9h5Kw7hd5u9wxDfAjjiS4=;
        b=iIdH5PZbP1HU8PSugz5OfSn0mamhxsm9AsI4i2aFhKdlu6ghCKwzKpwsB0kmHE/T+2
         XNBUyjQpCdlAmTJwlE+jIFCFyIy9PWWG8qqA7fUZgwwuxxcN/gOxveDz3X6Zt05eWJb5
         jm57SZe1doMxlNLRWzeh8XEwrRaBo/rkdEOJx2Vl1b3uHm47NedqYhQbNOvU8cyOrLh1
         q7K8ZTAb0l7WLloYxDOOmRoyFnQFozLkX8ddwfJnCai1yFa8RqSkrN2nRAapifUGpw1l
         Gprf/xy4WhOkfPl0/s+AD8GTa5IlhMbYD4B1qOInx5Qp5Ky5xXqt8fVvuN32o4sMQNXl
         sl0w==
X-Gm-Message-State: AOAM531QxE+psIl661d07LHwMXEo+YyT6UKG5h+AtMjWvfDz8HaU4x02
        5FU5YjkdJWW3gYCxGHcOuFfaajiqemPdc0YY
X-Google-Smtp-Source: ABdhPJxumf713Kyp2AbRWDymrISEnClQhigyZsN5FNd2QTlqxbHCIi1OrtuTtARMLkl2Yj8bk3V3zg==
X-Received: by 2002:a17:903:1ce:b029:12c:e40d:2c38 with SMTP id e14-20020a17090301ceb029012ce40d2c38mr3497451plh.20.1628191174845;
        Thu, 05 Aug 2021 12:19:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 28/52] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:04 -0700
Message-Id: <20210805191828.3559897-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
 
