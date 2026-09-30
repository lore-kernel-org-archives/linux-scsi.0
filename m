Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2400551EE1C;
	Wed, 30 Sep 2026 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792618; cv=none; b=NYpmZaMxWz2yNkI6qrEvkqNZgd6WwxJDs/SZGShCpSQQFEITvmEWTvVSsMULcVNTsSdICyrdOCMsQjElbPLnLz83vwwhM+h0d4Xj/nnUHBCal9PslxNhQC3A6D+81c/hKpX2DjAbbEQMN7UcrlP/jPzgcXsfBQu8xgzkYSn8Nes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792618; c=relaxed/simple;
	bh=bmDM03+tLd+AuWbBgeoQZy2DHCFIayB04YrQozuSbYs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qdK2M9PgvPKi4wJqhiCdiCA+b8d67AoLaUElK7ZlZ0Lx0SCL51d97F3MhXZVg+FQVEJVbh/3z3Ac9p8x9rrauIc90Ql9dmA0VlB7yfIQJmAw8Jl25g2n3o7iFRB0iLxyHvXsufE1LTmVsI5gDpehag9PzHuZpCdIQIUA9S12jhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iqvv/N3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iqvv/N3v"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3301C4AF14;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790792617;
	bh=bmDM03+tLd+AuWbBgeoQZy2DHCFIayB04YrQozuSbYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Iqvv/N3vY2En3A8+Wsf3w9de/rBhYkex4qHSd0Illf0CLhu0/cZzAtwUTQjSrww7X
	 RxikwnFdKu8QBtH74uM2NS1BJomVBY6iEBE7J+9/TtFKH8yk4HxSi6D9mE0o9g6CbT
	 ZePSdHG8TCJ/NToHn0p8fTZUWUlSpE2YGWhypb0hCyRMy4eQT4zXytQ1B/+gIwRj29
	 8RCyqRsVTnLmDJPdbMGtq1nDbJlev+yRgvEzLzhnskIPWq2BctL91aNQk3QFB/ZUJq
	 ahjwcbswnfoHc7y/E4kC/1M8+OYgFBlKSbLGdHZ4P+MKzyGxlAgsee1xtMTOurHEwQ
	 21EBC+jeLgM5g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C266ACA5FCF;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 30 Sep 2026 13:23:38 -0500
Subject: [PATCH v12 10/11] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-ibmvfc-fpin-support-v12-10-53a3fff7d77b@linux.ibm.com>
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
In-Reply-To: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790792616; l=9310;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=qbp6BXJ3Cxq1a0a81BRBpvZX760ztAmWe+5bW21VEEE=;
 b=0ZTbdrfz9fc6yNFW3n+InoWiHQrXqnAPMHrF78TEvLPb+jtTi+J5kMls99wxO87e0LTgsmJ5W
 WXQ7i5ILuW6CgbWdz0yAu8IC+4RZufcqc7vYwP8PIvLpWNzkw+jI4OF
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

In ibmvfc_probe(), initialize vhost->async_scrqs with desired_queues=1,
max_queues=1, and protocol=IBMVFC_PROTO_ASYNC. Add
ibmvfc_release_channels() as a helper to free a channels array and its
queue buffers.

In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ via
ibmvfc_alloc_channels() before allocating the SCSI channels. Register it
with the VIOS via ibmvfc_reg_sub_crqs(). Either failure disables
multi-queue and aborts init.

In ibmvfc_alloc_channels(), select IBMVFC_ASYNC_SUB_CRQ_FMT for async
protocol channels instead of IBMVFC_SUB_CRQ_FMT, so the queue is sized
for ibmvfc_async_sub_crq entries.

In ibmvfc_release_sub_crqs(), ibmvfc_reenable_crq_queue(), and
ibmvfc_reset_crq(), deregister and re-register the async sub-CRQ
alongside the SCSI channel queues.

In ibmvfc_channel_setup_done(), capture the async sub-CRQ handle
returned by the VIOS in the channel setup response and store it in
vhost->async_scrqs.scrqs[0].vios_cookie. Pass the async sub-CRQ cookie
to the VIOS in ibmvfc_channel_setup() via async_sub_crq_handle.

