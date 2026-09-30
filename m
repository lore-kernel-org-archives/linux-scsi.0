Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F951C060;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792617; cv=none; b=ryBPYsnCDDpHV0mqxjjMgElSTt1AbVjJaPtn1iZ6fgfUmLlHYBpeLXOK4JnBwX4xhrPcvIuaN0efHtG9hEdqgFSt3groONe+/4m/hFGR8I1FhRsCEnTylhiD1QDmf4DTDIlO/HnF2vwURp13G0gxKMjFSuEf6pSZZc8+VDc+iu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792617; c=relaxed/simple;
	bh=mmHAI4lqTiWTWsOFBymcfgvv8S2qQq8i1Z2ZjGjy+mE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jry791Qql/Ul7OAGfTwZnHTeFRdlPyWxNekw4PoqneztFxOwZ6EU2XZ3SQjEylG+22cR7ireuinYZHAnNl+GMcikwBYXj5CYKFmrcjBdhVcgnrfAtm79vbM5oamJU9n0HiB1sKCSz2H8piF9LMEjp9VDbmuIanoKtepUHhlE3ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hlk1LpFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hlk1LpFl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75258C4AF15;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790792617;
	bh=mmHAI4lqTiWTWsOFBymcfgvv8S2qQq8i1Z2ZjGjy+mE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Hlk1LpFl/3LpfiDXkeoBoHzLa8j8C8D4PoaxcRwmGWGFhqhMZmoYJ06ETkTpsDnf+
	 GNakbcWs1KmlnuIH4dRv3n+NwGWE/BkFdx7pia2DpyzUgIlHsTa9vc31/WHRUi3SO6
	 iCJ2KYgIr+vkg4GuYxxJcM5kAdGc+fdLDnissk4AiNaXCmNIcLtlXOiWp2zsN15mcf
	 57seNk6FU+lVhmzOKUKmotTetnSoDMBGEZ5DELqIk/72PJHj6J0G0d6xMMJnm00v5+
	 pbP+yjg5bqzDoNmtjxjlgk0RP0t/9YOZ8VLIhwed4KD5jEpD0QlMj+eWWGY6V2lGFD
	 RnUasIsnJLfQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A446CA5FC1;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 30 Sep 2026 13:23:31 -0500
Subject: [PATCH v12 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-ibmvfc-fpin-support-v12-3-53a3fff7d77b@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790792616; l=1111;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=wAZi3BQ6xlr40111qSneTKnSLs5YURCCqScQ3cxxd4c=;
 b=r/VU30jCdhbJPK6Aelfox28Qr16E8hvz4KYiuZlauaftjn9+Ww+yILCMwgTlxmT9B2yAo5mVT
 ykKlXxoDmNxB9aIdwfx/GMyJDmatwIZuk9T4yAbN8KyYGw4tu9nDuR/
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
index e847e0e5f0c2..cf775f0673a0 100644
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


