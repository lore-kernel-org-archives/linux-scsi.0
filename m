Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6C343D63;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029461; cv=none; b=ggQrB7O8f505yuuVuRius45Wgq6CYA2QCrW0kfc5tGoXY5N1PQiYMdRUD4YuJB6SVf92TfBcge7QvY/pqG/WgDorEHKiOzThVN4mjyGuSRuXMzC8HVhX9X+Tg1f+4xKe7pB/Z/sgW5NwcKzZZ8Fi/m0dcHelFYBM6kpzCVh52kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029461; c=relaxed/simple;
	bh=FsXcpIYOs0w8fAtVAyJEkoHOmC2YdXOKAfol/LybEx4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SY9+QWqyl46QW1Cx5NlasTjgaEzNTKOODQYmPSq22KQISYp4T9bP39P8DJ5VV5Pb33ID4Qug8oJ/8TSTcLZLiBHcblypH4AzO1QPWOBtRL+yXWyoi1X0es+lssbZRkf6SdtUan2FIYX3wY5tLwyRMasxNS4FZPSx9ICi2wnMJYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/V09KsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/V09KsR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAB74C2BCFD;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786029460;
	bh=FsXcpIYOs0w8fAtVAyJEkoHOmC2YdXOKAfol/LybEx4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R/V09KsR0hIvHyqnuqMxONvRlNEZJ5EBfBf1SzMZc2Ga4CJAuGnHfFma4NQZ9wJTK
	 ZvHMCZATA2AfO50gJOug80ShzqQ/ab3ekNo4tI7Mte+hXdG5AuR6/Y8K1M2Y4QhGwQ
	 C29sN3uUXT1T/n73gnF7jXbumAK/ocsucqDU7aw/vPJGUac75Q6lbMl0D195okGd1h
	 LKIzgLl6W3/UsvgNXE2CedGNsoWlNLa597JK9reoMdCZ0yLJeU3UPO2c2jJeyiFvRq
	 40Q49Smskvv6M4LgPfHKRyXOcBpiMm3lSOL6YvaXbg9vGRnw98weJA2684VLofWOte
	 j+YS+DX2OzcuA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64D0C5AC80;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Thu, 06 Aug 2026 10:17:34 -0500
Subject: [PATCH v5 4/7] scsi: ibmvfc: allocate asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-ibmvfc-fpin-support-v5-4-13fd6f8a8f8b@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786029459; l=2503;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=5RuNy3ewl5Y+dwhrMNnUroVom0cpBS0889/aQRw9BCM=;
 b=O2TVx4DtdVUFoCtw1cVhQdxnL8xx6AGWr6s5zDZUbvq19acN6cJSzKuNbQzSLuTtAcwdDLCSQ
 ncLWojrmHDUBgFyMBkBTwTcp6dFmxIAiJQAtDQF0f+mn74t6mkEqtMk
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Allocate and initialize the asynchronous sub-queue required for receiving
full and extended FPIN events from VIOS.

Modify ibmvfc_alloc_channels() to allocate async_scrq using
ibmvfc_alloc_queue() with IBMVFC_SUB_CRQ_FMT format. Update error
handling to properly clean up async_scrq on allocation failures.

Update ibmvfc_channel_setup() to pass async_subq_handle to VIOS during
channel setup, and ibmvfc_channel_setup_done() to store the VIOS cookie
for the async sub-queue.

Modify ibmvfc_release_channels() to free async_scrq resources during
cleanup.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index aec953f29e55..06898a407d07 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6726,6 +6726,17 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
@@ -6734,13 +6745,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
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
 
@@ -6782,8 +6801,15 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 
 		kfree(channels->scrqs);
 		channels->scrqs = NULL;
+
 		channels->active_queues = 0;
 	}
+
+	if (channels->async_scrq) {
+		ibmvfc_free_queue(vhost, channels->async_scrq);
+		kfree(channels->async_scrq);
+		channels->async_scrq = NULL;
+	}
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)

-- 
2.55.0


