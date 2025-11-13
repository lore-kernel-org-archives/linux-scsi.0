Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B462E9749;
	Thu, 13 Nov 2025 15:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763046606; cv=none; b=LzK8YR9ZKv7vOb5YR4qMMlGmXsL3V1bWp2l9LdKDkf1i8ce39aKouuyi1Aha5jm+e5YAOpxfVoQVfdUsT81fjoX/Y3WbkLmCJJy+5nT9wG1tB97lttUyv3J/IJII4BdSPEhij+eg+Yd+GsLy5/f6kI7heyJcWfsKGCCYEdpy3WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763046606; c=relaxed/simple;
	bh=vi+LyETqpSGvjke/7Br6KgKKQXb9QDeOQwrjW7h5hug=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ueKR863OjZtP3wPhI19sQ+/yNz0eT5M2zksd7dhw0dM2DBSPD+r636QsXMmK9lv47unWw0q5gNEurKxNuyzL3dK/oeQhihWQ4Voet9IIo/AZx3QzIrVDaat4IL77t4JZNCOz1LT2f8N50qlIN5m5MwapK5jafEXuuu7fo+4aXwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=TZ9zQFz4; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="TZ9zQFz4"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 297e69a6a;
	Thu, 13 Nov 2025 23:09:59 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] scsi: mvumi: Fix memory leak in mvumi_probe_devices()
Date: Thu, 13 Nov 2025 15:09:34 +0000
Message-Id: <20251113150934.758067-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a7dc4286c03a1kunm5605d43d14a3a1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGBlOVhgZTxodHhoaSkJIS1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=TZ9zQFz4AyyT0TiHT6M8K0LqwGXd/WPi/mAVcAQNVfSiVasDNuKmCjkk33Va3mSLz7ra4nsBfHF39/rCv9CKPtQnP5R5Du26pCxUAR4TwZw2VEVAPLFin2D6tOCN+F9zTugdSGpUG1uaZSMI6FV3V3qUbv3y+CtSScFsatmG3bU=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=0t7k+O2CxwdjkOom484ODUoUSay3YPDNbL2zPq28a14=;
	h=date:mime-version:subject:message-id:from;

In mvumi_probe_devices(), an internal command cmd is allocated via
mvumi_create_internal_cmd() at the beginning of the function.

This command is used within a loop that calls mvumi_match_devices(). If
a device conflict is detected, the function exits immediately without
freeing the cmd allocated at the start, leading to a memory leak.

Fix this by calling mvumi_delete_internal_cmd() to release the command
before returning in this error path.

Fixes: bd756ddea18e0 ("[SCSI] mvumi: Add support for Marvell SAS/SATA RAID-on-Chip(ROC) 88RC9580")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/mvumi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index bdc2f2f17753..9a721608ccea 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1589,10 +1589,12 @@ static int mvumi_probe_devices(struct mvumi_hba *mhba)
 				dev_dbg(&mhba->pdev->dev,
 					"probe a new device(0:%d:0)"
 					" wwid(%llx)\n", id, mv_dev->wwid);
-			} else if (found == -1)
+			} else if (found == -1) {
+				mvumi_delete_internal_cmd(mhba, cmd);
 				return -1;
-			else
+			} else {
 				continue;
+			}
 		}
 	}
 
-- 
2.34.1

