Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72F16DED9;
	Mon,  1 Jul 2024 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719852660; cv=none; b=ZMXD1ILNIr/aJFZFTsiplAtrqrHzXeFgy9Vq5++h2MiSfHKrwMx+X5h1cIshi6c5OWdQhdZ/MrYvMj7pXf7yyiEp2ZmgWl0Yi+MJYktdcO1lt5NuYKNNy+BFmoha1PkN7SgEhRn8I+Uc5D/1lHBNnYtcksAjwHLXMBaELPyIdck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719852660; c=relaxed/simple;
	bh=zOFLftViufapuivx3YffdETelgmIgRHdwp9+F6+2Qqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GqCWwOlMEWhyIn5hlMZ2WzIfh3Yy2CHK27zi95PhuNmZ9HaKiuwa9wZUDrgviQ/mMR2OD4Up5/JZjJIOIFNnNtuANyOEDjc8+y+43fvA5L3/Cuat4uA2pz0UEEa1UY7MZPqQhzVSZgmwJPhvCLEQ4rxbPiNwcMFdB6RvqCBYNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CV6uAFCE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CV6uAFCE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WCX9Z2Wdxz6CmSMs;
	Mon,  1 Jul 2024 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719852656; x=1722444657; bh=Y+bFqVUrYtpwvsoBRpn7yP4H
	1jwZfKeHmCcUEqtPACI=; b=CV6uAFCEdExtDdDfdnCWsj0FpMbzUF1ez3lQlwBz
	eKQrtYoKnd5WgFoMK8vtivhW1wtS/bKxmlGzoootnpUdsZwI5QqIFThF9Pu/Tl3Z
	jKBRaH/4o1Xs4k8esXNP2I3J+OCnmInVEgz8UG4SvbXdOMb5LXWXz9ByoZpHhrQF
	HTrEhEaR8ysrq3HX/M3W9Jjf4TI6sxJUbtyGFQGnLAtYxBiSZP01xVEgLtcnQFtC
	UJWLLrIuA+wjZEpgVM8big03VBJdsER4ykrDNMZ48TK8/ct9CMWP9f4Ketn+pRSL
	z1sQ/zCaPoP3G3eBTnRSDN6Wpc5ZKvXn+P1PPHMg+spf8g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HjoeCZ1Q7Zkc; Mon,  1 Jul 2024 16:50:56 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WCX9W2TpKz6Cp2tZ;
	Mon,  1 Jul 2024 16:50:55 +0000 (UTC)
Message-ID: <230c996d-536c-4d7f-9098-2e03203482e4@acm.org>
Date: Mon, 1 Jul 2024 09:50:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Fix unsigned expression compared with zero
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20240701090603.127783-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240701090603.127783-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/24 2:06 AM, Jiapeng Chong wrote:
> The return value from the call to scsi_execute_cmd() is int. However, the
> return value is being assigned to an unsigned int variable 'the_result',
> so making 'the_result' an int.
> 
> ./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared with zero: the_result > 0.

Since this is a bug fix, please add Cc: stable and Fixes: tags.

Thanks,

Bart.

