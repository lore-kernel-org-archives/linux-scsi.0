Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE0A3128B2;
	Fri, 22 Aug 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755875870; cv=none; b=szlxzhVMT8i6ZDOit7bNbT48LhT6PXy5fESWTTITme48V2QORFCbvVI4tAP2V81BgN6RnmuTcWm3tImIzuLLozlHnkD85JbZRTps9ZzCdRn8IWjVZ4g98YewXEK6G82LxkF7aPAqpo2dElqLOptzls9o0xLBbDBjrMeuq65Jf+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755875870; c=relaxed/simple;
	bh=UUIuMemQ4yZziJD9+AhK63S0jT0r3OEI9F9PpDNfyqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fq8bIoPtXPfDEg0itUyKDYZkgo1dyuLbn9tfr4ViQmWczIvmhJclozgqH3KCAXDoxtI+KTsqjeTlO/hxTcaLyhuCVximJOwB8jlZ3ufDr6P8FpyMZuCxg5WiQLVS8IghzXuov51EVW2roWN+pCbr0OJ7NZnuI76oww/iGWxM2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dqIR5Wql; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dqIR5Wql"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c7kMb1LwVzlgqV7;
	Fri, 22 Aug 2025 15:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755875865; x=1758467866; bh=UUIuMemQ4yZziJD9+AhK63S0
	jT0r3OEI9F9PpDNfyqo=; b=dqIR5WqltNR+dQ1XaLcvCrR5egeC1Zup4+GYgj+G
	YGdJzeqdjBbuy+ySQsReRXjaK1BeAJgbUygifczyzuvsP4HFIEY30rzepOOhNEx/
	l+3ftG2ATZjyi/JLybYCXz43zalScYwA7pazZqmO4U7RNSicOLk7CKZqEBji5AFW
	tr/KtEbTTctjsCvy1R9PgOXQaQjPSbFoLifaefVzTj/FrZfMTb5wEUGjIkHAmZQc
	SefAkPHRV23fB8lcdzO+aLml6hcxq6AkD+2JlkeyAyq8GZnyEcHv3VKxTl/FWs/K
	lkhfteDGIrnp85R+xawNoiObBS7IbgemUxgsLJeMCkF2bw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MeLRszCoK-qj; Fri, 22 Aug 2025 15:17:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c7kMQ1MQdzlgqVr;
	Fri, 22 Aug 2025 15:17:36 +0000 (UTC)
Message-ID: <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
Date: Fri, 22 Aug 2025 08:17:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Yihang Li <liyihang9@h-partners.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liyihang9@huawei.com, liuyonglong@huawei.com,
 prime.zeng@hisilicon.com
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250822075951.2051639-1-liyihang9@h-partners.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/25 12:59 AM, Yihang Li wrote:
> We found that when the CPU handling the interrupt thread is occupied by
> other high-priority processes, the interrupt thread will not be scheduled.
> So there is a change to switch the driver to use tasklet over threaded
> interrupt handling.
Tasklets have severe disadvantages and hence their removal has been
proposed several times. See e.g. https://lwn.net/Articles/960041/.
There must be a better solution than switching to tasklets.

Bart.
