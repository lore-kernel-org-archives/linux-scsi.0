Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DE6404BD5
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452805; cv=none; b=rNLTshR6PJGdpizx9x/xzl9ufBchcLgpbEhIjGEvEmpzDdUnmi7i1XxoZRf1+6aA1UJ8Lyu114zO9DUWHibTJpnpox1ZiG1wkt3Ftdi8z/RrFtCZO46xdPxCeu33qF6cELSolgq+dTM4mOU5St2GDo8ZVI6YQOH0Ew8gUMJsDOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452805; c=relaxed/simple;
	bh=87M0I1GhZNbLdCNvxfW2V7wcyiSQrwE5yS1Z72u2b04=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PAYnhbvyT3Er4N66SW2SB7eLBF8uhxUpK9WV79zSHJVIMl0oP5nqMVBaIRJsJw6GI//LBEMZqvQZW2DXUAULUI+kHxAWHk0HG8eS/0wPhJOdCyseYo0fc28aH62tJFAr3MII53WiiBu494shAQdzPHBOtTfCtPop7k3rWljL5fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBNcddU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBNcddU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC131F000E9;
	Thu, 30 Jul 2026 23:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452803;
	bh=iFeD0shR4xRXY3P5OXmgEi1HhDvTbU7HvFd9saQ0pws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VBNcddU9IEjT7vFQa7zGrxhKbSo4Y5ooiwNd67/tHEqSgIXB2kmuebgWtyJigUazR
	 GELVLJ4wFpuPdizHnlqoK3IpgztCmXECEygEUhIYgIe1J5FIR6PrTnhrPsG5a7nuKo
	 9QshYcWTjrF2FybZHAw5ClS/6GbBYHwxbI3U2uaa5Tec+5OeTM04wyW1OqhBtRLB4F
	 kcZU21OhgeizdnSTv7ss7VXeC8iICFPWEMHJVzt3dq6HW+H9WIEddU6ZUHmMv+mNtX
	 6qMX+thn/2+AIs/pJYKiCrJ2VHKIGOWaMmLzwZDey8TvEJGbmIDfhgHTCpa7QsShtO
	 SgpGUGDEr+3ZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/57] scsi: BusLogic: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <045a86725b6f568d4f070c036d40d0352d25424a.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <045a86725b6f568d4f070c036d40d0352d25424a.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:06:42 +0000
Message-Id: <20260730230643.2DC131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Medium] The lock expressions used in the new `__must_hold` annotations d=
o not syntactically match the lock variables used inside the functions and =
their callers, causing false positive context imbalance warnings in static =
analyzers.
- [Low] The patch misses several other functions in the driver that explici=
tly require the host lock, leaving the lock context annotations incomplete.

Pre-existing issues:
- [High] `spin_unlock_irq()` unconditionally enables interrupts in contexts=
 where they must be preserved (e.g., inside `spin_lock_irqsave()` regions a=
nd hard IRQ handlers).
- [High] A failure in DMA mapping triggers a kernel panic via `BUG_ON()` ra=
ther than gracefully failing the command.
- [High] Missing memory barrier (`wmb()`) between CCB and Action Code write=
s in `blogic_write_outbox`.
--

--- Patch [6]: [PATCH v3 06/57] scsi: BusLogic: Prepare for enabling lock c=
ontext analysis ---
commit 927e16987713b901aca16b28f9b8a4d54db270de
Author: Bart Van Assche <bvanassche@acm.org>

scsi: BusLogic: Prepare for enabling lock context analysis

