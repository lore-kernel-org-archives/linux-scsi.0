Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA32834D3B9;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998480; cv=none; b=EqU/u0KHA/pjSCWAiySypjZZoWmxV4i3N4cxoO15uNkfKSvy2bLW/d51ZCzNLKZB/X0FzEwcKewNSZ86PqlOW89TpVZNfCkQDqCtxFh8sPQT9KMM967Xm/XFQGn53shCL8m35OvHKXbIuAY1u0FK1GnvGv4BTbK1YVisZsFlocA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998480; c=relaxed/simple;
	bh=HwmWfEDHvET2VABRqB2+L7uM+jxA3WMPRe4ZJvrflZM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HdornqwkfIZhOCnvnI6gukLnjkAiYXtT2rAH1d9mEXw5zvRFGnA2VfysQL+nPfeT6cm4PDoB1aVEKpPfxO9blEQYDVGtYhI7uY2TOfu37ZS/OWDR0u8tEGfzOhHxtBpY/PBs/05qw9LfnFwwdA5Y+mPiPw33M3EEsvZ484cXfa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8cOjpar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8cOjpar"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87999C2BCF4;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786998480;
	bh=HwmWfEDHvET2VABRqB2+L7uM+jxA3WMPRe4ZJvrflZM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=G8cOjparchmZQ27bDjr6H6Zpj15G+qi36rgFkVW2gDt6EbRwponnX8JW9i23XwEwb
	 uVKJN71+Q3U+4XSCaavHgcOCcv+qGovVFutQGPW6aQqaWKE11UpfCNzKHMDQx3ApC8
	 6e+ojpwjJSwZ3qjDPvFIN2rSBvsfdxFqavIZn/XPkEwkKXILVexvXMj0LGumCWqNis
	 3H+eLofhDEx5kOG2HvSSLY7pz4fhScHk0fqnA5e1yCFG4Iz9/t+EiszNSA0Avh6k8L
	 fbU6EHiPOjK3lbPffQzqXghnrctDXX3iYAFs/cE/7oTmUZck65dn0iUGysjCiMv1f1
	 VL7jxIXDlc74w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69976C5DF7E;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 17 Aug 2026 15:27:55 -0500
Subject: [PATCH v6 2/8] scsi: ibmvfc: Add NOOP command support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-ibmvfc-fpin-support-v6-2-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786998478; l=2488;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=9SEbwhnfSVQdalnJewp+335AWlDv08Etc/f1IY3q92c=;
 b=1Ll5s9Ouf3E7OwQQH6Lbk036WFAuUT3qfwh8ooBIh/3hD8pJsLjitPA2eihfYKiBqu/EBKYB3
 zK0Bzq4ptZTAOqQsIGj61OlM0/WDXVGd8UxpLQUlWiPohFDmxaBZsFT
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
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 1ac730c0a8a6..3aac4fd2c5c3 100644
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
@@ -3657,6 +3659,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
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
@@ -4185,9 +4195,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	case IBMVFC_CRQ_CMD_RSP:
 		break;
 	case IBMVFC_CRQ_XPORT_EVENT:
+	case IBMVFC_NOOP:
 		return;
 	default:
-		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	if (unlikely(!evt)) {
+		dev_err(vhost->dev, "Received null event\n");
 		return;
 	}
 

-- 
2.55.0


