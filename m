Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC552C11DF
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863432; cv=none; b=ZOk/65SY/sPofLqrTVFt923GI1pkmaDBmsh9az0SQJMkWrhLeKmiSWC0UIqkjJct1rVKKzjC40j7Lo7F2Vv85WzkyGBYPLaCO31wA750BU0DNw960aqIziS1te6UGklsC4A4LYY+AiPi8GwZZ5LBQuRe5RY445wZiGoG81RuIrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863432; c=relaxed/simple;
	bh=bIUir7tAmehpocp1AFl2OcuN8tRFD27dxZiQs6nKRv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGAK9pd92xO7IIj2jcIChpQB/Um85Nr08AVFuHl5V1cKbEgm4clkrSyFNZjKUxutmQZzVnn1BS5BQRoU5z7DJO/ToFFEGV3gTp0sTdoA8OrXZIEg9Iq1h/gys5kNkDGVsxtGT3vYcMVNi/4OabZMDEa1sSYD5BcBnL49WVu09EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZJ0oe0yA; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZJ0oe0yA"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gHCh015pXzlfvqC;
	Fri, 15 May 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778863421; x=1781455422; bh=XkXttJ+PVrVbaoTjAPpzihf8
	SZQovy0LqjeOWOf8rTs=; b=ZJ0oe0yA/jbXKDg2UiNjTzx2TdytxGkt9TfsFslS
	e3adgb76XOpV5UtK04vtop/PREaXgaBoezPshoRKnT2emv6EG7PvVTNzI/3i725i
	BppFq6522JT2NIkX+Y7JE9ti3FjMCaqCfsIkN0cOSdS3LrYz1nnldAbtvXLLbxlU
	t20NAjhZL6xzEfHae+6hLPbW/CN6ki7izLCPBNPHbaZ+bd5fcSkFkiwqX5h0fcS8
	sGiWiUCr0Nl06ek3iPu7yVNvdAjXSRC/SWHHcoNIgsgyzN0f45vIAtw+GmjQEyQu
	Hx9n+XvlpK9oaIitjLAh6ZwEP8SFS2XmN5CEp+kYTLPMfg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f1mhIl8lTq5j; Fri, 15 May 2026 16:43:41 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gHCgw169MzlgwNC;
	Fri, 15 May 2026 16:43:39 +0000 (UTC)
Message-ID: <2ed721de-0410-413a-bda1-99b5313b072d@acm.org>
Date: Fri, 15 May 2026 09:43:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
 <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/15/26 1:13 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This is not an issue because the CQ head is protected by cq_lock.
> Only the CQEs from head to tail will be processed by ufshcd_poll
> or the ISR. The main difference is that these CQEs will be
> processed later, without holding the cq_lock.

Hi Peter,

Do you agree that the following can happen with this patch applied=20
(assuming there is space for 9 CQEs on completion queues)?

(1) Host allocates tags 0, 1, 2 and 3 and adds the corresponding SQEs to
     a submission queue.
(2) ufshcd_mcq_poll_cqe_lock() is called from thread context because the
     host is polling for completions. The CQ tail is updated but CQE
     processing is delayed, e.g. because the process scheduler triggered
     a context switch to another thread.
(3) The host allocates tags 4, 5, 6 and 7 and sends the corresponding
     commands to the same submission queue.
(4) ufshcd_mcq_poll_cqe_lock() is called because a completion interrupt
     has been generated and processes completions for tags 4, 5, 6 and 7.
     The CQ tail is updated and the CQEs are processed.
(5) The host reallocates tags 4, 5, 6 and 7 and writes the corresponding
     SQEs to the tail of the submission queue.
(6) The host controller completes the corresponding commands and stores
     the CQEs in CQ slots 8, 0, 1 and 2. Hence, slots 0, 1 and 2 are
     overwritten although the overwritten CQEs have not yet been
     processed.
(7) The polling code from (2) continues and completes the CQEs in slots
     0, 1, 2 and 3. This causes three of the four of the commands from
     (6) to be reported as completed to the block layer although these
     have not yet been completed. This will likely trigger data
     corruption.

Thanks,

Bart.
