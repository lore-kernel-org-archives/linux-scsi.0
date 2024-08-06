Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B812315573A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 20:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722977828; cv=none; b=hUE/al74tDh2XJJnqYIjtrJlzYHE4WtfLjAkrlRX/201w+TQ8+pOSrfI4GKk6AC+hXB+7EUR2Vf/bbBBlwm57Nc6q9FdPq+DMLi5A520WRpuBQM/MZ7/RRTgiHdonhfPkMoqDkJq64vLVmIhgQEbquQkQ3zxUi5QXRHreoFhwus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722977828; c=relaxed/simple;
	bh=lK6wWEaKk4SUrMA1v/UtBu+tAC3l78V1jqrTi2deEsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K+AFrITlXNDxe1/CXs6S+2uyXU9nnklgwxZIfb6yYlBMGNLKkPKq6+LxPuszkCh33HJlIeKBoLqi+J5CWxKMhEw2Xq5ep40pJA/pqrO+hhAxhktOBQLGNgONKcCAmuVy2ZIAv9XPpJ84gEofDm/VRGTITuimyJ1urpedjWJMogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1CyhSlrg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1CyhSlrg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wdlwq6PV3zlgTGW;
	Tue,  6 Aug 2024 20:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722977817; x=1725569818; bh=jQFm3k6wyyFoO667b9XN/SWC
	ggtYckDlWpJUkZJ1JvY=; b=1CyhSlrgTNlTq90Gp97PCpStouNQ2ajhYcyhxoWw
	tH6Nbszvj34/PQw74yWjmXkd/YeSTKBCIEqpx0Xf+2Zu6IZLxAAO+64ozNxLFc2C
	dE7wJqyPgQ0svXKVyooIEUky7DZ6KpA3bGRw72WYcrJNcksGcbkcozbODOxjKjaB
	DJh6l54GStVPM1Xu0krRFAgurAFZDvHFcjLWCT8R+ep3dYz3nROrjFOFqxxCDPDZ
	dnS2ne2G2qhFx5hJ1EY7qILT2+zaxklAZ968II+WSnkjFo4uqT194UOV9ZqBKiOP
	xVOBUn3zKZMmsXUz7igHspjkucEu2mL9oKQwI520qZFDfg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id F3v-dRHxBRRH; Tue,  6 Aug 2024 20:56:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wdlwk4B3JzlgVnF;
	Tue,  6 Aug 2024 20:56:54 +0000 (UTC)
Message-ID: <c41f73c2-be91-450d-ae8c-d0f500d0bbef@acm.org>
Date: Tue, 6 Aug 2024 13:56:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mips: sgi-ip22: Fix the build
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Genjian Zhang <zhanggenjian@kylinos.cn>,
 "Ricardo B. Marliere" <ricardo@marliere.net>,
 Sumit Garg <sumit.garg@linaro.org>, Alex Elder <elder@kernel.org>
References: <20240805232026.65087-1-bvanassche@acm.org>
 <20240805232026.65087-3-bvanassche@acm.org>
 <2024080603-buffed-choosy-a04b@gregkh>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2024080603-buffed-choosy-a04b@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/24 11:57 PM, Greg Kroah-Hartman wrote:
> On Mon, Aug 05, 2024 at 04:20:21PM -0700, Bart Van Assche wrote:
>> Fix a recently introduced build failure.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   arch/mips/sgi-ip22/ip22-gio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> Thanks for this, and the other, fix, I'll queue them up to my local
> trees soon.  Odd that these two targets do not seem to get any testing
> in that I never was able to see them in the 0-day or other testing bots
> out there.  How did you find them?

Some time ago, while making changes in the SCSI core, I noticed that it
is very hard to build all SCSI drivers manually. That is why I wrote a
shell script to cross-compile all SCSI drivers. That script is available
here: 
https://github.com/bvanassche/build-scsi-drivers/blob/main/build-scsi-drivers

Thanks,

Bart.

