Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A36174EC6;
	Tue, 25 Jun 2024 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719333774; cv=none; b=MT+ZqqAYhAGGxqU1n1t4BFoc3Ct6cxPKbbc0X6iOGgLTQ5zSczwL75umf5Wr2C7ui8Lewl6qmfGMTWittc0/v1MGfk8OetGjvE8s6101PHnwzWKraQGCUCAz5UNLBCoer6AhnDQuwfJp5znGhQD2hZSyRGa1xba5d6+aEuberqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719333774; c=relaxed/simple;
	bh=AiVRnM36SZePV7DiOFeYsrWEs3Bvv9LCMdrNJReGEkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTFqW+KHMCOqvp24yWJW4650/9YDz72ajJXQvkqBcIrTOthmSfhiQ38YkeL/ioXkZs5SxE52ZdGYyAksYbQA37pOueD167pyiYuffTAcFLHKTZ33rc7jHa0vYr5llL4R9wN9SOVsHHHplo4rs9U/DjcbMElYJQaZMLQE9jbRM3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LIYF5uJd; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LIYF5uJd"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W7rH022Xrz6Cnk9F;
	Tue, 25 Jun 2024 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719333757; x=1721925758; bh=sAjpvwr1/jgh6UyW1p1dhJNm
	AbUi5v13hU7EV0lbSHI=; b=LIYF5uJdWitfHtvZuWidNmtesPBlfGPnKrcAMTKH
	cvb90tnfF1Lu3kL0zfyXYckr8hNXHP1QTCNaMf9QezjQlOdTI7E0QRaYvsnjAIcC
	PIVfKY6V13l5DgtJ4KJJHZ3ELLy2nv1xJwyWPfKqHt3EA/CEf3RhJoquvPdlnIre
	SBHdLwxjEbUdpvZxinxYjvGU+rRjx2Ui2+oors3hwKMVQsFY8QEKBkqt5A8XLS1q
	JkbkkC0gxMFKZ/jDh+S2J3f5WV6GJp6Ig32ymcJvlI6NWSl7iV7asIWi/wyzwvbB
	FmILgtNFpDBbru4wBrF6lHX0QR0mtP6s6vL+pHE5muRc+w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nKsHhbovsQ9L; Tue, 25 Jun 2024 16:42:37 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W7rGd6x2cz6Cnk97;
	Tue, 25 Jun 2024 16:42:33 +0000 (UTC)
Message-ID: <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
Date: Tue, 25 Jun 2024 09:42:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/25/24 1:29 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2024-06-24 at 11:01 -0700, Bart Van Assche wrote:
>>   On 6/24/24 5:11 AM, peter.wang@mediatek.com wrote:
>>> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-
>> mcq.c
>>> index 8944548c30fa..3b2e5bcb08a7 100644
>>> --- a/drivers/ufs/core/ufs-mcq.c
>>> +++ b/drivers/ufs/core/ufs-mcq.c
>>> @@ -512,8 +512,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba,
>> int task_tag)
>>>    return -ETIMEDOUT;
>>>   =20
>>>    if (task_tag !=3D hba->nutrs - UFSHCD_NUM_RESERVED) {
>>> -if (!cmd)
>>> -return -EINVAL;
>>> +/* Should return 0 if cmd is already complete by irq */
>>> +if (!cmd || !ufshcd_cmd_inflight(cmd))
>>> +return 0;
>>>    hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
>>>    } else {
>>>    hwq =3D hba->dev_cmd_queue;
>>
>> Does the call trace show that blk_mq_unique_tag() tries to
>> dereference
>> address 0x194? If so, how is this possible? There are
>> only two lrbp->cmd assignments in the UFS driver. These assignments
>> either assign a valid SCSI command pointer or NULL. Even after a SCSI
>> command has been completed, the SCSI command pointer remains valid.
>> So
>> how can an invalid pointer be passed to blk_mq_unique_tag()? Please
>> root-cause this issue instead of posting a code change that reduces a
>> race window without closing the race window completely.
>=20
> blk_mq_unique_tag() tries to dereference address 0x194, and it is null.
> Beacuse ISR end this IO by scsi_done, free request will be called and
> set mq_hctx null.
> The call path is
> scsi_done -> scsi_done_internal -> blk_mq_complete_request ->
> scsi_complete ->
> scsi_finish_command -> scsi_io_completion -> scsi_end_request ->
> __blk_mq_end_request ->
> blk_mq_free_request -> __blk_mq_free_request
>=20
> And blk_mq_unique_tag will access mq_hctx then get null pointer error.
> Please reference
> https://elixir.bootlin.com/linux/latest/source/block/blk-mq.c#L713
> https://elixir.bootlin.com/linux/latest/source/block/blk-mq-tag.c#L680
>=20
> So, the root-casue is very simple, free request then get hwq.
> This patch only check if reqesut not free(inflight) then get hwq.
> Thought it still have racing winodw, but it is better then do nothing,
> right?
> Or, maybe we get all cq_lock before get hwq to close the racing window.
> But the code may ugly, how do you think?

Please include a full root cause analysis when reposting fixes for the
reported crashes. It is not clear to me how it is possible that an
invalid pointer is passed to blk_mq_unique_tag() (0x194). As I mentioned
in my previous email, freeing a request does not modify the request
pointer and does not modify the SCSI command pointer either. As one can
derive from the blk_mq_alloc_rqs() call stack, memory for struct request
and struct scsi_cmnd is allocated at request queue allocation time and
is not freed until the request queue is freed. Hence, for a given tag,
neither the request pointer nor the SCSI command pointer changes as long
as a request queue exists. Hence my request for an explanation how it is
possible that an invalid pointer was passed to blk_mq_unique_tag().

Thanks,

Bart.

