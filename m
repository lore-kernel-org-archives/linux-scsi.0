Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7D42E36EF
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752771372; cv=none; b=TwjO8ET14qiX7rgiawIryUp4mWFMebMBm1ajuYqT3uNhBxJlRb8hughCoc3cfO1BPQkIFmdh6qRHdV2PL7ZIJHnYqc/Y/QXywXjErAzEBWvLNwjbnMYVgujOiNHWu3h/h6hUK60X87iv5o4ONecMEEywABTmqWCc80VPh0CFPKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752771372; c=relaxed/simple;
	bh=9YzKT/T9GOdEP7OBOyIMoFAvRnV/PAr7pxn01XWTvLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EA1y5u31ZtHMl0+QULQEl62jlEc6opBJQL4ZQQhGSXAvnvvMPtzBDPoeNfsgetk/gBSJO0oa7MtRvE5FgnPjrLwmCWtd8w4lG+PQQ30n4syJICcsljfqG04PCf1qod9mwCkdcoVwGo+p8e9GN4oMvaX81vGvuuFJvtVFpZ+rLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dA3ovLZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dA3ovLZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4630DC4CEE3;
	Thu, 17 Jul 2025 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752771372;
	bh=9YzKT/T9GOdEP7OBOyIMoFAvRnV/PAr7pxn01XWTvLk=;
	h=From:To:Cc:Subject:Date:From;
	b=dA3ovLZOmaNIOMGa0VKL7itT+tHs3Y4Eug5gAHe+hNuoYK1+eHchqseW5tIOII74w
	 g2bxuMTRUyhXxlB53z8uHuRxuBMxh0ed32THHJMnlUAw488t160reATID0mS7fosmt
	 Q9KrzXGd4NCo39m+sgsyM+mqEMkcf22kLc6kI6Jjcwyvw/LrCoaWt64kKWxX+xMhq1
	 ru8L4fRaRRLkJ/QhNHNMUyzY8bv6NHKiyYnkTC9yzZztdtB0HT8S3hDIjQyjH9pIpS
	 hlVT1+oDOHPS6Lyn60Xu4xQm7lRbOG+L/sYyq8QQllnelxV6XLri8Wn/V1RvA4Mmxe
	 nlrq5C5iNcEPg==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
Date: Thu, 17 Jul 2025 18:56:07 +0200
Message-ID: <20250717165606.3099208-2-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5611; i=cassel@kernel.org; h=from:subject; bh=9YzKT/T9GOdEP7OBOyIMoFAvRnV/PAr7pxn01XWTvLk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDIqtdW439m6rdsq+ak/Ynefsys/WzbPgcl1/w/dm/7Q1 2DVn+lJHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjIm4WMDLNNZ9y71TUtls33 iPeLkoKdTbN4fSeGNjmck5vFq15Uv4zhn4KCZn5UZLR8yJzvQSYM33f+lNdqvcjcnbx7reDchoe JXAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2.

Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
drives behind a SAS enclosure (which is connected to one of the ports
on the HBA) to no longer be detected.

Connecting the drives directly to the HBA still works. Thus, the commit
only broke the detection of drives behind a SAS enclosure.

Reverting the commit makes the drives behind the SAS enclosure to be
detected once again.

The commit log of the offending commit is quite vague, but mentions that:
"Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
to get the port ID."

This assumption appears false, thus revert the offending commit.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
dmesg after the offending commit, in case anyone is interested:
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 2
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x2
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 3
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x3
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 4
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x4
pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x4 port_id:0x0
sas: phy-11:4 added to port-11:0, phy_mask:0x10 (50015b21409aefbf)
sas: DOING DISCOVERY on port 0, pid:215
pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16385
sas: executing SMP task failed:-19
sas: RG to ex 50015b21409aefbf failed:0xffffffed
pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16385
sas: DONE DISCOVERY on port 0, pid:215, result:-19
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 5
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x5
pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x5 port_id:0x0
sas: phy5 matched wide port0
sas: phy-11:5 added to port-11:0, phy_mask:0x30 (50015b21409aefbf)
sas: DOING DISCOVERY on port 0, pid:277
pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16386
sas: executing SMP task failed:-19
sas: RG to ex 50015b21409aefbf failed:0xffffffed
pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16386
sas: DONE DISCOVERY on port 0, pid:277, result:-19
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 6
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x6
pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x6 port_id:0x0
sas: phy6 matched wide port0
sas: phy-11:6 added to port-11:0, phy_mask:0x70 (50015b21409aefbf)
sas: DOING DISCOVERY on port 0, pid:277
pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16387
sas: executing SMP task failed:-19
sas: RG to ex 50015b21409aefbf failed:0xffffffed
pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16387
sas: DONE DISCOVERY on port 0, pid:277, result:-19
pm80xx0:: pm80xx_chip_phy_start_req 4641: PHY START REQ for phy_id 7
pm80xx0:: mpi_phy_start_resp 3340: phy start resp status:0x0, phyid:0x7
pm80xx0:: mpi_hw_event 3417: HW_EVENT_SAS_PHY_UP phyid:0x7 port_id:0x0
sas: phy7 matched wide port0
sas: phy-11:7 added to port-11:0, phy_mask:0xf0 (50015b21409aefbf)
sas: DOING DISCOVERY on port 0, pid:215
pm80xx0:: pm80xx_chip_reg_dev_req 4742: register device req phy_id 0x0 port_id 0x0
pm80xx0:: pm8001_mpi_reg_resp 3309: register device status 0 phy_id 0x0 device_id 16388
sas: executing SMP task failed:-19
sas: RG to ex 50015b21409aefbf failed:0xffffffed
pm80xx0:: pm8001_chip_dereg_dev_req 4226: unregister device device_id 16388
sas: DONE DISCOVERY on port 0, pid:215, result:-19

 drivers/scsi/pm8001/pm8001_sas.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f7067878b34f..8cfdfb77d9b0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -431,6 +431,23 @@ static int pm8001_task_prep_ssp(struct pm8001_hba_info *pm8001_ha,
 	return PM8001_CHIP_DISP->ssp_io_req(pm8001_ha, ccb);
 }
 
+ /* Find the local port id that's attached to this device */
+static int sas_find_local_port_id(struct domain_device *dev)
+{
+	struct domain_device *pdev = dev->parent;
+
+	/* Directly attached device */
+	if (!pdev)
+		return dev->port->id;
+	while (pdev) {
+		struct domain_device *pdev_p = pdev->parent;
+		if (!pdev_p)
+			return pdev->port->id;
+		pdev = pdev->parent;
+	}
+	return 0;
+}
+
 #define DEV_IS_GONE(pm8001_dev)	\
 	((!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED)))
 
@@ -503,10 +520,10 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
 	pm8001_dev = dev->lldd_dev;
-	port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
+	port = &pm8001_ha->port[sas_find_local_port_id(dev)];
 
 	if (!internal_abort &&
-	    (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
+	    (DEV_IS_GONE(pm8001_dev) || !port->port_attached)) {
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		if (sas_protocol_ata(task_proto)) {
-- 
2.50.1

