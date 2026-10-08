Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F302931F4;
	Thu,  8 Oct 2026 03:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429978; cv=none; b=g7LMlhHvdWGn9pso+5G0UuYK7LKpXPe2yMI4q67/aUjZiaeDaWOFWOTAWkco7Kn/VyZcLy5Bdmd9ZtLF3JIXSuJcy/8JURMHK2aKkrMQ0yA13V+/6InvU7iA/Kj8ZnYk1/ebMU7I2d+5jI51NtbW1sSVBIMzwsqLjdt31pe+Dfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429978; c=relaxed/simple;
	bh=s1uKTRF3ikNsqvjAcL1++JtKq9fhnd2kNamRn5bGtWY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gpL3Rfw9iH5xCplHBP1/74r5qZsTrHu/td2+JAgvTHk0I4Lt+Rpl32pxD4RAhJT3xY5GVcyiTytbR0l9+rEfNt3KknAw/i9PsvJwHyWghanpmboB4nX4tEw9o1yfzqw02oAHoCAQcqnagQGR1VNNKnaz4bzxOCKgSOhxn8TBZ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=lKRV+NcR; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="lKRV+NcR"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K/SSbPtEDp8t7CiB5g5PgAyha5euJ3huYPLY/3nLBhQ=;
	b=lKRV+NcRdDtgnYBHIrFwRQRQrfHotJf9ttvtigV316jtJMv4CmGpxuyU6S0WlNObWrAwGiaSU
	imahsZCaNl/vToAhuFDgElr7+LY0CHfS0ARFu7W+ZqDdynyilJpfVk4N4yfMePNNRb5/vJaKX/D
	R4KjszbhwsFggn0WJrfNEcU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4j0Znz46vwzpSy8;
	Thu,  8 Oct 2026 11:13:43 +0800 (CST)
Received: from kwepemp200008.china.huawei.com (unknown [7.202.195.107])
	by mail.maildlp.com (Postfix) with ESMTPS id B7F044057F;
	Thu,  8 Oct 2026 11:26:07 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200008.china.huawei.com (7.202.195.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:07 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:06 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 0/4] scsi: hisi_sas: Some misc fixes
Date: Thu, 8 Oct 2026 11:26:01 +0800
Message-ID: <20261008032605.2853026-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

This series contains three independent fixes for the hisi_sas driver,
plus a libsas fix found during review.

Patch 1 fixes an out-of-bounds memcpy in sas_ssp_task_response(): a
device-provided sense_data_len >= 0x80000000 turns negative in the
min_t(int, ...) clamp and becomes a huge memcpy length.

Patch 2 fixes incorrect delay values introduced by a previous
magic-number cleanup commit. Three delay sites were changed to use
a single macro (value 100) which did not match their original values,
causing increased boot and shutdown time.

Patch 3 clears stale PHY error counts on phyup so that error detection
is not misled by intermediate errors generated during link
establishment.

Patch 4 fixes spinup failures of directly-attached SAS HDDs that power
up in the Active_Wait state and wait for a NOTIFY(ENABLE SPINUP)
primitive before becoming ready: parse the sense data in the slot
completion path and send the primitive from deferred work.

Changes from v1:

- Patch 1 is new, found in review of the sense parsing of patch 4.
- Patch 2 (v1 patch 1) is unchanged.
- Patch 3 (v1 patch 2) now clears the counters under phy->lock with
  the error interrupts masked around the CHL_INT2 status write, drops
  the broken print gate on the cumulative counters, and replaces the
  open-coded RX error bit mask with the CHL_INT2_RX_ERR_MSK macro.
- Patch 4 (v1 patch 3) now takes a runtime PM reference for the
  deferred work, pairing with pm_runtime_put_sync() in the work, and
  uses the 16-bit LU_NOT_READY_NOTIFY_REQUIRED definition from
  scsi_sense.h instead of local ASC/ASCQ macros.

The remaining review findings are pre-existing issues, left for
separate fixes:

  - lockless SL_CONTROL read-modify-write between
    sl_notify_ssp_v3_hw() and phy_down_v3_hw() (hardirq)
  - _suspend_v3_hw() flush/interrupt-disable ordering versus late
    work queued by the threaded CQ handlers

The 50 ms wait in disable_phy_v3_hw() for the PHY to leave the up
state is a hardware requirement and is left as is.

Xingui Yang (4):
  scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
  scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
  scsi: hisi_sas: Clear PHY error counts on phyup
  scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait
    state

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 42 ++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 48 +++++++++++++++++---------
 drivers/scsi/libsas/sas_task.c         |  2 +-
 6 files changed, 84 insertions(+), 17 deletions(-)

-- 
2.43.0

