Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340EAC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0895E20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irX0fgLd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfHNX5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40633 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbfHNX5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id w16so333464pfn.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fk5h2S18ZJb3jQirasCxiDfGqvmf59+BHrMRWY9uNZ0=;
        b=irX0fgLd4BD9ykIMGzurcvGgjTgwvsLVxzaAyt2UYf/j7I60+TT7TiAROuJ3PiEe6f
         oQvxHMF2xbwvFKdT5jDxUvnAhmS6aG88TDhJcwbXUElRdIrwuZviM4F6Xbd0HiqzWbxu
         u6YN97Nw14TKagkL1OU/7gD3wRACvtoZ+Cm511mFPnwN4DGG3HBl3hyIKUFdSsukNGI6
         u6jIL1MzgvsQ2O6dTJVfFAURZOdM2pmGMew/9BrynXjn+C5d4o+4xtU8uHYGJHo0h1l4
         P+NyOFQ7hK6/K4TBMKjjeC4A+v2/s/1JoeeoKFm2H5FpW5MxdZhDrRDB8ha7H5uwRYIB
         41wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fk5h2S18ZJb3jQirasCxiDfGqvmf59+BHrMRWY9uNZ0=;
        b=ieaWg5A+6eXLYAX+o+UzzhBo9oQxvmUud+tA07I7KFrCTFBsR9KBCJd8Jap/CL8YbE
         AV6jhozZJvqSQhedoBuheY8MLslHcH1SZGnohWU10l5KHuT0qCQ7eTDHuWWM3XdX7dVW
         /vxPBMnchS6N8OUM72a0oHBMJ723KQJRPtF1RxxCOtgy8IidWanZRHzJmsDdfyE3zrO6
         KgE0X7q0RzZp2BBYvd0BvAvo+Q8s02RwA9vTjPEQZkQYCYVIpNx4z2fHPqcwiHl3LMWf
         NS8un3v2LGLwURr95z6u7Kiwf/BXOPxZJXBxRu/NmLTMlC2SrJizL/cUtMpYbvRpBp+v
         V1xQ==
X-Gm-Message-State: APjAAAWHbduliLNz5/ASapJbSm82QfqflSlmVrvdrB6ID3VX4qi5HzBc
        38Dx3QQm3Iq+a2I69XP+6Ta6hTAr
X-Google-Smtp-Source: APXvYqw8QqaWjpAiZs0hMfxxGhXAohwBZyDlhc5I6fD7gRw1BXBQMFcOKr9WoqO/wgX9lbAOayyOAQ==
X-Received: by 2002:a63:c44c:: with SMTP id m12mr1351483pgg.396.1565827072008;
        Wed, 14 Aug 2019 16:57:52 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 38/42] lpfc: Add MDS driver loopback diagnostics support
Date:   Wed, 14 Aug 2019 16:57:08 -0700
Message-Id: <20190814235712.4487-39-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added code to support driver loopback with MDS Diagnostics.
This style of diagnostics passes frames from the fabric to
the driver who then echo them back out the link.  SEND_FRAME
WQEs are used to transmit the frames.  Added the SOF and EOF
field location definitions for use by SEND_FRAME.

Also ensure that enable_mds_diags is a RW parameter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  2 +-
 drivers/scsi/lpfc/lpfc_els.c  | 11 ++++++-----
 drivers/scsi/lpfc/lpfc_hw4.h  |  6 ++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 30 +++++++++++++++++++++++++-----
 4 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f4f1291ec1ba..491a999056aa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5925,7 +5925,7 @@ lpfc_sg_seg_cnt_init(struct lpfc_hba *phba, int val)
  *       1  = MDS Diagnostics enabled
  * Value range is [0,1]. Default value is 0.
  */
