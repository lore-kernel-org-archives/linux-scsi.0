Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491954;
	b=URIKishH6yIUiPID9ut5ZGKXA+gQBhvDNVXT9GLf8P+yOOnlXcqbnzjbC0FKz8IKLnaU
	 N5k9iFsU4U36zs8NgUUDo/64W2frWd7H8A4aXTRWfLayc+61j/8S/izBYVja8n+Zl2NOM
	 4r541b8+cz6zrlEgFCGZxsK6GEz8qM5h01ISRDxDKtHo5XH2gVbAn1WrmWO8ZHwwT29/b
	 oBIxjAY36hjadWOU7zWz3s6mMFK4mq/nTSAm4Heb6N4TP8akAgrO2RaJvbVUELIQuonf3
	 6+97mV3qYcIgWVcc/rUpU1T3MOxDc1LkSpE1nYcqEAJX3oUIZffjYazx7ENj3NAKbtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491954;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=blWWq3NqrSGPaPvNvUztCVfgq/Fk8ijAAMgXh8ISXQk=;
	b=wtBmNF0irn939nY+64q0At4rSW/XWB98M9WqbISQRon5FIfiI9AYwqDC78N1wl3W1NKp
	 wu89KHlo6y374afiDTAW1B9Hyi/0Q7om8gDJaIIuScGKCxtwM4DX8iOk2YSral+N3J8fF
	 ET680ti6I6kgNHd/30xq1AfAKl+NdE2phkLfkl5wPHp0p7vpXFSqHfp5ZXKEYI5Ey/lRU
	 ah+QYLpoj7y6XJ+gfnOB4/NiOC023Ht/AmB1V0wuuI12NprFSoULkb69wDTxiWAzSI9YM
	 ngq+DgJ9S/S3n8TapYS0PSl7JieC4dUpjL/djwP+QezxbINR2zgZ6CZ+X3TRZRUzmMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=T0Mb7Nhn;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFAC606A327;
	Thu, 12 Nov 2026 13:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBFAC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=T0Mb7Nhn
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54773891f;
	Thu, 12 Nov 2026 21:59:00 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: efct: Fix potential use-after-free on RQ setup failure
Date: Thu, 12 Nov 2026 21:58:59 +0800
Message-ID: <20261112-88a3a7ff32-scsi-efct@mail.sdu.edu.cn>
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
X-HM-Tid: 0aa1d00dfe2f03a1kunm29860c7d29dc
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTh0YVk8ZHUIZTUodQhhNGFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=T0Mb7NhntcCkNN4oe6EimVsLgk7ClW9q6IgCqW+lsEF2T37HOG2ch4S5EOBgTxsuqVYrtSHm7gLiLvaUjE2qDR7NH3/Q19T1MwAMiJASr0trBopr5ATC40jeBzoKKi4hH0RP4xCbXWhci/5FV3gLs6gKyHMkML5bjqllDflZU4A=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=blWWq3NqrSGPaPvNvUztCVfgq/Fk8ijAAMgXh8ISXQk=;
	h=date:mime-version:subject:message-id:from;

Receive queues are linked to their completion queues before all tracker
allocations succeed. On failure, the RQs are freed but CQ teardown still
walks their list nodes. Publish the RQs only after all allocations succeed.

This issue was found by our static analysis tool under development.

Fixes: e10fc2335980 ("scsi: elx: efct: Hardware queue creation and deletion")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/elx/efct/efct_hw_queues.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
index 3c27f927f96c..784eadabd3aa 100644
--- a/drivers/scsi/elx/efct/efct_hw_queues.c
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -362,15 +362,18 @@ efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
 	}
 
 	for (i = 0; i < num_rq_pairs; i++) {
-		hw->hw_rq[rqs[i]->instance] = rqs[i];
-		INIT_LIST_HEAD(&rqs[i]->list_entry);
-		list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
 		size = sizeof(struct efc_hw_sequence *) * rqs[i]->entry_count;
 		rqs[i]->rq_tracker = kzalloc(size, GFP_KERNEL);
 		if (!rqs[i]->rq_tracker)
 			goto error;
 	}
 
+	for (i = 0; i < num_rq_pairs; i++) {
+		hw->hw_rq[rqs[i]->instance] = rqs[i];
+		INIT_LIST_HEAD(&rqs[i]->list_entry);
+		list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
+	}
+
 	return 0;
 
 error:

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
