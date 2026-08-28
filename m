Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A025432D0E3
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787942130; cv=none; b=GaDdWF6zpPpHuSyBmE1bXSnlhlUpdlkq3x9mEasvTvlFOrzEkPB4mCRN1L4g3ytA3/z9098qmm9R9WXn0Z3AP75FP5ErZHTZitV+c0uzgWBobll4EDpijuz8O3Kh6lujtsYiiioiJVBWEOVfVAW84AuLPqwlJhf6jtxgZhPa9U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787942130; c=relaxed/simple;
	bh=9S535EXM1hEXE0pbPeRPW14f8lEFibjZYo5OwSMmMkg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mkrdDrDmFbWlzIfNWLtZgaUXusNBQ/o0kk+JJXMptxBIuZWgTTLPZrq/AV8gXLcR5h5798J05gyX6Z5EaE3P4pBhxIDb/R29qjeRxS79R4AiOwylJtoBBhzKGmM1XddHXnm4b4IedF5oRcwgaOEd4LNIFfm8GpHQOiSqHhoZfRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b80/+voR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b80/+voR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9331F000E9;
	Fri, 28 Aug 2026 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942129;
	bh=/MHEb2TvGrZNuJuWWYE77hQUhl/RftDFu3E7270kN60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b80/+voRJKPl/Kjutx1XbCt/PYDC52jlPNjrkHh29WpDdB0lVt4LKvrRxFeZOq5NT
	 WR+Jnchb/YX0e1dENFhZUTCYCu9ayCVO4nZubsqPe5qAgUCoU7tgv+KgTz3Pi+sVhv
	 7EBkgJ3FU5NeS8BKPktI0FqZgM7qu8zoTfsDBq2r2mt4BPArgZmhWaUL9BashFJcqr
	 IekUoOQUADVaahvDDvagjUUS7D5wF2wiQcBX5mOKS3d+TPjKZgUbtFfXQFfYJwUyRe
	 9F5LY+pQsNXH+909VDiihbOQ62wICDIzKQmPtOtAbpzAzMbeYv9eH0DkVrsRZ8rH7l
	 BDjVIC7Z43xVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in
 megasas_resume()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <6e802da5e402b1d304ab753da77d27f118d0f61b.1787941140.git.bvanassche@acm.org>
References: <6e802da5e402b1d304ab753da77d27f118d0f61b.1787941140.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 28 Aug 2026 18:35:28 +0000
Message-Id: <20260828183529.1D9331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Mixing goto-based error handling and scoped_guard in the same fu=
nction violates the kernel cleanup guidelines.

Pre-existing issues:
- [High] The error path in `megasas_resume` fails to deregister IRQs while =
freeing critical control structures, leading to a Use-After-Free.
--

commit 29ed10a7540b21ede13952240b8d781f1bdf89ab
Author: Bart Van Assche <bvanassche@acm.org>

scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()

Protect the megasas_get_ctrl_info() call in megasas_resume() with
instance->reset_mutex using scoped_guard().

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index f0152b043e18c..f345fb266db05 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7875,8 +7875,9 @@ megasas_resume(struct device *dev)
>  			goto fail_init_mfi;
>  	}
> =20
> -	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
> -		goto fail_init_mfi;
> +	scoped_guard(mutex, &instance->reset_mutex)
> +		if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)

[Severity: Medium]
Does this mix goto-based error handling and scoped_guard() in the same
function?

The cleanup guidelines explicitly state that goto and cleanup helpers should
never be mixed in the same function to avoid confusing ownership semantics.
Should the other resources in megasas_resume() using goto cleanup be
converted to scope-based cleanup, or should this scoped_guard() be changed
to standard mutex_lock() and mutex_unlock()?

> +			goto fail_init_mfi;

[Severity: High]
This isn't a bug introduced by this patch, but could this error path lead
to a use-after-free?

If megasas_resume() fails here, it jumps to the fail_init_mfi label:

fail_init_mfi:
	megasas_free_ctrl_dma_buffers(instance);
	megasas_free_ctrl_mem(instance);
	scsi_host_put(host);

Since IRQs are requested earlier in the function but megasas_destroy_irqs()
is not called in this error path, could an interrupt fire and execute the
handler while structures like instance->reply_queue (freed in
megasas_free_ctrl_mem()) are accessed?

> =20
>  	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
>  		     (unsigned long)instance);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/6e802da5e402b1d304a=
b753da77d27f118d0f61b.1787941140.git.bvanassche@acm.org?part=3D1
