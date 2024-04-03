Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA03D76;
	Wed,  3 Apr 2024 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116734; cv=none; b=cV5OY+QIk/BofV+GZ/rs94fapYB7WWVyakDI9emU5br08A+Mj9wD1Ml48ykeYu1tdfyawe6geGp0P8vC7YsKPGdvUysp1MbGZhGLTH7yDRGl9rWLkw8cyVh4afiICLjXTZr3g7eN2cL3RtSr9C3QcBlvYG+5xB5hH+40cpbEYlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116734; c=relaxed/simple;
	bh=WsY/TNsEXjthucfE5va9e+m05l9sgv1UbriWKESjJ7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jWAOER3RJD4BHtbPVUl+TazKZm+V/UxLuBGqXebltqwsnGjLtyhHO8/KwL1w1XQztwvKU6dhlqbJoFu8PArbR4y1DOqSdtgEmPpvOwjiQ/wp75a0AggHMCB5uhn+D8Nmaie4VfXeWK7ZKRKtUS7JyFtOMLY+GshONsrER+yXlZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnVAISck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnVAISck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57539C433F1;
	Wed,  3 Apr 2024 03:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116734;
	bh=WsY/TNsEXjthucfE5va9e+m05l9sgv1UbriWKESjJ7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TnVAISckYGOK578QZvqWjsbafhEKXwBgnAEZm5jAuLBn59H3EgOo989qVebHS6kFd
	 4S+MLbOKEX/3bnE1oW/U2yoGRH2dZ1cRuwHuj3aEsDmpFAqtAmCaqyGqxt2xDQZ7sw
	 GYjUPMGsP0LXPYwc45HuYrvaJOu5WlM2xI26yc4Pf4zKbfCOnzZE/G+4M/4B4DM5Xs
	 iR+4wKr83LsWFGcoYdGg4VBhdgc6dGxi2DkhWbIxePR0+wDmaeQSZJojJE6xODfBp9
	 ukS9rKhqbFZtxtUNlJ3CjyhtWLziCc2lvRV6yefMK1yA8Ro0pllMtVRH8sEt1Lrmb4
	 rdXTpRnkd4gZg==
Message-ID: <3b35dca4-e548-427b-a304-e21f3ee483e0@kernel.org>
Date: Wed, 3 Apr 2024 12:58:51 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/28] null_blk: Introduce fua attribute
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-18-dlemoal@kernel.org>
 <7a3be43c-39d9-472a-9593-89a1c4e03004@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7a3be43c-39d9-472a-9593-89a1c4e03004@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/3/24 12:56, Chaitanya Kulkarni wrote:
> Damien,
> 
> On 4/2/24 05:38, Damien Le Moal wrote:
>>   +static bool g_fua = true;
>> +module_param_named(fua, g_fua, bool, S_IRUGO);
>> +MODULE_PARM_DESC(zoned, "Enable/disable FUA support when cache_size is used.
>> Default: true");
>> +
> 
> checkpatch is generating warning on this patch, please check :-
> 
> WARNING: Symbolic permissions 'S_IRUGO' are not preferred. Consider using octal
> permissions '0444'.
> #31: FILE: drivers/block/null_blk/main.c:229:
> +module_param_named(fua, g_fua, bool, S_IRUGO);
> 
> Also, I noticed that for zone_append_max_sectors attribute patch
> you are using 0444 but for fua you are using S_IRUGO, any specific
> reason ?

No particular reason. I probably followed the pattern around the code when I
added it.

Personnally, I find this checkpatch warning about S_IRUGO silly as it is far
more readable than 0444... Just my 2 cents. I can make the change if you insist.

> 
> -ck
> 
> 

-- 
Damien Le Moal
Western Digital Research

