Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2138D155742;
	Thu, 23 Jan 2025 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737657455; cv=none; b=cA+2pLaThoCdFhyyw70h1aZRCAetgK/aJsrPz73q0RaV6SCrdM7198h7udBjnoMU8W2LiJAC18RNLj3faSnZdqXj3/K3XdovJdSz4FldLFvQBFpkwxFAJUaxwC+pnrYHE+qdJRAaulHldn6+Cgn/RDsVYfC62l3RTIyOlHhynGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737657455; c=relaxed/simple;
	bh=m7duHxIbBH3L3SmBqgno07ypccOnWOZitvYRcmczPq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qM4TH0F+GdgYfncgOYFg1BrldTMUaVDchDuJ4yyyynRffdJzR1QBwWTl3/Yp8y8jsKuiYs9jDBfT3d/Jd5n4GFECpKxWflcFAGtktQRs2rR2Q8rPprJ24ECpQcgm7n9Dhz+Zx6XduXSfh0IiLPi3hpzs/kOwLWVfb5+gsxD1euE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=m0Y4ZWW+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="m0Y4ZWW+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yf8nM52Bzzlfw6N;
	Thu, 23 Jan 2025 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737657444; x=1740249445; bh=Sc1C6DNv+URymf11ILQ4Xa34
	vJDaZ5LuqTzQ1+bijsc=; b=m0Y4ZWW+qQfWo8M/eMKsloQ5vlR0fzXwncyUR3ml
	B5YmBCAxdgGGNgaF6yn3FEC5RAX/siumCwBVzMtB9I70qUAoTpgLD7O+x5nrLNrT
	pM2livktQJub+0eprAW5LFhVzWYaRln2jVHuhvfSJGorm16zMOPyi+aZymVs6EIT
	cSOUZvaMdOGw97QhDOqOgYKcsOZBP9xhvN2LHjNuS/Jtvbqc2CcyDGBawqq1UDlA
	bA7JEwjnjRVZDwTlN2CS1kLLB1FPZhG7uKiTJyiLr1fT3pkxcAEKCyXp9XaSgZGW
	0f4zANShcChknaUlH5lXVxGuzFStwPpZO01eQLKn0VhBZw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gMKkBHSa3s2R; Thu, 23 Jan 2025 18:37:24 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yf8nG614bzlgVnN;
	Thu, 23 Jan 2025 18:37:22 +0000 (UTC)
Message-ID: <8a714674-fecf-4067-97e4-59e28816c854@acm.org>
Date: Thu, 23 Jan 2025 10:37:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Can Guo <cang@qti.qualcomm.com>
References: <20250122143605.3804506-1-avri.altman@wdc.com>
 <52d287b6-f6e4-4644-aef8-2c22bff59613@acm.org>
 <DM6PR04MB657584F352A1AD45FBD7B23DFCE02@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657584F352A1AD45FBD7B23DFCE02@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/25 11:31 PM, Avri Altman wrote:
>> On 1/22/25 6:36 AM, Avri Altman wrote:
>>> +static ssize_t
>>> +clkgate_enable_show(struct device *dev, struct device_attribute *attr,
>>> +                 char *buf)
>>> +{
>>
>> The above formatting does not conform to the Linux kernel coding style.
>> Please fix this, e.g. by running git clang-format HEAD^ && git commit --amend
>> on the git branch with this patch.
> Done.
> AFAIK, there hasn't been a formal announcement that `clang-format` should replace `checkpatch` for Linux kernel development.
> And yes, while checkpatch --strict accepted the above formatting, clang-format did make changes.

Hi Avri,

Nobody ever required to use clang-format as far as I know.

With my email I was referring to the requirement that the return type
and the function name occur on the same line.

Thanks,

Bart.

