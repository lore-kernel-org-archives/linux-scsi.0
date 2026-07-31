Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6767533ADBA;
	Fri, 31 Jul 2026 07:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785483522; cv=none; b=XxXA1DgPJkZhu9ZrhlBQ/CcdBm9ONfLtZz8GDObZ+u2JvxNBRHZmg10v/P93KIdizn4HGbEWdVxtAl4qVCb0byBrOaEDukdT6HQb2RsmhcIj/ug36QyPMujUznS48LV5iahu4nw4Z/1jJ1bhiTPvRuu4/LRY9hlnzbgDwfb03Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785483522; c=relaxed/simple;
	bh=Nz7A02Qk2ikwqtgmDtErl399F1EcSfindkzponkNqho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MVbOgfRUmwmFZHEyadnCKg+ckzuxBtXMkpbT5htwAtN5ollTOAvnzx5mVNnsnW8VY3B4bbirf5VPDkNv7vQaYH4mW9rkKJ63B/1lqRZ3CVCQsanQYJVhI24GrRJeNSwqzkeEhIGD4u9Tlzv4tDw63OOPCS2sq7ZWjWlFM0HcNBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d0f173568cb211f1aa26b74ffac11d73-20260731
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:173bb9ab-c28e-4354-8510-11dc1d614bba,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:e5a0b3ca7e6318a872dd3fc4f90bbca3,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d0f173568cb211f1aa26b74ffac11d73-20260731
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 999829685; Fri, 31 Jul 2026 15:38:26 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arun Easi <aeasi@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Linkai Gong <gonglinkai@kylinos.cn>
Subject: [PATCH 1/5] scsi: fnic: use GFP_ATOMIC for VLAN alloc under spinlock
Date: Fri, 31 Jul 2026 15:38:20 +0800
Message-Id: <20260731073820.16449-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fnic_fcoe_process_vlan_resp() allocates a VLAN descriptor with
kzalloc_obj() (default GFP_KERNEL) while holding vlans_lock via
spin_lock_irqsave(). GFP_KERNEL may sleep, which is not allowed in
this atomic context and can trigger a sleeping-from-invalid-context
warning or deadlock.

Pass GFP_ATOMIC so the allocation is safe under the IRQ-safe spinlock.

Fixes: 098585aa8aca ("scsi: fnic: Add and integrate support for FIP")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
---
 drivers/scsi/fnic/fip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 132f00512ee1..28c9861b6501 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -139,7 +139,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header *fiph)
 			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "process_vlan_resp: FIP VLAN %d\n", vid);
-			vlan = kzalloc_obj(*vlan);
+			vlan = kzalloc_obj(*vlan, GFP_ATOMIC);
 
 			if (!vlan) {
 				/* retry from timer */
-- 
2.25.1

