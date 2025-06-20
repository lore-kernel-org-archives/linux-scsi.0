Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BF1DC075
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442210; cv=none; b=B/Qq6ZpmfS9M3IgvT2qYlDN6m5CabVcb2eY/z0f5GJBpmQwMClxl0X20pM++PDhEMb5h+4/fPW+nXAdCGnsIF/dPHGMw5wMqHivvxck+mNSXPnZS/FcbryQA3fcGcDzdYCiltAMnKruzW2VKVzty3Saib1tfYumbobdA849GNwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442210; c=relaxed/simple;
	bh=wC32DKk2N7Gxrk9oFKRS7QU/dh3dJGtFL9lB8hhcMZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SrR5XoO6YY4SmTKTSR3D478PfspAYzW+xirMcWrMN0hZJtQtCKJjvGtcTZo1VUcTQZ3hxSlV8R83dfiJj3nYaI038zppQsf8oMH06XdIPgTL8R+cW0hB4jBZUQ/6f8FAt7cV/2oCqdWENjxI5oiH3YIqHT0yvwodLEePXHlVgCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H484sZFP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H484sZFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750442207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+k/PzmZFNCcHfs5nMoe3Ogufiyy+ih/BV0Jnn4FDitc=;
	b=H484sZFPOwvi14wp8CxnBhbNtEQEiolvQVQF7D+nWPE6FzJeS5PHqEQR305c7FHnUUPzhn
	N9EatUp9mgduA+kK63PnAuC3G+SAYKRbDtKcKdm52qykH70szoALPKbMrw3lyHDcVfCeCv
	dxjJeYnBmdj9FXZUB+dPIBTzMfaZUJM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-GSvEBTZqO92u5GaU2WpHpQ-1; Fri,
 20 Jun 2025 13:56:42 -0400
X-MC-Unique: GSvEBTZqO92u5GaU2WpHpQ-1
X-Mimecast-MFC-AGG-ID: GSvEBTZqO92u5GaU2WpHpQ_1750442200
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AE5B180135B;
	Fri, 20 Jun 2025 17:56:40 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.80.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7B6B1956094;
	Fri, 20 Jun 2025 17:56:36 +0000 (UTC)
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
Subject: [PATCH v6 2/6] nvme-fc: marginal path handling
Date: Fri, 20 Jun 2025 13:56:32 -0400
Message-ID: <20250620175632.34660-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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
---
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/fc.c        |  4 ++++
 drivers/nvme/host/multipath.c | 17 +++++++++++------
 drivers/nvme/host/nvme.h      |  6 ++++++
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3da5ac71a9b0..ac03ef7baab9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5040,6 +5040,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	WRITE_ONCE(ctrl->state, NVME_CTRL_NEW);
 	ctrl->passthru_err_log_enabled = false;
 	clear_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags);
+	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
 	spin_lock_init(&ctrl->lock);
 	mutex_init(&ctrl->namespaces_lock);
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 014b387f1e8b..7e81c815bb83 100644
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
index 1062467595f3..003954985675 100644
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
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7df2ea21851f..71a5c5f87db6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -275,6 +275,7 @@ enum nvme_ctrl_flags {
 	NVME_CTRL_SKIP_ID_CNS_CS	= 4,
 	NVME_CTRL_DIRTY_CAPABILITY	= 5,
 	NVME_CTRL_FROZEN		= 6,
+	NVME_CTRL_MARGINAL		= 7,
 };
 
 struct nvme_ctrl {
@@ -417,6 +418,11 @@ static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
 	return READ_ONCE(ctrl->state);
 }
 
+static inline bool nvme_ctrl_is_marginal(struct nvme_ctrl *ctrl)
+{
+	return test_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
+}
+
 enum nvme_iopolicy {
 	NVME_IOPOLICY_NUMA,
 	NVME_IOPOLICY_RR,
-- 
2.49.0

