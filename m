Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7D3A7F6B;
	Fri,  9 Oct 2026 03:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516774; cv=none; b=QHPo5fVn7I/Boz4LIvJFp4DMIzm91XxP0bvXvwVghHhxNEFcug2sRoh4L5afPnPGYqRnZufIEd9K/stDReLzMMJrE6nhcCF1ywuLD9sKuvN0j8DXOXCA8DnSNL2MckplaIqhu9oTACcES8LMF+bcmvP8sF3g5V6PCJlWKYjouKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516774; c=relaxed/simple;
	bh=gSwkV4b53L40ypx3JkErNkZxQfpLr4GSByF/hmwq64c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kU6Sa9zWVIDAGvxxJAvHOmg+R5pcIiFwffq+Wla7ivPQCu+SFf6WgrQ49NILhjn5HpxZHc2gz1oDaQsD6UJt3IRKeLkim7hF4Icppo1kxuyfngCumNz+nNGt/QInPnw1752yB3KogrsmcHfycoqSmZc58tATqx377CO46w/Mgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Z8CUqN4S; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Z8CUqN4S"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NGDGLCD/chSarszJV+EI+gUhMYajjJ2Kz79no2W+6nA=;
	b=Z8CUqN4S5AU6MKIZLPFbxlRxM3Kj21mfPdqVkW9tWlhIich+3PrjCeIIQGuHvYN5MaqMMaY78
	Ve1gRKnWDR5nPzsZRFhmb+YjCjaUv3qGxI+Tqfzxxdo4RhLWnFQOVQnT/CMpLY5x1axKm6PSi0x
	261jY1OsQGJ3LJS4/zt+k0w=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j1BvC5B1YzKm4b;
	Fri,  9 Oct 2026 11:20:23 +0800 (CST)
Received: from kwepemp500007.china.huawei.com (unknown [7.202.195.151])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D73F40588;
	Fri,  9 Oct 2026 11:32:42 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500007.china.huawei.com (7.202.195.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:41 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:41 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 0/4] scsi: hisi_sas: Some misc fixes
Date: Fri, 9 Oct 2026 11:32:34 +0800
Message-ID: <20261009033238.1076098-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
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

Changes from v2:
Addresses the Sashiko AI review of v2.
- Clear all five error counter registers.
- Use pm_runtime_get_if_active().

Changes from v1:
Addresses the Sashiko AI review of v1.
- Add Patch 1, found in review of the sense parsing of patch 4.
- Clear the counters under phy->lock.
- Take a runtime PM reference for the deferred work

The remaining review findings are pre-existing issues, left for
separate fixes in the future.

Xingui Yang (4):
  scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
  scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
  scsi: hisi_sas: Clear PHY error counts on phyup
  scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait
    state

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 51 ++++++++++++++++++--------
 drivers/scsi/libsas/sas_task.c         |  2 +-
 6 files changed, 90 insertions(+), 17 deletions(-)

-- 
2.43.0

