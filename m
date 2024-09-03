Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913C1126BE7;
	Tue,  3 Sep 2024 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725397284; cv=none; b=p4yMsjRtSeKVsY9L6xEYZ9u3HlXdimz8xrgMJBdQ4HPvJwO+zTn5H42uPEuhfr5KpQRl6CSCPVuqMCBLVpkX9kLpBFbB6W82EpYgUQMH1ORD7atb919cp2t961PtjAy3E87tsu8QoO29Q+M6kns+bc/FrqdcQe15q6TVjQOP+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725397284; c=relaxed/simple;
	bh=jVhj2xMsWVduincqHIuHsp2XlN6UZ1a7zLSg46WfuWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mfFy0x6NVNwwky5Ns+m3DYsjFdorqiQs+IYkIZYey2cq+2X8DcA574eEFqgACBkOZalY/qwk6SKhNrqdiznO4NsAYd5ppTmKdwE8FeWvMTsGiUt41rWaRK4HeW2w/Drq/41RCtYA78oS3wIjbrPaB5nK9cyFvwsJRvYJavY6Noc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qNm9g//h; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qNm9g//h"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wyyhx5p7sz6ClY93;
	Tue,  3 Sep 2024 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725397279; x=1727989280; bh=GcSbK+dobI0o7Q22prdN5k7H
	CGcrrI0ReHGActTH+uw=; b=qNm9g//hzQagxuHCntXtcEwgtQ8st4tyDmZXxBpt
	V3Z9PlHP5+whFtBwci7Pee32auMSEL1Z4GgTPMmSpWpK12N9uOkrJC4VILCQ8eFr
	coH6pjCocaqcl8QIGcqYMse5DltSYVss054/QxqGPDW2r0g5PBiDXo2WjNzLltEh
	D78VjmVKpIFx01a3XLr3fNMkJHnVJ7RoXXv2tK/tLcQjEqfcufgROQRhEfxnX6Bz
	dQ5eBCl8i9cKyZiduLoiwQtEb4RwJMCLp8bKspLupLhbNJaRRxBgDPKg6ElamGdu
	SwO0PDL9p+En0D71M2LjnRsjlebhV0VCf0oCkj8eUETx3g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Gn4A2Pjt5VLY; Tue,  3 Sep 2024 21:01:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wyyht6HR8z6ClY92;
	Tue,  3 Sep 2024 21:01:18 +0000 (UTC)
Message-ID: <bf6746d0-d8cc-412e-ac7b-6f17c3e3de9d@acm.org>
Date: Tue, 3 Sep 2024 14:01:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib
 function
To: Riyan Dhiman <riyandhiman14@gmail.com>, aacraid@microsemi.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b7f0acf4-5e7d-4491-81be-71518197c58b@acm.org>
 <20240903203121.5953-1-riyandhiman14@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240903203121.5953-1-riyandhiman14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/24 1:30 PM, Riyan Dhiman wrote:
>> Just above the copy_to_user() call there is the following statement:
>>
>> 	list_add_tail(&fibctx->next, &dev->fib_list);
>>
>> Does that mean that the above kfree() will cause list corruption?
> 
> Yes, you are correct. I overlooked that fibctx is part of a list, and freeing the
> memory without removing the list entry would corrupt the list.
> The list entry should be deleted before freeing the memory if copy_to_user() fails.

Are you sure that this is what the code should do?

Thanks,

Bart.

