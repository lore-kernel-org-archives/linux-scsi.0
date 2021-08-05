Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7D3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8113360BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbhHETT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:56 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:44909 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242791AbhHETTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:52 -0400
Received: by mail-pj1-f50.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11974602pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gHpYNKPdLYIl1M0ZRtiiLCYKXNFU0DePiISm0XGxoM=;
        b=E+Uf6BvyJOXNRD3X1VBxagHyIhzI7a/Y/eG6SkkEF1Umwyyjbru2wm4yFAVRgAHQuu
         KL/guTb55gIMjMlyjXdrih+ixDWz2TZDcjtF2AE9fy3WBGpnA/Yoby5GOyPn2HSm6xNr
         h490sCkF/gx1ATKdhkxaC+zrdSOJhGK6FA8avx3FXRzrN5F8Sht1pQCHJh9r9eS6sGPW
         CUekmVpp7VAYy2rGNnj2kFza7l0TSXcKIU7wLCAvFEWf14K/y8sgCzp75gVpJbSpg7Rj
         12J304/Gujs+QwRjwJk/o7mTXKs6CM2gK2SYC8UrTyL71nyl8imfM6BVMkdr/UtME1x8
         CqXA==
X-Gm-Message-State: AOAM530eeb/n7Xh6ZPk/OwzY6m9aFaG1iKpVzAQSHOsBfN6qTkKi0iMk
        27cIVwKO+FpwKJLTOAvP5FY=
X-Google-Smtp-Source: ABdhPJzuZj5GqIiNuubLo4DTLWu+WqUtkoNwek1803uc1doSQ/+JReD7COLguawhOE3SrKdrRZyeFA==
X-Received: by 2002:a17:90a:aa05:: with SMTP id k5mr6221625pjq.47.1628191177948;
        Thu, 05 Aug 2021 12:19:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 30/52] mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:06 -0700
Message-Id: <20210805191828.3559897-31-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c39955239d1c..b9c513ef7134 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3651,7 +3651,7 @@ _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc,
 		    &ioc->total_io_cnt), ioc->reply_queue_count) : 0;
 
 	if (scmd && ioc->shost->nr_hw_queues > 1) {
-		u32 tag = blk_mq_unique_tag(scmd->request);
+		u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 
 		return blk_mq_unique_tag_to_hwq(tag) +
 			ioc->high_iops_queues;
@@ -3735,7 +3735,7 @@ mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	u16 smid;
 	u32 tag, unique_tag;
 
-	unique_tag = blk_mq_unique_tag(scmd->request);
+	unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 	tag = blk_mq_unique_tag_to_tag(unique_tag);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118f7931..0e8f6d9a998a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3304,7 +3304,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	sdev_printk(KERN_INFO, scmd->device, "attempting task abort!"
 	    "scmd(0x%p), outstanding for %u ms & timeout %u ms\n",
 	    scmd, jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
-	    (scmd->request->timeout / HZ) * 1000);
+	    (scsi_cmd_to_rq(scmd)->timeout / HZ) * 1000);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
@@ -5074,7 +5074,7 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		    cpu_to_be32(t10_pi_ref_tag(scsi_cmd_to_rq(scmd)));
 		break;
 
 	case SCSI_PROT_DIF_TYPE3:
@@ -5141,7 +5141,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _raid_device *raid_device;
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	int class;
 	Mpi25SCSIIORequest_t *mpi_request;
 	struct _pcie_device *pcie_device = NULL;
