Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79334345EA2
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788212762; cv=none; b=leGpvI+sB8UM3Zn8rS7Td4uJn5IHshYl+4lhQbPb6bV/WuftHAIiirUfzrpfYY0360LRbwxxT57yHjyHjz35P8Pn7YIcvRZjsjaZLRK0Q7TqGs09bGQTJV+w5MjvZdlQeBhmAxs2yg6NOD/vlWYWZF301dYQEFehQfkeaeJAEZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788212762; c=relaxed/simple;
	bh=uR3opM16B1jyRoQQIQLEc3msjEnv5G+8+gKOaLXClHw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FNks+iOaH7mC5uNNwrpfaJYwUBIBH37RGFDfhLxH3uXnWsrgAcCigtmivqsvIS2CGnEwUJbwRicYv51qtwlMYp8fWAze1ju3d114isEs/B0SCX62oID/CvYF4Ywv85j1OMXHKH/SoUoawXRTPWDkN7/zGJjlfttYi2L3dZ/4OnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krhfOvbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krhfOvbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DCA1F000E9;
	Mon, 31 Aug 2026 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788212761;
	bh=wNTx6xCIF0Ny4KpPlgYSU+fmvH/VYXDP1JCUy6jd3gM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=krhfOvbxeUHNWBLjsQDt16kxFs+LJCRKAySsAz3mvFyMzf+cSfUqkesDpvk9x9gRt
	 zyVhFOteb289qVvQQlb2qS+AQiZWAASC52yC4KFi0cn1qlibOPHCLAxMAYhMrJEsSS
	 UO6BwkQNFEFNtgQm+7OGSfDwTW9nHiWjg1KuJ6w7WrNes0IWWTOah87a+P/gYPEA6w
	 z7SDgILfjbk5f4JPb6jN5gAhjg+UU156Q5PW+1GQj+4oR6QdLJjnEqHT4uCZYeA9gR
	 zM+DYs3HJcrpNydV6Ay4I72VkjPkGqTjs60Onajx4mFJ1DHVv4WIK1U/TBkVLushAr
	 I6FtoI9L5xfOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: megaraid_sas: Protect megasas_get_ctrl_info()
 in megasas_resume()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org>
References: <f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:46:00 +0000
Message-Id: <20260831214600.C9DCA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Mixing goto-based error handling with scoped_guard() in megasas_=
resume() violates subsystem cleanup guidelines.

Pre-existing issues:
- [High] Missing IRQ teardown in megasas_resume error path leads to ISR Use=
-After-Free and memory leak.
--

commit aca55e5d3d8f6827c1bf9b8345c147c29fda17ef
Author: Bart Van Assche <bvanassche@acm.org>
scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()

This commit protects the megasas_get_ctrl_info() call within
megasas_resume() by wrapping it with scoped_guard() using
instance->reset_mutex. This ensures the function is called with the
mutex held, preventing unsafe releases and reacquisitions.

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index f0152b043e18c..d4cbc0643eaf1 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7875,7 +7875,9 @@ megasas_resume(struct device *dev)
>  			goto fail_init_mfi;
>  	}
> =20
> -	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
> +	scoped_guard(mutex, &instance->reset_mutex)
> +		rval =3D megasas_get_ctrl_info(instance);

[Severity: Medium]
Does mixing scoped_guard() with goto-based error handling in megasas_resume=
()
violate subsystem cleanup guidelines?

The subsystem documentation explicitly forbids mixing scope-based cleanup
helpers with goto-based error handling in the same function, requiring an
all-or-nothing conversion to avoid confusing ownership semantics.

Since megasas_resume() heavily relies on the goto fail_init_mfi style,
should this function be fully converted, or should a traditional
mutex_lock() and mutex_unlock() be used here instead?

> +	if (rval !=3D DCMD_SUCCESS)
>  		goto fail_init_mfi;

[Severity: High]
This is a pre-existing issue, but does the fail_init_mfi error path lack
proper IRQ teardown, creating a potential Use-After-Free?

If a failure occurs later in megasas_resume() after interrupts are enabled
(for example, if megasas_fusion_start_watchdog() fails), the code jumps to
fail_init_mfi and calls megasas_free_ctrl_mem(instance). This frees
instance->reply_map and the fusion context, but it does not call
megasas_destroy_irqs(instance) or disable the interrupts.

Since instance->mask_interrupts would be 0 at that point, any subsequent
shared or spurious interrupt could invoke megasas_isr_fusion(), accessing
the freed reply_map and fusion context.

Does this error path need to unregister interrupts before freeing the memor=
y?

> =20
>  	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/f06b5ee432b21cf293f=
0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org?part=3D1
