Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B4024A062
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789307; cv=none; b=Dskto8Tzs7AYG3+9+nXSCAmNOrVkSGfymzcCm9rMleIXu1uBs+lVUFZCgAemexyP44Bx8sZCGMW4DK4vU76KsKyiEAHZkNFrDVzo7u2K1XM7iLfqt+ysnRcCSpmaAn0f2BnhC1t4XvGvCVLA1eVeSXcZAxvezM5Pf9CNyXk2I/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789307; c=relaxed/simple;
	bh=NYFEv0VYMa7EUBici5isRQAN0iE2RUP3kydwB95u1lE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jl50vJmcZ9YmaWTf732870D7cLArFNKKeafzoCtvGeVUFcJFPgQ4xvLAsfRcXfYPW0cvYOBdQ1JS0qyDrXs8tEu0Obz+13854w7I4yuHgqLmHgfMarIxEQg5ghwjkjbe5TCpp4WtKORdRW2P0biSQ7M6DjfWz+ZgsWI9dO2y6wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rS98TI5p; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rS98TI5p"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZCXr20GVnzm0c3B;
	Wed, 12 Mar 2025 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741789295; x=1744381296; bh=NYFEv0VYMa7EUBici5isRQAN
	0iE2RUP3kydwB95u1lE=; b=rS98TI5ppvyQteyvUcrLrsNP6KWrCPqdwrnimgLr
	pvLx3iCZkb/qwctBhTvh1XNnMKoO96et6Dheww2wo+aVb7dsCaZMf0T9cPfODTOB
	MwBwA2Wewt0cwQDnkOTIBoL3dbBBvoSCAlRZ31GSjmidBzFOvZbsgrfXY4m57l5h
	YRA7AHpP4ElXSbt9I8U5tQBAdZNhXjHYp6gdRwsOMgkAvdERH+JW86ayz1e+Y1Lr
	IpDDEPCkhND/Kn+NuqpQjj0ldARwPIDmYmQNDB619yyFJuCphaQnpI0jUBod1DNG
	vyhYdSRLa1wSVcQOZCTFBBgl4bUf/9eiBoCrXLRRTonohQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BfjWKy27_smV; Wed, 12 Mar 2025 14:21:35 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZCXqn2Xkdzm1Hcg;
	Wed, 12 Mar 2025 14:21:24 +0000 (UTC)
Message-ID: <088fdfb9-00c7-43a9-acb9-e5300923d129@acm.org>
Date: Wed, 12 Mar 2025 07:21:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Can Guo <quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
 <PH7PR16MB6196B6AD43F68C7BE8128332E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB6196B6AD43F68C7BE8128332E5D02@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/25 12:33 AM, Avri Altman wrote:
> Hi,
>> There is a TOCTOU race in ufshcd_compl_one_cqe(): hba->dev_cmd.complete
>> may be cleared from another thread after it has been checked and before it is
>> used. Fix this race by moving the device command completion from the stack of
>> the device command submitter into struct ufs_hba. This patch fixes the following
>> kernel crash:
 >
> Can you elaborate how this is possible if there is a single tag for device management commands,
> And it is obtained under lock?

Which lock? The code that submits device management commands is
serialized by the hba->dev_cmd.lock mutex while ufshcd_compl_one_cqe()
calls are serialized by the hwq->cq_lock spinlock in case of MCQ. I'm
not aware of any single synchronization object that serializes all
hba->dev_cmd.complete accesses.

> And why making the completion structure persistent beyond the function's scope solves the problem?

Without my patch, hba->dev_cmd.complete is sometimes set and sometimes
NULL. My patch ensures that the pointer passed to the complete() call
is never NULL. Does this answer your question?

Thanks,

Bart.
