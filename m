Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49786C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjGLRyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjGLRxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:53 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE873212D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-676cc97ca74so1647762b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184428; x=1689789228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lkcn6jjamEII+0zvdwv69Z5HuW6ijaZMDO9tv3a3e48=;
        b=aRxF8cDA1xBwUHyoOfeBT2S2Hdhk0jiwG6M7zR6WqPaCecviDeB+EngoP1jxP4bbiO
         OXLBwlUyZnzXwH+YzKYmyFuSgjgRjjwEQYJ1RVKM3zdCbjoIT3WBcbrhielXQdjc0BaY
         LZdnbW9tTWtroqW0oipyzanz/CquJefqLhKRW6qRpCcFsC6T7Vd/Sge3oSozmucb+aPi
         XR3TniLaCF0O3sj2x8ThttXyjKHlM/man0mLs3iK8EJH/af6h8hkJ4RMYYMXaVDyO+o4
         DpFiZEBnesHic4Ywi06vyB4ngUdXACDtM9CZSTG5sf+4NBoXCoC2W3X/1I3RV99HVWRL
         fwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184428; x=1689789228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lkcn6jjamEII+0zvdwv69Z5HuW6ijaZMDO9tv3a3e48=;
        b=ek4z5nspiVHnu9Xhn/XexN51mKWx6gcpjYaMchrj/+TliVq5SPP4al7DU1LvzQFSTS
         kSQS33OwR2z1jISksyiXb+YteNiP15hOEBWGVGy+b9z6pFA3n/VD0MfmQSAC5Is5Bb8U
         9RtFu4XGQSdACSmh90u0NQ2n9C1tOeJpn5kpBqrPSOdZVpVn9rgrBjd3K0CIHzbs0Cbz
         /VnRdVYcOGXXfbEqlKW1EnsguooZepPpbGRpFn0YxzeDsK2Fz/eCLJdi64u/CK1mcOlx
         CcG987/FUGdsrnStB9igR9mO7wMxyLd6ONn5UrHEWEo4UlfsuhVdcKUIVaBYyaKHdiRa
         ZFtA==
X-Gm-Message-State: ABy/qLYOePZFx+FcxHTPVvVU2hF3ZBYmhCG3x0c+n+6/1qxucLztFRIa
        dJLgJ6NX7fXp045aK2KPEJt5JFCd0XA=
X-Google-Smtp-Source: APBJJlHHgP5fq+6VWt503CXNLrliWFSpNH/LJCphw40G1bGWB5iupqvbik2xZxX7nTm1skGqno8Vcw==
X-Received: by 2002:a17:902:d483:b0:1b8:95fc:cfe with SMTP id c3-20020a170902d48300b001b895fc0cfemr54316plg.3.1689184428069;
        Wed, 12 Jul 2023 10:53:48 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:47 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/12] lpfc: Clean up SLI-4 sysfs resource reporting
Date:   Wed, 12 Jul 2023 11:05:20 -0700
Message-Id: <20230712180522.112722-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, we have dated logic to work around the differences between
SLI-4 and SLI-3 resource reporting through sysfs.

