Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945CF48EBF6;
	Mon, 21 Sep 2026 12:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993312; cv=none; b=qJGmGP4Q9Zurg9VEYwPXHuUUXYW8d97MLkhncMeIpUEbXWUr1DaKRvfQcEH1iXsmPVNI4SxlI+LAXzzJrolE/twUm/NpbRffLn0wm1+Otgqv+QynFyV9AN1WhmyCGj7RV3PMj0++iZghmm1JnX2XB91e+9XXIoSTFAnA6ucovBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993312; c=relaxed/simple;
	bh=NV4qdg6H+nYZCHCMrKyGhFgQhHvTjqaLdup/kouP4Ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OJDfnRyVzBOyrOOwgSeG3B0brpTnNXxe/VZeUNtcQPA0ZqGL3fdqIY9uVfAHANVgpW1KWNrKDtHRkEjzX2+6fRuRrvF37LO4rPO0Gb53scYJWNDDr+1oahrQn4eQElZID8yvyauMGhbhtrL8hEeFj2jpCQ5fR2yAchaXqVSVIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=guCSztVJ; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="guCSztVJ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qki1kFQ6gVLwf8MQ8saLgKHA3ydWA1c2aSG7gxHdc9M=;
	b=guCSztVJm23fU6fARnnvD1L2TWkdWxoi++z8C527sOPB/twVbS7HNfZm+fxmQD66p9BMWxZqg
	SX+YioKNwHmh0dqimISu5gE4hvmNKbE2ahaHZk4sTcVAtWwe08MmEjVocNtkzXwW+nOTlc0C0Xt
	m6hqxbL8CpvTvyCjOVBBY5U=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hpMW04mdGzcb44;
	Mon, 21 Sep 2026 20:10:20 +0800 (CST)
Received: from kwepemp200006.china.huawei.com (unknown [7.202.195.217])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C08240591;
	Mon, 21 Sep 2026 20:21:41 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200006.china.huawei.com (7.202.195.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 21 Sep 2026 20:21:41 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 21 Sep 2026 20:21:40 +0800
Message-ID: <bab95bba-3091-30e5-91ba-0fd459db0101@huawei.com>
Date: Mon, 21 Sep 2026 20:21:40 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: John Garry <john.garry@linux.dev>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260918070307.381207-1-yangxingui@huawei.com>
 <9a72eeb3-ca32-4241-9e21-74cf894a9bf1@linux.dev>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <9a72eeb3-ca32-4241-9e21-74cf894a9bf1@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi, John

On 2026/9/21 19:37, John Garry wrote:
> On 9/18/26 08:03, Xingui Yang wrote:
>> When the controller resumes, sas_resume_ha() -> sas_drain_work()
>> processes the DISCE_RESUME work, which restores the ATA ports through
>> the libata error handler (ata_sas_port_resume() requests ATA_EH_RESET)
>> and waits for it in sas_ata_flush_pm_eh(). For an expander-attached
>> ATA device the hard reset in that recovery is an SMP PHY CONTROL
>> command sent to the expander:
>>
>>    ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
>>      -> lldd_I_T_nexus_reset() -> sas_phy_reset()
>>        -> sas_smp_phy_control() -> smp_execute_task_sg()
> 
> This seems like an obvious issue. How come it was not found earlier? It 
> is apparently fixing a patch which is 5 years old.

The deadlock was not reachable for most of those 5 years - it is a
regression of 3dbbbf656b85 ("scsi: libsas: Fix HA resume deadlock and
hisi_sas disk-wake race"), which restored the draining sas_resume_ha()
in hisi_sas.

0da7ca4c4fd9 was part of the same 2021 series as fbefe22811c3 ("Don't
always drain event workqueue for HA resume"), which switched hisi_sas
to the non-draining sas_resume_ha_no_sync(). The two were designed
together: without the drain, nothing in the resume path waits on the
ATA error handling, so the pm_runtime_get_sync() in
smp_execute_task_sg() could at most delay the EH until the resume
callback returned - no circular wait.

3dbbbf656b85 restored the drain to fix the disk-wake race (the
controller autosuspending while disks were still waking up), which for
the first time made the resume wait on the ATA EH - and with it the
SMP PHY CONTROL for an expander-attached ATA device. So the deadlock
window is really since 3dbbbf656b85, not since 0da7ca4c4fd9.

It is also a narrow trigger: a directly-attached ATA device resets its
phy via lldd_control_phy() (no SMP IO), so it needs an expander-
attached ATA device whose EH lands inside the drain of a runtime
resume - which is why the testing of 3dbbbf656b85, whose scenario was
the disk-wake race, did not catch it.

Given that, should Fixes: point at 3dbbbf656b85 instead? I kept
0da7ca4c4fd9 as that is where the pm_runtime_get_sync() being fixed
comes from, but the deadlock itself only exists where 3dbbbf656b85
is.

Thanks,
Xingui



