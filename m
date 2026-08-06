Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F40387596;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029461; cv=none; b=taIRq1gMuVmc/pIiBY8AJlSDl/CA6XSHS4IzXKvJyLIVc0U0jcaiQVtw3dkcEk7eNQ1EbEQ9Tb78gPwNqmsV4I2QD+qvXpieVz41Sh/f66rpLJcGDtrKJd5WEXOJ8hYw7hY21p2fL7v7HX6M6jQfVKP5RhnEGlHLrOXEdjv7CpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029461; c=relaxed/simple;
	bh=SS0C1w6R0DRr0Jqzq/W0nd1ACrZ8nFL288TxiJd5ur0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J4XTwNJQ/uzK4gvMQKe8ZUGIUXKwgGQiusBK4mWHiNxS7OIuHRmxgE0MdKGH1VWKtQiHQDdopL24wJzbiUu0Z7enWemkXFelhA3PtxbDBf+Azwa66qlR9BbCv8Mm+H08OGvbNC5/qVzk82q/8ULcGLF0eMnBpxukyO2hY4FCFWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAnySlKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAnySlKn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B122CC2BCC7;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786029460;
	bh=SS0C1w6R0DRr0Jqzq/W0nd1ACrZ8nFL288TxiJd5ur0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NAnySlKngq4hMNjGytgL/is8jTiuaCRUjWUq1yPL9g8W0glxDi8VibUY48ABnEAm6
	 jp+0IeD9vau3UFIgFKXydWzAwfoZijweCpXq0DDvcoRhrr3U1NW+wRUo20ukgHkcSL
	 tXmzd7cJr4P8hw3QovknyRDwsbrcke921uSrGmuc/1H4nRrTncVO+z6C+l1VkXCzCW
	 cCw66k4H0rossCfbVwAtn5ruXUfMlTiXh9QW80fejRA6taFSzG7dOD53THtWzZg1as
	 o7uZ3UH3VlLovBwonBRtQGhUaTEaGVTMT3S2OYT2pRyfzARi9V0HrvbM7hWZTuym+8
	 fcwsiujiSQUiw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90901C5AC7C;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 06 Aug 2026 10:17:32 -0500
Subject: [PATCH v5 2/7] scsi: ibmvfc: Add NOOP command support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-ibmvfc-fpin-support-v5-2-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786029459; l=2480;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=pi0BYFtkGAwJUETNJURtMT+7ZgQM3DM/lgY7+X9EbdY=;
 b=07H7YIhit45FZuSgueA4OurntaVC5KR3hltV/ebQVYdxnRalbg7At0j9ECDMI94Qs4fVYKUan
 vYavy1b1yKGC7ePir+WZF1cJ7cZeiU2h6B+jZZcY+aNjOzFlRFAN+/P
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Add support for VFC_NOOP messages from VIOS to enable keep-alive
functionality between the client and server.

Define the VFC_NOOP CRQ format and add handling in both the main CRQ
handler (ibmvfc_handle_crq) and sub-CRQ handler (ibmvfc_handle_scrq).
Log unexpected NOOP messages if received before VIOS advertises support
during NPIV login.

Set the IBMVFC_CAN_USE_NOOP_CMD capability bit during NPIV login to
inform VIOS that the client can handle NOOP commands.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 537d2b565628..aec953f29e55 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1562,7 +1562,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3647,6 +3649,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 	if (crq->format == IBMVFC_ASYNC_EVENT)
 		return;
 
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
 	/* The only kind of payload CRQs we should get are responses to
 	 * things we send. Make sure this response is to something we
 	 * actually sent
@@ -4177,7 +4187,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	case IBMVFC_CRQ_XPORT_EVENT:
 		return;
 	default:
-		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	if (crq->format == IBMVFC_NOOP)
+		return;
+
+	if (unlikely(!evt)) {
+		dev_err(vhost->dev, "Received null event\n");
 		return;
 	}
 

-- 
2.55.0


