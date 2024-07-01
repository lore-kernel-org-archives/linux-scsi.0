Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABA516631C;
	Mon,  1 Jul 2024 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719853722; cv=none; b=lZlJKFVYdyNe+pGs5X1d4W7R8qwrBMt8LS8RblgVOhNehRZ5h/PMudIffnFdXjzX4qD/CsxogLcbcMMYRce3tmqXqpBCyujzAuKD3PQ6KGGLmCSgkLiqGJ88+NuzkzHCRzZuUVxvoCZzlamPch6ac5MFhia9aQWDMuLEqTAjTYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719853722; c=relaxed/simple;
	bh=LR+3P7CDYYJd7E55GaXBx3JFMH0DDOv1JfGvEou71b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUA3eX40n9y8UPO9jGrs8lUFfNPswvk0tgm1sYmwpRxsNRTLwuAKcdX545j1sp26w9B3HvzLoXnhJ1LXW27i5hElE2I4Hw0e+PZqZrfIm1tAI7nRfEYGeLucwxXFiqtAnjDICzGTkTWXde/1KznxrnGWuTNCpvnJXYhllpvGyQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aIEfUO2C; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aIEfUO2C"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCXZ03nTczlnNFJ;
	Mon,  1 Jul 2024 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719853718; x=1722445719; bh=LR+3P7CDYYJd7E55GaXBx3JF
	MH0DDOv1JfGvEou71b4=; b=aIEfUO2Cc3UNs1KSNjUYxHiOyj/5i4T85hKK9rny
	dEL9Tt2s4lrXt1Omt/mU3Ah808HkBzYMlcVYbZ+c2HF4lnmvfcNqyvFkiykmz+Lf
	78rsZrBXhWs/ChquTtT3vyLj/akMHCoQj507oZrkPrRv3UyYeb2HDRkqxltFUAj/
	Quym+RS+NFnP0JzHEymdLN7o0S1SL+hs3MwzQqaGPZWFelC45cNqc5iPudsdwU4z
	eOj+MzmBkHWQ4ilgue90QciuJ5j1qwB0Iu3AY8f5cGF550C9Sd9kdNUegKnlrm0K
	Ch7ohLceeyoYLB5xvD93T1Ahfpo8+8XevNUDu5vM0UG4pQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id n8iCso7WLsmh; Mon,  1 Jul 2024 17:08:38 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCXYx15tkzlmb8s;
	Mon,  1 Jul 2024 17:08:36 +0000 (UTC)
Message-ID: <f3e253f5-ece4-4ffe-9112-cd763a0f1ce5@acm.org>
Date: Mon, 1 Jul 2024 10:08:34 -0700
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

Please explain the full effect of this patch in the patch description. I
think this patch causes a potential read of uninitialized data (sshdr)
to be skipped if scsi_execute_cmd() returns a negative value. Do you
agree with this?

Thanks,

Bart.

