Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BA82E1F0E
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294729; cv=none; b=LKmU8bxYaVWB+05G4JDJoVqPQeGqNrCgSeNUe5EPwNbeSZBpTtzl1pt4Kg571hh7aJKCD7pUnCxR1EPIqFEdmgd0aFgeL4WW4OHDxI0gw89KCudAJQFuRdfYfG+Ypa6zqPNofUYUWb9kTagxuWjzp6gnahbLHJWJ7zvrAeDj3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294729; c=relaxed/simple;
	bh=WeP9iDTBzN98gI4RL7kSAp8BHIHaGPZWSFm/y/rJ+NE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=daRdSfHt7V18OCbhm+lNIqGJy2KYgiYpmHClWqFGCtZE17bdagPUwChDs77v7R3wlPkvd6N4uW0U1WVgu8IfOETKCDdir/zxX+Yg7pBAKthd0JCKOLq4lqML6iRoo7pxE2sTVbgUSQ7nUQ9wC7Ty2g2LrI4+J/SfD/lvCbhMjpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVJ2ufW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVJ2ufW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913971F000E9;
	Fri, 21 Aug 2026 06:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787294727;
	bh=fggDGh601E1ae9cMv46rEQFxpKVhJ+fsQoPbMn9a3Z8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MVJ2ufW3EvD7JsUxoP4ll/yVflgXvkPCy3vAa19qHjkCzHUiysqs2jmE02xiIRlcC
	 wzTi31sXBF63eUk+Zoc3Sjopu62XeUnLmEneZEbyu5OK2qUxVJfobtfspAn1NTVbJC
	 hQbTAVHAuKilUTwwyPFOvKVBNfdZpf3MJh+BATebndjvdRjEiDm23W8PCxG2TrAqAM
	 dqRVMx6eFM8eo+sLEEcIe0x67gs7tKEvnUSzZE+xozpTDyNUjEOqam3i0u/DQZTeV+
	 dyKR8zr8FMLjNBWr3gQSMRQU8KjkIwpaQnABgY4hgoRpok5zMC7z1C8Yr4F1RgRPIL
	 ct/K4Yavp3/kw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pmcraid: shut down command timers before reuse
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821062351.72658-1-runyu.xiao@seu.edu.cn>
References: <20260821062351.72658-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 06:45:27 +0000
Message-Id: <20260821064527.913971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Massive performance regression for all SCSI I/O due to uncondition=
al workqueue deferral.
- [High] Adapter reset state machine corruption causes premature failure vi=
a double-increment of retry counter.
- [High] Calling `timer_shutdown()` asynchronously stalls the adapter reset=
 sequence permanently.

Pre-existing issues:
- [Critical] List corruption and kernel panic due to a double `list_del()` =
race between tasklet and timeout handlers.
- [Critical] Lockless TOCTOU race on `pinstance->reset_cmd` causes Use-Afte=
r-Free and memory corruption.
- [High] Freeing command blocks during teardown without synchronizing timer=
s causes Use-After-Free.
--

--- Patch [1]: [PATCH] scsi: pmcraid: shut down command timers before reuse=
 ---
commit 1fe43c3a7e2ec130d4b5a6182060aafaaff8b4a8
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: pmcraid: shut down command timers before reuse

pmcraid removes a command from the pending pool and then either
completes it or reuses it for reset. timer_delete() only removes a
pending timer; it does not wait for a callback already running and does
not prevent the callback from rearming the timer. A timeout callback can
therefore access a command block after it has been returned or
reinitialized.

The response paths run in hardirq or softirq context, so they cannot
wait synchronously for a normal timer callback. Shut down the timer there
and defer completion to a work item. The worker uses
timer_shutdown_sync() before calling the original completion function.
The reset cleanup path also defers the reset command when it is still
pending so the reset engine cannot reinitialize it before its timer
callback has finished.

Flush command work before releasing command and control buffers.

Fixes: 89a3681041507773 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to supp=
ort 6Gb/s SAS RAID controller")

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 942a993932049..ed2ebe68c816b 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c

[ ... ]

> @@ -55,6 +55,43 @@ static unsigned int pmcraid_enable_msix;

[ ... ]

> +static void pmcraid_schedule_cmd_work(struct pmcraid_cmd *cmd,
> +				      void (*work_fn)(struct pmcraid_cmd *))
> +{
> +	/* The command block stays unavailable until the worker completes. */
> +	timer_shutdown(&cmd->timer);
> +	cmd->work_fn =3D work_fn;
> +	schedule_work(&cmd->timer_work);
> +}

[Severity: High]
Does calling timer_shutdown() permanently break the reset engine?

timer_shutdown() permanently disables the timer. If a command times out,
pmcraid_timeout_handler() starts the reset sequence by re-using the timed-o=
ut
cmd block and calling add_timer() to rearm it.

Concurrently, if the tasklet processes a late response for this command, it
calls pmcraid_schedule_cmd_work(), which executes timer_shutdown().

This makes the reset engine's add_timer() a silent no-op.

Will the reset sequence hang forever waiting for this cancelled timer?

> @@ -483,8 +521,6 @@ static void pmcraid_clr_trans_op(
>  	struct pmcraid_instance *pinstance
>  )
>  {

[ ... ]

>  	if (pinstance->reset_cmd !=3D NULL) {
> -		timer_delete(&pinstance->reset_cmd->timer);
> -		spin_lock_irqsave(
> -			pinstance->host->host_lock, lock_flags);
> -		pinstance->reset_cmd->cmd_done(pinstance->reset_cmd);
> -		spin_unlock_irqrestore(
> -			pinstance->host->host_lock, lock_flags);
> +		pmcraid_schedule_cmd_work(pinstance->reset_cmd,
> +					  pmcraid_complete_reset_cmd);
>  	}
>  }

