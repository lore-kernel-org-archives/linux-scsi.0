Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3296219A9B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753249292; cv=none; b=QQnvrAagNo2fEH7XeuS2OmHz3PhAztD2W3ouHy6DpIUOxl+z2E3vieIjTaNXUm1HBlrRiLzPR9CvUSPQlVBTogb+0XnGYMQd7KZvNmda1E/t2Ggs4VijHhDesQm95rUEi62UA69v61ySLJVFoyuJXelPDm5kaC2hF7APzKgBCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753249292; c=relaxed/simple;
	bh=02P/z9qEPQY92sz1kkCwWnxzpY61PWsE8GE3b+bUowQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaUByXRlXLE7KYdPanLljLH4/TVvtrwUZclBIAsIMy0Y5U6ki98HS7fhLvSfLMCPVLWCtoFSmomj3niez8GARvidI3s0OA/EkhvcaTHwQdi+5LsNBX1wj21nC/QTyXMz/bR6ykQUTbBEb8lgiLRGBvu6+K3cHOHVyGX8GWW+RB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXzHO1tQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXzHO1tQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D517BC4CEE7;
	Wed, 23 Jul 2025 05:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753249292;
	bh=02P/z9qEPQY92sz1kkCwWnxzpY61PWsE8GE3b+bUowQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kXzHO1tQEOhG/J+k6K8avGMNuQbV5ONv5dVglBqyEo8mqfnnmHARK8O8TqPWWRzf6
	 G0lOuhHPszHYIEqvyH6Z0AQ04x9/UclXvGHyC8ErAKHGCe07w5LNegRbJYp49Xpg15
	 HMuS9f+5tqR0mzwrBCBJKR4RNzgKeQfeRok023Uj/Bn/runAYUtL3kPnsgPYO7LRK5
	 gIlwL5J+GiCf2ypfvEQlQnI/eeRPMJq3ty7TtXLcsX8mKR/nQCVxT1Xu0n+0v6iRHg
	 5DJGRYNwl0xA6n+ceMqka8Yyxjz/5SKGtT4jnS7SMT/LhIDb/S/yNq/6lspf/Ku8u+
	 akehHNEVcw7zg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/4] scsi: libsas: Make sas_get_ata_info() static
Date: Wed, 23 Jul 2025 14:39:01 +0900
Message-ID: <20250723053903.49413-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723053903.49413-1-dlemoal@kernel.org>
References: <20250723053903.49413-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function sas_get_ata_info() is used only in
drivers/scsi/libsas/sas_ata.c. Remove its definition from
include/scsi/sas_ata.h and make this function static.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 include/scsi/sas_ata.h        | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0afc9944d985..f10a37f1ee3e 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -252,7 +252,7 @@ static int sas_get_ata_command_set(struct domain_device *dev)
 	return ata_dev_classify(&tf);
 }
 
-int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
+static int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 {
 	if (phy->attached_tproto & SAS_PROTOCOL_STP)
 		dev->tproto = phy->attached_tproto;
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 4317c39f77bb..f8806de007ab 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -21,7 +21,6 @@ static inline int dev_is_sata(struct domain_device *dev)
 	       dev->dev_type == SAS_SATA_PM_PORT || dev->dev_type == SAS_SATA_PENDING;
 }
 
-int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
 int sas_ata_init(struct domain_device *dev);
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
@@ -84,11 +83,6 @@ static inline void sas_resume_sata(struct asd_sas_port *port)
 {
 }
 
-static inline int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
-{
-	return 0;
-}
-
 static inline void sas_ata_end_eh(struct ata_port *ap)
 {
 }
-- 
2.50.1

