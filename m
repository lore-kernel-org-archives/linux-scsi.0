Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0844265CB1
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420280; cv=none; b=smXSBRbfzChA33OfuPxLhEEOBAVcR6+zHSIB+V36kWT88xUEFn/3eveb+wleHsnO5fGjexBfsot4TebAwsQA4DLmYGJ2ARMfQ2PW4RMTgfKOYZ6PkCDtlTz1ENTZ58LaCPrcH1xwSxcgr7kebrnYs+HmR/1bPayTBdx9UunKtFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420280; c=relaxed/simple;
	bh=WLQW2B8kv3mG9mP7davMCiIhRb42Ed/9jjTtROeNdhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8xssRQ45fkoymx31uWOdu9DunlAr4PHo3lEDg9FQ4bBEY5Ith/EUpBLknpFuQDiIut1IfY6i4++oQQkuolOBobmS2AEzwum9+ero0r5uYRfYuO006xcFsD9v8VDzYirRr30uNg7j6DTCsUeEOBAO+IfRNAB6mfQl21Vt4mDkbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZGfvAlV1; arc=none smtp.client-ip=199.89.3.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZGfvAlV1"
Received: from localhost (localhost [127.0.0.1])
	by 002.mia.mailroute.net (Postfix) with ESMTP id 4Z1pXc5mC7zlssGq;
	Mon, 24 Feb 2025 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740420271; x=1743012272; bh=VXEzAH3U3RM9LVWxyhEVIKY/
	VIq2LLWfLVT9s3KSVNQ=; b=ZGfvAlV1LixKkg3sR6Ma5jbUUYo6FmRKhXL7F+yf
	lYW89Mt6xubiniaPrHD05+RHZrB6ikH20bA+piyxHrs5/3qzSCj5+60LZTgyoeZC
	IqbZXdYeMCi1BiFdIOaxuK9Ux+/KGi1AlWS+ftXmakVh0YJ9QqMd28ysfQAQWgSq
	at+qFJ5YUtGSQzqWcLHRw832ak/thgu+s1fF70vI9QN0ohRF3/L5ttB9Bneaps1s
	TLNZmtxOwH++xcnqMdXt5iwCdCRbn28kNSAmEG+xnPXZFPXSTVdmyNlgwth4myDP
	Tn6csRiznOAv9D6Us+MdZWwvHzrBZsFxCzql8aPpUUpKXg==
X-Virus-Scanned: by MailRoute
Received: from 002.mia.mailroute.net ([127.0.0.1])
 by localhost (002.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Rqs3e2WugSgB; Mon, 24 Feb 2025 18:04:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 002.mia.mailroute.net (Postfix) with ESMTPSA id 4Z1pXZ6KFQzlslJS;
	Mon, 24 Feb 2025 18:04:30 +0000 (UTC)
Message-ID: <e815bc89-269c-44fd-9f43-cd3389a137c7@acm.org>
Date: Mon, 24 Feb 2025 10:04:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: scsi_debug: Remove sdebug_device_access_info
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250224115517.495899-1-john.g.garry@oracle.com>
 <20250224115517.495899-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250224115517.495899-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 3:55 AM, John Garry wrote:
> This structure is not used, so delete it.
> 
> It was originally intended for supporting checking for atomic writes
> overlapping with ongoing reads and writes, but that support never got
> added.
> 
> sbc-4 r22 section 4.29.3.2 "Performing operations during an atomic write
> operation" describes two methods of handling overlapping atomic writes.
> Currently the only method supported is for the ongoing read or write to
> complete.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
