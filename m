Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A246FBF
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 00:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315504; cv=none; b=gKEycyEQocAzrMuqS5xzFQF8K9DAKjlRRPBe2tBh/hEjOpghriEEPYdGKaSNmfZMPlPuaqyMZkMLFjxUjaPo+R/2oPe2s8bMyHxenFVwkDeUHd73MBSgt38tw0REuBPoqHn2xtP1hQE7nqwU50MWcIbTA8liKiBAZt/LbC/bwDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315504; c=relaxed/simple;
	bh=TuFCKJziW4MddtRyTPr+pqQ/kODb1W7xYpT1To/p55E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWY4TsHJb/G5aLrCgejv7+YSvkk7osNHQG0DZ7VdoaYMDFurhiEUts87hRRCA1WyXQZ21dhAu6w/6F6NEkIErcCpeIasuanQUAaEmoy3+bsRo/2X041e1n0XZUg8713hi5XXBlm43YpzbUWLfsQz4FEcxwgrxJtm85iPcBkHTvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzsHLVNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzsHLVNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6155C4CEF4;
	Thu, 24 Jul 2025 00:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753315504;
	bh=TuFCKJziW4MddtRyTPr+pqQ/kODb1W7xYpT1To/p55E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DzsHLVNhVBRN0u1AFUN6TL9rHiONsEI78KN6fw+r89Y2AfskqOMotJhXITdCtAbrR
	 0KAMxNwyYmpHCPi3BQV6VDtXpGGeSbB//QPZWeacb9Xbl1UpkbzkBRJA9z9YdYvAfa
	 HcuVcEsz7zhRH0wNSx45lpIz00XYokfIeEXvgHyJ5dllAH+lhbviOmfGsl8LJXfmTJ
	 DnHrRhRv32ns7BwKtlFlnu2YdwCKR0kB46sc9xaYixT+g8gqDF4Ct7w2nAUgcshe7W
	 Ighd5hgdHoKHCRiwltRPkmrX4sCXZ5u/9EYO9iWK9Fw/wKBa5dCUQVyL0BG787mUMs
	 F8XYcWoR6Qwvw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
Date: Thu, 24 Jul 2025 09:02:32 +0900
Message-ID: <20250724000235.143460-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250724000235.143460-1-dlemoal@kernel.org>
References: <20250724000235.143460-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the code of sas_ata_wait_eh(), removing the local variable ap
for the pointer to the device ata_port structure. The test using
dev_is_sata() is also removed as all call sites of this function check
if the device is a SATA one before calling this function.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7b4e7a61965a..2cbf38b18c5c 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -927,13 +927,7 @@ EXPORT_SYMBOL_GPL(sas_ata_schedule_reset);
 
 void sas_ata_wait_eh(struct domain_device *dev)
 {
-	struct ata_port *ap;
-
-	if (!dev_is_sata(dev))
-		return;
-
-	ap = dev->sata_dev.ap;
-	ata_port_wait_eh(ap);
+	ata_port_wait_eh(dev->sata_dev.ap);
 }
 
 void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
-- 
2.50.1