-LPFC_ATTR_R(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
+LPFC_ATTR_RW(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
 
 /*
  * lpfc_ras_fwlog_buffsize: Firmware logging host buffer size
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index aaad1c74bb98..30bbfa3f6086 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1052,17 +1052,18 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
 
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+				 "0150 FLOGI failure Status:x%x/x%x "
+				 "xri x%x TMO:x%x\n",
+				 irsp->ulpStatus, irsp->un.ulpWord[4],
+				 cmdiocb->sli4_xritag, irsp->ulpTimeout);
+
 		/* If this is not a loop open failure, bail out */
 		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
 		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
 			goto flogifail;
 
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-				 "0150 FLOGI failure Status:x%x/x%x xri x%x TMO:x%x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 cmdiocb->sli4_xritag, irsp->ulpTimeout);
-
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 77f9a55a3f54..d89480b9eade 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4314,6 +4314,12 @@ struct wqe_common {
 #define wqe_rcvoxid_SHIFT     16
 #define wqe_rcvoxid_MASK      0x0000FFFF
 #define wqe_rcvoxid_WORD      word9
+#define wqe_sof_SHIFT         24
+#define wqe_sof_MASK          0x000000FF
+#define wqe_sof_WORD          word9
+#define wqe_eof_SHIFT         16
+#define wqe_eof_MASK          0x000000FF
+#define wqe_eof_WORD          word9
 	uint32_t word10;
 #define wqe_ebde_cnt_SHIFT    0
 #define wqe_ebde_cnt_MASK     0x0000000f
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index efa602592728..6e8b03f38fac 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9352,11 +9352,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		memset(wqe, 0, sizeof(union lpfc_wqe128));
 	/* Some of the fields are in the right position already */
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
-	if (iocbq->iocb.ulpCommand != CMD_SEND_FRAME) {
-		/* The ct field has moved so reset */
-		wqe->generic.wqe_com.word7 = 0;
-		wqe->generic.wqe_com.word10 = 0;
-	}
+	/* The ct field has moved so reset */
+	wqe->generic.wqe_com.word7 = 0;
+	wqe->generic.wqe_com.word10 = 0;
 
 	abort_tag = (uint32_t) iocbq->iotag;
 	xritag = iocbq->sli4_xritag;
@@ -9862,6 +9860,15 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 		break;
 	case CMD_SEND_FRAME:
+		bf_set(wqe_cmnd, &wqe->generic.wqe_com, CMD_SEND_FRAME);
+		bf_set(wqe_sof, &wqe->generic.wqe_com, 0x2E); /* SOF byte */
+		bf_set(wqe_eof, &wqe->generic.wqe_com, 0x41); /* EOF byte */
+		bf_set(wqe_lenloc, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_xbl, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_xc, &wqe->generic.wqe_com, 1);
+		bf_set(wqe_cmd_type, &wqe->generic.wqe_com, 0xA);
+		bf_set(wqe_cqid, &wqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
 		bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
 		bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
 		return 0;
@@ -16940,6 +16947,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	struct fc_vft_header *fc_vft_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
+#define FC_RCTL_MDS_DIAGS	0xF4
+
 	switch (fc_hdr->fh_r_ctl) {
 	case FC_RCTL_DD_UNCAT:		/* uncategorized information */
 	case FC_RCTL_DD_SOL_DATA:	/* solicited data */
@@ -17950,6 +17959,17 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		fcfi = bf_get(lpfc_rcqe_fcf_id,
 			      &dmabuf->cq_event.cqe.rcqe_cmpl);
 
+	if (fc_hdr->fh_r_ctl == 0xF4 && fc_hdr->fh_type == 0xFF) {
+		vport = phba->pport;
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2023 MDS Loopback %d bytes\n",
+				bf_get(lpfc_rcqe_length,
+				       &dmabuf->cq_event.cqe.rcqe_cmpl));
+		/* Handle MDS Loopback frames */
+		lpfc_sli4_handle_mds_loopback(vport, dmabuf);
+		return;
+	}
+
 	/* d_id this frame is directed to */
 	did = sli4_did_from_fc_hdr(fc_hdr);
 
-- 
2.13.7

