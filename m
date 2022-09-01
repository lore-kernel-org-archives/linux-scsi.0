Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CD1ECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 18:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiIASSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 14:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiIASR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 14:17:57 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C6F7B7AA
        for <linux-scsi@vger.kernel.org>; Thu,  1 Sep 2022 11:17:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z187so18205885pfb.12
        for <linux-scsi@vger.kernel.org>; Thu, 01 Sep 2022 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=zI/BTKFXJXbsFO1kxQzveFTmwvhlHGn8PgFA+S1jres=;
        b=lbGN4Kp3lRbdgZAgZthVUQrgacQyY9T1ORf4+IRNyEdsR08hfaasoXVs5DtXtNjkTt
         wTxeqEsp7RBY+UWH7L93OCDfVRg9a1qSh9cBwhtS4I6Er4mCMCBHZU5JSui19cnXXiig
         44oPiVPAXmom3N3thvuWvMaOvOfbAWjPKiQSDzINje0Iw3JqQRthMh0s8MIbff5OnpvO
         N9tS9ZKZ0SL5YyBB3QM4IjwgO1zAcad5VDu0Kunmmzc158kOPOqoqYiZnKQaU3pCner0
         QYRlE7l5InBZMbljno6S49tduW45wREpYyIuNPHbDZ1EkbLBhOg8Xve56z8sFCfzHqVq
         iV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zI/BTKFXJXbsFO1kxQzveFTmwvhlHGn8PgFA+S1jres=;
        b=jZZk6ZuSUbmQHuk5KiDQdL0/frlW3VS61s4zj1O0BlXntaaOOSCcSEybWN19mJgK/P
         Bf1UEu+/6ksa7F5yN9T27yc6HzpJ2MChat+L3jEnMJ31uc/MRge4uIlz47y5ixTdhfmV
         Fdw47v6lpMBPEC1Fwzb1nV9gubcFNvgso1Fuuhm6Z77lfk5X0mKXpYFlIE/ppemO30q9
         6zIDU+p5+NYGvEFN+H+Ox8GufhsxuWtg4wZomQZpBmncJBuCkBz81C2g4P11+pSzuMLt
         VSIzUSsKCtohQbuijRQ3LoDlbGlP946x8HwFuitPeICKC7fb4L6VE2IcssL1sNgXoFc/
         /KuQ==
X-Gm-Message-State: ACgBeo2268xibImyeIZpww6JJm+BRitZy4IF5bfYNugvpu/D6ezw+kWb
        vukCuyhTnTnAgJ6DWKpUUEdSlA==
X-Google-Smtp-Source: AA6agR7kM8iGzccwGQ6iMySe4S2grbdHOsy/itfUuKWXsnekyj0x05dNeHnyQVuTcw2HeZHUxsgADQ==
X-Received: by 2002:a05:6a00:88a:b0:53a:b7a0:ea3a with SMTP id q10-20020a056a00088a00b0053ab7a0ea3amr9698501pfj.21.1662056274006;
        Thu, 01 Sep 2022 11:17:54 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id b13-20020a170903228d00b0017519b86996sm6320538plh.218.2022.09.01.11.17.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Sep 2022 11:17:53 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     fancer.lancer@gmail.com, jdmason@kudzu.us, dave.jiang@intel.com,
        allenbh@gmail.com, bhelgaas@google.com, ruscur@russell.cc,
        oohall@gmail.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     chenzhuo.1@bytedance.com, ntb@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/3] PCI/ERR: Clear fatal status in pcie_do_recovery()
Date:   Fri,  2 Sep 2022 02:16:33 +0800
Message-Id: <20220901181634.99591-3-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220901181634.99591-1-chenzhuo.1@bytedance.com>
References: <20220901181634.99591-1-chenzhuo.1@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When state is pci_channel_io_frozen in pcie_do_recovery(),
the severity is fatal and fatal status should be cleared.
So we add pci_aer_clear_fatal_status().

Since pcie_aer_is_native() in pci_aer_clear_fatal_status()
and pci_aer_clear_nonfatal_status() contains the function of
'if (host->native_aer || pcie_ports_native)', so we move them
out of it.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/pci/pcie/err.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 0c5a143025af..e0a8ade4c3fe 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -243,10 +243,14 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	 * it is responsible for clearing this status.  In that case, the
 	 * signaling device may not even be visible to the OS.
 	 */
-	if (host->native_aer || pcie_ports_native) {
+	if (host->native_aer || pcie_ports_native)
 		pcie_clear_device_status(dev);
+
+	if (state == pci_channel_io_frozen)
+		pci_aer_clear_fatal_status(dev);
+	else
 		pci_aer_clear_nonfatal_status(dev);
-	}
+
 	pci_info(bridge, "device recovery successful\n");
 	return status;
 
-- 
2.30.1 (Apple Git-130)

