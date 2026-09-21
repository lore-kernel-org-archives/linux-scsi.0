Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E79403EB5
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980651; cv=none; b=A5QByrrgFN5a/SOBOWtcuLRITHIjhub4Jzz40uVHqwuwzLeFvHADqRGvFrIazLQOhJGtWZbLbzpfC+gMEjE7FSzdAgKe7WoOkUSC+0yVyR3rkSGztf/fHchm6/81bVb7FLQBv0VPg4kL9wXxp0A/EVaVd/DitE88guA7Y5rNhX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980651; c=relaxed/simple;
	bh=8Li9ukqpPaIcwue8T5e6RB4FFaFuvrWVlBskY4JQMUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rr8Pcay0AT15mNHifIIf5dNResIyjaPk7oqc/NOroQf/KiSS8dWzYV9qDmJOi/3TG0coa/f9NB/vNjjeCKKcejA8oNorvGDZY5/A9Ep+toEinjTFgLEmhVoOwmKtmEIJCHDwJFdNw2J7xFgUi12W2GmbObYAiR07OqTLNKgqzAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v59JyEKw; arc=none smtp.client-ip=95.215.58.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v59JyEKw"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8Li9ukqpPaIcwue8T5e6RB4FFaFuvrWVlBskY4JQMUY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789980646; v=1; x=1790585446;
 b=v59JyEKw3siAawKAOeGfx/Rvl3oAHeDyBLpV3eYmmIHid6WnEEEVsQal6sfeVd1s4sjz2Fgx
 jlSIyxKXG5Pi5C0QHFLNunEQR+14BTvynpHxD/7mU0A+5EoUzYsONpRvM6IOAWkSvlrrAx/ETD5
 17iqAmZJUkehZnqbX6l5knxQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id d15056592cc9689c;
	Mon, 21 Sep 2026 08:50:31 +0000
X-Mizu-Trace-ID: d15056592cc9689c
X-Migadu-Flow: FLOW_OUT
Message-ID: <b0768abb-8ecf-4622-bbf3-1b3d8f926ef5@linux.dev>
Date: Mon, 21 Sep 2026 09:50:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Make SCSI host scan interruptible
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 21:11, Bart Van Assche wrote:
> Writing to the sysfs "scan" attribute serializes SCSI host scans via
> shost->scan_mutex. In virtualized environments such as virtio-scsi with
> 256 target IDs, scanning non-existent targets repeatedly allocates and
> destroys temporary scsi_devices. Each iteration transitions the shared tag
> queue state and freezes request queues, causing a full bus scan to take
> tens of seconds.

So does this scan use all wildcard "- - -"?

> 
> When multiple processes initiate host scans concurrently, waiter tasks
> sleep in TASK_UNINTERRUPTIBLE on shost->scan_mutex. If the waiting tasks
> receive signals such as SIGKILL, they cannot wake up until the mutex is
> acquired, easily exceeding the hung task timeout and triggering
> khungtaskd warnings ("INFO: task hung in scsi_scan_host_selected").
> Furthermore, once a task finally acquires the mutex, it continues to
> perform the full scan even if a fatal signal is already pending.
> 
> Fix this by:
> 1. Use mutex_lock_interruptible() instead of mutex_lock() in
>     scsi_scan_host_selected(), allowing waiting tasks to sleep in
>     TASK_INTERRUPTIBLE and immediately wake up with -EINTR on signals.
> 2. Check signal_pending(current) in scsi_scan_host_selected(),
>     scsi_scan_channel(), __scsi_scan_target(), scsi_report_lun_scan(),
>     and scsi_sequential_lun_scan() to abort scanning early when a signal
>     is delivered.

If you want to be able to cancel a scan which is in progress, then why 
run it in the first place? I don't understand how this helps.