In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
set for NVMe-enabled configurations; move it to the common multi-queue
path so it is always advertised when channels are in use.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 83 ++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 3d1d38993a83..37aea76be17c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -964,6 +964,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -986,6 +987,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1006,6 +1008,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1042,6 +1045,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
@@ -1584,9 +1588,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
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
@@ -5782,6 +5788,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
@@ -5812,6 +5819,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		for (i = 0; i < nvme->active_queues; i++)
 			nvme->scrqs[i].vios_cookie =
 				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+		async->scrqs[0].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
 
 		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
 			   scsi->active_queues);
@@ -5846,6 +5854,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	struct ibmvfc_channels *async = &vhost->async_scrqs;
 	unsigned int scsi_channels =
 		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
 	unsigned int nvme_channels =
@@ -5871,6 +5880,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		for (i = 0; i < nvme_channels; i++)
 			setup_buf->channel_handles[scsi_channels + i] =
 				cpu_to_be64(nvme->scrqs[i].cookie);
+		setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6718,6 +6728,9 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		queue->evt_depth = scsi_qdepth;
 		queue->reserved_depth = IBMVFC_NUM_INTERNAL_SUBQ_REQ;
 		break;
+	case IBMVFC_ASYNC_SUB_CRQ_FMT:
+		fmt_size = sizeof(*queue->msgs.async_scrq);
+		break;
 	default:
 		dev_warn(dev, "Unknown command/response queue message format: %d\n", fmt);
 		return -EINVAL;
@@ -6989,6 +7002,7 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 				 struct ibmvfc_channels *channels)
 {
 	struct ibmvfc_queue *scrq;
+	enum ibmvfc_msg_fmt fmt;
 	int i, j;
 	int rc = 0;
 
@@ -6996,9 +7010,11 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 	if (!channels->scrqs)
 		return -ENOMEM;
 
+	fmt = (channels->protocol != IBMVFC_PROTO_ASYNC) ? IBMVFC_SUB_CRQ_FMT :
+		IBMVFC_ASYNC_SUB_CRQ_FMT;
 	for (i = 0; i < channels->max_queues; i++) {
 		scrq = &channels->scrqs[i];
-		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
+		rc = ibmvfc_alloc_queue(vhost, scrq, fmt);
 		if (rc) {
 			for (j = i; j > 0; j--) {
 				scrq = &channels->scrqs[j - 1];
@@ -7014,17 +7030,39 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 	return rc;
 }
 
+static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
+				    struct ibmvfc_channels *channels)
+{
+	struct ibmvfc_queue *scrq;
+	int i;
+
+	if (channels->scrqs) {
+		for (i = 0; i < channels->max_queues; i++) {
+			scrq = &channels->scrqs[i];
+			ibmvfc_free_queue(vhost, scrq);
+		}
+
+		kfree(channels->scrqs);
+		channels->scrqs = NULL;
+		channels->active_queues = 0;
+	}
+}
+
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
+
 	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
-	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
-		vhost->do_enquiry = 0;
-		vhost->mq_enabled = 0;
-		return;
-	}
+	/* register async_sub_crq channel */
+	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
+		goto out;
+
+	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
+
+	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
+		goto deregister_async_sub_crq;
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
@@ -7036,29 +7074,23 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 	}
 
 	LEAVE;
-}
-
-static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
-				    struct ibmvfc_channels *channels)
-{
-	struct ibmvfc_queue *scrq;
-	int i;
-
-	if (channels->scrqs) {
-		for (i = 0; i < channels->max_queues; i++) {
-			scrq = &channels->scrqs[i];
-			ibmvfc_free_queue(vhost, scrq);
-		}
+	return;
 
-		kfree(channels->scrqs);
-		channels->scrqs = NULL;
-		channels->active_queues = 0;
-	}
+deregister_async_sub_crq:
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
+out:
+	vhost->do_enquiry = 0;
+	vhost->mq_enabled = 0;
+	return;
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
 	ENTER;
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
+	ibmvfc_release_channels(vhost, &vhost->async_scrqs);
+
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
@@ -7324,6 +7356,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;
 
 	vhost->mq_enabled = mq_enabled;
+	vhost->async_scrqs.desired_queues = 1;
+	vhost->async_scrqs.max_queues = 1;
+	vhost->async_scrqs.protocol = IBMVFC_PROTO_ASYNC;
 	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->scsi_scrqs.protocol = IBMVFC_PROTO_SCSI;

-- 
2.55.0


