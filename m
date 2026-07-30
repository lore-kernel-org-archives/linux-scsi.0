Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF03D75CF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454059; cv=none; b=J+5aU0k5GcpUEP2GtDcO/iXGKWuR7qTvotxAsbbYmnvvlgyoya/gheQYusaiE3LF10xI/HNYp4SRZT5gNXrVVgEQjHNLQT/kisZGCkNeo2HQmZSykwCZuhN7swp46/s/LFFKf91/HknugR5m7rurIXeVKeXuSRMSEgXzKhvzEHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454059; c=relaxed/simple;
	bh=Yay2Fsxms7+DpCG5YoYSZIKDEnbpfx0lFCT/tLLe+UI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Hckl23ZcAAuh6bcl9c/6jdbmFkFzT/UeCICubhguRDOexMBcpkeISTh7B3rIz2cjoILP/UZFZo3zC9Hxkyx2GtkLPZSzQqYCOZhAkqd9r8B7zJtPkHNyFOyK349TvOjIRKrQao5eGXWf5VZgQZE3FIEASWW5EakHl6IeCgkoZ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CH/HP1Zb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CH/HP1Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151C31F000E9;
	Thu, 30 Jul 2026 23:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454055;
	bh=/sHPWHpkN7+j4v0WXjXSc2qJ2vnyhkK1BAouUGsVUfE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CH/HP1ZbmVK3pnCDt/N71G0ueCr9JTnzuILZxA7JwUCvJyZXTAFglav0xhL/e4kjC
	 i8hJZEiRtYcA2zWwPz/BuXyZ663ARaVAqxUKf24HIp6EehCcsueUzH45ms46mdIyes
	 rQ9HUepyoDDkENhkVDHbGtdV0D23I305rIAdoveLs5HG6ym4H//yXA9zt4M9mHRQJz
	 BIbubyIuVXrc4UiJSDd0qWi1LLQZtcK05yG0msnK08EFQSY0aYjP+2wXzzzbnXeV1V
	 6CXPmf3lj80sq1ablRBYRlJdm+bkAomUummfVtTwe/1Bprag8bkCvMZFhA/Nm/y4aq
	 urW1y+VsrKnNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/57] scsi: hpsa: Prepare for enabling lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <e26d3c5bd77310a14adb0d72e9f1b5f760a4a4a4.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <e26d3c5bd77310a14adb0d72e9f1b5f760a4a4a4.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:27:34 +0000
Message-Id: <20260730232735.151C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If `hpsa_send_reset` fails with a SCSI error after being submitted=
 to the hardware, `dev->commands_outstanding` is leaked.
- [High] Concurrent device reset requests cause premature clearing of mutua=
l exclusion flags (`reset_in_progress` and `in_reset`), leaving the control=
ler vulnerable to rescans and new OS commands while a reset is actively in =
progress.
--

--- Patch [28]: [PATCH v3 28/57] scsi: hpsa: Prepare for enabling lock cont=
ext analysis ---
commit 9b4522a3e2cfce6e65e269b286bd08359ef94086
Author: Bart Van Assche <bvanassche@acm.org>

scsi: hpsa: Prepare for enabling lock context analysis

mutex_lock_interruptible() returns a negative value upon failure or zero
upon success. Since the Clang thread-safety analyzer only supports =3D=3D 0
and !=3D 0 tests for functions that perform conditional locking, change
the =3D=3D -EINTR test into !=3D 0. This change does not modify the behavior
of hpsa_do_reset().

> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8edad1830abe4..3f38030d6a8d1 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3163,7 +3163,7 @@ static int hpsa_do_reset(struct ctlr_info *h, struc=
t hpsa_scsi_dev_t *dev,
>  	int rc =3D 0;
> =20
>  	/* We can really only handle one reset at a time */
> -	if (mutex_lock_interruptible(&h->reset_mutex) =3D=3D -EINTR) {
> +	if (mutex_lock_interruptible(&h->reset_mutex)) {

[Severity: High]
This is a pre-existing issue, but concurrent device reset requests cause
premature clearing of mutual exclusion flags (reset_in_progress and in_rese=
t),
leaving the controller vulnerable to rescans and new OS commands while a re=
set
is actively in progress.

If Thread 1 is performing a reset and Thread 2 is blocked on
mutex_lock_interruptible(&h->reset_mutex), interrupting Thread 2 (e.g., via
Ctrl-C) causes it to exit hpsa_do_reset() and unconditionally clear
h->reset_in_progress and dev->in_reset in hpsa_eh_device_reset_handler():

drivers/scsi/hpsa.c:hpsa_eh_device_reset_handler() {
    ...
return_reset_status:
	spin_lock_irqsave(&h->reset_lock, flags);
	h->reset_in_progress =3D 0;
	if (dev)
		dev->in_reset =3D false;
	spin_unlock_irqrestore(&h->reset_lock, flags);
}

Does this strip the mutual exclusion protection from Thread 1, exposing the
hardware to concurrent commands?

[Severity: High]
This isn't a bug introduced by this patch, but if hpsa_send_reset() fails w=
ith
a SCSI error after being submitted to the hardware, does it leak
dev->commands_outstanding?

If hpsa_send_reset() successfully enqueues the command (incrementing the
counter) but the hardware later fails the command (e.g., CMD_TARGET_STATUS),
hpsa_send_reset() returns a non-zero error code.=20

hpsa_do_reset() sees this non-zero rc and skips
atomic_dec(&dev->commands_outstanding):

drivers/scsi/hpsa.c:hpsa_do_reset() {
    ...
	rc =3D hpsa_send_reset(h, dev, reset_type, reply_queue);
	if (!rc) {
		/* incremented by sending the reset request */
		atomic_dec(&dev->commands_outstanding);
    ...
}

Because CMD_IOCTL_PEND commands do not decrement this counter in their
interrupt completion handler, finish_cmd():

drivers/scsi/hpsa.c:finish_cmd() {
    ...
	else if (c->cmd_type =3D=3D CMD_IOCTL_PEND || c->cmd_type =3D=3D IOACCEL2_=
TMF)
		complete(c->waiting);
    ...
}

Is the count permanently leaked, causing an infinite hang on the next reset
attempt for the device because wait_event() will block forever?

>  		dev_warn(&h->pdev->dev, "concurrent reset wait interrupted.\n");
>  		return -EINTR;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D28
