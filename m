Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30912DF12C;
	Mon, 17 Nov 2025 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763397669; cv=none; b=JTI2dw2fsO3rnuuEf6+w+3JfkXXPMQBy7pptrGTOdLBv1W3jhO+gfG7yiZTkI9n+xMi597RNzqWlN22pBgG3Bx0Bjf/KXzByHE+jfVsb5PzwYJTLaXHhsO23ZUIeF8kOc0xabLJpBFyv8jgz6HhXNfsBpqaWRF/AXJN0YnpeRKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763397669; c=relaxed/simple;
	bh=4avwgk8uzN03Ykky3F9EsrzM4hwXV7Kx2GoLZrpbq68=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZJLwFCOAvZV0WqsHLcPNNwAoluG5fiOI4T1SPXdU4EE1sJVj1imQBmVhfhfDtXJ7iImSVYVslToctijCsNncHCI3xj8HYwMY04xgp7wdQEILJsFJOmMoPCMczH3eRyHDMsbSvsVhtRYLrD+P6xRwQPHm7OZF4U2xIYSp/uoF9hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kn1SzX0K; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kn1SzX0K"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d9D5Z4mcczm1LHh;
	Mon, 17 Nov 2025 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763397665; x=1765989666; bh=OkCC4kTl1bJKNCqz/LrMPLMC
	gri7Bztz3QohqTmLAqs=; b=kn1SzX0Kn4yIMMjdCujfxIgR3avmht41JvN40eOs
	KBgmKisN7KCy4v+fUyIWittwGcskgTHuWewuRv7JUfSs5Yja+KkH0CK42nsrkBJI
	5j6KnvYeYqNv7oRZLIOjJ9EnRRMOnNROoxG9jNs45e0yPGoA9w29cXCKRGFhyg2r
	JtS9NA6cPVw9nDAd0EaP9H6BEWK2IJCEW2AwXevEqBckCnP5afin59twA7S618V3
	brztDt/YQXC7R7GmrQ4UhyItpJZjV2xeSl1G4KSnv2fZl1UePkkelBMck7ptF/5K
	qp17HLab/e6PiAaNqH6i7k0SBRML9MrHOAgca4C1JkKyrQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lqdQYB8uP5JH; Mon, 17 Nov 2025 16:41:05 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d9D5S5yChzm0yQj;
	Mon, 17 Nov 2025 16:40:59 +0000 (UTC)
Message-ID: <c1f69239-b289-455f-b1b4-89fd3a6ddcee@acm.org>
Date: Mon, 17 Nov 2025 08:40:59 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: Hannes Reinecke <hare@suse.de>, =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+L?=
 =?UTF-8?Q?=29?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/13/25 2:08 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> In the worst-case scenario (when the device is stuck), it
> may takes 1.1 seconds to abort a single task. When the queue is
> full (64), there will be noticeable lag. Aborting all
> tasks can take over a minute, which is unacceptable regardless
> of whether TM_CMD_TIMEOUT is increased or not. Under normal
> conditions, it=E2=80=99s very unlikely to exceed 100ms. So I think
> directly modifying TM_CMD_TIMEOUT is also acceptable,
> but I suggest keeping it within 500ms.
Hi Peter,

Aborting different commands should happen concurrently rather than
sequentially. See also the queue_delayed_work() call in the SCSI core
scsi_abort_command() function:

queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);

Unfortunately the max_active argument is set to 1 in the call that=20
creates tmf_work_q:

shost->tmf_work_q =3D alloc_workqueue("scsi_tmf_%d",
				WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS,
				   1, shost->host_no);

Hannes, do you agree with increasing the max_active argument from 1 to
INT_MAX? I think the above code was introduced 12 years ago by commit
e494f6a72839 ("[SCSI] improved eh timeout handler").

Thanks,

Bart.
