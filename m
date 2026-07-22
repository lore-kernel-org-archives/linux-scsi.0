Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987D33655D6;
	Wed, 22 Jul 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744877; cv=none; b=ainqLcZL/cS4Ej0C8zIflpYjc4Mis9wuKEa2Y9WzV4SisfayLrrAL9Gxn15wDJ/JyKk/aAWa6+TZU3/emiFiDZNL0JKL44XO65AODEEnTETe54gK/544KDJu8faPKRiCWcMjvJRQWNsI/87x1nzFLiyGeDWNEdIntYfMicBY4gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744877; c=relaxed/simple;
	bh=01FV08OpE0RCriY/7L9JZOM4PprVz2+KCaviqHo9XU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvJsaEznqG2LaHZC0JV9LRaopX/iD6xuR3nkCgvdJx30UuUiJfLUdWd2ZydxNq4uByZVH1bNV0XWjMohhIziklaX/ktG+BwyaudEmDRSa02uxlFLiRYlFLYPJXuu05k7CLcgibTgmuSTqUbiDjGXt8I4fVpaOGfzIOLX9WWHTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=r6tUQZ4E; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="r6tUQZ4E"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h52mr0Hqrz1XM6JB;
	Wed, 22 Jul 2026 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784744871; x=1787336872; bh=9FtyShwmOf5mWR7My0kkKtMw
	l6PX38PMXynRThINBMA=; b=r6tUQZ4ENvPpLf9eqxQ3QKtWD6r3DO2Ef1DYm1Yb
	lu2lgWA2unw1/uCJ8b+YtPCsdm115DRwAUBL34OH6Vle995MdNu4mGxW4DPx1raF
	+vFWbS6aWgy1JoccVR8IXqHvL4nBN3iCIrfnB6RCWrlgLwOcGXPWiBhKa6cK013o
	mN/57zEwCZ4YO55EExEATfFq47UuLFgUV0qfiVifIIhYwaS8+x0FaQaUzqxvxHvx
	03uKLDOGzTkneNKs1zHPGQyDHboPT992Ng3cK+w7DViZ5aC0Nxn2FW8sT9U0H0rk
	Lr1qPNht0Sss7ha9iJelnVOVSf5cTLI93yBv+Y097+71TQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 39ZRgGX3FYGh; Wed, 22 Jul 2026 18:27:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h52mj4Tbtz1XM5kD;
	Wed, 22 Jul 2026 18:27:49 +0000 (UTC)
Message-ID: <0372449f-f41d-4484-a301-2a1bc15b0483@acm.org>
Date: Wed, 22 Jul 2026 11:27:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
To: Petr Vaganov <p.vaganov@ideco.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20260628185229.37957-1-p.vaganov@ideco.ru>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260628185229.37957-1-p.vaganov@ideco.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/26 11:52 AM, Petr Vaganov wrote:
> During fuzz testing, the following issue was discovered:
> 
> BUG: KMSAN: uninit-value in __dma_map_sg_attrs+0x217/0x310
>   __dma_map_sg_attrs+0x217/0x310
>   dma_map_sg_attrs+0x4a/0x70
>   ata_qc_issue+0x9f8/0x1420
>   __ata_scsi_queuecmd+0x1657/0x1740
>   ata_scsi_queuecmd+0x79a/0x920
>   scsi_queue_rq+0x4472/0x4f40
>   blk_mq_dispatch_rq_list+0x1cca/0x3ee0
>   __blk_mq_sched_dispatch_requests+0x458/0x630
>   blk_mq_sched_dispatch_requests+0x15b/0x340
>   __blk_mq_run_hw_queue+0xe5/0x250
>   __blk_mq_delay_run_hw_queue+0x138/0x780
>   blk_mq_run_hw_queue+0x4bb/0x7e0
>   blk_mq_sched_insert_request+0x2a7/0x4c0
>   blk_execute_rq+0x497/0x8a0
>   sg_io+0xbe0/0xe20
>   scsi_ioctl+0x2b36/0x3c60
>   sr_block_ioctl+0x319/0x440
>   blkdev_ioctl+0x80f/0xd70
>   __se_sys_ioctl+0x219/0x420
>   __x64_sys_ioctl+0x93/0xe0
>   x64_sys_call+0x1d6c/0x3ad0
>   do_syscall_64+0x4c/0xa0
>   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

dma_map_sg_attrs() shouldn't touch the data buffer. Is the above warning
triggered because of the kmsan_handle_dma_sg() call in
__dma_map_sg_attrs()?


>   		last_sg->length += pad_len;
> +		sg_zero_buffer(last_sg, 1, pad_len, data_len);
>   		cmd->extra_len += pad_len;

Shouldn't sg_zero_buffer() only be called if CONFIG_UBSAN is enabled to
prevent that this call negatively affects I/O performance?

Thanks,

Bart.
