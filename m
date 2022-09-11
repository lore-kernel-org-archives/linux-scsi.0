Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BACAECAAD3
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiIKWPf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiIKWPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:18 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DD214009
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:17 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id l5so5492348qvs.13
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jXfhzgPPGWXpm39Slb4Wh2gd2XqGL+p89QBNFC0XBYc=;
        b=gPN0me67nce2eoAdrxZFn3zL1yY/EsxSrNzusGHpAslpRbOmmpW3T7JA/DuxDDbR/9
         B5/lnMrurhR3NuXziJAnVRvZWya/twYxTMUUNAsUGusd8ZN5LnjrwhmgVrRsBtnnv3ED
         Xrt554LnoT1L5JlwTLXMNQkqQBbacMOgh7a7E1cbc0BODDtMhJdDAedKWYNNZ1HWg5t7
         3uunag8Ru/BFMA9NMIkxXnTABtrt77xs0Nl4g+pstRANTev4KYhD/75shjQT6Ef8k8s6
         uotW7IP1G6Kw44O8OF4FOVDHr1WFqPQhEFdRtmZ/pKf+N/iV3PdPkdepKnnNhcAziMFZ
         6Fuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jXfhzgPPGWXpm39Slb4Wh2gd2XqGL+p89QBNFC0XBYc=;
        b=Q6JmsPePpAraOPoa3ErlcLwOLx02XXitoSXHyUuQbIX+nfF3UQfub4Y3XMLtvjJqhe
         On17sRQ65301D2awnsGZRkogi7uvt8TeRUhIlVoCENSDG3//SYfFsA6xa4rNEVG8xd4E
         bhgi9mUBJSG3bj4OdRQajTO2CN4UhOowq0WYciE8rGSVp2laBAvXBAjPYp+W2B9JYE6L
         0pgLYWN7N3CFT4fnXWuhi5IdbiAbtscguDYQiba1UQQF1j2PcM46ZQK50SbQD7R5wEQe
         9SUW8XgYeBRU5bF5ReTCgEd3muSkoag6oTOe0zF3I2HSoWZASxfPyvQY92jZyY19ahuD
         sfCw==
X-Gm-Message-State: ACgBeo3zg98waZ8pCXWy318PuVcG9hFF0uadzO9l4eSLi96QyOmkcJbC
        m3Jn3qFnTU/djxWGYl6Cg11F9GvRY1Q=
X-Google-Smtp-Source: AA6agR6ywmULh4n0xaKzg+K6fLQgVu+i54uarywsa8Lhb96Zle/2nGKjeBaNpbJzzFeUUbOGBDxL+Q==
X-Received: by 2002:a05:6214:e45:b0:4a9:ccab:b306 with SMTP id o5-20020a0562140e4500b004a9ccabb306mr20209163qvc.6.1662934516825;
        Sun, 11 Sep 2022 15:15:16 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/13] lpfc: Update congestion mode logging for Emulex San Manager application
Date:   Sun, 11 Sep 2022 15:14:59 -0700
Message-Id: <20220911221505.117655-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If there is a congestion or automated congestion response mode change,
then log the reported change to kmsg.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0a4a82f5df5c..b170e9e9f167 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7038,6 +7038,12 @@ lpfc_cgn_params_val(struct lpfc_hba *phba, struct lpfc_cgn_param *p_cfg_param)
 	spin_unlock_irq(&phba->hbalock);
 }
 
+static const char * const lpfc_cmf_mode_to_str[] = {
+	"OFF",
+	"MANAGED",
+	"MONITOR",
+};
+
 /**
  * lpfc_cgn_params_parse - Process a FW cong parm change event
  * @phba: pointer to lpfc hba data structure.
@@ -7057,6 +7063,7 @@ lpfc_cgn_params_parse(struct lpfc_hba *phba,
 {
 	struct lpfc_cgn_info *cp;
 	uint32_t crc, oldmode;
+	char acr_string[4] = {0};
 
 	/* Make sure the FW has encoded the correct magic number to
 	 * validate the congestion parameter in FW memory.
@@ -7133,9 +7140,6 @@ lpfc_cgn_params_parse(struct lpfc_hba *phba,
 					lpfc_issue_els_edc(phba->pport, 0);
 				break;
 			case LPFC_CFG_MONITOR:
-				lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
-						"4661 Switch from MANAGED to "
-						"`MONITOR mode\n");
 				phba->cmf_max_bytes_per_interval =
 					phba->cmf_link_byte_count;
 
@@ -7154,14 +7158,26 @@ lpfc_cgn_params_parse(struct lpfc_hba *phba,
 					lpfc_issue_els_edc(phba->pport, 0);
 				break;
 			case LPFC_CFG_MANAGED:
-				lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
-						"4662 Switch from MONITOR to "
-						"MANAGED mode\n");
 				lpfc_cmf_signal_init(phba);
 				break;
 			}
 			break;
 		}
+		if (oldmode != LPFC_CFG_OFF ||
+		    oldmode != phba->cgn_p.cgn_param_mode) {
+			if (phba->cgn_p.cgn_param_mode == LPFC_CFG_MANAGED)
+				scnprintf(acr_string, sizeof(acr_string), "%u",
+					  phba->cgn_p.cgn_param_level0);
+			else
+				scnprintf(acr_string, sizeof(acr_string), "NA");
+
+			dev_info(&phba->pcidev->dev, "%d: "
+				 "4663 CMF: Mode %s acr %s\n",
+				 phba->brd_no,
+				 lpfc_cmf_mode_to_str
+				 [phba->cgn_p.cgn_param_mode],
+				 acr_string);
+		}
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT | LOG_INIT,
 				"4669 FW cgn parm buf wrong magic 0x%x "
-- 
2.35.3

