Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A692D0C96
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085289; cv=none; b=dR0Qh+KxkHN2KOqfWQ/odqSNObtHzwGZ1GPxmLBoE60ooH6l9KVnAImt1iweKVY9ruVTq88SFQ8oM77XG2rCw1Rwaqybv1NdCdOxrkg0qhRH0qhE5P9sBPD0lPIaNoB/UK0FC9cYbnkJDiT5JXeRf+R31mjGRsCPtswvSBJrzA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085289; c=relaxed/simple;
	bh=l+XEiH6AEmFKO8kCylOgB7VOe/WqN/qGKCq3iGKsSl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTDWyb5tVZL2JYXIFAutac2P1UAsLUkhW+ImdRuXpaDGShxKA0mEMtpVdBd9c+ZIV9q750v8S+AfNwo3jkyjupa6g+koJCRe2VVCK4OMrEjZM/TYYorfcIKxT/MuEvNYKlVB1ZW3MViAzqx7a/YqELU9z63tjo9EFap4U/dgfWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTq1wzDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTq1wzDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32641C4CEEB;
	Wed, 13 Aug 2025 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085288;
	bh=l+XEiH6AEmFKO8kCylOgB7VOe/WqN/qGKCq3iGKsSl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTq1wzDRYMZAbsBnZ0VxmMdYP8+v12TaDaWaS15Xxpl0ip7rQ++pN/ZWW/7C9fQHF
	 X/B/ZOKTNctGDpKp7AFXchvj+K34A4zBBP2kB2GVDmaBhJ4DSYPXvG5jLGAZ1sUZDw
	 U9qmxEuFfoNT4ONctz/+NUS9cd2NSER6NNJLcNW5Tiar+gUCOxYF42H9sVAk88UIP4
	 m723SdARlIR0mgqAvld/CkV+SurjIruPpKGp1fDyAOAbTXov7Ye9ggfOIacfCpB26g
	 u5dOmOjctcpNwcv0st0uvVehVKymaVIEe080U2hLrCxE+3pQakXlILCtbaUndGyS5I
	 NGizF9GH1FQ0Q==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] scsi: pm80xx: Restore support for expanders
Date: Wed, 13 Aug 2025 13:41:08 +0200
Message-ID: <20250813114107.916919-8-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
References: <20250813114107.916919-7-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1615; i=cassel@kernel.org; h=from:subject; bh=l+XEiH6AEmFKO8kCylOgB7VOe/WqN/qGKCq3iGKsSl8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVF5nWOITrso366GewqEbR8umXfmzVqTi3F7eM79Ov 5jyf6Uhb0cpC4MYF4OsmCKL7w+X/cXd7lOOK96xgZnDygQ2hItTACbi3c7wT90rUtB6hYew7KnF m89MMcgIimvSnH2zk9N3en+eE1/vcYa/0pWbtywMv6nz+uUTjjPvr/yPcZB98Lphrfy679vPvOK zYwQA
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

Suggested-by: Igor Pylypiv <ipylypiv@google.com>
Fixes: 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID")
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

