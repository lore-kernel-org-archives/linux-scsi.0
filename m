Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08047433CA;
	Thu, 30 May 2024 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098437; cv=none; b=CR55GeR5xvNTe9rPNfiz7i6WvuusRXEs9Uxpr5IjU46Qi6XVQKh7YCXaV2GqbERp56UKJdewldPA5dwDHPNJijr5cc2HU0BwHJ6ARrwmS0MbLBcsdG4rngBsPsrSuyw292SL8uATmAolnp+Iadz2fnjBJ2CKONHBq8eh2j1qSsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098437; c=relaxed/simple;
	bh=T4P6Ag1Go7nBQSOYVyvPB8OAHJbSm/JWRXRwZA3iazE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aMi3vTz3W0cxBF2G/aHQ/Rz78koTEvGL718AcYVrY+dEwq/DaWgbBrlZubfGFCr1CitXS8vCqKO/y17/oJtfYenES9WOVwByQIDMHOIn97mVNJiK+H/7zk0amz49CPWM/Z+M+NoCn/Ce8Z3Nk97NmLq00hB4ZwwRV49j9TaqJvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LeBK1nTD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LeBK1nTD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vqxbk6tSqz6Cnk9T;
	Thu, 30 May 2024 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717098428; x=1719690429; bh=gIZD+XBfeoiXCs+vsIOauc0J
	AFtw0ViQpf0RwIfdqeI=; b=LeBK1nTDoaUU8KAvyoiidxeqI1H8VC7yltJTPW4y
	XkYIFoLA0Xsv871K8AMKv1pruRb7L5Vojxd3TXpVjOmpzCKnxzsAzPwXavUCLmiG
	5Io9SoOjP5YKnml8f0lVeIWDw6umtR8N2JBzgwVMlGiuo36RH4kWKMRKIp7SrKHq
	49OVo1TUglVJnZ/FHnf1DulkWr6IflF9OncnRDnJq9pnqGyM16QVtbsNy1ahrI3q
	GKMmq9vzmNV1PmpyA8YGpgIcN378oHvXWXKo5o6AkOKWk1xSeOKUZJjERmaxIpao
	1jHLbCjdnG+qM70N4r3Tjg99XIgFTQPKTwcpUYGYirs6RQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tO0K_eu1GhdP; Thu, 30 May 2024 19:47:08 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqxbZ4pbBz6Cnk9F;
	Thu, 30 May 2024 19:47:06 +0000 (UTC)
Message-ID: <8d927897-0436-4f47-9b03-c3e9adb90f40@acm.org>
Date: Thu, 30 May 2024 12:47:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for
 max_sectors
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-3-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> The soft max_sectors limit is normally capped by the hardware limits and
> an arbitrary upper limit enforced by the kernel, but can be modified by
> the user.  A few drivers want to increase this limit (nbd, rbd) or
> adjust it up or down based on hardware capabilities (sd).
> 
> Change blk_validate_limits to default max_sectors to the optimal I/O
> size, or upgrade it to the preferred minimal I/O size if that is
> larger than the kernel default if no optimal I/O size is provided based
> on the logic in the SD driver.
> 
> This keeps the existing kernel default for drivers that do not provide
> an io_opt or very big io_min value, but picks a much more useful
> default for those who provide these hints, and allows to remove the
> hacks to set the user max_sectors limit in nbd, rbd and sd.
> 
> Note that rd picks a different value for the optimal I/O size vs the
             ^^
             rbd?

> user max_sectors value, so this is a bit of a behavior change that
> could use careful review from people familiar with rbd.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

