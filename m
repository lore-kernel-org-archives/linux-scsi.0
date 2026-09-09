Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655E1368263;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980880; cv=none; b=I4Fijrn5UjYy1O21XKdRLAC7dmaJesPGUGnfagOGvEUgSXiUmL8pZfoZ43xSf+A4RaUAwRKyFt6WFvINPkUnr2wgQ7/2pa9T4SgBuMkF68KacmREMxSCv+gu5vpQRw5DttmDWKG/PoCFHEzdigpKpFJoKozhZ5+2eqFdQcIpimE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980880; c=relaxed/simple;
	bh=mFnlH7/qPv+L0T9B45mohz9x62pSXgPbs74b2lQ0Hdk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LoNaGgpUuTxCwnQ8MIIO+iurHNM/bsA2PGqDZ+rBShlbMFJdTKgbTOk7T3uA4ZiS+o0qEuLer/P79aLj9tL3FXu0d/el9N302yTK0Z4eekErZY+UAtFh6EzbC5C0sUB5LTwZ4k7OP3oFppFyh7iiE5MisvQkjSZumTYh17pvUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpDkrlqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpDkrlqa"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 102F6C2BCFB;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788980880;
	bh=mFnlH7/qPv+L0T9B45mohz9x62pSXgPbs74b2lQ0Hdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UpDkrlqaOjTxG1bQxA+syvZdV6zcAJP62pfqIqdHcFG+KjNVARy2+Af74NHuUQqgQ
	 tFsi+IhP9jgKUu0bxIXHut983VefNf4UCCCn+8KT34REA5n/ir3PzGIgGjK/AhI9ei
	 g7e4LLn3QlAHcaujhJQdadSQyCRdZ3XG/L0vw4HckDN9PrE7uPud/v3gXjeOVp0z2/
	 z4F/YSInFX7rQFqAOa1hnyvxi0Y5b+hnfrPsHQDBo0jSQeMcpvm+jd9gI/jp4DHVW9
	 i1zAnAq/d6+P2anMRyziIjKLMbyDyfH4X5G2DxE8uaw+FuByW0mtvPPouoHtE43KaT
	 xH91iYoNw18ug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE385C88E40;
	Wed,  9 Sep 2026 19:07:59 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 09 Sep 2026 14:07:58 -0500
Subject: [PATCH v8 3/9] scsi: ibmvfc: add FPIN extended flag and async
 sub-CRQ queue handle
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-ibmvfc-fpin-support-v8-3-b27183b055af@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788980878; l=1156;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=6+Vf0PoqfDYiBtRPDVPvMbpbtiabmKU9+0zi74lACkM=;
 b=wZL86Y4MW/fnRBDZlJyyY4UdT/X/nD6f0brUZLcFM2YlQr6XJnLQNQVuKYivvf1QE5AebfEUH
 SKBLxmoBjV3DW7Hp3o3bXIKCGBaLPQGbV/mBveo1wfVKoZtuKgpGJJe
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Add IBMVFC_ASYNC_IS_FPIN_EXT flag bit (0x02) to ibmvfc_async_sub_crq.flags
to distinguish extended FPIN events from standard ones.

Add async_sub_crq field of type ibmvfc_queue to ibmvfc_host to hold the
queue handle for the asynchronous sub-CRQ, alongside the existing crq and
async_crq queues.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index d7a30e7a4a28..a8a063d99564 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -773,6 +773,7 @@ struct ibmvfc_async_sub_crq {
 	volatile u8 valid;
 	u8 flags;
 #define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+#define IBMVFC_ASYNC_IS_FPIN_EXT	0x02
 	u8 link_state;
 	u8 fpin_status;
 	__be16 event;
@@ -990,6 +991,7 @@ struct ibmvfc_host {
 	mempool_t *tgt_pool;
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
+	struct ibmvfc_queue async_sub_crq;
 	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_channels nvme_scrqs;
 	struct ibmvfc_npiv_login login_info;

-- 
2.55.0


