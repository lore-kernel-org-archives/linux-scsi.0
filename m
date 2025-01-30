Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9893F1F153B;
	Thu, 30 Jan 2025 22:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738276610; cv=none; b=D5f1aK/ivaBlrb4xNVsJ+YJTin9cgHdEUQyBqqYNwj7VbNjV2T259nEDkrd+RLp9Fam0hBJqY9GZbnqI3oN0p4KLDqppr79ZNtHLmCJr0fi3UxFxarR52X+oZi1a/ZvNLWpj6AtWpwaZf9nQaMkXSveGDgA4KBOwf1z+SIHYvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738276610; c=relaxed/simple;
	bh=xssy6lDsWSDz5ehuUs9q6oXzvRmyKgv/FvxTH9ueGE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1ssNzXpr6686qJlhXWIMcEatFJqmGuxeGFoDhp9RAgKZ11Bkwpbs5zkMZtQz7V6ypXLQljWMa5qmQo1Yms+4lt53rzC8/54/mXv8DejE9PztSJtYfqaV9EK5QSm3xkmeYmKjqJbXBAeiOtP+BNgls3DO4VycTj49vmsF5jlEqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nV1JYgcV; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nV1JYgcV"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YkYmB1pt8z6CmQtQ;
	Thu, 30 Jan 2025 22:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738276599; x=1740868600; bh=SVxKiB5XIFUumjcBJgKkx9ru
	LmeBxixL8UJ+RXA/om4=; b=nV1JYgcVhaZAEsUdlewpRPBBsi6tAWPy+La1v3JT
	8LVESSmk9PBNO2xmW2AE5KnQ4WnLektLk3V8IM2EjxDx07ykdgmCSi5hI5kcusfN
	sdohd0oalrmHGC1LiqT0UV0ZvJ9xnW765mRHOwMpj52XC47zd6K7NKvSLTtJV92d
	LMrqC9P11De/GOq/S7gK6HqAjcQ3J4pJG2KatzWdv24krWdB/j/KOobEPEPPha/+
	eD3rhgpUL056wHTX+xR4K/vxqiJVQCzxOD0oPA3rLRmWv9LDqZb7vr9iqmWxZtcO
	wF7rWS3fQZ5tFv+kIL9qNRzE2AWMeA+yQ0JaN5nsO7ThJA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1zK9rWL-bHmK; Thu, 30 Jan 2025 22:36:39 +0000 (UTC)
Received: from [100.118.141.189] (unknown [104.135.204.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YkYm60RRBz6CmQwN;
	Thu, 30 Jan 2025 22:36:37 +0000 (UTC)
Message-ID: <00557746-b7c6-4b34-ada7-0b4b8a21d98a@acm.org>
Date: Thu, 30 Jan 2025 14:36:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Do not retry I/Os during depopulation
To: Igor Pylypiv <ipylypiv@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250130222632.1462218-1-ipylypiv@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250130222632.1462218-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 2:26 PM, Igor Pylypiv wrote:
> Fail I/Os instead of retry to prevent user space processes from being
> blocked on the I/O completion for several minutes.
> 
> Retrying I/Os during "depopulation in progress" or "depopulation restore
> in progress" results in a continuous retry loop until the depopulation
> completes or until the I/O retry loop is aborted due to a timeout by
> the scsi_cmd_runtime_exceeced().
> 
> Depopulation is slow and can take 24+ hours to complete on 20+ TB HDDs.
> Most I/Os in the depopulation retry loop end up taking several minutes
> before returning the failure to user space.

Since this patch is a bug fix, please add Fixes: and Cc: stable tags.

Thanks,

Bart.
