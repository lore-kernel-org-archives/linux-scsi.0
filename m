Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76B3C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 15:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiI0PjX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiI0Pis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 11:38:48 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E531CEDFB
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 78so9711068pgb.13
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pu5CUxxvzQDPV1MrZt0eySYk5qcgDQDMRS6x862FR3M=;
        b=hpOlDxF35EkFZOgnZUEUpb7bfMeNXlEs/6zeqAK6eTGvVycSXxN5mhIMc9S8WfoaF/
         cwWs267qASx0e+WT1TwXng5S9nSyp1dRWH7rUpDXZLoP8jh/myCkq/Dpt9Ocv61bMCrX
         KCVkGQ/DsIqrtNOayppyBxQYmf/6pDTp8loAtnshKT2GVLI7NiICfkvNXNmQwARXA4ba
         w7biRtQ/LR4lB7JOHBHhVgKhVaVGPDngj0vRuIKmH6akrigtDtDlTjL6PpQqW/lzhXea
         fBVQ0A2O0oriv/fWIVwEeR77bbp0SvmTpT9sZNgGsqs2ciLylmpapoYCcXrGggb+tFGz
         ksig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pu5CUxxvzQDPV1MrZt0eySYk5qcgDQDMRS6x862FR3M=;
        b=O1n87VXM2ZJg2QvjYHcVl4cj7/zAFM413mSpNgMSuTuKbe+yt3GgQBYvDBTipaRbJg
         pZg6p8VItbLVFl1I8j94NCG+hIQGdJdcyB6foUT08PWKfot9JR5wvQPxW/+7tl2XfFd0
         ESVPuOZPfrIL+qj7VrWqXNkrKz9R6XjAByA1PCF7Mu7KykfBBtjLfWcHkw1q7+mQ9Eg7
         erbkPZLFnCcQNJ5Xyubi11HwU/C3x14I8i5Dy0K4sypWyV6ZjojhUq+EReGffuKxrgxp
         Rsi0YXK3G/efyltLyQLRAmIpjmKrRqOttqbylMwPrcnU+KLbI3klxda2ZK+3SfwDu6eJ
         soZw==
X-Gm-Message-State: ACrzQf3aIj8g1k89Ah4ysgDCFUjAb2fIMxvExVC4Hdu+rBV9EC2SJArF
        OUoopCOpNtCbXf5NGIQzBK2Q3A==
X-Google-Smtp-Source: AMsMyM5Rm9HIrz8bymvsH/euOjrFQJ4/XBJHdRa6nFHuOBrWJvQLmhDheo/pfwZ79K47Gzo473rdQw==
X-Received: by 2002:aa7:8c4e:0:b0:54e:fa98:5031 with SMTP id e14-20020aa78c4e000000b0054efa985031mr29740531pfd.44.1664293002852;
        Tue, 27 Sep 2022 08:36:42 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79a10000000b0053639773ad8sm1933087pfj.119.2022.09.27.08.36.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 08:36:42 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     bhelgaas@google.com, ruscur@russell.cc, oohall@gmail.com,
        fancer.lancer@gmail.com, jdmason@kudzu.us, dave.jiang@intel.com,
        allenbh@gmail.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v2 3/9] NTB: Change to use pci_aer_clear_uncorrect_error_status()
Date:   Tue, 27 Sep 2022 23:35:18 +0800
Message-Id: <20220927153524.49172-4-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
References: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Status bits for ERR_NONFATAL errors only are cleared in
pci_aer_clear_nonfatal_status(), but we want clear uncorrectable
error status in idt_init_pci(), so we change to use
pci_aer_clear_uncorrect_error_status().

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/ntb/hw/idt/ntb_hw_idt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/hw/idt/ntb_hw_idt.c b/drivers/ntb/hw/idt/ntb_hw_idt.c
index 0ed6f809ff2e..d5f0aa87f817 100644
--- a/drivers/ntb/hw/idt/ntb_hw_idt.c
+++ b/drivers/ntb/hw/idt/ntb_hw_idt.c
@@ -2657,8 +2657,8 @@ static int idt_init_pci(struct idt_ntb_dev *ndev)
 	ret = pci_enable_pcie_error_reporting(pdev);
 	if (ret != 0)
 		dev_warn(&pdev->dev, "PCIe AER capability disabled\n");
-	else /* Cleanup nonfatal error status before getting to init */
-		pci_aer_clear_nonfatal_status(pdev);
+	else /* Cleanup uncorrectable error status before getting to init */
+		pci_aer_clear_uncorrect_error_status(pdev);
 
 	/* First enable the PCI device */
 	ret = pcim_enable_device(pdev);
-- 
2.30.1 (Apple Git-130)

