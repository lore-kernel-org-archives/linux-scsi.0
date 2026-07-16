Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D64A414A2F;
	Thu, 16 Jul 2026 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784202531; cv=none; b=KS7k0ZaI8XesH+kL6mlPtAbGRfbWDRTZTnpu2CWx4WAOnPjVR4NClyaERZbxnXd9k/navXRyUCysQIWSSAMvRq0Lx9Vy/xDIG8RbnX7BirEVKQ+ZzFbl4lwgt62Hx9GFGgwXMVunCDVeNVgEe7xI3rRZcD/eomZasP2/wH4Rgz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784202531; c=relaxed/simple;
	bh=dRMI3KG6vZjd/rRXojyvLSrbOfzaJ/d/wWqhV9mS7KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d4qkO8p+IArMgJCRXL6qYhnHrUf2JFtZsAhZMg1gBYSTqlYm3VR1O+t+2SB7wegYZXqtT0x75ZeWQxiBK1x5aG3Z2ATaBETue+H+Z6Eznot5g+J3g7+ocSfVUiu7gIKjYwlW7FQNshQumG1IOzjqAaf4e+BIxOtIzOpDNV3MM+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=k4Y9aYTF; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="k4Y9aYTF"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Nvkuj/SNJ9dyqx1xoXyiVRzPzsYee/dKFjcFegZyqjo=;
	b=k4Y9aYTFFyrbvyNpuaQwLLEUrBljUGHa6IrZeUF77L24uQ7JADYq5njgxU48cBGIUhXa59hVT
	2ENzKorXHrkkWvYRfFyjkATAz9wG8Y3zZ8ROMQ9wMCtcp/3CecjJLL0Vh/NTzuhEggMMuIB7jIw
	HVY0kzS3RJa5rOdGh+WuadU=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h1B0G0VKpz1T4Hh;
	Thu, 16 Jul 2026 19:39:26 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 4449F40561;
	Thu, 16 Jul 2026 19:48:38 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 19:48:37 +0800
Message-ID: <1c228b61-4aa5-bbec-2590-ed15d81e45e5@huawei.com>
Date: Thu, 16 Jul 2026 19:48:37 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260716081145.3950172-1-yangxingui@huawei.com>
 <160b8fcb-6020-4a97-a23c-3515bfa39e43@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <160b8fcb-6020-4a97-a23c-3515bfa39e43@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100007.china.huawei.com (7.202.181.92) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/7/16 19:02, John Garry wrote:
> On 16/07/2026 09:11, Xingui Yang wrote:
>> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
>> for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock:
>> the PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
>> sas_deform_port() -> sas_destruct_devices(), which removes SCSI 
>> devices and
>> waits for the host to become runtime-active. But the host cannot resume
>> until sas_resume_ha() -> sas_drain_work() returns, and the drain is 
>> blocked
>> on that very handler.
>>
>> However skipping the drain reintroduces a race: hisi_sas returns from
>> resume before all PHY UP work and libsas discovery work finish. The
>> controller may then autosuspend while disks are still waking up. The 
>> disks
>> issue IO to a suspended controller, the IO fails, and the disks get
>> disabled.
>>
>> Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
>> notification to after sas_drain_work(). By then the host resume is 
>> about to
>> complete, so device removal through device_link no longer blocks on the
>> resume and the cycle is broken.
>>
>> With the deadlock gone, restore sas_resume_ha() (the draining variant) in
>> hisi_sas and remove sas_resume_ha_no_sync().
>>
>> The reorder is safe for the other libsas consumers (isci, pm8001, 
>> aic94xx,
>> mvsas). During suspend, sas_suspend_devices() calls
>> sas_notify_lldd_dev_gone() for each device, which sets dev->lldd_dev to
>> NULL. When scsi_unblock_requests re-enables I/O in resume, any I/O to a
>> timed-out phy's disk is immediately rejected by the LLDD before reaching
>> hardware: isci returns SAS_DEVICE_UNKNOWN (mapped to DID_BAD_TARGET), and
>> pm8001 returns SAS_PHY_DOWN (mapped to DID_NO_CONNECT). Both complete
>> directly via scsi_done() without entering SCSI EH. This is identical in
>> both the old and new ordering since lldd_dev_gone runs during suspend,
>> before resume. The reorder only affects when the PHYE_RESUME_TIMEOUT
>> handler runs (synchronized by sas_drain_work() vs. asynchronous after
>> resume returns), not whether I/O can reach the device. aic94xx and mvsas
>> do not register any PM ops and never reach this code path.
>>
>> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event 
>> workqueue for HA resume")
>> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
> 
> Can this possibly be tested on another SCSI HBA which uses libsas? And 
> using SATA disks.

Hi John,
Unfortunately I don't have access to isci or pm8001 hardware for 
testing. ^-^

If anyone on the list has such hardware and could help verify, that 
would be much appreciated.

On our side, we don't see phy-up timeouts during resume in normal
operation. The timeout scenario only occurs when a disk fails to
re-establish its link within the 25s window. To reproduce this reliably,
we simulate it by manually removing the disk during suspend — the phy 
never comes back, times out, and the PHYE_RESUME_TIMEOUT handler removes 
the device.

