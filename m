Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6E4360EC7;
	Thu, 11 Jun 2026 06:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158564; cv=none; b=TJmjtOQ7CK6ErLdHkrUdNhO8diXUACSlbzoCNE5e0je3PZvw1iA2CsjrwnQ8cpVJTjrNE2UnuVcfIz+HttTTpW4UwIOtV+E3NWi+ctL3RDX3vX5ZgQ0YGcaZDAqMlDpT/Ravg/rd5Kj6zOKsdmd0DBG2KX/FjNdU4Pm08rkCxJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158564; c=relaxed/simple;
	bh=Y2LGu+LRxm6aO2AbsuJTxG6xif81p/uTbrUQGn1Ovms=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MRutGfJV+/olR75Cl7MwlM5vznUnGaOp4Z6qa9iLFaOnO8BoCrUDzS1nIUQ9P3XUgCMRNPoHzW6uDQm4cOr5rezJ/dvmsv783aMcPahG8q1uO4Ax6yG8D9bhIKB9oliqm8LfmWmUAclAHEbvHR3RRGlrbMXFoF1DDmQjsr7/SRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=m4Uy4Unq; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="m4Uy4Unq"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yL/O134Y23bR+GbIpNUFroueUl48PwdpiBvFihnM3ck=;
	b=m4Uy4UnqbAISfYuVZ4MmQPjZyha4PtGK51zleZi4hrCDKxl4Gw7qDyKJo1RO1yf2W7sSK6C4M
	C6ocjSj52gODKb/N1BWnEGpslv9nk5uor/5OfjqakGT6W0uz+TKvOqCzcAjSV1UJPee5qwQZjhe
	mQJ0kuo5zw3SDAfQaG4daLU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gbXJ41ZlKznTVK;
	Thu, 11 Jun 2026 14:08:04 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id C84D5402AB;
	Thu, 11 Jun 2026 14:15:52 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:15:52 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v7 0/2] libsas: rediscover improvements for linkrate/sas_addr changes
Date: Thu, 11 Jun 2026 14:15:49 +0800
Message-ID: <20260611061551.1171058-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When a device attached to an expander phy experiences a linkrate change
(e.g., due to cable reconnection or negotiation), the current code in
sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
if the SAS address and device type remain unchanged.

This series is based on John Garry's suggestion [1] to check the linkrate
and mark the device as gone and rediscover when flutter occurs, replacing
the previous v2 patch series that used lldd callbacks.

The previous v2 approach added lldd_dev_info_update callback which John
commented as "seem fragile and too specialized" [2]. This series adopts
a simpler approach that directly checks linkrate/sas_addr changes in
sas_rediscover_dev() and triggers rediscovery using libsas's standard
async discovery pattern.

This aligns with Jason Yan's earlier work [3] which was verified to
solve the linkrate change issue.

Additionally, per the discussion in v3 [4], the existing replace code
path also suffers from the same sysfs duplication issue: 
sas_unregister_devs_sas_addr() only marks the device as gone, but the
actual sysfs cleanup happens later in sas_destruct_devices(). Calling
sas_discover_new() immediately after unregister causes sysfs_warn_dup()
errors. This series also optimizes the replace path to use the async
pattern, ensuring proper ordering for both flutter and replace cases.

Changes from v6:
- Add comment for restoring phy->attached_sas_addr to child_dev->sas_addr
- Optimize the conditional structure in sas_dev_is_flutter()

Changes from v5:
- In sas_addr change handling, restore phy->attached_sas_addr to
  child_dev->sas_addr before returning false, ensuring
  sas_unregister_devs_sas_addr() can properly match the device via
  sas_phy_match_dev_addr() for correct device unregistration

Changes from v4:
- Rename sas_rediscover_phy to sas_rediscover_ex_phy for consistency
  with expander phy symbol naming convention
- Rename sas_is_flutter to sas_dev_is_flutter per John's suggestion
- Check return value of sas_ex_phy_discover() for errors
- Factor out child_dev checks to improve code clarity

Changes from v3:
- Also optimize the replace code path to use async discovery pattern
- Introduce sas_is_flutter() and sas_rediscover_phy() helpers
  to encapsulate the flutter handling logic and avoid function bloat
- Fix replace code path sysfs duplication issue

Changes from v2:
- Drop lldd_dev_info_update callback approach per John Garry's suggestion
- Drop hisi_sas specific changes (no longer needed without callback)
- Use libsas's async discovery pattern for rediscovery
- Add sas_addr change detection alongside linkrate change

Changes from v1:
- Split into three patches

[1] https://lore.kernel.org/linux-scsi/c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com/
[2] https://lore.kernel.org/linux-scsi/28bd9d5b-f597-0aae-5340-bd951b2083aa@huawei.com/
[3] https://lore.kernel.org/linux-scsi/20190130082412.9357-6-yanaijie@huawei.com/
[4] https://lore.kernel.org/linux-scsi/b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com/

Xingui Yang (2):
  scsi: libsas: refactor sas_ex_to_ata() using new helper
    sas_ex_to_dev()
  scsi: libsas: Add linkrate and sas_addr change detection in rediscover

 drivers/scsi/libsas/sas_expander.c | 94 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 77 insertions(+), 18 deletions(-)

-- 
2.43.0

