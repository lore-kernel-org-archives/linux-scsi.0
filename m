Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317C1C5D7D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744216989; cv=none; b=scDX/Zj1Ijzu4lh8Vb87av9P12ajE20B+ZXKnq6EIAyXweifS8h24a7cK0pLVfYQYhTmn7UbhdDCtLtz1C+yntjPgJ+dsQD7DHXRONR4g18K1DGkodmaF/muYG9aMAD49Zxeuy9u0lc9dnn1+4aPYwTq58I5pVJ0cY7Zu483amU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744216989; c=relaxed/simple;
	bh=QRqdvXqISrbWXTqqH1H3X9/cvwxIy9poc39hAskSXlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZrt6s3kQBUejwcoEQZDA9TWw/QQCoooBeP/9coQbBsykZOpRyyd2VwlqaQRnUEqKjgN8D06LQEk2kL/UgIa+fzxql1FyhPFi6zsh+lhd2UTD2VNZuQPRb+IVRVXtQp3SInKO3KC6L7sJeo1RhZRfEfgT9GPIek/5LAXJeip1oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qgJnmrtR; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qgJnmrtR"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZXpfL3bT5zlng8Q;
	Wed,  9 Apr 2025 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744216984; x=1746808985; bh=QRqdvXqISrbWXTqqH1H3X9/c
	vwxIy9poc39hAskSXlE=; b=qgJnmrtRZ/zZsV5A6LHi8gJkW30UGQUZXNDI0c5Y
	+/G1UkwXwpBPnaDRP6HOUloS1ohJXwpOeNgpsWOOAjeYa+oyPdbKukkMKeUcYqk0
	BuDxePI8byIgH2j7ZcYDc2HfM8ArYb6H5aVD6yARAjgLoFmVOAtJnY9b9Xlp5Bqm
	reKwbohp9f8FKCxwUzdLWVHjjdNY9F/tym1AskEOY0CINjavt77+81JVN5xV0mQW
	THcJ+RL7SGzRMzTEBq6bylYo9NyFCDoqteUpDkdYzM8zV9gPlwN+MKB9r4X2vUp8
	9f/6PmFE+7CzrcWcs8MjpeouHoDFnR0DQx7IJFF+0FgCVA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EhBCerixiOfz; Wed,  9 Apr 2025 16:43:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZXpfC3K3Lzlmm7j;
	Wed,  9 Apr 2025 16:42:58 +0000 (UTC)
Message-ID: <3bd786ae-1def-4e7c-9ea5-884204f70315@acm.org>
Date: Wed, 9 Apr 2025 09:42:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/24] scsi: ufs: core: Call ufshcd_mcq_init() once
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-18-bvanassche@acm.org>
 <PH7PR16MB6196C7D2CAE1E37913264AA0E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB6196C7D2CAE1E37913264AA0E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 11:52 PM, Avri Altman wrote:
>> Make sure that ufshcd_mcq_init() is called once even if ufshcd_alloc_mcq() is
>> called twice.
> Maybe elaborate the commit log, or even the cover letter,
> explaining how patches 14..20 fits in the bigger picture of removing the lrb array.
> Because it seems like you are going through a lot of trouble,
> but essentially the queue allocation flow stays a 2-phase process as before.

Hi Avri,

Making struct scsi_cmnd and struct ufshcd_lrb adjacent implies
allocating the SCSI host before any device management commands are sent
to the UFS device and before the UFS device queue depth has been
queried. Hence, the queue depth must be modified after the UFS device
queue depth has been queried. Modifiying the queue depth involves
calling ufshcd_alloc_mcq() a second time. This patch prepares for
calling ufshcd_alloc_mcq() twice.

Thanks,

Bart.
