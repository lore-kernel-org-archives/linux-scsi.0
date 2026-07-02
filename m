Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4FC39EF25;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015179; cv=none; b=DKkgM4qMebXMp5D0iQzYBdaxtkHmFQz4tp8nMn/ovb+cHRRFOS2onf2d4Pq3EX0cKxD5XG7AYWDM9O/6XZxttIDiQl2ZEYb1GPlqyzWM26E+vRw5QecKE+OnbQw4Vzm+L+INB+TOp4Mu4at8Odpu+SbXNPt9jeCBVYU3H/3S1ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015179; c=relaxed/simple;
	bh=PyvJaPZhTS4ONKKajSTHKx/fXAj7Ooynu1ixySZwBF4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pG5iIMj98qcHz+88AT/OHbpMiqdXUjI96/rdge6YKX0RgK/shKg9hgSCA2aX+FPc4D/Y7IZ/sVdwvVsZ1jFEL6UZ4ASWJK66hlxCVuBVePKAsVd2usRsl9UHOBeydLOSN4SuQoHM4jGQvPEsfzcB5gtT5dEdvM4V0dBnA5+HPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nG7pAR7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nG7pAR7V"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D92CC2BCFD;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783015179;
	bh=PyvJaPZhTS4ONKKajSTHKx/fXAj7Ooynu1ixySZwBF4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nG7pAR7VHPKAboZLjI7XHt/FTw8ewqVltfIScmuQtoUS/EyzsRsqaoRzkJ2oXs+kf
	 PqMr8E5dLoxLYx2Fjta1f4nSKiRfCkKojIZKz56XZW3CgVrTWwYYhdU+p6HXgJaQqt
	 EBYYv93cHjOTN3MPo8+fbo1s5l9IJoyXdBJ3O01Wb8J2fqJ12EddXY3qJcGqceSm7P
	 9PB7AAHH8Dk1LkjaBDBP4507F+AuMRPAsFAQTE9FMSuc5zdVwl3I30BHExMb5dF4Sd
	 SIsYShRg3YQFI6vPFtbOxp8kpOeHob6ExqtwmGGiCGP0HYJ7I2/oNdMxeZt3kaEP+u
	 bkU9XnvMJeudw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C575C44500;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 02 Jul 2026 12:59:37 -0500
Subject: [PATCH v3 7/8] ibmvfc: register and use asynchronous sub-queue for
 events
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-ibmvfc-fpin-support-v3-7-d95b9547cf88@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783015177; l=7544;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=l6PI8SD/ZbptZNlj7Hfkl/TY7QR4YidAGNTKqTjfFFI=;
 b=ctNomyBTh9mnyQvhTiuphwA1Uc/1G2WNaRO/oLsiA1G9TXj6PHDYKYFe3pCsBvAgeSUwEYKRN
 hTyWnp5vAmrA9MMctXV6JCKXuRoRgNEju/vLPtkTwiI8jwM60EJET4U
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Set up interrupt handling for asynchronous sub-queue, register the
asynchronous sub-queue as a channel, and enable its use by NPIV login.
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 128 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 106 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4678d76c84fe..36abca0bbd34 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1514,7 +1514,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	login_info->max_cmds = cpu_to_be32(max_cmds);
 	login_info->capabilities =
 		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
-			    IBMVFC_CAN_USE_NOOP_CMD);
+			    IBMVFC_CAN_USE_NOOP_CMD | IBMVFC_YES_SCSI |
+			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN);
 
 	if (vhost->mq_enabled || vhost->using_channels)
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -4235,6 +4236,49 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
 	return crq;
 }
 
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_crq *crq;
+	unsigned long flags;
+	int done = 0;
+
+	spin_lock_irqsave(scrq->q_lock, flags);
+	while (!done) {
+		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
+			ibmvfc_handle_async(crq, scrq->vhost, true);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		}
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		crq = ibmvfc_next_scrq(scrq);
+		if (crq != NULL) {
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_handle_async(crq, scrq->vhost, true);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		} else
+			done = 1;
+	}
+	spin_unlock_irqrestore(scrq->q_lock, flags);
+}
+
+/**
+ * ibmvfc_interrupt_asyncq - Handle an async event from the adapter
+ * @irq:           interrupt request
+ * @scrq_instance: async subq
+ *
+ **/
+static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+{
+	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
+
+	ibmvfc_toggle_scrq_irq(scrq, 0);
+	ibmvfc_drain_async_subq(scrq);
+
+	return IRQ_HANDLED;
+}
+
 static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 {
 	struct ibmvfc_crq *crq;
@@ -6331,14 +6375,27 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 	return retrc;
 }
 
