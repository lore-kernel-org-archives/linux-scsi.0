Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343DD277C8B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260852; cv=none; b=js5jaq5A4owQdVJMdQDpGGlNGMmRA/DkRGcVS+xvuVUNcVzd5ago2jAnlVmiGBu/0lCBrjs52Pe8TEzEJl/v7lNHXEOjeMT6Nu6p5a5/8E5ZtLZrFULzBVakwmAUYeuf7p+Ndvk9JfrpGXo/lWSpJOy4n/goFcVxQNKZAPpPc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260852; c=relaxed/simple;
	bh=Bu5n1IV9TsNvGu5mGLpgaG/e/vqkcuvjNq438/yGlmU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxz23meUZtvJ92EUQEgADqssHttTCK3j2pBSuKWT+iGSe6PpIaXS4DKHrz1zJ6f8Y0I0BK/sTO78yRE9EZNsftaw/uM0JX7hzk1/j5bSTO77d9ryaG4gUNy8Rlf0EG8J/yRQaNNcMdOJGFPnBVUSIogrKquc/4TVe3LO4DpX8aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPe00zcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPe00zcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45742C4CEE7;
	Wed, 23 Jul 2025 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753260851;
	bh=Bu5n1IV9TsNvGu5mGLpgaG/e/vqkcuvjNq438/yGlmU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OPe00zcOsK0JaZG2pkJ39NwitBQZY3NLqgU6OvYtrY5TAaBZnDSh7/arHnRhDC9rA
	 vXB+BbKbpNNTYUDDXHT00N1088JJhjfYcE30kFNtkaQidsCaV3NINL3bjTgShzS6Lw
	 +bHz29+srTQfqdyJB+kZZBL0pDIHDmSMSJ0S+hv7JEQMdHmnEyEgfWtm73t4R3BbdH
	 03gOOJVyIljhT4Ox6c/0EL99TesgSzHFmp0cOrG7ea7TU7nHH8e0Qi5qb4iqd41EUo
	 hOpuCjNunm0w9z7Fo7Q9HfbO2coFbxYfCffUI7t+S28DIPMlfNSkQD+Qo9DwzrgtPe
	 M1UDtOJXMSk9g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/5] scsi: libsas: Refactor dev_is_sata()
Date: Wed, 23 Jul 2025 17:51:39 +0900
Message-ID: <20250723085143.134333-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723085143.134333-1-dlemoal@kernel.org>
References: <20250723085143.134333-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a switch statement in dev_is_sata() to make the code more readable
(and probably slightly better than a series of or conditions). Also have
this inline function return a boolean instead of an integer.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/scsi/sas_ata.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 92e27e7bf088..8dddd0036f99 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -15,10 +15,17 @@
 
 #ifdef CONFIG_SCSI_SAS_ATA
 
-static inline int dev_is_sata(struct domain_device *dev)
+static inline bool dev_is_sata(struct domain_device *dev)
 {
-	return dev->dev_type == SAS_SATA_DEV || dev->dev_type == SAS_SATA_PM ||
-	       dev->dev_type == SAS_SATA_PM_PORT || dev->dev_type == SAS_SATA_PENDING;
+	switch (dev->dev_type) {
+	case SAS_SATA_DEV:
+	case SAS_SATA_PENDING:
+	case SAS_SATA_PM:
+	case SAS_SATA_PM_PORT:
+		return true;
+	default:
+		return false;
+	}
 }
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
@@ -49,9 +56,9 @@ static inline void sas_ata_disabled_notice(void)
 	pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n");
 }
 
-static inline int dev_is_sata(struct domain_device *dev)
+static inline bool dev_is_sata(struct domain_device *dev)
 {
-	return 0;
+	return false;
 }
 static inline int sas_ata_init(struct domain_device *dev)
 {
-- 
2.50.1

