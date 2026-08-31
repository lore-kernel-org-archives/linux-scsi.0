Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D3B3DB326;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788202817; cv=none; b=Rv0KmvbiyOOXx19KXig5cmTvPSrK013P/OZS1iOKe8QxU6ETdkr4LfrTcA2qKonF4OpzDb+HJrKC6QxZXy4+UYw40USuZOYUSkv+PbrLVfjn3ajszBJiCEsbru+/6nx6GMaHB6PLnWAySXPGEYVclQyB6G+pyFz7LHoN1wKQ1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788202817; c=relaxed/simple;
	bh=rjBmlQQTMG7h7d2b5mk9jOmECyYSFyRAc5cMyiPFXBM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S1H0m9/CSP+kLa9PdILZ63wFDf7TlKOznI2bhWFfDHctAI4uxZdw6tui0sRRoNQ5zxJ8zzOmqdspd9I2AbDx/H1jOZ+MF6Iu25t9MlA6Gety+Z17qtWE7DNJ7cn4wZxpUBvsY1nnn6tbH2/yzKA+423HA1tWE3D7OTf8oduwK6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+Q2UdAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+Q2UdAL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76819C4AF09;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788202817;
	bh=rjBmlQQTMG7h7d2b5mk9jOmECyYSFyRAc5cMyiPFXBM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=b+Q2UdALgQsDfkNTSjMjNMlI6axcqokp8Jynzt7Y3ul4bc0ubwHx3PlqSejTUqmWT
	 d0R4nKglu45htYQji+CniK0/ka2t1vVU/7h0Eqru/JSmqQr46tOnmTuUFgyEdPV2/j
	 NdDXplZzfedG2T4BMBIllSotpBsYlF2FlRaN1cFDRhnYjBUOvZl54ij/ajex3iRHQH
	 bYTckeiaQXQztyiDNe+IqmQjzveB0Rrhv4fWhG3Qj759BpS37lx7isfRTRFBcQ92hE
	 E4A3wfTCFk8teZNudVI43d2tpqtu/WLo+DV/EMN1HkGU4TBLx4EyzbNniXxsvv12/t
	 B3JUap/qRqi5A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57360C61DFD;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 31 Aug 2026 14:00:14 -0500
Subject: [PATCH v7 2/8] scsi: ibmvfc: Add NOOP command support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-ibmvfc-fpin-support-v7-2-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788202815; l=2519;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=ZPYobFx4Tjmjv4+HMsDvOBnSXCtpmV13W5cWm9Aqs+k=;
 b=QhmopkvLCRSB87GEEqkFKKcdQ19roqMvftbaia9cA9eSUNEKQ5PJbfYNBlak1jIlBPZmmW1hr
 qSgI9yD0UunDT7qfO4ewn/esxZ5b2OoH9ouZJOps3mJaW963qSncfWa
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
during NPIV login. Also fix a typo in ibmvfc_handle_scrq.

Set the IBMVFC_CAN_USE_NOOP_CMD capability bit during NPIV login to
inform VIOS that the client can handle NOOP commands.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 78be00d31a06..e972e4ec5be0 100644
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
@@ -3693,6 +3695,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
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
@@ -4223,7 +4233,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
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


