Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F43DB63A;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788202817; cv=none; b=oExBYEGVn+FBolcnAu9CBy9wM8fgo/bXfArGqXy/ilLpdI58v/cHzSd4oVODbJB8+REpt5qXlAmZzO46rowYYXUSWpAxd+1unUS2rBo5GE0SgpliVdCiehURii0KHMJiN2lp/ezFnnJo+KFF4IUy2MbmNkbFC8rlO3AOggiYweg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788202817; c=relaxed/simple;
	bh=2Tu9hv7UV4sPka0itSJBGOvFzakW74cJMqAuTb+GLcQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dn4M4qpAe2XZxG+bOT8St0KNAEzeyiLul03JRdoih3ypkNCWaiR5R1NRWpMintnOAVbNEnGQTAtAu7T7LlRT4CPIzyatct4VmovojiajnE4y9W/YNeaCdX4JbVtcJUdcL8alk8+Y2XxTrdXl/6q3BV56zjuggpY0VrjSWgHAjCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMqcKiln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMqcKiln"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80A8CC2BCF5;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788202817;
	bh=2Tu9hv7UV4sPka0itSJBGOvFzakW74cJMqAuTb+GLcQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pMqcKilneysIDDgdZ6m9l0HLB5TZmvXCq2HfnzR1GUbYLq2SFOTq14N7+itfrCADs
	 kCTYJLqLvc3Zwim8XezyD4PN2FBdwgHhAFM55swv6J7jN0Ag35gRN/SEkD7JE23pDV
	 o49YPSeeCbQhZ4kE1cXGf49gRhtm/uT3OroABI/OU6d3IBe9dfSyv1ZYGRHVIpiG/o
	 jSgsQT8elQLDJ0PMJuJIuksrbhE7MVRdD/SLlpNeLXu14oVJnIE0C7oIhulbGHz67K
	 uubE4DHB+e/NfnPsFWzh9dp//UtaYvuYBU8YweDKnOdsZbG0CvzmCoaVRgVCvWo1kE
	 sZMccKPOpso6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6862FC624D1;
	Mon, 31 Aug 2026 19:00:17 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 31 Aug 2026 14:00:15 -0500
Subject: [PATCH v7 3/8] scsi: ibmvfc: add FPIN extended flag and async
 sub-CRQ queue handle
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-ibmvfc-fpin-support-v7-3-77d0b9809080@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788202815; l=1156;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=LHQEdLSXmrelE8PxihHPWRiGoEQFDjeL6jTPhksOZpY=;
 b=WVDH/Gt43dZKsRfLhefKop8P2BeM2nsgkaxFVpJgKHvfkep9WTxXsuBRcE/m7xfsiCCKKR9pm
 YsJslS+wF9/DeKJE5acnlxqT1WJ3PUJICpPJo28iK8/aflMIwlpOqwh
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
index 646aaa01177c..3848fa936e38 100644
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


