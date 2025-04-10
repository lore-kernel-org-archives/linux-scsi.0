Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F9A1C3308;
	Thu, 10 Apr 2025 20:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744318006; cv=none; b=TT0Rqi5m3bdMFdmHKRGS6BgOLH604t+O2KjyKlraleGQPO6ntVxyDk3safrwZaiooPbjEhsWZBLs/ne7YwEI4OJH3GCiUpiYrCMJdL3vCGUtokIfnck6PXgKNZfaYeM+mK7KWLT7+jiOYM6PWV0GErhAB0vufwFPoMNl5GluNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744318006; c=relaxed/simple;
	bh=jjfz2sEMmj3peUrbRTcapLbGRPdp9xvU05ee8BNL0aE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3tfyEbqIOimLEFYOc6Na7Fab8fqcp84FpH7sCKsbDSJzy/UPJdA8aVHIjPhXAcU1Fe6HLB+YjgPJ65J6He2I0G1C6GPO4/yXV1DFYgIW5DBfcviSeIyn5cgnkk8JoFHJC9dq0yBVoXA1uYAZsan9XxTn3pr/UbK1lDcp7MRzUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XIpmAoOK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XIpmAoOK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZYX0q5RdTzlvyCJ;
	Thu, 10 Apr 2025 20:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744317993; x=1746909994; bh=zJFyeR0ZWJOawptBl+t2NsUC
	50GEMlG6RIBSklFrDh0=; b=XIpmAoOKHsNBm4m052pDE3oYjDOgZPFWakcJWrfh
	8Gn/UdEOc0jG8GcOK6cECTcpgCxIkDgrbGF/W0zHpVRlSViHKQjhAJ1ECIHOXmTx
	G9lSyFaB9mNQgfvz3kcyHhVHc9LwsFdXHJr1sZVQtYV4f4Ti3jC77fsRgpw7G3O7
	Zm/d/6AjiBxODMa8P82WrWk4vrBkQxCcGuMQwuXdpp6dXL4JAxDNFMG+uRrN8aQx
	EgwaBL9dbXmvXeiwQj/AnMM6ItoRjhqpwfHtcJz8jrnuvzsvPu5WIf5OHJx4S2v8
	42gA9a8zTuy5vnJ0mQvvGMAGrrY3KKekHzxuyW2lyHKekA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hW6_3JHwXHxY; Thu, 10 Apr 2025 20:46:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZYX0b5XN4zlvyCC;
	Thu, 10 Apr 2025 20:46:22 +0000 (UTC)
Message-ID: <5c4b5e2e-eac1-4be5-bf72-2c151979a5cf@acm.org>
Date: Thu, 10 Apr 2025 13:46:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
To: Chenyuan Yang <chenyuan0y@gmail.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, minwoo.im@samsung.com,
 manivannan.sadhasivam@linaro.org, viro@zeniv.linux.org.uk,
 cw9316.lee@samsung.com, quic_nguyenb@quicinc.com, quic_cang@quicinc.com,
 stanley.chu@mediatek.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250410001320.2219341-1-chenyuan0y@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250410001320.2219341-1-chenyuan0y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 5:13 PM, Chenyuan Yang wrote:
> A race can occur between the MCQ completion path and the abort handler:
> once a request completes, __blk_mq_free_request() sets rq->mq_hctx to
> NULL, meaning the subsequent ufshcd_mcq_req_to_hwq() call in
> ufshcd_mcq_abort() can return a NULL pointer. If this NULL pointer is
> dereferenced, the kernel will crash.
> 
> Add a NULL check for the returned hwq pointer. If hwq is NULL, log an
> error and return FAILED, preventing a potential NULL-pointer dereference.
> As suggested by Bart, the ufshcd_cmd_inflight() check is removed.
> 
> This is similar to the fix in commit 74736103fb41
> ("scsi: ufs: core: Fix ufshcd_abort_one racing issue").
> 
> This is found by our static analysis tool KNighter.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
