Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E455C63798
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 00:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 022B922273
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Nov 2020 00:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1xjm4Mu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKNAti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKNAth (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Nov 2020 19:49:37 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3042225E;
        Sat, 14 Nov 2020 00:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314977;
        bh=qBaAL4MQUHwMWUUhiKf9tMwN4kN0fQHr7+CN7eAoXTI=;
        h=From:To:Cc:Subject:Date:From;
        b=R1xjm4MuS5ug9mWAuq31K5jPWEMl9OXX2DXqSl6aMu3xUtft9xO9PEnU9edRvKzJO
         +/p3G4/OwzKeMH4EFyQlJWZjd2wPyt8Q7uquE4ai9nNS+46w3qwFcVKhtVtm3CS5Jf
         /FpK6qu9GzMFH+qgQ+lUttyns9RoXe4q6ix84G2Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH] scsi: ufs-qcom: only select QCOM_SCM if SCSI_UFS_CRYPTO
Date:   Fri, 13 Nov 2020 16:47:54 -0800
Message-Id: <20201114004754.235378-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

QCOM_SCM is only needed to make the qcom_scm_*() calls in
ufs-qcom-ice.c, which is only compiled when SCSI_UFS_CRYPTO=y.  So don't
unnecessarily enable QCOM_SCM when SCSI_UFS_CRYPTO=n.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index dcdb4eb1f90ba..3f6dfed4fe84b 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,7 +99,7 @@ config SCSI_UFS_DWC_TC_PLATFORM
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
-	select QCOM_SCM
+	select QCOM_SCM if SCSI_UFS_CRYPTO
 	select RESET_CONTROLLER
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
-- 
2.29.2

