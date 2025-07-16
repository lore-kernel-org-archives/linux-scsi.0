Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4556D2857E2
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752678871; cv=none; b=jeTJSoxX4MApCiiwOrGOimaf9fnebz5VIs3qXowdVosPmyD+ldhoYQgX/cyI/oBccF8sEG1vxU/tdFeUXtH+S/urwND1oeWzRiND+CG0RNvqK2R48KXkLmP52dDkl48PWouXVAs/hWpIGBOL7shb6JM7paCpGjSD1vL6xrbU37I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752678871; c=relaxed/simple;
	bh=GitT/XQkUzgAhQ8xWTFQ9iX9w5CQTZGoJ8klZA4ZID8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NVWN07zglI48RasYuBmPREdvQvR8RBmeos9w2XFuPqNDaBVMsu/CBtlkg0Wp2dx6cqmTD3ShRjkXtOWIvoh+bsQZI0aeowiHzJoQMV1zWYd9FoOzUiw527Oo0Z4XDgEZPxbvm2GbXqdXZpqCXxJH16VfJxP3EtgqIOoPO2Nz7Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vLDUUuSx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vLDUUuSx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bj02s1G5Qzm174n;
	Wed, 16 Jul 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752678867; x=1755270868; bh=GitT/XQkUzgAhQ8xWTFQ9iX9
	w5CQTZGoJ8klZA4ZID8=; b=vLDUUuSx2VCsCWNWnRx91lRlkPzEyd77PXuD1OYP
	vq/7+sgNHPdNvzJDhBpH7YRZPWcMkYaUfGiWNW41uDeJfUCwCeTHhVPmHdXPE8EZ
	W6OEcIa5A2KvKAjCWmI9dzdgVvSwGo1+GiizYEuha7Wve//staNf72rZF6VjwEGX
	UiG95nFuJwY0243ZIqTqxywh36FrDalDZiQp2DAvTOcCQnrg47XHJ2vcJDFZ1AiJ
	9r6FJ8uJX8LtNXQI8HqCz4caMM9pz92Aj4WPRI9zeJe1WqRWNmr8X/oJ3bV1FIKN
	Z32oBsfSn2+5OtaLM2e2snN3z7KWXZw7h5Svmt7H57BZOA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fk9ajxnvI4pT; Wed, 16 Jul 2025 15:14:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bj02k1cZqzm174m;
	Wed, 16 Jul 2025 15:14:21 +0000 (UTC)
Message-ID: <4080315d-4d90-433d-85e3-db5eef48bc90@acm.org>
Date: Wed, 16 Jul 2025 08:14:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
To: Seunghui Lee <sh043.lee@samsung.com>, 'Bean Huo' <huobean@gmail.com>,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
 <20250714090617.9212-1-sh043.lee@samsung.com>
 <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
 <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
 <cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
 <005801dbf61f$7287e7d0$5797b770$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <005801dbf61f$7287e7d0$5797b770$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/16/25 12:01 AM, Seunghui Lee wrote:
> This issue arises from the race condition between the runtime pm
> worker and the error handler worker.

How could there be a race condition between the runtime PM code and UFS
error handling? Runtime PM is disabled while UFS error handling is in
progress by surrounding error handling with ufshcd_rpm_get_sync(hba) and
ufshcd_rpm_put(hba).

> I believe it would be safer to handle recovery within the runtime pm
> worker itself.
I do not agree. If runtime PM and the UFS error handler really happen in
parallel, the proper way to fix this is by serializing both activities
instead of introducing concurrent error handling.

Thanks,

Bart.
