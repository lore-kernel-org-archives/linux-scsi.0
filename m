Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4CB442F;
	Tue, 15 Oct 2024 04:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728968362; cv=none; b=aN2QP3EhzEcOs/EJ0gDJ7vOEer5eZwjPtHc3Js6V7rDUEkNUgtrDbeN9r7z/jAbkwMOKJnYdh3NslimYwXdBJu4tlNYHlx2WAdKUdNzx8dxNZ0OB8dZIriWpU1LzG9iC+lTIyqMh5jwgpPbV55lPeeHwgmGOYGzD8ac9QIckKhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728968362; c=relaxed/simple;
	bh=XFugerY3y5irdTOz31VIwqmf/328N1n+8mSFvShFKc4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KwiRFdruNt0p365UZOBUaP/vo0kg5R43TnSxM62WmhNVCSgN5DrESQKeth3vBfQs64ebeo1PYoNqESc9z2MG/C15kEJEClyqt7oVvGPHOHARl3vgDqMD8EY7ngWIoZosX44xZtpuy4ceYv49/R157DjskiGP3TTLWcXakbgmnNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TzjQcEEO; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TzjQcEEO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728968361; x=1760504361;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XFugerY3y5irdTOz31VIwqmf/328N1n+8mSFvShFKc4=;
  b=TzjQcEEOqyU08B80mqxq6kuqo2wAnzCarxAHME21q2aC3ZpjzV4TBm1n
   gVTSOftkH3cSdptE6Ken3+gPD/dGAun3BLw/+z1czUjJHrR9g3N3b00Xt
   DiSR3veXEp0kUyVOIzluWLwdw59qOlHHpi0gK4vXw6EYFRdpMDSIBE5en
   x5S2yKBK7RC8aNzaw4KTEmDgV5Cacycp/oZeHD6I3bPWxwrvfnHcVUn1z
   CJVHhYgriOFZFqTh5izjHi6SQYsCxPxbUvvpxLqi5MHssWlkfciXOhPuS
   88ZDtaODC04O36gerWGzpdr8hazJfDZQYZVunS5sghD3oaWm/8U/P0R+s
   g==;
X-CSE-ConnectionGUID: gMsMZGvgQf6ZnTyZqKrWEA==
X-CSE-MsgGUID: t9zoLfUoQPmujMognTa86g==
X-IronPort-AV: E=Sophos;i="6.11,204,1725292800"; 
   d="scan'208";a="29055186"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Oct 2024 12:59:13 +0800
IronPort-SDR: 670de851_H+FJSLQ4nCyn5wKMhAcoxb9FVdzAkCXDwOP2JZsafGfeBrh
 AyZRqjD67olZhN0nsIiajlJTBEnCoJ725sHwYng==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2024 20:58:10 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Oct 2024 21:59:12 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Use wait-for-reg in HCE init
Date: Tue, 15 Oct 2024 07:57:11 +0300
Message-Id: <20241015045711.394434-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of open-coding it.  Code simplification - no functional change.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..f23d37c227e1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4818,8 +4818,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_stop);
  */
 static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 {
-	int retry_outer = 3;
-	int retry_inner;
+	int retry = 3;
 
 start:
 	if (ufshcd_is_hba_active(hba))
@@ -4847,22 +4846,20 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 	ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
 
 	/* wait for the host controller to complete initialization */
-	retry_inner = 50;
-	while (!ufshcd_is_hba_active(hba)) {
-		if (retry_inner) {
-			retry_inner--;
+	while (retry) {
+		if (!ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE, CONTROLLER_ENABLE,
+					      CONTROLLER_ENABLE, 1000, 50)) {
+			break;
 		} else {
-			dev_err(hba->dev,
-				"Controller enable failed\n");
-			if (retry_outer) {
-				retry_outer--;
-				goto start;
-			}
-			return -EIO;
+			dev_err(hba->dev, "Controller enable failed\n");
+			retry--;
+			goto start;
 		}
-		usleep_range(1000, 1100);
 	}
 
+	if (!retry)
+		return -EIO;
+
 	/* enable UIC related interrupts */
 	ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
 
-- 
2.25.1

