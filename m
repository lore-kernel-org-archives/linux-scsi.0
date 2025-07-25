Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04CE19066B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408846; cv=none; b=gEIQ3HSX7Vv/etA3tLDmOVUADo77nIxpqVSi8VSNa56yzdcO4ySAcDujAJtugSDXG4HHj31nuu9NCEyXuNAtJg0uzjRbn08F/WQ9fTGx23KDw1uFlm7YJWysTYeFD1B6S1lxSNXBfm1qfBhdB/dKAFW6dnpW3lcve+m4uH0nhwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408846; c=relaxed/simple;
	bh=8FyN4zk3zA1P6BIsjszVhSEGrc6jX+6Dy2G5CJ6II+Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bubys5TjQ+j4S3LHD11Js3Qo2vomQoH82fMKxv3O8wRDuBmbFLZiKgXVvCKqxslFYBLK2IqmzWhj/w2sfKqOS6SNhhhf/c/QOzCg34WdKRRfKTbKckI/oSCoidHVFiA2WLyda2IheTmtnupxx9hFuxRbbujZg7/8YrK+wQw65bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtNB+vRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtNB+vRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE9BC4CEEF;
	Fri, 25 Jul 2025 02:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753408846;
	bh=8FyN4zk3zA1P6BIsjszVhSEGrc6jX+6Dy2G5CJ6II+Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dtNB+vRT33FQX0GvHQmJfG6XS7xG9ky6/mSNZs5Z6ts1ZOI2onwYEgzAcmRKROrrG
	 Tbvivi45K7caYh0Vn0xXVGcWv+Jvg/I3OUbWfmECCLhPAc9YSUX2tdh2wfBIqhY8tF
	 yUje9B36l2e5V2AOlvItlOoPzFNfNtmrpCmbVJ+q1dtS3u53QTjpgH+xoTr5Z9K+Ob
	 zt7D5bS0j+OzHVb+R7ui6k2dJEV2ySYFYEWOF0R+3oPnn/YyWcsPJIiC7tzq029tr0
	 +hdF2ntVt4cg13kBh2uVMvQmDohZuKc71y1BLi0EMqQ4OonxeTQ6Nr3Vg/OuUT1s5+
	 tVfDxeRjHnCsg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 1/5] scsi: libsas: Refactor dev_is_sata()
Date: Fri, 25 Jul 2025 10:58:14 +0900
Message-ID: <20250725015818.171252-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org>
References: <20250725015818.171252-1-dlemoal@kernel.org>
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

