Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476413E1205;
	Thu,  6 Aug 2026 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029461; cv=none; b=FBPnpemHzYLKyxbvNipIDOgytKyVHAAB0I7SGtmBRN7weeR0YfnWpOno+lvY4ocHIFkAgLgkBXbCqYhsIcwAH404QwPEiMvkxdO2zLj8XjX0GpO2aZkzKzmc8WRJ2KL9CF9pez547pdpD9KVDu54oNC2muLAtlgNI+kvZ/yuSZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029461; c=relaxed/simple;
	bh=GCpp8loI/qph9CLzy+fFISXczkAT4Cpt7iOweu2NwRs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fNRI1MkAcn/RSDaCqW3LZ2+0jM7i1aZM+hZmY2jme6mRORBXwZ+YN5ws5EC7t0YUpaV2Z3C0XyfLh0MhD4Bh9WelejYL4bMtV9gAuZAqL+5FP9ifKFHV1DqlZas5FdsFcRb3zHCfo3irdOx5KZOZQ5IwQrg7N3NAEkSlyXAIsJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owik93Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owik93Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F09F7C2BCFF;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786029461;
	bh=GCpp8loI/qph9CLzy+fFISXczkAT4Cpt7iOweu2NwRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=owik93Tl/AuuoOAu7IwY03tiIwMmvPPnxNCflN5phhQb/fqdOordsRorZlF3hydna
	 FsyMGw12BV5iQb5p6bp/AUH68jc51pMGDMI01yjaLUX0RN4kQdVfOy9qv9KUyGXQW7
	 Z9FkfJ6g/2raZjg0eeP2gQakVvN8EGFqv4m6AEaXPX1EPXsSzajGyJT89VOy5M4IIC
	 afDD5rBhMRVxm08akknqnD+InLrAE1NxTBr7zqK/kOpf4AhAqOlx6iAN2RBMXjJtfv
	 U3nL1i6d9BELzvnOZztuB7WkBrnPR6XSobwJ8W3UqLfR0AumtrwmoasQ6QsCja7GoJ
	 hAPyauke1uVUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC760C56207;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 06 Aug 2026 10:17:36 -0500
Subject: [PATCH v5 6/7] scsi: ibmvfc: register and use asynchronous
 sub-queue for events
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-ibmvfc-fpin-support-v5-6-13fd6f8a8f8b@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786029459; l=8719;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=fCuKuW0pL10CRvqISUmrayWRJcBYtnsRj+Nrw2rw9WU=;
 b=k94URTV124LThEM0RS/RNjfDe4FWM2nzMWsLX2DIvpeoYWrfmVQfHL8xo9oDdODdqLcv3cSME
 +HSlYdxXjkeDNP0K0XKjSRwKWJsdnHPCGBnHzLDhtzulZkz793mDc4e
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Complete async sub-queue integration by setting up interrupt handling,
registering the queue as a channel, and enabling its use during NPIV
login.

Add ibmvfc_interrupt_async_subq() interrupt handler and
ibmvfc_drain_async_subq() to process events from the async sub-queue.
Refactor ibmvfc_register_channel() into ibmvfc_register_channel_common()
to support both regular sub-CRQs and the async sub-queue with different
interrupt handlers.

Update ibmvfc_set_login_info() to set IBMVFC_CAN_USE_CHANNELS,
IBMVFC_YES_SCSI, IBMVFC_USE_ASYNC_SUBQ, and IBMVFC_CAN_HANDLE_FPIN
capability bits when channels are enabled, informing VIOS that the client
supports async sub-queue and FPIN handling.

Register async_scrq during channel initialization and unregister during
cleanup.
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 146 ++++++++++++++++++++++++++++++------
 1 file changed, 124 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 230bf2be6531..c002226f4617 100644
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
@@ -4321,6 +4323,52 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
 	return crq;
 }
 
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_host *vhost = scrq->vhost;
+	struct ibmvfc_crq *crq;
+	unsigned long flags;
+	int done = 0;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock(scrq->q_lock);
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
+	spin_unlock(scrq->q_lock);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
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
@@ -6666,14 +6714,29 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 	return retrc;
 }
 
