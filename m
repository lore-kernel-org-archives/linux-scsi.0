Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DCFAD23
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260854; cv=none; b=gq58rwIwFcFGRLRhol6ZQ4n7j+Wmgt5alZiJ7lNBVWI3NIW19IH1hTtuEO89Xh3mTnD+CrJoDCtmTAlaCaSVxZGABTi+4g+3kenXFg6BCAEHkt+PYFmaI5iG8xeXRX+8gdKk0hQB/VNNau7Xk+i0rqlcuJ5f+aDEqgOSZtDkjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260854; c=relaxed/simple;
	bh=5qlbiZU7Y9gFe3uhv3ojWC3+uVBYjmqogyNsxsvxjLo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T35yHCw0P731SI3+Z34D5EQ83cmG87wfoeMYen4sx5ccuPF5vMAce7P94l+jOQElzivwhNJRMN28aU2nxmbuXezIdXy4pN0v2yWiL4g2F8rQdPDjWIABy77Ho0s9pgdekwWF6QQ13fdDEaVScQWyFWq7rK6RQkW+GCfSgRkOxgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVFD+EAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVFD+EAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189F2C4CEF4;
	Wed, 23 Jul 2025 08:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753260853;
	bh=5qlbiZU7Y9gFe3uhv3ojWC3+uVBYjmqogyNsxsvxjLo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EVFD+EAf8MSIIX0uazoHffeGD0PeKaZB6dvK56J664KOwjhCYluf0SxaiZW2/Zdi/
	 j0TYKbFeC1TxLO5bIJU8ITcmmJ6DO/XQ2PzyNqJN7Z06O8FcUxl0Fw8HvWZxKqS5v/
	 trXDAIf3gSEjQ54oH16i7+BDJkXwf4I8M0u7rFgq/b6h5M0u29wSyVf1eJcSQ5qcpf
	 fjKyIse6vjzNJTdMVWC9uOQH4QHf2egNIeRqXQKOlBdAi2vdimc/VeYJDbUZEcg5vg
	 3oBZ3ql0yjb02Vf36DfIyI2mdhOqTQiRsrp1rqYiBHRswP7k1Dujvi2LH3UZNV2FNX
	 CQc1GhSkaTY7g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/5] scsi: libsas: Make sas_get_ata_info() static
Date: Wed, 23 Jul 2025 17:51:41 +0900
Message-ID: <20250723085143.134333-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723085143.134333-1-dlemoal@kernel.org>
References: <20250723085143.134333-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 include/scsi/sas_ata.h        | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 440efdc714f7..660508286f7e 100644
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
index 8dddd0036f99..5e3475975aee 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -28,7 +28,6 @@ static inline bool dev_is_sata(struct domain_device *dev)
 	}
 }
 
-int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
 int sas_ata_init(struct domain_device *dev);
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
@@ -96,11 +95,6 @@ static inline void sas_resume_sata(struct asd_sas_port *port)
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

