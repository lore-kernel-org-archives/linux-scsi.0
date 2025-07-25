Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECFB19066B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408848; cv=none; b=rvsJz0HgVu49Z9lHIeZi1L7rHAGQCEblRJjDDsTzIY73UUUiJh6LjBo2H3BfZTCCbswOgtXINymQXYmwsFBTjSwaIVz+dytTUtEAedwHzCxonwMERnfvy0fLOdzMHUTUY1wSzPlEdc82t+stvdk+TqSUuTMGsVtCfHvUelvM2F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408848; c=relaxed/simple;
	bh=vy+azCmp6KmOjcT9B4yizJSZv387vTXiVaypyh3seMM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1JR3DNkgBb2t3zVpQtJ/6q6VCrkyWzr6/19OGJFJzTAhdeuC9fR3/2up8TvzZwc5xI/3xThjq2S5r30crLczhzVlJ0PvB+MR65bm2Td9ueRCMTIvop7N1WnzDK9ksjgZ/yLZXXxU7lNzDXImUk0hpZVkY3F9wsmNtSuXtiBPuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9rKplRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9rKplRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD9CC4CEED;
	Fri, 25 Jul 2025 02:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753408848;
	bh=vy+azCmp6KmOjcT9B4yizJSZv387vTXiVaypyh3seMM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q9rKplRjuQFC1BPotCR72fSJyZ6AgZoGdAxRXuJNMu9UNQdsSO7ntLGaXcKOm/bvz
	 Exr7r3I+eTJNxW3yXlAK9XExFLgh/4jOjM6vrzrD5hQPX8H46vcYVwej2iC2XTsfl4
	 qU9LYXOOh7bQzEpKvOsT7Bgv5oXn6lWkqnN1oKklIyEbG//8nEfpbOBkmbmuvGkL0r
	 9RDJGggSpxaGzLxm5LfoZErmxyADfISI6JIDG3IcvOxBiLtEsaIVTEmXDUBxZ2AD6K
	 XKLLS6OigV6nyjcK1b/aIOzHb1DHLUH6owaC4Q2quCnv0MKrBhjH1+YF+mUQsQ1t55
	 ceN1LxSU8hmcg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 3/5] scsi: libsas: Make sas_get_ata_info() static
Date: Fri, 25 Jul 2025 10:58:16 +0900
Message-ID: <20250725015818.171252-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org>
References: <20250725015818.171252-1-dlemoal@kernel.org>
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
index 2cbf38b18c5c..cc093cdc9c69 100644
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

