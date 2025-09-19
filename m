Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE4A1D54D8
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315786; cv=none; b=fkCq+/LTXl4glk8siEhBVIW7whmaYq0ErdwyNlloRlChPrD6GXt6p8c1MMBsIFxPhmMSFK1vPmq/ZXxyAyULnycLVoBSbf8zSCqV9XxM5aENABW3Y6LRKm5AEPPeSDcWF6ybjqzwvT7VsJbbJFubG10BXQXftwf05N5ANeE9pm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315786; c=relaxed/simple;
	bh=ehmo0zVpsScCNwYSk35hKBqCz+aSYotg0zAVgDcga6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQPs7lpAtREM8OltRrLeKIzdYypZ7jlXhzoI/hKY7GcDLU9LeADLW2Wa5cwvqVDeG5OLlWnw6jjub0zdBtrHRUTM1v5w54ao5Q1zHldwhHw3Wg5ixgR3Bq+6qiPVJYPxmzIE8jPS6xHn9Jvyv2hmXyZ8AJzdEIzMBz7GVH6uYfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=psgjlYXi; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="psgjlYXi"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cT4j34gnfzlgqy3;
	Fri, 19 Sep 2025 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758315780; x=1760907781; bh=ehmo0zVpsScCNwYSk35hKBqC
	z+aSYotg0zAVgDcga6U=; b=psgjlYXi6XyLUlF5wGplfA2yNWAPmFRPFzgHvQBp
	ZMlRtBhTLSLMlQArNonkSLFSRHLQHliv4q1+tQXp6FHiB7fwrx7NE14fcc/TDe8K
	GWkStKe1eQBJ3AGBGmIbNGNih+aJciqMxVPZSwGV8zSyC4Doa5X5ZOqv70k4b/Yg
	id3UgnNx+UseFMHnpZIeKdOrheyefq1HAF4T2LsaKZujZNSDeOVyFka70sGwqYyN
	Cj7nQKOL8vZrSdZHusXcncq9ggjqqtFTfbeiTASAnXDHPstKSpV+l05W/ohnoSR9
	c+OEcTE4be6slXYQt4xI2WcS7o9WUIu+Xoz7ijCTtsySPw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pO4KjVvECtoX; Fri, 19 Sep 2025 21:03:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cT4hm2w7Yzlgqxm;
	Fri, 19 Sep 2025 21:02:47 +0000 (UTC)
Message-ID: <ba381e9a-4cb5-45df-9fe0-3d370a84429d@acm.org>
Date: Fri, 19 Sep 2025 14:02:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
 <Chun-hung.Wu@mediatek.com>, =?UTF-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
 <Yi-fan.Peng@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-3-peter.wang@mediatek.com>
 <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
 <21a451c752709cd9c1a3e18568c18f384bb77a05.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <21a451c752709cd9c1a3e18568c18f384bb77a05.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/19/25 1:11 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2025-09-18 at 11:30 -0700, Bart Van Assche wrote:
>> On 9/18/25 3:36 AM, peter.wang@mediatek.com=C2=A0wrote:
>> > Correct clock scaling with PM QoS during suspend and resume.
>> > Ensure PM QoS is released during suspend if scaling up and
>> > re-applied after resume. This prevents performance issues
>> > and maintains proper power management.
>>=20
>> Is this issue related in any way to the MediaTek UFS host driver? If
>> not, please change this patch into a patch for the UFS core driver
>> such
>> that this issue is fixed for all UFS host drivers at once.
>
> Yes, this is a MediaTek-specific test which disables clock scaling
> and keeps the power mode in high gear.
> So, I don't think this patch should be applied to the ufshcd core.

Hmm ... it is not clear to me why this change is specific to MediaTek
host controllers. Please move the code changes in this patch from the
MediaTek driver into the UFSHCI driver core.

Additionally, why is this change necessary? Suspend and resume should
happen quickly. Does removing CPU latency QoS requests during suspend
and resume really save power? Has the power impact of this patch been
measured?

Thanks,

Bart.
