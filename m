Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A837C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 15:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiI0PkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiI0PjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 11:39:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19361CFB8A
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:30 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso10439817pjd.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=RIt/qxR4EAUFbxZ1RMkWtn/7tkqNw/Ddhp3wGfxncRU=;
        b=Wsp7XHabqPR9cfN47YLDb5kP/+DtTWVPXDtUDkStJwV2rn/HziBanxswpSDmdcRLKo
         Dq48tAVzMZp92d4f2AamMdyY8zGEbeQXB6tLxpaB6Y6Wy1VanyBKBfRP9VCLyZAejQ5Y
         a93f5ZK+7C25YS/LlQfWf06VDV3NKB5Luu1bvtlF6PZbg7BkbqtGZsqyim91FVKC6lEU
         8muWZi3OdBTxGXgk0JYE5D0t+53+wm9AL7EvbMtB88Dvaw6MIid+MhOhPoX9yA5NOz7c
         BbZqCnkgyhan4o2ymTMZOD6XQFYA38i8N4n3lHJDN4qromb5YDGrzMTLjyHVlIv8DDnB
         2DOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RIt/qxR4EAUFbxZ1RMkWtn/7tkqNw/Ddhp3wGfxncRU=;
        b=hdQIRszwjtNSlTgwUDARptJsu8djUCaly+IOjFaTf/KJR9Rhxrlls2u2zCGnlvtrmG
         2nMa3eBkgV1s8U7/f1O01u69ysHX4Cc7pIP6oLD9aHSD/RU2sS6LW0XIV6WYzlh9yEgg
         3BK8r5nYw+ey/RYuEI9NeZJvyq3Yh8AwvLccINnbXLOU1mwU5vM92lNnUgHQ3KiOWTNS
         MFbJeyz2n5nTnGFUA6yiwzi45iEmwzWVOBejDImDL3584ncyFvNSy6UPLhiDNwzOnSgv
         56s413GL76Qr8d3RbYTBTBNrLV/TlP2wJ/ucu+KXd9xHYHIKvuxHLwqyA5Hew4MlJViv
         2sbg==
X-Gm-Message-State: ACrzQf1zWtMC09zJKBXq+UQBCro7p8OxO6Qqb2kuGl/HmLIuEOXDXPju
        xRaCvXhtX0K+E5CLBKoesseqpw==
X-Google-Smtp-Source: AMsMyM4PN/sa9EbDRewn4uJ6KiQJHc76Hv5S3W7v3hjUMHPJa2uK3esBhbriqEzLGCbP+ZwPX9ZUzw==
X-Received: by 2002:a17:902:8214:b0:178:95c9:bd5d with SMTP id x20-20020a170902821400b0017895c9bd5dmr28462138pln.106.1664293017089;
        Tue, 27 Sep 2022 08:36:57 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79a10000000b0053639773ad8sm1933087pfj.119.2022.09.27.08.36.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 08:36:56 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     bhelgaas@google.com, ruscur@russell.cc, oohall@gmail.com,
        fancer.lancer@gmail.com, jdmason@kudzu.us, dave.jiang@intel.com,
        allenbh@gmail.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v2 5/9] PCI/AER: Unexport pci_aer_clear_nonfatal_status()
Date:   Tue, 27 Sep 2022 23:35:20 +0800
Message-Id: <20220927153524.49172-6-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
References: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since pci_aer_clear_nonfatal_status() is used only internally, move
its declaration to the PCI internal header file. Also, no one cares
about return value of pci_aer_clear_nonfatal_status(), so make it void.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/pci/pci.h      | 2 ++
 drivers/pci/pcie/aer.c | 7 ++-----
 include/linux/aer.h    | 5 -----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 785f31086313..a114175d08e4 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -684,6 +684,7 @@ void pci_aer_init(struct pci_dev *dev);
 void pci_aer_exit(struct pci_dev *dev);
 extern const struct attribute_group aer_stats_attr_group;
 void pci_aer_clear_fatal_status(struct pci_dev *dev);
+void pci_aer_clear_nonfatal_status(struct pci_dev *dev);
 int pci_aer_clear_status(struct pci_dev *dev);
 int pci_aer_raw_clear_status(struct pci_dev *dev);
 #else
@@ -691,6 +692,7 @@ static inline void pci_no_aer(void) { }
 static inline void pci_aer_init(struct pci_dev *d) { }
 static inline void pci_aer_exit(struct pci_dev *d) { }
 static inline void pci_aer_clear_fatal_status(struct pci_dev *dev) { }
+static inline void pci_aer_clear_nonfatal_status(struct pci_dev *dev) { }
 static inline int pci_aer_clear_status(struct pci_dev *dev) { return -EINVAL; }
 static inline int pci_aer_raw_clear_status(struct pci_dev *dev) { return -EINVAL; }
 #endif
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 4e637121be23..e2ebd108339d 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -251,13 +251,13 @@ int pci_disable_pcie_error_reporting(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_disable_pcie_error_reporting);
 
-int pci_aer_clear_nonfatal_status(struct pci_dev *dev)
+void pci_aer_clear_nonfatal_status(struct pci_dev *dev)
 {
 	int aer = dev->aer_cap;
 	u32 status, sev;
 
 	if (!pcie_aer_is_native(dev))
-		return -EIO;
+		return;
 
 	/* Clear status bits for ERR_NONFATAL errors only */
 	pci_read_config_dword(dev, aer + PCI_ERR_UNCOR_STATUS, &status);
@@ -265,10 +265,7 @@ int pci_aer_clear_nonfatal_status(struct pci_dev *dev)
 	status &= ~sev;
 	if (status)
 		pci_write_config_dword(dev, aer + PCI_ERR_UNCOR_STATUS, status);
-
-	return 0;
 }
-EXPORT_SYMBOL_GPL(pci_aer_clear_nonfatal_status);
 
 void pci_aer_clear_fatal_status(struct pci_dev *dev)
 {
diff --git a/include/linux/aer.h b/include/linux/aer.h
index 154690c278cb..f638ad955deb 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -44,7 +44,6 @@ struct aer_capability_regs {
 /* PCIe port driver needs this function to enable AER */
 int pci_enable_pcie_error_reporting(struct pci_dev *dev);
 int pci_disable_pcie_error_reporting(struct pci_dev *dev);
-int pci_aer_clear_nonfatal_status(struct pci_dev *dev);
 int pci_aer_clear_uncorrect_error_status(struct pci_dev *dev);
 void pci_save_aer_state(struct pci_dev *dev);
 void pci_restore_aer_state(struct pci_dev *dev);
@@ -57,10 +56,6 @@ static inline int pci_disable_pcie_error_reporting(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
-static inline int pci_aer_clear_nonfatal_status(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
 static inline int pci_aer_clear_uncorrect_error_status(struct pci_dev *dev)
 {
 	return -EINVAL;
-- 
2.30.1 (Apple Git-130)

