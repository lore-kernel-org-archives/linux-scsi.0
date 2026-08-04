Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE643368BF;
	Tue,  4 Aug 2026 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835828; cv=none; b=XR82CSiDNw5pROKzsS92ePjJux04zztUM+XY99a07/s1JINOEu7uVgPP7zjg8Qf9+9ZxEA3bTA5bA8/J0HlOto+Ks0DM7mZN/doYa/Ze1wz5e4D7MSe4055CTZs/nVBJSyYFsfErUdZ9zHMbT/9wp1KvfRgpjolvs7SWawJSmw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835828; c=relaxed/simple;
	bh=akRk/5pny04vkRlrfX6HMHoih595bIl1rthGSuyplTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YZAWxCZbN5h+jTYHnFw6seq6eu2N+duirYCRYe+R5gs62HF5p1iwln+ebN9TOyBCuzZr3u35yTObcm8nsMJ1Z/FuxhUMqX9RlQhfxrfYg7twtMG8r+spcw+AaS9i5vlqeIX3KqJdtm1P5nuH18JsN1qeHWJlwfDc964LLeeRri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jLabr0O5; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jLabr0O5"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GozzaqgeAEsUCAtP3RjHcv6kLBS5aPKfrn+RLSoHpso=;
	b=jLabr0O5eq2iZElb3/VgDhDEpivBLho40ZLNZ56huo15s13m9/beIclHP8571Ndg1zi+W29xJ
	s9q3IKsrOxvFDj9H4T1bAt9CoHwXce2DipmU3eXh5AgaiWa7g173eXLqPYz4caU4rTzw5SHrGEd
	059zDE1xA6/wHCjlcHtZ414=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hDp1R59ktz1prQc;
	Tue,  4 Aug 2026 17:20:43 +0800 (CST)
Received: from kwepemp100005.china.huawei.com (unknown [7.202.195.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 62CD14058C;
	Tue,  4 Aug 2026 17:30:16 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100005.china.huawei.com (7.202.195.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 17:30:16 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 17:30:15 +0800
Message-ID: <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
Date: Tue, 4 Aug 2026 17:30:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS
 devices
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100018.china.huawei.com (7.202.181.105) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi John

On 2026/8/4 15:35, John Garry wrote:
> On 03/08/2026 03:05, Xingui Yang wrote:
>> When a SAS device is in the Active_Wait or Idle_Wait power state, it
>> returns NOT_READY with ASC/ASCQ = 0x04/0x11 (notify (enable spinup)
>> required), indicating that a NOTIFY(ENABLE SPINUP) primitive is needed to
>> trigger media spinup.
>>
>> Without handling this condition, the SCSI mid-layer will indefinitely 
>> retry
>> the command with ACTION_DELAYED_RETRY, resulting in the disk never 
>> spinning
>> up and becoming unusable. A typical manifestation is:
>>
>>    sd 4:0:9:0: [sde] Spinning up disk...
>>    ...not responding...
>>    sd 4:0:9:0: [sde] Sense Key : Not Ready
>>    sd 4:0:9:0: [sde] Add. Sense: Logical unit not ready, notify 
>> (enable spinup) required
>>
>> To resolve this, the SAS controller needs to send a NOTIFY(ENABLE SPINUP)
>> primitive to the target phy, which transitions the device out of the
>> waiting state and allows normal spinup to proceed.
>>
> 
> How would other SAS HBAs which use libsas handle this scenario? Since 
> they have FW, would the FW automatically issue this NOTIFY(ENABLE SPINUP)?
> 
> I just wonder why hisi_sas seems to be only driver which would need this.

Thanks for the question. This affects only SAS HDDs. I checked pm8001, 
isci, and aic94xx — all handle NOTIFY(ENABLE SPINUP) at the driver level:

- pm8001: sends once at phy-up, then mdelay(200) — comment: "delay a 
moment to wait disk to spinup" — before notifying libsas.

- isci: enables hardware periodic insertion during link idle (ENABLE bit 
in notify_enable_spinup_control), cleared at phy stop.

- aic94xx: enables microcode periodic insertion during link idle 
(NOTIFY_TIMER_TIMEOUT = 500ms interval), stops at phy down.

hisi_sas also calls sl_notify_ssp() at phy-up, but the NOTIFY_EN bit is 
held for only 1ms — msleep(1) between setting and clearing — before 
immediately notifying libsas.

The root cause appears to be that 1ms is insufficient compared to 
pm8001's 200ms. An alternative to hisi_sas would be to simply increase 
the hold time in sl_notify_ssp() to match pm8001's approach, keeping the 
fix within hisi_sas.

Would you prefer this simpler approach, or do you still see value in the 
libsas-level sense detection and callback from hisi_sas? ^-^


Thanks,
Xingui Yang
