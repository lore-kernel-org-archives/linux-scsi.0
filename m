Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7EC3D955E
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 06:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785997212; cv=none; b=aJu2j0qw2lTubxi1tNP3fJCX9X7GG8yRhYKgKwI+Do8dLrsNihhy46bVduxwCGPvfp+JFg9Caf0g0rTaJeJiKYnE0LsOERkEkOxYT9CtmUfVDI+sBC299mm8E0N71y4fD44/knhfILtpX737NNi80s5yb4AI6jjEnJeYZe5Db34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785997212; c=relaxed/simple;
	bh=aAI7UoOdnPnFdHY/doCh0Xaefa4Q6Q3I+AYoS3rW+C4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c2kfaHmwi9ZxaV3hCIcgWDcLSvwDIaftNqw0h6t/T/JNMX/CC1emrWlZbb2rq/Py2FtpFkrZ5vh4vu3/sNwwnag+hJvAHZVXFm0iZk1lMEwKGtnTJyAjsLzC/CoQaPrhG7zn8n1qu/CJXHllbLDFJdtUD7v3tMYcFFSGyBfOOuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4xs8AHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4xs8AHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5E41F000E9;
	Thu,  6 Aug 2026 06:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785997210;
	bh=SZhNa+jMLG25kNgNOklgei68uteiTnFExS1U6/zQL9s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4xs8AHp9KOmkhus0gx9TlfElA93IfixzLoFBAKHJJbdWmL7rbr6w3cKVpoeCeGtv
	 5397XCs358xJZ8XqnhQNIozx0wsLSjN+atLeDlSQ4ASLhdbxgeQm2t/45cgdQyShQ3
	 DEEaj+pLXz2J9zzKZseDGflSoQp+k1rlUSgjXBFaM9RjNMND6wKlYc3PVroth3zLaz
	 UKvZppCoTToOi8hs8n26utqEuAFFh7NH9VPk7hGNKLtt4i1Gpu8JqIZ4fxYym88Rrf
	 XfPTd2+uVit5PfVpZytYPUVYfdzTSI8o/HUQa3isYm8hixSoSTuZSoWbyN51WJpssG
	 Cg4qQDY8WMVLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: myrb: quiesce the SCSI host before controller
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongyan Xu" <getshell@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806060659.1852-1-getshell@seu.edu.cn>
References: <20260806060659.1852-1-getshell@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 06:20:09 +0000
Message-Id: <20260806062010.4C5E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect teardown sequence in `myrb_cleanup()` causes use-after-f=
ree and page fault panics.
- [High] Data race and waitqueue corruption due to concurrent accesses to `=
cb->mcmd_blk` without locking.
- [High] Hardware command execution uses an unbounded `wait_for_completion(=
)`, allowing unprivileged denial of service on hardware failure.
--

--- Patch [1]: [PATCH] scsi: myrb: quiesce the SCSI host before controller =
teardown ---
commit f8a31e3f5c2db4d7eb1518b32495ee728296ad52
Author: Hongyan Xu <getshell@seu.edu.cn>

scsi: myrb: quiesce the SCSI host before controller teardown

This commit addresses teardown issues in the myrb driver by removing the
SCSI host before releasing controller resources. It stops the monitor and
destroys pools before unmapping hardware and dropping the host reference
to ensure callbacks do not run after teardown.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..adb2fadf9146e 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -3496,9 +3496,10 @@ static void myrb_remove(struct pci_dev *pdev)
>  	struct myrb_hba *cb =3D pci_get_drvdata(pdev);
> =20
>  	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
> +	scsi_remove_host(cb->host);
>  	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);

[Severity: High]
This isn't a bug introduced by this patch, but does hardware command execut=
ion
use an unbounded wait_for_completion()?

In drivers/scsi/myrb.c:myrb_exec_cmd() (called by myrb_exec_type3()):

	spin_lock_irqsave(&cb->queue_lock, flags);
	cb->qcmd(cb, cmd_blk);
	spin_unlock_irqrestore(&cb->queue_lock, flags);

	wait_for_completion(&cmpl);
	return cmd_blk->status;

myrb_exec_cmd() submits a command to the controller and blocks indefinitely
waiting for a hardware interrupt. There is no timeout or fallback wake
condition.

If the controller firmware crashes, drops an interrupt, or the device is
abruptly removed, the completion is never signaled. Since unprivileged local
users can trigger hardware commands through world-readable sysfs attributes
(like reading rebuild), could this allow them to intentionally hang a
kernel task if they can induce or encounter a hardware error state?

> -	myrb_cleanup(cb);
>  	myrb_destroy_mempools(cb);

[Severity: High]
This is a pre-existing issue, but does myrb_get_rbld_progress() have a data
race on cb->mcmd_blk?

In drivers/scsi/myrb.c:myrb_get_rbld_progress():

	struct myrb_cmdblk *cmd_blk =3D &cb->mcmd_blk;
	union myrb_cmd_mbox *mbox =3D &cmd_blk->mbox;
...
	myrb_reset_cmd(cmd_blk);
	mbox->type3.id =3D MYRB_MCMD_TAG;
	mbox->type3.opcode =3D MYRB_CMD_GET_REBUILD_PROGRESS;
	mbox->type3.addr =3D rbld_addr;
	status =3D myrb_exec_cmd(cb, cmd_blk);

myrb_get_rbld_progress() accesses and resets the shared cb->mcmd_blk and its
waitqueue completion without any serialization.

myrb_reset_cmd(cmd_blk) re-initializes cmd_blk->completion. If an
unprivileged user concurrently reads the rebuild sysfs attribute while the
background monitor work myrb_update_rbld_progress() is running, both will
modify cb->mcmd_blk at the same time.

One thread could re-initialize the completion while the other is blocked in
wait_for_completion(), corrupting the waitqueue list.

Could this corrupt the waitqueue list and lead to deadlocks or kernel crash=
es?

> +	myrb_cleanup(cb);
>  }

[Severity: High]
This is a pre-existing issue, but I noticed an incorrect teardown sequence =
in
myrb_cleanup() that could lead to a use-after-free and page fault panics.

In drivers/scsi/myrb.c:myrb_cleanup():

	/* Free the memory mailbox, status, and related structures */
	myrb_unmap(cb);

	if (cb->mmio_base) {
		if (cb->disable_intr)
			cb->disable_intr(cb->io_base);
		iounmap(cb->mmio_base);
	}
	if (cb->irq)
		free_irq(cb->irq, cb);

The teardown logic frees DMA memory (cb->first_stat_mbox and
cb->first_cmd_mbox via myrb_unmap) and unmaps the MMIO base before freeing
the shared IRQ line.

If an interrupt fires on the shared IRQ line during this window, the
interrupt handler (e.g., DAC960_LA_intr_handler) accesses the freed DMA
memory and the unmapped MMIO base without knowing they have been released:

drivers/scsi/myrb.c:DAC960_LA_intr_handler():

	DAC960_LA_ack_intr(base);
	next_stat_mbox =3D cb->next_stat_mbox;
	while (next_stat_mbox->valid) {

Could this cause a kernel panic if the shared IRQ fires before free_irq() is
called?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806060659.1852=
-1-getshell@seu.edu.cn?part=3D1
