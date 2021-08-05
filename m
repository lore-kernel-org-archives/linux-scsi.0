Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFE9C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31B660BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242907AbhHETTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:53 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:35338 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242920AbhHETTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:51 -0400
Received: by mail-pj1-f51.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so17377686pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8ekO4G1BiWlUQSo2Reg6lj4O73UX5iGXlyNzLMWfic=;
        b=A0q4MEEceOzMeMmv9Jlz0+TXN0eOc0Ag7sAm0CH8TP+Gd/8VFzEtoDi51wC3Q/pP9F
         z5KgU84ypc3BVrUgjjh2yHMSENEM6FIsowPRUISTE9vsqutAUFzaFhhnhiCnauwM/KrH
         oUbXtRCMQ8D9Z5cY+R3f+vvmnJnAetxJk1y3fCj2XAZj2P8wgP6QNC8f37p9kVdlHlLF
         slgUg95DoxtvmsV4wCWPdOc/MNMZDH2Nw2DhTVyPB9H55WXEgpnHaG9kS1s8DiAOz+0T
         5lT2hhIuwWImkrfiT+9QDtVb+4WN+G4CazCXWJC4yutlxRvlSdHUpgv2yeKyMY+0OLV/
         fM9g==
X-Gm-Message-State: AOAM530X3prdtmL73lHW7Lwvj0D9OZ3EbIts3W0ABTstwVRpYpZ1rGJZ
        9EJGnBcZ4Yz2VtU21TdejOk=
X-Google-Smtp-Source: ABdhPJz9jiyJufOXMJh9E9YPiWh+SuL20q1nB5QMwrUvb8FBJp8ngknycoAv32AwNgTssaXJ9jS1CA==
X-Received: by 2002:a17:90b:38ca:: with SMTP id nn10mr6259692pjb.3.1628191176479;
        Thu, 05 Aug 2021 12:19:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 29/52] mpi3mr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:05 -0700
Message-Id: <20210805191828.3559897-30-bvanassche@acm.org>
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
