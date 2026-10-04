Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181244A5C32
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 22:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791153607; cv=none; b=BCYibd44B6VbNfxmcpgwS8KXCdJHITKleC2ajfaYmLDlXxkphTHhPaIoCYvZEwIwcntvIJPQuDJ7K6ksXmc+TwjKBpkRkM/z2feDNXWKHeo0kAt/lL/WrwzVsUkg2yHPOFXiygrWviNgZHr+yrS8LHJqgpRo0fEeKwcBFBQH4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791153607; c=relaxed/simple;
	bh=JU1JAJMb1XlfMfJapZ6Nmj+7Gisuv/cAWJ0RveR3vx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lNBlcL6CMCWpK+UoFqre7FVyBAyWb+p2UT43Mp3kiaXvj5Qi4Nh5keaJYkQ3erotljcxYZCd/+22U6AzBPuLmrQiyGVrSLBe3TLV/VEeycqePu9Ho24P3mX6SeGh8j7K53fvtpfzNNEHDTsVJfIhZoarAq0Zur0fzoNJhEiUj18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uVe7LBWT; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uVe7LBWT"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hycsW5tydzlfvpb;
	Sun,  4 Oct 2026 22:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791153598; x=1793745599; bh=/jgVzMM0D5xuKx11J21qdNN+
	+60Vei61y1tPI1/3ZXs=; b=uVe7LBWTysWS/bc459poWTiaN2Pm6DE5YR8VHtlK
	c/ewC9xg2+6tNXIx2reW5Mr1KTw703Sjyi0YwuKccxLsi2jLoZAB1d34KbB95QLv
	DJGXh5JTOUogXyvUg2Z/0IU1aC7QxhR9aTNluDFY/EaOGrI0UinMDuTZfRbTHY2p
	6WI+kfq0y+i5xW6acr/CjcjJEuCKIsYnpOVk9DrbFGbrs2PJqkS4rAZJnpUYXlqO
	VPtPi7HVnWVm3RdsYvbD/z+YviwJycKn18Enyfpv1NbUR2yVToKWLCDsJ7KvS78o
	s2LhqOJmiiiBZtm0RoXtNuM5VDyDkc5QFaDXTb8b5sYKWQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UwSrNviQZotM; Sun,  4 Oct 2026 22:39:58 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hycsT1Yf2zlfvpT;
	Sun,  4 Oct 2026 22:39:56 +0000 (UTC)
Message-ID: <2fe7fd58-fda8-45db-830f-3197999a2538@acm.org>
Date: Sun, 4 Oct 2026 15:39:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] scsi_debug: Enable lock context analysis
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <cover.1790723966.git.bvanassche@acm.org>
 <yq1a4oulv5e.fsf@mail.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1a4oulv5e.fsf@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/26 7:24 AM, Martin K. Petersen (Oracle) wrote:
>> This patch series fixes a locking bug in the scsi_debug driver and
>> enables lock context analysis.
>>
>> Please consider this patch series for the next merge window.
> 
> There are several conflicts wrt. Niklas' zoned write series. Please
> rebase, thanks!

Is Niklas' series already available on kernel.org? This is what I see:

$ git fetch mkp-scsi && git show --format=fuller mkp-scsi/for-next |
     grep ^CommitDate
CommitDate: Tue Sep 22 22:29:47 2026 -0400

Thanks,

Bart.
