Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B554E4321;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401148; cv=none; b=Ncefd159RbyjXdJXdIAJQJQ7fTx+SqfQvgSJGHU9fHYLGXMjEUZO9TH8crvTLLhz7yhZ0Al1QxNiZ7VjMUr2E0hGIdUEDhkUrVdtNjpv5AxksmAfRBY1RE9OqCxKJ4D4/hqvFyWdRtA7Bn7cmqhI7VKAdk/s7pl6jfYk0OkCySk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401148; c=relaxed/simple;
	bh=g6usOz8CmL25lJzLr50kc/7PPOlh9IYsOlTysJcouZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QRDphJQvcQcZRUT7c9kJXgEVRm4YgEqe+DKHsaRdkMXDvcWu0c5MkWsFilBUCtLo8AP7D+ln1q2OurSEmRYx+s4XHGTNvzbikC/sN9laVp1twcNZbDKtflEn7V/HyUk9wDJZjAR6/3uVGv3XXc15nIRS9SQIXCIkp4xWSj7zoUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQZkfoGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQZkfoGl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92B83C2BD05;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791401147;
	bh=g6usOz8CmL25lJzLr50kc/7PPOlh9IYsOlTysJcouZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pQZkfoGlHamof8EAVpLGsHKH+vaxIksuAIrRU/TUKSqVMJ1B+VdlhfMZpSl4Osmjg
	 xLbUO4RIZBE5VCfL6EdkR0AzF6Oosbsq6fr2k7vd4lzeIub6t6faSO3yGpqi7I6fiy
	 N3nBzs1+/X6IiswGPr1dIYjENghPeCz/24pMeJpasu+qXtz0Rq+BaK33H9wko6aD61
	 QQNpPWqAxHrdBntssttYmDHI68wyGddy72+rVPR8TXT+BMtgcYgKGIhTo8rWTY+BV+
	 YPAURPuOcwpdBH7BWwxmqf2jD45qeACW/aW6fEIGgeSsKpuvr6h+TDgRziVcqrR8Rr
	 pb1QEDdT+b3PQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1EFCA600A;
	Wed,  7 Oct 2026 19:25:47 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 07 Oct 2026 14:25:49 -0500
Subject: [PATCH v13 05/11] scsi: ibmvfc: add NOOP command support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-ibmvfc-fpin-support-v13-5-b816abfa4fcc@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791401146; l=2959;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=hom48UpLCAkoDIXMZgjFC78dZosqbEa7V9vQfdIXO4M=;
 b=h4ro3sf9pa47k1hva7LtbnmMq3bcjGZ4IGDIEkDV04oAd3m7GhDMUKXXkd0sLkJ60AYvXF1Vs
 KQyTzG60iREAP2yXm5W0HEL0vQrErKb19CFaLOdj9xaY/Ulzg8lfD6T
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Add support for handling IBMVFC_NOOP format CRQ messages from the
VIOS partner.

Advertise the client's ability to handle NOOP commands by setting the
IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info().

Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
and ibmvfc_handle_scrq(). In both handlers, log a rate-limited error if a
NOOP is received while in the IBMVFC_ACTIVE state without the partner
having advertised IBMVFC_SUPPORT_NOOP_CMD.

In ibmvfc_handle_scrq(), also fix a typo ("Got and invalid" -> "Got an
invalid"), add a missing return on invalid message types, and guard
against null event pointers before processing CRQ responses.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index ac2571e9e1eb..161d4679d702 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1578,7 +1578,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3695,6 +3697,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
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
@@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	case IBMVFC_CRQ_XPORT_EVENT:
 		return;
 	default:
-		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
+	if (unlikely(!evt)) {
+		dev_err(vhost->dev, "Received null event\n");
 		return;
 	}
 

-- 
2.55.0


