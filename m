Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF527703;
	Thu, 16 Jul 2026 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184398; cv=none; b=aaL2oZaMEtfKRPdy2rJl0wJqGuNvNlLlnDOhgE79yMGpT2fh+zM7BjJUkodaEs3CH2LhbxKulUZ/FOAY9ejxHHUv9bpPYoAGwtFfxQy6oDHAFdv+6qS1NyLsmPm05K3e0tqMid6eTcvRG3D76elWcazUAB064e/f92dbWAyoOD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184398; c=relaxed/simple;
	bh=zlqbaRS3QmX20cv5HOrGDaPsi+NtykQhI1Ie+rzDb6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TDE3z+ptpcw+6kOYBtMSMzQVFnTyt0bPA+lrWRpfLhUeCv3Tztk3bF9iw144SwvUbcZgBQjUcfn9lphGXzPg0bwREKd2Yya87gTeosUMRkO9172ExNrW1L15MFWS/9GTxU77mJmYU3vp1C+44AAe7RXLMsRkIcLxoQ1SuNSsoVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Av4ejPlC; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Av4ejPlC"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PVxsOJdVBv1QQ6cxedrmAEtHDaUl4CvuP2XVbSvFLZU=;
	b=Av4ejPlCV/kLyTiKioYSg0ufpncegwCKRo6Bfzg23M5nDveWA5a1a/1sBwi57r15pinjjq1bx
	oX5YuLA062YYtBCPoFtCftQBergkUce5fTcrjQShCSpxzfnEmt9AhUVjAxjBPCgUD1bod1dAkiv
	FmdZsEjwyM7Ob5+Cob1pveY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h13HK2rHLz1prMN;
	Thu, 16 Jul 2026 14:37:01 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 5145140561;
	Thu, 16 Jul 2026 14:46:22 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 14:46:21 +0800
Message-ID: <309c7ded-2f18-65b2-a828-7057139a9c12@huawei.com>
Date: Thu, 16 Jul 2026 14:46:21 +0800
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
 <b1f12c52-ab0a-e146-6559-858eb5e581d6@huawei.com>
 <90dd58a1-598d-403a-a29a-266924d0f577@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <90dd58a1-598d-403a-a29a-266924d0f577@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100016.china.huawei.com (7.202.181.102) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Hi, John

On 2026/7/15 16:25, John Garry wrote:
> On 14/07/2026 13:06, yangxingui wrote:
>> There are five libsas consumers (callers of sas_register_ha): hisi_sas,
>> isci, pm8001, aic94xx, and mvsas. Only hisi_sas needs a driver-side
>> change, because it is the only driver that satisfies all three
>> conditions below simultaneously.
> 
> I am saying that other drivers use sas_resume_ha() and you are changing 
> the behavior of that function - how can you guarantee that you are not 
> causing regression for that those other drivers?

Good question. I didn't explain this in detail before. The reorder 
changes one thing for isci and pm8001 (the
only other drivers that call sas_resume_ha()): the PHYE_RESUME_TIMEOUT
handler now runs asynchronously after resume returns, instead of being
synchronized by sas_drain_work() within resume.

This does not cause a regression because I/O to timed-out phys is
already rejected before reaching hardware, regardless of ordering.
During suspend, sas_suspend_devices() calls sas_notify_lldd_dev_gone()
for each device, which sets dev->lldd_dev to NULL. So when
scsi_unblock_requests re-enables I/O in resume:
- isci: isci_lookup_device() returns NULL (lldd_dev is NULL) →
isci_task_refuse(SAS_DEVICE_UNKNOWN) → mapped to DID_BAD_TARGET
- pm8001: DEV_IS_GONE(pm8001_dev) is true (lldd_dev is NULL) →
returns SAS_PHY_DOWN → mapped to DID_NO_CONNECT
Both complete directly via scsi_done() — I/O never reaches hardware,
and this is identical in the old and new ordering since lldd_dev_gone
runs during suspend, before resume even begins.

For healthy phys that did resume in time, I/O proceeds normally in
both orderings — the earlier unblock just lets it start sooner.
aic94xx and mvsas don't register any PM ops, so they never call
sas_resume_ha() and are unaffected.

I'll include this analysis in the v3 commit message.

Thanks,
Xingui

