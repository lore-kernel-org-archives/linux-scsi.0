Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85AA1FECCD;
	Tue, 11 Aug 2026 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786421028; cv=none; b=AHxYR9Rih4NugQ/YwMz3VRL9abWmKM+EoHS8flFGTIGML6sJM2YCG5Fq3rCpaFppBHuGo1MEfAxTzEqL8+Z4KQksS+g05xMQTXMSlaZsIb3hI8ST0FZ2YmsiQ1YS/1FWl1UD24LzYPCqrMm+/oQ0B6gVi5dcxTK1+t8Shu2NkBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786421028; c=relaxed/simple;
	bh=8jdrBUiP6yMAlhO/ifHNTp2k4P59dJwZPLBbvhe8oag=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KkgmKIg81TcYwqVVmHCoDr1ocmkbXoLUWLHCyu0uIOl9DluznEvmfzDxFva80Lp9JxgwWChnv3wI6VpOSsJRj3xlELMQlPuWoSmIQH4E0y0Zm6xmOfPdP3XgLftldng+1I6iGHO0UZnQlxZUF6Q+Uhzr2kyA4t9Z1fcJ7i9j5kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=i4modmgr; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="i4modmgr"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=awNq41Q7h0I0DIdweVPFE0Rhh4HDwtfWR7WMt9P5sDA=;
	b=i4modmgr0YRYf5y7P4ckDvUwapKAtP//Q4vUvKdlDS6KZPaRN+Wt7xicCIUjtY8aA4OVk5GaK
	/1SprsGfcVN8+BwLifVHR3U9CSUw79NwbUMIqP2r4KvwoQ4NOljzTjaKHkDNI0gTIJgPEh/dMjM
	Uf6eggtI6+ttQ4Oczk+V3rs=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hJyQ141RMz1prl2;
	Tue, 11 Aug 2026 11:52:57 +0800 (CST)
Received: from kwepemp200009.china.huawei.com (unknown [7.202.195.233])
	by mail.maildlp.com (Postfix) with ESMTPS id E3D794056D;
	Tue, 11 Aug 2026 12:03:35 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200009.china.huawei.com (7.202.195.233) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:35 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 12:03:35 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v10 0/2] libsas: rediscover improvements for linkrate/sas_addr
Date: Tue, 11 Aug 2026 12:03:32 +0800
Message-ID: <20260811040334.4184911-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)

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

Changes from v9:
- Rename sas_ex_to_dev() to sas_ex_phy_to_dev() per John's review [5],
  for consistency with sas_ex_phy_discover() and other phy-related
  helpers
- Remove the defensive NULL check for ex_dev per John's review [5], as
  no current caller passes a NULL expander device. The check was added
  in v7 based on an automated Sashiko AI review suggestion which may
  contain noise

Full changelog at [6].

[1] https://lore.kernel.org/linux-scsi/c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com/
[2] https://lore.kernel.org/linux-scsi/28bd9d5b-f597-0aae-5340-bd951b2083aa@huawei.com/
[3] https://lore.kernel.org/linux-scsi/20190130082412.9357-6-yanaijie@huawei.com/
[4] https://lore.kernel.org/linux-scsi/b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com/
[5] https://lore.kernel.org/linux-scsi/11581a25-caa6-4ea3-9aa0-2a4dacb7f34e@oracle.com/
[6] https://lore.kernel.org/linux-scsi/20260624063230.3264029-1-yangxingui@huawei.com/

Xingui Yang (2):
  scsi: libsas: Add sas_ex_phy_to_dev() helper
  scsi: libsas: Add linkrate and sas_addr change detection in rediscover

 drivers/scsi/libsas/sas_expander.c | 96 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 79 insertions(+), 18 deletions(-)

-- 
2.43.0

