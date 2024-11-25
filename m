Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDD71E48A;
	Mon, 25 Nov 2024 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732554228; cv=none; b=iNJp6eFeWmvpQGnrPHvKskmVeYUwbEkPZKvGwVDoC/PIRujFu5iz6CHOdt0qzfrNE9WMZqvIIFwjyiTXiqIJESbIV0/uWok5JrYI1rHQ0W25tm69ZfAVd5h8xCRnDuOm6jmgBHq23bEXdy78L25YlREzdHJG2/V5gl7f2a6T3CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732554228; c=relaxed/simple;
	bh=Ttq0vcLY/ScbiHvI6ZYe0gALY3by1dvPC0VV9rW/wpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EH8i8apcr+Sx+4uhceMyECe4ePv3w1UstVwP2HTZbS0fQmZqcWche6c1lybQmXAMVN9CoqClLEPpN/pp4+P0wDMqP99pPRB2JEmINwfx/12+c3p91gvfTiGuxrxKb5wsE0Pv3NM1KPt8rKS4bnhUZhZhfWmFWu0fH4y4WZCixfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x4eEHWKN; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x4eEHWKN"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XxsVN4hjszlgMVx;
	Mon, 25 Nov 2024 17:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732554218; x=1735146219; bh=BJN/hlYI6VFZIPSutzIg5Uyn
	nzGEeixZT5eTTqsmzuc=; b=x4eEHWKN5Ycp+IZQG0t2EmF/ntviT0vHMbKQVrrm
	BAC64MxkEDYe1QoTa1Uqz+W68BaAegtR0e+JE9ppSQX8rOtJrkiodWwgzhtVBqPH
	fIjjS2NY+Jf+DgzAOU/S6YRHFluiyzkw4WrXkuPwkaFqzz6pjYq1kSqPoK9cvY3B
	g5nAjk5HrkfpBPtqweUh3guzY1zPxDo/VFpZPS/0xXBI/B2HzgfwuS19ru6/awXc
	RFunhFr63A1HUzCV9VRIXym1N2D776UcvH85YkM+ZCI74cjDcQaHO24fvybhvjSp
	uZFzqfDP1PriwcagQoAvJisPqouMFgVpSlpL6xoH3WlUpg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OdF0VKmEKrE5; Mon, 25 Nov 2024 17:03:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XxsVH3ZfkzlgTWQ;
	Mon, 25 Nov 2024 17:03:34 +0000 (UTC)
Message-ID: <dc9ee4e6-5410-4635-9970-d0b2a5d02d81@acm.org>
Date: Mon, 25 Nov 2024 09:03:32 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
To: Suraj Sonawane <surajsonawane0215@gmail.com>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
 <d4695943-51b8-40f2-bf2c-3a6436081887@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d4695943-51b8-40f2-bf2c-3a6436081887@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 6:30 AM, Suraj Sonawane wrote:
> Hello!

Which person are you addressing with this email?

> I wanted to follow up on the patch I submitted. I was wondering if you 
> had a chance to review it and if there are any comments or feedback.

Sending a ping after 5 days is too quick. I think that you should wait
at least a week before sending a ping.

Bart.

