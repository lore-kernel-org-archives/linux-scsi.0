Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B87C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 18:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1326D60F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 18:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhI0ShJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhI0ShI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 14:37:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5869C061575
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 11:35:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so16027622pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 11:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYzDw/UeJWpkH0j6HapD4cjz7z9HfTDcte9HZvpQmo4=;
        b=SCt5FGWYnG0UchiDTRWOWjCCzfS2hjwVf2yEbc7r2TF6jmPJqsCKD6Atn8JcMftGTz
         eDBFsxfgwRb6b2pCiQmrLLWwTKiPcMd2aVxEuCDG64PKsYSc5owFC14e6ThJfrw8OkHB
         oSmrjiWu2EmjfZjsVdWnQyJGw1Lvt8Ppbch8vmOKGb6o2Kl3Lr8Ag5Y+FI2skPf7I0+v
         CLr89ZwDDSRsKCW+KYcs9yYcX36tiSjEZT/YhFUo4M9gvvmwusbmKqtGyjneYI1iaRLj
         m9dDsxuVxIuCVb1xW1zK5tvY3ICcxjKsQ0z2K/E9HyNCpzLpP9yHOEl8/lY1VXsSCzlQ
         6MZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYzDw/UeJWpkH0j6HapD4cjz7z9HfTDcte9HZvpQmo4=;
        b=fQDKinViRJBMmyJ0AFZCsr5T65kjVpQ+rMVWT06OWod44sajmNRUKucrKl7jeuQrpg
         RMqFZTrdAJXbVqgy7B1IsOYNoSPdXb+QHtMh3IYUfWEBoy4Z+I47dacQ4hj0fJR+bWaf
         0cBMBkEUM+j3THytUjtpkAdtQrDoZZWOEIfpRHSUh0kLc7a2U+Kug9Vb8bmZR8gDGzIm
         xZg1I6eirbqIs3Yt3opURdPltSxOxqKYbeTzMaKmivf3VIKCZjY6EOx/CCblRkEM+E8K
         poDp5MaDriC79k2gYxrOJAwvCnFkojh3uSClQ6Iv4236ZDfU9SiTfQnOxE7OHIlAj6uW
         VYwQ==
X-Gm-Message-State: AOAM533jNpwB4MLUn+CaIJ1l5k8Tl2sC/qvN9HWvHfC9Pv+9BwwOiBQJ
        9fScaqgr8dZP56XSSXoTJe0E2bXRiprkZUlg
X-Google-Smtp-Source: ABdhPJyHndfTXEvZ1tig2bUsPW0TTUqh4/gBv5FiSYQUePqxHZ0wJwfdJ6G8ckPWZaz1GWcL/cvREw==
X-Received: by 2002:a17:902:f693:b0:13e:161a:f172 with SMTP id l19-20020a170902f69300b0013e161af172mr1374312plg.30.1632767730362;
        Mon, 27 Sep 2021 11:35:30 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v1sm8338500pfn.174.2021.09.27.11.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:35:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: [PATCH] lpfc: Add support for optional pldv handling
Date:   Mon, 27 Sep 2021 11:35:18 -0700
Message-Id: <20210927183518.22130-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At adapter attachment or SLI port initialization, read the SLIPORT_STATUS
register to check for pldv_enable. If found, the driver will perform a
PCIe configuration space write when attaching to an SLI port instance
that is an LPe32000 series adapter.

Co-developed-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  4 ++++
 drivers/scsi/lpfc/lpfc_init.c | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 79a4872c2edb..143b73f71333 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -673,6 +673,10 @@ struct lpfc_register {
 #define lpfc_sliport_status_rdy_SHIFT	23
 #define lpfc_sliport_status_rdy_MASK	0x1
 #define lpfc_sliport_status_rdy_WORD	word0
+#define lpfc_sliport_status_pldv_SHIFT	0
+#define lpfc_sliport_status_pldv_MASK	0x1
+#define lpfc_sliport_status_pldv_WORD	word0
+#define CFG_PLD				0x3C
 #define MAX_IF_TYPE_2_RESETS		6
 
 #define LPFC_CTL_PORT_CTL_OFFSET	0x408
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d0e64233d273..bd2bc88e2ae9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -68,6 +68,7 @@
 static enum cpuhp_state lpfc_cpuhp_state;
 /* Used when mapping IRQ vectors in a driver centric manner */
 static uint32_t lpfc_present_cpu;
+static bool lpfc_pldv_detect;
 
 static void __lpfc_cpuhp_remove(struct lpfc_hba *phba);
 static void lpfc_cpuhp_remove(struct lpfc_hba *phba);
@@ -9359,7 +9360,15 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 					phba->work_status[0],
 					phba->work_status[1]);
 				port_error = -ENODEV;
+				break;
 			}
+
+			if (lpfc_pldv_detect &&
+			    bf_get(lpfc_sli_intf_sli_family,
+				   &phba->sli4_hba.sli_intf) ==
+					LPFC_SLI_INTF_FAMILY_G6)
+				pci_write_config_byte(phba->pcidev,
+						      LPFC_SLI_INTF, CFG_PLD);
 			break;
 		case LPFC_SLI_INTF_IF_TYPE_1:
 		default:
@@ -11567,6 +11576,9 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 			goto out;
 		}
 
+		if (bf_get(lpfc_sliport_status_pldv, &reg_data))
+			lpfc_pldv_detect = true;
+
 		if (!port_reset) {
 			/*
 			 * Reset the port now
@@ -15559,6 +15571,8 @@ lpfc_init(void)
 	/* Initialize in case vector mapping is needed */
 	lpfc_present_cpu = num_present_cpus();
 
+	lpfc_pldv_detect = false;
+
 	error = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 					"lpfc/sli4:online",
 					lpfc_cpu_online, lpfc_cpu_offline);
-- 
2.26.2

