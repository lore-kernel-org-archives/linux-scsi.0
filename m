Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F9145948
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192766; cv=none; b=JZ79kdnK5BEhdaWDPxgrpXevWin9hDlJnQVdHYL8Rmgsg1RGaGSZahH8TEYYdgpqvevV2kp9f2w9tNBLZ0OMEZ8P4TPgHoWADewZWavxfWiI8eb96+0HWEu5bbveNmMJ2SoNyc4TK+QhQ1RwioWJ8DzqsRWy1kGO3Dxf5Ct4uCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192766; c=relaxed/simple;
	bh=jQWaGl10rvUi3VUsLwcvGRmxHIUMzMKyEgwOaVqROjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPM8GF9Hsq22Ja+Lj+k2/iZ6RP9bDsmI181iMezigpWqahhufY2pwISsNiJrqge1R7w4dR/U5WSD1KOAkTYj4U4sv5B/g8I2HoATTaBe1Vkff/E70wLo+fbi88pUC+o1KdXvhSLlP5eIDTSO0dFZWhlykWead4yQ9f8GyqVIA+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0qK/Z+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0qK/Z+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02DEC4CEED;
	Thu, 14 Aug 2025 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192765;
	bh=jQWaGl10rvUi3VUsLwcvGRmxHIUMzMKyEgwOaVqROjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0qK/Z+VFIYilzmCybetpbNxz/PIDMJsnvrDijNjJHE2UamuhsyRFiShb3wCUh1r7
	 O6Ik5jo0EUxNsvDjwWfKG5vmYbRfkTT9OliDpn1jxPCEJc7KE9pIU3mxJQlTfld18o
	 faff9G5gxdQH9WEDdFhGg/ifrb72qjXlqHD8qlim5HQb60obEAopINdlxdP0LzyUBG
	 6CjZjUpmju5Rf3uaMuWst6PKjCrScQKbYGDp4zBsmxjKH/wIdYHWKwZBtvhugil4QL
	 OaQHrpbWpK7bPoefjGqBQKoayrLcH1s2vt3o0stl6Gxox197POsw0frnuLKTWxk1pR
	 vRNxpoUOWb6/g==
From: Niklas Cassel <cassel@kernel.org>
To: Yihang Li <liyihang9@h-partners.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 04/10] scsi: hisi_sas: Use dev_parent_is_expander() helper
Date: Thu, 14 Aug 2025 19:32:19 +0200
Message-ID: <20250814173215.1765055-16-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4359; i=cassel@kernel.org; h=from:subject; bh=jQWaGl10rvUi3VUsLwcvGRmxHIUMzMKyEgwOaVqROjA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS5bvv7Yu0DRPpmlTCoTEqwfeXF+OiRilmh44tNLh z2pVsIrOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRmgyGf6Y9C6u79dY3L4z0 Kgtn2VDm9mf/Wsbl171DPys/CJV9wczI8NJ+evOES6eY72ifkPzMyKXn8f6Y2temRQkzjl7+n3L qJi8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Make use of the dev_parent_is_expander() helper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 ++----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d1a4cc69d408..30a9c6612651 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -876,7 +876,7 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	device->lldd_dev = sas_dev;
 	hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
 
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(device)) {
 		int phy_no;
 
 		phy_no = sas_find_attached_phy_id(&parent_dev->ex_dev, device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 4431698a5d78..f3516a0611dd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -925,7 +925,6 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 	struct device *dev = hisi_hba->dev;
 	u64 qw0, device_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
-	struct domain_device *parent_dev = device->parent;
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	u64 sas_addr;
@@ -942,7 +941,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PENDING:
-		if (parent_dev && dev_is_expander(parent_dev->dev_type))
+		if (dev_parent_is_expander(device))
 			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
 		else
 			qw0 = HISI_SAS_DEV_TYPE_SATA << ITCT_HDR_DEV_TYPE_OFF;
@@ -2494,7 +2493,6 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 {
 	struct sas_task *task = slot->task;
 	struct domain_device *device = task->dev;
-	struct domain_device *parent_dev = device->parent;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
 	struct asd_sas_port *sas_port = device->port;
@@ -2509,7 +2507,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	/* create header */
 	/* dw0 */
 	dw0 = port->id << CMD_HDR_PORT_OFF;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(device)) {
 		dw0 |= 3 << CMD_HDR_CMD_OFF;
 	} else {
 		phy_id = device->phy->identify.phy_identifier;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2f3d61abab3a..2f9e01717ef3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -874,7 +874,6 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 	struct device *dev = hisi_hba->dev;
 	u64 qw0, device_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
-	struct domain_device *parent_dev = device->parent;
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
 	u64 sas_addr;
@@ -891,7 +890,7 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PENDING:
-		if (parent_dev && dev_is_expander(parent_dev->dev_type))
+		if (dev_parent_is_expander(device))
 			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
 		else
 			qw0 = HISI_SAS_DEV_TYPE_SATA << ITCT_HDR_DEV_TYPE_OFF;
@@ -1476,7 +1475,6 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 {
 	struct sas_task *task = slot->task;
 	struct domain_device *device = task->dev;
-	struct domain_device *parent_dev = device->parent;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
 	struct asd_sas_port *sas_port = device->port;
@@ -1487,7 +1485,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	u32 dw1 = 0, dw2 = 0;
 
 	hdr->dw0 = cpu_to_le32(port->id << CMD_HDR_PORT_OFF);
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(device)) {
 		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
 	} else {
 		phy_id = device->phy->identify.phy_identifier;
-- 
2.50.1

