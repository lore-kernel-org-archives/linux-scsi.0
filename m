Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4A4C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0016861454
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhENVgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:10 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:36546 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbhENVgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:07 -0400
Received: by mail-pl1-f171.google.com with SMTP id a11so107348plh.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29sCidPj+SoPCRHr9m8Ap1ddi6G1T++ogw6KCMhFjVU=;
        b=IqzNRRaTAwo33GTGksyg4ASwqkAF/8KA+C1nVTfLkEVm2/aOUnyHrUENydWHMxQHk8
         j3T3HO5AMkrLD/ih1f0dZaAlwpGqd6oyXbH3e6EYdjx6l+uiGtlIFmxBDNpLwn49Nn/l
         oViENArJhqQVrPxFyn5Nb1D6cB7xm4t3qMwVTZ87H1mUVYQmEZZDXuQq9ftv3SFlKGOn
         vL8v8cEsEw0zGWFMX7RUjOdlU0F49fRbpW2L0Z8xgZ0/aVs0LmPNLqqs2RgOXXEo1c/P
         2B23Xa4XZYDd6ckSkTnuInaX9MlRWeBB3ulQIZ9y2U9uJmrzKzp3XD1vKRX1sG6Hcrw7
         jb4Q==
X-Gm-Message-State: AOAM530JQD+jy7WNFMS5xSJuXLTWG02gryEeMMJBQJ16YO3fCpCIyH76
        zU7X7hzmw3z7KI9LztJowawKg7ZaZ3y2XQ==
X-Google-Smtp-Source: ABdhPJz8YKgJxsSie2fuGAXuO/6CquNZl+0iq04ULq28VDdJFiB1+onNhEB3dy8ew4torkbJZKJz9w==
X-Received: by 2002:a17:90a:b388:: with SMTP id e8mr13104079pjr.167.1621028095489;
        Fri, 14 May 2021 14:34:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 28/50] mpt3sas: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:43 -0700
Message-Id: <20210514213356.5264-29-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 68fde055b02f..88ffd1df7da4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3649,7 +3649,7 @@ _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc,
 		    &ioc->total_io_cnt), ioc->reply_queue_count) : 0;
 
 	if (scmd && ioc->shost->nr_hw_queues > 1) {
-		u32 tag = blk_mq_unique_tag(scmd->request);
+		u32 tag = blk_mq_unique_tag(blk_req(scmd));
 
 		return blk_mq_unique_tag_to_hwq(tag) +
 			ioc->high_iops_queues;
@@ -3733,7 +3733,7 @@ mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	u16 smid;
 	u32 tag, unique_tag;
 
-	unique_tag = blk_mq_unique_tag(scmd->request);
+	unique_tag = blk_mq_unique_tag(blk_req(scmd));
 	tag = blk_mq_unique_tag_to_tag(unique_tag);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d00aca3c77ce..5d617bb74ddc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3303,7 +3303,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 	sdev_printk(KERN_INFO, scmd->device, "attempting task abort!"
 	    "scmd(0x%p), outstanding for %u ms & timeout %u ms\n",
 	    scmd, jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc),
-	    (scmd->request->timeout / HZ) * 1000);
+	    (blk_req(scmd)->timeout / HZ) * 1000);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
@@ -5032,7 +5032,7 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		    cpu_to_be32(t10_pi_ref_tag(blk_req(scmd)));
 		break;
 
 	case SCSI_PROT_DIF_TYPE3:
@@ -5101,7 +5101,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct _raid_device *raid_device;
-	struct request *rq = scmd->request;
+	struct request *rq = blk_req(scmd);
 	int class;
 	Mpi25SCSIIORequest_t *mpi_request;
 	struct _pcie_device *pcie_device = NULL;
