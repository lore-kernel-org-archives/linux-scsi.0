Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A712D248A;
	Tue, 19 Aug 2025 19:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631268; cv=none; b=IK3u2OQxQna8Ct7nn7tfxdwFtQVPFPNPzrN4VqxObKHV6SUPejAlPTvkvuepHAH6L0FFOSFQ3xYYcUInZNxsClGQeUmt+tBulspWYBj8R6uVH5khROkLF7EnMroZP9mkmH+Aq3O1csMNSh9/P/UvPPzZfcszZIZFUbYUO0dJP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631268; c=relaxed/simple;
	bh=tOGoJFPH16Dim7LwFxXMTdrj4KdFpOiw6TPs3YcSlrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FOzBj/efI7+LLZaptRvTFC5okxxKJiFrLvEKxXji6Nv9rMi+CNi8/p5b6KRbvti7Fsd0WteEL0LEuFc7SlFHjEeYMBDvk1fasNxrfl0GuvxT67xcZM6a3kwDuf8Gbx4738bR53Ht6RS8AgUuF8G/sHeo8GgiD9yaus12+8rd9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zI3ZRqRA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zI3ZRqRA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c5zvZ1cBFzm1748;
	Tue, 19 Aug 2025 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755631256; x=1758223257; bh=pRzdCfFjYk8Vdokz4fCzqwUQ
	FMX4J9WA10x/e7yFMmA=; b=zI3ZRqRA0iRGYMbIaM0u0d65VEJ4b74Nt6gQEKOy
	mPuN5UuTA4jNxYd55Cf5heyBeKyYBTKAI6E4EAKDfUtiOh+EHE68Kptk/7AXSwFO
	KV0016uuhuj13JPOtIA1UYL7eXFivjiS/UnUNdpLxgrEUFfVytz375Q0WrEe+S92
	RWhaZ8YHhY7FMiNIujQTybTLXHfc2Av4hGcu/aVL0zogtRH6CrlNHYUKVdneaKa8
	LDzFFDvJ+alRqap+F+Y4c3OGaxFgJ5ccsP1uJ+87pkCEkByBCb/SRq1G8b4ebFPS
	9specoeAuije11jgih2O+lgiD+AMcBVaSpD+jn/x6zS7mg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w_oA_IcGjZ7N; Tue, 19 Aug 2025 19:20:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c5zvT1nX9zm1743;
	Tue, 19 Aug 2025 19:20:52 +0000 (UTC)
Message-ID: <2899b7cb-106b-48dc-890f-9cc80f1d1f8b@acm.org>
Date: Tue, 19 Aug 2025 12:20:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] general protection fault when connecting an old mp3/usb
 device
To: phil@philpotter.co.uk
Cc: David Wang <00107082@163.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
References: <20250818095008.6473-1-00107082@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250818095008.6473-1-00107082@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 2:50 AM, David Wang wrote:
> [Sat Aug 23 03:56:09 2025] Oops: general protection fault, probably for non-canonical address 0x2e2e2f2e2e2f308e: 0000 [#1] SMP NOPTI
> [Sat Aug 23 03:56:09 2025] Call Trace:
> [Sat Aug 23 03:56:09 2025]  <TASK>
> [Sat Aug 23 03:56:09 2025]  sr_do_ioctl+0x5b/0x1c0 [sr_mod]
> [Sat Aug 23 03:56:09 2025]  sr_packet+0x2c/0x50 [sr_mod]
> [Sat Aug 23 03:56:09 2025]  cdrom_get_disc_info+0x60/0xe0 [cdrom]
> [Sat Aug 23 03:56:09 2025]  cdrom_mrw_exit+0x29/0xb0 [cdrom]
> [Sat Aug 23 03:56:09 2025]  ? xa_destroy+0xaa/0x120
> [Sat Aug 23 03:56:09 2025]  unregister_cdrom+0x76/0xc0 [cdrom]
> [Sat Aug 23 03:56:09 2025]  sr_free_disk+0x44/0x50 [sr_mod]
> [Sat Aug 23 03:56:09 2025]  disk_release+0xb0/0xe0
> [Sat Aug 23 03:56:09 2025]  device_release+0x37/0x90
> [Sat Aug 23 03:56:09 2025]  kobject_put+0x8e/0x1d0
> [Sat Aug 23 03:56:09 2025]  blkdev_release+0x11/0x20
> [Sat Aug 23 03:56:09 2025]  __fput+0xe3/0x2a0
> [Sat Aug 23 03:56:09 2025]  task_work_run+0x59/0x90
> [Sat Aug 23 03:56:09 2025]  exit_to_user_mode_loop+0xd6/0xe0
> [Sat Aug 23 03:56:09 2025]  do_syscall_64+0x1c1/0x1e0
> [Sat Aug 23 03:56:09 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Phillip, is this behavior perhaps introduced by commit 5ec9d26b78c4
("cdrom: Call cdrom_mrw_exit from cdrom_release function")? Please do
not call code that invokes ioctls from the disk_release() callback.

Thanks,

Bart.

