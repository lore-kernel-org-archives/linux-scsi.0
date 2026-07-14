Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE0379EC6;
	Tue, 14 Jul 2026 12:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030797; cv=none; b=qCd6UAEDIEatIXZyZZ5cXI4bKwpAmPTpuliYs0V+Pyqpy5EeRINR6x+tCMx0mkf+00eIhnn/7D9Yoc/q4x4K9hOE7AAS2RRRNBDWbAsBvcSNuXEohQhip143Z4BcdHXFquY4ZXTq/+kwiYi2itcA2aIPNvDI9iZUrfS/wnAWhXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030797; c=relaxed/simple;
	bh=wkel+evs/SgcWftRGm27ZJ4iA6wpkMZEHm69qZdpScA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UgCY/Jrvwck8YMs8vTS45uzGTZ0CPvsDoYp8aIhsNj3aOQekJ0xcnKUZwIy2rW35L2GPpee1AKw0EoqxCqIGDuiuYv5ieiD9b9T+Ra6ZvtF02I2uHBFTilfvJbZxLd3MWRDLXtdYzQYzy2M9BNyKYKERdmXo3y4YE0Q7xdarnoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=owSHDvwg; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="owSHDvwg"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WXP85WQHWsQejbjPPXzCupI9FhvK4bOYd2miLF+MpCQ=;
	b=owSHDvwgA+YeyoC/erOUlZNS8HLBE9MBEJMX1qU6qR/YH3jMFhr4gKIiT8zehTKJ79kunl/RU
	5MBq2vAkhrH85B+STSDwQ+JeZagCdKpZ4tujChwnk8qDhemf2dfX1Z4TI3qzkPDvMhC7jqzIoYH
	d3Foa1f/Ox2qgn+tGaUHEwA=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gzyTh6qgSz1cyVy;
	Tue, 14 Jul 2026 19:57:12 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 541B340565;
	Tue, 14 Jul 2026 20:06:29 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 14 Jul 2026 20:06:28 +0800
Message-ID: <b1f12c52-ab0a-e146-6559-858eb5e581d6@huawei.com>
Date: Tue, 14 Jul 2026 20:06:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260702033211.1743313-1-yangxingui@huawei.com>
 <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
 <56d1c5d9-cb3f-4bef-a099-304ef0c49837@oracle.com>
 <e91cdddb-2323-904f-dc63-3d00597b5c8f@huawei.com>
 <de319ce0-ca42-46cf-87ea-98c93c73bc8e@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <de319ce0-ca42-46cf-87ea-98c93c73bc8e@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500018.china.huawei.com (7.202.181.152) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Hi, John

On 2026/7/14 16:26, John Garry wrote:
> On 14/07/2026 03:15, yangxingui wrote:
>>>>> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event 
>>>>> workqueue for HA resume")
>>>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>>
>>> Any idea why this problem has only been discovered after 5 years 
>>> (from fbefe22811c3140 being merged)?
>>>
>>> Is there some new test case?
> 
> ok, I can check below. But another question is if this applies to only 
> hisi_sas driver? I mean, you are changing libsas and the hisi_sas, but 
> not other libsas-based drivers - why? They support suspend/resume.

There are five libsas consumers (callers of sas_register_ha): hisi_sas,
isci, pm8001, aic94xx, and mvsas. Only hisi_sas needs a driver-side 
change, because it is the only driver that satisfies all three
conditions below simultaneously.

1. Only hisi_sas used sas_resume_ha_no_sync().
isci/init.c:               sas_resume_ha(&ihost->sas_ha);
pm8001/pm8001_init.c:      sas_resume_ha(sha);
hisi_sas/hisi_sas_v3_hw.c: sas_resume_ha_no_sync(sha);  ← only caller
isci and pm8001 have always used the draining variant. aic94xx and
mvsas do not register any PM ops — their pci_driver structs have no
.driver.pm field — so they never enter the resume path.

2. Only hisi_sas establishes a device_link between SCSI devices and
the HBA. Commit 16fd4a7c5917 added device_link_add() in
hisi_sas_v3_hw.c to keep the HBA active while associated SCSI devices
are active. A side effect of this device_link is that
scsi_remove_device() in the PHYE_RESUME_TIMEOUT handler waits for the
HBA to be runtime-active — the direct cause of the original deadlock.
None of the other four drivers uses device_link_add() for PM sync, so
their sas_destruct_devices() path never blocks on host resume.
Original deadlock as follow:
[ 1335.875252] Call trace:
[ 1335.878380]  __switch_to+0x150/0x238
[ 1335.882646]  __schedule+0x388/0x880
[ 1335.886825]  schedule+0x58/0x130
[ 1335.890744]  rpm_resume+0x1e4/0x940
[ 1335.894926]  __pm_runtime_resume+0x68/0x130
[ 1335.899805]  rpm_get_suppliers+0x4c/0x158
[ 1335.904506]  __rpm_callback+0x190/0x248
[ 1335.909034]  rpm_callback+0x40/0x88
[ 1335.913215]  rpm_resume+0x6a8/0x940
[ 1335.917396]  __pm_runtime_resume+0x68/0x130
[ 1335.922271]  device_release_driver_internal+0xd4/0x238
[ 1335.928104]  device_release_driver+0x20/0x38
[ 1335.933065]  bus_remove_device+0xd8/0x158
[ 1335.937768]  device_del+0x168/0x3e0
[ 1335.941944]  __scsi_remove_device+0x120/0x198
[ 1335.946988]  __scsi_remove_target+0xe8/0x1c0
[ 1335.951943]  scsi_remove_target+0x120/0x228
[ 1335.956812]  sas_rphy_remove+0x8c/0x98 [scsi_transport_sas]
[ 1335.963075]  sas_rphy_delete+0x20/0x40 [scsi_transport_sas]
[ 1335.969336]  sas_destruct_devices+0x74/0xb8 [libsas]
[ 1335.974992]  sas_deform_port+0x218/0x270 [libsas]
[ 1335.980387]  sas_phye_resume_timeout+0x2c/0x60 [libsas]
[ 1335.986303]  sas_phy_event_worker+0x38/0x68 [libsas]
[ 1335.991961]  process_one_work+0x174/0x3e0
[ 1335.996656]  worker_thread+0x22c/0x3b0
[ 1336.001091]  kthread+0xec/0x100
[ 1336.004919]  ret_from_fork+0x10/0x20

3. Only hisi_sas supports runtime PM (autosuspend). This is
consistent with your own statement in fbefe22811c3140: "Other drivers
which use libsas don't worry about this as none support runtime
suspend."

Without runtime PM, the controller never autosuspends during disk
wake-up, so the race this patch addresses cannot occur.

Thanks,
Xingui