This commit prepares the BusLogic SCSI driver for lock context analysis.
It adds the __must_hold() macro to document locking requirements for
blogic_qcmd_lck() and blogic_resetadapter().

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index f2a6ed710c770..dafec8b24e586 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2878,6 +2878,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>  */
> =20
>  static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
> +	__must_hold(command->device->host->host_lock)
>  {

[Severity: Medium]
Will this annotation cause false positive context imbalance warnings in sta=
tic
analyzers like Sparse?

The annotation requires command->device->host->host_lock, but the function
body internally unlocks and locks shost->host_lock:

	spin_unlock_irq(shost->host_lock);
	blogic_delay(1);
	spin_lock_irq(shost->host_lock);

Since Sparse evaluates lock context expressions syntactically, will this
structural mismatch trigger the exact warnings this patch intends to preven=
t?

[Severity: High]
This isn't a bug introduced by this patch, but doesn't spin_unlock_irq()
unconditionally enable interrupts in contexts where they must be preserved?

Looking at blogic_qcmd_lck() in drivers/scsi/BusLogic.c:

	spin_unlock_irq(shost->host_lock);
	blogic_delay(1);
	spin_lock_irq(shost->host_lock);

Since blogic_qcmd_lck() is called from inside a region protected by
spin_lock_irqsave() via DEF_SCSI_QCMD, does this break the caller's IRQ sta=
te
by forcefully enabling interrupts?

[Severity: High]
This is a pre-existing issue, but does a DMA mapping failure here trigger a
kernel panic instead of gracefully failing the command?

drivers/scsi/BusLogic.c:blogic_qcmd_lck() {
    ...
	count =3D scsi_dma_map(command);
	BUG_ON(count < 0);
    ...
}

Under high memory pressure or extreme fragmentation, could scsi_dma_map()
return a negative error code and cause a Denial of Service?

>  	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
>  	struct blogic_adapter *adapter =3D

[ ... ]

> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 24697a5bedc8b..c152b93fb6ddb 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1279,7 +1279,8 @@ static int blogic_sdev_configure(struct scsi_device=
 *,
>  				 struct queue_limits *lim);
>  static void blogic_qcompleted_ccb(struct blogic_ccb *);
>  static irqreturn_t blogic_inthandler(int, void *);
> -static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
> +static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard=
_reset)
> +	__must_hold(adapter->scsi_host->host_lock);

[Severity: Medium]
Will this syntactic mismatch also cause warnings with static analyzers?

The caller blogic_hostreset() acquires shost->host_lock:

	spin_lock_irq(shost->host_lock);
	blogic_inc_count(&stats->adapter_reset_req);
	rc =3D blogic_resetadapter(adapter, false);
	spin_unlock_irq(shost->host_lock);

But the annotation requires adapter->scsi_host->host_lock.  Could this
mismatch lead to analysis noise?

[Severity: Low]
Are there other functions in this driver that explicitly require the host
lock but missed this annotation?

Functions like blogic_alloc_ccb() and blogic_write_outbox() have header
comments explicitly stating "The Host Adapter's Lock should already have be=
en
acquired by the caller":

static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)

static bool blogic_write_outbox(struct blogic_adapter *adapter,
		enum blogic_action action, struct blogic_ccb *ccb)

Would adding __must_hold() to these functions complete the static analysis
coverage?

[Severity: High]
This isn't a bug introduced by this patch, but does blogic_resetadapter()
forcefully enable hardware interrupts inside a hardirq context?

The interrupt handler blogic_inthandler() calls blogic_resetadapter() on
errors. Inside blogic_resetadapter():

	spin_unlock_irq(adapter->scsi_host->host_lock);
	blogic_delay(2);
	spin_lock_irq(adapter->scsi_host->host_lock);

Since this drops the lock using spin_unlock_irq() and busy-waits for 2
seconds, can this lead to hard IRQ re-entrancy, stack overflows, or potenti=
al
deadlocks?

[Severity: High]
This is a pre-existing issue, but is there a missing memory barrier in
blogic_write_outbox()?

drivers/scsi/BusLogic.c:blogic_write_outbox() {
    ...
		next_outbox->ccb =3D ccb->dma_handle;
		next_outbox->action =3D action;
		blogic_execmbox(adapter);
    ...
}

Because these assignments to memory polled by DMA are not protected by a
compiler or memory barrier, can a weakly-ordered CPU reorder the stores to
next_outbox->ccb and next_outbox->action?

If the Host Adapter asynchronously polls and observes the new action code
before the CCB address is fully committed to memory, could this cause the
hardware to execute invalid or stale CCB addresses?

>  static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapt=
er *, ...);
>  static int __init blogic_setup(char *);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D6
