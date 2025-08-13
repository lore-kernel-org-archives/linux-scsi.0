Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A242FD7AC
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 20:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755115702; cv=none; b=bgvxAlM7ZcTXLBJhwO5gf3xOJGtkzAyUWj99PViHvf0RU0+Zz3pxk7fluv9tH6OvLwO+OjIHbdbTTRMo1IASfhTjo/P2yGHz66Bp3eyPPsGJb41gkfZrIooNlRxxc8FKgp0u3mlFdNRyTnvaUE/+7VISu7qqKhLViEFvM1tSUQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755115702; c=relaxed/simple;
	bh=DBWXWOv7qj3o//AYq5OwCyJWYgOCjKBgQngVCP4NWA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkj1U0uvCrroLI5nwgh/SuyiX8qwm6ZW35lcqntiqsEYHt3J8nRlpt9iGFpJmpCYdPOsdpG7DCKobhEjL/B9BKoOEmIqWE+EDGy3R+9Ao5qwg9Q9bJRND7jhI2mk0C7c35v9/gIQEnvCsrMZ5lk8AxTtm1r8lPT0vwWx+OGfoMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gP3NNEKN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gP3NNEKN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755115698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GashsEiLQTWm9PM2jecL69D8tPAzp/bzvdPmv+TcMPg=;
	b=gP3NNEKN1laAlQ00YXppRO901Q0y3faEvinSGLhpxEPcQNP8DyNC6nHnk9Nk6qZUPsN2Mr
	Xa/INoy7DfSZA6gYPB60iYtnVzHiL/bkazShyyTiLwRaFEK7Lh+6kCNhn9ND6kgmo+ZpZF
	uyAk7t6g1k6h+Ur923o0ldc2Pu9wBlk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-1pl12zroMledsX5GsaiO3Q-1; Wed,
 13 Aug 2025 16:08:15 -0400
X-MC-Unique: 1pl12zroMledsX5GsaiO3Q-1
X-Mimecast-MFC-AGG-ID: 1pl12zroMledsX5GsaiO3Q_1755115693
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F004180029B;
	Wed, 13 Aug 2025 20:08:13 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.32.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51E3218003FC;
	Wed, 13 Aug 2025 20:08:06 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	linux-hardening@vger.kernel.org,
	kees@kernel.org,
	gustavoars@kernel.org,
	bgurney@redhat.com,
	jmeneghi@redhat.com,
	emilne@redhat.com
Subject: [PATCH v9 2/9] nvme: add NVME_CTRL_MARGINAL flag
Date: Wed, 13 Aug 2025 16:07:37 -0400
Message-ID: <20250813200744.17975-3-bgurney@redhat.com>
In-Reply-To: <20250813200744.17975-1-bgurney@redhat.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
policies to react to a path that is set to a "marginal" state.

The flag is cleared on controller reset, which is often the case when
faulty cabling or transceiver hardware is replaced.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/nvme/host/core.c | 1 +
 drivers/nvme/host/nvme.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 812c1565114f..fafbd5c9c53d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5069,6 +5069,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	WRITE_ONCE(ctrl->state, NVME_CTRL_NEW);
 	ctrl->passthru_err_log_enabled = false;
 	clear_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags);
+	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
 	spin_lock_init(&ctrl->lock);
 	mutex_init(&ctrl->namespaces_lock);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cfd2b5b90b91..d71e6668f11c 100644
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
2.50.1

