Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C03BB69D;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998480; cv=none; b=IVLnmiifPRLgFAEJ72NKXHO0sHQDMARpyHv+eYeMv5R77d+IRhSzDbs5so82iB/TNUMtt1+tIRb8layMm5kHja7lUPmr3HB00/P8odEIlmkcJTfwe/YoOQ62Bn4TKCGk4d7FFd8ml/S2M1rdIILiQFjJgnvQMDgNe7nQDe5ljdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998480; c=relaxed/simple;
	bh=ibH6S6bENnAuY6Aa+juHgFRTm4gvytfx9OuJzg8EsIY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aPnlOFc0xzlfAOW/i0HofWnF3aubms90yIBvWe7WrBYPpPr/nnX32MrQOChedf36rv/FJeo9lQFViRVk7xlHuLrh+Jt184B/nqDOEd8Q2s9F/RRgPtDR4N2mbH/+Xz1gL1Y5bMRWS4udmjIOUxcJ+3vFspXKZJ34M2t1TSdNa+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gF10GSGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gF10GSGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9709BC2BCFB;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786998480;
	bh=ibH6S6bENnAuY6Aa+juHgFRTm4gvytfx9OuJzg8EsIY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gF10GSGJCzm6/VSnsXkagfLOTPmDgqQ/P/vDV4Et94s58qfdkxWElNBnO4ikpmCE5
	 zyMbJFxXVDFvrJlAj8TpgVmodRZzfmQaEg1qcAwkvhwifOiZ5l3EFBKnpiu9WHOlu7
	 IlUqRWxh+TFFtH/dYEeKKWwLNj55meaADEYUEzW3l5PZBd5wEBlHrT7MP+ViJ15xfY
	 SnPdBxuBmfAEKPGxldeCDhhEJ9AyiywQnkd+rtI4clUippC/b9qokb1dvB+bX5chkF
	 aLA2tbinbLHbHCF59a9mWbDAbOT268VU+JsulgQmdzR74lDC3qWcVof4ieK6b2K/vs
	 ZiGgru06KBxPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E21EC5DF7A;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 17 Aug 2026 15:27:56 -0500
Subject: [PATCH v6 3/8] scsi: ibmvfc: define asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-ibmvfc-fpin-support-v6-3-62a2d525e70d@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786998478; l=1724;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=/KuclEPljx50OTgTOexb3g3OjrWOPH3RuTwtYAu4ZCA=;
 b=+1629IP57o+J51b+3ITeltUAP+OLqWdGeAZJHhZ90rI7MHuCuzRXht3bgo2YPc7JdegRHvPQg
 OJb/Ew+AxR3B0ZuppdltVOt7zVVrsY1iGhr+1qq82o7EImQS8yqL1zI
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Define data structures for asynchronous sub-queue support required for
full and extended FPIN functionality.

Add ibmvfc_async_subq structure to represent async events received via
the sub-queue, including FPIN status, link state, event type, and WWPN
information.

Update ibmvfc_channel_setup structure to include async_subq_handle field
and reduce IBMVFC_MAX_CHANNELS from 502 to 501 to accommodate the async
sub-queue. Add async_scrq pointer to ibmvfc_channels structure.

Add capability flags IBMVFC_USE_ASYNC_SUBQ and IBMVFC_SUPPORT_ASYNC_SUBQ
for negotiating async sub-queue support with VIOS during login.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index e8ca0d30f483..d8880d02685b 100644
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
@@ -790,7 +791,6 @@ struct ibmvfc_async_work {
 	struct ibmvfc_async_crq crq;
 	struct work_struct async_work_s;
 };
-
 union ibmvfc_iu {
 	struct ibmvfc_mad_common mad_common;
 	struct ibmvfc_npiv_login_mad npiv_login;
@@ -990,6 +990,7 @@ struct ibmvfc_host {
 	mempool_t *tgt_pool;
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
+	struct ibmvfc_queue async_sub_crq;
 	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_channels nvme_scrqs;
 	struct ibmvfc_npiv_login login_info;

-- 
2.55.0


