Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4539C65F;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015179; cv=none; b=Hv4iarTR5/wBfkXYLFTh5et+bNgmayJejjRmA3VF4nQmtSlb6PtemZ7nM/2nLZS4TyzI3P7ECGnEi4ixeR7LGENA/RGf7I18QVgqt4/QazSwQcwS1UQweAzijTreGIxYITpsBgT4NEcAFRtukG9dpsxQunSQ9NX+9xrhlq8bGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015179; c=relaxed/simple;
	bh=r/yw1PUhy7UV35sOWWHK1QoNpvS3BuqsGA8lL7TwQw0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HxGgPZKyI0oQPkI7F4aeH7DsurVyBV21HKkLl9axqCuXy4hz3SKmNmJCuQNdFyHw0fxt/rBxs15wWCkb81t1uqjDoQBrtvTiFFRozpWq1cLWv2F454t2QU6Gcf1nXembzqAlDwaDiBJ6RbZ2mNhWpauL3ilalO+hKco68QkKwuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRF3jtfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRF3jtfd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48914C2BCFB;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783015179;
	bh=r/yw1PUhy7UV35sOWWHK1QoNpvS3BuqsGA8lL7TwQw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WRF3jtfdipGIVYlCMcdD/dINOSYyxlye9wcDCpvJHHQXWqzQErhx8lLM9z9PlXf/s
	 +ic+D+3DP+64t2BqnDEazHyg/ibrW4hqv6sX44BhcLaMXh93pK2RRv4rvyrTWEmIRN
	 OR4SBIgyqlroKz9UupPkvwI5EpPcga7cDsBGOSmwuDGnSKCAWoGVxcdUp0/rxVWnLn
	 lURxIUmqudpHuPZD7FGBX0XNbFNZSTImy9xoEwRjHpaVNCboyjLX7ff8TMUhjIamnY
	 R13HHoNixC935Lp/6GKBLxlj8uxrmUXuP19suKV/dkzPcm+ckneROOlduVZpFx9VS3
	 Hoj8ME7MmVNiQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3191AC43458;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 02 Jul 2026 12:59:34 -0500
Subject: [PATCH v3 4/8] ibmvfc: define asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-ibmvfc-fpin-support-v3-4-d95b9547cf88@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783015177; l=2549;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=t3GAtt64OVGT26JjyvFfUoKnkOVBvG8xLeMJBBNEB88=;
 b=muyPHW9fm7/uHgwfcgXDf/H7XRobj2kXV51KicjPF5Iebab2Gaan76gsQJ4rVlCXR+K50Y3u5
 rX6by70AGb0Ai49LIPLFkWioSsb7Co/pbymqJRNDYPbRTNZm7LtlFqk
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Defines the asynchronous sub-queue structure, modifies the existing
channel setup structure, adds the asynchronous sub-queue to the
channels structure, and adds flags needed to tell VIOS to use the
sub-queue.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index adfd67e85af8..f38dfae9924c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -182,6 +182,7 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_USE_MAD_VERSION	0x008
 #define IBMVFC_CAN_SEND_VF_WWPN		0x010
 #define IBMVFC_YES_SCSI			0x040
+#define IBMVFC_USE_ASYNC_SUBQ		0x100
 #define IBMVFC_CAN_USE_NOOP_CMD		0x200
 	__be64 node_name;
 	struct srp_direct_buf async;
@@ -230,6 +231,7 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_HANDLE_VF_WWPN		0x0040
 #define IBMVFC_CAN_SUPPORT_CHANNELS	0x0080
 #define IBMVFC_SUPPORT_SCSI		0x0200
+#define IBMVFC_SUPPORT_ASYNC_SUBQ	0x0800
 #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
@@ -564,7 +566,7 @@ struct ibmvfc_channel_setup_mad {
 	struct srp_direct_buf buffer;
 } __packed __aligned(8);
 
-#define IBMVFC_MAX_CHANNELS	502
+#define IBMVFC_MAX_CHANNELS	501
 
 struct ibmvfc_channel_setup {
 	__be32 flags;
@@ -579,6 +581,7 @@ struct ibmvfc_channel_setup {
 	struct srp_direct_buf buffer;
 	__be64 reserved2[5];
 	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
+	__be64 async_subq_handle;
 } __packed __aligned(8);
 
 struct ibmvfc_connection_info {
@@ -715,6 +718,25 @@ struct ibmvfc_async_work {
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
@@ -854,6 +876,7 @@ struct ibmvfc_queue {
 
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
+	struct ibmvfc_queue *async_scrq;
 	enum ibmvfc_protocol protocol;
 	unsigned int active_queues;
 	unsigned int desired_queues;

-- 
2.54.0


