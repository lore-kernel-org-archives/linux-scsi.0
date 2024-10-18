Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5728B168488
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729270908; cv=none; b=B5VpuwMVT+8iCWvDhI//dEVp5FGy10E8Yqjz+9B9AyJigsZmITnRVYhRhPEereR9N1QZK1xu97+V57/N54OcpqIxSvmeiWLhOdSGg78I2Orx0I8uvGFd249DnWojSmnsFr3IIeHMdmzJsMuGXARFUgVd8xke5MMOX+CKG5JeV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729270908; c=relaxed/simple;
	bh=uDp1vRFCGHe/FSqvrH5o5MmVgRhd77jn3H1KSdbCABw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJlEsXt4nlvILwiz8AVDnGIl4OfD30ebnUmTuQ/xxOA5Hx72+vea6jPY5uEVM3Xp32AdK23a2Eao2cksS7e+u/L95+kL37oPnkAWjyKHRISuu7ILR8KhGZGRmCo5gW//U80CMk+ySe6rl7VJoAP3xZNd2sHsiLfH9ql8Z/3nX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x/dd6LvW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x/dd6LvW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVWFj4fJRz6ClV8W;
	Fri, 18 Oct 2024 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729270898; x=1731862899; bh=58jHIC6byV6TZZweESy/1sOh
	tEE0CbEsZhNy8BRU8p8=; b=x/dd6LvWJ720wEgtkOgA0nEMeCQ89chi2E4KM1n9
	zT0UgiYIknA1L3xJIbiJwMWmttTIrMDB2ef6AD2UCK1xZPyI5F8MQlOG/frRD3Uv
	FklKuKFQCc1/ZMC4fKCRi4cJpYJqQ9WG2RL3y5oPGCUkNCdmctDnzhoqxCuagG8x
	2ef6jl7vOl4URb2gxILYdcF8dqBLdrwJGVLztlemUXLUnLNqWlIyqTvoL383b5Dc
	iSXDOFThR9nIl486SbX3zBHgN+mVSP514Fqmn5czEpbRz6HfrtymWnSRA4c9b4Bp
	WDfvQdb+N6Ob5UWwJpGC+BGfRnYMjh7+4UaoyGLFkTt85g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H3qJgVry6HdI; Fri, 18 Oct 2024 17:01:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVWFV6knNz6ClSpy;
	Fri, 18 Oct 2024 17:01:34 +0000 (UTC)
Message-ID: <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
Date: Fri, 18 Oct 2024 10:01:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Maya Erez <quic_merez@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>,
 Can Guo <quic_cang@quicinc.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 10:50 PM, Avri Altman wrote:
>> Use blk_mq_quiesce_tagset() / blk_mq_unquiesce_tagset() instead of
>> scsi_block_requests() / scsi_unblock_requests() because the former wait for
>> ongoing SCSI command dispatching to finish while the latter do not.
>>
>> Fixes: 2e3611e9546c ("scsi: ufs: fix exception event handling")
 >
> I think that when Maya introduced the scsi_block_requests calls (2018),
> the block tagset quiesce api wasn't available yet (2022).

Hi Avri,

Do you perhaps want me to integrate that information in the patch 
description?

Thanks,

Bart.

