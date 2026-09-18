Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501930CD95
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789714760; cv=none; b=XwqbWsBssGg5JZWlGaKUvhEQsEWO8i7cY1No8liuYBv06rq5AOY2JJzJ8pRcbY5wj9nvfb/h8yNvfMiRcLVTn8JSKgpww4IPDleC74LD/BA18rp0So1RZOM/GJ4OojYuxNbOH6qB4jmLkJ3s0lmC6gA5CNyVxTFQ3RgJR33ABQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789714760; c=relaxed/simple;
	bh=JV6QCvDz4ojJBBAX8alvdc2Geq5uxAza3V2fDXIpd8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iuWPESDJdK0nWi1NcUd0kRZ3NG4y8KnItRkC98EASztVLWX4Ozd/trmVf490rh99wFP2tJNT2Gg/3Of5A4U5Zb+/L+6OzduAJbiiYiscoNU33jW9FuBdvuoU4rUMc+0Rgv8fZHFKVjSxkruoQaLz0dHxTIoCOGJczUII/jg3CYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=d3o6CYm9; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="d3o6CYm9"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=re+qb6b3Wt6oaaE85ttSZhwAjNXyMlzddCzdbi3wLiE=;
	b=d3o6CYm9J5kZD1a3C5mjZtLa8BmqKt3sSLXIfQ4KfxD4SbkRt8K5/N57HdyIZtPa1s6cA/23w
	3w7I4Yf/s1E9/lKXGN+0DCrUUeng6ZxKHQe7Z2/0cWFik8scIuGw8AdLICZk68qFmheLiAvKFGj
	Bdh7dko+ot1gcVgqn1ycSDI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hmNVg45jTz1prKW;
	Fri, 18 Sep 2026 14:48:11 +0800 (CST)
Received: from kwepemp100009.china.huawei.com (unknown [7.202.195.55])
	by mail.maildlp.com (Postfix) with ESMTPS id C42F34057F;
	Fri, 18 Sep 2026 14:59:12 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100009.china.huawei.com (7.202.195.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 14:59:12 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 14:59:12 +0800
Message-ID: <8f97a362-f9cd-715a-625b-a15851f72616@huawei.com>
Date: Fri, 18 Sep 2026 14:59:11 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260917130642.1796231-1-yangxingui@huawei.com>
 <20260917131758.A2F4A1F000FF@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260917131758.A2F4A1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/9/17 21:17, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] libsas: missed PM autosuspend in smp_execute_task_sg()
> --
> 
> commit 8e09b6455fc925eb255f96d9d3584cbd10d1bdaa
> Author: Xingui Yang <yangxingui@huawei.com>
> 
> scsi: libsas: Fix SMP IO deadlock during HA resume
> 
> This commit fixes a deadlock during controller resume by using
> pm_runtime_get_noresume() and pm_runtime_put_noidle() when
> SAS_HA_RESUMING is set. Outside of the resume window, it converts
> pm_runtime_get_sync() to pm_runtime_resume_and_get() to handle
> runtime resume failures.
> 
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 811c9eb4fef11..a17b938cd3b7c 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
> 
> [ ... ]
> 
>> @@ -135,7 +150,10 @@ static int smp_execute_task_sg(struct domain_device *dev,
>>   		}
>>   	}
>>   	mutex_unlock(&dev->ex_dev.cmd_mutex);
>> -	pm_runtime_put_sync(ha->dev);
>> +	if (ha_resuming)
>> +		pm_runtime_put_noidle(ha->dev);
> 
> [Severity: Medium]
> Does this leave the device permanently in the RPM_ACTIVE state if this
> thread outlives the host resume?

Ok, v3 drops the reference with pm_runtime_put() instead. ^_^
