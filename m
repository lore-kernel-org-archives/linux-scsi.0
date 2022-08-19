Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FBCC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242900AbiHSBSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiHSBSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:18 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04625FB
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:14 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id d1so2459628qvs.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KckgxN+2d68nHx3ZmR5HkKsVpzGD9TI8MdHd1p6XvKk=;
        b=mhkZmEVN/JuKswWDw8MP1K+knuG/ddzyEhP42H5VzgLtuOIw8ScvyMhJv8PqkCKoMr
         /1Of5R/+oGIzYzC3yf6T1lWZ9o/nRyzF9zPcGGETfZLL3Pl58D48qGSMP8n1aKYAlUnj
         WNuKmyEku7bKbDEWQii0Gn/5Doy9CKaRaupIVCxL4phvDpssY+Hp32tsfS78rVmmyFOu
         aVcJFMsWxtUb0aQbVTIo8YlCvp+MSncXzOQAQZBPXE1kfAygiig7HCnQv3XzwRvolFDz
         UWhByLudBgDC+k//akyjqItdTwgosNv75tlT4iO6P/FCQGL5IslDfXaqOon+OedB3Jew
         fbXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KckgxN+2d68nHx3ZmR5HkKsVpzGD9TI8MdHd1p6XvKk=;
        b=p/S3t88f/OC1vFV6EMYs4jsX9G2s1i3lpM0KDCKwuCHHXF7AC6KdvtfzXXIn5TvUR+
         CYzGRdpV6QWlY9JFrTotGavZhUcnJjmhW4P6tad8bs2MXNBOaffLUxUSv5+EjAJl7kSq
         DGcsJW8x1cGN0NAFDAbNiaRJFa5M6GHFKyAMfUlaXOB9uWMt2PwyaAa8CDrzLodyKzWi
         yCR5EAnZMkhAA0Y07OK7G/wcguV2G9IOD0naqsmdK9IWKpKeP1vmZjq6rt1nHbgkvJF4
         9qcAc5xksN6HB9jmWDbj9VJUhAax884X3xlDAcRBSGQWavbDJ6Wm7OX40Tbbcnk+hhuT
         OSWw==
X-Gm-Message-State: ACgBeo36QmlHeoDsrTvIR76cgcwU0m67gMR9wXHMZ3forVPi/M3QsLFB
        Kjw8djqcdUzXLIreUGflK2n2vYK9OHE=
X-Google-Smtp-Source: AA6agR6wG7fvN9C6sOe056OV8lfM+lT/vAQa2SNqs77TLwL1ors4ThZ9QQmsPXL+3GZgrgbQDTRQ4Q==
X-Received: by 2002:a0c:a99d:0:b0:474:7389:858b with SMTP id a29-20020a0ca99d000000b004747389858bmr4718167qvb.100.1660871893570;
        Thu, 18 Aug 2022 18:18:13 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/7] lpfc: Add warning notification period to CMF_SYNC_WQE
Date:   Thu, 18 Aug 2022 18:17:33 -0700
Message-Id: <20220819011736.14141-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add capability to specify warning notification period to help firmware
adjust to congestion accordingly.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h     | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h | 4 ++++
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 11a05f2c88c4..71e6dae5eae8 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1564,7 +1564,7 @@ struct lpfc_hba {
 		/* cgn_reg_signal and cgn_init_reg_signal use
 		 * enum fc_edc_cg_signal_cap_types
 		 */
-	u16 cgn_fpin_frequency;
+	u16 cgn_fpin_frequency;		/* In units of msecs */
 #define LPFC_FPIN_INIT_FREQ	0xffff
 	u32 cgn_sig_freq;
 	u32 cgn_acqe_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 4527fef23ae7..ca49679e87b9 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -738,6 +738,7 @@ struct lpfc_register {
 #define lpfc_sliport_eqdelay_id_WORD	word0
 #define LPFC_SEC_TO_USEC		1000000
 #define LPFC_SEC_TO_MSEC		1000
+#define LPFC_MSECS_TO_SECS(msecs) ((msecs) / 1000)
 
 /* The following Registers apply to SLI4 if_type 0 UCNAs. They typically
  * reside in BAR 2.
@@ -4798,6 +4799,9 @@ struct cmf_sync_wqe {
 #define cmf_sync_cqid_WORD	word11
 	uint32_t read_bytes;
 	uint32_t word13;
+#define cmf_sync_period_SHIFT	16
+#define cmf_sync_period_MASK	0x0000ffff
+#define cmf_sync_period_WORD	word13
 	uint32_t word14;
 	uint32_t word15;
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 55c9eb39ea19..0f2b6ac56baf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1916,6 +1916,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	unsigned long iflags;
 	u32 ret_val;
 	u32 atot, wtot, max;
+	u16 warn_sync_period = 0;
 
 	/* First address any alarm / warning activity */
 	atot = atomic_xchg(&phba->cgn_sync_alarm_cnt, 0);
@@ -1970,10 +1971,14 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 				lpfc_acqe_cgn_frequency;
 			bf_set(cmf_sync_wsigmax, &wqe->cmf_sync, max);
 			bf_set(cmf_sync_wsigcnt, &wqe->cmf_sync, wtot);
+			warn_sync_period = lpfc_acqe_cgn_frequency;
 		} else {
 			/* We hit a FPIN warning condition */
 			bf_set(cmf_sync_wfpinmax, &wqe->cmf_sync, 1);
 			bf_set(cmf_sync_wfpincnt, &wqe->cmf_sync, 1);
+			if (phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ)
+				warn_sync_period =
+				LPFC_MSECS_TO_SECS(phba->cgn_fpin_frequency);
 		}
 	}
 
@@ -1989,6 +1994,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	bf_set(cmf_sync_reqtag, &wqe->cmf_sync, sync_buf->iotag);
 
 	bf_set(cmf_sync_qosd, &wqe->cmf_sync, 1);
+	bf_set(cmf_sync_period, &wqe->cmf_sync, warn_sync_period);
 
 	bf_set(cmf_sync_cmd_type, &wqe->cmf_sync, CMF_SYNC_COMMAND);
 	bf_set(cmf_sync_wqec, &wqe->cmf_sync, 1);
-- 
2.26.2

