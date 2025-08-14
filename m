Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78381205E3B
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192774; cv=none; b=aBHMCTO5MLOj361PIy8IPzG2+tEAVQwMvArPrR/8O/ILIYaFtHu9a44CQyOcoDbMNubn7MQ431cBa2OSRDpDPsOa2d2FgDARvc8SxvbZQiLs6cNHpVeQEAV209wGGEDfq3AMo+PrwPnN3YG3/uMGrviAiH+PR949FYTD5aMC7bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192774; c=relaxed/simple;
	bh=l8RvRsvMfR2zddVKiOfB73QczJAWCKw4iTl2BBnx0pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpDGHBT1UnUAyKLGPDa/JEg4TBz+SirQCLF0h2wEZf75KVMoXxUfmxwA2wg4tKXQzYEpxOZC3/xqki2e/zwi0RZD7zB2ZCwtMBp05rGB1zfUBa2tqBaqAn7e9qqujuAtk1FP5wMXlbIgZNklmaO/9waEkkkZRppzfq4rJAGqjEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XahriD4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XahriD4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D7FC4CEEF;
	Thu, 14 Aug 2025 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192774;
	bh=l8RvRsvMfR2zddVKiOfB73QczJAWCKw4iTl2BBnx0pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XahriD4OFps9sXJQDVXNW3WRVeo3zoI2+OYUTniYeQMJvoiK2Js3yzhnJPoH/NEh1
	 5hq4bsvfG4g/eI8on/IP9F9Abp5xP45MeUi+hf92M8x2/NyyB8JN5thKg5ylMLAnwe
	 qz8cfULvk5MJe/CaGjDIycooCjdaGONkT5BfUjfkkGJJ4bQru5ZXuYqA8mnCRz19pL
	 1rqUrAcqMmNXcfByoHqo3yjRddlu6lDozfFPnKzBaqbcnIgGPyBa2Y7QyuiiEKbt4U
	 eK6XMItCWdAi0Sg+3/7jf7BbKgqnwqPVCj1eSvbQgjIAxlVS5uVJtmtQ7wj6SAuVrA
	 nprskLxfAW4/Q==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 08/10] scsi: pm80xx: Add helper function to get the local phy id
Date: Thu, 14 Aug 2025 19:32:23 +0200
Message-ID: <20250814173215.1765055-20-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2932; i=cassel@kernel.org; h=from:subject; bh=l8RvRsvMfR2zddVKiOfB73QczJAWCKw4iTl2BBnx0pc=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS5PtdqXoh1f9pdbYveiDokTeSGecxJ2u94Jj3DT5 Q+d7TWro5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABMJf8HwvzB9g1apokw/84qa M5dPNl2sZInrqmqPu2s9l+/K32jzvwz/jBUcFnvc4sypuHdcqnuCytzLV5n3Ctiltr/TlUwwsdj KCgA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Avoid duplicated code by adding a helper to get the local phy id.

No functional changes intended.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  7 +++----
 drivers/scsi/pm8001/pm8001_sas.c | 10 ++++++++++
 drivers/scsi/pm8001/pm8001_sas.h |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |  6 ++----
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index fb4913547b00..8005995a317c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4184,10 +4184,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (dev_parent_is_expander(dev))
-		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
+
 	opc = OPC_INB_REG_DEV;
 	linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
 			pm8001_dev->sas_device->linkrate : dev->port->linkrate;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 2bdeace6c6bf..5595913eb7fc 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -130,6 +130,16 @@ static void pm80xx_get_tag_opcodes(struct sas_task *task, int *ata_op,
 	}
 }
 
+u32 pm80xx_get_local_phy_id(struct domain_device *dev)
+{
+	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+
+	if (dev_parent_is_expander(dev))
+		return dev->parent->ex_dev.ex_phy->phy_id;
+
+	return pm8001_dev->attached_phy;
+}
+
 void pm80xx_show_pending_commands(struct pm8001_hba_info *pm8001_ha,
 				  struct pm8001_device *target_pm8001_dev)
 {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 334485bb2c12..91b2cdf3535c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -798,6 +798,7 @@ void pm8001_setds_completion(struct domain_device *dev);
 void pm8001_tmf_aborted(struct sas_task *task);
 void pm80xx_show_pending_commands(struct pm8001_hba_info *pm8001_ha,
 				  struct pm8001_device *dev);
+u32 pm80xx_get_local_phy_id(struct domain_device *dev);
 
 #endif
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 546d0d26f7a1..31960b72c1e9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4797,10 +4797,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (dev_parent_is_expander(dev))
-		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
 
 	opc = OPC_INB_REG_DEV;
 
-- 
2.50.1

