Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829C3D4128;
	Wed, 19 Aug 2026 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139786; cv=none; b=VBJhqzlcm/SLjFCWKPhI7Tdo/teFJ5l4X08B1WXhvI7CdURX6OLKjn+zHDLwOVK4j92/uwyiuHkqUvqcnpA3+Iiyz9BkKupbTpdHOkP2XbaaKSId7WDID2k0rXdvCFF4ZdxAtFai8RLSD1D8xL9DudwqQUer33x2dNqASCGJJp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139786; c=relaxed/simple;
	bh=8LaE+86hMWzUWJDkWKG/TyBYanrbC8t8hLLMpc0RUCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RncYQEcPLSnX4f+zotsIgXKQ4ov51Hb44v/bJE/aJhdZgSV78n3WbK8GiSZzMMu0AV9UDe4f8wxoQiH05u5Z3SNuSx5O/fPL+5YS7/LYZcV+2LxOoY5PdoFufcWsZiiV8/A181OVOF75GlNCJbJPAh3bweBJo1u/57AQl28YyHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1c0f146e9bc311f19a56ed5b684f684d-20260819
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:85c6c030-466d-40ab-94a5-e78f40081adf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:b778686e1c716a07527b9d6df8874b04,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|850|865|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1c0f146e9bc311f19a56ed5b684f684d-20260819
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1648008702; Wed, 19 Aug 2026 19:42:51 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 2/2] scsi: fnic: free the NVMe port template from the delete callback
Date: Wed, 19 Aug 2026 19:42:42 +0800
Message-Id: <20260819114242.3598034-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819114242.3598034-1-lilinmao@kylinos.cn>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nvfnic_nvme_unload() calls nvme_fc_unregister_localport(), waits for the
transport to call back into nvfnic_local_port_delete(), and then frees
iport->nv_tmpl.  The wait is bounded, and when it expires the driver
only warns and frees the template anyway.

iport->nv_tmpl is the struct nvme_fc_port_template the transport keeps
in lport->ops.  nvme_fc_unregister_localport() only invokes
->localport_delete() when the local port has no active remote ports
left; otherwise the call is deferred to
nvme_fc_rport_inactive_on_lport(), which dereferences lport->ops long
after the unregister call returned.  Freeing the template on the timeout
path therefore leaves the transport with a dangling ->ops.

Tie the lifetime to the callback that marks the end of the transport's
use of the template instead of to the timeout.  nvfnic_local_port_delete()
runs from ->localport_delete(), after which nvme_fc_free_lport() no
longer touches lport->ops, so freeing there is safe in both the direct
and the deferred case.  The free is done before the completion is
signalled, because the unload path may tear the fnic down, and with it
the embedded iport, as soon as it wakes up.

Fixes: 5efdd5cf9281 ("scsi: fnic: Add the NVMe/FC transport path")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/scsi/fnic/fnic_nvme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 00d9d5d439a38..a8b7b7d40b9ab 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1243,7 +1243,6 @@ void nvfnic_nvme_unload(struct fnic *fnic)
 				WARN_ON(1);
 			}
 			iport->flags &= ~FNIC_LPORT_NVME_REGISTERED;
-			kfree(iport->nv_tmpl);
 		}
 	}
 
@@ -1669,6 +1668,9 @@ void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
 	FNIC_NVME_DBG(KERN_INFO, fnic, "lport delete 0x%x\n",
 		      iport->fcid);
 
+	kfree(iport->nv_tmpl);
+	iport->nv_tmpl = NULL;
+
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (fnic->nvme_lport_unreg_done)
 		complete(fnic->nvme_lport_unreg_done);
-- 
2.25.1

