Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332551D1736
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038142; cv=none; b=NSbx87LFQrMdAm1EbkbA29afR9W8x9G+P6EparUxgV1d1MLHLIvL93M27xOEFbAcUkg8nbez9Q+/ft2M5bt7QA+6dZVOnj3CrL42Vz6+feVBT1y+SqCUYKpW44DOqQYSACotbCc++bDyczrjINycqqBIJ5omvv9ugCR6aTRmD6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038142; c=relaxed/simple;
	bh=M5k0AqiKyOFxU9Ojr3ShSDioWPLbKPMAjgAzK4nea2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uL8d140O/d87guTI11ihLG7OnS4RHeDbSf6L0H0CF0ZaJwuG5ab6mmtr4CNiGW3FnoQs0ExI17aG0A0D7ixjYNU4MTFQI9rVgPF9VrQukrb2tUzi4K102g9KRb7ymqvnXD1RiKdzQupiWgIpJimOsU7DsD9SkmfaVvn+ir7AksI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TnTlW2v6; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TnTlW2v6"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtBdm3N5HzlgT1K;
	Tue, 19 Nov 2024 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732038138; x=1734630139; bh=M5k0AqiKyOFxU9Ojr3ShSDio
	WPLbKPMAjgAzK4nea2M=; b=TnTlW2v6Xpjc9GqVHSEnWy1WEd7dvXK+yWQtj9rh
	GzD7gTwURnKUYC8ftMWpQ54Dfw/URLb6J8Ashws7FMkOp+7Ax3mkxAAmChY319iK
	oMzB24v66yyfFr+la9B5KZIzfvj/4UVJsxBOJnstlFi99ij55/EwCUHq8JoG/v3M
	LWePBXdS2qAF7fqdESLkAWpSt1tV/BBYNYvOo+J9GJ0gSjWZIBLyNKVnX+uoueJb
	1C22j8I8ag0ZF02ODMcmwP6uZVS1KEw/1UZIOVZ2504r0kV5s3EpBEJYzLpmefMY
	snMHFausB4pDizHGEvKGIGvC7+Fh++6u/cC6pZj9nzLR9A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3_taHuK4QluD; Tue, 19 Nov 2024 17:42:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtBdk1Y6yzlgTWK;
	Tue, 19 Nov 2024 17:42:17 +0000 (UTC)
Message-ID: <5c15f52b-bbb5-4d04-8e48-11a92d407201@acm.org>
Date: Tue, 19 Nov 2024 09:42:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi bus disconnect on high load in qemu kvm anno 2024
To: Marius Schwarz <fedoradev@cloud-foo.de>, linux-scsi@vger.kernel.org
References: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 4:52 AM, Marius Schwarz wrote:
> a bug in the scsi subsystem has been discovered

Why would the observed behavior indicate a bug in the SCSI subsystem?
If the queue depth is high enough and the I/O timeout is short enough,
any storage controller will get overloaded and will start aborting I/O
requests, isn't it?

Bart.
