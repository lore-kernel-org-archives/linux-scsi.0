Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4A29D26E;
	Thu, 27 Nov 2025 07:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764228448; cv=none; b=Jtwq7jEv3T2UmPibFJRBegD2Dt2FlWJUDGrKfXar+0GI69Fqqc37QSIHfAjwIw+R01KR46cA3oE/NvdHRCn2WPgnB80UBsH841NpMG6BCrsq6y0nzGca0m5wHsFzhJhcqL0FEY/NRNaZR0sxtKHoHSxUU6XxSGDge4s0JWkAJSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764228448; c=relaxed/simple;
	bh=yOGBVxPSqfb1y6n5vvt9jVlcDyA5CDGtNqeoZ2JQa/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MmWr6yuznGg4R0i8X0EW/uenwprBm1IweXC5/S1U6il0UgrAx12Nzw3QhsX9Jccva07c2L0d1dX6vJjdIfb/FzNhB0NkGWUnNYuOGTX3KpeFSdTosEVvpB0i68+kxDi297OhZEtcWlWX3adIowXbjyKhn9BFrvKChy3O1iyawAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=dEg0vkB7; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="dEg0vkB7"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vv4pSca5qbf47ZFpsvQb1BbeJPmedmasjkXoCk7Y7zU=;
	b=dEg0vkB70VKfHO6S/Ok/Mh73tTKAuyCeTiTZ8wMpbR/fw5YUEHuYVwmYvaGYD23fT1FGOS8e8
	RjQloG5Mh0xxLtxCcykccCySqj1yqdwEmyEfdX2EVQCqqR8HL4AmK/yG/Vl5hj3Ol/gW5uyOnYC
	vjyus0tVcuBJSW/QXhSKPbQ=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dH7Hv2W7zzLlXj;
	Thu, 27 Nov 2025 15:25:31 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E6C5140276;
	Thu, 27 Nov 2025 15:27:19 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 15:27:18 +0800
Message-ID: <8911e1d8-98d3-9c1d-1329-c9dd78cda45e@huawei.com>
Date: Thu, 27 Nov 2025 15:27:18 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20251021073438.3441934-1-yangxingui@huawei.com>
 <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
 <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500009.china.huawei.com (7.202.181.140) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Hi, John

I'm glad to receive your reply.

On 2025/11/27 14:47, John Garry wrote:
> On 27/11/2025 00:59, yangxingui wrote:
>> Kindly ping for upstream.
>>
>> On 2025/10/21 15:34, Xingui Yang wrote:
> 
> Your reasons for revert is light on details.
> 
>>> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
>>>
>>> As the disk may fall into an abnormal loop of probe when it fails to 
>>> probe
>>> due to physical reasons and cannot be repaired.
> 
> So for a faulty disk we get into a indefinite loop, right?
Yes, because a hard reset for SATA disk is executed during the error 
handler, a BC event will be received after the disk probe fails, and the 
probe will be re-executed on the disk.
> 
> What about case where this was helping before?
A temporary fault injected into the disk or link, which can be recovered 
after a short time.

log before:
[49495.065650] sas: broadcast received: 0
[49495.065661] sas: REVALIDATING DOMAIN on port 0, pid:318259
[49495.066190] sas: Expander phy change count has changed
[49495.068368] sas: ex 500e004aaaaaaa1f phy2 originated BROADCAST(CHANGE)
[49495.068369] sas: ex 500e004aaaaaaa1f phy2 new device attached
[49495.068434] sas: ex 500e004aaaaaaa1f phy02:U:9 attached: 
500e004aaaaaaa02 (stp)
[49495.090453] hisi_sas_v3_hw 0000:b4:02.0: dev[698:5] found
[49495.266248] sas: done REVALIDATING DOMAIN on port 0, pid:318259, res 0x0
[49495.271115] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[49495.271129] sas: ata761: end_device-6:3:0: dev error handler
[49495.271133] sas: ata762: end_device-6:3:1: dev error handler
[49495.271136] sas: ata764: end_device-6:3:3: dev error handler
[49495.271170] sas: ata765: end_device-6:3:4: dev error handler
[49495.271171] sas: ata768: end_device-6:3:5: dev error handler
[49495.271173] sas: ata769: end_device-6:3:2: dev error handler
[49497.465030] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4081 task=0000000054417d4d dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0ff1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49497.503517] sas: sas_to_ata_err: Saw error 135. What to do?
[49497.503518] sas: sas_ata_task_done: SAS error 87
[49497.503546] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4082 task=00000000972479c8 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x203 0x2ba0ff2 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[49497.542451] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[49502.713074] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4005 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fa5 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49502.752805] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49502.767384] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4006 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fa6 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49502.807336] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49502.821449] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4007 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fa7 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49502.861361] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49502.875664] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[49502.898556] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[49502.912015] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[49505.112967] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4010 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x203 0x2ba0faa 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[49505.153594] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[49510.137044] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4027 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fbb 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49510.178227] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49510.193284] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4028 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fbc 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49510.234190] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49510.248603] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4029 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fbd 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49510.288968] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49510.303156] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[49510.325863] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[49510.339230] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[49512.536979] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4032 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x203 0x2ba0fc0 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[49512.577050] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[49517.561046] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4050 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fd2 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49517.601923] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49517.616945] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4051 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fd3 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49517.657745] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49517.672097] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4052 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
CQ hdr: 0x101b 0x2ba0fd4 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[49517.712567] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[49517.726756] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[49517.749459] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[49517.762828] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[49519.960965] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[49519.971018] sas: sas_probe_sata: for exp-attached device 
500e004aaaaaaa02 returned -19
[49519.971039] hisi_sas_v3_hw 0000:b4:02.0: dev[698:5] is gone
[49519.984864] sas: broadcast received: 0
[49519.984876] sas: REVALIDATING DOMAIN on port 0, pid:318259
[49519.985362] sas: Expander phy change count has changed
[49519.987278] sas: ex 500e004aaaaaaa1f phy2 originated BROADCAST(CHANGE)
[49519.987442] sas: ex 500e004aaaaaaa1f phy02:U:A attached: 
500e004aaaaaaa02 (stp)
[49519.987443] sas: ex 500e004aaaaaaa1f phy 0x2 broadcast flutter
[49519.987448] sas: done REVALIDATING DOMAIN on port 0, pid:318259, res 0x0

