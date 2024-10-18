Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AC920495B
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729272642; cv=none; b=jX1/07IfdBxyj4n10OdVq/JsghjxhRjd7KT4/NZX5inW0ehj9Px3G78nQGb3knyMa/r2ZZ+Ag2yAo2iQvowEi5KKQ9p5yBEAfS3LkIc3Z7Qj9mFuFnBrRKqRVA/5So4tzfNDtry0LryQfqEcCgf3esIRGOAnDI/ydnf+2pO9omg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729272642; c=relaxed/simple;
	bh=VnJJoD7SsTyj0nFbc9Pc9guiZLti4Wk9BgdIWEwvF+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DgroULxzn30vIJmMEjDens4k1bt6gLzNf1VXqi9EU3lZ79qWEVrSds4XLHpHFbBKMWA9D14VjLeyBKLqTGH7YijDG8xgWSkdYoW6gMUC7El9EUZ2IKNIwXVkh038j6lHGRj3sYMd9MFFd4EH7IxgPiY/nScawhQxjnHWzKQzucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AHPNE8sW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AHPNE8sW"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XVWv11CsqzlgTWG;
	Fri, 18 Oct 2024 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729272630; x=1731864631; bh=5eJIGSV12hgaXdKCbooGT4oZ
	8aGMa9GSa+wd+gt2wvg=; b=AHPNE8sW3u+KVcX8Xjqvo1RF2Qa0Gtg+zItkDxcs
	TebskYMXxDtPYwR2k5IQ14/5MbQV2ujUORUt/Yz5FDdTb2/S3T6AxSekCqH3Ythh
	CkXV6bP6G00oR0JRURLCUNLv9QFqvmEYkwLwi5chRyNJgotgrMaoPkF0adTwod+L
	kixQgtwAVKSojPr1TYqmnfVUOY8+eFmeJf/l6tqBbiYdTj1Ezu+4yu7E6bzmtaTo
	IVB5H6h3+fbbGclxvFT98mft+aee8LWqU3Q8Za00bBmpNcYn3L3VGCiLlXMoEL6i
	7LwSaRIpysTN0yFrD1FY7LOzOw+fLx62Ap/vX/OQsabxsA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pykB_vWBUazK; Fri, 18 Oct 2024 17:30:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XVWtm6TT6zlgT1K;
	Fri, 18 Oct 2024 17:30:24 +0000 (UTC)
Message-ID: <e42e8677-faf3-4ce9-9bc6-ca3e3368def5@acm.org>
Date: Fri, 18 Oct 2024 10:30:22 -0700
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
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/24 10:25 AM, Avri Altman wrote:
>> On 10/17/24 10:50 PM, Avri Altman wrote:
>>>> Use blk_mq_quiesce_tagset() / blk_mq_unquiesce_tagset() instead of
>>>> scsi_block_requests() / scsi_unblock_requests() because the former
>>>> wait for ongoing SCSI command dispatching to finish while the latter do
>> not.
>>>>
>>>> Fixes: 2e3611e9546c ("scsi: ufs: fix exception event handling")
>>   >
>>> I think that when Maya introduced the scsi_block_requests calls
>>> (2018), the block tagset quiesce api wasn't available yet (2022).
>>
>> Hi Avri,
>>
>> Do you perhaps want me to integrate that information in the patch
>> description?
 >
> No. But the Fixes tag seems strange, isn't it?

Right, that patch did not introduce the issue that 
ufshcd_exception_event_handler() doesn't wait for ongoing SCSI command
dispatching calls. Let me look up which patch introduced that issue.

Thanks,

Bart.