-static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
-				   struct ibmvfc_channels *channels,
-				   int index)
+/**
+ * ibmvfc_register_channel_common - Register a sub-CRQ with the hypervisor
+ * @vhost:	ibmvfc host struct
+ * @channels:	ibmvfc channels struct
+ * @scrq:	sub-CRQ to register
+ * @index:	channel index (negative for async)
+ * @irq:	interrupt handler for the sub-CRQ
+ *
+ * Return value:
+ *	0 on success / non-zero on failure
+ **/
+static int ibmvfc_register_channel_common(struct ibmvfc_host *vhost,
+					  struct ibmvfc_channels *channels,
+					  struct ibmvfc_queue *scrq,
+					  int index,
+					  irq_handler_t irq)
 {
 	struct device *dev = vhost->dev;
 	struct vio_dev *vdev = to_vio_dev(dev);
-	struct ibmvfc_queue *scrq = &channels->scrqs[index];
+	long hcall_rc;
 	int rc = -ENOMEM;
+	const char *name_suffix;
+	bool is_async = (index < 0);
 
 	ENTER;
 
@@ -6692,20 +6755,19 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	if (!scrq->irq) {
 		rc = -EINVAL;
-		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
+		if (is_async)
+			dev_err(dev, "Error mapping sub-crq[%s] irq\n", "async");
+		else
+			dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
 		goto irq_failed;
 	}
 
 	switch (channels->protocol) {
 	case IBMVFC_PROTO_SCSI:
-		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
-			 vdev->unit_address, index);
-		scrq->handler = ibmvfc_interrupt_mq;
+		name_suffix = "scsi";
 		break;
 	case IBMVFC_PROTO_NVME:
-		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
-			 vdev->unit_address, index);
-		scrq->handler = ibmvfc_interrupt_mq;
+		name_suffix = "nvmf";
 		break;
 	default:
 		dev_err(dev, "Unknown channel protocol (%d)\n",
@@ -6713,35 +6775,63 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		goto irq_failed;
 	}
 
+	if (is_async) {
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-%s%s",
+			 vdev->unit_address, name_suffix, "async");
+		scrq->handler = irq;
+	} else {
+		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-%s%d",
+			 vdev->unit_address, name_suffix, index);
+		scrq->handler = irq ? irq : ibmvfc_interrupt_mq;
+		scrq->hwq_id = index;
+	}
+
 	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
 
 	if (rc) {
-		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
+		if (is_async)
+			dev_err(dev, "Couldn't register sub-crq[%s] irq\n", "async");
+		else
+			dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
 		irq_dispose_mapping(scrq->irq);
 		goto irq_failed;
 	}
 
-	scrq->hwq_id = index;
-
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
 
+static int ibmvfc_register_channel_async(struct ibmvfc_host *vhost,
+					   struct ibmvfc_channels *channels,
+					   struct ibmvfc_queue *scrq,
+					   irq_handler_t irq)
+{
+	return ibmvfc_register_channel_common(vhost, channels, scrq, -1, irq);
+}
+
+static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
+				   struct ibmvfc_channels *channels,
+				   int index)
+{
+	struct ibmvfc_queue *scrq = &channels->scrqs[index];
+
+	return ibmvfc_register_channel_common(vhost, channels, scrq, index, NULL);
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
 	long rc;
 
 	ENTER;
@@ -6756,7 +6846,7 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 
 	if (rc)
-		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
+		dev_err(dev, "Failed to free sub-crq[%s]: rc=%ld\n", scrq->name, rc);
 
 	/* Clean out the queue */
 	memset(scrq->msgs.crq, 0, PAGE_SIZE);
@@ -6774,10 +6864,21 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
+	if (ibmvfc_register_channel_async(vhost, channels,
+					  channels->async_scrq,
+					  ibmvfc_interrupt_async_subq)) {
+		vhost->do_enquiry = 0;
+		return;
+	}
+
 	for (i = 0; i < channels->max_queues; i++) {
 		if (ibmvfc_register_channel(vhost, channels, i)) {
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
@@ -6796,7 +6897,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 		return;
 
 	for (i = 0; i < channels->max_queues; i++)
-		ibmvfc_deregister_channel(vhost, channels, i);
+		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
+	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);
 
 	LEAVE;
 }

-- 
2.55.0