Leave the SLI-3 path untouched, but for SLI4 path, retrieve resource values
from the phba->sli4_hba->max_cfg_param structure.  Max values are populated
during ACQE events right after READ_CONFIG mbox cmd is sent.  Instead of
the dated subtraction logic, used resource calculation is directly fed into
sysfs for display.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 136 +++++++++++++++++++++++++---------
 1 file changed, 101 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 21c7ecd3ede5..b1c9107d3408 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2127,11 +2127,12 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mrpi, uint32_t *arpi,
 		  uint32_t *mvpi, uint32_t *avpi)
 {
-	struct lpfc_mbx_read_config *rd_config;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
 	int rc = 0;
-	uint32_t max_vpi;
+	struct lpfc_sli4_hba *sli4_hba;
+	struct lpfc_max_cfg_param *max_cfg_param;
+	u16 rsrc_ext_cnt, rsrc_ext_size, max_vpi;
 
 	/*
 	 * prevent udev from issuing mailbox commands until the port is
@@ -2167,31 +2168,65 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	}
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		rd_config = &pmboxq->u.mqe.un.rd_config;
-		if (mrpi)
-			*mrpi = bf_get(lpfc_mbx_rd_conf_rpi_count, rd_config);
-		if (arpi)
-			*arpi = bf_get(lpfc_mbx_rd_conf_rpi_count, rd_config) -
-					phba->sli4_hba.max_cfg_param.rpi_used;
-		if (mxri)
-			*mxri = bf_get(lpfc_mbx_rd_conf_xri_count, rd_config);
-		if (axri)
-			*axri = bf_get(lpfc_mbx_rd_conf_xri_count, rd_config) -
-					phba->sli4_hba.max_cfg_param.xri_used;
+		sli4_hba = &phba->sli4_hba;
+		max_cfg_param = &sli4_hba->max_cfg_param;
+
+		/* Normally, extents are not used */
+		if (!phba->sli4_hba.extents_in_use) {
+			if (mrpi)
+				*mrpi = max_cfg_param->max_rpi;
+			if (mxri)
+				*mxri = max_cfg_param->max_xri;
+			if (mvpi) {
+				max_vpi = max_cfg_param->max_vpi;
+
+				/* Limit the max we support */
+				if (max_vpi > LPFC_MAX_VPI)
+					max_vpi = LPFC_MAX_VPI;
+				*mvpi = max_vpi;
+			}
+		} else { /* Extents in use */
+			if (mrpi) {
+				if (lpfc_sli4_get_avail_extnt_rsrc(phba,
+								   LPFC_RSC_TYPE_FCOE_RPI,
+								   &rsrc_ext_cnt,
+								   &rsrc_ext_size)) {
+					rc = 0;
+					goto free_pmboxq;
+				}
+
+				*mrpi = rsrc_ext_cnt * rsrc_ext_size;
+			}
 
-		/* Account for differences with SLI-3.  Get vpi count from
-		 * mailbox data and subtract one for max vpi value.
-		 */
-		max_vpi = (bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) > 0) ?
-			(bf_get(lpfc_mbx_rd_conf_vpi_count, rd_config) - 1) : 0;
+			if (mxri) {
+				if (lpfc_sli4_get_avail_extnt_rsrc(phba,
+								   LPFC_RSC_TYPE_FCOE_XRI,
+								   &rsrc_ext_cnt,
+								   &rsrc_ext_size)) {
+					rc = 0;
+					goto free_pmboxq;
+				}
 
-		/* Limit the max we support */
-		if (max_vpi > LPFC_MAX_VPI)
-			max_vpi = LPFC_MAX_VPI;
-		if (mvpi)
-			*mvpi = max_vpi;
-		if (avpi)
-			*avpi = max_vpi - phba->sli4_hba.max_cfg_param.vpi_used;
+				*mxri = rsrc_ext_cnt * rsrc_ext_size;
+			}
+
+			if (mvpi) {
+				if (lpfc_sli4_get_avail_extnt_rsrc(phba,
+								   LPFC_RSC_TYPE_FCOE_VPI,
+								   &rsrc_ext_cnt,
+								   &rsrc_ext_size)) {
+					rc = 0;
+					goto free_pmboxq;
+				}
+
+				max_vpi = rsrc_ext_cnt * rsrc_ext_size;
+
+				/* Limit the max we support */
+				if (max_vpi > LPFC_MAX_VPI)
+					max_vpi = LPFC_MAX_VPI;
+				*mvpi = max_vpi;
+			}
+		}
 	} else {
 		if (mrpi)
 			*mrpi = pmb->un.varRdConfig.max_rpi;
@@ -2212,8 +2247,12 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		}
 	}
 
+	/* Success */
+	rc = 1;
+
+free_pmboxq:
 	mempool_free(pmboxq, phba->mbox_mem_pool);
-	return 1;
+	return rc;
 }
 
 /**
@@ -2265,10 +2304,19 @@ lpfc_used_rpi_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	uint32_t cnt, acnt;
+	struct lpfc_sli4_hba *sli4_hba;
+	struct lpfc_max_cfg_param *max_cfg_param;
+	u32 cnt = 0, acnt = 0;
 
-	if (lpfc_get_hba_info(phba, NULL, NULL, &cnt, &acnt, NULL, NULL))
-		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		sli4_hba = &phba->sli4_hba;
+		max_cfg_param = &sli4_hba->max_cfg_param;
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 max_cfg_param->rpi_used);
+	} else {
+		if (lpfc_get_hba_info(phba, NULL, NULL, &cnt, &acnt, NULL, NULL))
+			return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	}
 	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
@@ -2321,10 +2369,19 @@ lpfc_used_xri_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	uint32_t cnt, acnt;
+	struct lpfc_sli4_hba *sli4_hba;
+	struct lpfc_max_cfg_param *max_cfg_param;
+	u32 cnt = 0, acnt = 0;
 
-	if (lpfc_get_hba_info(phba, &cnt, &acnt, NULL, NULL, NULL, NULL))
-		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		sli4_hba = &phba->sli4_hba;
+		max_cfg_param = &sli4_hba->max_cfg_param;
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 max_cfg_param->xri_used);
+	} else {
+		if (lpfc_get_hba_info(phba, &cnt, &acnt, NULL, NULL, NULL, NULL))
+			return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	}
 	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
@@ -2377,10 +2434,19 @@ lpfc_used_vpi_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	uint32_t cnt, acnt;
+	struct lpfc_sli4_hba *sli4_hba;
+	struct lpfc_max_cfg_param *max_cfg_param;
+	u32 cnt = 0, acnt = 0;
 
-	if (lpfc_get_hba_info(phba, NULL, NULL, NULL, NULL, &cnt, &acnt))
-		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		sli4_hba = &phba->sli4_hba;
+		max_cfg_param = &sli4_hba->max_cfg_param;
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 max_cfg_param->vpi_used);
+	} else {
+		if (lpfc_get_hba_info(phba, NULL, NULL, NULL, NULL, &cnt, &acnt))
+			return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	}
 	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
-- 
2.38.0

