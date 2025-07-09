Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50AE55B
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096072; cv=none; b=kn8fG8CF/JPFBMWFoKWO0rKTJ8CeTt1j3+83brnxFHUNBOvidNtlbkg+oO9a3gtIoGOPZysJ+D7JsmNHX5pJoUvym6wAjOJLgebsftRQi/WYMtaXre14VtkxdzYPT3MNRaPZd5RE7QU1FBUP0SxYI8rrW5S7DIuPjI/tef0Tw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096072; c=relaxed/simple;
	bh=VT7NynoS31Rz4b64p1d21tUWg3ecpVGeBKlyOKaXUSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge3QQ3UVFnJy390NmWYG1oTHBZbmnODY2GxGQqYSvf1Y5XqPDeevXK87bhKfPmuXa0E9Bp+2s05V9R+qfuwaIQhHMB8KpeLQ+o7XdWgb2C5OeVxhvC9PS4kFcTazryC7j1cL/FGUTAwfuOnRvYzlx+1QY7gzqEdGLfwDPYpcEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DeoqwIy9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DeoqwIy9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IEoKjLXQqO10CK4dZ145tc/+sBgm/Pdyi+fGs3CUeNU=;
	b=DeoqwIy9jhlQJQ9K6TL1whwDDo6KEDCmuwzS4AYqnvYdhOJR70zf0BHK2Nj37rpXe4QtUA
	IriALnpBkEglcz5TBomCaaA+8Zi8fGbngJiqmG8LIu0euaErznk2FpKot/4Lhk1YtOJJeW
	JZxPsQtW5sKytXL9UiCMyHnCFtqaHe0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-VnTS9VYKN-aq12ZTgyPl0A-1; Wed,
 09 Jul 2025 17:21:05 -0400
X-MC-Unique: VnTS9VYKN-aq12ZTgyPl0A-1
X-Mimecast-MFC-AGG-ID: VnTS9VYKN-aq12ZTgyPl0A_1752096064
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E590719560A6;
	Wed,  9 Jul 2025 21:21:03 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4F8319560AB;
	Wed,  9 Jul 2025 21:20:57 +0000 (UTC)
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
Subject: [PATCH v8 2/8] nvme: add NVME_CTRL_MARGINAL flag
Date: Wed,  9 Jul 2025 17:19:13 -0400
Message-ID: <20250709211919.49100-3-bgurney@redhat.com>
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
index 5d8638086cba..c4ae4041c055 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5039,6 +5039,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
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
2.50.0

