Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B77C14AD23;
	Mon, 19 Aug 2024 06:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724049886; cv=none; b=XNMSsHvoEmQYHxmwCU+bB2wOxQqcoz7ACHsFsAf1a4kH3NaxH+df/bgnAZBHPbQiF/wV8yq/50PAB1x/inPdj/QesY+SHdZIlo6qjgPMWK5/j3YB+Y4IuftxSJ58lUPu/JUHlbxvmuEuWbAoqAS2OHti+LZ0PV6F+LuYXPvn9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724049886; c=relaxed/simple;
	bh=2bl5gl0mNYQ4ISUhz1fUgbt0jmAaZtG+6mJGM55o9RI=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TAjUZZ438rkMSHY5yLVbnGn/DfEf2/RkZzCBZZppFOFEKB1vh/HZswKZbDkI9C02AV1GPcorqvdXZWvcqXWuEhCgroLu5aENR8QoX/sWT5TmoyYHHEs9b2SsYw/3vdzpMT3j9RGqUky/xOkfQYzoI/5h8tlIwVemVgB7M8rodNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WnNHc044zz2CmYZ;
	Mon, 19 Aug 2024 14:39:40 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C1F614011F;
	Mon, 19 Aug 2024 14:44:38 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 14:44:37 +0800
Subject: Re: [PATCH v4] scsi: sd: retry command SYNC CACHE if format in
 progress
To: Damien Le Moal <dlemoal@kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240817015019.3467765-1-liyihang9@huawei.com>
 <10c56cbc-a367-44c3-8b14-b846a3c4e4a0@kernel.org>
 <4618fc13-4499-53f1-efea-0487f436b353@huawei.com>
 <a3fc662c-fa98-4a6e-807b-babb9a344904@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bvanassche@acm.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<stable@vger.kernel.org>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <676e37ba-a9c3-3d52-5c3b-0fa86cf1402e@huawei.com>
Date: Mon, 19 Aug 2024 14:44:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a3fc662c-fa98-4a6e-807b-babb9a344904@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/19 12:17, Damien Le Moal wrote:
> On 8/19/24 13:07, Yihang Li wrote:
>>
>>
>> On 2024/8/19 7:55, Damien Le Moal wrote:
>>> On 8/17/24 10:50, Yihang Li wrote:
>>>> If formatting a suspended disk (such as formatting with different DIF
>>>> type), the disk will be resuming first, and then the format command will
>>>> submit to the disk through SG_IO ioctl.
>>>>
>>>> When the disk is processing the format command, the system does not submit
>>>> other commands to the disk. Therefore, the system attempts to suspend the
>>>> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
>>>
>>> Why would the system try to suspend the disk with a request in flight ? Sounds
>>> like there is a bug with PM reference counting, no ?
>>
>> According to my understand and test, the format command request is finished,
>> so it is not in flight for the kernel. And the command need a few time to processing
>> in the disk while no other commands are being sent.
> 
> OK, fine. But I think that retrying SYNC CACHE if the drive is formatting makes
> absolutely no sense at all because there is nothing to flush in that case.
> So what about simply ignoring the error ? I.e. something like this:
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 699f4f9674d9..1da267b8cd8a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1824,12 +1824,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>                                 /* this is no error here */
>                                 return 0;
>                         /*
> -                        * This drive doesn't support sync and there's not much
> -                        * we can do because this is called during shutdown
> -                        * or suspend so just return success so those operations
> -                        * can proceed.
> +                        * If a format is in progress (asc = LOGICAL UNIT NOT
> +                        * READY, ascq = FORMAT IN PROGRESS) or if the drive
> +                        * does not support sync, there is not much we can do
> +                        * because this is called during shutdown or suspend. So
> +                        * just return success so those operations can proceed.
>                          */
> -                       if (sshdr.sense_key == ILLEGAL_REQUEST)
> +                       if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
> +                           sshdr.sense_key == ILLEGAL_REQUEST)
>                                 return 0;
>                 }
> 

Thanks for your suggestion, it seems like good.
I will send a new version based on this later.

Thanks,

Yihang.
