Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833D6309EF7;
	Mon, 15 Dec 2025 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817256; cv=none; b=Ljco0CIh5TPOtQGnXZw5woaB83H4rCDekcxfYpVn99Q4gH8WbNa7tCjFildt5ReQbU4FH/ArPI7hXzxdlyMZvqiXQxr6uGWC9KGm0RgWG0M8glpY6NhFZbrp2MC8xjyYzIfXEvb+hG3F59FklN6TUUtLi6JTR9O3EWqMg1jT+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817256; c=relaxed/simple;
	bh=A8/a4u7TzuNfkMN93bTIkVRRbuTknk1QkfYBjexj6MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hILbEMfWSboA8il6kvpxzBLsp2JdpF5eSLgMX2OebbOr1QmthyZXY+A6JDxWzjzznoyzGI2ti0M1CvSFpMGxw7nEyYbAUrf9fKGD5MHl9PmA8LDngVFSKDQ/q4JP9yopauVGwEpbJSIN6G6RDHNGYvw19bkdWozE1qVQa+yW//8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=laAGiZKS; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="laAGiZKS"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dVQvz0q8kz1XMM2X;
	Mon, 15 Dec 2025 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765817245; x=1768409246; bh=nk9TH875DI0tB7LDOR4Zcx1p
	30Up18YMJO/6J1I24go=; b=laAGiZKSJt/SJWbd43G4foKj3QQhhennBS0KNP72
	h0/UYlFe1wnGcLaCudolhZuJugKev3kWASefRQTmXNuQNOJJ4RBbaqzmYUN/cf07
	4kalnz5a2+/+ZP/MCguQoJF9B4Rak3FBcjhoM6QOQ7rIJrh98n8j596LtonTgPFC
	3rgeNeTTrOQAff/BFEAkjbIbIbnRGrJX5w5czOFEzAMgFfRgE6vIUaTLPEQV9rPH
	5MMeVQo7JpgNmrJLN3mpi4LPPA4Fsa8cfsPj1M+rbdqlFzc5P4LnBirXil9BbC9f
	Uz1BrywF0JxA4TzWNcoMu/Ul5WDMEz+csRRiVOfOjicARg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cOCvOqV3CnPd; Mon, 15 Dec 2025 16:47:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dVQvw20GVz1XMKfh;
	Mon, 15 Dec 2025 16:47:23 +0000 (UTC)
Message-ID: <54d824db-ec39-447c-8eab-6c2ce4ca87a6@acm.org>
Date: Mon, 15 Dec 2025 08:47:03 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>
Cc: Po-Wen Kao <powenkao@google.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20251208025232.4068621-1-powenkao@google.com>
 <aTkXqslvwMOz2TUG@infradead.org>
 <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
 <aT-jjQpp1UfaiZIU@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aT-jjQpp1UfaiZIU@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/14/25 9:58 PM, Christoph Hellwig wrote:
> On Wed, Dec 10, 2025 at 09:44:52AM -0800, Bart Van Assche wrote:
>> On 12/9/25 10:48 PM, Christoph Hellwig wrote:
>>> As mentioned last round, why are you even calling into the crypto
>>> code here?  Calling that for a request without a crypt context,
>>> which includes all of them that do not transfer any data makes no
>>> sense to start with.
>>
>> ufshcd_prepare_lrbp_crypto() only has one caller. Moving the new test
>> from inside ufshcd_prepare_lrbp_crypto() into its caller should be easy.
> 
> I don't think callers vs calle is the important part here.  It is to
> check if any actual data is tranferred instead of special casing EH
> commands.

Hi Christoph,

Do you agree with the following?

(a) There is code in the SCSI error handler that submits SCSI commands
     with a data buffer. Hence, disabling encryption if and only if the
     data buffer length is zero can't fix the reported problem. From
     scsi_eh_prep_cmnd() in drivers/scsi/scsi_error.c:

		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
					 sense_bytes);
		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
			    scmd->sdb.length);
		scmd->sdb.table.sgl = &ses->sense_sgl;

(b) In general in the Linux kernel it is strongly preferred to fix the
     root cause of a bug rather than to implement a workaround. This is
     preferred because it makes kernel code easier to maintain and
     reduces the chance that new bugs are introduced.

(c) Disabling encryption in the UFS driver if a command has been
     submitted by the SCSI error handler is a workaround. Patch [1] fixes
     the root cause of the problem, namely the SCSI error handler not
     setting the encryption fields in struct request correctly. We prefer
     [1] because UFS devices that support one million IOPS are expected
     to arrive soon (early 2026). Hence the importance of keeping the hot
     path in the UFS driver fast.

Thanks,

Bart.

[1] [PATCH v2 1/1] scsi: core: Fix error handler encryption support
  
(https://lore.kernel.org/linux-scsi/20251203073310.2248956-1-powenkao@google.com/)
