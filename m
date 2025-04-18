Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FB22405F8;
	Fri, 18 Apr 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745011762; cv=none; b=Z5OOrhzU01Zpru8Txm0DT+7nq/yO7UU6ha3Q/nZs5hQr4lFconGh0PXSRMYefK9mCi5Biutj9qVuD71v/tXekvFF/iGT5SuXA4BJ6UYPl7irtye5x2U0IKX7atl2Phu2pNxoiticAyT5h3FdbMjhS8lxGFpUMo8DcJgONABHt3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745011762; c=relaxed/simple;
	bh=02K1TDhrRJCLo86IW3OtYhpy9D7KIuQr59mXQAg0Ti4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqdFbqB5A24vptA/o//H5Zbo49AUf7y1qqNaG9dKQvn4ATVjLRVwsCMOAthnyTKGjXbct5ryKNWh3BiX7A5F1VVxs+5bcuUckclqck2rHfI31GWZuH3GVubeLmJsUY+LEclh1K942K8f21VyiFy34O6hTACrDFthk8AlN+yEiYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcpWPQTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcpWPQTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66DCC4CEE7;
	Fri, 18 Apr 2025 21:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745011761;
	bh=02K1TDhrRJCLo86IW3OtYhpy9D7KIuQr59mXQAg0Ti4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NcpWPQTtaQHQALpouJZo8DT6Tg7wTRi8Q+zX4sCbF+IjMpJgi2sc0ZHXuOTda7SLH
	 BAfLY8UUK4OY8RCPTprI5pY4GRRZ6lUhvYn15o8CqJ9mMNFM4Thn1SJeNEKcPTNpYk
	 vaKQT/CfCSHf1wjoKXXAguQFnkfe+bxRKPsZZfiVEcfDTv7twlyBKsE9hpcdDNezik
	 WUDcGwoRueJZypiejw3nkueR0lxz4RlKSpVtgQU34ZshKLw226Yai8hEhJpf5iE+5r
	 fuASnFhuwa1d+CMYNRBAdaBCk49w4ryG0ctwIv5UK52Yk6I42NyNdaG4LN83aHxwtp
	 bE2eq0RsdUvOg==
Message-ID: <8454a55d-bfcc-441a-837e-157123e881fe@kernel.org>
Date: Sat, 19 Apr 2025 06:29:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to
 UIO_MAXIOV
To: SSiwinski@atto.com, Christoph Hellwig <hch@infradead.org>
Cc: bgrove@atto.com, James.Bottomley@hansenpartnership.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, Steve Siwinski <stevensiwinski@gmail.com>
References: <20250411203600.84477-1-ssiwinski@atto.com>
 <Z_yinytV0e_BbNrF@infradead.org>
 <OFA5AB0241.ED5C089D-ON85258C70.0068BDE0-85258C70.00721A7A@atto.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <OFA5AB0241.ED5C089D-ON85258C70.0068BDE0-85258C70.00721A7A@atto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/25 05:46, SSiwinski@atto.com wrote:
> 
> "Christoph Hellwig" <hch@infradead.org> wrote on 04/14/2025 01:52:31 AM:
> 
>> On Fri, Apr 11, 2025 at 04:36:00PM -0400, Steve Siwinski wrote:
>>> The report zones buffer size is currently limited by the HBA's
>>> maximum segment count to ensure the buffer can be mapped. However,
>>> the user-space SG_IO interface further limits the number of iovec
>>> entries to UIO_MAXIOV when allocating a bio.
>>
>> Why does the userspace SG_IO interface matter here?
>> sd_zbc_alloc_report_buffer is only used for the in-kernel
>> ->report_zones call.
> 
> I was referring to the userspace SG_IO limitation (UIO_MAXIOV) in
> bio_kmalloc(), which gets called when the report zones command is
> executed and the buffer mapped in bio_map_kern().
> 
> Perhaps my wording here was poor and this is really a limitation of bio?

sd_zbc_alloc_report_buffer() is called only from sd_zbc_report_zones() which is
the disk ->report_zones() operations, which is NOT called for passthrough
commands. So modifying sd_zbc_alloc_report_buffer() will not help in any way
solving your issue with an SG_IO passthrough report zones command issued by the
user.

For reference, libzbc uses ioctl(SG_GET_SG_TABLESIZE) * sysconf(_SC_PAGESIZE) as
the max buffer size and allocates page aligned buffers to avoid these SG_IO
buffer mapping limitations.

-- 
Damien Le Moal
Western Digital Research
