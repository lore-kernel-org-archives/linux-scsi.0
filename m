Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46651C058;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792617; cv=none; b=audkyzAHA0fflGvvPboYocXEtF2EfpOby5XH2SQHeFN4/c3slLNmbFxLSbKEM81juYiO40vNnu12T6Eob8RSUPKiIkunJbRCXmc55hSI8wItuMR0MWtCBK0ueYnOi6FWsw7wKEEremnHtb3XhPB1hyb6Uk2aMwwHR9zYILKdUtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792617; c=relaxed/simple;
	bh=BOShqBMpn6WLtqFgaUcQndUcGxKEzjfXZvTdhjIDg7c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZtCWFri3QGyOO0coVJ3WjZkmieh0BUqdHzdHRzS5QM9f6jcSor/RpQzlFcH0T8d8vaz/o6GhhYY18Gb6y75Ak5hqvBt+Ceboesg1nlAhgPJi1CMGJ8F71GoAeJr/zxUTZoN8bU3iAzOAoDRpizA/otZvobkIqFdB32cZaFLWX/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5XjTJvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5XjTJvW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B480C2BCB9;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790792617;
	bh=BOShqBMpn6WLtqFgaUcQndUcGxKEzjfXZvTdhjIDg7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=T5XjTJvWOYmK/00k/kXzYdw57eOPRDalt7WGWVIDgvPSbq0WE8LcYagPoNFdCQypj
	 yV0rhrJcn2ZkORHCVKau4UhkFoOCRdc99gZGyHmkUQ9uVAzqM4lUkDiqWevYBuBflC
	 tgN/bCdiaXvF4KLszvTy/F7CPN8UdSXz+wiq+Ub2Dr9a+H1IIUjrttPEcXACoqOb7r
	 zgHuCqFIaThLR5pzRYzX7COvre9m23Lls8ekaEK4r80mhr8qK9E+nY6dS5IdR+YiiT
	 lszhtTKOSFHWcRlKj4iwvH8fTmVpKEYiVqXUFJBFPfR6awU29w3a2kZMgRmrfUERUe
	 9LbvrTCl9lxAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6F7CA5FC5;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 30 Sep 2026 13:23:29 -0500
Subject: [PATCH v12 01/11] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-ibmvfc-fpin-support-v12-1-53a3fff7d77b@linux.ibm.com>
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
In-Reply-To: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790792616; l=1764;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=fV+o0wT8doUXVY3i6OM5YZhGutYlLzEIfwvRfhNooRw=;
 b=WzYkzLOUT2A5AMgtRdcKdZJqzuxKBQPqA2dTn082MdQufFSAQD6W0Y38YfTIJ78OvZNrkVp3Y
 ii2LEKtQcTjDxNqIF8ODdYoyTR+TbT5fAGadFl9yHfIhMOh0tvWFWoS
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

If request_irq() fails during ibmvfc_register_channel(), the error path
disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->irq
populated with the stale virq number. A subsequent call to
ibmvfc_deregister_channel() during teardown or reset cleanup then
unconditionally invokes free_irq() and irq_dispose_mapping() on the stale
IRQ descriptor, triggering kernel warnings.

Fix this by:
1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
   ibmvfc_register_channel() error path.
2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq->irq
   in ibmvfc_deregister_channel() so unmapped or unregistered queues are
   safely skipped.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index b3bc3ce872d6..1cd0f80cc9df 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6435,6 +6435,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	if (rc) {
 		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
@@ -6463,9 +6464,11 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 
 	ENTER;
 
-	free_irq(scrq->irq, scrq);
-	irq_dispose_mapping(scrq->irq);
-	scrq->irq = 0;
+	if (scrq->irq) {
+		free_irq(scrq->irq, scrq);
+		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
+	}
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,

-- 
2.55.0


