Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2D238C2A
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753248364; cv=none; b=lqbu9rZ6nzchK+CjqrtUA/PgthsTFh2MJC353nRqPBMwDW3ewmB8eiUbJZ6shYlDs/riTfgjh5bOSB5f4BvM4+OkSYOX+nDagSQLtojkeh/6MM6z+vpadPaz/fq3PCuYCFvmqbtXx1PZ0LxMSp1NBZEv3/RzyWsBhGR2lBXlN94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753248364; c=relaxed/simple;
	bh=fdUkybP+xFq32u1w2ezPiYHWoRKKnGVAGaIEoqbKynk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzGSAIsIahPUQ2fkv/KCKpmtQAjT03JiT/AUrOsq+YsZWuL53zat7vfE6RljxebwXrkkbXgWwG28MpWh2WMV1tzO6WAAe8J7+jLVl8Szwpp8N0gaisMHE9d4TldqdBRpR75qY8iVrxJ9OyXKEViTvMB9P25hDPJ7pj5eUVs2e1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tRuOOSf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tRuOOSf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFFDC4CEF4;
	Wed, 23 Jul 2025 05:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753248364;
	bh=fdUkybP+xFq32u1w2ezPiYHWoRKKnGVAGaIEoqbKynk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRuOOSf4nQxU7BFqXjlU9vEggkyRCMR6p+/bhKn7dbEPiKUqYScHTKdGHjcqcknMY
	 xtvJQwCCppKj1f0KtNWGMbsQO+XxN0N+PG/oFNjZTJWnzSMCIToV+oqCn407CaNloe
	 A6BnvLOfEHLmmdbxiZmCgI1c1FyiWk2onl/1u3vPdWoYThJ4z5guTMz9SRPwtuBMmT
	 J0HgysFVW+sU1g11IcYLL1r6GR9HCIi0hbcUj7H2vRAYDw9nbgM9s0Mr1G2NtwmBJ6
	 8QL8dPfmo5ubCu8xOHvBQCYf2VSrp+4aemz6BWbOI3M4OFGxMRr8i6kAciGEcpCSjW
	 dxQw8hM0tuCfA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Cc: Friedrich Weber <f.weber@proxmox.com>
Subject: [PATCH 1/2] scsi: Allow SCSI hosts to force-disable CDL support probing
Date: Wed, 23 Jul 2025 14:23:33 +0900
Message-ID: <20250723052334.32298-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723052334.32298-1-dlemoal@kernel.org>
References: <20250723052334.32298-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Users in the field have reported issues with Command Duration Limits
(CDL) support probing when hot-plugging ATA devices in enclosures served
by some SAS HBA models. These issues seem to be limited to older HBA
models that are now EOL and not getting any firmware updates.

Given that recovering from these issues sometimes even need a full host
power cycle, allow a low level driver to declare its lack of support for
the CDL feature on ATA devices using the new SCSI host template flag
no_ata_cdl. If a low-level HBA driver sets this flag, scsi_cdl_check()
returns without issuing any command to probe an ATA device and reports
CDL as not supported.

Reported-by: Friedrich Weber <f.weber@proxmox.com>
Fixes: 624885209f31 ("scsi: core: Detect support for command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi.c      | 6 +++++-
 include/scsi/scsi_host.h | 6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 534310224e8f..60ec9e8e4d8a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -649,6 +649,7 @@ static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
  */
 void scsi_cdl_check(struct scsi_device *sdev)
 {
+	const struct scsi_host_template *hostt = sdev->host->hostt;
 	bool cdl_supported;
 	unsigned char *buf;
 
@@ -657,8 +658,11 @@ void scsi_cdl_check(struct scsi_device *sdev)
 	 * lower SPC version. This also avoids problems with old drives choking
 	 * on MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES with a
 	 * service action specified, as done in scsi_cdl_check_cmd().
+	 * Also ignore CDL support with ATA devices for any host declaring
+	 * lacking support for this feature.
 	 */
-	if (sdev->scsi_level < SCSI_SPC_5) {
+	if (sdev->scsi_level < SCSI_SPC_5 ||
+	   (sdev->is_ata && hostt->no_ata_cdl)) {
 		sdev->cdl_supported = 0;
 		return;
 	}
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c53812b9026f..b815cc012f2c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -462,6 +462,12 @@ struct scsi_host_template {
 	/* True if the controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/*
+	 * True if the controller does not support Command Duration Limits on
+	 * ATA devices.
+	 */
+	unsigned no_ata_cdl:1;
+
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
-- 
2.50.1

