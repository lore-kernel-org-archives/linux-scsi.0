Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9F14A0B8
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719333205; cv=none; b=K1AmOQZGt1AX1bWiHTr2xhFvZfPF2keXnU9A27vTuJ1rwz9cyXNl56+jqd7uBM+nKrK0ZSwrb3HkdFORt9bJenSprbt4XetE6DeI7aA8o9psXN2BzX52HABB9Abk5w+560FXUInM7hJaE94JlKS8v46p+MhQH9GilzzitHN6wuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719333205; c=relaxed/simple;
	bh=tEXyC+BSJzU7y5j/nQdj8WW3hejE8zOrX2GYZjzceLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEg+uPPIP3igG/V4ZKq7/HLOVKJY/dK5WuiDCx9Qyq2u/j6T7K4/nFpgjcmjIU9HjmtcTqEVFh6BTT+vr1GYuwMUhdKAuPQvm2BMhkmR13dMBKgO4+nh7nfB6jJ/Idn4RkhJs/1wFokZF0tnOo9rpVHKOewGCsSWG+Ii7xwFkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KABxxaxK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KABxxaxK"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W7r3x1VxCzllBdl;
	Tue, 25 Jun 2024 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719333194; x=1721925195; bh=tEXyC+BSJzU7y5j/nQdj8WW3
	hejE8zOrX2GYZjzceLQ=; b=KABxxaxK3+9cugiVC7GZttEhzcdv5fEhpM2SgC/i
	QhXMi9eaJi88Y/o0SwX3+m3F8xnE4RtASFmWLCAazGRemEuLxKGnMcXOJpVm7mSL
	BClpPVJp7Km2olHe0CbrcMr8DBifz81CvB3fkO2ISvHUr38+t1eau8EAVEtaCziF
	f1L0t1x0jHxkrgFtX0QcMbk/xw1iAlUmy5eXVJb/nMEebs34wacLGneJrkBEaTSI
	cW81LHgN89H7mLMRbyNjDRu8ON8uy+OpI2X5CDYF/bh1lCz99oC3RvO4U09amfVY
	GaQsj6SCVItWXxqLfdqEWL7XUoQvwZyQswgS8Vu8hfXs1A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IlxQ6ckyjWHn; Tue, 25 Jun 2024 16:33:14 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W7r3s1LvMzllBcw;
	Tue, 25 Jun 2024 16:33:12 +0000 (UTC)
Message-ID: <b302c1ae-2cbb-4906-81f2-285c2b913109@acm.org>
Date: Tue, 25 Jun 2024 09:33:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-9-bvanassche@acm.org>
 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
 <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
 <671bb45f-22a1-4f81-ae93-65bd5a86f374@acm.org>
 <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <167b737c45ff3c9b9422933d45b807929d0b83de.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/25/24 3:04 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> When eh_timed_out() called concurrently with the regular completion
> handler.
> Both process use test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state) to
> set SCMD_STATE_COMPLETE flag.
> test_and_set_bit should be atomice operation? and only one can set this
> bit than run forward?

Yes, only one of the two test_and_set_bit(SCMD_STATE_COMPLETE,
&cmd->state) calls will set the SCMD_STATE_COMPLETE bit and only
one of these two calls will return the value 'true'.

> BTW, I still don't understand if both eh_timed_out and regular
> completion handler set SCMD_STATE_COMPLETE,
> what is the relation between SCMD_STATE_COMPLETE and
> ufshcd_queuecommand null pointer?

While ufshcd_eh_timed_out() does not set the SCMD_STATE_COMPLETE bit,
its caller may set that bit after ufshcd_eh_timed_out() has returned.
Hence, a command may be completed while ufshcd_eh_timed_out() is in
progress.

Thanks,

Bart.
