Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8233DC4AB;
	Mon, 27 Jul 2026 09:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785143871; cv=none; b=SThJz3CvcTXKLDfSZ8PiMjcUPchvY9bOKzn6bVVjuYjYFeWm1tlFlltdcwBHbiBmx6ge03kqR88ft9bq1O0zr0PBirBt+EchvNHkLorLwj6f0yHexM1KVHIsuvUiBkuvJ/LNxEqlXvHWu3i8t9Mv2aKUAI7pyDBbR0KrwOeRaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785143871; c=relaxed/simple;
	bh=BAsz4AHuzonWAltgNqSLKhvKG4377xkRpdmA5hVV8II=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TkrJ/JrAwvBXKoLeltEuxZ3FjpE52mIWPqw7LW0UGIJifRgdO6F5x9dJlEb/lOQvliA4J00yxilhyk3j24Hzfu20YY2w9WOtoBSsQAOEtL8owIA9Z7JTNm6aVBC4jHtUSdT6kHOX33NW3RiqdySCSPOyKx5VpPYTVhoPSWBNscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 03beba24899c11f1aa26b74ffac11d73-20260727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2eb1d280-2502-490c-a921-6c13a071825b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:52aa5c6158f3a53ea9580efb30b04685,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 03beba24899c11f1aa26b74ffac11d73-20260727
X-User: chenchangcheng@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <chenchangcheng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 751628676; Mon, 27 Jul 2026 17:17:39 +0800
From: Chen Changcheng <chenchangcheng@kylinos.cn>
To: ram.vegesna@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH] scsi: elx: Fix memory leak on scsi_add_host_with_dma failure
Date: Mon, 27 Jul 2026 17:17:36 +0800
Message-Id: <20260727091736.276482-1-chenchangcheng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If scsi_add_host_with_dma() fails in efct_scsi_new_device() or
efct_scsi_new_vport(), the Scsi_Host allocated by scsi_host_alloc()
is never released, causing a memory leak.

The caller's error path has no knowledge of this internal allocation:
 - efct_scsi_new_device's caller (efct_xport_initialize) only frees
   the xport structure, not the Scsi_Host.
 - efct_scsi_new_vport's caller chain (efct_vport_create ->
   fc_vport_setup) only cleans up the fc_vport structure itself,
   not the vport's Scsi_Host allocated inside efct_scsi_new_vport.

Add the missing scsi_host_put() calls before each error return.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
---
 drivers/scsi/elx/efct/efct_xport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9dcaef6fc188..61ebbf091d71 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -416,6 +416,7 @@ efct_scsi_new_device(struct efct *efct)
 				       &efct->pci->dev);
 	if (error) {
 		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		scsi_host_put(shost);
 		return -EIO;
 	}
 
@@ -930,6 +931,7 @@ efct_scsi_new_vport(struct efct *efct, struct device *dev)
 	error = scsi_add_host_with_dma(shost, dev, &efct->pci->dev);
 	if (error) {
 		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		scsi_host_put(shost);
 		return NULL;
 	}
 
-- 
2.25.1

