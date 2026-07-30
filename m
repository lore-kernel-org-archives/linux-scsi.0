Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456C4749D8
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453540; cv=none; b=oocoPy6dLM7hLch+uK5O0F07C5Ie1wTBTTcC6weU+z5hyhWegO+VAF0dqcafaiyocB755qL0PJ9rYZN/UbE7OFkNKuuYS6pjydeBc0yLGoTaKAXUtUMTfRDUdLZLxG5hW/9FIDINXQJMFr9TkTJiwm4AMQGeqZNZ8i7csC/JfBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453540; c=relaxed/simple;
	bh=FHizFKt4OkBh8ThmgOovO9Z0EPk19cuhiaQX2vHyDWI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UHkVxgcAYkklNV6Ku1hGccPhr1TsD+RNs/DjT+7eQ5r5OR3mocrVlfT7DHzRjetJt59zHTKP62+7tGbOfE4zQTmlxxUehUPtZ9Bu+fK3XTiyVqlxH8xnNT8Nsw4wQFA6KqBuMBW03I7idR23yBxBcJwOfuwzePpwV27lQsEio7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKHJRZWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKHJRZWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD101F000E9;
	Thu, 30 Jul 2026 23:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453538;
	bh=52ppbHBp2WF2rGWobr9ymuWhfxQLDP/6uy/vT/mhWSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fKHJRZWciJaDsBztuplDYWXp1Tpicq0ebBCYtJU8MkhgFWwY3Y51Q1meaW6h8YdBg
	 SCaR2X12Bt5JS/rKOISm3Zjivyvbw9jaBbsFSnaTE9VMBedhRBTRkSuN1b1mneMI3C
	 EU7nDtz45iKHpp2AMVvExKBJ+z5j/IVYeJmGnjMbT6BEa+p58t5425mxSWNf6doTz8
	 sLhlal52Lsf+cA8uJ9ot+VsW74xTrANwbQirpEFaZvFmvz5oiYR+hGFPInjIpY7qmg
	 yR2MCjeSKzArd83O9fV5Mo08MwgKShwI34nvvTkFCRIyUZwrw85Lp42odtCIkZOiIg
	 JFlbMWGhx8GsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/57] scsi: aha152x: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <f721bb8e817434bf1449bcdba0f305e3f69fd9d4.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <f721bb8e817434bf1449bcdba0f305e3f69fd9d4.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:18:58 +0000
Message-Id: <20260730231858.8DD101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting list corruption vulnerability due to unlocked accesses=
 to DISCONNECTED_SC.
- [High] Possible NULL pointer dereference in SCSI phase handlers if CURREN=
T_SC is NULL due to unexpected target behavior.
- [High] Calling INIT_WORK dynamically in an interrupt handler for a global=
 work_struct corrupts the workqueue.
- [High] The global `aha152x_host_list` is modified and traversed concurren=
tly without any locking.
- [High] The driver fails to cancel the global workqueue during device rele=
ase or module unload.
--

--- Patch [10]: [PATCH v3 10/57] scsi: aha152x: Prepare for enabling lock c=
ontext analysis ---
commit 4e1483c06dfed36c67b1da76d5119c68317479aa
Author: Bart Van Assche <bvanassche@acm.org>

scsi: aha152x: Prepare for enabling lock context analysis

Annotate is_complete() with __context_unsafe() because it performs
conditional locking.

> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index e3ccb6bb62c00..c16dcb9274eb8 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -2319,6 +2319,7 @@ static void rsti_run(struct Scsi_Host *shpnt)
>   *
>   */
>  static void is_complete(struct Scsi_Host *shpnt)
> +	__context_unsafe(conditional locking)
>  {
>  	int dataphase;
>  	unsigned long flags;

[Severity: High]
This is a pre-existing issue, but is there a risk of list corruption when
accessing DISCONNECTED_SC?

In is_complete(), the host lock is dropped before calling phase handlers
such as busfree_run():

	DO_UNLOCK(flags);
	...
	if(states[STATE].run)
		states[STATE].run(shpnt);

Then busfree_run() mutates the list without holding the QLOCK:

	append_SC(&DISCONNECTED_SC, CURRENT_SC);

Concurrently, SCSI error handler callbacks like aha152x_abort() modify the
exact same list while holding the lock:

	disconnected =3D issued && remove_SC(&DISCONNECTED_SC, SCpnt);

Can this concurrent modification lead to list corruption?

[Severity: High]
This is a pre-existing issue, but could there be a NULL pointer dereference
if a target behaves unexpectedly?

In is_complete(), the state machine transitions to phases like status or cmd
based on hardware bus signals via update_state():

	switch(GETPORT(SCSISIG) & P_MASK) {
	case P_MSGI:    STATE=3Dmsgi;    break;
	...

This occurs without verifying if a command is currently active. The state
handlers then unconditionally dereference CURRENT_SC:

status_run():
	aha152x_priv(CURRENT_SC)->status =3D GETPORT(SCSIDAT);

cmd_init():
	if (aha152x_priv(CURRENT_SC)->sent_command) {

If the hardware reports a phase while no command is active, would this crash
the kernel?

[Severity: High]
This is a pre-existing issue, but does dynamically initializing the global
work item in the interrupt handler corrupt the workqueue?

The interrupt handler intr() calls INIT_WORK() before schedule_work():

	INIT_WORK(&aha152x_tq, run);
	schedule_work(&aha152x_tq);

Since aha152x_tq is a global variable, if a second SCSI host adapter
triggers an interrupt while the work is already queued by the first adapter,
would INIT_WORK() overwrite the list pointers of the pending work?

[Severity: High]
This is a pre-existing issue, but is it safe to traverse and modify the
global aha152x_host_list locklessly?

Nodes are added and removed from the list locklessly:

aha152x_probe_one():
	list_add_tail(&HOSTDATA(shpnt)->host_list, &aha152x_host_list);

aha152x_release():
	list_del(&HOSTDATA(shpnt)->host_list);

Concurrently, the workqueue callback run() iterates over the list locklessl=
y:

	list_for_each_entry(hd, &aha152x_host_list, host_list) {

If aha152x_release() removes a host while the workqueue thread is traversing
the list, could this lead to following invalid pointers and a use-after-fre=
e?

[Severity: High]
This is a pre-existing issue, but could pending work items execute after
the module is unloaded or devices are freed?

Neither aha152x_release() nor aha152x_exit() appears to cancel the global
workqueue:

aha152x_release():
	void aha152x_release(struct Scsi_Host *shpnt)

aha152x_exit():
	static void __exit aha152x_exit(void)

If an interrupt schedules the work and the module is immediately unloaded,
will the kernel attempt to execute run() after the module's code segment
has been unmapped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D10
