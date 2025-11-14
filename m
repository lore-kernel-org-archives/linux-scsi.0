Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF3326D4D
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763137679; cv=none; b=uMRiLMwzW5tVbkkq9OlMWPx/LrKWjsz1IK6xFx36Ph6QQuKV5k1GxfbcFJ9Y6v7eSGJ+DZTsh8kvLEdOk8EpgckQTivV4KUE2LE3F426Hc4OFACdgBLMI27KTSPJ35onWfMmplibWMJxLFO+L286Vwr8bvSWd7xDtzhJwl5dUB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763137679; c=relaxed/simple;
	bh=120CtHoTxaXFrp3ACLw8sghi5sG1PUw17D+K7UfKU+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfZ6kk5Jcwm6Bs8o1jVipm82aUROOixHxS0zQVa3ZmzWD8/AjCD0gKf/HmeK17epCZM5h1i9pmrzusrERh+cSyywYxH96Ppi2UD3HE2kYvWMYkn0ufBdau3WE7xAbzQAQ2gdxySDYkjOye4PeUuH20R1D5k7TyoXV5DXeswzb5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bN0iWvPU; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bN0iWvPU"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d7Mxm5qKtzlv4Vs;
	Fri, 14 Nov 2025 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763137675; x=1765729676; bh=o/6S/N1Gur1HwdzxzAKlcXkP
	PcgKJ3dsd0antpcpdgo=; b=bN0iWvPUwUyCuOBA5b307i5prYQaqTP0wt/6qXFj
	TVGWU51Y9Yh01txu7ihxv7Vmo9AXq3XZDHSzy97R0T4P+KUMH3iiY79ghtbPNIqH
	YhkmUG5FTfdrplm4wjKEvfFhZgdx0J3JSt/2dCVYfk3ZWm2ydH6Go82EtDczRztZ
	prbTnJIghEVkBSExmnjbm8wDDyKKqSB54e6ZLxlNyzr/eohO+qZpUd4/vne9WCLK
	z4y3H0rN1V9cbJL4dvPvCgiwPGkyfbUxgNReu/+T3BHLq81oDIqKfLqjnRWDJbFy
	WGrYwzMiyqHRhr+cPwZjrpbMvNBfQ3OmeTVJ1qjFgbzUXg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tCF-wUk2tCs6; Fri, 14 Nov 2025 16:27:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d7Mxh18Zqzlv4D0;
	Fri, 14 Nov 2025 16:27:51 +0000 (UTC)
Message-ID: <df112b95-c142-4984-b2c5-ad587d98f486@acm.org>
Date: Fri, 14 Nov 2025 08:27:50 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: scsi_debug: Stop using READ/WRITE_ONCE() when
 accessing sdebug_defer.defer_t
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <20251113133645.2898748-3-john.g.garry@oracle.com>
 <0108b7fd-77c5-4aa5-a761-2a7640d2a024@acm.org>
 <a0e4fdd2-3dce-46c8-94ad-cdddbf90676a@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a0e4fdd2-3dce-46c8-94ad-cdddbf90676a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/25 1:02 AM, John Garry wrote:
> So do you see a problem with this patch? As mentioned, 
> sdebug_defer.defer_t is already only accessed with a spinlock held 
> (sdebug_scsi_cmd.lock) (which I consider being a critical section).

Ah, that's something I hadn't realized yet.

I agree that this patch should be fine.

Thanks,

Bart.
