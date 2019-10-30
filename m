Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9CFCA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25BCB2190F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572451130;
	bh=TTTgOS79xzCkyvAQmvyDhZ4Enfn54YURfcmMu7/oJZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g35Xh6Kliq3dq9y8QDFtHL0WGbebOBZDp2Bji66WTTn031B6S4qcEpmkHAYAyEMGL
	 a9YptpSZkDJnsWVC7sP1qCONOeX19/XJECSvauPE4PYghcOm1dKVkcwtulhPdliD6d
	 QY5174gU4hfhQDmmBApTvH6g+BYqBU85CiKvGm4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfJ3P6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfJ3P6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:58:09 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB9B217F9;
        Wed, 30 Oct 2019 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451088;
        bh=TTTgOS79xzCkyvAQmvyDhZ4Enfn54YURfcmMu7/oJZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10J1dop9wji32cn8KL4bT6n5uvQDC/uToLCVss+KUKXwCoaC4L9jZFnV21Vecukr3
         oV1kWlhu2vcRM8R9whoRrtt+MMXs1pJaH7OopGqa+fCfVkXwr5MIuTsb4r8uUdRtZD
         +Hk+MProBwadjZukZ0jiFwuNv/VlEWJ+F+Z1HysA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/13] scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
Date:   Wed, 30 Oct 2019 11:57:45 -0400
Message-Id: <20191030155751.10960-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155751.10960-1-sashal@kernel.org>
References: <20191030155751.10960-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 8cbf0c173aa096dda526d1ccd66fc751c31da346 ]

When building a kernel with SCSI_SNI_53C710 enabled, Kconfig warns:

WARNING: unmet direct dependencies detected for 53C700_LE_ON_BE
  Depends on [n]: SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_LASI700 [=n]
  Selected by [y]:
  - SCSI_SNI_53C710 [=y] && SCSI_LOWLEVEL [=y] && SNI_RM [=y] && SCSI [=y]

Add the missing depends SCSI_SNI_53C710 to 53C700_LE_ON_BE to fix it.

Link: https://lore.kernel.org/r/20191009151128.32411-1-tbogendoerfer@suse.de
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 433c5e3d57338..070359a7eea1d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1013,7 +1013,7 @@ config SCSI_SNI_53C710
 
 config 53C700_LE_ON_BE
 	bool
-	depends on SCSI_LASI700
+	depends on SCSI_LASI700 || SCSI_SNI_53C710
 	default y
 
 config SCSI_STEX
-- 
2.20.1

