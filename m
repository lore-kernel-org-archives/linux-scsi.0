Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A6B156F2B;
	Fri, 20 Sep 2024 18:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726857562; cv=none; b=n12/Nkv9wn7abuDQmspwmMGQP2RV2l9c9gK1oS8dMCde9la/N/VqgyLSAMXmii3rWPy5WAcru6N5dgXuUZxjxtiCSOLsl7u7wFMNSnm8HCkjXxGSLZ6FNPNRr2qJJ7at4e0LaCGSGTmAMrr2+kcSUKHdxKup/aeaG8ZJHz0/jzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726857562; c=relaxed/simple;
	bh=1T/lgYDGhoKWKe/iewrgMynEOMOM9YDpp7ygWqqgofo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P9o08s/kQloY6iJYVaAxkwy0OrKcgrncgTHUk8cfwGPFctOQPqvu0wDi1YLIsabmo6ACIpaKkQ0Pft14SFOTS48ciREt70AtnXxGkY0APWgZZ4zVEsd5vmeGkoos6Yk6kkbBJR2/+NLRLjn6icF5XVPD4DT0sA8Lb2X7Myr8xlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QC6KPhG5; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QC6KPhG5"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X9LlD5KGHz6ClY9H;
	Fri, 20 Sep 2024 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726857552; x=1729449553; bh=AdEEt3u0eY6KT/KDZt7EFUB/
	vvIuBAZCZRyYfatoQtQ=; b=QC6KPhG50IMXHhtddPfTQobHuMeducQhYT/Csx3/
	5BFtDYko6WTw45NrlhTVJGdZE91nndwEZU9TIpLDwnrRCfRCsaOgf4B1U2e6lozd
	GljV4rCls8+GHcTm3qX/K8jgWT+CwUM3ONKiZjDx/q3Lqa99Pazg9nu10Nbqt2ky
	jwLzcPq8MtTijyIcG41XOKaw401plORhIaRfNs6AVPTsNJx6tjTXMMi4QIj8Ytcp
	eEaM33s2vM4XVfFWm9u0lUmImKWrwJ5h0uVRqbz+mHgb75EBiD0JvuTDQESM4nXX
	D091BuufdWJXO0c2lbxj6OhrA36e8xe6H2F/BEQvLi/Zww==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RZSk16_plGrt; Fri, 20 Sep 2024 18:39:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X9Ll20h3fz6ClY9C;
	Fri, 20 Sep 2024 18:39:09 +0000 (UTC)
Message-ID: <ec301d5f-cfee-41ce-ae1a-5679b2da2cce@acm.org>
Date: Fri, 20 Sep 2024 11:39:09 -0700
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
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
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
 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
 <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
 <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
 <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
 <beeec868-b4ac-4025-859b-35a828cd2f8e@acm.org>
 <4f9e2ac99bcb981b11dc6454165818c5de6fd4d6.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4f9e2ac99bcb981b11dc6454165818c5de6fd4d6.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/19/24 7:02 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2024-09-19 at 11:49 -0700, Bart Van Assche wrote:
>> For legacy and MCQ mode, I prefer the following behavior for
>> ufshcd_abort_all():
>> * ufshcd_compl_one_cqe() ignores commands with status OCS_ABORTED.
>> * ufshcd_release_scsi_cmd() is called either by ufshcd_abort_one() or
>>     by ufshcd_abort_all().
>>
>> Do you agree with making the changes proposed above?
>=20
> This might not work, as SDB mode doesn't ignore
> OCS: INVALID_OCS_VALUE but rather notifies SCSI to requeue.

cmd->result should be ignored for aborted commands. Hence,
how OCS_INVALID_COMMAND_STATUS is translated by
ufshcd_transfer_rsp_status() is not relevant for aborted commands.

> So what we need to correct is to notify SCSI to requeue
> when MCQ mode receives OCS: ABORTED as well.

Unless the host controller violates the UFSHCI specification, the
command status is not set for aborted commands in legacy mode. Let's
keep the code uniform for legacy mode, MCQ mode, compliant and non-
ompliant controllers and not rely on the command status for aborted
commands.

Thanks,

Bart.

