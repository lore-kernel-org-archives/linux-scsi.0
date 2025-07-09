Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1845CE55B
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096709; cv=none; b=FcsU/AtMUHmFVOVz0CdOsFmP64Yyr07+Vsy5/fyQ+9rNFTajt8nTwHjBTNyU7rYg5Q6QlieMxKsh/j7YDqYq0UlhVv6c/c5JQ9LNrCzlK5SW9wqJLO/OKetZL0zMIWNUJZ3ZO95sMM8sphv56WFU2vzHjG6F3cwLj3ULzxE5ypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096709; c=relaxed/simple;
	bh=Vf8MBeLWtJTW89v9YLeWv8CZrfxLafiFXSGk/KRju6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDlDF6uPQlgaSvSI+oRskBS1GOFlgmIpogjivLQ16KMMrsdBxWN9mrK5qSJd/gzngEdhQvcrEveCLNGfHWobMhAB1KeVTnXkomBnk3vjNH/bkS+eBkHZkjaP9Xz4YAm4+98h36OtYAEhytLHOTYl1G+BSLIh710XN9guowQ12EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QO8YIpUj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QO8YIpUj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IKC4k/0je8rn9J3srT4GB6ofNpr/x2eG9j1NbSu3+b8=;
	b=QO8YIpUjnoCP4F3X10x8m73QdkTPhZPdik5jci8h19HODHjmsuPyJfL+CW5+nv4ZyerBce
	Qgy3iseNecyooEwQmM5kELcuKxv7xDsnxWGKddXYLnAr+iT1GqkEymHkhqrwKWp410YXdq
	Onz2duKinU7Kg5BjmaZPvZhLSAtl9Tk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-cJbejgniPGutwMKZP4Lfew-1; Wed,
 09 Jul 2025 17:27:03 -0400
X-MC-Unique: cJbejgniPGutwMKZP4Lfew-1
X-Mimecast-MFC-AGG-ID: cJbejgniPGutwMKZP4Lfew_1752096421
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95B011955EC3;
	Wed,  9 Jul 2025 21:27:01 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BC4719560AB;
	Wed,  9 Jul 2025 21:26:56 +0000 (UTC)
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
Subject: [PATCH v8 8/8] nvme-multipath: queue-depth support for marginal paths
Date: Wed,  9 Jul 2025 17:26:52 -0400
Message-ID: <20250709212652.49471-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: John Meneghini <jmeneghi@redhat.com>

Exclude marginal paths from queue-depth io policy. In the case where all
paths are marginal and no optimized or non-optimized path is found, we
fall back to __nvme_find_path which selects the best marginal path.

Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/nvme/host/multipath.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 8d4e54bb4261..767583e8454b 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -420,6 +420,9 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 		if (nvme_path_is_disabled(ns))
 			continue;
 
+		if (nvme_ctrl_is_marginal(ns->ctrl))
+			continue;
+
 		depth = atomic_read(&ns->ctrl->nr_active);
 
 		switch (ns->ana_state) {
@@ -443,7 +446,9 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 			return best_opt;
 	}
 
-	return best_opt ? best_opt : best_nonopt;
+	best_opt = (best_opt) ? best_opt : best_nonopt;
+
+	return best_opt ? best_opt : __nvme_find_path(head, numa_node_id());
 }
 
 static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
-- 
2.50.0

