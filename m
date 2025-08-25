Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01719D8BC;
	Mon, 25 Aug 2025 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756149999; cv=none; b=Jfh/bamnD2BP1UkFzO1NlKXdSsrTRWNWF0+5QnK5FFI6O8Qzh7HWsojdPlu6aAPxxkj3Q79WyIsC0+8qkcm5oTGRBQ5Y5eXrdWxvBZff0CVY1Y2A5ATuouN/Snfs4n1RdQQYBBdrzeI4HvljFsY7BMk33E9lP/vUJ3N/9S9Vv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756149999; c=relaxed/simple;
	bh=HcN4vR8LIE+L8fhTUYMYP+bPSXdz7hVSdrqL/p2ORGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JaAKKyy0Q4oSy5ntDPhZpXkppPpueuXYRgDEYXgv0SLU1cIc9UXnMgAztrCN8NL6GvjXXeSdyTf5IcO1BtmemJQjJSftlB87vAteqZv8KiHYBqVBzoss52ALl3l0UUXsUUmkUJ1Di63pM/+cEplYUrUPpmtqlW9WaUGd+tFRhiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nFT4MksL; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nFT4MksL"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c9glJ16w1zm1742;
	Mon, 25 Aug 2025 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756149994; x=1758741995; bh=HcN4vR8LIE+L8fhTUYMYP+bP
	SXdz7hVSdrqL/p2ORGw=; b=nFT4MksLKaxE5rk6UlTD5a2+VDSeSApGacC+pRkJ
	i7jyoy42AhdA2aFC/fVok3a7KziUc4W2TezeJgy2XqyRWyJVQ3Gy1mp8XAwVcFE0
	faJapR3bOyuqWyExgrf6ulhMXy5XAa4KO77xuM3+jyPlXarAO/M7UliNYJtknblr
	uJM4MHi/I2KiETZ708AgYKEPUqh/6vB2NwtzAbZd/pg/odAS9G97wVaKP/c3hS1b
	g+DRqwEI7llEHfoXjjSnFuMEn8UAUDELl3iJ9J0x8qZ80avBVcpY22u5xKydS1Fp
	VTru76GCKL7dEJ4EWmMej7nzKpHf/8UuvtkSveH6k6kPdQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UUCelCwczmzh; Mon, 25 Aug 2025 19:26:34 +0000 (UTC)
Received: from [10.167.82.167] (unknown [216.9.110.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c9glB0zZJzm0yTL;
	Mon, 25 Aug 2025 19:26:29 +0000 (UTC)
Message-ID: <a78bcbfc-a81f-4266-a646-82fad1044f79@acm.org>
Date: Mon, 25 Aug 2025 12:26:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/3] scsi: sd: Remove redundant printk after kmalloc
 failure
To: Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, dlemoal@kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
 <20250825183940.13211-3-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250825183940.13211-3-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/25 11:39 AM, Abinash Singh wrote:
> Remove the unnecessary sd_printk() call. Control flow is unchanged.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
