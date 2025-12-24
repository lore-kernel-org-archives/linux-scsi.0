Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554A32D0605;
	Wed, 24 Dec 2025 08:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766564762; cv=none; b=AM9bn4EoYLrGB8TYIk11vbc4ItyIvoJ8bHjW7c8UM2MVqZvysUiB51OWBNXQl3tmIS1jUCjVydTFQl/jg271vaOcCUtwOv8W2HKLrEOBLagmCOk1afXc80p0LEVqBPr/cv0mETFwhMq1gTbUBZhXwok2bkL7o+1vjzaixUO2fP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766564762; c=relaxed/simple;
	bh=OOfrTiXAxe9NjHol1NGSyb8Q57WWbU56sf8YNa8NA2A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u7vEwpBJvF/tmfAHaWJQuHGCTYT/Hm3aDZig8dsn0XKli41Xr+vPRpyB9iL6TnHVOCO4afsr9eAi3pdqWM3ETbtxRtQL4c3abQBZT58jqHT2DFH3D/ZAja/8kTsHcp4VV1HYBzvTjsdkRLcFDZexTl1NwkqMJq9DZy7/HsjFrzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn; spf=pass smtp.mailfrom=isrc.iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=isrc.iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isrc.iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.209])
	by APP-05 (Coremail) with SMTP id zQCowACnOAyHo0tpFMrBAQ--.11256S2;
	Wed, 24 Dec 2025 16:25:44 +0800 (CST)
From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
To: njavali@marvell.com,
	mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	jthumshirn@suse.de,
	adheer.chandravanshi@qlogic.com,
	hare@suse.de,
	saurav.kashyap@cavium.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: [PATCH] scsi: qedi: fix memory leaks on error path in __qedi_probe()
Date: Wed, 24 Dec 2025 16:25:42 +0800
Message-Id: <20251224082542.1562004-1-lihaoxiang@isrc.iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnOAyHo0tpFMrBAQ--.11256S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4UZw1rXr1kuFWfZr45trb_yoW8Gw4fpr
	s3X3s2kr45Gry3uFnrJ3WUXF1Yg3y0qFW5CrW7Kw45X3W3C3yDtr1xCa42qFy7GFZ7Xr12
	ywnrtFyUCa9rJ3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 5olkt0x0ld0ww6lv2u4olvutnvoduhdfq/1tbiCQ4GE2lLmkQGgAABsp

Add qedi_cm_free_mem() and qedi_free_itt() on error path in
__qedi_probe() to prevent memory leaks.

Found by code review and compiled on ubuntu 20.04.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
---
 drivers/scsi/qedi/qedi_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 56685ee22fdf..805078205ef1 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2754,7 +2754,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		if (rc) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Could not alloc itt memory\n");
-			goto free_cid_que;
+			goto free_cm_mem;
 		}
 
 		sprintf(host_buf, "host_%d", qedi->shost->host_no);
@@ -2764,7 +2764,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start tmf thread!\n");
 			rc = -ENODEV;
-			goto free_cid_que;
+			goto free_itt_mem;
 		}
 
 		qedi->offload_thread = alloc_workqueue("qedi_ofld%d",
@@ -2800,6 +2800,10 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 
 free_tmf_thread:
 	destroy_workqueue(qedi->tmf_thread);
+free_itt_mem:
+	qedi_free_itt(qedi);
+free_cm_mem:
+	qedi_cm_free_mem(qedi);
 free_cid_que:
 	qedi_release_cid_que(qedi);
 free_uio:
-- 
2.25.1

