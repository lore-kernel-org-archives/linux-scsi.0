Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C61F1C8FD0;
	Wed, 18 Sep 2024 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726681873; cv=none; b=pCx1IllJe3ZPkFoGqnD3VCyA3q84ywSoHRe7nT/gtUgjjRolmRLW0YeZWxRgNbj3aUEeGcVsBkfhtEpjnh6s10vRO4gsEEFMuVGwWw8SkEUdvD/bodNO9znx6LuA60ts0QOC7ZL8RZqMJMXlDriphrHYDAHgvG2QSCAlmJRWh08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726681873; c=relaxed/simple;
	bh=7B/iHqhbByzLlGQndN/dmYDptGaGPOhuCn4rJOLYm9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kX+ecpwXTkGzrOiFoPfFZs/3nk5I8PWFok1XLxJH7AggKnK+93tBHg+GTfwIuSll8xWQb227SYF2uxvVa+SRto2W1/6L3vfCY/sdeOZI27NXZcoQ5ivQxLTl0ICm7B5FfgFOuJAr4fyJGssbq5RMRsMhWF4WS3DKiWe6Olqgwt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eerbl3rT; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eerbl3rT"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X85mT2QhYzlgMVV;
	Wed, 18 Sep 2024 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726681863; x=1729273864; bh=7hSJKXInXl33D9eUWm0V2yKe
	+d256sueEpI32nhLwfU=; b=eerbl3rTnadd/Q4K+2VjBuAVw27nyNIEJ0KmmAeI
	fD/2uZAyHNYD8BFHX54BNJY8BdMEjYKmlJJMYPisprJtHzDTFdThvRUYBhlzdemP
	LttnZsoLG0+gvo9QvjKxCIjxma+kIeQqHn5Bv4Q3Tk6IqGAZhcXd3EyqYSX/n1A6
	bcltkQ8pr26cP61Ep6N3LLPxa5Jl11hqVTvEgd/DEtB86ggXxLPdGevooyedem4+
	HrInYVMZOHpUoZbPmW5/kK5crwpC+XLMRffhZ/6nqr8Lt+Lh6kFA54cIpesHDICd
	kVNPruv/ZEWaGg59VOhiT+u82LIrRdVCaC3Fp9TIBOMRrQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lxQ9TncDLNTt; Wed, 18 Sep 2024 17:51:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X85mQ65jwzlgMVT;
	Wed, 18 Sep 2024 17:51:02 +0000 (UTC)
Message-ID: <6bb14e23-7711-4d27-8efa-4e60cd737fa5@acm.org>
Date: Wed, 18 Sep 2024 10:51:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240915074842.4111336-1-avri.altman@wdc.com>
 <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
 <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b7a05da9-7a80-42f7-bf95-379d78f3296b@acm.org>
 <DM6PR04MB6575F0F368FD49B191CAD7D4FC622@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F0F368FD49B191CAD7D4FC622@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/24 11:03 PM, Avri Altman wrote:
> My proposal is making 4 changes, attending the 5 upiu types:
>   1) Zero query upiu and nop upiu in ufshcd_compose_devman_upiu
>   2) zero command upiu in ufshcd_comp_scsi_upiu
>   3) zero raw query upiu in ufshcd_issue_devman_upiu_cmd, and
>   4) zero rpmb extended header (raw command upiu) in ufshcd_advanced_rpmb_req_handler
> 
> Your proposal is making 3 changes:
>   - zero query upiu in ufshcd_prepare_utp_query_req_upiu
>   - zero nop upiu in ufshcd_prepare_utp_nop_upiu
>   - zero command upiu in ufshcd_prepare_utp_scsi_cmd_upiu
> And you haven't zero the raw query upiu nor the rpmb extended header .
  Hi Avri,

Would it be possible to combine our patches in such a way that all UPIU
types are covered and such that the memset() calls for query, nop and
command UPIUs occur in the functions that initialize *ucd_req_ptr->header?

Thanks,

Bart.
