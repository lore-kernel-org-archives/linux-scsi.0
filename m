Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE2828689
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723227107; cv=none; b=mQY2sphsnOwukmGng5k0haF0xQyKetBERRhl8wnc28RZ7jQ+0OcxvU6bKxj53S2xJhGUzHBrxrhpTC0kCEyBjrtc2CdCKuBwO0BFH7+Jmn6dRT6Y8rK5XqVF9YR6VOZaOHu8KZQRZIMjYBX/alECwiVhwlilxNIW1fynhdeZ1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723227107; c=relaxed/simple;
	bh=o3BMLQcgHjSM3Z4OfU+KijBnQh8X/Vh7Zmthsw+qV20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TmzufBmqz3kwu56KYu23RAqUvOkrSGC8Lbcmvgun3/6M1zcHb3Hr81NQFodnU4zZnr7F40aUbkLkmYLnCrBjoznAkSPXBwsjO3OE/phdjk2rVjYG15H/DkXmJ9DHh5Eaxvwm4IkHKpfajUdp4c4qMUKTXO7vi9lQI2vkrfmagTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c8GlOABW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c8GlOABW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgX6g6Jypz6CmM6L;
	Fri,  9 Aug 2024 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723227097; x=1725819098; bh=61BnyPbtDrO8iUWh8JsgAyUD
	VT2He5cesB690zSprdM=; b=c8GlOABWfs7OY3YFmqfVSCRxcjviWxGNtbHGzPAt
	M0tDB+uES1+lfgW+8MAKM416pCYSM8oukdG+Ef36diCIs/GBy0hqrUA9dI4UIW00
	ITtZN7X1+o6O+L0GvBtC3AJm0iq9f6P9XPwowZ45WsJdXeqDkSUFNXkGMq1FAY9D
	MHG0g+1f42YqCWOUwoNVfbDSoYn0ZlaSvx3t7ChC5bM/i+DJOeFHogK0KNTq27zP
	JYC3sVOMuyZ1RY3Hvka4ypmo8UpXvrKJqfXiOPS/He3uYpTpdgzNAaoa6ED3nLPZ
	ysLVC0AVwCjkrXn/B1E7QRFi7z1cUMXE8yjBTUUF5xWLFg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bxgb-3jJZ7eT; Fri,  9 Aug 2024 18:11:37 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgX6b3Qhwz6Cnk9X;
	Fri,  9 Aug 2024 18:11:35 +0000 (UTC)
Message-ID: <1d8d8bcc-e70e-45d1-b722-4931d2a65ae0@acm.org>
Date: Fri, 9 Aug 2024 11:11:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] Driver core: platform: Add
 devm_platform_get_irqs_affinity()
To: John Garry <john.g.garry@oracle.com>, lenb@kernel.org, rjw@rjwysocki.net,
 gregkh@linuxfoundation.org, tglx@linutronix.de, maz@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <1606905417-183214-1-git-send-email-john.garry@huawei.com>
 <1606905417-183214-5-git-send-email-john.garry@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1606905417-183214-5-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/20 2:36 AM, John Garry wrote:
> +	for (i = 0; i < nvec; i++) {
> +		int irq = platform_get_irq(dev, i);
> +		if (irq < 0) {
> +			ret = irq;
> +			goto err_free_devres;
> +		}
> +		ptr->irq[i] = irq;
> +	}

(replying to an email from four years ago)

Why does this function call platform_get_irq(dev, i) instead of
platform_get_irq(dev, affd->pre_vectors + i)? Is there perhaps something
about the hisi_sas driver that I'm missing? I'm asking this because this
function would be useful for UFS controller drivers if the
affd->pre_vectors offset would be added when calling platform_get_irq().

Thanks,

Bart.
