Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E2B3B0599;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980880; cv=none; b=A9L90vIG2cEvDohsdz+29w0CPXQe+5a9v08HTd6aUWbXHDTJjW865lrW9iWGenVNkZyQdDtzFTYOdYiZAHZYyDlF4wWqpe3EN5mH+3JlII1k29kQ2nfYUBlPlqzjh3AFri7j6wloRRaZAgdCVuyqvK+UwvW9ivtpoPR/3d+tjao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980880; c=relaxed/simple;
	bh=XkBXrQmmKWZ+hf01Y8mXNBZ2JaNJ3dWvop4CqYBj65M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ir5maHxTXADs7xW2PEEfUJSdI8VEF+Gonwk6P1BnBQ9B8AbYiL4G+Hlrk6DUGOIIRBq2KigpaBus31ERseKfTUATyRctomQEDCzoQF7oKCqA/nouP/UQwCb/VFkIuZXGBwrgOWlIxOTfooHaM4Z6X9vL04FxlhOjiQB1MVfmzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooCEZ8Ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooCEZ8Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55131C2BD01;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788980880;
	bh=XkBXrQmmKWZ+hf01Y8mXNBZ2JaNJ3dWvop4CqYBj65M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ooCEZ8Ym5Qao96wo4dkQoNKP5xdJZr0iOg5K4mnVOIuKuX/6Tw4LZ7LYHb1eNAZNr
	 2wBYZSdgUkTxA9v4Ev5JZ2GUj/kddRTnKpbcHonZn5gEW1lPtsimA+z5sqauX36Nw0
	 EInd/qB0VQH84fAl6oKpa5uLrwMbwYLjf7V4M/Gr7kp8T5q+FdVSUbTLvMkbs2b3hu
	 OBO9ueoZcFDfDy2YBqQdY8T51Mv7hLZuxTMl7DmLKfoUt5Eo4dKxfIxde075XTgjZD
	 oylgNEQoptrouTYadVZtw3oRntP8tYy2CqIz3L6Z9vmfuXrq8W9/O6927Khgb2vYNF
	 4iT4VQRZgtkcg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33785C88E41;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 09 Sep 2026 14:08:02 -0500
Subject: [PATCH v8 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister on
 channel reg failure
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-ibmvfc-fpin-support-v8-7-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788980878; l=1707;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=S7JoJv6nrDtzuAz4WAYCfne5ZRPe72ADWh4nieJY2a8=;
 b=9EKpDYXsAWuyIv5VClmdHCHj6iXDLtkM3OFohJa0odSJLkXvi8TC85rn2+NQ4uM+X/Coewesr
 DFIQNkDhKVyDB7dezOZNN7ASZMQYys04zY0EeMvwzD9v0uoG+Ewmwr8
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
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 1c660edcf608..f88262ffad13 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6888,6 +6888,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		else
 			dev_err(dev, "Couldn't register async sub-crq irq\n");
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
@@ -6930,9 +6931,11 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 
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


