Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004BDC32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 11:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiI1LCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 07:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiI1LBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 07:01:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244CBE5F9B
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:00:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d24so11481514pls.4
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=RIt/qxR4EAUFbxZ1RMkWtn/7tkqNw/Ddhp3wGfxncRU=;
        b=d2W1pLchnwquxcq0SaIHq+JVlwQdK1dLJyk6IbZ5tT5ZgmZDlzGh9dQFGvUHHMee/8
         4eCRMz497eb69Zl8la5FvOnmviD4W7y18tP6UTl2DnawVcVLeJ6ivPayff9akC/ZKWSG
         J70O2bz4ZbP+H+YKT4OrZasGv0iQzXQCskJ30QW8L6plaf2Eyx8/2RrTI8bF2cfaeaLn
         H3v+60z4DEBwM/szdWIP+MVpvaRHIzUfT4ZSZA3i14C5f6Q3SZpW8BQtVOZNVw4hTGZH
         w/GSKr7+FzYhJn9VaYLIr/iotP4yrE32Su6pMfBnaqjYIy17Klis0nZPfKr9pXq4P/YM
         +YHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RIt/qxR4EAUFbxZ1RMkWtn/7tkqNw/Ddhp3wGfxncRU=;
        b=dzmYRWg9iw+mQHk0SdVr9ejo7m2y97gvXFJuVogzHEGf0G0TwSoQmAZoHrzLaLZu3C
         tXmOIGn/gqiGigrKzGP08xqNJ+Kj4zbZpsPEaf3yzeubHZVZrG37a1fVxVll/j/Qx/JQ
         Jyxv8D9AQVjHDq7OTgnSXvEURpHRyhjnyW8wbd9d6aPShdCpNH8mbR80yMEm6quU9ohO
         9zO+TrvjAlv4fIL+ylzegajmntH8LCBHKcUSdW+ZzE7DjZsb+j2sHKP4tlmNFXOI9zbk
         om6TS/MaRtZffkSI+90oq+Smnd0D3mPe3l2cnY6mxmssCk2HQxx9/XUQMgx9KHpyoxC0
         6CHw==
X-Gm-Message-State: ACrzQf0MaytZ5WjsnuklvTINdFASEhHvGNWKisz8c6FllvSbBGFCk8tF
        ByEy2SFpFlmH16ayxud3wBjQ0w==
X-Google-Smtp-Source: AMsMyM7e+doSVcNfsgJRtgQO2FTh/mndFIJ8tFDGM1/fX7o2yWrpaYGbOuOTgBdfIXXwWYdMMdaylw==
X-Received: by 2002:a17:902:ceca:b0:177:fa1f:4abc with SMTP id d10-20020a170902ceca00b00177fa1f4abcmr31918275plg.99.1664362836541;
        Wed, 28 Sep 2022 04:00:36 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b00177efb56475sm1539524plg.85.2022.09.28.04.00.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Sep 2022 04:00:36 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     sathyanarayanan.kuppuswamy@linux.intel.com, bhelgaas@google.com,
        ruscur@russell.cc, oohall@gmail.com, fancer.lancer@gmail.com,
        jdmason@kudzu.us, dave.jiang@intel.com, allenbh@gmail.com,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v3 5/9] PCI/AER: Unexport pci_aer_clear_nonfatal_status()
Date:   Wed, 28 Sep 2022 18:59:42 +0800
Message-Id: <20220928105946.12469-6-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
References: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
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

