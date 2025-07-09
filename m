Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D512185B1
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096112; cv=none; b=jn+dwe+g3xk1/IUZnYHan9BpiY1y3x9gM96PrnAcWv0GNojPUFJDNS3C0ClYNJipvk8xeTF/nYkHEH1edJC+ccEExy2xFT66ranKEAC3Nh6rCmwFLNi8HIlYOYKYR6o9bixEOuz+xpLZX5kxqKwtb+D4uPgu6ks+25gV0WqKsWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096112; c=relaxed/simple;
	bh=Hv8/CtaYTApGZl3gi4MKaktTQxhm+GnMQQdz9sxNq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDxoOJ6nqH1Gd+oMD81XYBhHd1MRM73wI0w+R9qxU+PsKqToBBq1QaaFXG7uq2DVE3DoupSgBwoNHeVzSHvlYUValNMO2NTOaB6Wv4aOO0PmoNrVlcepYYdjg7X2EjaQ4ThEHtQRxiIjE+bspIPKZ78beZZVqtCf+QIu+4i7uCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eLEKPRb7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eLEKPRb7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uy3hA5q/W+ezg8EdM87Kkf8lgPiVHkZXLDM3ntYGW64=;
	b=eLEKPRb76dIyNlxPD6/mHfS8pQFpQNg1IAwrpJO6XiHa1+zhSU4rtvYRZWV4mqKXC6g0p7
	h2s2Dl4dXno+EfmO4ps8DocksZI8yZ5wQAbGXI5GrxAKT5CoBLIn6L1NRQi5fjV/2OO3Xo
	6aUJsO0Ffs6kw015STH/Si+TW8SRXM8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-63JyFQboNNixkZF0wI2-vw-1; Wed,
 09 Jul 2025 17:21:46 -0400
X-MC-Unique: 63JyFQboNNixkZF0wI2-vw-1
X-Mimecast-MFC-AGG-ID: 63JyFQboNNixkZF0wI2-vw_1752096104
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53DCE180028D;
	Wed,  9 Jul 2025 21:21:44 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3535319560AB;
	Wed,  9 Jul 2025 21:21:37 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	bgurney@redhat.com,
	jmeneghi@redhat.com
Subject: [PATCH v8 3/8] nvme-fc: marginal path handling
Date: Wed,  9 Jul 2025 17:19:14 -0400
Message-ID: <20250709211919.49100-4-bgurney@redhat.com>
In-Reply-To: <20250709211919.49100-1-bgurney@redhat.com>
References: <20250709211919.49100-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Hannes Reinecke <hare@kernel.org>

FPIN LI (link integrity) messages are received when the attached
fabric detects hardware errors. In response to these messages I/O
should be directed away from the affected ports, and only used
if the 'optimized' paths are unavailable.
To handle this a new controller flag 'NVME_CTRL_MARGINAL' is added
which will cause the multipath scheduler to skip these paths when
checking for 'optimized' paths. They are, however, still eligible
for non-optimized path selected. The flag is cleared upon reset as then the
faulty hardware might be replaced.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 drivers/nvme/host/fc.c        |  4 ++++
 drivers/nvme/host/multipath.c | 17 +++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 08a5ea3e9383..8787c566f939 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -786,6 +786,10 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
 		"Reconnect", ctrl->cnum);
 
 	set_bit(ASSOC_FAILED, &ctrl->flags);
+
+	/* clear 'marginal' flag as controller will be reset */
+	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
+
 	nvme_reset_ctrl(&ctrl->ctrl);
 }
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 316a269842fa..8d4e54bb4261 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -324,11 +324,14 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 
 		switch (ns->ana_state) {
 		case NVME_ANA_OPTIMIZED:
-			if (distance < found_distance) {
-				found_distance = distance;
-				found = ns;
+			if (!nvme_ctrl_is_marginal(ns->ctrl)) {
+				if (distance < found_distance) {
+					found_distance = distance;
+					found = ns;
+				}
+				break;
 			}
-			break;
+			fallthrough;
 		case NVME_ANA_NONOPTIMIZED:
 			if (distance < fallback_distance) {
 				fallback_distance = distance;
@@ -381,7 +384,8 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 
 		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
 			found = ns;
-			goto out;
+			if (!nvme_ctrl_is_marginal(ns->ctrl))
+				goto out;
 		}
 		if (ns->ana_state == NVME_ANA_NONOPTIMIZED)
 			found = ns;
@@ -445,7 +449,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 {
 	return nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE &&
-		ns->ana_state == NVME_ANA_OPTIMIZED;
+		ns->ana_state == NVME_ANA_OPTIMIZED &&
+		!nvme_ctrl_is_marginal(ns->ctrl);
 }
 
 static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
-- 
2.50.0

