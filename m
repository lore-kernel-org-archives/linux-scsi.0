Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4391CD1F;
	Tue,  3 Jun 2025 23:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748993029; cv=none; b=M+hAtVrTIR9L9cdgPSdMxmuYoyc228EM/x5LrG2iUu8pChU0d6AAIGP5RKos4K9oscvm5fNKNFrYXEk/7J8w2N2xMTwbxzSM7Ly9TF/ki+xk2TJlhD6/GjW+/vccBDEmKUhQ+hpkwifmPW0vN52y6h5BMSKaLimdviI7/ph93qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748993029; c=relaxed/simple;
	bh=RB3uO5vqD+jkCq8D4eGcycQQpynIt1GzD+jXQPy3FUA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nBD8Z1bijmGrTT4VrdJXPIqk5fDQMVWbf1D5G19BjuXT0xQwpNAkkZZ2rb7GhCyAOqDthknKIG4uZbGzkzqSvPVuWq40fdxd/omvePVC853swoNVYYz703aDTLXPdhtVR+1lEFnzB/bqYFXIwzX+2b9n/rMGwayj88bum60vDIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE+uHbRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE+uHbRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CF9C4CEEF;
	Tue,  3 Jun 2025 23:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748993029;
	bh=RB3uO5vqD+jkCq8D4eGcycQQpynIt1GzD+jXQPy3FUA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AE+uHbRworKsxg+gQl1k8efBWqhhDUhyBgo2QfEMJwxiIWUKl3RxMmF5HYwWpGO3t
	 izyhyfC+bEH1oXtenMRifsInKXj4sHVsWGcv9HJhSQdpITooOIDuhhZQKj+HUOFQoV
	 NGkujnyoIaNemWjOb9JTn4RSP+8ckZtg6c4rqkWd3M3+/d6O6WyT3ZCM2VKU58wQ1r
	 41L8ntbQmCNutQdaleLS4+UWnC8vS24b+vqB5PKIJRX/Mr5gC7BEMGKLfHqo/DVEhb
	 c3ig2C2HqqUp7IID64GzUIhl2vGsktymD58mw/Nq7GdeAi/uR/OmL0ZaVF91mBGanC
	 4XoVGXOHbYraw==
Date: Wed, 4 Jun 2025 08:23:46 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sd: Add timeout_sec and max_retries module parameter
 for sd
Message-Id: <20250604082346.2f00f1776700812215e42ec0@kernel.org>
In-Reply-To: <ac157481-9cd3-47be-92f1-67a67b1b726d@acm.org>
References: <174892923909.3887244.10526006121005369450.stgit@mhiramat.tok.corp.google.com>
	<ac157481-9cd3-47be-92f1-67a67b1b726d@acm.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Jun 2025 03:19:54 +0800
Bart Van Assche <bvanassche@acm.org> wrote:

> On 6/3/25 1:40 PM, Masami Hiramatsu (Google) wrote:
> > For example, enabling CONFIG_DETECT_HUNG_TASK_BLOCKER, I got an
> > error message something like below (Note that this is 6.1 kernel
> > example, so the function names are a bit different.);
> > 
> >   INFO: task udevd:5301 blocked for more than 122 seconds.
> > ...
> >   INFO: task udevd:5301 is blocked on a mutex likely owned by task kworker/u4:1:11.
> >   task:kworker/u4:1state:D stack:0 pid:11ppid:2  flags:0x00004000
> >   Workqueue: events_unbound async_run_entry_fn
> >   Call Trace:
> >    <TASK>
> >    schedule+0x438/0x1490
> >    ? blk_mq_do_dispatch_ctx+0x70/0x1c0
> >    schedule_timeout+0x253/0x790
> >    ? try_to_del_timer_sync+0xb0/0xb0
> >    io_schedule_timeout+0x3f/0x80
> >    wait_for_common_io+0xb4/0x160
> >    blk_execute_rq+0x1bd/0x210
> >    __scsi_execute+0x156/0x240
> >    sd_revalidate_disk+0xa2a/0x2360
> >    ? kobject_uevent_env+0x158/0x430
> >    sd_probe+0x364/0x47
> >    really_probe+0x15a/0x3b0
> >    __driver_probe_device+0x78/0xc0
> >    driver_probe_device+0x24/0x1a0
> >    __device_attach_driver+0x131/0x160
> >    ? coredump_store+0x50/0x50
> >    bus_for_each_drv+0x9d/0xf0
> >    __device_attach_async_helper+0x7e/0xd0  <=== device_lock()
> > ...
> 
> How can this happen? The following code should prevent that a hung task
> complaint appears while blk_execute_rq() is waiting:
> 
> static inline void blk_wait_io(struct completion *done)
> {
> 	/* Prevent hang_check timer from firing at us during very long I/O */
> 	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
> 
> 	if (timeout)
> 		while (!wait_for_completion_io_timeout(done, timeout))
> 			;
> 	else
> 		wait_for_completion_io(done);
> }

The hung task complaint is for 'udevd:5301', but the stacktrace is for
'kworker/u4:1:11' (sorry I should paste the udevd's stacktrace too)

>   INFO: task udevd:5301 blocked for more than 122 seconds.
> ...
>   INFO: task udevd:5301 is blocked on a mutex likely owned by task kworker/u4:1:11.

There are 2 tasks involved, waiter of SCSI commands (kworker),
and waiter of a lock which is locked by __device_attach_async_helper()
(udevd).

The above blk_wait_io() trick is for preventing a hung task on the
kworker which is waiting SCSI command. But if it is done under a lock
and there is a waiter of the lock, it does not help the lock waiter.


> 
> > +/* timeout_sec defines the default value of the SCSI command timeout in second. */
> > +static int sd_timeout_sec = SD_TIMEOUT / HZ;
> > +module_param_named(timeout_sec, sd_timeout_sec, int, 0644);
> > +
> > +/*
> > + * write_same_timeout_sec defines the default value of the WRITE SAME SCSI
> > + * command timeout in second.
> > + */
> > +static int sd_write_same_timeout_sec = SD_WRITE_SAME_TIMEOUT / HZ;
> > +module_param_named(write_same_timeout_sec, sd_write_same_timeout_sec, int, 0644);
> > +
> > +/* max_retries defines the default value of the max of SCSI command retries.*/
> > +static int sd_max_retries = SD_MAX_RETRIES;
> > +module_param_named(max_retries, sd_max_retries, int, 0644);
> 
> Shouldn't these parameters come from the SCSI host template rather than
> introducing new kernel module parameters? It is impossible to make a 
> good choice for these kernel module parameters if multiple types of SCSI
> devices are present (USB, HDD, ...).

Hmm, that does not help us from the hung task for lock waiter case.
I would like to tune the total timeout according to the hung task
timeout.

Or, as another idea, instead of tuning it from userspace, maybe
we can finish waiting earlier according to the deadline of the
hung task from when it acquires a mutex.

Thank you,

> 
> Bart.


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
