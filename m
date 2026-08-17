Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B533BE644;
	Mon, 17 Aug 2026 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998481; cv=none; b=EJ3Ng4qlVrhKkAcy+gkE3tmTstlG7MKSll95VpJ1VfmBXTdhtkM6TZ07GKGqtV9zyiCMex1XI+LNICRfPCOyIywrKFNJgCUAS1zYQf3l/v08wQJJaxaKqFsqw8PnCJWTmJ9k7L8vSHRtmz4z1G4k5RO8rKRvx5WO6AOwUQryNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998481; c=relaxed/simple;
	bh=0xav3ZG2vwafFbyRgSfB4B8YteusTxcTD4O99qBOm9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SXT3ySAHYN11P2OKwUn2e8rzHUhl+TrMhmEakNIkAPJ0f60VeAV/2y1UGY47zzwrZLSNhDo9iowDCPzkhUuLaR58gIdtVr9amt7rynX+4FpvzpmDKJhC2CMoU2jWNEPMwpVYLBwCxygjGvNVAFrR5Mf80zNfopqcA5wjUQU8+tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJ0rEFLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJ0rEFLx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E307FC2BCFD;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786998480;
	bh=0xav3ZG2vwafFbyRgSfB4B8YteusTxcTD4O99qBOm9I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LJ0rEFLxSD8Sd6xWr4m5FieJpyoxlOWD4LdvUJqz+HyKZ1KKfpMIRqHNkuoyYMEnu
	 CeAPBg6L4hj/1TF2s3n0fhcs2Y+DD6IPOw1/nf4NmrHLOjf14iF3mzxQsIi8fvN4bC
	 BRFlaiIwVeor2JSrnSpzgttHPUgLYfhxxRnhnhtTPO5X5Ph6Gpo9A+YKPb7HQM/tHl
	 7sW9/2tXGKM3xNPL6M+DZ0P6LvabHWp2iNP8DxxR8i3OZEeQB8DRA/Snlido5V1ZGe
	 GyNt97C6ryYXrSLbf7cGQAVgCGGxZqLUGpxwM9lTGMFzJjzt0DqTMioPzi/k6ItcNv
	 gtvni6FJ5gqMQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A5DC5B572;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 17 Aug 2026 15:28:00 -0500
Subject: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub CRQ
 for events
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-ibmvfc-fpin-support-v6-7-62a2d525e70d@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786998478; l=4793;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=j22BIxygRjLa4p+iYGPOotTe0EA7iaqbwa3Kd3tyrQ0=;
 b=bmM1vQX/hlqZescK8GyIzDVs13rycnVQ8XYyh2XPfyATmUqG9Yqb5T4roaPkoGnU19d30Y1gj
 daUXzc6XyV9BhsxITyxziYnDvV/NpasYpGwbNwYJP8ho59+tARxt7Ye
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ queue buffer via
ibmvfc_alloc_queue() before allocating the SCSI channels. Register it
with the VIOS by calling ibmvfc_register_channel() with index -1 (the
negative-index sentinel introduced in the previous commit). Either
failure disables multi-queue and aborts init.

In ibmvfc_release_sub_crqs(), deregister and free the async sub-CRQ
before tearing down the SCSI channels.

In ibmvfc_channel_setup_done(), capture the async sub-CRQ handle
returned by the VIOS in the channel setup response and store it in
vhost->async_sub_crq.vios_cookie.

In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
set for NVMe-enabled configurations; move it to the common multi-queue
path so it is always advertised when channels are in use.
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index da34b572518a..686142761863 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1568,9 +1568,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 		if (vhost->nvme_enabled) {
 			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
-			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
 			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
 		}
 	}
@@ -5749,6 +5751,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5808,6 +5811,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		setup_buf->async_sub_crq_handle = cpu_to_be64(vhost->async_sub_crq.cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6879,7 +6883,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
 			for (j = i; j > 0; j--)
-				ibmvfc_deregister_channel(vhost, channels, j - 1);
+				ibmvfc_deregister_channel(
+					vhost, channels, j - 1);
+
 			vhost->do_enquiry = 0;
 			return;
 		}
@@ -6934,10 +6940,27 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
+	int rc = 0;
+
 	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
+	rc = ibmvfc_alloc_queue(vhost, &vhost->async_sub_crq, IBMVFC_SUB_CRQ_FMT);
+	if (rc) {
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		return;
+	}
+
+	/* register async_sub_crq channel */
+	if (ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1)) {
+		ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
+		vhost->do_enquiry = 0;
+		vhost->mq_enabled = 0;
+		return;
+	}
+
 	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
 		vhost->do_enquiry = 0;
 		vhost->mq_enabled = 0;
@@ -6980,6 +7003,9 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
+	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
+	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
+
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
 
@@ -7258,7 +7284,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
 	mutex_init(&vhost->passthru_mutex);
 
-	vhost->fpin_workq = alloc_workqueue("%s-fpin-workq-%u", 0, 0,
+	vhost->fpin_workq = alloc_workqueue("%s-fpin-workq-%u", WQ_PERCPU, 0,
 						 IBMVFC_NAME, shost->host_no);
 	if (vhost->fpin_workq == NULL)
 		goto free_scsi_host;

-- 
2.55.0


