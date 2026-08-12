Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C0848425F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558436; cv=none; b=e+32LPvyR+WMYJYfr8ScgmGsLVQ6zjS47vxsdDvhpE+MdSCSsRyt1StPyVbwWeReoBqOOnAQ/6ogqqs6AO0F0xXoWTJeSLgzdeUJzBSRmspMQOdl1a5Iq7UA2z62rTzcB/5CxMKJuwFe0/togmPutEXvPFWDRDLNr+O37oTT5MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558436; c=relaxed/simple;
	bh=pXmsgew6LHplNFdkV6enDJUmqQO4wZCvzVIbfHl6bcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df0bdPiI/RiihQ1j/XBH2XHt1N9be4XF5Rt7WF6ma1KPMvRzZtf0aLsT7cakg5B16vHwfnlKu6q4dItW9u57lZ2b1mkzIqkhgT+AVz4K+KnnFEBtQGVUrzJeUHzkq4ZOIwJzX2nw+MJ2KybhgV6Mob/Sv7h6ubstqubZ6Hwnkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GODym6te; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GODym6te"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vcu9PbtDT1pNYoR33movkVcPOA1p/h5oinwfvgSmomU=;
	b=GODym6temzE2lGPMIOAIA9mZz5NZggtxB34zjRMoT+a4iCBVon+suJouDcvN2u/b7m7Nza
	OIpRI3MhgQhVNEHddvFyeLb1K5F2T9ZS4qIUP9+S54ZgCUqHCHSkGw8kRFjQZb6EguIX8C
	HC9WaBF24YmHYqq5rE8jUidiqEI63Tk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258--3g3ShMDN3KjRurcw1SDwA-1; Wed,
 12 Aug 2026 14:13:46 -0400
X-MC-Unique: -3g3ShMDN3KjRurcw1SDwA-1
X-Mimecast-MFC-AGG-ID: -3g3ShMDN3KjRurcw1SDwA_1786558414
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0849C195604B;
	Wed, 12 Aug 2026 18:13:34 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 41C3E180034F;
	Wed, 12 Aug 2026 18:13:28 +0000 (UTC)
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
Subject: [PATCH 04/13] nvme-multipath: queue-depth support for marginal paths
Date: Wed, 12 Aug 2026 14:12:51 -0400
Message-ID: <20260812181300.3712426-5-jtaubepe@redhat.com>
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

From: John Meneghini <jmeneghi@redhat.com>

Exclude marginal paths from queue-depth io policy. In the case where all
paths are marginal and no optimized or non-optimized path is found, we
fall back and select the best marginal path.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
V10 -> V11:
 - New commit
---
 drivers/nvme/host/multipath.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 02936c580a37..dc34634842be 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -453,7 +453,9 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *best_opt = NULL, *best_nonopt = NULL, *ns;
-	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	int min_depth_opt = INT_MAX, min_depth_nonopt = INT_MAX;
+	bool opt_is_marginal = true, nonopt_is_marginal = true, marginal;
+
 	unsigned int depth;
 
 	list_for_each_entry_srcu(ns, &head->list, siblings,
@@ -462,28 +464,40 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 			continue;
 
 		depth = atomic_read(&ns->ctrl->nr_active);
+		marginal = nvme_ctrl_is_marginal(ns->ctrl);
 
 		switch (ns->ana_state) {
 		case NVME_ANA_OPTIMIZED:
-			if (depth < min_depth_opt) {
+			if (is_best_distance(opt_is_marginal, marginal,
+					     min_depth_opt, depth)) {
 				min_depth_opt = depth;
 				best_opt = ns;
+				opt_is_marginal = marginal;
 			}
 			break;
 		case NVME_ANA_NONOPTIMIZED:
-			if (depth < min_depth_nonopt) {
+			if (is_best_distance(nonopt_is_marginal, marginal,
+					     min_depth_nonopt, depth)) {
 				min_depth_nonopt = depth;
 				best_nonopt = ns;
+				nonopt_is_marginal = marginal;
 			}
 			break;
 		default:
 			break;
 		}
 
-		if (min_depth_opt == 0)
+		if (min_depth_opt == 0 && !opt_is_marginal)
 			return best_opt;
 	}
 
+	/*
+	 * Prefer non-marginal non-optimized path
+	 * over a marginal optimized path.
+	 */
+	if (opt_is_marginal && !nonopt_is_marginal && best_nonopt)
+		return best_nonopt;
+
 	return best_opt ? best_opt : best_nonopt;
 }
 
-- 
2.54.0

