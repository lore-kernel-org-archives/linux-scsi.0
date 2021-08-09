Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A973C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD7E61002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhHIXFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:14 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36392 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbhHIXFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:10 -0400
Received: by mail-pl1-f182.google.com with SMTP id f3so7720576plg.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8ekO4G1BiWlUQSo2Reg6lj4O73UX5iGXlyNzLMWfic=;
        b=OhTOvfehx3SfYnMZCQC260xzlUMdOuhZOkvsqZzKKBoHnmLDZ2bKmz5NXJqXNsObdV
         1xSECpjhWrscVqEXItmZbGERqzBUgWV6Fi87m2gYyqscdRsmrqFlQLlfRFtN4ZaRATtp
         Egj8iIdlfiFcs+3zF5w98MMy/+peZOCapOoxW47VjT2XC+bxNQwlx6MMnHETFydFVHcN
         ZOiGg8iNtl7EDeux3yOrILujXjkG0ZY5xgr7T7JRtjjzPuJwpoNvZg0yoGiBFrwNWfEr
         bUziLbJ0v+cExt2hgxVq2nDzku7Q+nnvJIW7/oSDFUCFC190WYHiAYoOndKA0UQB6QV9
         RgRQ==
X-Gm-Message-State: AOAM533IszgWSb6w7iHxXAwOt6sztnKaTdbIr5p8jinTMrS9RQWWWJB5
        TfqIBbQADw69ziHljsxxrNYXbCYMSxDICQ==
X-Google-Smtp-Source: ABdhPJzGMqupFbRP8AoOlZUdSCuUKrtLijwH6wWdGWjP5YA5u7nSCJynatgh3myX3zqlOUggxADK4Q==
X-Received: by 2002:a17:90b:3014:: with SMTP id hg20mr16494564pjb.140.1628550289543;
        Mon, 09 Aug 2021 16:04:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 29/52] mpi3mr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:32 -0700
Message-Id: <20210809230355.8186-30-bvanassche@acm.org>
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
 drivers/scsi/mpi3mr/mpi3mr_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 24ac7ddec749..bc1c32f599de 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -50,7 +50,7 @@ static u16 mpi3mr_host_tag_for_scmd(struct mpi3mr_ioc *mrioc,
 	u32 unique_tag;
 	u16 host_tag, hw_queue;
 
-	unique_tag = blk_mq_unique_tag(scmd->request);
+	unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
 
 	hw_queue = blk_mq_unique_tag_to_hwq(unique_tag);
 	if (hw_queue >= mrioc->num_op_reply_q)
@@ -2016,7 +2016,7 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 	case SCSI_PROT_DIF_TYPE0:
 		eedp_flags |= MPI3_EEDPFLAGS_INCR_PRI_REF_TAG;
 		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		    cpu_to_be32(t10_pi_ref_tag(scsi_cmd_to_rq(scmd)));
 		break;
 	case SCSI_PROT_DIF_TYPE1:
 	case SCSI_PROT_DIF_TYPE2:
@@ -2024,7 +2024,7 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 		    MPI3_EEDPFLAGS_ESC_MODE_APPTAG_DISABLE |
 		    MPI3_EEDPFLAGS_CHK_GUARD;
 		scsiio_req->cdb.eedp32.primary_reference_tag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
+		    cpu_to_be32(t10_pi_ref_tag(scsi_cmd_to_rq(scmd)));
 		break;
 	case SCSI_PROT_DIF_TYPE3:
 		eedp_flags |= MPI3_EEDPFLAGS_CHK_GUARD |
@@ -3451,7 +3451,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	u16 dev_handle;
 	u16 host_tag;
 	u32 scsiio_flags = 0;
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	int iprio_class;
 
 	sdev_priv_data = scmd->device->hostdata;
