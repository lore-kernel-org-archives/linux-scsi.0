Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F788C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 11:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiI1LCm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 07:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiI1LBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 07:01:08 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2CE101D3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:01:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i6so8025619pfb.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 04:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8Z/ugyVP4SSiBNTqiEXPWybAg+NaSbXcSQ5EW7ChSt4=;
        b=FHnm2AaDgGGL3Qb4S5rvtHWuJoHeyMlhpER41MQux4jSSHMRLmSauxip2U8Ls1Dd+Y
         19x3//5jQZghMH2wT1Gw9kAIothGyal7qXRDEfQmW+eZEnJwwIr6prp5dMhpipz8eGFX
         1MvRVNMEPcMMj1ZUz797NlbPTWYbgcHrYvxxJErlM36QkHTtLH55iGoTR9CKNc9+qxuC
         Jzc8mdsAQjxdzZsdZ5rdbM//fGbWf75NhkKFVlQTDRy4xtMVB9EbLMCogwmPXICPTXhj
         WtcORu4EtFGUkcjXR6FH4O8OTeKcf18OfFNznmBsUNtZx+rl204eixa8gkxPN5E//vcE
         b/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8Z/ugyVP4SSiBNTqiEXPWybAg+NaSbXcSQ5EW7ChSt4=;
        b=38RET12HLcIo3SVB4Z9nBTsFh3P7WheP0KuwuMHBiDizsiuUBkPb+jBIfz2he+Y77F
         JjysRkYCvgt8RoGFzLBnq4ZhdGqviZAotIbPI3ynvHufb+9Y3p1l9cMofSyPyoRniSJt
         beX6ZtDBpZi62zj/T4FQSzDNLmGxQOl46DW6D/a8pWG8NfwjX8fEw3o0ROdU0nbpD0uU
         KszN0y2p1z4tPUtrOmZb+ajLKBDDYS5L8MKMKHTZyOYi4kzrUwocARi2MKM/Whl0Z3bQ
         vc8UGF2wNlHB48BTBCJJ1HmEpHJUCFbc8HwOheK4bRluF5U5U4vsAcmWQm9ZQT5RVCL9
         vACw==
X-Gm-Message-State: ACrzQf0oOyApL9KStTZxs/2i4pbCxDY7MKv/WuPjMda6QFf6cdAe8jgC
        10qcI1B9YvuSzh3THvJ7L/Nyqw==
X-Google-Smtp-Source: AMsMyM4ofQZRkpGFxs4XD0rXBl1JIn4/vMVBWhueuGH3CSuShGbXwzXsRpudhK5toT82OfIWlzxVcg==
X-Received: by 2002:a65:6d8d:0:b0:43c:9bcd:41ab with SMTP id bc13-20020a656d8d000000b0043c9bcd41abmr16631977pgb.303.1664362859624;
        Wed, 28 Sep 2022 04:00:59 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b00177efb56475sm1539524plg.85.2022.09.28.04.00.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Sep 2022 04:00:59 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     sathyanarayanan.kuppuswamy@linux.intel.com, bhelgaas@google.com,
        ruscur@russell.cc, oohall@gmail.com, fancer.lancer@gmail.com,
        jdmason@kudzu.us, dave.jiang@intel.com, allenbh@gmail.com,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v3 8/9] PCI/ERR: Clear fatal error status when pci_channel_io_frozen
Date:   Wed, 28 Sep 2022 18:59:45 +0800
Message-Id: <20220928105946.12469-9-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
References: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When state is pci_channel_io_frozen in pcie_do_recovery(), the
severity is fatal and fatal error status should be cleared.
So add pci_aer_clear_fatal_status().

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/pci/pcie/err.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index f80b21244ef1..b46f1d36c090 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -241,7 +241,10 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	pci_walk_bridge(bridge, report_resume, &status);
 
 	pcie_clear_device_status(dev);
-	pci_aer_clear_nonfatal_status(dev);
+	if (state == pci_channel_io_frozen)
+		pci_aer_clear_fatal_status(dev);
+	else
+		pci_aer_clear_nonfatal_status(dev);
 
 	pci_info(bridge, "device recovery successful\n");
 	return status;
-- 
2.30.1 (Apple Git-130)