[Severity: Critical]
This is a pre-existing issue, but does accessing pinstance->reset_cmd outsi=
de
the host_lock introduce a use-after-free?

In pmcraid_clr_trans_op(), pinstance->reset_cmd is evaluated and dereferenc=
ed
without holding pinstance->host->host_lock.

Concurrently, pmcraid_ioa_reset() (which holds the lock) can complete the
reset, set pinstance->reset_cmd =3D NULL, and return the command to the free
pool.

If a transition-to-operational interrupt races with reset completion, could
pmcraid_schedule_cmd_work() be called on a stale pointer, corrupting
cmd->work_fn of a freed command?

> @@ -1998,42 +2057,28 @@ static void pmcraid_fail_outstanding_cmds(struct =
pmcraid_instance *pinstance)

[ ... ]

>  		atomic_dec(&pinstance->outstanding_cmds);
> +		if (cmd =3D=3D pinstance->reset_cmd &&
> +		    cmd->cmd_done =3D=3D pmcraid_ioa_reset) {
> +			/* The reset engine owns this command and must resume only
> +			 * after its timer callback has finished.
> +			 */
> +			pmcraid_schedule_cmd_work(cmd, pmcraid_complete_reset_cmd);
> +			reset_deferred =3D true;

[Severity: High]
Will this cause the retry counter to be double-incremented for a single res=
et
attempt?

During IOA_STATE_IN_HARD_RESET, pmcraid_ioa_reset() increments
pinstance->ioa_reset_attempts.

If the reset command is pending, pmcraid_fail_outstanding_cmds() defers its
completion and returns true, causing pmcraid_ioa_reset() to break out of the
switch and return early.

When the worker later runs pmcraid_complete_reset_cmd(), it calls cmd_done()
(which is pmcraid_ioa_reset()) again. Since the state is still
IOA_STATE_IN_HARD_RESET, ioa_reset_attempts will be incremented a second ti=
me
for the exact same physical reset attempt.

Could this mark the adapter as dead prematurely?

> @@ -3982,17 +4029,15 @@ static void pmcraid_tasklet_function(unsigned lon=
g instance)

[ ... ]

>  		spin_lock_irqsave(&pinstance->pending_pool_lock,
>  				   pending_lock_flags);
>  		list_del(&cmd->free_list);
>  		spin_unlock_irqrestore(&pinstance->pending_pool_lock,
>  					pending_lock_flags);

[Severity: Critical]
This is a pre-existing issue, but is it possible to corrupt the list here?

If a command times out, pmcraid_timeout_handler() starts a reset and
pmcraid_fail_outstanding_cmds() iteratively unlinks all commands from
pending_cmd_pool using list_del() under pending_pool_lock.

Concurrently, if the response was already placed in the HRRQ by the adapter,
pmcraid_tasklet_function() processes it, acquires pending_pool_lock, and
blindly calls list_del().

If the command was already removed by the reset path, wouldn't this second
list_del() corrupt the list?

> -		timer_delete(&cmd->timer);
>  		atomic_dec(&pinstance->outstanding_cmds);
> =20
>  		if (cmd->cmd_done =3D=3D pmcraid_ioa_reset) {
> -			spin_lock_irqsave(pinstance->host->host_lock,
> -					  host_lock_flags);
> -			cmd->cmd_done(cmd);
> -			spin_unlock_irqrestore(pinstance->host->host_lock,
> -					       host_lock_flags);
> +			pmcraid_schedule_cmd_work(cmd, pmcraid_complete_reset_cmd);
>  		} else if (cmd->cmd_done !=3D NULL) {
> -			cmd->cmd_done(cmd);
> +			pmcraid_schedule_cmd_work(cmd,
> +						  pmcraid_complete_response_cmd);

[Severity: High]
Does this code defer every normal SCSI completion to a workqueue?

In pmcraid_tasklet_function(), normal SCSI I/O operations have cmd->cmd_done
set to pmcraid_io_done.

By routing every response with cmd->cmd_done !=3D NULL to
pmcraid_schedule_cmd_work(), does every single SCSI read and write incur a
context switch to system_percpu_wq?

Will this cause a severe latency and CPU overhead regression for all block
I/O?

> @@ -4097,7 +4142,10 @@ pmcraid_release_cmd_blocks(struct pmcraid_instance=
 *pinstance, int max_index)
>  {
>  	int i;
>  	for (i =3D 0; i < max_index; i++) {
> -		kmem_cache_free(pinstance->cmd_cachep, pinstance->cmd_list[i]);
> +		struct pmcraid_cmd *cmd =3D pinstance->cmd_list[i];
> +
> +		flush_work(&cmd->timer_work);
> +		kmem_cache_free(pinstance->cmd_cachep, cmd);
>  		pinstance->cmd_list[i] =3D NULL;
>  	}
>  	kmem_cache_destroy(pinstance->cmd_cachep);

[Severity: High]
This is a pre-existing issue, but does this function free command blocks
without shutting down their timers?

During adapter teardown or module unload, pmcraid_release_cmd_blocks()
iterates over the command blocks and frees them via kmem_cache_free().

It flushes the async workqueue but does not call timer_shutdown_sync().

If any command timer is still pending or executing, will the timer subsystem
access the freed command block and cause a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821062351.7265=
8-1-runyu.xiao@seu.edu.cn?part=3D1
