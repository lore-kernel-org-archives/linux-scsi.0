Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F6F254AF0
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192759; cv=none; b=YAxDZAYBeCqIQWM5hy+18F5nkm4j1uFTjssFNtYoyAXf8Ru4Sop0lUSX9o5GxVR5S/ukI95KluDj7eKvAvZQ6eV+ZADN4LouKv9CsShqd7YG1pZNWOtrcVuB9sHM2B8sjr0/t3pgtkhKG7u1LNX3eWjcO1qZZRVN0IBSlOx/NlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192759; c=relaxed/simple;
	bh=RjpHcZmb+gW/BlwI+KvyGPTI4JxdNy2LZe2pSWa/oDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMC/0byPiqg+9xljKfkXIEx9vif1mnvH4Z0P3YsM3NPXHIplTx2jwNxNntuPHng+sA0BkA672CRKTPNireAfSXf7pSz1DzdCJIjJ/+GCQ7FUCesxCiai1bT1BMJRR/5UgK7A9aDICb9wJxc0+/gvzmyYRU6Y5VBMGwNSY62YKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dG87cbxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dG87cbxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35030C4CEED;
	Thu, 14 Aug 2025 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192758;
	bh=RjpHcZmb+gW/BlwI+KvyGPTI4JxdNy2LZe2pSWa/oDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dG87cbxt8thL+Q/3ELHTq64ezEhCxP/DkzbQgxyK54S/KPRJeea22vkcEYbu0IVqo
	 4K1/m1VYlnfK82lxVipPsyoIze1EClLpnj9rvNRNZzYSdUJRHt35Cyqf+pBto7eNn5
	 ZwzxK7uuTmIdIcTl/+rI4T2tofjowKDNKII6pY44sPz01YqsMb1cdJVUBG+1/hn0So
	 kamWf7+tc01ZZZo2exKShCRcs134yoE3k6TuBnP5tBme9Bwpt6cGx31kt7/56ejyPk
	 jfeHk+Xau12gW73pnfRRqtpnUTLIV+cotrWXv9/qE7mFlTI6rHB0gWnH+o05JCwi26
	 lCU7t0LJ70oUA==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 01/10] scsi: pm80xx: Restore support for expanders
Date: Thu, 14 Aug 2025 19:32:16 +0200
Message-ID: <20250814173215.1765055-13-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1664; i=cassel@kernel.org; h=from:subject; bh=RjpHcZmb+gW/BlwI+KvyGPTI4JxdNy2LZe2pSWa/oDo=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS6Rz1o24cQVuX9nrG+FHXL1XZOx8oSBpkpz9LZ1z z1KzRbId5SyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAi2eGMDNNzBN1f1uuVfgzN iODc7JJ/XN3rkZ5TldAexuSWVzxyHgx/xWd/WF3v//41v1p23pfpU4OiZk7xf+RUZpI6Wbr0e1U hFwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") broke
support for expanders. After the commit, devices behind an expander are no
longer detected.

Simply reverting the commit restores support for devices behind an
expander.

Instead of reverting the commit (and reintroducing a helper to get the
port), get the port directly from the lldd_port pointer in struct
asd_sas_port.

Fixes: 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID")
Suggested-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f7067878b34f..753c09363cbb 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -477,7 +477,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	bool internal_abort = sas_is_internal_abort(task);
 	struct pm8001_hba_info *pm8001_ha;
-	struct pm8001_port *port = NULL;
+	struct pm8001_port *port;
 	struct pm8001_ccb_info *ccb;
 	unsigned long flags;
 	u32 n_elem = 0;
@@ -502,8 +502,7 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
-	pm8001_dev = dev->lldd_dev;
-	port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
+	port = dev->port->lldd_port;
 
 	if (!internal_abort &&
 	    (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
-- 
2.50.1

