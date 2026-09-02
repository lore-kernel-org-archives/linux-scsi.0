Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C51F3B3BF5
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379579; cv=none; b=rXFDowDKIOrSocgrzBZc+IljgdQ4EFhKwl5lXo6e/pv2RPeCdE/lTgERDFoWoem1yEmU6hk+BxWN3MXMUdr6S4L86RDyyCs7R9i2KCwCICuqMaQJbFktB+6SLwPy/wGRvIWk2Z7S8UfZC2s1Grz8iFS7HVy/7rvU14P4RWXye6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379579; c=relaxed/simple;
	bh=8surKw7udmsQwFPiPd6xTmHp71njgqhrlZSvjoy14eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1P0nSFVBW80L7qIxJT0Bjl3yNpIkaIpIcBmTVWEfrgG9gA+zIh1NFGEbp2HUay9K+SjeNKpyNJjZlE3Cnv4dXJWDbj+YLBBnfM31fXBdLbwPjhjDh65vns2MXmsUlIWpl7co0wZvjLRHHhDlq2AdPrW1RvSLt3PWjFek127WV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbDRczcl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbDRczcl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4SOQVx6UDmhZ26lSu1cCcYqEQXYt2vou3jNd344Y+M=;
	b=bbDRczclhhrDZPu89iXliJd7QFMc1XkR6Y6PahlUgfACt5AN4nUfLrxOtAhd0rQFJoppCL
	v082ICeWPQOAas9HVq2G85K3rQQpx2hOqU5ORk5uqdt4ybtOrJFWBomp2WVGgdKuCapcNF
	IRIKU3hpI1jbKUIQdL9egW9xKQJZOg8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-wFa_C8tYM3y7FXo3Jv1X2Q-1; Wed,
 02 Sep 2026 16:06:11 -0400
X-MC-Unique: wFa_C8tYM3y7FXo3Jv1X2Q-1
X-Mimecast-MFC-AGG-ID: wFa_C8tYM3y7FXo3Jv1X2Q_1788379565
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74E081808898;
	Wed,  2 Sep 2026 20:06:04 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2AF5D1955F03;
	Wed,  2 Sep 2026 20:06:01 +0000 (UTC)
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
Subject: [PATCH v2 3/7] nvme-multipath: queue-depth support for marginal paths
Date: Wed,  2 Sep 2026 16:05:43 -0400
Message-ID: <20260902200547.184734-4-jtaubepe@redhat.com>
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

From: John Meneghini <jmeneghi@redhat.com>

Exclude marginal paths from queue-depth io policy. In the case where all
paths are marginal and no optimized or non-optimized path is found, we
fall back and select the best marginal path.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
V10 -> V1:
 - New commit
V1 -> V2:
 - Rewrite
---
 drivers/nvme/host/multipath.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index dbf09cdda815..f28797deab68 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -439,12 +439,17 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 	struct nvme_ns *best_opt = NULL, *best_nonopt = NULL, *ns;
 	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
 	unsigned int depth;
+	bool need_marginal = nvme_all_paths_marginal(head);
 
 	list_for_each_entry_srcu(ns, &head->list, siblings,
 				 srcu_read_lock_held(&head->srcu)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
 
+		/* Skip marginal paths unless we need to use them */
+		if (!need_marginal && nvme_ctrl_is_marginal(ns->ctrl))
+			continue;
+
 		depth = atomic_read(&ns->ctrl->nr_active);
 
 		switch (ns->ana_state) {
-- 
2.55.0

