Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6FB1C84DF
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 20:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796525; cv=none; b=XIDeLoltUjF9FUT7AnErzGrEIfbilqxEiQdOdLkrSUVGSnmQwvab0SB9+vtShWJX6xNF3MxgcMW0OGCNrgtM71z+EC/Cm8YdhvF34IjXv719I9RUrSU5iYPNmcSiNJRMthUtFujhDYWQ6AjIjA/pKGWl8yF/9CtrPdbVOyBm+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796525; c=relaxed/simple;
	bh=wC32DKk2N7Gxrk9oFKRS7QU/dh3dJGtFL9lB8hhcMZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0QKxVLqg+FzqFPqyypL21ShL98TNuK7vsF77w9cLMYfb3Uf//zIWjlj+9rmITpBhHuPPRwa/xyE9tFZyhxEbqaAe3DiU5EsLE/IaQtbqP0PF/dMQKvgtq9HdNpAhYA6EH3GrMbntHwJfr97zMuodGkqRROkwALnJt4BVVaKojI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1+edQ+Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1+edQ+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750796522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+k/PzmZFNCcHfs5nMoe3Ogufiyy+ih/BV0Jnn4FDitc=;
	b=R1+edQ+QPMXTuMbVKYEnUdpcYmdMmS0iuPV4DGfGLAHpL4rnV+mAwkE8pN8BoQgOOSkhS6
	OnitiLhX7JzjStWIvbL8CvsMgBz7rNWwdGd7NfFSWOTHU1HrAUVdOYSnIhDvE+ISzo+4uX
	UyOLwNFZxf/9mydR1QvKjqHetwGVNdo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-UkHu5dZeMmKI_p4Nh28lzg-1; Tue,
 24 Jun 2025 16:21:57 -0400
X-MC-Unique: UkHu5dZeMmKI_p4Nh28lzg-1
X-Mimecast-MFC-AGG-ID: UkHu5dZeMmKI_p4Nh28lzg_1750796515
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3519B195608B;
	Tue, 24 Jun 2025 20:21:55 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.45.226.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6028719560A3;
	Tue, 24 Jun 2025 20:21:48 +0000 (UTC)
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
Subject: [PATCH v7 2/6] nvme-fc: marginal path handling
Date: Tue, 24 Jun 2025 16:20:16 -0400
Message-ID: <20250624202020.42612-3-bgurney@redhat.com>
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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

