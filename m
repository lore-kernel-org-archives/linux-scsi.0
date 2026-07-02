Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6579C39A079;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015179; cv=none; b=gA1E1siPLuIFQJbe2eph8gTx3N/zZ36dQfy+NPHg1P6OZxRpMA6mPPSdvWWuPhEzlPqGbGKU+wFAz6u+hWZGnK/z6iS4lf+xevPvQ42MYTkOkxwEGSHewCrnDzjYvLJqi8HB/8dOuyYY2XNBuGm9G0CJ0phKE5CdMd3Oc2h64i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015179; c=relaxed/simple;
	bh=w2tfk98n+UCuaS+Oy2S54hKGlB1cAWyRh+N4+QYXZvY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MnUT49ZKbT+PNUgHh3N62NcKmRpL//Fmp8bK59d01TT3M9HZetp078jpKq+J5R4ZCTBHPcLy0VP+xhJW9rjKnixVBSAq+MhrfedgHTT0+IhoJRePQFzgyMBLt7Mw85/G/mp67FU8/DUdKC6xjR7cUoez2RSC0OHC7MEd3FBHNHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReJCx9xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReJCx9xE"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31B82C4AF09;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783015179;
	bh=w2tfk98n+UCuaS+Oy2S54hKGlB1cAWyRh+N4+QYXZvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ReJCx9xEr2sTEvBQrgxMHsJZ8JWuUpmASjKEB6DnSbES9wOYu14T32kRERx7uPtZH
	 jWCZQDvH3LO/TM5rJfOE/u9Qc0WikSf4fiPNye2gyg4neeQBQCDeOjyChkPWHbCNfS
	 19VtyYwOEPD1zDjwFoCex9xyqngni2Bo41yU/JBhI+H5P0SPq5ZrN8zfpM1RrR+3Ly
	 kTM8zQpeMDzpNZe/h174cbKEV3E5tqQ2EjSw6irHO1rutuSeCJgxQEZG61bwA7iAcR
	 0SyLthyDtCX8x4Jg1xBzpc5ctVdxln1gQzijgyzyxGwtByTJRGHX56eL3ZUKg86ZKw
	 cx6tfLCUQkNKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152EEC43327;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 02 Jul 2026 12:59:32 -0500
Subject: [PATCH v3 2/8] ibmvfc: Add NOOP command support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-ibmvfc-fpin-support-v3-2-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783015177; l=4073;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=6CCiDtpYdacbzUgnPOO62NTyDOad19qQmC79kAzA9z4=;
 b=OocrBSHZmXuBKR2A57MxZwSgjooHvtwEWlmkYpvQOMknQ4IUD0BxzWm+jSqGats20tZC5LWBV
 UyGSExQIVDgDxcj2S3D3EG8xn4aU30c3brvon9gSp6QuFGzhy79lldC
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

This patch adds support for receiving and recognizing VFC_NOOP
messages from VIOS. This is done by
- defining the VFC_NOOP CRQ format
- recognizing the VFC_NOOP CRQ format in the CRQ handler. If the VIOS
  has not provided the "support VFC_NOOP" bit in its capabilities on
  NPIV login, note that the VFC_NOOP is unexpected
- setting the "can use VFC_NOOP" bit in the capabilities sent during
  NPIV login

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 16 +++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h | 23 +++++++++++++----------
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b63f41a6cfff..110d77b9aac3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1512,7 +1512,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels)
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3569,6 +3571,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 	if (crq->format == IBMVFC_ASYNC_EVENT)
 		return;
 
+	if (crq->format == IBMVFC_VFC_NOOP) {
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
@@ -4099,6 +4109,10 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 		return;
 	}
 
+	/* Some CRQs, e.g. a VFC_NOOP command CRQ, do not have an ioba, so evt is NULL. */
+	if (!evt)
+		return;
+
 	/* The only kind of payload CRQs we should get are responses to
 	 * things we send. Make sure this response is to something we
 	 * actually sent
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index f69e0605a78d..526632cb7237 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -175,11 +175,12 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_FLUSH_ON_HALT		0x02
 	__be32 max_cmds;
 	__be64 capabilities;
-#define IBMVFC_CAN_MIGRATE		0x01
-#define IBMVFC_CAN_USE_CHANNELS		0x02
-#define IBMVFC_CAN_HANDLE_FPIN		0x04
-#define IBMVFC_CAN_USE_MAD_VERSION	0x08
-#define IBMVFC_CAN_SEND_VF_WWPN		0x10
+#define IBMVFC_CAN_MIGRATE		0x001
+#define IBMVFC_CAN_USE_CHANNELS		0x002
+#define IBMVFC_CAN_HANDLE_FPIN		0x004
+#define IBMVFC_CAN_USE_MAD_VERSION	0x008
+#define IBMVFC_CAN_SEND_VF_WWPN		0x010
+#define IBMVFC_CAN_USE_NOOP_CMD		0x200
 	__be64 node_name;
 	struct srp_direct_buf async;
 	u8 partition_name[IBMVFC_MAX_NAME];
@@ -221,11 +222,12 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_NATIVE_FC		0x01
 	__be32 reserved;
 	__be64 capabilities;
-#define IBMVFC_CAN_FLUSH_ON_HALT	0x08
-#define IBMVFC_CAN_SUPPRESS_ABTS	0x10
-#define IBMVFC_MAD_VERSION_CAP		0x20
-#define IBMVFC_HANDLE_VF_WWPN		0x40
-#define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
+#define IBMVFC_CAN_FLUSH_ON_HALT	0x0008
+#define IBMVFC_CAN_SUPPRESS_ABTS	0x0010
+#define IBMVFC_MAD_VERSION_CAP		0x0020
+#define IBMVFC_HANDLE_VF_WWPN		0x0040
+#define IBMVFC_CAN_SUPPORT_CHANNELS	0x0080
+#define IBMVFC_SUPPORT_NOOP_CMD		0x1000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
 	__be64 max_dma_len;
@@ -621,6 +623,7 @@ struct ibmvfc_trace_entry {
 enum ibmvfc_crq_formats {
 	IBMVFC_CMD_FORMAT		= 0x01,
 	IBMVFC_ASYNC_EVENT	= 0x02,
+	IBMVFC_VFC_NOOP		= 0x03,
 	IBMVFC_MAD_FORMAT		= 0x04,
 };
 

-- 
2.54.0


