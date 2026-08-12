Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE09449B01
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558430; cv=none; b=JZRVk97dnYQjIMHMWQB4lN5uvdXkDbj+HfMcdUowK25T8bPxI+1q+EXYKM40Sstl3EVJJ8cKGLUN888OZGTqYT1RuaZZgM7PhsL665SfS66Z15UTQIA1vJrt2+J4c5h77WJrdlDDMYl+2tjUILFIWxGdaZFgX/Ua/YbJaeRW7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558430; c=relaxed/simple;
	bh=ih+r6u2j+Jx4pTCdPB8B0Ila2P8nfiI+EO6yY7eySyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWccLAsCpLO4fPa0fC96WaDtzl+reyhOTxvaSdqDAsPah7dU310P1teD7UjVaV04Z/wS6FepmTjO55TNESDJ5gQM1lXxK72IyXcPR3fDY7/7RyoEOGshsBMPsnnQmi20Sjjj8c0Oj7eYsbgdkRlGRisrfphkjf3E9yxRgoIDAXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHa7mJ/Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHa7mJ/Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5hCJTyk+JlNhkqSdY8pBWBu0X2FbGauT5SMAOg6BwM=;
	b=QHa7mJ/QQfBfpiArRnHgI3XXso12OXdf28cdbrHFJ44DKFGiBRUdxG5DSmG1qA134HUWOx
	I+IGjMBQoAjw4V+OpCxnmMm0YYDnL2IL7Iz5FRpP1o6jdDetw6ksEhGxqsMtcs7Xe6IbFw
	DFFY7hDoAaDDb4wt573got3r3SzVfjQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-0Kh43q5oOv-BWeaItZ2FLg-1; Wed,
 12 Aug 2026 14:13:43 -0400
X-MC-Unique: 0Kh43q5oOv-BWeaItZ2FLg-1
X-Mimecast-MFC-AGG-ID: 0Kh43q5oOv-BWeaItZ2FLg_1786558420
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E602619560AA;
	Wed, 12 Aug 2026 18:13:39 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42C76180034C;
	Wed, 12 Aug 2026 18:13:34 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: [PATCH 05/13] nvme-multipath: round-robin support for marginal paths
Date: Wed, 12 Aug 2026 14:12:52 -0400
Message-ID: <20260812181300.3712426-6-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Exclude marginal paths from round-robin io policy. In the case where all
paths are marginal and no optimized or non-optimized path is found, we
fall back and perform round-robin on the marginal paths.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V11:
 - New commit
---
 drivers/nvme/host/multipath.c | 47 +++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index dc34634842be..11f474704fdd 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -405,6 +405,7 @@ static struct nvme_ns *nvme_next_ns(struct nvme_ns_head *head,
 static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *ns, *found = NULL;
+	bool found_is_marginal = true;
 	int node = numa_node_id();
 	struct nvme_ns *old = srcu_dereference(head->current_path[node],
 					       &head->srcu);
@@ -425,22 +426,58 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 			continue;
 
 		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
+			if (found_is_marginal && nvme_ctrl_is_marginal(ns->ctrl)) {
+				/*
+				 * A marginal path has already found,
+				 * or this is the first path found.
+				 * This one is also marginal, but optimized,
+				 * so prefer it.
+				 */
+				found = ns;
+				found_is_marginal = 1;
+				continue;
+			}
+
+
+			/*
+			 * A non-marginal path has already found.
+			 * This one is marginal, so skip it.
+			 */
+			if (nvme_ctrl_is_marginal(ns->ctrl))
+				continue;
+
+			/* Found a non-marginal, optimized path use it. */
 			found = ns;
 			goto out;
 		}
-		if (ns->ana_state == NVME_ANA_NONOPTIMIZED)
+		if (ns->ana_state == NVME_ANA_NONOPTIMIZED) {
+			/*
+			 * A path has already found. This one is marginal,
+			 * so skip it.
+			 */
+			if (found && nvme_ctrl_is_marginal(ns->ctrl))
+				continue;
 			found = ns;
+			found_is_marginal = nvme_ctrl_is_marginal(ns->ctrl);
+		}
 	}
 
 	/*
 	 * The loop above skips the current path for round-robin semantics.
 	 * Fall back to the current path if either:
-	 *  - no other optimized path found and current is optimized,
+	 *  - no other non-marginal optimized path found and current is,
+	 *      optimized and not marginal.
 	 *  - no other usable path found and current is usable.
 	 */
-	if (!nvme_path_is_disabled(old) &&
-	    (old->ana_state == NVME_ANA_OPTIMIZED ||
-	     (!found && old->ana_state == NVME_ANA_NONOPTIMIZED)))
+	/* no other usable path found and current is usable. */
+	if (!nvme_path_is_disabled(old) && !found)
+		return old;
+	/*
+	 * no other non-marginal optimized path found and current is,
+	 *   optimized and not marginal.
+	 */
+	if (!nvme_path_is_disabled(old) && !nvme_ctrl_is_marginal(old->ctrl) &&
+	    (old->ana_state == NVME_ANA_OPTIMIZED || found_is_marginal))
 		return old;
 
 	if (!found)
-- 
2.54.0

