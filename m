Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B97D39DBF7;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015179; cv=none; b=G1jjQvaKJCQvEGRWt9gx9CVgzNuLVUJc2aYXckO2qaYeDViksXlbjPvj4xIp6w9kY77Gnl3OooAMWEmh28Ql16Wc5QC+Tp1ikoHX+mgCxp3ortxk3uKy7GK11fAyV5NJFEKJLN+jcKbo5sLRU0PLyuHol9akojquES2uZ151Z50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015179; c=relaxed/simple;
	bh=nyZGkqA9jE+Wt5WQfH4jQjx/9FB7V+NCYg0TeF4oThs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kYq3usk5GsCNgVVOUTDNNBrendzIs0W9/2sXnGLjBelCS/HkyIkKdCCf4WeqMKKQPbK37SGP3IZzEUndpmNRpXXVtIbTzEZtBm+D3uCFrhORWc0GOHEcUySlV34B2liHED4j7Bg5fq8YoLT2uASyKfrWWPP0XhTBjPyNtLUk3SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRLcW1ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRLcW1ay"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EB14C2BCF7;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783015179;
	bh=nyZGkqA9jE+Wt5WQfH4jQjx/9FB7V+NCYg0TeF4oThs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CRLcW1ayt89LnoGkj38ROM14kAVCcYBk54flXGZmEpqsCLIf8K3BLxs2caoa+MZn0
	 vOfrKnFqBomwnHOvM3oW3uuM49O4fEudwXS+nFoZLkirvkyzkWnbgzNdy/lv0U+Rqq
	 WJPVyC4JZMsR1B9EDLWftCcgRlNGWHiEbPxBtQ1EBo2U7MO/PD4ehAbut7z0D+KR74
	 m0DznXk4pe1KeMdz9qczehqoyBe15hB5ltkjHPX8T8OO/MDgnSgHi+1z4wPaOeO9ia
	 ltaFVxeuztmZUTliNemMvPRo5NHpdVYOqle9eiirMcPLTZLLpcJLBPxlEoXEwLoKLh
	 VHIc7vUbpk94A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCEDC43327;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 02 Jul 2026 12:59:35 -0500
Subject: [PATCH v3 5/8] ibmvfc: allocate asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-ibmvfc-fpin-support-v3-5-d95b9547cf88@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783015177; l=2700;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=uDOxMbB8uvBIOoiFSNqV1PpDlUddjOkPBOQ0/akLTHo=;
 b=U3EHwHUhQzKgBD2RJ1nYjYkcnSEph6/JMTis4U3ZmRoLwaBfXfQ2yLJs4Vzed428NTOGNr/SU
 ODpiWf+ssFtCPwU8ekK8VfnzDdfR8xm/7NH4WD7/EOitaRoC8AVJ57Q
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Allocate and set up the asynchronous sub-queue for asynchronous
events, as required for full and extended FPIN support.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6dd1e726d9b9..804887fb5635 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5371,6 +5371,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 			for (i = 0; i < active_queues; i++)
 				scrqs->scrqs[i].vios_cookie =
 					be64_to_cpu(setup->channel_handles[i]);
+			scrqs->async_scrq->vios_cookie =
+				be64_to_cpu(setup->async_subq_handle);
 
 			ibmvfc_dbg(vhost, "Using %u channels\n",
 				   vhost->scsi_scrqs.active_queues);
@@ -5421,6 +5423,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
 		for (i = 0; i < num_channels; i++)
 			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
+		setup_buf->async_subq_handle = cpu_to_be64(scrqs->async_scrq->cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6388,6 +6391,17 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 	if (!channels->scrqs)
 		return -ENOMEM;
 
+	channels->async_scrq = kzalloc_obj(*channels->async_scrq, GFP_KERNEL);
+	if (!channels->async_scrq) {
+		rc = -ENOMEM;
+		goto free_scrqs;
+	}
+
+	rc = ibmvfc_alloc_queue(vhost, channels->async_scrq,
+				IBMVFC_SUB_CRQ_FMT);
+	if (rc)
+		goto free_async;
+
 	for (i = 0; i < channels->max_queues; i++) {
 		scrq = &channels->scrqs[i];
 		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
@@ -6396,13 +6410,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 				scrq = &channels->scrqs[j - 1];
 				ibmvfc_free_queue(vhost, scrq);
 			}
-			kfree(channels->scrqs);
-			channels->scrqs = NULL;
+			ibmvfc_free_queue(vhost, channels->async_scrq);
 			channels->active_queues = 0;
-			return rc;
+			goto free_async;
 		}
 	}
 
+	return rc;
+
+free_async:
+	kfree(channels->async_scrq);
+	channels->async_scrq = NULL;
+free_scrqs:
+	kfree(channels->scrqs);
+	channels->scrqs = NULL;
+
 	return rc;
 }
 
@@ -6437,6 +6459,10 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 
 		kfree(channels->scrqs);
 		channels->scrqs = NULL;
+
+		ibmvfc_free_queue(vhost, channels->async_scrq);
+		channels->async_scrq = NULL;
+
 		channels->active_queues = 0;
 	}
 }

-- 
2.54.0


