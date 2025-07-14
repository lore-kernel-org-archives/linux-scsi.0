Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1131F2C34;
	Mon, 14 Jul 2025 07:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479892; cv=none; b=CqXWkE7lTeHR0qRa+/gli+q4J97FB33ywocdb/AOiXEguUHskKt4weMB3ynBOLK1gputjthmmpIRIxbtHRO+QPB/uUbIYeUmxZD4ddGgHcw2En9z1YSRHyCYwe2nwYglxbPWuvQENB0Va5MW8z7AabWZF3IgOayXWRCVYI8a9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479892; c=relaxed/simple;
	bh=PzbB+7IcW8L6GtFe+c2FSmfXUY7BWeG2rhSrFIM/koA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iA8Zatf6dY2aNCov4pP07jz7ZkGtDjbRHNmf/crj0tIidaTV9x4f6hN8QjJYo3I4AvKp3cDtTOV19H8iijREdaTwFQNAs9ZoZ29w5cCC2w2DKiX9mgBpjOsoMX63JH7CaBqz2+iGTeXfN6QurKk5ETJ5vE8cLbHCuta4zONdGrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stGtnnuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stGtnnuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0C9C4CEED;
	Mon, 14 Jul 2025 07:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752479891;
	bh=PzbB+7IcW8L6GtFe+c2FSmfXUY7BWeG2rhSrFIM/koA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=stGtnnuGLWy3zdQrA0dUE6vGvp5hjkpzdNwjmZdQEu6nqHkJ0qdVidnNJyDRYRSJp
	 RvAA4r/x0zd6TRcbAIbTrcGJYnwjT/Bm30+RBFNqhcxUte90GywgH6wuXAt2GjrmvT
	 WwrTyGxMh+39V0jruwC+pLvWQAZaCaQpziG/n0b+pcJa34mncnGhx2UVTpwe9iAUeh
	 27HEjreYl8TdpjTZ68R98b+o2ParDyQMvxtqfo7WXTOvMhHGyNqSowSoNF3yZHkeTo
	 C8hEdIpVG3zADCE2KsQASkIq4qf6fIhVAfw2jAoQvqT6d6KPkeI9o9+yR+yvwYgj0M
	 DhYsp+JPEDTNg==
Message-ID: <45bca57f-90eb-44cd-af3d-8316cd50eae9@kernel.org>
Date: Mon, 14 Jul 2025 16:58:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] ata: libata-eh: Simplify reset operation
 management
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>
References: <20250714005454.35802-1-dlemoal@kernel.org>
 <20250714005454.35802-3-dlemoal@kernel.org> <aHS4MmhX0W33SxL7@ryzen>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aHS4MmhX0W33SxL7@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/07/14 16:56, Niklas Cassel wrote:
> On Mon, Jul 14, 2025 at 09:54:53AM +0900, Damien Le Moal wrote:
>> Introduce struct ata_reset_operations to aggregate in a single structure
>> the definitions of the 4 reset methods (prereset, softreset, hardreset
>> and postreset) for a port. This new structure is used in struct ata_port
>> to define the reset methods for a regular port (reset field) and for a
>> port-multiplier port (pmp_reset field). A pointer to either of these
>> fields replaces the 4 reset method arguments passed to ata_eh_recover()
>> and ata_eh_reset().
>>
>> The definition of the reset methods for all drivers is changed to use
>> the reset and pmp_reset fields in struct ata_port_operations.
>>
>> A large number of files is modifed, but no functional changes are
>> introduced.
>>
>> Suggested-by: Niklas Cassel <cassel@kernel.org>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
> 
> (snip)
> 
>> diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
>> index 93ebf566b54e..8de63d889a68 100644
>> --- a/drivers/ata/pata_parport/pata_parport.c
>> +++ b/drivers/ata/pata_parport/pata_parport.c
>> @@ -321,8 +321,7 @@ static void pata_parport_drain_fifo(struct ata_queued_cmd *qc)
>>  static struct ata_port_operations pata_parport_port_ops = {
>>  	.inherits		= &ata_sff_port_ops,
>>  
>> -	.softreset		= pata_parport_softreset,
>> -	.hardreset		= NULL,
> 
> I think you need to add .reset.hardreset = NULL, because pata_parport_port_ops
> inherits ata_sff_port_ops, which does set hardreset, so I think this line will
> clear the pointer.
> 
> 
>> +	.reset.softreset	= pata_parport_softreset,
>>  
>>  	.sff_dev_select		= pata_parport_dev_select,
>>  	.sff_set_devctl		= pata_parport_set_devctl,
> 
> 
> Rest looks good to me:
> Reviewed-by: Niklas Cassel <cassel@kernel.org>
> 
> 
> Tell me if you want to fix it up when applying or if you want to send a new
> version.

If you can fix it up when applying, that would be great. Thanks.

> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
