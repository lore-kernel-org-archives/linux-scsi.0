Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.224.83.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781097;
	b=vN0xN7Wm8Eq0HwawagjRk/bKGsE1642Yqjw/kT2dGPlPWU3wSgrVd+ZtrSiTOVGFM3p/
	 RX1cFYe0UC50KU7iKnHRGBEMti17tdNzXYrHZHRIzaD2kg4KsQ+K2anADMzW7y8GTbdIE
	 IsIbCkpuRzgY5LCH/yjfeaZrldYmDB5TNhordE9nno4vzT0aLXgY/71TayDmzIVLwwNAk
	 4cgdubFg9EIjIs8hihF94OylEmwg4f1CO2/03yvWIJOhaKOFw0uOUr9CEqU4w4o8aW04b
	 CYRSh8b2LjDLIzfIdqpwZPe5Y34m2thL2GPiY2/smKhDnWSi6OwJq3SvkObWEwjtJ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781097;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:X-HM-Spam-Status:
	 DKIM-Signature;
	bh=4Soui1oevHHOpNf6Ld09yGq9KiYJXTE+lAiRJ+e+lPw=;
	b=2/sTq0U24TKsPlnI9O5GwFaJdY494fzZMBeG71xRBHRTHUGW/8az2YkbTfw+4oUEHrDW
	 m3IuR9dFQivXEyI+pkEkcnDKV1nmyVZG/DhzNnYt9W1BXU2+ul9x+TOst8X7W7Xsy6NiA
	 BMbSSNRSV5zXwyII6A6vAyHxQosMQGV1jVPLNSqyudDCasLetnULpjOMM3McwJvMMNZEh
	 2yQUDcr4MPtQ7ChU6bXw9QyEvbA8kVdJaofMTCRRnTJCM+gOpJxCvd+ygEc5IpfoSHnF5
	 kRCQcvcmicuIUFDYy71606NyKazcupBUCguWv4xgdGWzZEDwQiPu0BseIH59A4GHwdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leap-io-kernel.com;
	spf=pass smtp.mailfrom=leap-io-kernel.com;
	dkim=pass header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b="f/JkH2L0";
	arc=none smtp.remote-ip=156.224.83.230
Received: from mail-m83230.xmail.ntesmail.com (mail-m83230.xmail.ntesmail.com [156.224.83.230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4D606A338
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 08:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EA4D606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=f/JkH2L0
Received: from [10.0.66.4] (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5375794e3;
	Wed, 4 Nov 2026 16:31:24 +0800 (GMT+08:00)
Message-ID: <88014df3-4d08-4cfd-a6ce-629a672fb791@leap-io-kernel.com>
Date: Wed, 4 Nov 2026 16:31:24 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: leapraid: Fix init_cmd_priv error handling
To: Damien Le Moal <dlemoal@kernel.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: hare@kernel.org, hare@suse.de, yjzhang@leap-io-kernel.com,
 kezijie@leap-io-kernel.com, jzzhang@leap-io-kernel.com,
 baikefan@leap-io-kernel.com, linux-scsi@vger.kernel.org
References: <20261104031823.198733-1-doubled@leap-io-kernel.com>
 <a161c75d-c8a2-4e44-8e33-30298622fc0c@kernel.org>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <a161c75d-c8a2-4e44-8e33-30298622fc0c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a5af320a03aekunm32509a8d45435b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZT0xCVk1CQxgYS0NJHkpJHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tISkpCTVVKS0tVSkJZBg++
DKIM-Signature: a=rsa-sha256;
	b=f/JkH2L0ZZ9Q2JrmGyMvifM/Hl+GROeo12IYitkmyXkkPuJcvbtAgZjBF0+HAetZuRQwGszOoioJ/dn+XCY2e7SZW+q5QvxNTJh2CiV4VTDfJN7/xqgk/w78MWftDiLNXT4BI6dMkGRVX9OJjFmHIJmF7p4cui7eITpyr9NMwVGSkNwUu4C18OTjaRGyLqAiMpHeWJxfaQLZMVL3frCaX2hRfJmwpfZ50Cee9sVJi1l4ardj0tT4rhv4iF1Z0n8Sz/wbOQk//XE5Q/uxXYAOiVSHRkJkvwJsRy2ZG1NacLD5AuJmNG9ahTo0P01Rt7I0sYimP8JM+JFCrVZpH7am1w==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=4Soui1oevHHOpNf6Ld09yGq9KiYJXTE+lAiRJ+e+lPw=;
	h=date:mime-version:subject:message-id:from;

在 2026/11/4 14:49, Damien Le Moal 写道:
> On 11/4/26 12:18, Dongdong Hao wrote:
>> leapraid_init_cmd_priv() ignores the return value of
>> leapraid_internal_init_cmd_priv() and always returns success. If
>> dma_pool_alloc() fails, io_tracker->chain remains NULL, but the SCSI
>> midlayer considers the command successfully initialized.
>>
>> A subsequent I/O requiring more than LEAPRAID_SGL_INLINE_THRESHOLD
>> DMA-mapped scatter-gather entries dereferences the NULL chain buffer
>> while building the chained SGL, causing a kernel crash.
>>
>> Return the result of leapraid_internal_init_cmd_priv() so that allocation
>> failures propagate to the SCSI midlayer and abort initialization of the
>> affected request.
>>
>> Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
>> ---
>>  drivers/scsi/leapraid/leapraid_os.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
>> index da597eb99377..0f3219c4f438 100644
>> --- a/drivers/scsi/leapraid/leapraid_os.c
>> +++ b/drivers/scsi/leapraid/leapraid_os.c
>> @@ -938,9 +938,8 @@ static int leapraid_init_cmd_priv(struct Scsi_Host *shost,
>>  	struct leapraid_io_req_tracker *io_tracker;
>>  
>>  	io_tracker = scsi_cmd_priv(scmd);
>> -	leapraid_internal_init_cmd_priv(adapter, io_tracker);
>>  
>> -	return 0;
>> +	return leapraid_internal_init_cmd_priv(adapter, io_tracker);
> 
> 	return leapraid_internal_init_cmd_priv(adapter, scsi_cmd_priv(scmd));
> 
> and you can remove the io_tracker local variable.
> 
> With that,
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 

Thanks, v2 is on the way.

> Note: when I sent out the SCSI ASC/ASCQ series rework, Sashiko had comments
> about pre-existing issues in the leapraid driver. See:
> 
> https://sashiko.dev/#/message/20260831021810.235281F000E9%40smtp.kernel.org
> 
> You may want to check that.
> 

As for the SCSI ASC/ASCQ series, we checked the report, but both
scsi_build_sense() and scsi_set_sense() already set scmd->result to
SAM_STAT_CHECK_CONDITION, so it looks like a false positive.

