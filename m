Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D325B2D322E;
	Fri, 14 Aug 2026 05:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686325; cv=none; b=aopYGIAnhDw3U86hcDC4PLHs4QgeagT+FySHLjsMIW3PxFTCWEYem7t0Xd+or2LkOcAI6yJtMHZ/CoaG+lS1b9p9ltOOIQbPKo05YdCklgYF2QzBHUvsu2Td5pltMJ/1Uk8ATCNp11Qx1mLZyJg7LeI+UqZeQf/E+TazNHnr9S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686325; c=relaxed/simple;
	bh=L4Kwm71XFmebDAAxAVPpH3/zXql+a0CCr3yywd4mdVs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FzwF4qwi294NjMxCIOZFRjXbWs1jmJwy0lohUSp4G4UNtC1T/tQZ2sbeogARtjRsUgRuFQAUqt0e+sXmygB8PsqeImY4hmyAPmL53dXpvDJqUMX/DMlo6nbdpsYBnDWXt3l6dVwvbipiEnrX87guP197kZw6KIXtx3QEXqX2Q74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 543419e497a311f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d93b0840-86c2-4400-ae97-23424cea5726,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:fd60620e950140392450f88443cb8632,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 543419e497a311f1aa26b74ffac11d73-20260814
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2127355857; Fri, 14 Aug 2026 13:45:17 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linkai Gong <gonglinkai@kylinos.cn>
Subject: [PATCH] scsi: pmcraid: check device_create() return value
Date: Fri, 14 Aug 2026 13:45:13 +0800
Message-Id: <20260814054513.2519483-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

device_create() can fail after a successful cdev_add(), but the driver
ignored the return value and still reported success. That leaves a
registered char device without its /dev node.

Check the return value, report the error, and unwind the cdev and
minor on failure.

Fixes: 89a368104150 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
---
 drivers/scsi/pmcraid.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a99393204..65a87d30e65f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4721,12 +4721,21 @@ static int pmcraid_setup_chrdev(struct pmcraid_instance *pinstance)
 	pinstance->cdev.owner = THIS_MODULE;
 
 	error = cdev_add(&pinstance->cdev, MKDEV(pmcraid_major, minor), 1);
+	if (error) {
+		pmcraid_release_minor(minor);
+		return error;
+	}
 
-	if (error)
+	error = PTR_ERR_OR_ZERO(device_create(&pmcraid_class, NULL,
+					      MKDEV(pmcraid_major, minor), NULL,
+					      "%s%u", PMCRAID_DEVFILE, minor));
+	if (error) {
+		pmcraid_err("failed to create device file for minor %d, error %d\n",
+			    minor, error);
+		cdev_del(&pinstance->cdev);
 		pmcraid_release_minor(minor);
-	else
-		device_create(&pmcraid_class, NULL, MKDEV(pmcraid_major, minor),
-			      NULL, "%s%u", PMCRAID_DEVFILE, minor);
+	}
+
 	return error;
 }
 
-- 
2.25.1

