Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2D4C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 05:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3756764EF6
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 05:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBUF1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Feb 2021 00:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhBUF0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Feb 2021 00:26:55 -0500
X-Greylist: delayed 811 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 Feb 2021 21:26:15 PST
Received: from frontdoor.pr.hu (frontdoor.pr.hu [IPv6:2a02:808:3:101:250:56ff:fe8e:1370])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730AFC061574;
        Sat, 20 Feb 2021 21:26:15 -0800 (PST)
Received: from [2a02:808:3:101::5] (helo=mail.pr.hu)
        by frontdoor.pr.hu with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <zboszor@pr.hu>)
        id 1lDh2q-0000VP-Oj; Sun, 21 Feb 2021 06:12:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=pr.hu;
        s=pr20170203; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=f40Fx/Hmx9xz9dKoklu7aLMqq9AlCJu/St+EpaOZARI=; b=GU4QLV+XxVaEG7rY4f3YbMTCte
        HbbHbAOLmPIMXpAoKZUjOBBB+MLSCz/n9xeGFi5+VRYuHjG9GcxYB2F0HX4By7vuRJxUS/jhqA68X
        0ujdlrNea9f+QuMrqCBnPoZXa8yIVt7tQ+25XYdXSbSj0bhh+rug86BFFsvz5uuZ61qPJSExYSTDv
        Rx7EPVkzCxpTT7XQOEcYpSYdJgaZGS4tyf+mnr3XkH2Oc1Sfhl39LncwO2UeVtE1LI9pudHzsb/lh
        4EQU4XemzW+H5sQPzAQK+/a3GX1dCb/aNgs0FigESasjWsLfisIpwLAIGjosPZZz6+JOC5wdYpBRR
        EcB9YTbQ==;
Received: from host-87-242-23-58.prtelecom.hu ([87.242.23.58] helo=zolilaptop.lan)
        by mail.pr.hu with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <zboszor@pr.hu>)
        id 1lDh2m-0002j6-TT; Sun, 21 Feb 2021 06:12:34 +0100
From:   =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@pr.hu>
To:     linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        gregkh@linuxfoundation.org,
        =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>
Subject: [PATCH] nvme: Apply the same fix Kingston SKC2000 nVME SSD as A2000
Date:   Sun, 21 Feb 2021 06:12:16 +0100
Message-Id: <20210221051216.3398620-1-zboszor@pr.hu>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scan-Signature: dda648b1d3e643e91fd1a0320e0a0c7d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zoltán Böszörményi <zboszor@gmail.com>

My 2TB SKC2000 showed the exact same symptoms that were provided
in 538e4a8c57 ("nvme-pci: avoid the deepest sleep state on
Kingston A2000 SSDs"), i.e. a complete NVME lockup that needed
cold boot to get it back.

According to some sources, the A2000 is simply a rebadged
SKC2000 with a slightly optimized firmware.

Adding the SKC2000 PCI ID to the quirk list with the same workaround
as the A2000 made my laptop survive a 5 hours long Yocto bootstrap
buildfest which reliably triggered the SSD lockup previously.

Tested against 5.10.17.

Signed-off-by: Zoltán Böszörményi <zboszor@gmail.com>

---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4a33287..3af6a95 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3264,6 +3264,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
-- 
2.29.2

