Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623633E348;
	Fri, 17 Jul 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302791; cv=none; b=DQDWIwgCzmVUBnipa5J7MQmEr74oUc00Ab/fMu5MtmkW2yeggDe8YdyNcPZH6kK+Q5LCHT4+jxCGik7iwphssLF3NYJlCamTuhdtwzdWDvWEhQ8SsAfKhZTPo2/6BHHK2nRr9j1L8U9NaesnpfFooBoIHS7TOxFVJrbZGhEd5BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302791; c=relaxed/simple;
	bh=Z6oh0Aq5J0HC92QSmxmgcuwDkCdEfj4l2FJAyi1z5Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na8ZnpSnmbLKklTW2jjvO65hv8qvcZMXazpXsQsv9E3boYHx873STuFUcKAXsWaUkTc7WW3Zvv+APfRWx9nvljtxJD/0eHgu2oilAEq33G/hw+7eLCvdXJXGyq2ziPTHgUYsXRSL4Qv1tNG/8L1pC8uy7QXrDKFPLgny5x0vGmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b80c4c8481f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:33fca415-e321-4e80-9423-80f37d191bf8,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:33fca415-e321-4e80-9423-80f37d191bf8,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:ce9d4801fc87a208fe06f4bc3542b35d,BulkI
	D:260717233941M7C6XWU3,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b80c4c8481f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1100195280; Fri, 17 Jul 2026 23:39:37 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH v2 6/6] scsi: ufs: debugfs: Reserve space for a string terminator
Date: Fri, 17 Jul 2026 23:39:13 +0800
Message-ID: <20260717153914.26321-7-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufs_saved_err_write() copies user input into a zero-initialized stack
buffer and passes it to kstrtoint(). A write that fills the entire
buffer overwrites its only terminator.

Reject an input whose length leaves no room for the trailing NUL.

Fixes: 7340faae9474 ("scsi: ufs: core: Add debugfs attributes for triggering the UFS EH")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufs-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3dd81d6fe82..be527209540d 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -165,7 +165,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 	char val_str[16] = { };
 	int val, ret;
 
-	if (count > sizeof(val_str))
+	if (count >= sizeof(val_str))
 		return -EINVAL;
 	if (copy_from_user(val_str, buf, count))
 		return -EFAULT;
-- 
2.43.0