With this patch applied, the timeout path works correctly: no deadlock,
no spurious I/O to the removed disk, and the controller resumes normally.

Remove the sata disk under phy0 during suspend with hisi_sas, Logs as 
follow:
[ 2014.255164] hisi_sas_v3_hw 0000:32:04.0: resuming from operating 
state [D0]
[ 2016.320559] hisi_sas_v3_hw 0000:32:04.0: neither _PS0 nor _PR0 is defined
[ 2016.328062] hisi_sas_v3_hw 0000:32:04.0: waiting up to 25 seconds for 
8 phys to resume
[ 2016.328733] hisi_sas_v3_hw 0000:32:04.0: phyup: phy1 link_rate=10(sata)
[ 2016.343960] hisi_sas_v3_hw 0000:32:04.0: phyup: phy6 link_rate=10(sata)
[ 2016.344123] hisi_sas_v3_hw 0000:32:04.0: dev[38:5] direct-attached 
phy1 found
[ 2016.351259] hisi_sas_v3_hw 0000:32:04.0: phyup: phy7 link_rate=10(sata)
[ 2016.366450] hisi_sas_v3_hw 0000:32:04.0: dev[39:5] direct-attached 
phy6 found
[ 2016.366540] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2016.374284] hisi_sas_v3_hw 0000:32:04.0: dev[40:5] direct-attached 
phy7 found
[ 2016.380955] sas: ata9: end_device-6:0: dev error handler
[ 2016.381113] sas: ata10: end_device-6:1: dev error handler
[ 2016.381122] sas: ata11: end_device-6:2: dev error handler
[ 2016.381124] sas: ata12: end_device-6:7: dev error handler
[ 2016.394114] hisi_sas_v3_hw 0000:32:04.0: phydown: phy1 phy_state=0xc0
[ 2016.401238] hisi_sas_v3_hw 0000:32:04.0: ignore flutter phy1 down
[ 2016.450253] hisi_sas_v3_hw 0000:32:04.0: phyup: phy4 link_rate=11
[ 2016.457034] hisi_sas_v3_hw 0000:32:04.0: phyup: phy3 link_rate=11
[ 2016.463810] hisi_sas_v3_hw 0000:32:04.0: phyup: phy5 link_rate=11
[ 2016.470589] hisi_sas_v3_hw 0000:32:04.0: phyup: phy2 link_rate=11
[ 2016.472496] hisi_sas_v3_hw 0000:32:04.0: dev[41:1] direct-attached 
phy4 found
[ 2016.485197] hisi_sas_v3_hw 0000:32:04.0: dev[42:1] direct-attached 
phy3 found
[ 2016.496497] hisi_sas_v3_hw 0000:32:04.0: dev[43:1] direct-attached 
phy5 found
[ 2016.508342] hisi_sas_v3_hw 0000:32:04.0: dev[44:1] direct-attached 
phy2 found
[ 2016.602597] hisi_sas_v3_hw 0000:32:04.0: phyup: phy1 link_rate=10(sata)
[ 2016.768496] ata9.00: Entering active power mode
[ 2016.790465] ata9.00: configured for UDMA/133
[ 2016.795589] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2016.805949] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2016.812484] sas: ata9: end_device-6:0: dev error handler
[ 2016.812495] sas: ata10: end_device-6:1: dev error handler
[ 2016.812642] sas: ata11: end_device-6:2: dev error handler
[ 2016.812651] sas: ata12: end_device-6:7: dev error handler
[ 2016.817882] hisi_sas_v3_hw 0000:32:04.0: phydown: phy6 phy_state=0xbe
[ 2016.825006] hisi_sas_v3_hw 0000:32:04.0: ignore flutter phy6 down
[ 2017.025190] hisi_sas_v3_hw 0000:32:04.0: phyup: phy6 link_rate=10(sata)
[ 2017.192499] ata10.00: Entering active power mode
[ 2017.199314] ata10.00: configured for UDMA/133
[ 2017.204526] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2017.214886] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2017.221567] sas: ata9: end_device-6:0: dev error handler
[ 2017.221578] sas: ata10: end_device-6:1: dev error handler
[ 2017.221581] sas: ata11: end_device-6:2: dev error handler
[ 2017.221723] sas: ata12: end_device-6:7: dev error handler
[ 2017.227881] hisi_sas_v3_hw 0000:32:04.0: phydown: phy7 phy_state=0x7e
[ 2017.235006] hisi_sas_v3_hw 0000:32:04.0: ignore flutter phy7 down
[ 2017.433352] hisi_sas_v3_hw 0000:32:04.0: phyup: phy7 link_rate=10(sata)
[ 2017.600495] ata11.00: Entering active power mode
[ 2017.606721] ata11.00: configured for UDMA/133
[ 2017.611924] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2042.212434]  phy-6:0: resume timeout
[ 2042.212508] sas: sas_form_port: phy1 belongs to port0 already(1)!
[ 2042.216704] hisi_sas_v3_hw 0000:32:04.0: end of resuming controller
[ 2042.223481] sas: sas_form_port: phy6 belongs to port1 already(1)!
[ 2042.223484] sas: sas_form_port: phy7 belongs to port2 already(1)!
[ 2042.230436] hisi_sas_v3_hw 0000:32:04.0: FLR prepare
[ 2042.237860] sd 6:0:7:0: [sdj] Starting disk
[ 2046.460557] hisi_sas_v3_hw 0000:32:04.0: neither _PS0 nor _PR0 is defined
[ 2046.468806] hisi_sas_v3_hw 0000:32:04.0: phyup: phy1 link_rate=10(sata)
[ 2046.476114] hisi_sas_v3_hw 0000:32:04.0: phyup: phy6 link_rate=10(sata)
[ 2046.483413] hisi_sas_v3_hw 0000:32:04.0: phyup: phy7 link_rate=10(sata)
[ 2046.577033] hisi_sas_v3_hw 0000:32:04.0: phyup: phy3 link_rate=11
[ 2046.589979] hisi_sas_v3_hw 0000:32:04.0: phyup: phy4 link_rate=11
[ 2046.596766] hisi_sas_v3_hw 0000:32:04.0: phyup: phy5 link_rate=11
[ 2046.603548] hisi_sas_v3_hw 0000:32:04.0: phyup: phy2 link_rate=11
[ 2046.644064] hisi_sas_v3_hw 0000:32:04.0: FLR done
[ 2046.644205] sd 6:0:7:0: [sdj] Start/Stop Unit failed: Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 2046.659804] sd 6:0:7:0: [sdj] Start/Stop Unit failed: Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 2046.670154] sd 6:0:7:0: [sdj] Start/Stop Unit failed: Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 2046.680495] sd 6:0:7:0: [sdj] Start/Stop Unit failed: Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 2046.727158] sas: sas_form_port: phy1 belongs to port0 already(1)!
[ 2046.733945] sas: sas_form_port: phy6 belongs to port1 already(1)!
[ 2046.740725] sas: sas_form_port: phy7 belongs to port2 already(1)!
[ 2046.747504] sas: sas_form_port: phy3 belongs to port3 already(1)!
[ 2046.754284] sas: sas_form_port: phy4 belongs to port5 already(1)!
[ 2046.761064] sas: sas_form_port: phy5 belongs to port4 already(1)!
[ 2046.767845] sas: sas_form_port: phy2 belongs to port6 already(1)!
[ 2047.420415] hisi_sas_v3_hw 0000:32:04.0: entering suspend state
[ 2048.327932] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2048.334616] sas: ata9: end_device-6:0: dev error handler
[ 2048.334624] ata9.00: Entering standby power mode
[ 2048.334724] sas: ata10: end_device-6:1: dev error handler
[ 2048.334878] sas: ata11: end_device-6:2: dev error handler
[ 2048.339936] sas: lldd_execute_task returned: -22
[ 2048.339941] ata9.00: STANDBY IMMEDIATE failed (err_mask=0x40)
[ 2048.346528] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2048.356740] hisi_sas_v3_hw 0000:32:04.0: dev[38:5] direct-attached 
phy1 is gone
[ 2048.364898] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2048.371587] sas: ata9: end_device-6:0: dev error handler
[ 2048.371598] sas: ata10: end_device-6:1: dev error handler
[ 2048.371602] ata10.00: Entering standby power mode
[ 2048.371742] sas: ata11: end_device-6:2: dev error handler
[ 2048.377001] sas: lldd_execute_task returned: -22
[ 2048.377007] ata10.00: STANDBY IMMEDIATE failed (err_mask=0x40)
[ 2048.383679] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2048.393891] hisi_sas_v3_hw 0000:32:04.0: dev[39:5] direct-attached 
phy6 is gone
[ 2048.402048] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2048.408738] sas: ata9: end_device-6:0: dev error handler
[ 2048.408748] sas: ata10: end_device-6:1: dev error handler
[ 2048.408751] sas: ata11: end_device-6:2: dev error handler
[ 2048.408756] ata11.00: Entering standby power mode
[ 2048.414150] sas: lldd_execute_task returned: -22
[ 2048.414157] ata11.00: STANDBY IMMEDIATE failed (err_mask=0x40)
[ 2048.420828] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 2048.430891] hisi_sas_v3_hw 0000:32:04.0: dev[40:5] direct-attached 
phy7 is gone
[ 2048.438893] hisi_sas_v3_hw 0000:32:04.0: dev[42:1] direct-attached 
phy3 is gone
[ 2048.446893] hisi_sas_v3_hw 0000:32:04.0: dev[43:1] direct-attached 
phy5 is gone
[ 2048.454891] hisi_sas_v3_hw 0000:32:04.0: dev[41:1] direct-attached 
phy4 is gone
[ 2048.462885] hisi_sas_v3_hw 0000:32:04.0: dev[44:1] direct-attached 
phy2 is gone
[ 2048.470956] hisi_sas_v3_hw 0000:32:04.0: end of suspending controller

Thanks,
Xingui
.
