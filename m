Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D911F6667
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 22:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753826571; cv=none; b=pKBZJHiRz0aArr+8TYFgvgQth130QtJI1D4PIy0YLpgsMEry2IsDRtlRK68iPRYL9x8kViUdeeGcR6bgdDNdRXTRv6Yrv/D1KbZkJY295rOPwr/9+9FL+JQGYbYNKvYpYVlF13ywxKga0jm+YW0aOLM1LXPEzKJl4TJeiaIcvME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753826571; c=relaxed/simple;
	bh=yRg6eOA2pI7VR9kP3GRY/9wTmCvwN1H2Fw/73v4WPJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcUWZmvNsze+Nt7h16zf2tRlNSV3BSs381dhJxh2d1Sby6iRHdhL2yEgnMuT/uZNcAPi5lLOhO7LfiYY1bowlu7kqWCMKLQrbMFJRJ8ZBkLsnK1kHQ+pP6DtVQecuPWNnGmYD2ENb/JDGagAzrGCQDzr1FuqC3IynAyjkVCQYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=YcV9Cq+4; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="YcV9Cq+4"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id sfeZ1V2l5i9jbe1X; Tue, 29 Jul 2025 18:02:47 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=drEJ5gCcWsTBvPdShlimCesu062Qnv7hfBvDrm5Ny80=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=YcV9Cq+4nqsBwxY6uuIO
	cjbV7lphu+VBUHIBPbMnu1Rzw7T8wNhWlxvgmJOUjtShH/HemmU9ojRnoh6YBNBD98tl1HTqkmeEr
	E4P/5+HXD5NQHl1GTDfTKSGc3bpboOjOV56+VDvXzaARzWgGWVyVwUicKc5CE1TvLb9KHB9lVc=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14114401; Tue, 29 Jul 2025 18:02:47 -0400
Message-ID: <6b1fd11b-9947-4d60-bf9b-cdd66ba1e39a@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Tue, 29 Jul 2025 18:02:47 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
Content-Language: en-US
X-ASG-Orig-Subj: Re: Improper io_opt setting for md raid5
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
 =?UTF-8?Q?Csord=C3=A1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
 <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
 <yq1zfcnljtw.fsf@ca-mkp.ca.oracle.com>
From: Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <yq1zfcnljtw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1753826567
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 953
X-ASG-Debug-ID: 1753826567-1cf43947df83650001-ziuLRu

On 7/29/25 00:23, Martin K. Petersen wrote:
>> b) io_opt, size to ???
>>  4) For raid0/raid10/rai5, this value is set to mininal IO size to get
>>     best performance.
> For software RAID I am not sure how much this really matters in a modern
> context. It certainly did 25 years ago when we benchmarked things for
> XFS. Full stripe writes were a big improvement with both software and
> hardware RAID. But how much this matters today, I am not sure.
>
FWIW, I just posted a patch that aligns writes to stripe boundaries
using io_opt:

https://lore.kernel.org/all/55deda1d-967d-4d68-a9ba-4d5139374a37@cybernetics.com/

I get about a 2.3% performance improvement with md-raid6, but I have an
out-of-tree RAID driver that gets more like 4x improvement.

If io_opt means different things to different code, might we consider
adding another field to the queue limits to give explicit stripe parameters?

Tony Battersby
Cybernetics

