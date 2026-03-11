Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B3F3E63B6;
	Wed, 11 Mar 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252029; cv=none; b=Nlekd5YwcANOBQNL7HGwkz0Ry2DTtQrc+LfirclA+n7I3RUAQdqUqfSQu0rY3JsWFIHNPKTUdsUDJresSnnNBatf3hTHvW6dlxdsds0qVsOuXt+v1bfUOBRFYt+MMGBKo6gS/vbNnqHN2JEMe93iBOWp6dYqA7Xs/AQq6hr1F4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252029; c=relaxed/simple;
	bh=3Bqe61RpNtPA/mk3G+ZYZN83iIHGqrb8FwOs9Jh7/i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LlD8yaYMJ8oVlxKZwdXS6EumZWDkTJ743+Wa2z/dg111ce97nYBMKwCb8+nyk0S2HxGgW9ew8VwuoKKX6VDWz07qeTECJXKgcbtLI3IuXsjaOtDvkVZNpA75+FZW11p4oTOQ0ZMIND+6J3vbvmOIO9ZHLb11cctpXgsLOxNEVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V1Fpp4h9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V1Fpp4h9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fWJSW48jfzlfl7L;
	Wed, 11 Mar 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773252017; x=1775844018; bh=tvM2hQBnBZ2PM4qZROf41ABf
	lysElOeZjll64D8yv8Y=; b=V1Fpp4h9xVUVgVq7bT0RPnlWtYJeFodbkB/+RPLI
	qAwhAky9T8CBbmdJ7uxeZI1y78EscDTPVYM4m3JexRLRqG1O+jaqkPo26Mkerc5y
	3I+V9DMbQHPH4iIKYgARGqhBdnobJaBuPTvyx9xSF3RW9sSJvxOrTf2x2f8Sp4n0
	/19VtyPybtX59UzXoq66GHooAAQMtvCCgKYmvIJn/1n6AMiSp1zKg5wSviabuyYW
	pUA0PDXrQ71nbOsHU613bGWqBdqqOgSLDNji4QLTlFi8RwoDvjLGDzUUjA2YnNI3
	EbOILaoSqaJXu/moF5CsCKUMkJ0ZF5AWRz8smCTg/BTsgg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DVoJV8QxSZOn; Wed, 11 Mar 2026 18:00:17 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fWJSD3TXNzlfvpG;
	Wed, 11 Mar 2026 18:00:12 +0000 (UTC)
Message-ID: <932d4e59-395f-4022-a2de-874fdea778ac@acm.org>
Date: Wed, 11 Mar 2026 11:00:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] driver core: separate function to shutdown one device
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
 driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
 =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
 Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>,
 "Lombardi, Maurizio" <mlombard@redhat.com>,
 Stuart Hayes <stuart.w.hayes@gmail.com>,
 Laurence Oberman <loberman@redhat.com>, Marco Elver <elver@google.com>
References: <20260311171209.9205-1-djeffery@redhat.com>
 <20260311171209.9205-2-djeffery@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260311171209.9205-2-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/26 10:12 AM, David Jeffery wrote:
> +static void shutdown_one_device(struct device *dev)
> +{
> +	/* hold lock to avoid race with probe/release */
> +	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> +		device_lock(dev->parent);
> +	device_lock(dev);
> +
> +	/* Don't allow any more runtime suspends */
> +	pm_runtime_get_noresume(dev);
> +	pm_runtime_barrier(dev);
> +
> +	if (dev->class && dev->class->shutdown_pre) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown_pre\n");
> +		dev->class->shutdown_pre(dev);
> +	}
> +	if (dev->bus && dev->bus->shutdown) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown\n");
> +		dev->bus->shutdown(dev);
> +	} else if (dev->driver && dev->driver->shutdown) {
> +		if (initcall_debug)
> +			dev_info(dev, "shutdown\n");
> +		dev->driver->shutdown(dev);
> +	}
> +
> +	device_unlock(dev);
> +	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> +		device_unlock(dev->parent);
> +
> +	put_device(dev->parent);
> +	put_device(dev);
> +}

Please keep the following code in the caller:

	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
		device_lock(dev->parent);

	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
		device_unlock(dev->parent);

	put_device(dev->parent);
	put_device(dev);

Additionally, please make sure that the caller is made compatible with
lock context analysis (see also
https://lore.kernel.org/all/20250206181711.1902989-1-elver@google.com/).
All that is required to make this code compatible with lock context
analysis is to organize it as follows:

	if (dev->parent && dev->bus && dev->bus->need_parent_lock) {
		device_lock(dev->parent);
		shutdown_one_device(dev);
		device_unlock(dev->parent);
	} else {
		shutdown_one_device(dev);
	}

Thanks,

Bart.
