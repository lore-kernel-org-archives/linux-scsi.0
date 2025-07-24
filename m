Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75E4400
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315503; cv=none; b=KHPIHR34ev6O6HfgS/V5mJO9mM1lFGdGUibFZGwLcH1u3AZBqhGoIXPB0JH229P2WWiKedY7YkMCrQ4dw0zSo1Vqn9DW0yEKfZDWMXdf8ZVK3mKz7axi01eo5kZRL9TMKyylrZHwUYVjRRhJCpjPDZle6LXR9ZOYuk14MNKlZLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315503; c=relaxed/simple;
	bh=8FyN4zk3zA1P6BIsjszVhSEGrc6jX+6Dy2G5CJ6II+Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8wHQVcyJS0eqiz/E1ygG4DfnXlMJVtxiIza+2p2HXuH37WYLycepIk34ArD+G92aTwC+hf8UZjTyEss9iUXnw0A73CBmXhOwK2otaI2sAmfOeW2sJaveHna8nhUVg6wDFty+3qEjimoSO9sgn1VBugJL4BSRTLwGy9sCF7A8yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9euKxoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9euKxoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B4CC4CEE7;
	Thu, 24 Jul 2025 00:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753315503;
	bh=8FyN4zk3zA1P6BIsjszVhSEGrc6jX+6Dy2G5CJ6II+Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P9euKxoZLTAY7nOJIf5plcmEH3b9Xi3EUtfvSOH6BUwGs9DaSrtsRP2spFWsVAhQZ
	 V/LONTAHNor4GTnBmXLnzaunC8wOotuSTDjNrqMe5luGknCGY/h+lkEuC2ZHsEbMnA
	 zpz/xjXlgu62bTyn9WhpviL3SnOiOlQPrcyX/maKRnNa2gSpUCWGb8ZxqJpliu1KDW
	 WtJNTizg+qg/3ZP4JASK+7qvxf40g3Edef7nPpGEpUMauI46+9e/M3iap1vC6G4sut
	 xaRUuXR6kId4iKthuttskrTVscx9AB1bN3HUpOlAf3Hzph7ObLAuU4QScZt3aq9n1X
	 GpOTF3jthegpA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/5] scsi: libsas: Refactor dev_is_sata()
Date: Thu, 24 Jul 2025 09:02:31 +0900
Message-ID: <20250724000235.143460-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250724000235.143460-1-dlemoal@kernel.org>
References: <20250724000235.143460-1-dlemoal@kernel.org>
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
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

