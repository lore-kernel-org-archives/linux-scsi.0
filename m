Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85D51EDFF;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792618; cv=none; b=NMPVueLsKLRTUQA1o/p/MQ1Lwhd2KdL6MppWE3IW+5buqQWjZTmSoTXGhXHdWcFveDy/GmgGOB0Z9rpPQuvjKFKG1NK6D5ijK9Gt0PXD+6eKVnDCxwJ+a0/LubCyuhEYtYBDdPP9tVBHrvuHTPD6IiV9+qV9SHv6ATVJzJSFJXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792618; c=relaxed/simple;
	bh=rK/SavcgqPzwClCLU8F78BdPVvtBbvnkY1KEXMjfL4c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MRaYZ6IHNkffNW8hkzzIGLAaP0ogM0ccvEbqLFOP+Jb3imLJ7Hormtm/qp0OaWBsqZa8PQRICMxefhkp4epU0u0V2D08NTdHNGSVjtzCHhkSwhcG8Gcx+lqym42KpTy5LoQa3n8b1YTrPtYcDVPFHmxl1FEG+eTP39lKxsgMFcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p24+F26a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p24+F26a"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7AB5C4AF18;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790792617;
	bh=rK/SavcgqPzwClCLU8F78BdPVvtBbvnkY1KEXMjfL4c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=p24+F26a8S0oibdPKtk0uTz0k/f6/3T8VFVw8GmkTlOsMK3LLwxeKSGAqSLGRALte
	 vgKSHyeEmhLijJhL52gv1Ny9ucxg76Okr857KT6narA/oh+3Cj8IZY6rrzVUGn7O3e
	 4SPUaM4O3BBji41fthEETgGqs6TzpDMfY54K6T0aEHUVUi2BEgjNNw3EtEVseuAbf0
	 +mTiFLiIaHOn1DC/YJCq6/wyZG5pE+6m+mCvEBgjRrNCyd/eALaSrlegMt00TyVz5L
	 LB6Pb+Bl+Jh5d69fugvqDadRJCAE2E2NlTZt2MPgTIhpyPUZ2toun55hjxSNT1MuxG
	 HGfIl9AKQmmrg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FBDCA5FC5;
	Wed, 30 Sep 2026 18:23:37 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Wed, 30 Sep 2026 13:23:36 -0500
Subject: [PATCH v12 08/11] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-ibmvfc-fpin-support-v12-8-53a3fff7d77b@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790792616; l=2919;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=4wU1+XD4KWZbvOe7+5eUsYhuxWymvhpzhImvVnwEIQA=;
 b=eEGLao4ijxuP5jHmNi+dEgPYMWvLN6RjWLe0CuQyQ2krTHf2/BsXvnAv+luGwGHbyxf5QcdWC
 6vbCGG3p1FnDTLYyK/UmYgtOrmK6OiIIlMMfc9OmoiWlA/Nh3IStF6t
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Add ibmvfc_interrupt_async_subq(), an IRQ handler dedicated to
asynchronous sub-CRQ events from the adapter. The handler disables
the sub-CRQ IRQ and then calls ibmvfc_drain_async_subq() to consume
all pending entries before re-enabling interrupts.

ibmvfc_drain_async_subq() holds the per-queue q_lock while
processing. It loops over available CRQ entries via ibmvfc_next_scrq(),
wrapping each in a typed struct ibmvfc_async_crq_event and dispatching
it to ibmvfc_handle_async(), then clears the valid bit and issues a
write barrier. After draining, it re-enables the sub-CRQ IRQ and performs
one final check for a newly arrived entry to close the IRQ-enable race;
if one is found it is processed before exiting the loop.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 54 +++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 88941ad85e86..86383fd5b338 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4377,6 +4377,60 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
 	return crq;
 }
 
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_host *vhost = scrq->vhost;
+	unsigned long flags;
+	struct ibmvfc_crq *crq;
+	int done = 0;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock(scrq->q_lock);
+	while (!done) {
+		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_SUB,
+				.subq = *(struct ibmvfc_async_sub_crq *)crq,
+			};
+			ibmvfc_handle_async(&ae, scrq->vhost);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		}
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		crq = ibmvfc_next_scrq(scrq);
+		if (crq != NULL) {
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_SUB,
+				.subq = *(struct ibmvfc_async_sub_crq *)crq,
+			};
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_handle_async(&ae, scrq->vhost);
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
+ * ibmvfc_interrupt_async_subq - Handle an async event from the adapter
+ * @irq:           interrupt request
+ * @scrq_instance: async subq
+ *
+ **/
+static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
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

-- 
2.55.0


