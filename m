Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EDA3A83AC
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787155246; cv=none; b=opVu4m/yzRKeWrGIgIKsCrASpq8rNevHjWWFItfnf98w20RztH9RYOCe1SW0a2i2Cuz49HMiYb0Ij+DI3LK6LRQPZQidInByK6Dghc2Sree/07owmjHG6R1QRPmE9TeUjJW20qFal12vYwcd/P3wTC8hLFU2+2kVpE1KgWHCdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787155246; c=relaxed/simple;
	bh=ZLJV22/bVawEtiT6gqEIzxB9YCziyVSiy4oj/rPgYek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iRuXfepVtIDKOnu2RViWEtK8p+pnOFCLHnuExaXLN4tQ25NZu5r+8nRr/kwQHwUQKl6TJ9CaEn/fTlzv8tTn3xC33MXf0x5zEyjBrMF4S8IHxqNZI+mFlSzEdnOJjioDoAvMsq7ZRNapiMZtab+J+jVqmureLXs0ohB/CKtOUBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eW7lsc0+; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eW7lsc0+"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hQBB41txyz1XM6J9;
	Wed, 19 Aug 2026 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787155242; x=1789747243; bh=sygsUeMqjEbBG+KY6fBUpbXA
	fLwzZ25rMA/0BnuXhN0=; b=eW7lsc0+mozLc6/yBMw6kjdzHAWPC7Ly/Aco3dEc
	gauIWSIx6mTmEw92QliQ9ruK0BMUFNQY8+4v035e9vfWaXg1/D09eW92e9ECtJjE
	OxTfBxOlnZ7J+0uRo0if+neKgnppAIndgpCte6XGXjd064FEWGhXmKVv4dpXZLFD
	Q8jQWL82Rh34sB/VAlM21aauyoGTDoRcYPwUj+JV0M26SVSE3Chszr4rTfh17GhM
	Op6gBWWw5XNGj9rFRD+A12L4Gyohr3ebbNlIY6kD2kIfQWGSBcDRI3K6MpvFQHku
	pDb1d8gORn6TZyHn7O3oVXNvkxA4hcO2lYLG9qqm+scieQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v79sOzpAZTLa; Wed, 19 Aug 2026 16:00:42 +0000 (UTC)
Received: from [100.80.228.34] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hQBB12XJVz1XM318;
	Wed, 19 Aug 2026 16:00:41 +0000 (UTC)
Message-ID: <18c7a0ff-d88d-4865-936a-62e28e8fbb1c@acm.org>
Date: Wed, 19 Aug 2026 09:00:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20260819065850.1358861-1-hch@lst.de>
 <20260819065850.1358861-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260819065850.1358861-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/26 11:58 PM, Christoph Hellwig wrote:
> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
> +		u32 nr_bit_errors, s32 reftag_adjust);

Can the corrupt_lbas() definition be moved here such that the forward
declaration of this function can be removed?

Thanks,

Bart.
