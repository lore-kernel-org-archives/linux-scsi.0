Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726A4A5EDB
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379584; cv=none; b=GiNlX8Doaz8W1LsdwlBCAbSuwQOHvZhtbVhQZdt7Dmy1BP9fs7avCf5pieMXPDy7RH+9gdHN7pHvP2nuxyhmInqDcjzJWLdTzwAYB4Lpwk6gng/Ay8Z+q1nHQ5J9rYIGasM4Qq3aZRlLhX+sx4QBHHSd4i91b6Pm9kaDrV7//Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379584; c=relaxed/simple;
	bh=KyigujruG9PSQ4X/h7TyBYjnfhYpTml3X/Nidvemv3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf0lZ3gIbU9f/XZGl1Fq8o/FiftpvsH1kfD3OP8PCb7x/Dz6H/HwZu2A1Dofl/UDiYhDGLvWpw+cHA5HCythWgYNR/jzjWT/MV0EcPVOFU7h3drxNUxrRzpqV5h8hfSG7+cyrujPdWeEXXnl6/bNEXGgEcUSmIaaJ2TxkxcHjnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAdk/zPm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAdk/zPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOzuicW09ymDk9cexEa+3/Sews5a9NJ263znpzR+848=;
	b=iAdk/zPmrbBeH4oqp1GvfYp3OK2tO9SV+tWBNsQ4ozSVqvtOxp3Z8P9c3NXyZew7zFN3HY
	Py1znvpGI1AHKg0CmTz3Pp+SHgmoZYmU0IwzInD6PKwVTYeeNW04wKqVVx/PQH5J79Dl0G
	g5n6+wgEeN4Cap2mN4NmmTQbkWpnP6M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-72-yttTKMveSGAZMlApg2A-1; Wed,
 02 Sep 2026 16:06:17 -0400
X-MC-Unique: 72-yttTKMveSGAZMlApg2A-1
X-Mimecast-MFC-AGG-ID: 72-yttTKMveSGAZMlApg2A_1788379568
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E64BF1955D99;
	Wed,  2 Sep 2026 20:06:07 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8FE51955F02;
	Wed,  2 Sep 2026 20:06:04 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 4/7] nvme-multipath: round-robin support for marginal paths
Date: Wed,  2 Sep 2026 16:05:44 -0400
Message-ID: <20260902200547.184734-5-jtaubepe@redhat.com>
In-Reply-To: <20260902200547.184734-1-jtaubepe@redhat.com>
References: <20260902200547.184734-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Exclude marginal paths from round-robin io policy. In the case where all
paths are marginal and no optimized or non-optimized path is found, we
fall back and perform round-robin on the marginal paths.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V1:
 - New commit
V1 -> V2:
 - Rewrite
---
 drivers/nvme/host/multipath.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f28797deab68..738e3c742b74 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -392,22 +392,29 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 	int node = numa_node_id();
 	struct nvme_ns *old = srcu_dereference(head->current_path[node],
 					       &head->srcu);
+	bool need_marginal;
 
 	if (unlikely(!old))
 		return __nvme_find_path(head, node);
 
 	if (list_is_singular(&head->list)) {
-		if (nvme_path_is_disabled(old))
-			return NULL;
-		return old;
+		if (nvme_path_is_usable(old))
+			return old;
+		return NULL;
 	}
 
+	need_marginal = nvme_all_paths_marginal(head);
+
 	for (ns = nvme_next_ns(head, old);
 	     ns && ns != old;
 	     ns = nvme_next_ns(head, ns)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
 
+		/* Skip marginal paths unless we need to use them */
+		if (!need_marginal && nvme_ctrl_is_marginal(ns->ctrl))
+			continue;
+
 		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
 			found = ns;
 			goto out;
@@ -419,12 +426,23 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 	/*
 	 * The loop above skips the current path for round-robin semantics.
 	 * Fall back to the current path if either:
-	 *  - no other optimized path found and current is optimized,
+	 *  - no other optimized path found and current is,
+	 *      optimized and not marginal.
+	 *  - no other non-marginal path found and current is,
+	 *      optimized and marginal.
 	 *  - no other usable path found and current is usable.
 	 */
-	if (!nvme_path_is_disabled(old) &&
-	    (old->ana_state == NVME_ANA_OPTIMIZED ||
-	     (!found && old->ana_state == NVME_ANA_NONOPTIMIZED)))
+	/* no other usable path found and current is usable. */
+	if (nvme_path_is_usable(old) && !found)
+		return old;
+	/*
+	 *  - no other optimized path found and current is,
+	 *      optimized and not marginal.
+	 *  - no other non-marginal path found and current is,
+	 *      optimized and marginal.
+	 */
+	if (nvme_path_is_usable(old) && old->ana_state == NVME_ANA_OPTIMIZED &&
+	   (!nvme_ctrl_is_marginal(old->ctrl) || need_marginal))
 		return old;
 
 	if (!found)
-- 
2.55.0

