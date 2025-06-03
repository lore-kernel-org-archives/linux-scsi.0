Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2354C92;
	Tue,  3 Jun 2025 19:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748978415; cv=none; b=jy2GA9j5lomELHDTBU+vDzlMmpaVC9tk80t4QpsTfVBM7OWyABaNLs77V67EPtAGMIOQfg+61jdC3Nqo+By1WPHhoYXZ6Lzrm5qxlRITOsuWJUa1MQ9CTjLHyi+D8b4ZdDeozukkZXHYBhA1P+GmHMrL5yhWvmdOLnVqafUqaT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748978415; c=relaxed/simple;
	bh=1rseXZ7/eVVZGaFCE7BEhez7XZ4k5XrquOi0yYRso14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2SjPdxQkdxdl5lI9Lr8tLnt86oCj+qinjrbGggnGYkvf14qSrKC+5vNiRAM8Asfoz2KQsR+Ka+DDsXogmefPBTCkojnrqB1L8yTROVUUrNvIlgJuQQyozbTZ5tM29Ayw9veMjs+IHlHEBqq5uQDhlQtNI5tOYO2stW++IXeO6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rGrRSAO/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rGrRSAO/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bBgX72m85zlgqyG;
	Tue,  3 Jun 2025 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1748978405; x=1751570406; bh=BRhLyAYg+IYU841bf4IlcUL+
	fCVB77GQGBHNNn1DMpk=; b=rGrRSAO/9YhVXqg6bxkq2j0++H/H7SolJeDsMHWv
	RTpSOf8mJxjcnmodJEC/sBqRau6aG8ioheAY9Nbd+0ujpMZBJWdKGDeLDTBFInRS
	V56OlAE25tsxepx78z+bgnMTBBVZoZTgk/tCIpPj33Rh5ElQ7tgHCJAQMXrHhWDv
	3JZPy0EMHgkjeomRTbpp4TGnN+YTl08QEKrHrbP1tBB1GnsyxJ/O2dvua5XPbmmV
	x4FDUJ2U138d6uW5Urzgqy5Ec4nM+sYp6e/opzwDLyVzNgN1Kq2Z61nNdn0LPBjf
	qhRZQysu1ewbmk5Ncx7Km9Zzfns4LwRL/igNnX2MizbV8w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sfqMSXRwLN5G; Tue,  3 Jun 2025 19:20:05 +0000 (UTC)
Received: from [192.168.200.62] (36-226-204-54.dynamic-ip.hinet.net [36.226.204.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bBgX00Zqbzlgqy7;
	Tue,  3 Jun 2025 19:19:58 +0000 (UTC)
Message-ID: <ac157481-9cd3-47be-92f1-67a67b1b726d@acm.org>
Date: Wed, 4 Jun 2025 03:19:54 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] sd: Add timeout_sec and max_retries module parameter
 for sd
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <174892923909.3887244.10526006121005369450.stgit@mhiramat.tok.corp.google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <174892923909.3887244.10526006121005369450.stgit@mhiramat.tok.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/25 1:40 PM, Masami Hiramatsu (Google) wrote:
> For example, enabling CONFIG_DETECT_HUNG_TASK_BLOCKER, I got an
> error message something like below (Note that this is 6.1 kernel
> example, so the function names are a bit different.);
> 
>   INFO: task udevd:5301 blocked for more than 122 seconds.
> ...
>   INFO: task udevd:5301 is blocked on a mutex likely owned by task kworker/u4:1:11.
>   task:kworker/u4:1state:D stack:0 pid:11ppid:2  flags:0x00004000
>   Workqueue: events_unbound async_run_entry_fn
>   Call Trace:
>    <TASK>
>    schedule+0x438/0x1490
>    ? blk_mq_do_dispatch_ctx+0x70/0x1c0
>    schedule_timeout+0x253/0x790
>    ? try_to_del_timer_sync+0xb0/0xb0
>    io_schedule_timeout+0x3f/0x80
>    wait_for_common_io+0xb4/0x160
>    blk_execute_rq+0x1bd/0x210
>    __scsi_execute+0x156/0x240
>    sd_revalidate_disk+0xa2a/0x2360
>    ? kobject_uevent_env+0x158/0x430
>    sd_probe+0x364/0x47
>    really_probe+0x15a/0x3b0
>    __driver_probe_device+0x78/0xc0
>    driver_probe_device+0x24/0x1a0
>    __device_attach_driver+0x131/0x160
>    ? coredump_store+0x50/0x50
>    bus_for_each_drv+0x9d/0xf0
>    __device_attach_async_helper+0x7e/0xd0  <=== device_lock()
> ...

How can this happen? The following code should prevent that a hung task
complaint appears while blk_execute_rq() is waiting:

static inline void blk_wait_io(struct completion *done)
{
	/* Prevent hang_check timer from firing at us during very long I/O */
	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;

	if (timeout)
		while (!wait_for_completion_io_timeout(done, timeout))
			;
	else
		wait_for_completion_io(done);
}

> +/* timeout_sec defines the default value of the SCSI command timeout in second. */
> +static int sd_timeout_sec = SD_TIMEOUT / HZ;
> +module_param_named(timeout_sec, sd_timeout_sec, int, 0644);
> +
> +/*
> + * write_same_timeout_sec defines the default value of the WRITE SAME SCSI
> + * command timeout in second.
> + */
> +static int sd_write_same_timeout_sec = SD_WRITE_SAME_TIMEOUT / HZ;
> +module_param_named(write_same_timeout_sec, sd_write_same_timeout_sec, int, 0644);
> +
> +/* max_retries defines the default value of the max of SCSI command retries.*/
> +static int sd_max_retries = SD_MAX_RETRIES;
> +module_param_named(max_retries, sd_max_retries, int, 0644);

Shouldn't these parameters come from the SCSI host template rather than
introducing new kernel module parameters? It is impossible to make a 
good choice for these kernel module parameters if multiple types of SCSI
devices are present (USB, HDD, ...).

Bart.
