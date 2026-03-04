Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754E7366544;
	Wed,  4 Mar 2026 12:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626900; cv=none; b=QK6xoYFQY4k9wp/Z3XtVjrC4b7eNhmgzLdoKOgIBalmvVToXTuHKdeORMEvypWK5pkPbjbPbRjzbiR0/zTdgCQzq+frOk5tVWhOufs0omDZb5eh6sBFSMdINZGPXJtSs8iQI5HTWfz4ubLmtW4soLAqWXjCL+BtasyPPTCbgrMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626900; c=relaxed/simple;
	bh=4KsvjWjuCfdFRNMqn7L1Wo9HHjUqZtzdjmF5eVONFkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rwOje+FLqawE0eUaOR3iHtbAS9x4RcpNLObl+nHFGDzcv7TZsm7eZyo52TkjCLwRHNv69Svs7U1kT+TyHZ3PXctgNjWKSPYBpW/NeZ436v0naHZnN+ZStswBEqMgG7Nt6v0VBUy/Z+PX+CRIV7x17ZKmi/XBz/6teRa69sVWoUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g/PNWiz1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g/PNWiz1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fQsGp6p8Vzlfgf6;
	Wed,  4 Mar 2026 12:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772626894; x=1775218895; bh=4KsvjWjuCfdFRNMqn7L1Wo9H
	HjUqZtzdjmF5eVONFkg=; b=g/PNWiz1W18T69/2jTj172EIx6yS1yxvx1jNRXZS
	s7kgtALfDNzBtwA3+zdVXno3oEF90drckmkKBwDhUIoDspc075v5/BjvcYs3PJnp
	62YURmcCMNklEqj308nzCFL7IvTVfbQjBf59sGfn+N3I8DD+MiORPQI0i/SqeHG6
	bkr9DrRankaZ2UsF/+A2lq7QI0X5g4CW3P9phPntvDwKkt6yW4nUBaxuQRMfbvYz
	1kFDwA0LryUV4qCBV6/AUryowR1vtDtXJltN0nhW2DNpzXrEyJts+OH5D004QFi3
	asnSewSrKJYkSDgg8X6YPFao2xP5TifELJcVo6aHe6005g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xXiJx8rjw82Y; Wed,  4 Mar 2026 12:21:34 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fQsGh0Mvvzlfl5P;
	Wed,  4 Mar 2026 12:21:31 +0000 (UTC)
Message-ID: <8ae81fca-7366-4ee0-81ea-1c86f1e4c88c@acm.org>
Date: Wed, 4 Mar 2026 06:21:30 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
To: Chaohai Chen <wdhh6@aliyun.com>, John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 dlemoal@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
 <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>
 <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 3:43 AM, Chaohai Chen wrote:
> On Wed, Mar 04, 2026 at 09:20:25AM +0000, John Garry wrote:
>> On 04/03/2026 07:57, Chaohai Chen wrote:
>>> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
>>> but this approach introduced naked reads in some code paths.
>>>
>>> Convert async_scan from a bitfield to a bool type to eliminate bit-level
>>> conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
>>> memory ordering on Alpha and satisfy KCSAN requirements.
>>
>> Is the shost->scan_mutex always held when shost->async_scan is read/written?
>>
> Yes. In theory, there is no need for READ-ONCE/WRITE-ONCE. Plus, this belongs
> to defensive programming. And it indicates that this is a shared variable,
> which means that this variable will be accessed by multiple threads and
> concurrency issues need to be handled carefully.

Using READ_ONCE() / WRITE_ONCE() for member variables protected by a
mutex is wrong because it confuses people who read the code. Please use
__guarded_by() to document that the async_scan member is protected by
the scan_mutex. More information about __guarded_by(), introduced during
the 7.0 merge window, is available in
Documentation/dev-tools/context-analysis.rst. As one can see in that
document, Clang 22 or later is needed to verify __guarded_by()
annotations during compilation. Information about how to build the
kernel with Clang is available in Documentation/kbuild/llvm.rst.

Bart.
