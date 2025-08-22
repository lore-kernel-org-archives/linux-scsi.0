Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C295F1DE89B;
	Fri, 22 Aug 2025 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755892072; cv=none; b=sN/jj3FGWqUOhXfpQVKJs4yg8N0YKsesmXna6gZqTmcYVY3qMRlp/SPgY37Ij431cZduZGlxf3fsqwNZ0eZFBjH0aC5VOcWDlZrP+8X8ZHtvaMhHojrz2ZC7QckpiNj6lNg4HbacwriBR/PJWvA9aAfhgf1Kv40NITMzQzbpHiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755892072; c=relaxed/simple;
	bh=VFUz7WD1YgTNzevzRIp7UXr/xOtM/q4luKbzZz2jgLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AhgrKlRCcMeblZMuhR530W9QY+qeUcUxmSANOYu4qwSkDVn0a8rx75ajPGp8PIgrukCOTDnmqF0urVqV+CITxNWcWmsw/Zk78xaD9oiNE2A5iRLElbJmXhHvIbM++5MWQ5CvpXF5cawesfUwdwpXMQQ2+l5GkMwMZ1tGMzLSwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZRHWKRPO; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZRHWKRPO"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c7rM95C3lzlgqxy;
	Fri, 22 Aug 2025 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755892068; x=1758484069; bh=MLBOiNYx24swkpiYJhVCDHw2
	FrCecYca5CX2eV7uvAs=; b=ZRHWKRPOtPI7SJBbYJlx5MiYn1juOZi3tFOBmBnc
	/yTo7Maudt8GRku4F7Wks1ad9oJFNTTM76r0taPNPR6Z1A2vhtfUXpwCFfQb0czY
	2tjvQMFn+CM2gyQajM2dinM0hAcLDY1I7KNU63pnKkU84LAiu4YmoXdQemcL0G1y
	giRGK6HAseVXQh96oCl2QIT26PyPObkn+2ndyK0yCmY7S03VDgSEudqbCp2xVhT/
	dVf4+k+GgsF0H7RLqIkMeU4IhWQSKS47RKF7ZrIVpHTP4JKsEcTodFYlSrUOcOLR
	OEl7LzKKJFNvTAB9yDvd7okhpQjpj5sRPH66BD3VNQAJ5g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ccTbk4axFGzl; Fri, 22 Aug 2025 19:47:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c7rM45yNqzlgqxq;
	Fri, 22 Aug 2025 19:47:43 +0000 (UTC)
Message-ID: <660498d6-3526-4f1c-99d8-776fa9967747@acm.org>
Date: Fri, 22 Aug 2025 12:47:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] scsi: sd: Fix build warning in
 sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 dlemoal@kernel.org
References: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
 <20250820144511.15329-2-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250820144511.15329-2-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/25 7:45 AM, Abinash Singh wrote:
> +	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
> +	if (!lim) {
> +		sd_printk(KERN_WARNING, sdkp,
> +			"sd_revalidate_disk: Disk limit allocation failure.\n");
> +		goto out;
> +	}

 From Documentation/process/coding-style.rst:

These generic allocation functions all emit a stack dump on failure when 
used
without __GFP_NOWARN so there is no use in emitting an additional failure
message when NULL is returned.

>   	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
>   	if (!buffer) {
>   		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "

Has this example perhaps been followed? I think it is safe to remove
this sd_printk() statement.

Otherwise this patch looks good to me.

Thanks,

Bart.
