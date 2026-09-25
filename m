Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00471DDC38
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320669; cv=none; b=ZSEMOZMWeNA/hoca9A83UixGE6nf+giyOQy8JMxXNxA/+yiDSj0QrG9f/Kw+wNJBsiIHYb0Yv80vDlgc5WhrgtT8QGNHlIsH6v1wJJEbxfP1rddo1IOc41LRY7ugtAQalci+5Ph8PisRMC0HGTJbZwhg0JykRIxal8MIM5i8/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320669; c=relaxed/simple;
	bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNRQZqmKO+Zyk9yALtjLBsNUDLI9ar2gDp5NCwuyrVE8+aJHqIy81mNAbHoNymf8l4367nSoKtFqImKfkeyZOAlxRtlJbZx/kc/070mMWnzMgxgeRsnTBMMgUUuQi4GOB+PzOPfXseECbjUQ6007oozs90ARCLlYm1NY5T4eGuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tvc0wG0n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tvc0wG0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89421F00893;
	Fri, 25 Sep 2026 07:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320667;
	bh=ey0gyz67TSo2myMlN7dPMXp4he7umj2+wNfXxNtkXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tvc0wG0ntzIQIpMIAkGi8+SAZU+9iYB/hx9RjO+LcXfSAp0z31xT4uGeYwxwkO2NF
	 UAjw/+8m3rdeVnpTeq9vYkV1XC1J5FUIpuCsEXK9T+RpsQg1xj3WkcYy8MjOU27lg0
	 9ZHCaNMc/fJincRtBXstZef2BNF/+diYLNdi5qhCI6L0NyQN+bNSrdSydApY1B80BP
	 Hm84oofInnfVTOYORdPIMhcNtWPGvve1cGSZXIuNT27lbkLH9OEeZXBWwgfEgm5bI2
	 le1qXuRizKpGhpW5YUfXMKScO0t2AhN7Cv5icYopwgD1g9jFW2x3G9kJ92VwfjPjtC
	 qYr9vcz5wCs2g==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 01/11] scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligned LBA
Date: Fri, 25 Sep 2026 09:17:28 +0200
Message-ID: <20260925071726.140915-14-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1627; i=cassel@kernel.org; h=from:subject; bh=4SOu81yTRppMjmvYzStwz/4XSobf5kfsWdTXYk3JlgY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQjZnT5taLC3spZB+vwd/vyTYkdlXdmV7sy8YqhTs +GekExbRykLgxgXg6yYIovvD5f9xd3uU44r3rGBmcPKBDKEgYtTACbyN4Phf8ldpcc3Vz3/X7rt 88UAzp3BVRePKX/Oz/Sf92rullrP3XGMDMeua7ziO30lx37GydyJ0zRctlyc+crfhKN2q2alZv8 1FzYA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_debug reports the lowest_aligned module parameter in the LOWEST
ALIGNED LOGICAL BLOCK ADDRESS field, see SBC-6 r02 (T10/BSR INCITS 587),
5.20.2, but nothing else in the driver acts on it.

On a zoned device a non-zero value puts the start of every zone in the
middle of a physical block. ZBC requires a write to a sequential write
required zone to end on a physical block boundary, so a host writing in
units of the reported zone write granularity could never write such a
zone at all.

Refuse the combination rather than emulate a device that cannot be used.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested by loading the module with each combination:

  zbc=managed lowest_aligned=8    refused, -EINVAL
  zbc=aware   lowest_aligned=8    refused, -EINVAL
  zbc=managed lowest_aligned=0    loads
  lowest_aligned=8                loads, as the device is not zoned
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6941809dfdb7..c664966e95cb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8734,6 +8734,11 @@ static int __init scsi_debug_init(void)
 			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
 	}
 
+	if (sdeb_zbc_in_use && sdebug_lowest_aligned) {
+		pr_err("lowest_aligned is not supported by a zoned device\n");
+		return -EINVAL;
+	}
+
 	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
-- 
2.55.0

