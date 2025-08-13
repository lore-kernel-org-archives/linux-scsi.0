Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805FC20EB
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 00:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755043359; cv=none; b=nevm/Ia2nTk4LAkSKWBLI1GmXvb7fgON08IFnZdgDmFm1jGs84ugu8iIdKrHuHflKVzyKtFDk6kGXCbhPg51p4SbMHM1F48LcG7dlMkodEsHLc7Kpf1iHWlEj7Ll0Vutoc3q9wk2fJOLtzuMhpevctgHjXG+shWxxiI9FhjoPxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755043359; c=relaxed/simple;
	bh=F6+E5JKyC735G+wUW7i+UbBTiKCGH2EUdiFqyJeZnII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3dbLQfLVQXyXzSYraQKD4/FRJrRuvKOfuVCAae1+rJ3atUSa5PvONBRqm6jr6BHRRHiw3SDssNh5ANNJTGvXM/VCCZgNmpNQG7Y051BEp25ZtX3GIA7izILGNdaMLujAtLUIHb2m0/CcDzZjS4mmvLlQpmeaDXYogRKck2ANpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=im+qEepD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="im+qEepD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c1pTl1hsGzlgqV4;
	Wed, 13 Aug 2025 00:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755043351; x=1757635352; bh=26pgtWLdEgGKlPQHJi31paXy
	ixX17g2NNp6WaGsrJSE=; b=im+qEepDXtIwoJ0LX+yR+eIlt0k2ScJ7JHJ70lR0
	SQHH3hHKhtU3OrfmdTv39K3bgPm9oNXLvWWC/qmJRImpRzeVAC2rGj8bhs+Ngf7V
	IEsJ0cKOO5zLuIMw/ZhbWZMOTGr5rFcv9Z02RipJGivIgbnYHpO61pBbT66B+fNM
	Ed3CoQ9MRpC3rkQ5enuaCrdojRA5IF70mPS6jYjAB31EKABe/ZzNwFaqQ+7ZtKX0
	49t+bzNDimkzsqhZEP7WSQFhFoXQjCVcwkar+E8bgcnB++Z7keMAKHcVAhIUcdV/
	0jU7bmqWfc6MhN7Tly9zWhLTloWhnQpu+sBwLnd/L9CBYg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c4EaZHn1DjMP; Wed, 13 Aug 2025 00:02:31 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1pTc1FYtzlvBYR;
	Wed, 13 Aug 2025 00:02:27 +0000 (UTC)
Message-ID: <1a1dd344-dbc5-45f0-869c-6207e19b44b8@acm.org>
Date: Tue, 12 Aug 2025 17:02:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250716184833.67055-1-emilne@redhat.com>
 <20250716184833.67055-3-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716184833.67055-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 11:48 AM, Ewan D. Milne wrote:
> @@ -2712,7 +2713,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   
>   	if (the_result) {
>   		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
> -		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
> +		read_capacity_error(sdkp, sdp, &sshdr, the_result);
>   		return -EINVAL;
>   	}
>   

Readability of read_capacity_16() would improve if the 'sense_valid'
declaration would be moved into the only scope where it is used.
Otherwise this patch looks good to me.

Bart.
