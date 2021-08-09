Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E401C43214
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F39F6101D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhHIXFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:15 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:47021 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhHIXFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:12 -0400
Received: by mail-pj1-f53.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso2377202pjy.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gHpYNKPdLYIl1M0ZRtiiLCYKXNFU0DePiISm0XGxoM=;
        b=irT4mthX1Zb9X2vkdS/SSXnK5CsUUkFTcEmsOn+ApEtjhQGIi3jVQWTojoa7SA+GUW
         xUvhw2BomY+eNJBiR7tjkCNLH1fK03/qtTLcg6BmPfNbRUhUYR0tv4drLDT1ems/yYIO
         xYyOrqCUlyoCCsTqZzlyKC1TD940N7d4217yDXAmA9D1ZPJc6jfxXFpkksTAv/cHSkMF
         ldNYxzdpIhMB2odYcmwkvJP4SJ5SrKKmnuxbfVrW1a9lZKRsWY4UE7pNoSzkFNTHmXj7
         /uPwRTJYOMtx+QgvNN6vL7F2ZXKzMDqMPskm1lf1HDpu3GJWGUH5V5BiHWteeqBHD9a1
         9jtA==
X-Gm-Message-State: AOAM531gvcS3uQWFQuRiTzOkU/cQ88o9X9vQyVCiahaff+CUpKFhxMAz
        lDrWKoqtd/REI9q5hkD/LEg=
X-Google-Smtp-Source: ABdhPJy/mwerNlmgLzqN4j4x93jrQCAIX6jRjUS0F6cAqVUumY7yrXYwXGWIinOdNStFAJpZzGdt6g==
X-Received: by 2002:a17:90a:d144:: with SMTP id t4mr27132060pjw.113.1628550291034;
        Mon, 09 Aug 2021 16:04:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 30/52] mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:33 -0700
Message-Id: <20210809230355.8186-31-bvanassche@acm.org>
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
