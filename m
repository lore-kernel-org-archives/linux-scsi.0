Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F21B5325;
	Thu, 21 Nov 2024 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732211005; cv=none; b=PC7LQE6BzhP+aFOiww6MgRes2Unmjyk4gxCPc42wg4N1MBR8uiJGocvPGeNsnb2etCrIYt6pXt2quPN0en0FXtGkX8cdtHylAajpnq28Xn6kU4GIKXbobHgrMIkc3g6+vy+cevfxtMEOian19JxfIPjcDpzb7Jady/43zsLSJxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732211005; c=relaxed/simple;
	bh=5dljb1XolvJzVbfZ4LIhIwKXBiJhW0N+BZljmI1e1fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/LTEp95acz2fmC3oVaeynvr/9aKV4Zj+hAXcoJO5HLQW+27m7eS18wRGStutu5Qc3jTULsAlo6gMGAv94nJDNGsJblHuk0ty+/Q50q07aL80Ln9GGELv0qNe97qKgKeyrz8VQbpy+pJouS9P/8Q6X6zT4vq3rRKQhdZQequeUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qFJg2DkG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qFJg2DkG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvQYx0lsfz6CmQvG;
	Thu, 21 Nov 2024 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732210993; x=1734802994; bh=rqwte/u4VDOUnz0zCGTlVUFX
	ijGl/VH99DbTZicbOVQ=; b=qFJg2DkGg+W+Gw9yfT7Gae4RqS8tAlkU3YLxa8XT
	XHC6UjPptfNGN5hu/iW7YbQ4O4AWjB2xZwldRlsLujq8vUigAL1/F9KhrQKPimB1
	xHKN954DqJ5Sgo7zEGRr5mQXfls8vJP9CawAvtc/PqbMN/dM6XBC96rfOhTpKpDQ
	Hsjmr9+eEesZQyE12xwu1UmNFglwMfbxU67FE0EBi1aafdw+sxdvN1bAuP+f8bHO
	uCiekPZTjDZvYJ8GiaEVQfA2QRvtoMuOD6bflYlA1APkVO81UkouQqnUmtlCtdLr
	kzTQ2HrztUog/kzDfNJvH4mIBEoHZDx4RMH1JVK/ngzNoA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LJ4FwaGtTvHj; Thu, 21 Nov 2024 17:43:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvQYq0xlpz6CmQtQ;
	Thu, 21 Nov 2024 17:43:10 +0000 (UTC)
Message-ID: <58fd8b59-c8b1-464e-9bb8-f308cea3021f@acm.org>
Date: Thu, 21 Nov 2024 09:43:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/26] blk-zoned: Only handle errors after pending
 zoned writes have completed
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-5-bvanassche@acm.org>
 <7f4058f9-df04-404c-b4f0-25bf0e8e4886@kernel.org>
 <719628f8-5ac2-48b5-8458-68540ae0b2f1@acm.org>
 <c257a046-5f9f-40eb-8ef8-f36a3f1174e6@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c257a046-5f9f-40eb-8ef8-f36a3f1174e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 7:23 PM, Damien Le Moal wrote:
> On 11/20/24 05:51, Bart Van Assche wrote:
>>>> +/*
>>>> + * Change the zone state to "error" if a request is requeued to postpone
>>>> + * processing of requeued requests until all pending requests have either
>>>> + * completed or have been requeued.
>>>> + */
>>>> +void blk_zone_write_plug_requeue_request(struct request *rq)
>>>> +{
>>>> +	struct gendisk *disk = rq->q->disk;
>>>> +	struct blk_zone_wplug *zwplug;
>>>> +
>>>> +	if (!disk->zone_wplugs_hash_bits || !blk_rq_is_seq_zoned_write(rq))
>>>> +		return;
>>>
>>> I think the disk->zone_wplugs_hash_bits check needs to go inside
>>> disk_get_zone_wplug() as that will avoid a similar check in
>>> blk_zone_write_plug_free_request() too. That said, I am not even convinced it
>>> is needed at all since these functions should be called only for a zoned drive
>>> which should have its zone wplug hash setup.
>>
>> Moving the disk->zone_wplugs_hash_bits check sounds good to me.
>>
>> I added this check after hitting an UBSAN report that indicates that
>> disk->zone_wplugs_hash_bits was used before it was changed into a non-
>> zero value. sd_revalidate_disk() submits a very substantial number of
>> SCSI commands before it calls blk_revalidate_disk_zones(), the function
>> that sets disk->zone_wplugs_hash_bits.
> 
> But non of the commands are writes to sequential zones, so the hash bits check
> should not even be necessary, no ?

Hi Damien,

I will double check whether this test is really necessary and leave it
out if not.

Thanks,

Bart.


