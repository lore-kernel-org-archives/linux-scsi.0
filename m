Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8E537647B
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788212151; cv=none; b=ZF3eWcbQfM7t8PzVGuaip6ymGoIR2DIFw+fd+DTMOCiFKGxAoCFB2LKHrjg3iBIc+7m4NJ7y+sIWkrC0OKlcFJvEteAkIj4gFxodydxoZ27SzouWGqWHwa2UhTIbulIqxRV9FCF+RXeI6Iwg4dmvXn4/uJoiYTqIV5hXMsaKK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788212151; c=relaxed/simple;
	bh=NELBlKY+TQ+cWhWyDxAIjxShnNnSvPU7CVbHBgBhq4A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UHzy4b2neKiVcKmsM4OhWYQd4aB2eVZb8KAHCYrGIWwbJObRt2msnfxCp4SH+f113yJGKSGK2qK2Aqb1qMCg8OQ+zOevqgNmUOl8ICyq6DTZw9vgCXCIORZAYxNCcvV8pP8+7J7eQRFX4NNHnjp5XxpLZeVIjLob4FdK6MQICck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiZXe/6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiZXe/6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7EE1F000E9;
	Mon, 31 Aug 2026 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788212150;
	bh=IE3uCJRJSmTvKCVs4Gfw0YoSTqFPrQvlf1oAT/b1mWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MiZXe/6QAEBn5rK/xqqhbbEal4VmfCCTUPQQvk0VDLH/3LaXPCJ0hYvDHsdayRt74
	 Tg5cMMN8thv9Vv5w/XybRE2jHeJ05/z38W29YMOoz19bhR7jg42pGM/2+vDMXNZVqa
	 JSDjyt5oJGeyj//xhXj65sdvZVp3oriseO0UQJpjQ8QrcKeH/r575wpas/OYVgdwNL
	 B2iCslWmi3ENkX8/gN4nQqpqiMNBGyNLxUDTprOkqjSeDxAnyRHeWpdKfsZOfJlUuH
	 1JawKcMdOPPndFD7E+XRbG+4+bW7LlIwjqHK2S6httNBoSCINRDzMo5X3BlXxDVAzW
	 U7bZleH0yqp9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: Rework the DEF_SCSI_QCMD() implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <61df3d2ad6e65f188469708fb05b679b49596cef.1788204517.git.bvanassche@acm.org>
References: <61df3d2ad6e65f188469708fb05b679b49596cef.1788204517.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:35:49 +0000
Message-Id: <20260831213550.2E7EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Accessing `cmd->device` in `spin_unlock_irq` after the command=
 may have been completed results in a Use-After-Free.
- [Low] The `shost` parameter in the macro-generated function is completely=
 unused, which triggers compiler warnings.
--

commit 6119bc222730902c8f828977bcf9466e8f555a95
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Rework the DEF_SCSI_QCMD() implementation

This commit modifies the DEF_SCSI_QCMD() macro to lock against
cmd->device->host->host_lock directly instead of using the provided shost.
It also removes the saving and restoring of IRQ flags since the queue
function is always called from thread context.

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -531,12 +531,11 @@ struct scsi_host_template {
>  	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
>  				      struct scsi_cmnd *cmd)		\

[Severity: Low]
Does this leave the shost parameter completely unused within the function
body?=20

It seems this could trigger compiler warnings for unused parameters when
compiling drivers utilizing this macro.

>  	{								\
> -		unsigned long irq_flags;				\
>  		enum scsi_qc_status rc;					\
>  									\
> -		spin_lock_irqsave(shost->host_lock, irq_flags);		\
> +		spin_lock_irq(cmd->device->host->host_lock);		\
>  		rc =3D func_name##_lck(cmd);				\
> -		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
> +		spin_unlock_irq(cmd->device->host->host_lock);		\

[Severity: Critical]
Can this cause a use-after-free if the command is completed during the
execution of func_name##_lck(cmd)?

If a driver's implementation processes the command and completes it by
calling scsi_done(cmd) before returning, the block layer can reclaim and
recycle the cmd structure immediately.=20

When the wrapper then executes spin_unlock_irq(cmd->device->host->host_lock=
),
cmd->device may already be a dangling pointer.

Using the passed shost parameter for the unlock operation would avoid
dereferencing cmd after it may have been handed off.

>  		return rc;						\
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/61df3d2ad6e65f18846=
9708fb05b679b49596cef.1788204517.git.bvanassche@acm.org?part=3D1
