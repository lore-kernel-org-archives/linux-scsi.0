Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87C83CC7;
	Tue, 15 Apr 2025 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676927; cv=none; b=FH+xTznBwWIjCOdJGQajuMMVTPzSyhUh0QuGLUAIoqCfkdGtRHSAZDdLKV96i3U5oVgp4zcRACB7nsL2Lk5B6J2ocfe4iFNAgDRxpHI5JY2lrYZ/7bVUdCfXBcGj7HfdW11ENayxJlV1kcn1LNvzS8GOzCEi2mH4aC31Kjbaad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676927; c=relaxed/simple;
	bh=43ci30IL/3d5OAqA6P7HEpDAL6J/3SN52Y02vIoTNZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sdlvt0AN2fV7LLCVqfihJHPVIREOs0F5dFEm3OdB361j72OEe7W9prL43hmw133RTrdPukGRwHI/w4SoRY4d/YsXkX1kiWBEfx+swdVcOT9TJ64JvynIB7Ddk3M84IKIEUfKUhyK3Yq296wzfk4iBJcAub4ym/aYZhJkZ+xR2gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=m0hR3P2k; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="m0hR3P2k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=6Bto6bxa+eDsKRAjWbdTd9DlRt6aCeBtgQvfcG8fj+o=; b=m0hR3P2kZI2e7CGx
	dvJBF8cndjjv/qzIB/zEgGncuDAKv5llpJdwwDGqgFAuhDIGI0TK//UjHSzBbaV2xgLqcKMg+V+Er
	cZcuOiU5g27pK0B8WqtanBopeNvsxCsnst0qVEcx6rBbpmCUHJtJWDH7Tulu4O0zOiHiYwG2JV6tr
	NFieLtUnkVEnS9dxW3nDQjR0+wm61YgzQfrJUfnF0r8GLhcDBPBRAPYCGgIvWy4IA1LXk6gvfhhGM
	/b+0PttEIiCucRxo1Id+5sL8nOo811wCHuBgD+OjHsZFLCMd/do1CtZ3OdYA3Na0CzBLXiziuguvC
	zgrOz+2idaagCcVAQw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9m-00BSPG-2M;
	Tue, 15 Apr 2025 00:28:06 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 4/8] scsi: qla2xxx: Remove unused qla82xx_pci_region_offset
Date: Tue, 15 Apr 2025 01:27:59 +0100
Message-ID: <20250415002803.135909-5-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qla82xx_pci_region_offset() has been unused since the last use was
removed by 2010's
commit 3711333dfbee ("[SCSI] qla2xxx: Updates for ISP82xx.")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  1 -
 drivers/scsi/qla2xxx/qla_nx.c  | 19 -------------------
 2 files changed, 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e556f57c91af..ad76cf8e123d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -822,7 +822,6 @@ extern int qlafx00_rescan_isp(scsi_qla_host_t *);
 /* PCI related functions */
 extern int qla82xx_pci_config(struct scsi_qla_host *);
 extern int qla82xx_pci_mem_read_2M(struct qla_hw_data *, u64, void *, int);
-extern int qla82xx_pci_region_offset(struct pci_dev *, int);
 extern int qla82xx_iospace_config(struct qla_hw_data *);
 
 /* Initialization related functions */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 6dfb70edb9a6..1da954f446f6 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1595,25 +1595,6 @@ qla82xx_get_fw_offs(struct qla_hw_data *ha)
 	return (u8 *)&ha->hablob->fw->data[offset];
 }
 
-/* PCI related functions */
-int qla82xx_pci_region_offset(struct pci_dev *pdev, int region)
-{
-	unsigned long val = 0;
-	u32 control;
-
-	switch (region) {
-	case 0:
-		val = 0;
-		break;
-	case 1:
-		pci_read_config_dword(pdev, QLA82XX_PCI_REG_MSIX_TBL, &control);
-		val = control + QLA82XX_MSIX_TBL_SPACE;
-		break;
-	}
-	return val;
-}
-
-
 int
 qla82xx_iospace_config(struct qla_hw_data *ha)
 {
-- 
2.49.0

