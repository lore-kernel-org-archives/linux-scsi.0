Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D96BC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 09:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CA1214AF
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 09:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TlJRvRJH";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WN6lb6Gw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfLKJNq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:13:46 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:48974
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727253AbfLKJNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 04:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576055625;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=42yNDIrjy8vmTGZpCOEq/aiq1nTIM3d9+rZoTsv/drQ=;
        b=TlJRvRJHI9bvVQ3XjG87h4UaQzFj8t2FzMYfDzDYSeIJHz7wtXBI4J+LvvCi2uVt
        JMecs7KV9e2IqYz9gsRIJycWldJWH2DgndPDxAhT1vn/U7avICEnERW8Ok6P57SvlIf
        iYdZ3bhMq9qFAEtE5buyKjAShr71V6nZhBuXlVUQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576055625;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=42yNDIrjy8vmTGZpCOEq/aiq1nTIM3d9+rZoTsv/drQ=;
        b=WN6lb6GwWL7Ae7tSzls9fhSZGoK4I/DGDhKXv6OKYJVJPI+VZguokGPkZgnmZeqi
        ghfxG4TXA2MWcBUxDSYcjU+EqBNIkZhJ8MhchpY8a36eZzokPDQefZjSLb4qJ4NstfR
        pv6pzvrL1iuNNRDSMnR21HltyIYwWUy1bofV0xYM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B186C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Maxime Ripard <mripard@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] arm64: defconfig: Compile ufs-bsg as a module
Date:   Wed, 11 Dec 2019 09:13:45 +0000
Message-ID: <0101016ef43c56d3-c7064a44-6025-4349-afd4-a2c91a9d9ffe-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.11-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Compiling ufs-bsg as a module to improve flexibility of its usage.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 8e05c39..169a6e6 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -227,6 +227,7 @@ CONFIG_SCSI_UFSHCD=y
 CONFIG_SCSI_UFSHCD_PLATFORM=y
 CONFIG_SCSI_UFS_QCOM=m
 CONFIG_SCSI_UFS_HISI=y
+CONFIG_SCSI_UFS_BSG=m
 CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
 CONFIG_SATA_AHCI_PLATFORM=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

