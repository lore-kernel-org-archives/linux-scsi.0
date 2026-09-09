Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E47B328611
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976521; cv=none; b=S1ii/N8iZ9JRcxy6eC1YtxAUIEaZwTxpKFNDBF1hJV23bnrPw3PLjjmwVEaHXKDIsCrNkqq11Faww/rZrpesbwQu6BisaBiddmEZAfPSxKkekRY7e+rttijtYHMqCcNJDpx9SzS4cKursK+xPRHofJm4GrzpWrGp5JLUe/jwg7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976521; c=relaxed/simple;
	bh=V6xhegSJgvytNo6GtTUmLbCG4pkGgDwa9PMPQr3jIQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZgFwNjQltjLqPJPI2bFIKBcf34EAH6n2/EfdXrLLHIdmOermEqSqZATUIrbrcvmcU+WOlnHgEbHx3Pf59ErZGfZ+2ufLWxMWyyjm8McGJTQNk5eeLS8afwAkAcXPZSMiaZ9rGIcJq60zc5876ndgFMwpAtozfau4ta2uA2slI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uoB3SfXb; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uoB3SfXb"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hg7kb2hTLz1XM311;
	Wed,  9 Sep 2026 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788976516; x=1791568517; bh=hHDKS/wtU0wiCUG0nRvo9ozY
	zOKNKHCepGgNbfJzPsg=; b=uoB3SfXb2rX40xYsWpLIo5cefwKrTC+7vHtsMHoS
	mlj8PMinph8hZ/V8XhoYD9tse0+ZrrJdWCnte964yKaFfF2jiz7tcb2zO1GEDi3F
	Jgw3ouwIfGLxVwwDckt6a+/dQtDT1PGV7UswYNEsW1fxdf2FpbFqjH9q52LVvdXu
	HghiJBO98zl/RUUg2v9SKeGIO8qU5LLLv0vKXTfJfijYmgX8HqvzoF93A7JfoD9U
	k+MNNzPeAjrEMyXvPu+2SnPKaorHWbPP9h4S01XuhGlkShqJW6oER5jJSD77mSeC
	DAtcyt2js1oos3pDurPuoHaMQgnwGcyGpFW4rOKLI7cCcA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H0mLqTpLETLR; Wed,  9 Sep 2026 17:55:16 +0000 (UTC)
Received: from [100.86.178.220] (unknown [104.133.214.192])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hg7kV65DFz1XM4Sx;
	Wed,  9 Sep 2026 17:55:14 +0000 (UTC)
Message-ID: <27d34a00-8bee-4cc7-8d2e-41166affcd9c@acm.org>
Date: Wed, 9 Sep 2026 10:55:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: core: Clear cmd->flags for terminal queuing
 error
To: John Garry <john.garry@linux.dev>, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de
References: <20260908120841.185742-1-john.garry@linux.dev>
 <c46f6c74-2aa0-4aad-a234-7ff4ba367bdb@acm.org>
 <60306ea1-f186-4f63-b29b-aebdc0433945@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <60306ea1-f186-4f63-b29b-aebdc0433945@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 9:49 AM, John Garry wrote:
> Yes, logically this looks the same. However does scsi_cleanup_rq() need 
> the unsetting of RQF_DONTPREP at ***, below. I suppose that it is not 
> doing any harm if the req is going to end.

It's not necessary in the scsi_queue_rq() code path that we are
discussing but it improves consistency because clearing RQF_DONTPREP
reflects that the scsi_mq_uninit_cmd() call undid the changes made
by the code that sets RQF_DONTPREP.

Thanks,

Bart.
