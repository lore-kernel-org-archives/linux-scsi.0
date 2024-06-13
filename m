Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A814A4F0;
	Thu, 13 Jun 2024 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302222; cv=none; b=uQcto2FibOKMGYhdlMMN2R0nuJTvv2OTuQP2fAaoTjxNYlJW9Mqm3PejuUwWDam6zrbPSIsJ1fCMxMStjMTYJSPEHtSozS2OKauB2Fh9xzwgn//7M/wG0YPdkGXJlWcK/EODkMQtXMQtqn7qigGBWS1FUC6pzrry3AY9pzq2Xbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302222; c=relaxed/simple;
	bh=Fp26F/H6Z6H9jVklu8g8opBQaBFSgieOIZUNLhoUgqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WOIIuwX0tXHYw7GezwZOq0KoBofVDBFPL4EMCpgp0FatoARqlfL0nF4jrb4+WGrOuPHoONBJnP9funaKX91sDmwuQuzl7BC+IDR7dayIA/bj1Yi39J8Wo/ISDt1SaRwysbbG6Eban0E4TYA90NSKuFBBBAlPcgx7kyhTegWmxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mhy4F+6H; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mhy4F+6H"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W0VnL0L5Pz6Cnk9X;
	Thu, 13 Jun 2024 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718302209; x=1720894210; bh=Fp26F/H6Z6H9jVklu8g8opBQ
	aBFSgieOIZUNLhoUgqk=; b=mhy4F+6HFbmKhLrFIa22imw/XaTKMzQzHtno0wzw
	55+tXb3SpnJjE/KL0SRD4aaeLpclaKJHkTP+WQwqBO+llLq8WD5aQpVt0mV+a2WT
	4kepPh6Nfd9m53HI86uwGDE644TWRrh9EpDQZJhfi4W6eYpXEuWPnUAtV8OB0SnD
	HL1b2+EY57cgPE/StNO3pgejw2QkIuAXtfu+6wclQb4O6bVsxKOdphUCH/uCjVLC
	WRwlB6EdJV9w1zOmj5R5PhBAXXYZns1ILn6/VsiaYBJnW1o8ZNH8anrEMXFaS14v
	/EGbKd7NOar+BknjluHoUcskcAGo4nGy+35ShPQrwDwfew==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4EVbcNaD06ku; Thu, 13 Jun 2024 18:10:09 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W0VnF0xGmz6Cnk94;
	Thu, 13 Jun 2024 18:10:08 +0000 (UTC)
Message-ID: <f3a8f117-4534-4071-8084-4cc984f963e4@acm.org>
Date: Thu, 13 Jun 2024 11:10:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org, Joao Machado <jocrismachado@gmail.com>,
 Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240612165249.2671204-1-bvanassche@acm.org>
 <20240612165249.2671204-3-bvanassche@acm.org>
 <CAHp75VdT8hp+aSN_ZyGebkUykaP=p9ipq4Guk6+e_HJ2apu18g@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAHp75VdT8hp+aSN_ZyGebkUykaP=p9ipq4Guk6+e_HJ2apu18g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/13/24 10:44 AM, Andy Shevchenko wrote:
> On Wed, Jun 12, 2024 at 6:53=E2=80=AFPM Bart Van Assche <bvanassche@acm=
.org> wrote:
>>
>> Recently it was reported that the following USB storage devices are un=
usable
>> with Linux kernel 6.9:
>> * Kingston DataTraveler G2
>> * Garmin FR35
>>
>> This is because attempting to read the IO hint VPD page causes these d=
evices
>> to reset. Hence do not read the IO hint VPD page from USB storage devi=
ces.
>=20
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: linux-usb@vger.kernel.org
>> Cc: Joao Machado <jocrismachado@gmail.com>
>=20
>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Cc: Christian Heusel <christian@heusel.eu>
>=20
> Besides no need to repeat these Cc's in case there are other tags for
> the same emails, can you move the rest of Cc's after the --- line
> below? For you it will be the same effect, for many others the Git
> history won't be polluted with this noise.

I will leave out the redundant Cc's but I'm surprised by the request to m=
ove
Cc tags after the --- line. There are many patches with Cc: tags in Linus=
' tree.
I have never before seen anyone requesting to move Cc tags after the --- =
line.

Thanks,

Bart.
