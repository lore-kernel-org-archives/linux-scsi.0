Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB4039185C
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379566; cv=none; b=Dk8Q2ZKJAkWWEr4SuW9dgTrptKxjnKcIKV5yUNC1BC0tUCGIie7FeC8ouxPpreFTDc+FAyMwHgae+S/nt2xIeeOSXn6bqX2hTsNl5TxvFHoi2y+VTk1279mFgB9w80duHOR5FIpdkvE/0tDryUjQWP0Iz5Lrh1F05pz/+qYYGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379566; c=relaxed/simple;
	bh=EG7jMXrQq32CibfG9Ke7DQ8xfXT/tW3mpnjzild10qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzeuF9LHU2puqvH8DUo352WjKAO6aHT2T2ylceHqlQt4uIFURWKQ0mDeZ4IXq+BUJuHtYPfA8hTh97wFEC9JRlmmkK2ynBFT1Cw+vGsLDEjcZ/2nLZQGaC4Trkm3rPm830OhJMf+MLvnqZF7noOMbCevR3Kc1L7pizy40JQcilc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PJ1re0tg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJ1re0tg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fS8rV8Ai6nPQGvPzbdvPVCf76DBf0vaQn7m2V2kfIXg=;
	b=PJ1re0tgyd+fJqhCwW6Bz4q2iiRTlAVkBuUPdE2qw/nN+6RpkMec0ulOF4iW8vqzpogDOa
	Ujue8eU+O4i3DDh/Hgm7XKacO3bD9PCmUNVL4+ImBaKxYjuU5mqtle1HqzBBLzpPv6WPDR
	cyW1vAgP0OwuztaANMJ5Eb6EmpY/UtU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-2M5-PBdvMNqYV8QDxEtbfQ-1; Wed,
 02 Sep 2026 16:05:59 -0400
X-MC-Unique: 2M5-PBdvMNqYV8QDxEtbfQ-1
X-Mimecast-MFC-AGG-ID: 2M5-PBdvMNqYV8QDxEtbfQ_1788379557
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E77F81801BF4;
	Wed,  2 Sep 2026 20:05:56 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A3F21955F03;
	Wed,  2 Sep 2026 20:05:52 +0000 (UTC)
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
Subject: [PATCH v2 1/7] nvme: add NVME_CTRL_MARGINAL flag
Date: Wed,  2 Sep 2026 16:05:41 -0400
Message-ID: <20260902200547.184734-2-jtaubepe@redhat.com>
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

From: Bryan Gurney <bgurney@redhat.com>

Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
policies to react to a path that is set to a "marginal" state.

The "marginal" flag is initialized to false in `nvme_init_ctrl` and
cleared in `nvme_fc_ctrl_connectivity_loss` before re-association.
It is only cleared there, not in the generic `nvme_reset_ctrl` path,
because the marginal condition reflects a physical link problem.
An arbitrary controller reset does not signal that a hardware fault has
been resolved. Calling `nvme_fc_ctrl_connectivity_loss` means the FC
association has failed and will be re-established, so the prior link
quality state is no longer meaningful.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
V10 -> V1:
 - No change
V1 -> V2:
 - Add nvme_ctrl_assign_marginal
 - Fix nvme_fc_ctrl_connectivity_loss clearing wrong bit.
 - Update commit message
---
 drivers/nvme/host/core.c |  1 +
 drivers/nvme/host/fc.c   |  4 ++++
 drivers/nvme/host/nvme.h | 11 +++++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 453c1f0b2dd0..4ce3c0573707 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5165,6 +5165,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	WRITE_ONCE(ctrl->state, NVME_CTRL_NEW);
 	ctrl->passthru_err_log_enabled = false;
 	clear_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags);
+	nvme_ctrl_assign_marginal(ctrl, false);
 	spin_lock_init(&ctrl->lock);
 	mutex_init(&ctrl->namespaces_lock);
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 04363b9c4489..7886c0dcc626 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -788,6 +788,10 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
 		"Reconnect", ctrl->cnum);
 
 	set_bit(ASSOC_FAILED, &ctrl->flags);
+
+	/* clear 'marginal' flag as controller will be reset */
+	nvme_ctrl_assign_marginal(&ctrl->ctrl, false);
+
 	nvme_reset_ctrl(&ctrl->ctrl);
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 824651cc898d..640cb4747ba2 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -329,6 +329,7 @@ enum nvme_ctrl_flags {
 	NVME_CTRL_SKIP_ID_CNS_CS	= 4,
 	NVME_CTRL_DIRTY_CAPABILITY	= 5,
 	NVME_CTRL_FROZEN		= 6,
+	NVME_CTRL_MARGINAL		= 7,
 };
 
 struct nvme_ctrl {
@@ -479,6 +480,16 @@ static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
 	return READ_ONCE(ctrl->state);
 }
 
+static inline bool nvme_ctrl_is_marginal(struct nvme_ctrl *ctrl)
+{
+	return test_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
+}
+
+static inline void nvme_ctrl_assign_marginal(struct nvme_ctrl *ctrl, bool marginal)
+{
+	assign_bit(NVME_CTRL_MARGINAL, &ctrl->flags, marginal);
+}
+
 enum nvme_iopolicy {
 	NVME_IOPOLICY_NUMA,
 	NVME_IOPOLICY_RR,
-- 
2.55.0

