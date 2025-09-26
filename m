Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312D11712
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844948; cv=none; b=QZuLk8nX5HnEIkyuxGszEMgf9/M99ecAoWEf8rP2VAtLYVJcFSZCgVyRUt5+dt1LyRxnWQS1QmvmuTQbgrPzGVTVr52NO4xkuxjTsPR1YaPE3fyyqw4MdfUuKbzC5l1dKwCTYpNYxH9c0I/mNM0bnOgdRvp4yiDtebdv2ZT7Wh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844948; c=relaxed/simple;
	bh=lXxztFXLbRkKjFp5h0JfLivhxUtWR/+R1fM4+hTrvV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=WrQAs3YHThbe2v5mYNGGIuotxxYmcY8VAZvySnBxaMCjYGxjDCR6SyH0Q/dL4tV6S2miG6nkklUgb65lC4nCSFgew3muIz1S3zajE1yHwOhmFb++i03TZHLOWB/C1GqDNXJehqq9tuDvHCcaZo/yKCm7vLmrJB1DXkNG1ek0DNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TpUXTlty; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TpUXTlty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0ro65iXKpEktawGScfWsoklq1awzhrvk2EM85X8+MM=;
	b=TpUXTltyRcMXJG+8D470iUN52MmddFcDqFktNbVIFZXzEPk5gcXz9S0vAHIF5ZeFSiigqr
	C+OEpizoodCxQjPsun/CcBpyXRb2SKzorWb3bjIN1zumccBY2o/fAEevg9bQwwrjmUMCkB
	YA4TB2gIY1YlbKIP42AxoUdLrRuOwcY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-2hmoVebIOrWF8X3XH5__jQ-1; Thu,
 25 Sep 2025 20:02:21 -0400
X-MC-Unique: 2hmoVebIOrWF8X3XH5__jQ-1
X-Mimecast-MFC-AGG-ID: 2hmoVebIOrWF8X3XH5__jQ_1758844938
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F99C195E916;
	Fri, 26 Sep 2025 00:02:18 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 73A7A1800579;
	Fri, 26 Sep 2025 00:02:14 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 03/11] nvme-fc: marginal path handling
Date: Thu, 25 Sep 2025 20:01:52 -0400
Message-ID: <20250926000200.837025-4-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-1-jmeneghi@redhat.com>
References: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
index 03987f497a5b..5091927c2176 100644
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
index 3da980dc60d9..c042a9a11ce3 100644
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
2.51.0

