Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5B51B1D53;
	Wed, 11 Sep 2024 19:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726081931; cv=none; b=Jrj6z4MzXKuRbQ28XcWjAj82PIZiRILSy14Kh0W5u/bGnnzirTsw40BQM8rRDXQFmi9Xet5fhe/6hGU2LdkzjjZXENGJuxk+7iUaiamQ1cPRSBITIO9IpPyaeWcMNt3thbfAvEbp+yNCxbzdpiC8p8zzIzcpFEpHehvRBO1UY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726081931; c=relaxed/simple;
	bh=fsoxF7sGIu5bOZ9u0NafTnI88ERHYf0UaLPVUsqPJhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LxARWFDHnUmlS7Zb0Rmyvo2cufAMmwvfsXsTLfnBFlqIRKYc+Kbn9XMXMlGNPvJfJr/uZIv4gAh06ATTLDEYNL2dT9c7ZpGNImaBC2Sdzy6OPU37U30UYw1n8JRD0pCcxNB6Nb3mRCMHgKXiZdlxcISWNuLeeTztGt1pgK6OffU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w94iOTF5; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w94iOTF5"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3qvF0tD1z6ClY9P;
	Wed, 11 Sep 2024 19:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726081917; x=1728673918; bh=LgUJrvRBNbuYJhKEae8t1pD8
	8/KE+UPgTHV197Abt0o=; b=w94iOTF59lHhd1wu0GBhna72MMT+5bzSYBZ85Huc
	MtSjsIfRi3uW+wjemZbJY5Bz0oJYg82lgz4ywKCZRNPhq2eEgqYJGSHrDho0OR7C
	vb1lrvkgmRRWOc/LqwA7jqH0SbbfgfZHguWN3XeWKA2BwnBLoaSVxUtGsJQyWUa4
	st5AMkew5I8t8SU+4sDeuUXvv7ywglaOTPIiht1B+cx94shkTX0jgfNSo4MTIO/m
	ezzQOKIizmXot94a5zWWz3jzk9M7TeljSsRcPBmHYgx6lt9yIcMv+GbvmNZ8Czxy
	3QPIZS/jJ1NMuUK2ql96RHl5rkJpPDYiJxtsI4hmE0zU0w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7HCF5J1oaQqY; Wed, 11 Sep 2024 19:11:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3qtw0vbNz6ClY9K;
	Wed, 11 Sep 2024 19:11:51 +0000 (UTC)
Message-ID: <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
Date: Wed, 11 Sep 2024 12:11:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
 <20240910073035.25974-3-peter.wang@mediatek.com>
 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/24 11:03 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This statement is not quite accurate becasue in UFSHIC2.1, SDB mode
> specification already have OCS: ABORTED (0x6) define.
> And it is used in below UTRLCLR description:
> 'which means a Transfer Request was "aborted"'
> Therefore, the host controller should follow the
> specification and fill the OCS field with OCS: ABORTED.
> If not so, at what point does your host controller use the
> OCS: ABORTED status?

Hmm ... I have not been able to find any explanation in the UFSHCI 2.1
specification that says when the OCS status is set to aborted. Did I
perhaps overlook something?

This is what I found in the UTRLCLR description: "The host software=20
shall use this field only when a UTP Transfer Request is expected to
not be completed, e.g., when the host software receives a =E2=80=9CFUNCTI=
ON
COMPLETE=E2=80=9D Task Management response which means a Transfer Request=
 was
aborted." This does not mean that the host controller is expected to
set the OCS status to "ABORTED". I will send an email to the JC-64
mailing list to request clarification.

>>> +/*
>>> + * When the host software receives a "FUNCTION COMPLETE", set flag
>>> + * to requeue command after receive response with OCS_ABORTED
>>> + * SDB mode: UTRLCLR Task Management response which means a
>> Transfer
>>> + *           Request was aborted.
>>> + * MCQ mode: Host will post to CQ with OCS_ABORTED after SQ
>> cleanup
>>> + * This flag is set because ufshcd_abort_all forcibly aborts all
>>> + * commands, and the host will automatically fill in the OCS field
>>> + * of the corresponding response with OCS_ABORTED.
>>> + * Therefore, upon receiving this response, it needs to be
>> requeued.
>>> + */
>>> +if (!err)
>>> +lrbp->abort_initiated_by_err =3D true;
>>> +
>>>    err =3D ufshcd_clear_cmd(hba, tag);
>>>    if (err)
>>>    dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
>>
>> The above change is misplaced. ufshcd_try_to_abort_task() can be
>> called
>> when the SCSI core decides to abort a command while
>> abort_initiated_by_err must not be set in that case. Please move the
>> above code block into ufshcd_abort_one().
>=20
> But move to ufshcd_abort_one may have race condition, beacause we
> need set this flag before ufshcd_clear_cmd host controller fill
> OCS_ABORTED to response. I will add check ufshcd_eh_in_progress.

Calling ufshcd_clear_cmd() does not affect the OCS status as far as I
know. Did I perhaps overlook something?

Thanks,

Bart.