log new after apply the patch:

[70734.380100] sas: broadcast received: 0
[70734.380110] sas: REVALIDATING DOMAIN on port 0, pid:311546
[70734.380431] sas: Expander phy change count has changed
[70734.382191] sas: ex 500e004aaaaaaa1f phy0 originated BROADCAST(CHANGE)
[70734.382193] sas: ex 500e004aaaaaaa1f phy0 new device attached
[70734.382262] sas: ex 500e004aaaaaaa1f phy00:U:9 attached: 
500e004aaaaaaa00 (stp)
[70734.402596] hisi_sas_v3_hw 0000:b4:02.0: dev[18:5] found
[70734.574064] sas: done REVALIDATING DOMAIN on port 0, pid:311546, res 0x0
[70734.580049] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[70734.580064] sas: ata370: end_device-7:0:4: dev error handler
[70734.580066] sas: ata371: end_device-7:0:5: dev error handler
[70734.580071] sas: ata373: end_device-7:0:1: dev error handler
[70734.580075] sas: ata374: end_device-7:0:2: dev error handler
[70734.580076] sas: ata375: end_device-7:0:3: dev error handler
[70734.580077] sas: ata376: end_device-7:0:0: dev error handler
[70736.776755] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4013 task=00000000113fa417 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fad 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70736.813168] sas: sas_to_ata_err: Saw error 135. What to do?
[70736.813169] sas: sas_ata_task_done: SAS error 87
[70736.813201] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4014 task=0000000037bc53e5 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x203 0x120fae 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[70736.850261] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[70741.992742] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4032 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fc0 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70742.030820] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70742.044539] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4033 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fc1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70742.083611] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70742.097548] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4034 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fc2 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70742.137553] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70742.151829] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[70742.174491] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[70742.187938] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[70744.392769] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4037 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x203 0x120fc5 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[70744.433129] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[70749.416741] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4055 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fd7 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70749.457819] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70749.472339] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4056 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fd8 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70749.513046] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70749.527425] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4057 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fd9 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70749.567887] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70749.582146] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[70749.604974] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[70749.618406] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[70751.816753] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4061 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x203 0x120fdd 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
[70751.856789] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[70756.840742] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4079 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120fef 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70756.881620] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70756.896277] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4080 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120ff0 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70756.937020] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70756.951407] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
iptt=4081 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
hdr: 0x101b 0x120ff1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
[70756.991856] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
[70757.006124] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
internal task failed!
[70757.029005] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
[70757.042455] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
failed (-5)
[70759.240774] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[70759.250828] sas: sas_probe_sata: for exp-attached device 
500e004aaaaaaa00 returned -19
[70759.250845] hisi_sas_v3_hw 0000:b4:02.0: dev[18:5] is gone
[70759.264497] sas: broadcast received: 0
[70759.280050] sas: REVALIDATING DOMAIN on port 0, pid:311546
[70759.280189] sas: Expander phy change count has changed
[70759.281879] sas: ex 500e004aaaaaaa1f phy0 originated BROADCAST(CHANGE)
[70759.281880] sas: ex 500e004aaaaaaa1f phy0 new device attached
[70759.281940] sas: ex 500e004aaaaaaa1f phy00:U:A attached: 
500e004aaaaaaa00 (stp)
[70759.305377] hisi_sas_v3_hw 0000:b4:02.0: dev[19:5] found
[70759.478056] sas: done REVALIDATING DOMAIN on port 0, pid:311546, res 0x0
[70759.487508] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[70759.487522] sas: ata370: end_device-7:0:4: dev error handler
[70759.487527] sas: ata371: end_device-7:0:5: dev error handler
[70759.487530] sas: ata373: end_device-7:0:1: dev error handler
[70759.487539] sas: ata374: end_device-7:0:2: dev error handler
[70759.487544] sas: ata375: end_device-7:0:3: dev error handler
[70759.487572] sas: ata377: end_device-7:0:0: dev error handler
[70761.674270] ata377.00: ATA-11: SAMSUNG MZ7KH960HAJR-00005, HXM7404Q, 
max UDMA/133
[70761.696856] ata377.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth 
32), AA
[70761.713233] ata377.00: configured for UDMA/133
[70761.725238] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1

Thanks,
Xingui
