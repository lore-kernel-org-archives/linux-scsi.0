Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB6377015;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029461; cv=none; b=cj8AuHxfnXKNTkJh+PawQFTkfgUEazrVpXlQlRIhRKcepdJSOSgNwptCX+Ok6XYhhfgQr5QOQKX0c+Q7n0YBGe/Xd9iPBoVK5G1PBpjaCvDVBdaWm4PnkFDL9SoErfkE4haA5HV3us1rnJfm5YQM7q8rZI0BimZSPW6bvNKKBJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029461; c=relaxed/simple;
	bh=NpORjKnGGwSWjo96rY491mQ4DCuXGuJzwqjHxSwNKB0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=avaoelKBJqmX6yob2X7PBntkR/ygqvuY0FFsXEcpMplc1bWRXUEXehj4WQcRUA6lkCBNPK3OHwLZJH4CSLmBa404RX6bnMFXg3FyIsr58Z8uuPuKnICmqoaXczynacUOU+LYH4a00JUPLNFrJ/lF/A5xNk8v9wJXdRTrb4RCQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STKdnQNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STKdnQNm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD6AAC2BCF7;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786029460;
	bh=NpORjKnGGwSWjo96rY491mQ4DCuXGuJzwqjHxSwNKB0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=STKdnQNmPVMeb64FDz98TcSXhTcT5hjpa7BYjytrdcCihGselS5M2B/WukUeCkMRO
	 3QvdV8jl2FoNZctVu3jxSLAeEL+ysIf287SVxd/oR6oatmNQuVQuO7FUQgW51lHPRp
	 q8VU6IRf6k0qgU06AerKfAH+otcVVb9ALdcFey+teZNgNmK5S8hxzIyPimFSXX4Twe
	 t30SRxyu8ZPJs93WfeYKc8A26smzgPDH5tp2Zp81QeYIPlve2RlSrplTCoE/FY0ryR
	 OGZQKFKZ0n72vsBeusaBzarqE+2dpN/s+7BKxHvj2KBwPzu5nereivkPAMIIWig3JC
	 mOuT48tyBUDRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3579C56205;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 06 Aug 2026 10:17:33 -0500
Subject: [PATCH v5 3/7] scsi: ibmvfc: define asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-ibmvfc-fpin-support-v5-3-13fd6f8a8f8b@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786029459; l=1853;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=w68m3zR1aKLFee7eqfMuZfkcraWrl8VL7pHlxbyiDug=;
 b=EShFeXOjm+MksZFb+wLG8x+m98Oq4fE/ypTeNJ/BB3QEVRM7POCIFoZ+E9bbOccrcGTPt72m6
 E6Gce7LJwVsD5NMz1jJ608Nei+4iLjUMakiALFxXZImLIa5DPrId85B
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
 drivers/scsi/ibmvscsi/ibmvfc.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index e8ca0d30f483..3711be4b6748 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -791,6 +791,25 @@ struct ibmvfc_async_work {
 	struct work_struct async_work_s;
 };
 
+struct ibmvfc_async_subq {
+	volatile u8 valid;
+#define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+#define IBMVFC_FC_EEH			0x04
+#define IBMVFC_FC_FW_UPDATE		0x08
+#define IBMVFC_FC_FW_DUMP		0x10
+	u8 flags;
+	u8 link_state;
+	u8 fpin_status;
+	__be16 event;
+	__be16 pad;
+	volatile __be64 wwpn;
+	volatile __be64 nport_id;
+	union {
+		__be64 node_name;
+		__be64 assoc_id;
+	} id;
+} __packed __aligned(8);
+
 union ibmvfc_iu {
 	struct ibmvfc_mad_common mad_common;
 	struct ibmvfc_npiv_login_mad npiv_login;
@@ -935,6 +954,7 @@ struct ibmvfc_queue {
 
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
+	struct ibmvfc_queue *async_scrq;
 	enum ibmvfc_protocol protocol;
 	unsigned int active_queues;
 	unsigned int desired_queues;

-- 
2.55.0


