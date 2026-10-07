Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A754DE721;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401147; cv=none; b=mKigALZxnQTqm887Xa7WS4K8WzZ3Iij/1NtkPkO31pL1ZvUzBYgvxZKYfp3wxXk3IeImsDesQmMc+SjHW4AFgy+h1HcimxdW3qtj9F+nEcv7YzTEBckETGGiONZ40LumL2hE9i5nU6LUxLN37GygqakD3pwcdhYLMwqe9oLgBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401147; c=relaxed/simple;
	bh=pxTCB+8r4h9iLO+9EiB4XXAQcmK8WExkDzMIEXKqWQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kXJZHELqxnrnuaG0GowLD/o50u2swe8YQGoUc1E2i+7jOyC+WLeZN4saanMJS/aSXLXeW2nQQAEdLokOFcBBzWyl+5oPd+gNK75KHAeYI5OFHsghPUAcx7vEWFjvp63uPHvnlGJy51U+H2Y569cChdywoKIhrtOCy2raS4VSrZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6wrf7PT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6wrf7PT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78016C4AF09;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791401147;
	bh=pxTCB+8r4h9iLO+9EiB4XXAQcmK8WExkDzMIEXKqWQM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t6wrf7PTbHhEzOIhjTs6wjgnHrPK3xAaCdq3hlQDD8zzs0YpoDmD4xpETqUsJHHv+
	 k8+Oa38hmCNNx8PVceRjuRcmdmGTP33Toy4jA1YnGmSWXvPS0nPR+6xQp0OP1YmfmN
	 n7RKIHO//RaYTXKWzYeVA+/QMb2DOwwOkq9Cfml7N119snRloFD5mBQkTvuGZp6/f3
	 IM9jZ2OsAda3Vv69ZNisi03YiE6NL3RgOAD2naqlxqB4WH7+VBOPwfZwXOj6Pw3nGL
	 GlMXBzgCu523yvw7XU3wY3sib/sA2R2Bq4QxOQRlb5xngtTYfDatzTvEAAtMzRTPa4
	 faNYAwvP+AOnw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566E9CA6002;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 07 Oct 2026 14:25:47 -0500
Subject: [PATCH v13 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-ibmvfc-fpin-support-v13-3-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791401146; l=1111;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=5MabxL8K2rBUNQC1NT9ZFM4Bgb2QgZQZyrHF4zEwrIs=;
 b=8vOF60GIEts5umotur9o5bMuyMkkPWWmDft62QDPpRfaZRXQqLzN2Wj9BukQACoS3Qu5g3ulo
 XXR7EPp6NBCC5cRd8WBOERIHNQHCE+e3Ld7ZLfCF1r9CsqfonaFk+ii
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Tyrel Datwyler <tyreld@linux.ibm.com>

Guard the memset() in ibmvfc_deregister_channel() behind a check of
scrq->msgs.handle to prevent a NULL dereference when the function is
called on a queue that was never allocated, such as async_sub_crq when
multi-queue is disabled or initialization failed before
ibmvfc_alloc_queue() was reached.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 145d559041f1..6a42d15db9ec 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6480,8 +6480,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
 
 	/* Clean out the queue */
-	memset(scrq->msgs.crq, 0, PAGE_SIZE);
-	scrq->cur = 0;
+	if (scrq->msgs.handle) {
+		memset(scrq->msgs.crq, 0, PAGE_SIZE);
+		scrq->cur = 0;
+	}
 
 	LEAVE;
 }

-- 
2.55.0


