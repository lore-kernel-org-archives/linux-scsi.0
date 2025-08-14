Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4172566E9
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192772; cv=none; b=QskUkvwFY15/Z8/J7mueu/hQpvmXdaHxGA7SJij/zB95uqGvqFYMMqPcXciBG8zElBoT7XfypvXyUGWc+Xaq2UBj9V+iDHM+mcxj6R/5GVN8ussGpuo2w/34EqMsCeNWMhwdzfovbug9l1/M96mElo0seg1lugXOdEisAoP4920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192772; c=relaxed/simple;
	bh=58HAYWEES4RX0VMIWrx/mUTOwzsCCU6NYrdVp4A1GKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzmZ3havMiJVjoQExIlUNuDZWdBPIau+/pv+Vgw7CrtD+DmoS1QC1rP5ju++ta/wA0U17uYJpcOcXSkywHvUdMDWdIAbW53U/98Ui/e0B/KRuLtA/4xxy96WMExnEfgTlb//WfOIn0O9s8/57GW4bU5qknclL8yvDut6phveqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSl30IeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSl30IeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA6DC4CEED;
	Thu, 14 Aug 2025 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192771;
	bh=58HAYWEES4RX0VMIWrx/mUTOwzsCCU6NYrdVp4A1GKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSl30IeSn4GwJsQmTwS1Lz4LlJFZiFtwWNbLzGSr7oHyUctrm/EuAvf5bgBAWCABf
	 ENONJmaJ4tJXFnKZ5UtvQuhTocEOjCn0DBgXQ81jn5srMjA09IBia8wQ91Rlv9wGDg
	 vWMdqpScADotzFeH0m5IZZvgJ7ktHdKVMDH7NETWOnQTd5GI8aBmsbibJMX2VrelEl
	 gl4PRmYfjMOI0Yx2nl5eXacQsecnOW+pGQ8dY0UDKV/z71lO+2gsR+qUhbIM3JeJQ6
	 KJ6KdmAOuY+ZYoQJcth9oeSYw7pKdKJYjC4B7rMLBZmh0Nijjo+W0RbbrnRiVjp0Cy
	 7p+m2U8gRxP2A==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 07/10] scsi: pm80xx: Use dev_parent_is_expander() helper
Date: Thu, 14 Aug 2025 19:32:22 +0200
Message-ID: <20250814173215.1765055-19-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4654; i=cassel@kernel.org; h=from:subject; bh=58HAYWEES4RX0VMIWrx/mUTOwzsCCU6NYrdVp4A1GKY=; b=kA0DAAoWyWQxo5nGTXIByyZiAGieHaegcjIA6yElCI5ab6THkjRaLV2WyL6T2Y3+P/NrQM60X Yh1BAAWCgAdFiEETfhEv3OLR5THIdw8yWQxo5nGTXIFAmieHacACgkQyWQxo5nGTXLwHgD5AWPS u00/EKEqkM06uTz8Wjm4Us68Bwer0Rw0yQqIJ0UBALMeqngeRJhWfPv9AVDjevl1YpZMhEvg9QW /Mx/pK7EI
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Make use of the dev_parent_is_expander() helper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 8 +++-----
 drivers/scsi/pm8001/pm8001_sas.c | 5 ++---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 42a4eeac24c9..fb4913547b00 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2163,8 +2163,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
-		if (!((t->dev->parent) &&
-			(dev_is_expander(t->dev->parent->dev_type)))) {
+		if (!dev_parent_is_expander(t->dev)) {
 			for (i = 0, j = 4; j <= 7 && i <= 3; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0, j = 0; j <= 3 && i <= 3; i++, j++)
@@ -4168,7 +4167,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4186,8 +4184,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
+	if (dev_parent_is_expander(dev))
+		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
 	opc = OPC_INB_REG_DEV;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3e1dac4b820f..2bdeace6c6bf 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -700,7 +700,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 	dev->lldd_dev = pm8001_device;
 	pm8001_device->dev_type = dev->dev_type;
 	pm8001_device->dcompletion = &completion;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(dev)) {
 		int phy_id;
 
 		phy_id = sas_find_attached_phy_id(&parent_dev->ex_dev, dev);
@@ -749,7 +749,6 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	unsigned long flags = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
-	struct domain_device *parent_dev = dev->parent;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -771,7 +770,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		 * The phy array only contains local phys. Thus, we cannot clear
 		 * phy_attached for a device behind an expander.
 		 */
-		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
+		if (!dev_parent_is_expander(dev))
 			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c1bae995a412..546d0d26f7a1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2340,8 +2340,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
-		if (!((t->dev->parent) &&
-			(dev_is_expander(t->dev->parent->dev_type)))) {
+		if (!dev_parent_is_expander(t->dev)) {
 			for (i = 0, j = 4; i <= 3 && j <= 7; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0, j = 0; i <= 3 && j <= 3; i++, j++)
@@ -4780,7 +4779,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4799,8 +4797,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
+	if (dev_parent_is_expander(dev))
+		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
 
-- 
2.50.1

