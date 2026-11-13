Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794578644;
	b=VvVm8Zt93mlw/ebTfRtfbBPcQSkTB40WJTA0DVyKQU08yQ0/OrJRyfkl1YjFfjbkh6jk
	 nI99S2oHjMMR7+OGKtvplWKHdEJixnixb2q9OoRxL9+zlNFIXgbIZNiJ18FV5aXi5Rwen
	 UJvAb18FPCvGYDG9uC94cIotEW6RUR/2OBOug9nfewJTp9Us9jlw7L0sEa21ppsOle2/r
	 IqXeT35hWzaPDc04Kb9cCjujrvNaI5YResiepGhxreFeZqpCenMo1rOe4ec4d8FItlnKM
	 FM5wYH9edrqqAYAXf0KkO4AHu3dbe6Dl4HMvTez7jVUgK4z1rZa2h/gGzaVYgxySNeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578644;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=6X0nyebS2BY1vy6IezGXEVYTSbFtAzOvJZEYJ/TK4Cg=;
	b=o645Zjad0S2tsS1kEyf6jGVewWKTKQfo0j2VVzUFaqCbGNE4NuM+5PHuNW4ZAPYsnXmk
	 Nybr6brQO5SNOhdxFC94uAuczcTnq+Xpx8dQJIYKNdmeXq0NvL/8zhU/2o3SKjjnMoSwT
	 Wnz3mmu9t189PKqBwdrpIy7HAu9i4HjhyLp9/5tPk0KvAhyktM8jTmhUjkGn4ICBmwy1w
	 7eYL8Bztz2QyudKDGpb3ix80qGnj3SIzABMcQoAtqqYIxR6o8Jq5rh0h0P7ClnA+jk3y1
	 uXrPRm1vhPcb1NaWqoS29RsUKQBgsZlrZkAt2M4jKBLARfEs6dhyyrE0Q+gY6Qml5gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=MlMI2sh4;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D7606A323;
	Fri, 13 Nov 2026 14:04:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A8D7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=MlMI2sh4
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 549aebcb7;
	Fri, 13 Nov 2026 22:03:50 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix potential VMID resource leak during vport cleanup
Date: Fri, 13 Nov 2026 22:03:49 +0800
Message-ID: <20261113-4e14e563a1-scsi-lpfc@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1d538c4b503a1kunme35979b447fbd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSx9LVkNKTxhPHhgeHR9DHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=MlMI2sh4+ZE9LqJeU0flhvRSKvItt8W1cMEOTJpjSRUjaM7B5AS+5G0jWutlkvlXc4njC+Ejl/LTxbNRKVOT3VrHi35MM1HDUkBgrW1H6HTBGs/yP66l5Lh+PQCg5e0Au/FDGdxh5G2xmXyTmOPRCSa+GSGtxoLhrLdJQXzqZ8Q=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=6X0nyebS2BY1vy6IezGXEVYTSbFtAzOvJZEYJ/TK4Cg=;
	h=date:mime-version:subject:message-id:from;

lpfc_vmid_vport_cleanup() frees the VMID array without freeing the
per-CPU timestamps owned by its entries. It also traverses the embedded
hash nodes after freeing the array.

Free the timestamps in every slot, including those retained after VMID
reinitialization, and clear the hash table before freeing the array.
Clear last_io_time when registration fails so cleanup cannot free it
again.

This issue was found by our static analysis tool under development.

Fixes: 5e633302ace1 ("scsi: lpfc: vmid: Add support for VMID in mailbox command")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 11 +++++------
 drivers/scsi/lpfc/lpfc_vmid.c |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3f39cc065029..75c5b4bfd0f5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5475,20 +5475,19 @@ static enum scsi_qc_status lpfc_queuecommand(struct Scsi_Host *shost,
  */
 void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport)
 {
-	u32 bucket;
-	struct lpfc_vmid *cur;
+	u32 i;
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT)
 		timer_delete_sync(&vport->phba->inactive_vmid_poll);
 
 	kfree(vport->qfpa_res);
 	kfree(vport->vmid_priority.vmid_range);
+	if (vport->vmid)
+		for (i = 0; i < vport->max_vmid; i++)
+			free_percpu(vport->vmid[i].last_io_time);
+	hash_init(vport->hash_table);
 	kfree(vport->vmid);
 
-	if (!hash_empty(vport->hash_table))
-		hash_for_each(vport->hash_table, bucket, cur, hnode)
-			hash_del(&cur->hnode);
-
 	vport->qfpa_res = NULL;
 	vport->vmid_priority.vmid_range = NULL;
 	vport->vmid = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index 14dbfe954e42..a13e5a07e818 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -270,6 +270,7 @@ int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
 			hash_del(&vmp->hnode);
 			vmp->flag = LPFC_VMID_SLOT_FREE;
 			free_percpu(vmp->last_io_time);
+			vmp->last_io_time = NULL;
 			write_unlock(&vport->vmid_lock);
 			return -EIO;
 		}

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

