Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD36C23A9AD
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085294; cv=none; b=ERVPm/Uo96JEv8UY0V9dljwN0qB0xHpP7zg48BV7aqFsoQR5Uz2JNK+9EXleGnVmlZ8EIjWocd9oZ9sVjgENM4wlFFQJM+JSw9pumUGw3B63jWSKSukVf83ULCYtTrNRA6QqB8ibxzATGeTErpT/PHVsyHleEINWZzDZtj5/kgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085294; c=relaxed/simple;
	bh=5CppmD+nxWwmxlevh8EH2tF6hVQ7prNacoAOT/w/ZNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek2Sz3N+P6ksoR3yRcmuabcGmyendntUnLH90obclrThog5FTar3Qq2X6U/Q3nKauhwK3bHnBvbN/YWr5jfsLi8SepP0TC01wcDQ3z8NNqtsLK1kYUYyx+VuOgN2s1ARrnezH58OoFBc7igtDALM+4VwhAL6ez/Yhblt56PJGrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpWPBa/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpWPBa/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBB8C4CEEB;
	Wed, 13 Aug 2025 11:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085294;
	bh=5CppmD+nxWwmxlevh8EH2tF6hVQ7prNacoAOT/w/ZNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpWPBa/dsWMwXopOCkF/6uuZHinGW4r41LlLxlWi9gqQGa9UZBKtQwui5HNWF5Q2L
	 avwGMqzmyJ5rIi8Z+ToOWY3LfUUsyIBTxBVaUsomEyVSNd12+76UM3xsu+WiloyURT
	 VuWPPJOEgS9HxFy//x/22dIF0ayN7GiBK/1127JGeE3AlNcGk1IX5uLfloLuhL8Ic1
	 0dguqVW71BURTmiGQ4OpOUn3LxIWXjacObp0aMDpEL2YFlpWQj+Qo7AhCSWNd627mF
	 OSDyC6mQJAuuw7YQmDrNC0GgymigDsSd85k3aRIFoAr7wBfB4EDZt3SMuhTbE5rRl2
	 0JH9T7lSEcOpg==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/5] scsi: pm80xx: Add helper function to get the local phy id
Date: Wed, 13 Aug 2025 13:41:10 +0200
Message-ID: <20250813114107.916919-10-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
References: <20250813114107.916919-7-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3746; i=cassel@kernel.org; h=from:subject; bh=5CppmD+nxWwmxlevh8EH2tF6hVQ7prNacoAOT/w/ZNE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVN4Ir95Ree7ZG4ZbJX3W1tbyi0P4OKeErJ1vWV6// NlZ3rnXOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjAR42BGhp7lp5x/dl1PmN77 Jrj5o8fG/v2P5nhwrxI/tWP9y5WzveYz/PfRM+CXrCycW3b1K7vrlxhbac3+uzeagoyK9xrw5Z/ dxAIA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Avoid duplicated code by adding a helper to get the local phy id.

No functional changes intended.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  8 +++-----
 drivers/scsi/pm8001/pm8001_sas.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.h |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |  7 ++-----
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 42a4eeac24c9..5d3b958d1dbb 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4168,7 +4168,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4186,10 +4185,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
+
 	opc = OPC_INB_REG_DEV;
 	linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
 			pm8001_dev->sas_device->linkrate : dev->port->linkrate;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3e1dac4b820f..56d0309d5984 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -130,6 +130,17 @@ static void pm80xx_get_tag_opcodes(struct sas_task *task, int *ata_op,
 	}
 }
 
+u32 pm80xx_get_local_phy_id(struct domain_device *dev)
+{
+	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+	struct domain_device *parent_dev = dev->parent;
+
+	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+		return parent_dev->ex_dev.ex_phy->phy_id;
+	else
+		return pm8001_dev->attached_phy;
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
index c1bae995a412..53f25d1bce74 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4780,7 +4780,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4799,10 +4798,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
-	else
-		phy_id = pm8001_dev->attached_phy;
+
+	phy_id = pm80xx_get_local_phy_id(dev);
 
 	opc = OPC_INB_REG_DEV;
 
-- 
2.50.1

