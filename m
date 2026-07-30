Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2817846EF9B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452462; cv=none; b=lpchM5u6RykvZ88klX1ZePcZyPGZGW38uZd7KYZgrhCTsvoJoBqgLSQzFX4IE4ZPmBp/n73+4NPS8iwnJ/Td4BK547q9CmKJYeg3Jk2zuN2XdeSPaA/EdNjTQukidLFxiDJSd4B2pSr2fDH6AhBA9BZWcNZbx8nOYS4c+jyCRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452462; c=relaxed/simple;
	bh=e7Ytl07sHblZ4dCSIO0Lc/BPMzbBf0rRI9vm2pHSwjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WmqTViWE5SPJVVtuuTZNBYyGynxdsGp8QPc9TmW+PvG9nb+MoETUbcOjJyYZEhhucvoXCyJ2dosY6ibcPUlvWegQqG8fKStO1IiDS51LTDB03U6Kkd01Hsx2emSAWwnkhCPcQ7aMWDOCKL4lC/L4m6zDtgkNNb1cgjaXbsKAgK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeL3ap3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeL3ap3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00E31F000E9;
	Thu, 30 Jul 2026 23:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452460;
	bh=ibLTmJ7mV4F3nb6mUO+WMQegedxndoYrPcJiscFzNVs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XeL3ap3YbhLmCqP+iCjvETBacT/nr45lorthat9Wj2LoIDTmL+14wJX9r9afvQpPc
	 4Qnuv6MCaLf+mZxTbMi8z5pjzKYocTI2CqO2KAya6AxyGyvAk9NUWdnmVexfIFieYY
	 D0v4fReB8GqQkVHJcM9Uq6JgkIesfw+FIln6VMTbgOg4RBzcMcKqZXybbaysG1HQ6z
	 9M/7xGWxVdMjyuv+Sg7iEHY9JT3rcl+61jes8ZuiV5xs7NMSMHFS7C3Y1W7adHR2zs
	 unmPFFTZHx9xTPqTyFj+wxx1hnu/lUXWBTmuOw0oFqrGW/KII32eaUUbW9MYjvheBN
	 biWFzTqwB1SdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/57] scsi: bnx2fc: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <8916cb8f189b235cf7873378617575c922463dd3.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <8916cb8f189b235cf7873378617575c922463dd3.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:01:00 +0000
Message-Id: <20260730230100.A00E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional evaluation of nested pointer chain in `__assume_ctx_=
lock()` causes a potential fatal NULL pointer dereference for standard SCSI=
 commands.
--

--- Patch [19]: [PATCH v3 19/57] scsi: bnx2fc: Enable lock context analysis=
 ---
commit 914539bc4256a83053d649d7450d8f075fb16ba8
Author: Bart Van Assche <bvanassche@acm.org>

scsi: bnx2fc: Enable lock context analysis
   =20
This patch enables context lock analysis by documenting locking requirements
and informing the compiler about lock aliases. It updates functions with
__must_hold() and __assume_ctx_lock() to track context around target locks.
It also standardizes an argument name in bnx2fc_process_seq_cleanup_compl().

> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2f=
c_hwi.c
> index a5ecb87d5b2d7..a3670c48900ba 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -880,6 +880,9 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt=
, u16 wqe,
>  		return;
>  	}
> =20
> +	/* Tell the compiler that there is an alias for tgt->tgt_lock. */
> +	__assume_ctx_lock(&io_req->cb_arg->aborted_io_req->tgt->tgt_lock);

[Severity: High]
Does this unconditionally evaluate io_req->cb_arg?

For standard SCSI commands, io_req->cb_arg is NULL.

Since the kernel is compiled with -fno-delete-null-pointer-checks, computing
the address of tgt_lock requires evaluating the intermediate pointers.

This means the compiler is highly likely to emit a memory load rather than
optimizing away the dead read, since it treats address 0 as valid.

Could this lead to a fatal NULL pointer dereference on every standard IO
completion processed by bnx2fc_process_cq_compl()?

It appears this annotation might belong solely inside the BNX2FC_SEQ_CLEANUP
case where cb_arg is known to be valid.

> +
>  	/* Timestamp IO completion time */
>  	cmd_type =3D io_req->cmd_type;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D19
