Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1672C433F1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8F522BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DtSHceJ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgHCVCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgHCVCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:44 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E05C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c80so813018wme.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9ofHR51ml//KjZizQSlqbR9d+agIKi1dvjWF0o4qTs=;
        b=DtSHceJ7fxNrqK9iLcjrSRvAUohzKxJR8vEvsVWgEEjmJ554v8SfKq3hBO9kgqa88N
         DA+DHNuG9Bio0N71QTqIOf3fJks6BroDIhEGniktAEWV7NtHCIWXonfBqAOJmHnpajCh
         jlJoYUCO3NzQDV0iy7mUdba8dgP53Y0SXkvfWiIksR4xlrj1HXrBVKJPLEEL8iVFfUn5
         OfJZtv5ffSxUbsoWK6tFGm0ADEpBzzPqVMh97J/GibFjULypVC7tvM2bzthVRC+L75ew
         9WtrZZ1QmGePLgIXJyGY5P0Ou/tppQMfDdEMM4MgY7uflMzzxBQTXJgJnJtl2JiPciCO
         U4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9ofHR51ml//KjZizQSlqbR9d+agIKi1dvjWF0o4qTs=;
        b=CAIwu+3IPFxdhfAJEkl5IuPQ28vQqKRtkkB2/bkm0MX9TvSKAwwjeB858JhHLJvcK6
         +t4Emnn8daQHwXEYZufYFCr1dpu3SiphvUxAWTHedSj06c3ZvwGM5M3tBS5sIJhnvZgz
         ePJMKEFHKALgBXRB9Th31n1r5JXz3QcF3kjVL8zvwpxSaRiNARXcR7hn0o+kNHPwz59s
         a+bQl1px0Nj70uy8N8Ltc1vUNvvRE2gjjb3wY9BItvShuaa1oHBy9IKbsxNcsu3GEcc9
         c6fv4YKV9Ybcii3RshHorDyAcQFP1D+isUe5R9peBUYI+MvD+Y7BZfNrmpFqCy2TNvXv
         bwag==
X-Gm-Message-State: AOAM533YzEzWAx8e4CmyefdCQIzG8BJWLkMkfFlKRELJ9MYAlOSDHQQC
        GeNH4BzbQlMyfviEZUTsjr7HO8ZF
X-Google-Smtp-Source: ABdhPJwsg8q0H3gWV3LmVyf5qIHjfiea1wKb+DX+XdsWjXVj/80PjKQfagSA7GXiY7VzAyoQuzNZbQ==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr920775wmg.34.1596488562899;
        Mon, 03 Aug 2020 14:02:42 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 3/8] lpfc: Fix RSCN timeout due to incorrect gidft counter
Date:   Mon,  3 Aug 2020 14:02:24 -0700
Message-Id: <20200803210229.23063-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In configs with a large number of initiators in the same zone (>250),
RSCN timeouts are seen when creating or deleting vports.
   lpfc 0000:07:00.1: 5:(0):0231 RSCN timeout Data: x0 x3

During RSCN processing driver issues GID_FT command to nameserver. A
counter for number of simultaneous GID_FT commands is maintained (an
unsigned value). The counter is incremented when the GID_FT is issued.
If the GID_FT command fails for some reason the driver retries the
GID_FT from the completion call back. But the counter was decremented
before the retry was issued.  When the second GID_FT completes, the
callback again tries to decrement the counter, possibly wrapping to a
very large non-zero value, which causes the RSCN cleanup code to not
execute. Thus the RSCN timeout failure.

Do not decrement the counter on a retry. Also add defensive checks to
ensure the counter is not decremented if already zero.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index dd9f2bf54edd..ef2015fad2d5 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -713,7 +713,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* This is a GID_FT completing so the gidft_inp counter was
 		 * incremented before the GID_FT was issued to the wire.
 		 */
-		vport->gidft_inp--;
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 
 		/*
 		 * Skip processing the NS response
@@ -741,11 +742,14 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				goto out;
 
 			/* CT command is being retried */
-			vport->gidft_inp--;
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_FT,
 					 vport->fc_ns_retry, type);
 			if (rc == 0)
 				goto out;
+			else { /* Unable to send NS cmd */
+				if (vport->gidft_inp)
+					vport->gidft_inp--;
+			}
 		}
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
@@ -825,7 +829,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				(uint32_t) CTrsp->ReasonCode,
 				(uint32_t) CTrsp->Explanation);
 		}
-		vport->gidft_inp--;
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 	}
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
@@ -918,7 +923,8 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* This is a GID_PT completing so the gidft_inp counter was
 		 * incremented before the GID_PT was issued to the wire.
 		 */
-		vport->gidft_inp--;
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 
 		/*
 		 * Skip processing the NS response
@@ -942,11 +948,14 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				vport->fc_ns_retry++;
 
 			/* CT command is being retried */
-			vport->gidft_inp--;
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_GID_PT,
 					 vport->fc_ns_retry, GID_PT_N_PORT);
 			if (rc == 0)
 				goto out;
+			else { /* Unable to send NS cmd */
+				if (vport->gidft_inp)
+					vport->gidft_inp--;
+			}
 		}
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
@@ -1027,7 +1036,8 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				(uint32_t)CTrsp->ReasonCode,
 				(uint32_t)CTrsp->Explanation);
 		}
-		vport->gidft_inp--;
+		if (vport->gidft_inp)
+			vport->gidft_inp--;
 	}
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-- 
2.26.2

