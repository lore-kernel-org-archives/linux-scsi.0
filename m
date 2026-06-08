Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0D3D564B;
	Mon,  8 Jun 2026 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943425; cv=none; b=UICj2R54mkqnQXNxl8NLWFXIyDgYbUyVBhBJ6lZ6iCXkHRKiVN+Qihx8IX8U3nCMFHDeJ9eryTJ+7l3kjz34YwkZaEKkpZl9BaE96tXSuWXanS9BtB7Bp07h5a7RRa9mRtht3mkvtfkeP5XXlAbZua4DKIJOnsupuxaInCwckTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943425; c=relaxed/simple;
	bh=WN/uN4JdRNJqo5v7zBaxw2Rc3Vdl8fe2Ys3xy2D3LPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJpMvpzJOplVFUiaLGGbcHH/kO47IYXQ0Tn1h2dlayl3sdAgRM+EV5eGrpMXowFayE94xd7Y2ObXf/Fz+lGW+v9HIhQwdCXGKR0dZ3Ecq6i1G4qhXkUpwNJ1hZVeLA1DHPkC7sDKR91me03jxWHNQKaLKp2BMjZD7RErXmuM0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J379PECU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J379PECU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAA07C4AF13;
	Mon,  8 Jun 2026 18:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1780943424;
	bh=WN/uN4JdRNJqo5v7zBaxw2Rc3Vdl8fe2Ys3xy2D3LPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J379PECUfuqCe33XlMQCTJscX9efWVmAcjxTnUBdzqbFk0O4ETRy0X0ktHBe3MPFZ
	 HPnhx+vUFAmwhdBjacYKtkQ18jFFyaXGO62Zz9hdlsb0WC25H/Xx56tvKOoGvIiRfH
	 BhGn4dJE8u/CdWvWQ4njJAzCdR4e8fgKca8vIMTuz2maI9mYKC7/bF4HRLK0Nbbmyu
	 LRN4iGnRMuuzCpmaDJ//5e8rGwGN4BBIHZftUq+oS9R+UyWW8oZ0hvihxFUY5+usUS
	 aW+VenLxoRYU6V5/7TpwZvdZ+nV9r7xaQGh7z18Jl2SylIb1pQecF50RMveM5TbZV0
	 4cZXf379VhbPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7046CD8CAA;
	Mon,  8 Jun 2026 18:30:24 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 08 Jun 2026 13:30:19 -0500
Subject: [PATCH v2 4/7] ibmvfc: define asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-ibmvfc-fpin-support-v2-4-d41f540fba5c@linux.ibm.com>
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
In-Reply-To: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780943423; l=2517;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=yA6tb5h9yHjsRv3RYlRjKBFZQlRZRIaWtxJ2hzF2GyA=;
 b=0zrGohOtPsnfaeBPgoDs9nTfdpfFnt/2uEoXKfYHbtytnom9kUeHBoNyfjGEzkpQAB30mVgTd
 HQfrSUFgk4/B0+KYMqQGg8fth2alskc6gW6XrA6ROFh1/+31hSzAJCM
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Adds the asynchronous sub-queue structure, modifies the existing
channel setup structure, adds the asynchronous sub-queue to the
channels structure, and adds flags needed to tell VIOS to use the
sub-queue.
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index c996b36d335d..f026f30f98d3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -181,6 +181,8 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_HANDLE_FPIN		0x04
 #define IBMVFC_CAN_USE_MAD_VERSION	0x08
 #define IBMVFC_CAN_SEND_VF_WWPN		0x10
+#define IBMVFC_YES_SCSI			0x40
+#define IBMVFC_USE_ASYNC_SUBQ		0x100
 #define IBMVFC_CAN_USE_NOOP_CMD		0x200
 	__be64 node_name;
 	struct srp_direct_buf async;
@@ -229,6 +231,7 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_HANDLE_VF_WWPN		0x40
 #define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
 #define IBMVFC_SUPPORT_SCSI		0x200
+#define IBMVFC_SUPPORT_ASYNC_SUBQ	0x800
 #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
@@ -563,7 +566,7 @@ struct ibmvfc_channel_setup_mad {
 	struct srp_direct_buf buffer;
 } __packed __aligned(8);
 
-#define IBMVFC_MAX_CHANNELS	502
+#define IBMVFC_MAX_CHANNELS	501
 
 struct ibmvfc_channel_setup {
 	__be32 flags;
@@ -578,6 +581,7 @@ struct ibmvfc_channel_setup {
 	struct srp_direct_buf buffer;
 	__be64 reserved2[5];
 	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
+	__be64 asyncSubqHandle;
 } __packed __aligned(8);
 
 struct ibmvfc_connection_info {
@@ -714,6 +718,25 @@ struct ibmvfc_async_work {
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
@@ -853,6 +876,7 @@ struct ibmvfc_queue {
 
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
+	struct ibmvfc_queue *async_scrq;
 	enum ibmvfc_protocol protocol;
 	unsigned int active_queues;
 	unsigned int desired_queues;

-- 
2.54.0


