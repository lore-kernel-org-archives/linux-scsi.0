Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB434F474;
	Fri, 10 Jul 2026 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783648420; cv=none; b=aWnAoGPPob6dKcIcm4q1M0S/yhKHE2TC9qQP4JCMi4jpSGKXuLwoyA1rw33L1fP3DWD62rE8EeqlAZotbeWS7ObiMVbW0ju7MQP2kJz/g3MVjr8Dmx60kGHAYmcklx4k6ezywt7WWW6hkIjkClZoE9Px0+zFZz0ASPkDRyxjPzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783648420; c=relaxed/simple;
	bh=sVcLg8mBbOlcU7U2S17/eem27V26Re7M4ChY0wfV64I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Fh8672U2lFknUqGg6ZZRuGKp3MA1wp4h3W3devCWNl8iaDV/wjkeuA85ONwJAj6+qIWD9+bbL4/dr4iiRODbNjUVe4cPENVdcVXy+30nDtcpAQ8Rbt4BEaXKPyFJJmkh0P6h10Eri0RgRg1cD0/BNCLV0Cf7QRC2OjDGPlp//a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VoyOVKzu; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VoyOVKzu"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tTjDvA366Z+mwtBEU1qTetAUB8oC2LXClWANoJ9MZGc=;
	b=VoyOVKzu2SCHmb+og/z7zyOm875JtyVYk7twNQ+AFWjvAiE+THAnr1XFj7cEUrDWtZ6pjAHbC
	XGtuCCMv3kVX3EDqBfdkehkPQSq7MkyJvxaKU2FsGweb6L/ed9hyU7s0o/piGoqreJvkqywqdkl
	SMVE+P+R5DTf6T5FWk3bGjs=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gxF493lgdzLlTZ;
	Fri, 10 Jul 2026 09:44:09 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 9573340563;
	Fri, 10 Jul 2026 09:53:24 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 10 Jul 2026 09:53:23 +0800
Message-ID: <1687e42a-7d28-4189-a261-975a8289c680@huawei.com>
Date: Fri, 10 Jul 2026 09:53:22 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: libsas: terminate deferred commands on time
 out
To: Damien Le Moal <dlemoal@kernel.org>, <linux-ide@vger.kernel.org>, Niklas
 Cassel <cassel@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>
CC: Igor Pylypiv <ipylypiv@google.com>, John Garry <john.g.garry@oracle.com>
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-3-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260710000646.1202200-3-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/7/10 8:06, Damien Le Moal 写道:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the scsi EH task is never woken up as the waiting
> deferred command is never issued nor completed, thus leaving this command
> to always be counted as "busy" for the SCSI host. This results in the
> scsi_error_handler() function test "shost->host_failed !=
> scsi_host_busy(shost))" to always be true, keeping the SCSI EH task
> sleeping. Eventually, when the deferred command also times out, the EH
> task is woken up and the timeout processing starts.
> 
> Avoid this unnecessary additional EH trigger wait time with the same
> method as implemented in libata-scsi, using the eh_timed_out SCSI host
> template operation. The function sas_eh_timed_out() implements this
> operation and executes the helper function ata_scsi_port_eh_timed_out()
> if the device is a sata one.
> 
> Co-developed-by: Igor Pylypiv<ipylypiv@google.com>
> Signed-off-by: Igor Pylypiv<ipylypiv@google.com>
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc:stable@vger.kernel.org
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c           |  5 +++--
>   drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++++++++++
>   include/linux/libata.h              |  2 ++
>   include/scsi/libsas.h               |  2 ++
>   4 files changed, 24 insertions(+), 2 deletions(-)

Looks good to me,

Reviewed-by: Jason Yan <yanaijie@huawei.com>
