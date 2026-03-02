Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351E22157B;
	Mon,  2 Mar 2026 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772462239; cv=none; b=msgKsD5xTfrCQs5AXLtyCxToc86guEnbOmeow2nJ6CyEESoFQU0wdkC1WtUBmet5hyViyrnEQHydmtenDCsx+cbGUKNStrWKSDXHa1ewucf4HbU39h7OZeBXAFK7M3uXUYbs9zYt2QdEbjx7tbwBmETkYpzrzWQxraV0r2LMkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772462239; c=relaxed/simple;
	bh=LNGhjABTV53LCnoMjs8CdlwcqNvy8aH4C/k/Ph0JSoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oA11usKqalXWskaeHPNjnlMyMqwK1qGs4AadGyiZfzOnonCB/svu61FhiTLmL2T79G/5YmgZ5H5v4ZLZfakSnmrOdLvBBwNLxubeQJ6eyoEi7nfJiGnmm6/WsaE9VNHIE5HdppUiLopLmotN2HHP9wD6xbmvWnEFISpwsLky7T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TF6lZGG3; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TF6lZGG3"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fPhNG03h0z1XM6JN;
	Mon,  2 Mar 2026 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772462235; x=1775054236; bh=bMTvvE2KZ76OnOzwZkmKjZ95
	Au7OV15Hk6kiO/+BwkY=; b=TF6lZGG3qukcXHxtWN6dP05AFknI3DOqwa1qN2G1
	HyfwT/O/XIqf02U03kRVWGU5MQxagponGMJBNRQAUfrJ9MvnjSj0kVbINZifbcCb
	i0Lx0VUMoXnwpiQwzjekELLDE2MRDcUz49Ggo50jqBPbH8fdhSDa7GS/Wl83MdMT
	1ye8bpsbLD7m14HqKXeMZptVwsRKuNBirPUoA7bu+qmHNn+39Zy/XPg6i+Gld6iJ
	+nXJcg/dJ0WcecsUIlTPX0jFqSV0PNO1G9DKVqGv9dZK8+wXcet6F167M4RTY0KT
	PpdhgcbEi53TluU3wXRbTYfIQcMNhmm9h+6ITTFg+yMe3g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CpbIFuuFw8jN; Mon,  2 Mar 2026 14:37:15 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fPhN9273Zz1XM5jn;
	Mon,  2 Mar 2026 14:37:12 +0000 (UTC)
Message-ID: <5ddfed76-1871-480a-ab28-a0462055e417@acm.org>
Date: Mon, 2 Mar 2026 06:37:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix missing lock when read async_scan in
 Scsi_Host
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302121343.1630837-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260302121343.1630837-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 4:13 AM, Chaohai Chen wrote:
> +static bool scsi_test_async_scan(struct Scsi_Host *shost)
> +{
> +	bool async;
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	async = shost->async_scan;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	return async;
> +}

Please use scoped_guard(), e.g. as follows:

static bool scsi_scan_async(struct Scsi_Host *shost)
{
	scoped_guard(spinlock_irqsave, shost->host_lock)
		return shost->async_scan;
}

> +static void scsi_set_async_scan(struct Scsi_Host *shost)
> +{
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	shost->async_scan = 1;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
> +static void scsi_clear_async_scan(struct Scsi_Host *shost)
> +{
> +	unsigned long flags;
> +
> +	lockdep_assert_not_held(shost->host_lock);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	shost->async_scan = 0;
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
Please drop the scsi_set_async_scan() and scsi_clear_async_scan()
functions since these only have one caller.

Thanks,

Bart.
