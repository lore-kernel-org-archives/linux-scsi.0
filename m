Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097C0438026;
	Thu, 13 Aug 2026 07:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786605995; cv=none; b=aylOROA9uFbff9vYfda2PKxYnIBhGTQrSa5tAXbSQRLIpi3gVZoq7XnLYHT7jEvs3dgMSMjh+0NkAxgLjctGvdGnCQUtk89W6kGPIber6mGdCWPZzOeQtsdRLle83hmQA85A+vkJtYIJhgUuVfpmTP0ZbLeDKo1xHbabs2COlLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786605995; c=relaxed/simple;
	bh=WKH/3eEuXjlh+u8ooFdTalPX0bMs7lVnXArbn+8yhfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o1PzEfJl2S2B+7BtpLz7fB/IQltL32Ed45HKvQgv4oCt5BaHyxWXBXPX4Wr2rj5K7c9gyqp0uXUh4DQtP/OCKQ8csHx/HBFi/SlQ6IOQ7wXAvM3UOQqe2q6uGTd46OG78JvCvDMc3R3TcIhZQjLKk5+zqnAeGjRwMWL9tkNLAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 483d15d496e811f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3bb6d5e6-a0a0-466c-aaad-2ad701375069,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e7bac3a,CLOUDID:64c606f4a02f70eb861908678d994b14,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 483d15d496e811f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 164138877; Thu, 13 Aug 2026 15:26:21 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH v2 1/2] scsi: leapraid: balance host references for firmware log VMAs
Date: Thu, 13 Aug 2026 15:26:13 +0800
Message-Id: <20260813072614.1387555-2-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813072614.1387555-1-lilinmao@kylinos.cn>
References: <20260813072614.1387555-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

leapraid_fw_mmap() keeps the Scsi_Host reference obtained while
looking up the adapter for the lifetime of the initial VMA.  The VMA
close callback drops that reference.

The open callback is also invoked when a VMA is duplicated or split,
but it only increments mmap_refcnt.  Since every corresponding close
callback drops a host reference, cloning the mapping can release the
host while another VMA still refers to the adapter.

Take a host device reference for every VMA open and release the lookup
reference once the initial mapping has acquired its own reference.  Use
get_device() because a VMA can be cloned after the host enters SHOST_DEL;
an existing VMA still pins the host at that point and open cannot fail.

Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/scsi/leapraid/leapraid_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
index 742f19c07fcbb..841027ce2501c 100644
--- a/drivers/scsi/leapraid/leapraid_app.c
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -697,6 +697,7 @@ static void leapraid_fw_mmap_open(struct vm_area_struct *vma)
 	if (!adapter)
 		return;
 
+	get_device(&adapter->shost->shost_gendev);
 	atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
 }
 
@@ -767,7 +768,6 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_private_data = adapter;
 	vma->vm_ops = &leapraid_fw_mmap_vm_ops;
 	leapraid_fw_mmap_open(vma);
-	adapter = NULL;
 
 	rc = 0;
 out_put:
-- 
2.25.1

