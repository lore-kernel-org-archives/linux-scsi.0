Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7834BA4C
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758133278; cv=none; b=sYO1/uq0x5nejErykWwe6/lJ1xWe7CdyXb9qkrYWJOde42hvXK2vWRjDDSSddNrI/dvnCbZVPjfX34hmWenzzaENrS4sDVNrhOpAyFrJManLVybnXNOPrDPGa1u4fLaqgz3iIQWQdgR+Zgp4ZoUcI3Up9bflE7hwWUTTgf+HnQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758133278; c=relaxed/simple;
	bh=ryZJkL3YIitFIZ4KCyUubnm4nI8QXpXiPmQM0ZYxYok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2ekP7XxjFVPeh8VpmPlOVcGUtGU4ZPTmYCa8slbS7/58VAPotsd39VvIYJumdHCOHFNo1W+vonefwL6ik9nKSvFzgrMaEbY7ljqvwcX0ybbYfa8QjRkJzuxRjB3zzFEw9V5WYYs+klEcqAm1ExI1ahkbCqIBKN3vFSWy+eSj7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2RQ6dtd/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2RQ6dtd/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cRnCF0fWfzltPtQ;
	Wed, 17 Sep 2025 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758133271; x=1760725272; bh=ImIx1JA/eSo1ypFEW/fe484U
	IyNmXaBQMdtJIyHdljA=; b=2RQ6dtd/cbi141OjLLKsRFziRWYV+bWwBZnkAnCH
	iw/0bLoHMyXC9AlawCwk4ZA6mesDl0z1NHUIzVLH9tDHklBu/r0yI24zpBly4GuH
	acv2aErMKm1bWZun9nKRloQGhvBcn4OwPgXvpynDIJW9eOZcLtgue661NbHAjze9
	/2vcRS5kA5Dx5jWdd3+DnNatW2d/PPe1DB7cNkBRXixsDjVjNAjN282Haj/HYh48
	PEhrxLlo3F5LvC6NCuR0a9ErxkT3fT3QCzC9R7PWc/ViabCshEy6zCWEDX+sikph
	CC975NAzYinEI+K92K58BVf4RXdrk+Tr8csWpovL6hRPRA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rHaLUzdQY4_f; Wed, 17 Sep 2025 18:21:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cRnC73cmMzltPt7;
	Wed, 17 Sep 2025 18:21:06 +0000 (UTC)
Message-ID: <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
Date: Wed, 17 Sep 2025 11:21:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
 <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/25 6:08 AM, John Garry wrote:
> I know that it is not ideal, but could we use scsi_execute_cmd() @buffer 
> arg for both in and out data?

The scsi_execute_cmd() buffer and bufflen arguments are passed to
blk_rq_map_kern(). blk_rq_map_kern() shouldn't be called in this case
because:
- Calling blk_rq_map_kern() is only necessary for data that will be
   transferred with DMA. The 'args' data won't be transferred by DMA.
- The 'args' data structure is typically allocated on the stack.
   blk_rq_map_kern() copies data that has been allocated on the stack.

Thanks,

Bart.
