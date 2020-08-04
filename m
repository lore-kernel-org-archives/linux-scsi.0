Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1AAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A7F206DA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hAswiq2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgHDJHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgHDJHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:51 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7031C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:50 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id j10so11972580qvo.13
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uez4k0J+TW681L8RwxiP223QcUomCz+eLUn40FJl6vw=;
        b=hAswiq2j66jXBq1ordgGgMZyvGzvTucFY7YVF61aYohV5bkjBzW06Qh95WcQ2TKmcP
         NLvWR1BmQCcUzT+pUGQQSBIf+41Lu7I07+NSCkPgDtX9qOmZGyhBcCVbWutiOqPGbKO5
         yeqXPkJuEpV2MP2oVLtGGMy+z773rH/yI4OZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uez4k0J+TW681L8RwxiP223QcUomCz+eLUn40FJl6vw=;
        b=RVBXoPONqP9ozafXqrJIuMsz0NHdxgtmM/kFny912kQcv6tb0W0DpGvk8NEqtPjm/D
         Gr47n5+U/0yGaZX/bmhoUhaU+tkPkVQ3PJbBDCYfUlUhziKPmQ5ojFT6+A3jSQR9LoYv
         GT27a1GGbbC6Dr3EHRct6MVkTL+sYH8r2+ECZq/4jUYm07llbwSq9KtuPXMMBlGM3NlU
         214q/6qf2DcjGN8AYo989euLz7tUoQkBUFNr55hL/ZMUAJArzJ5wqLz1tM60o3Lz0CQJ
         ICQiC5PMVgN0w7/MzUIzQAJXUcZNZeaiKdQr6mCK+WaopkYkHcQwfhtImJorSx6XHY8E
         nnFA==
X-Gm-Message-State: AOAM533yoCqTfQ2+GA6MIFMFjZlz+HMvkSeH9szOr+Xyr/qelo6CgzqT
        vioVMbIgOn+sV6lSzCAuWaC0+4lEOtI=
X-Google-Smtp-Source: ABdhPJwCnVxB4jCV+FZ1+bo45ArPaNpzxKvy6C2CXuYvgJuPmG9ce1zr4OaLw9G1G7tfdt2lzei0WA==
X-Received: by 2002:ad4:44f2:: with SMTP id p18mr20840188qvt.137.1596532070024;
        Tue, 04 Aug 2020 02:07:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:49 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 13/16] lpfc: vmid: Appends the vmid in the wqe before sending request
Date:   Tue,  4 Aug 2020 07:43:13 +0530
Message-Id: <1596507196-27417-14-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch adds the vmid in wqe before sending out the request.
The type of vmid depends on the configured type and is checked before
being appended.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 56 +++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bf006ec4ceb1..c5d6c1a927fb 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3724,7 +3724,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		if (irsp->ulpStatus) {
 			/* Rsp ring <ringno> error: IOCB */
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0328 Rsp Ring %d error: "
 					"IOCB Data: "
 					"x%x x%x x%x x%x "
@@ -9625,6 +9625,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 				*pcmd == ELS_CMD_RSCN_XMT ||
 				*pcmd == ELS_CMD_FDISC ||
 				*pcmd == ELS_CMD_LOGO ||
+				*pcmd == ELS_CMD_QFPA ||
+				*pcmd == ELS_CMD_UVEM ||
 				*pcmd == ELS_CMD_PLOGI)) {
 				bf_set(els_req64_sp, &wqe->els_req, 1);
 				bf_set(els_req64_sid, &wqe->els_req,
@@ -9756,6 +9758,24 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			ptr = &wqe->words[22];
 			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
 		}
+
+		/* add the VMID tags as per the switch */
+		if (iocbq->iocb_flag & LPFC_IO_VMID) {
+			union lpfc_wqe128 *wqe128;
+
+			if (phba->pport->vmid_priority_tagging) {
+				bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
+				bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
+				       (iocbq->vmid_tag.cs_ctl_vmid));
+				/* Bit 0 must be 0 */
+			} else {
+				wqe128 = (union lpfc_wqe128 *)wqe;
+				bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
+				bf_set(wqe_wqes, &wqe128->fcp_iwrite.wqe_com,
+				       1);
+				wqe128->words[31] = iocbq->vmid_tag.app_id;
+			}
+		}
 		break;
 	case CMD_FCP_IREAD64_CR:
 		/* word3 iocb=iotag wqe=payload_offset_len */
@@ -9820,6 +9840,23 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			ptr = &wqe->words[22];
 			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
 		}
+
+		/* add the VMID tags as per the switch */
+		if (iocbq->iocb_flag & LPFC_IO_VMID) {
+			union lpfc_wqe128 *wqe128;
+
+			if (phba->pport->vmid_priority_tagging) {
+				bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
+				bf_set(wqe_ccp, &wqe->fcp_iread.wqe_com,
+				       (iocbq->vmid_tag.cs_ctl_vmid));
+				/* Bit 0 must be 0 */
+			} else {
+				wqe128 = (union lpfc_wqe128 *)wqe;
+				bf_set(wqe_appid, &wqe->fcp_iread.wqe_com, 1);
+				bf_set(wqe_wqes, &wqe128->fcp_iread.wqe_com, 1);
+				wqe128->words[31] = iocbq->vmid_tag.app_id;
+			}
+		}
 		break;
 	case CMD_FCP_ICMND64_CR:
 		/* word3 iocb=iotag wqe=payload_offset_len */
@@ -9877,6 +9914,23 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 			ptr = &wqe->words[22];
 			memcpy(ptr, fcp_cmnd, sizeof(struct fcp_cmnd));
 		}
+
+		/* add the VMID tags as per the switch */
+		if (iocbq->iocb_flag & LPFC_IO_VMID) {
+			union lpfc_wqe128 *wqe128;
+
+			if (phba->pport->vmid_priority_tagging) {
+				bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
+				bf_set(wqe_ccp, &wqe->fcp_icmd.wqe_com,
+				       (iocbq->vmid_tag.cs_ctl_vmid));
+				/* Bit 0 must be 0 */
+			} else {
+				wqe128 = (union lpfc_wqe128 *)wqe;
+				bf_set(wqe_appid, &wqe->fcp_icmd.wqe_com, 1);
+				bf_set(wqe_wqes, &wqe128->fcp_icmd.wqe_com, 1);
+				wqe128->words[31] = iocbq->vmid_tag.app_id;
+			}
+		}
 		break;
 	case CMD_GEN_REQUEST64_CR:
 		/* For this command calculate the xmit length of the
-- 
2.18.2

