Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB6329399;
	Tue, 25 Nov 2025 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089120; cv=none; b=OrC9WroelhDvTJZZjXp2s1uw7CKURQVZggM4PpUD0fvVjuklSmxHViAqdzoNei1mNpslalT8bgTPghULpfp+MBQRiZN7n3yjZgBbXRyQtc6F89LN8uDBVCZqd1WJf6iL4oJJtPKc6B5V0bY8rcJQZnlUzxcjTJKZtb968SbuTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089120; c=relaxed/simple;
	bh=JsPiY48gVni81nFmxo5ZKJ3j/BURCL5IAHQ6U3e12BA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/RfU/RohS8GVhPgIv/WrioU8awJ6UGgylJGu4JkV49+IQzsWeKAOpQNJdg/KSGl6y87dfrx5hdk7eAfriQtG11Imn6G3qA6afOwxi80fMtX04vVaFSRQMKvl2wVKykZEPn1P0/Y1bbu0+JDS95Pk5kF2/dy3Y9/xSpiEBGo6r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ts/4J0uK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ts/4J0uK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dG7pj0HggzlgqjB;
	Tue, 25 Nov 2025 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764089115; x=1766681116; bh=83S9Y/jX41TLa+oX6NEFO3Lz
	3Vl7FZrP6eE+96i89CQ=; b=Ts/4J0uKydjsjkXLNFHCHT3PfVeRtioe+HqX5s/j
	3H2ASkGx+13Yen8keurKUwypW8i7bHjyUUPtWUcly17KBQultGmQQkuQqN1WcpnX
	SgUPxJk9qxrQl65k0BBzdbC69k1DF+gdecQkEpTUR0FCVff/pinQBVbE6Nhjrxom
	KHSk4tuguZJgNNNYjnHIb/g1DS7x8cEvdPYzIvHetjmvz79FmZEVMGJEG3/RPsZB
	MrA19mV3ZyKNz5Nx9JhtTm+nUJyA5TqvVsZK3IAkIOKUTm705Ibv1n2Du8hyayY/
	DRdkWw7MEJc2L6fIta1sIrmymo3uM65eOvyiE3lWcy9f8Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MeWO2MhkFGku; Tue, 25 Nov 2025 16:45:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dG7pb2qPGzlgqj6;
	Tue, 25 Nov 2025 16:45:10 +0000 (UTC)
Message-ID: <bca17c65-347a-4233-a1d9-e86605f1c86d@acm.org>
Date: Tue, 25 Nov 2025 08:45:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Increase SCSI IOPS
To: Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>
References: <20251124182201.737160-1-bvanassche@acm.org>
 <aSVmxETXzs5kOVG3@ryzen>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aSVmxETXzs5kOVG3@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/25 1:20 AM, Niklas Cassel wrote:
> The subject is:
> [PATCH v2 0/5] Increase SCSI IOPS
> 
> AFAICT, you already sent a v2 series a few days ago:
> https://lore.kernel.org/linux-scsi/20251117225205.2024479-1-bvanassche@acm.org/
> 
> I assume that you simply forgot to increase the version count.

Correct.
> If you respin, perhaps label it as v4, to make things less confusing.

Sure, I will do that.

Thanks,

Bart.
