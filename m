Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD15386578
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 06:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885671; cv=none; b=cGfribUkCjRwUDHFs0M1+SgKQiXXGAtzu0hEZeRqx5l0L20XXlGJOCoeXP+01Um3Hms9bB6TNWNRa+wjPX2/sONMIcn4RnOZCieeirvH5a1BTqx7ct4U9ApxNgu1uoBLUrSSkF8+gi0oqK2/nVG9/E7ZjciHNFZkM3XT59gnWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885671; c=relaxed/simple;
	bh=r3UDwEgOhwM2bBsO/fli8LbjE7GZ5k/2WDNbWccDDVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dNk9uVagVRj3/L7PH1Pl2LGKKZFuz9dx56sFvewv14QvZmU1B2RK3+U/aFeDz2ZAeKYADtlSBHT1fZy5/5peuaJxBeykw2FbjcbPl2EN0+LRoghLB37K25vaLzUEvL08iZt5fEqhpLOaFQa/bdZkmDRdikgjCRSozpB+PFV5Oas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jFtqzbnb; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jFtqzbnb"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CEf4/dWU3l7aWEd2QzQ+l/CkHhWv28HslDeguYTl7pg=;
	b=jFtqzbnbwWhMnZF5BIp/HoZi7FChqgYmRKOx5h1x6GAEzei4C2NE9n0r7FDHKSSpinuG5FpA3
	slqQ9+gBI6nbhxz0NwmR54NCyHExkMkmlAgbYqmR76IDB0ag6ZBXxrb1H6Kc6LxQ1YfHZ+ylM0s
	be4PTGV2KuRlbS2/R2NREGo=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hnbhF52qDzpSvd;
	Sun, 20 Sep 2026 14:15:41 +0800 (CST)
Received: from kwepemp500010.china.huawei.com (unknown [7.202.195.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C52F20333;
	Sun, 20 Sep 2026 14:27:34 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500010.china.huawei.com (7.202.195.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 20 Sep 2026 14:27:33 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 20 Sep 2026 14:27:33 +0800
Message-ID: <3befeeba-f395-c136-5dcf-4297db9751af@huawei.com>
Date: Sun, 20 Sep 2026 14:27:33 +0800
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
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260918070307.381207-1-yangxingui@huawei.com>
 <20260918071518.BD35B1F000FF@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260918071518.BD35B1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/9/18 15:15, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: libsas: concurrent SMP IO to uninitialized hardware during PM resume

No SMP command can reach the hardware before it is initialised. During
suspend, sas_suspend_devices() -> sas_notify_lldd_dev_gone() marks
every device gone (hisi_sas_dev_gone() sets SAS_PHY_UNUSED, or NULLs
lldd_dev for non-PM removal), and lldd rejects such commands via 
DEV_IS_GONE() with -ECOMM before any hardware access.
Devices are only re-registered by sas_resume_port() ->
sas_notify_lldd_dev_found(), which runs from the PHY UP events - i.e.
after hw_init_v3_hw() and phys_init_v3_hw() have completed.

log as follow:
[48370.881905] hisi_sas_v3_hw 0000:74:04.0: resuming from operating 
state [D0]
[48371.864031] jamy pm_runtime_get_noresume(ha->dev)
[48371.869751] hisi_sas_v3_hw 0000:74:04.0: task prep: device 19 not ready
[48371.877442] hisi_sas_v3_hw 0000:74:04.0: task exec: failed[-70]!
[48371.884342] sas: executing SMP task failed:-70
[48371.889667] jamy pm_runtime_put(ha->dev)
[48371.903331] jamy pm_runtime_get_noresume(ha->dev)
[48371.908931] hisi_sas_v3_hw 0000:74:04.0: task prep: device 19 not ready
[48371.916628] hisi_sas_v3_hw 0000:74:04.0: task exec: failed[-70]!
[48371.923535] sas: executing SMP task failed:-70
[48371.928877] jamy pm_runtime_put(ha->dev)
[48372.117963] hisi_sas_v3_hw 0000:74:04.0: neither _PS0 nor _PR0 is defined
[48372.126124] hisi_sas_v3_hw 0000:74:04.0: waiting up to 25 seconds for 
4 phys to resume
[48372.180880] hisi_sas_v3_hw 0000:74:04.0: phyup: phy0 link_rate=11
[48372.187994] hisi_sas_v3_hw 0000:74:04.0: phyup: phy1 link_rate=11
[48372.188003] hisi_sas_v3_hw 0000:74:04.0: dev[22:2] found
[48372.195016] hisi_sas_v3_hw 0000:74:04.0: phyup: phy2 link_rate=11
[48372.195019] hisi_sas_v3_hw 0000:74:04.0: phyup: phy3 link_rate=11
[48372.201352] hisi_sas_v3_hw 0000:74:04.0: dev[23:1] found
[48372.221700] hisi_sas_v3_hw 0000:74:04.0: dev[24:1] found
[48372.228037] hisi_sas_v3_hw 0000:74:04.0: end of resuming controller

Thanks,
Xingui
