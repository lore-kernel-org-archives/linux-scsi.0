Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3A70808;
	Tue,  8 Sep 2026 00:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788827265; cv=none; b=nX1SYWuEytgitL0baqhX5WJxchAS4wOQa9VbflKItgYp+Kb+PU2xxxuiy1C2jYP0mRpxWClXAj9oy+RYb1QcwQQtGZGG3xK41ElLKNR+8sgYjrb1vsRenOyxhOhM5cAErs8NEwgIg3WRv022xnnFylekHZGnlBXwNdRwIBt8NKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788827265; c=relaxed/simple;
	bh=t4vxgbrbi/wAWs1KoOlXAFuwYaRnFWoKYdliwh37Ytk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OkYI2JxGFkQyMAvbng7DKHPhaf1WUIYqOvpldfbvhvUwF+rCVWTOhzemg1G7eDvcI5Hu/p6ovjm72DDvbo/dSjDy94yj9zTarGnQZGvi83ZCQZ4y/Rl+uDsPJuuXMnm8xAwhcCBJvtFSXCiBk7tUxYn0eqAZCsRXaZsy6mCxjU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uc/qx5Es; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uc/qx5Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536651F00A3A;
	Tue,  8 Sep 2026 00:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788827263;
	bh=MOODhmwwhH7/g/Z4PPZATPpraTSPl3jX7F5Qv0B6f5Y=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Uc/qx5Esb1R07ri1PUbEPrBC9pZfxaKr/6lM9menQ/tJBJFdylTdwONmVgJUdExOj
	 gYErV3eTCA36Au4bYEQOLYYkr1kOcTVvgZPRJok/TvCEvV3mWMm1rEkGX/P4QI38wp
	 YlR2nP1syU3vl0U1H4PitI8NFpoS8QkMFDVWh/6bH4AzyIxn8Vqog0sEfGfaNXymH6
	 u64Vv61kjcTN39w1kMjlUI4NJdc6AIZNI7werlwRKWkV08xKrGUY1KviBMau++0H3g
	 vc4G4E0Mx7ymarO8VN5Ept2Ygx/QmqHYnSEEr3ThSxSFyLUB7gUvs0br8URbzpYsad
	 DOkb3h9mdzKaQ==
Message-ID: <f65388b1-e299-4f1f-927e-445f6d9e77df@kernel.org>
Date: Tue, 8 Sep 2026 09:27:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 35/40] usb: storage: use 16-bits defined sense codes
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-36-dlemoal@kernel.org>
 <fbbde389-d040-405b-8f87-f589c4890afe@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <fbbde389-d040-405b-8f87-f589c4890afe@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/8/26 01:13, Johannes Thumshirn wrote:
> On 9/7/26 4:43 AM, Damien Le Moal wrote:
>> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/
>> gadget/function/f_mass_storage.c
>> index a50743caf083..05e138968389 100644
>> --- a/drivers/usb/gadget/function/f_mass_storage.c
>> +++ b/drivers/usb/gadget/function/f_mass_storage.c
>> @@ -1103,9 +1103,9 @@ static int do_request_sense(struct fsg_common *common,
>> struct fsg_buffhd *bh)
>>        * FSG normally uses option a); enable this code to use option b).
>>        */
>>   #if 0
>> -    if (curlun && curlun->unit_attention_data != SS_NO_SENSE) {
>> +    if (curlun && curlun->unit_attention_data != NO_SENSE) {
>>           curlun->sense_data = curlun->unit_attention_data;
>> -        curlun->unit_attention_data = SS_NO_SENSE;
>> +        curlun->unit_attention_data = NO_SENSE;
>>       }
>>   #endif
> 
> No sure how relevant it is to change something in a commented out block.
> Wouldn't it be better to just remove the block?

Well, I don't really know why that block is here. Might be for some quick debug
thing, so I left it, but made sure it is also corrected so that if the #if 0 is
changed to #if 1, it still compiles.

I will let the cleanup of this, if any is needed, to the USB folks.


-- 
Damien Le Moal
Western Digital Research
