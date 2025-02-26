Received: from out30-65.freemail.mail.aliyun.com (out30-65.freemail.mail.aliyun.com [115.124.30.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A0E5028C;
	Wed, 26 Feb 2025 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553090; cv=none; b=CMKhuRNeWoy8Yx9H9UoOpam3uS1lYoOjiQfAeEqJLQ69FNyap58oKedrd76TKsxlFLfxbzVSRNOvJtStJct4QY/YBplg1hUXEPfbD34plrU1tcASrGLuwFFrcyeXYWSj3VPRxeDsYVGgSc7yxT6DPbAnnBeGP5wOe0Uti7e6MgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553090; c=relaxed/simple;
	bh=ZsjxukEOVO5ffJ4Zs95qYyTWGKODiQNlo9YbGYFgp5c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jPunHAosB+374UCzXYUR50whuaKEZkqhEVA8fywZcmeLpy5D9jKEXUmMcYCJn2lvZK4IgMJfDDBnfXj+w8fB1Skvkza11P40jg7cMG5XN4E3gqTrnS/qdlhX1KYkq3CiVEj6jeXcL9IvEnPTGyn7Jo0Ua7aBZa5WRB2WPmZdPh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=QI5nX0oX; arc=none smtp.client-ip=115.124.30.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="QI5nX0oX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1740553085; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=OxTo/iZCIK2ZpxP5h1M2T78BxTicPNxmRSp03rqcnX8=;
	b=QI5nX0oXvc9YuStyjWUKIbPG4KO3kXgPkN+TNV7L/Vi1OBo4bnLsW+lof0cBzonu/cZ7njkW2q56OG2JFnogNf69bmyKw4kr80/D0UvhSh7CNWYJWDTqCfLaQPxgOkXU3wkq32QMDOSfi6P9/QgeAdgah8ZmVxr/fmc3qg1lPro=
Received: from wdhh6.sugon.cn(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WQHDN2c_1740553084 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Feb 2025 14:58:05 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH] scsi: stop judging after finding a VPD page expected to be processed.
Date: Wed, 26 Feb 2025 14:58:02 +0800
Message-Id: <20250226065802.234144-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the vpd_buf->data[i] is expected to be processed, stop other
judgments.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/scsi.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a77e0499b738..53daf923ad8e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -510,22 +510,34 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 		return;
 
 	for (i = 4; i < vpd_buf->len; i++) {
-		if (vpd_buf->data[i] == 0x0)
+		switch (vpd_buf->data[i]) {
+		case 0x0:
 			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
-		if (vpd_buf->data[i] == 0x80)
+			break;
+		case 0x80:
 			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
-		if (vpd_buf->data[i] == 0x83)
+			break;
+		case 0x83:
 			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
-		if (vpd_buf->data[i] == 0x89)
+			break;
+		case 0x89:
 			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
-		if (vpd_buf->data[i] == 0xb0)
+			break;
+		case 0xb0:
 			scsi_update_vpd_page(sdev, 0xb0, &sdev->vpd_pgb0);
-		if (vpd_buf->data[i] == 0xb1)
+			break;
+		case 0xb1:
 			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
-		if (vpd_buf->data[i] == 0xb2)
+			break;
+		case 0xb2:
 			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
-		if (vpd_buf->data[i] == 0xb7)
+			break;
+		case 0xb7:
 			scsi_update_vpd_page(sdev, 0xb7, &sdev->vpd_pgb7);
+			break;
+		default:
+			break;
+		}
 	}
 	kfree(vpd_buf);
 }
-- 
2.34.1

