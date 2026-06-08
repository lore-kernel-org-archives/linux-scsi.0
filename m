Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D19B3E0C41;
	Mon,  8 Jun 2026 18:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943425; cv=none; b=fwr1GnMuFbzPGv8U2KBUBTQLZhMDuU8PWscxq4jrVClpQjcDen91jXM+40ZB7aHbbd0l9Kmju4cVjclESCHPE7y8Jx0ENsPq2KOO2Xus1Lyd2Tw+EiW5ZkIfsAQfP0f8Giz0rmS5Z3SEBxSxadvL4WfXZs8QuqLGKn/kXknU2yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943425; c=relaxed/simple;
	bh=8/EY0NOHHy8eX+qz/4HA9u/TVExATrYs5NIzD8L0QTg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KCxZlJSYzSpMzO67q+pV893WxHR1MgyCzUI3ZZouc01P+pcLWXgb0R10+kKA/lI4VkjKvSb8JOOH/SF2SpHSevQwx/NWQ9aBShne0h2DgISyqwFw0wrBRpRL2k1M/fB9XJoU+L0IWI09BzfHhbX7Sz7MO1zS+N0tXMF/lCYSNiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hta6CqAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hta6CqAh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4063C4AF17;
	Mon,  8 Jun 2026 18:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1780943424;
	bh=8/EY0NOHHy8eX+qz/4HA9u/TVExATrYs5NIzD8L0QTg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Hta6CqAhxsPBf4gwMV+sT8kL7RxymxnRgab/ME5l3Pe+NS0s5IAKXTxtsR4r6VvNt
	 IU3GMsL4P7c4xRdgJEnJww3FcbNe76QYxYtlWiyYvIJsyUY8jkkM171o+YVTCKCY6g
	 EsRBBr6tgBYmi3UEPWw2tGqhoGuLHWvkv+l6DRTcTjvsbGuJykMAJ0M3tRWTuABiQH
	 rLZcJFIg6V4IjQHnUfQuSCdIvMO3bJXYfY1VUWslKc2kNnb9LvF/vUiQpHG4/m/ux+
	 +1QPIFtA5HiwRBFEUrFWL2wI9ZIkeDw3L9+tmngenfslLgFAs/V+hwQEx/WY7XrjBj
	 5Um4d/jzM9byw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AA0CD6E79;
	Mon,  8 Jun 2026 18:30:24 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Mon, 08 Jun 2026 13:30:20 -0500
Subject: [PATCH v2 5/7] ibmvfc: allocate asynchronous sub-queue
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-ibmvfc-fpin-support-v2-5-d41f540fba5c@linux.ibm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780943423; l=2552;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=WZU0TiQHIfrATphYf2jr66JLZ5y9tryV6E3XG2zppIE=;
 b=nWCwY/Gaspg7WA0psfLZHY2NuOMDXWuDl+dLWUWEYYdS4gJkdVPFYe7pUJLHXH5YMoIPkeU8m
 5+KyrI5Vlf6C4313XdDy51CcLOyFUrpOw74R6CX3SFEHJqCZ/TDhGjv
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Allocate and set up the asynchronous sub-queue for asynchronous
events, as required for full and extended FPIN support.
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a18861808325..ad1f5636e879 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5352,6 +5352,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 			for (i = 0; i < active_queues; i++)
 				scrqs->scrqs[i].vios_cookie =
 					be64_to_cpu(setup->channel_handles[i]);
+			scrqs->async_scrq->vios_cookie =
+				be64_to_cpu(setup->asyncSubqHandle);
 
 			ibmvfc_dbg(vhost, "Using %u channels\n",
 				   vhost->scsi_scrqs.active_queues);
@@ -5402,6 +5404,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
 		for (i = 0; i < num_channels; i++)
 			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
+		setup_buf->asyncSubqHandle = cpu_to_be64(scrqs->async_scrq->cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -6369,6 +6372,24 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 	if (!channels->scrqs)
 		return -ENOMEM;
 
+	channels->async_scrq = kzalloc_obj(*channels->async_scrq, GFP_KERNEL);
+
+	if (!channels->async_scrq) {
+		kfree(channels->scrqs);
+		channels->scrqs = NULL;
+		return -ENOMEM;
+	}
+
+	rc = ibmvfc_alloc_queue(vhost, channels->async_scrq,
+				IBMVFC_SUB_CRQ_FMT);
+	if (rc) {
+		kfree(channels->scrqs);
+		channels->scrqs = NULL;
+		kfree(channels->async_scrq);
+		channels->async_scrq = NULL;
+		return rc;
+	}
+
 	for (i = 0; i < channels->max_queues; i++) {
 		scrq = &channels->scrqs[i];
 		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
@@ -6380,6 +6401,9 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 			kfree(channels->scrqs);
 			channels->scrqs = NULL;
 			channels->active_queues = 0;
+			ibmvfc_free_queue(vhost, channels->async_scrq);
+			kfree(channels->async_scrq);
+			channels->async_scrq = NULL;
 			return rc;
 		}
 	}
@@ -6418,6 +6442,10 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 
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


