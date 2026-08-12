Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4F5436BCE
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558418; cv=none; b=g9Jb1JeyGCqo8yTalbo6xYnMMhDm6LPmN1cJJ6cS/50IGDUkQ6bvY3kyEwLu2tkV7o2n+dYHX/mBWokMmzI4ftbUYUPCXAkcWHjKvIa1xK9CgTazQPD7GUSxqujja/wml9eJf2VfeB88L90lrulKELp501LnuYvb/7RuMu9P3m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558418; c=relaxed/simple;
	bh=ur2Hev1FLJ1HwFjaHZ/1lmfUBsMxcGkycZjqGOjKKGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOYCmmZoQUMT6+Sf0olXwyoS1B4K4ViAaDl5Y1hEzFel5GqAoSeq7f8K0QjUApk+Gs69HY46J+RnYmh3k6G8qEKc8meSOzXSDW4/PorGvVn8Eh73D8WlZvqS1aHJkUrYSdhJOMgeewF9wcTuR8I2PrDdLIMv1F6z18bYK4QyPTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=clkrYsHp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="clkrYsHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XuxldGJkQSNbqK2Yx8HEdsWR3K9j6pez914nD5LW/PI=;
	b=clkrYsHpfhpZYrOnIuE3RkN/+zx4pMNFsOYlI+h0dhsDdSVoAhA4MVbvQ1ETE8Dib/gWoV
	Vg4jWAKtybSbyWcW1OkOGVOabfHOkoOXOYRDZCI6JIyvRP1h8t5EX4lHuIm9HFI+YX97gV
	EiX1dxoBjckbr/AxjRda0RSjn216764=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-lkZ0DEioM9evW6z3W1nCnQ-1; Wed,
 12 Aug 2026 14:13:30 -0400
X-MC-Unique: lkZ0DEioM9evW6z3W1nCnQ-1
X-Mimecast-MFC-AGG-ID: lkZ0DEioM9evW6z3W1nCnQ_1786558408
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD9D018007FD;
	Wed, 12 Aug 2026 18:13:27 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 15F99180034C;
	Wed, 12 Aug 2026 18:13:20 +0000 (UTC)
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
Subject: [PATCH 03/13] nvme-multipath: numa support for marginal paths
Date: Wed, 12 Aug 2026 14:12:50 -0400
Message-ID: <20260812181300.3712426-4-jtaubepe@redhat.com>
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

FPIN LI (link integrity) messages are received when the attached
fabric detects hardware errors. In response to these messages I/O
should be directed away from the affected ports, and only used
if no other non-marginal paths are available.
To handle this a new controller flag 'NVME_CTRL_MARGINAL' is added
which will cause the multipath scheduler to skip these paths when
checking for 'optimized' paths.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
This is a distinct change from the previous commit
which treated marginal paths as non-optimized but still usable.
This changes the priority of marginal paths to be lower than
non-optimized paths.
V10 -> V11:
 - New commit
---
 drivers/nvme/host/multipath.c | 53 +++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 9b9a657fa330..02936c580a37 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -305,10 +305,44 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
 	return false;
 }
 
+/*
+ * Returns true if the new distance is better than the old one.
+ */
+static bool is_best_distance(bool found_is_marginal, bool marginal,
+			       int old_distance, int distance)
+{
+	if (found_is_marginal) {
+		if (marginal) {
+			/*
+			 * A marginal path has already been found,
+			 * or this is the first path found.
+			 * This one is also marginal, but closer
+			 * to the NUMA node, so prefer it.
+			 */
+			if (distance < old_distance)
+				return true;
+		} else {
+			/* Found a non-marginal path, use it over a marginal one. */
+			return true;
+		}
+	} else {
+		/* A non-marginal path has already found. This one is marginal, so skip it. */
+		if (marginal)
+			return false;
+
+		/* Found a closer non-marginal path, use it. */
+		if (distance < old_distance)
+			return true;
+	}
+
+	return false;
+}
+
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 {
 	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
 	struct nvme_ns *found = NULL, *fallback = NULL, *ns;
+	bool found_is_marginal = true, fallback_is_marginal = true;
 
 	list_for_each_entry_srcu(ns, &head->list, siblings,
 				 srcu_read_lock_held(&head->srcu)) {
@@ -323,15 +357,19 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 
 		switch (ns->ana_state) {
 		case NVME_ANA_OPTIMIZED:
-			if (distance < found_distance) {
+			if (is_best_distance(found_is_marginal, nvme_ctrl_is_marginal(ns->ctrl),
+					     found_distance, distance)) {
 				found_distance = distance;
 				found = ns;
+				found_is_marginal = nvme_ctrl_is_marginal(ns->ctrl);
 			}
 			break;
 		case NVME_ANA_NONOPTIMIZED:
-			if (distance < fallback_distance) {
+			if (is_best_distance(fallback_is_marginal, nvme_ctrl_is_marginal(ns->ctrl),
+					     fallback_distance, distance)) {
 				fallback_distance = distance;
 				fallback = ns;
+				fallback_is_marginal = nvme_ctrl_is_marginal(ns->ctrl);
 			}
 			break;
 		default:
@@ -339,6 +377,14 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 		}
 	}
 
+	/*
+	 * Use non-optimized path only if it is not marginal
+	 * and no optimized path is marginal.
+	 */
+	if (found_is_marginal && !fallback_is_marginal)
+		found = fallback;
+
+	/* No optimized path found, use the fallback */
 	if (!found)
 		found = fallback;
 	if (found)
@@ -444,7 +490,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 {
 	return nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE &&
-		ns->ana_state == NVME_ANA_OPTIMIZED;
+		ns->ana_state == NVME_ANA_OPTIMIZED &&
+		!nvme_ctrl_is_marginal(ns->ctrl);
 }
 
 static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
-- 
2.54.0

