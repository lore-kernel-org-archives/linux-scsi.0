Received: from out30-87.freemail.mail.aliyun.com (out30-87.freemail.mail.aliyun.com [115.124.30.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE12BD5BD;
	Mon,  8 Dec 2025 07:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765179098; cv=none; b=Q+nFF71oGLkSgHNXA/Ew7qdfJ05x/GxFUk8GnFMBkNsD6jxt8s6N6EYD3caLpafgWwrJcPtlbb1tAYd+cEfp7sICO5yV4NKP8AQeGHavNMqx3doCKR6W7WG2NImkiNFrNJVZDq5QdpOUN/X3MKIexenJbdOiaBKkU87TsuNvcdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765179098; c=relaxed/simple;
	bh=7obDSqtlbjhEi1Y+MA91W8RB3SDVYOccShSSjnkdpBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TzJuMbagE3Zomm32FArIK6Jy/mjFw/dW/MqD81k2zm+DE/3Dj3Lqm8qFAgVjC26bbGc9KnN0i03GFW8E17QCruLMv0EiK1iXnMRF+sDnmkmtz+yTQjGaG8bxg6sJ9kIRYkuRFw1dX6gJwhQkwCPkiH5gfMWe8fZGpNo6JSlSsyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=RhL1Mhu0; arc=none smtp.client-ip=115.124.30.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="RhL1Mhu0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1765179090; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=dh9la70FJtwU2wYpdJhgpAPewMnCzQ3uI4uthbRGpew=;
	b=RhL1Mhu0nsw1R+RteWXpyeItdvxbFDTwKjj0LVfA2Fql/BgGGKu5HjsZ5K24ol7FdehMIJ40dIg0ybZ55j9aPXCIpKRNTQ2fYpMKQ6pRObaWWDs1c2XIBiWRgT6iWxquvDJ8tmKxbZnUiHqW9D8ydxZgpwcc4Et8Q4nwFQxiqYI=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WuHPuky_1765179083 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Dec 2025 15:31:29 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	mingo@kernel.org,
	cassel@kernel.org,
	tglx@linutronix.de,
	wdhh6@aliyun.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libsas: Fix potential array out of bounds in sas_check_*_expander_topo().
Date: Mon,  8 Dec 2025 15:31:21 +0800
Message-ID: <20251208073121.3773147-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No check was made to ensure that parent_phy->appended_phy_id is within the
valid range. If the expander reports an invalid phy_id, it may cause the
array to be out of bounds.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/libsas/sas_expander.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d953225f6cc2..07633d795182 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1266,6 +1266,11 @@ static int sas_check_edge_expander_topo(struct domain_device *child,
 	struct expander_device *parent_ex = &child->parent->ex_dev;
 	struct ex_phy *child_phy;
 
+	if (parent_phy->attached_phy_id >= child_ex->num_phys) {
+		pr_err("Invalid attached_phy_id:%u, num_phys:%u\n",
+			parent_phy->attached_phy_id, child_ex->num_phys);
+		return -EINVAL;
+	}
 	child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
 
 	if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
@@ -1296,6 +1301,11 @@ static int sas_check_fanout_expander_topo(struct domain_device *child,
 	struct expander_device *child_ex = &child->ex_dev;
 	struct ex_phy *child_phy;
 
+	if (parent_phy->attached_phy_id >= child_ex->num_phys) {
+		pr_err("Invalid attached_phy_id:%u, num_phys:%u\n",
+			parent_phy->attached_phy_id, child_ex->num_phys);
+		return -EINVAL;
+	}
 	child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
 
 	if (parent_phy->routing_attr == TABLE_ROUTING &&
-- 
2.43.7

