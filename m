Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A28A2D4B57;
	Fri, 19 Dec 2025 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766162993; cv=none; b=Byq02d53Ae8F2FPwBytzx5YQ+pSOu4tPXaRk3uRnwVSu+brhr2sVA2fqAcnhEgMkSMuvuUt7qub1ZPhns61UucgrXaRzwYn4EL14b+zp5HFeEb+GD+p5ODk6jw+gS1Fq8QWj4LmJAnKnnOE6bG35yRToTctdT0TS0uwfXnvAAuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766162993; c=relaxed/simple;
	bh=EPeW9ugs65JpH/Mf5Q3FwmSXXWgCwajLERRKpwAcrN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJ4cunTY4gB7YO61Sw/UIzLnXOAuLgy/bzPIxl4vLNsKuHMY71sWgXtQ8LNZb7u2TKQv3y/BFoa5MWJ4nubGKxmpVK2UdirJBp6C7MiWgCMIqGGIXo9J49fE+0M+JSrvHvdj37aTytT8Gx1X5KrjocoMmbFf4M4jnhSQluBtE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M9q2HzYY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M9q2HzYY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXtmv4FPCzlvwY9;
	Fri, 19 Dec 2025 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766162990; x=1768754991; bh=STqlvAgIT/tzGkFFVDW+HwBP
	gIyQq7NxScHdUyVbq3c=; b=M9q2HzYYukd0J3ZqTLMzFYxHgcIDwrSIwEJF64tb
	tGbmXwFsQgS0O6ZdwexqDxrT+6itD+4CPQNMoJnV+WaTIx3LRlNBVKxZfDkQwdlR
	zD5A494pTeSRIVoZRWdGa7/HoXqk4EmQt4mCF+1sucYv0XOLfJNA1bhxDWbJDdWr
	gxNloIWvpDwbzMJiYqzRifmTYwk15+lA4ZntffcNzYw6WNfuuXW+oIDfmqHV7ugt
	/WiWR616RZoOWEdMFBEebdPii1XnRvYHUaeUWhV+duKlT2s6cRGinFEyYgqnWZUU
	16iSo8g9d6QUB50xAEY9/vce3OrTcdvvhQ4vHjkbMUN49A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3jS_07xiv3l4; Fri, 19 Dec 2025 16:49:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXtmr5sDLzlvwY2;
	Fri, 19 Dec 2025 16:49:48 +0000 (UTC)
Message-ID: <c44e75a9-071b-44b5-a280-742a9c5c6cb0@acm.org>
Date: Fri, 19 Dec 2025 08:49:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: core: Fix error handler encryption support
To: Po-Wen Kao <powenkao@google.com>
Cc: hch@infradead.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251218031726.2642834-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251218031726.2642834-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/25 7:17 PM, Po-Wen Kao wrote:
> Some low-level drivers (LLD) access block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
> configure hardware for inline encryption.
> However, SCSI Error Handling (EH) commands (e.g., TEST UNIT READY,
> START STOP UNIT) should not involve any encryption setup.
> 
> To prevent drivers from erroneously applying crypto settings during EH,
> this patch saves the original values of rq->crypt_keyslot and
> rq->crypt_ctx before an EH command is prepared via scsi_eh_prep_cmnd().
> These fields in the `struct request` are then set to NULL.
> The original values are restored in scsi_eh_restore_cmnd() after the EH
> command completes.
> 
> This ensures that the block layer crypto context does not leak into
> EH command execution.
> 
> Signed-off-by: Brian Kao <powenkao@google.com>

Hi Martin,

Please add the following to this patch:

Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks,

Bart.