-static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
-				   struct ibmvfc_channels *channels,
-				   int index)
+static inline char *ibmvfc_channel_index(struct ibmvfc_channels *channels,
+					 struct ibmvfc_queue *scrq,
+					 char *buf, size_t bufsize)
+{
+	if (scrq < channels->scrqs || scrq >= channels->scrqs + channels->active_queues)
+		strscpy(buf, "async", 6);
+	else
+		snprintf(buf, bufsize, "%ld", scrq - channels->scrqs);
+	return buf;
+}
+
+static int ibmvfc_register_channel_handler(struct ibmvfc_host *vhost,
+					   struct ibmvfc_channels *channels,
+					   struct ibmvfc_queue *scrq,
+					   irq_handler_t irq)
 {
 	struct device *dev = vhost->dev;
 	struct vio_dev *vdev = to_vio_dev(dev);
-	struct ibmvfc_queue *scrq = &channels->scrqs[index];
+	long hcall_rc;
 	int rc = -ENOMEM;
+	char buf[16];
 
 	ENTER;
 
@@ -6357,20 +6414,23 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		dev_err(dev, "Error mapping sub-crq[%s] irq\n",
+			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
 		goto irq_failed;
 	}
 
 	switch (channels->protocol) {
 	case IBMVFC_PROTO_SCSI:
-		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
-			 vdev->unit_address, index);
-		scrq->handler = ibmvfc_interrupt_mq;
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%s",
+			 vdev->unit_address,
+			 ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
+		scrq->handler = irq;
 		break;
 	case IBMVFC_PROTO_NVME:
-		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
-			 vdev->unit_address, index);
-		scrq->handler = ibmvfc_interrupt_mq;
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%s",
+			 vdev->unit_address,
+			 ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
+		scrq->handler = irq;
 		break;
 	default:
 		dev_err(dev, "Unknown channel protocol (%d)\n",
@@ -6381,32 +6441,43 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
-		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
+		dev_err(dev, "Couldn't register sub-crq[%s] irq\n",
+			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
-	scrq->hwq_id = index;
+	if (scrq >= channels->scrqs && scrq < channels->scrqs + channels->max_queues)
+		scrq->hwq_id = scrq - channels->scrqs;
 
 	LEAVE;
 	return 0;
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;
 }
 
+static inline int
+ibmvfc_register_channel(struct ibmvfc_host *vhost,
+			struct ibmvfc_channels *channels,
+			struct ibmvfc_queue *scrq)
+{
+	return ibmvfc_register_channel_handler(vhost, channels, scrq, ibmvfc_interrupt_mq);
+}
+
 static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 				      struct ibmvfc_channels *channels,
-				      int index)
+				      struct ibmvfc_queue *scrq)
 {
 	struct device *dev = vhost->dev;
 	struct vio_dev *vdev = to_vio_dev(dev);
-	struct ibmvfc_queue *scrq = &channels->scrqs[index];
+	char buf[16];
 	long rc;
 
 	ENTER;
@@ -6421,7 +6492,8 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
 	if (rc)
-		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
+		dev_err(dev, "Failed to free sub-crq[%s]: rc=%ld\n",
+			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)), rc);
 
 	/* Clean out the queue */
 	memset(scrq->msgs.crq, 0, PAGE_SIZE);
@@ -6439,10 +6511,21 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
+	if (ibmvfc_register_channel_handler(vhost, channels,
+					    channels->async_scrq,
+					    ibmvfc_interrupt_async_subq)) {
+		vhost->do_enquiry = 0;
+		return;
+	}
+
 	for (i = 0; i < channels->max_queues; i++) {
-		if (ibmvfc_register_channel(vhost, channels, i)) {
+		if (ibmvfc_register_channel(vhost, channels, &channels->scrqs[i])) {
 			for (j = i; j > 0; j--)
-				ibmvfc_deregister_channel(vhost, channels, j - 1);
+				ibmvfc_deregister_channel(
+					vhost, channels, &channels->scrqs[j - 1]);
+			ibmvfc_deregister_channel(vhost, channels,
+							channels->async_scrq);
+
 			vhost->do_enquiry = 0;
 			return;
 		}
@@ -6461,7 +6544,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 		return;
 
 	for (i = 0; i < channels->max_queues; i++)
-		ibmvfc_deregister_channel(vhost, channels, i);
+		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
+	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);
 
 	LEAVE;
 }

-- 
2.54.0


