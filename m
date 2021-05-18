Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDB3C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CF7611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351274AbhERRq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:57 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:47083 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351266AbhERRqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:52 -0400
Received: by mail-pj1-f53.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1951002pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=viCiB4o6GXr0kJHTMIfRdGFoQM/n4ommt0j81s06QY4=;
        b=Xo3A5E3jFiTCs44zCBD2ZPd+6lS0Nbt9uZ53TzwZoFV99uf7EYCDIm8+yCrJ2XsVoe
         y1wTqz1EQdAqfLTisK5iFsbAXU3Tdp8C+kHLFQ+M0viV0o2kbr2KkPIAd1BQfOGGSci/
         6FQ/C1MyCFexyD68r96+GQo3flKrTl645O+leoaBS9RLdkPr40g89mFA05J/RNHzXIC0
         IwZ/UMhlBnd7H5WLVzbEoVbhyanP+Oj3EUvndgQ+njQmYi5VXVofLRWdElNry7z6e5wQ
         3vMSUyx/kGoWo8OVP0ZD2LzXX8qTG7/nH7KI6WB/s9gvSXKBNkYSfn03fKbFd6CYyAAM
         QHCQ==
X-Gm-Message-State: AOAM5306tbgH2/wK0oZzyChEdFu8BnWtcRz87ouZnECDQjVtrrB2aGy4
        Jv13DkRBmMu6BuysZVJkHIE=
X-Google-Smtp-Source: ABdhPJxwQUYXmfYsaGeepmXgW3PywKgfFNE0Cm6/UBuidEsCOv0JDrlMUevaJ8bgBkSit73CIt4V5w==
X-Received: by 2002:a17:902:b487:b029:ee:d04b:741e with SMTP id y7-20020a170902b487b02900eed04b741emr5776486plr.45.1621359932596;
        Tue, 18 May 2021 10:45:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 28/50] mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:28 -0700
Message-Id: <20210518174450.20664-29-bvanassche@acm.org>
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
