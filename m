Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3952C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820786115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhEXDLY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:24 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:36553 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhEXDLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:23 -0400
Received: by mail-pl1-f176.google.com with SMTP id a7so5214436plh.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=viCiB4o6GXr0kJHTMIfRdGFoQM/n4ommt0j81s06QY4=;
        b=rVRHKgeMcCnZRG9W9VIIQ/pE2eYf5hHLoeGFxZ3BkH8YpgjP9gxNr+ciAEAjnrA2nh
         Yhv8Et+5fLHGNRi3PDb8ADHFHPgrZT/N47PKn6jCebkUCWVuOCX+hXb7lo2Bnm8g0yVz
         GFSmcGxqTi3/73g4ZXQtRdCvtZM5D8PBnPdaHVVeHUsmqvz7sZi4JT8KEj1uiqOWBEju
         +GgwnQFWc94KI//hj1yYsU11w52foRz6DfMAnWAx7nFCYznUt75mfrVi7rhE7lJqyqm6
         KRtt0jGMcM7MExgLpU9VchwFJa/BLoX/1kBpilLPHDGtyrXyo8L5/H8799GGmgBXi/of
         oOXg==
X-Gm-Message-State: AOAM532juDVlFG2tz/0ozZX2HjAy3U42whr+SSPpkqa5oR0rUFRA/akL
        MGCsKtP3Q7t1iEsmds+8BeE=
X-Google-Smtp-Source: ABdhPJyRQoHLRrmTHoDAfDd/nX23MQCUWLBssnvM9hEL4Rb34CqJa8Ad+PlKFxB1FDpMZkISgvtCuA==
X-Received: by 2002:a17:90a:4415:: with SMTP id s21mr21616217pjg.25.1621825794892;
        Sun, 23 May 2021 20:09:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 29/51] mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:34 -0700
Message-Id: <20210524030856.2824-30-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 68fde055b02f..352526cdcb2d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3649,7 +3649,7 @@ _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc,
 		    &ioc->total_io_cnt), ioc->reply_queue_count) : 0;
 
 	if (scmd && ioc->shost->nr_hw_queues > 1) {
-		u32 tag = blk_mq_unique_tag(scmd->request);
+		u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 
 		return blk_mq_unique_tag_to_hwq(tag) +
 			ioc->high_iops_queues;
@@ -3733,7 +3733,7 @@ mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	u16 smid;
 	u32 tag, unique_tag;
 
-	unique_tag = blk_mq_unique_tag(scmd->request);
+	unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 	tag = blk_mq_unique_tag_to_tag(unique_tag);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..c05abb458f57 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3303,7 +3303,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	sdev_printk(KERN_INFO, scmd->device, "attempting task abort!"
 	    "scmd(0x%p), outstanding for %u ms & timeout %u ms\n",
 	    scmd, jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
-	    (scmd->request->timeout / HZ) * 1000);
+	    (scsi_cmd_to_rq(scmd)->timeout / HZ) * 1000);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
@@ -5032,7 +5032,7 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		    cpu_to_be32(t10_pi_ref_tag(scsi_cmd_to_rq(scmd)));
 		break;
 
 	case SCSI_PROT_DIF_TYPE3:
@@ -5101,7 +5101,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _raid_device *raid_device;
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	int class;
 	Mpi25SCSIIORequest_t *mpi_request;
 	struct _pcie_device *pcie_device = NULL;
