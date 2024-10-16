Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D49D18E741;
	Wed, 16 Oct 2024 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729060933; cv=none; b=R8s9gwDxwWE9UUA0m7s4o0/rwol//JEjCFhR0e0aIPPy54WbzQREgiQ3M0YqAIXkNudKgjojucK0TdDKlDN2mgSQyapGqjGmgSzjUe/DajZR/985rVsEM13Zia+GNazvTBixzI1PwHOAJf5FA+bUXhEJhLMyA0k1Zg4a7XxdOpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729060933; c=relaxed/simple;
	bh=a76vNnrQ6fKDGQ20IVVMVK3kOk2IR/sqLIEk/A5Ed3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bXywR4sPiPiis1AmNDfNEJ5vhbhceoHFXUBr2tgnpwSX8A2ypThbwRo9eWJi+xyQBa0lAxUAxNs1bQNNyOhhFhz5UkUZY+xHgM8mygGH6k/tCwsT5VjaP3MDwk34REBj450tuIsf2ib4iqnseMyIhBHUQNOkym0BKA100vDKh0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FP1bRo65; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FP1bRo65"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729060931; x=1760596931;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a76vNnrQ6fKDGQ20IVVMVK3kOk2IR/sqLIEk/A5Ed3w=;
  b=FP1bRo65ZPl3aVMOQwrojtoBfXpweTZWSqSRoJuJ/QDl8f4m0H42lYcP
   n91CVQeMwxD9N6bYWPicKwYJ9Qt/2IiDFUzJHrMeGuPnrgiH/D8PkrE5+
   XM2+99WtVhQOK8b48S3ow5f4RPT5HNhcJPukjIxg88ZSUnW5lHEaiDdIC
   bdLDKYJcDnwlPn6tInan9lLl/9Wdp0Z/MQV659bVdaFijHdVUWrIe8fzJ
   CxcBd4n9ptPqVMPEYHDUTjn0BUIlewk6KNfiNhioXe7NfvFIS5jOcmZNa
   UUXTU1eU/+y3AuUPX/JUOLslbKXyv9HUMDSWMxQtMlh4vjsGW5kgVpExN
   g==;
X-CSE-ConnectionGUID: UP9T8TzeSci9cp/JOxaJOA==
X-CSE-MsgGUID: wZUvfPORTNqwAv8t0n4nJw==
X-IronPort-AV: E=Sophos;i="6.11,207,1725292800"; 
   d="scan'208";a="29520901"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2024 14:42:04 +0800
IronPort-SDR: 670f532d_Hmn+mkIbmSiElg25XdAryWy+Mn0w80SVWEzKn1XlZH7Aynf
 oPebTVGTHlrWx45QdgQ/O1PnGPdUxqhX1wR9YJw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2024 22:46:21 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2024 23:42:03 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: Use wait-for-reg in HCE init
Date: Wed, 16 Oct 2024 09:39:50 +0300
Message-Id: <20241016063950.436190-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current so called "inner loop" in ufshcd_hba_execute_hce() is open
coding ufshcd_wait_for_register. Replace it by ufshcd_wait_for_register.
This is a code simplification - no functional change.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v2:
 - Elaborate the commit log (Bart)
 - Change a while-loop into a for-loop (Bart)
---
 drivers/ufs/core/ufshcd.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..7587477d1712 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4818,8 +4818,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_stop);
  */
 static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
-	int retry_outer = 3;
-	int retry_inner;
+	int retry;
 
 start:
 	if (ufshcd_is_hba_active(hba))
@@ -4847,22 +4846,17 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 	ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
 
 	/* wait for the host controller to complete initialization */
-	retry_inner = 50;
-	while (!ufshcd_is_hba_active(hba)) {
-		if (retry_inner) {
-			retry_inner--;
-		} else {
-			dev_err(hba->dev,
-				"Controller enable failed\n");
-			if (retry_outer) {
-				retry_outer--;
-				goto start;
-			}
-			return -EIO;
-		}
-		usleep_range(1000, 1100);
+	for (retry = 3; retry > 0; retry--) {
+		if (!ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE, CONTROLLER_ENABLE,
+					      CONTROLLER_ENABLE, 1000, 50))
+			break;
+		dev_err(hba->dev, "Enabling the controller failed\n");
+		goto start;
 	}
 
+	if (!retry)
+		return -EIO;
+
 	/* enable UIC related interrupts */
 	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
 
-- 
2.25.1

