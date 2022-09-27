Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030CBC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiI0Pj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI0Pis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 11:38:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4594491D5
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so15922916pjm.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Q86dpO4MZD0CA12jM08xWGYyYtYWODVJgw7gnIuH5Tk=;
        b=IMIPIN6w3MO7MCbD7V3ThsGSRsp1g0IjueBKGf/11rJ6MD5qN4UR3XGmJipX9CK++6
         eiOchrYYinPyoOBn+0Y+rDP0uVRFImrpBNU1UDXtOMNUxPlRqmop3RFvpzPbyEybSG5F
         CRDPQ1enPFC99WOwYFVY2QZDmn8jSfY/zTlBpgKJUVPQ+lpJjVT0rmsBeR4eYvaQSxZK
         dvTm2obycBfI5P1tTJ+khPgiPLQGLeUoFr7m2HgOHrjHsPGgqHpQ2Yy3mDC88pmtuxyB
         YdSpANeZeOxf58GtYGN2R1FOht2o+Xmi4V/D1Ny4qiePO8a/2BpFtrT8iUKZBeNMTtOh
         RWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Q86dpO4MZD0CA12jM08xWGYyYtYWODVJgw7gnIuH5Tk=;
        b=w22orMUXKyBzDkVDmcvh9Qhcf3IclrilnxUhlImCGJ3r0INkrlzpovH7BB3CDSYshu
         aXMtY+fcMpp2GCs96kRa9WsoTqTEzhxSGF15YiLBHCH9dGCAZV25P3U4PxINwR3os7vI
         aO/vAVz+Vju4oKwKc5516+qSL1w3liXVsy5cCYnOA6P1KZsFXpJRoPLbCiZjamp/yBE6
         UoL6czgNzWo6OKAPrhQXE7Abw2ER4hytjGzt38KGPTdkDFcWj4xqnQdtPYfKWAgYrLTd
         r51RFZUp3nRyxo16Z8Fj/m381200L2dw8NjfT4661qhPRNR1lnut1BaVNBF5124JGbv8
         W5Ww==
X-Gm-Message-State: ACrzQf0gXJ8y1d4HtG3adWm36GGkjjZwrS7SDm+9tV4evvhfzDNtdivd
        +15L2AdZDJlYpZiER0LuRKQ2xg==
X-Google-Smtp-Source: AMsMyM5RaT7WFGyUZHFYqoVH6SiLBpf6gppnLFccPidOBspFk2OpmdxZsinWDsz9SjngtrgXs1RPug==
X-Received: by 2002:a17:90b:17cf:b0:202:95a2:e310 with SMTP id me15-20020a17090b17cf00b0020295a2e310mr5447237pjb.76.1664292992706;
        Tue, 27 Sep 2022 08:36:32 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79a10000000b0053639773ad8sm1933087pfj.119.2022.09.27.08.36.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 08:36:32 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     bhelgaas@google.com, ruscur@russell.cc, oohall@gmail.com,
        fancer.lancer@gmail.com, jdmason@kudzu.us, dave.jiang@intel.com,
        allenbh@gmail.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/9] PCI/DPC: Use pci_aer_clear_uncorrect_error_status() to clear uncorrectable error status
Date:   Tue, 27 Sep 2022 23:35:17 +0800
Message-Id: <20220927153524.49172-3-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
References: <20220927153524.49172-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use pci_aer_clear_nonfatal_status() in dpc_process_error(), which has
no functional changes.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/pci/pcie/dpc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index 3e9afee02e8d..7942073fbb34 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -288,8 +288,7 @@ void dpc_process_error(struct pci_dev *pdev)
 		 dpc_get_aer_uncorrect_severity(pdev, &info) &&
 		 aer_get_device_error_info(pdev, &info)) {
 		aer_print_error(pdev, &info);
-		pci_aer_clear_nonfatal_status(pdev);
-		pci_aer_clear_fatal_status(pdev);
+		pci_aer_clear_uncorrect_error_status(pdev);
 	}
 }
 
-- 
2.30.1 (Apple Git-130)

