Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A321957F4;
	Thu,  6 Jun 2024 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717677227; cv=none; b=DGw8fGwQu/72gwwsixawLZATD1NeBESUc7X5gYLg52YzAl9OjHAzrNmtPSwVyAPRpmZqyhH0vN85DlebOJNh6aDu5PcU+kituhNLUQiMdGyLBbvJMwCibKru7bfpQ8GKfy2nWsIAEctVhDM3+Z4o/yAMw4zJd89WnF36gyEF1rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717677227; c=relaxed/simple;
	bh=vGSPg6a5fe0OYL6lAgRHVbj5t2En0Mde6rJzsrpiSxk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UjBaTIboGpwEh7X5ScdecqiJMAxlhdO3Ae26+QHlfwsxaPLeoPqcpjgdZY8CU9ogtWXneX+LlEyMd1EbEXH5ME3ISr251L7r5j7n2lnjD7hvnQp6GSyd/2ZLf/hd2o60Ud/k+8jPU4QD6LI+WtUF9pG8iMQo0MmU7SvvDBi3ovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=r1ZoiLYv; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="r1ZoiLYv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717677222;
	bh=KK2aEsGryauZUlCd5y9kuRvTiVpdgQOV3Jda2VqMpvE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=r1ZoiLYvCjQatKeubwNDC8sbnUXe2n7Tx17Cfx2R7IfXaDM7du4yNb/bCPasy7dys
	 BsrsW8jSntGwqOTuBqvgwRgsQjrCqD72PT8Bi0omXbnzcKFwQY0oBPnMoBb5cehDTI
	 E1w6BT2NxiL95bDzY/aSPDAicVdcKZa20X3zyaNF2cuQueg83ZSKVDYiIlC2ZGneAo
	 Bpyb3CSNjyZrW4dyjYsx57VPOgmTcJV5x/lBQh+TQk1ZRtBq9GAmj129TQ956nM+D9
	 +Fh3zi2aFekNoQ8/PSUX/G4Ipd5mU8huV4HSRcy/fadXg5PRYOYpo+h4BaiDfRApbK
	 lvP6xWkF1gDog==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Vw3fD4Y5fz4wc3;
	Thu,  6 Jun 2024 22:33:40 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, benh@kernel.crashing.org,
 linuxppc-dev@lists.ozlabs.org, Guenter Roeck <linux@roeck-us.net>, Linux
 kernel regressions list <regressions@lists.linux.dev>,
 doru.iorgulescu1@gmail.com, bvanassche@acm.org
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
In-Reply-To: <0512b259-f803-4feb-a5bf-0feb7f7b44da@oracle.com>
References: <20240520151536.GA32532@lst.de>
 <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
 <8734pz4gdh.fsf@mail.lhotse> <87wmnb2x2y.fsf@mail.lhotse>
 <20240531060827.GA17723@lst.de> <87sexy2yny.fsf@mail.lhotse>
 <87wmn3pntq.fsf@mail.lhotse>
 <0512b259-f803-4feb-a5bf-0feb7f7b44da@oracle.com>
Date: Thu, 06 Jun 2024 22:33:40 +1000
Message-ID: <87o78ep7x7.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

John Garry <john.g.garry@oracle.com> writes:
>> diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
>> index 817838e2f70e..3cb455a32d92 100644
>> --- a/drivers/ata/pata_macio.c
>> +++ b/drivers/ata/pata_macio.c
>> @@ -915,10 +915,13 @@ static const struct scsi_host_template pata_macio_sht = {
>>   	.sg_tablesize		= MAX_DCMDS,
>>   	/* We may not need that strict one */
>>   	.dma_boundary		= ATA_DMA_BOUNDARY,
>> -	/* Not sure what the real max is but we know it's less than 64K, let's
>> -	 * use 64K minus 256
>> +	/*
>> +	 * The SCSI core requires the segment size to cover at least a page, so
>> +	 * for 64K page size kernels this must be at least 64K. However the
>> +	 * hardware can't handle 64K, so pata_macio_qc_prep() will split large
>> +	 * requests.
>>   	 */
>> -	.max_segment_size	= MAX_DBDMA_SEG,
>> +	.max_segment_size	= SZ_64K,
>>   	.device_configure	= pata_macio_device_configure,
>>   	.sdev_groups		= ata_common_sdev_groups,
>>   	.can_queue		= ATA_DEF_QUEUE,
>
> Feel free to add:
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks.

Sorry I missed adding this when sending the proper patch, maybe whoever
applies it can add it then.

cheers
