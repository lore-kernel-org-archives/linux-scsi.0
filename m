Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18A3AFCE3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454576; cv=none; b=e2irgzwiQyGXJGZhdKb5TZ3xPcmR1wNJs7ipaEAw9t61gxLiSdl1MvkSEu+7t1FglAm5jL8L/8P2QPNa05bIlAd1R1gLMv65277GNGDCs6Y8wGbvBPwjpf9a3yNf72QwrmSyCXsmhSpzy0CJdNlsJxHB0WkylzXms4X39mI8eH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454576; c=relaxed/simple;
	bh=cK7pNQ+ZYFg0GiVdoHRzxxnyvIsRCieq4Cvc1MYmLUw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OUjmtp7Rw0Bm9j6rKcbQvB47jlEsG0xAA4ULmPqnkTnrKfchMoBq7OupR43rzL8vIfOFqLBPF7+LRKCcEFR3HP/jIqCTex36SrmiY0xwP9ZHOITxcMPMNjoH9A3l21OqMi+Au6MdhmWQxrkkKpjvwl1LC5sntUF6OtSUVAQZqjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrTXQkqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrTXQkqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB8A1F000E9;
	Thu, 30 Jul 2026 23:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454575;
	bh=KyujPbPZjD0gVBG/rz4PFQ8AU8g32xE35CxTMnmskYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GrTXQkqnz2CPDokazhzQzhUeeaJ/yyH+ru9glGAGqmTt4BXd5uo4IS08q2ASj3GbV
	 /txavdstpjJfBThqwsqzlI5ejsXWFk/Ls+MtvZlzFgJbPLBxTMISKxTJiviuhTSYs+
	 UY4mq7dn8aJUopB2lkzQVOpotpRcPzm6+9K4C8jv4GyQ0l+I0vRFl6oytIO/oitedE
	 DVbeHaPFxiSEGYGBp/ZzmsBOYuuxfwaHBWydE9FpxpOMIn02OIVL3gHS7gXt6P61dv
	 QveG34H4MZRsHmribEFBeoFxKAuQ2h4b3h3pGK0CptvdeUPfAfV12uWksAGrrDfPIi
	 KWgNs4T5d9hPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 56/57] scsi: core: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <bab84be1d3cff4f1ab78e6508c20307f72aa9778.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <bab84be1d3cff4f1ab78e6508c20307f72aa9778.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:36:14 +0000
Message-Id: <20260730233614.CEB8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditional evaluation of `io_req->cb_arg->aborted_io_req->tgt->=
tgt_lock` causes a NULL pointer dereference for standard SCSI commands.
- [Medium] Falsely adding `__acquire()` macros to trick the static analyzer=
 instead of correctly annotating the function contract.
--

--- Patch [56]: [PATCH v3 56/57] scsi: core: Enable lock context analysis -=
--
commit 107a7992c0ed289ceb2e27bff45ba1eb5b8101fd
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Enable lock context analysis

Document which functions expect that shost->scan_mutex is held. Inform
the compiler about synchronization object aliases with __assume_ctx_lock().
Enable lock context analysis for the SCSI core and also for all drivers
in the drivers/scsi/ directory.

> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 842c254bb2269..a1fbdf4b0705a 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -14,6 +14,7 @@
>  # satisfy certain initialization assumptions in the SCSI layer.
>  # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
> =20
> +CONTEXT_ANALYSIS :=3D y

[Severity: High]
Does enabling context analysis here cause a NULL pointer dereference in
bnx2fc_process_cq_compl()?

When context analysis is enabled, __assume_ctx_lock() forces the compiler
to evaluate its argument. For standard SCSI commands where io_req->cb_arg
is NULL, this expression in drivers/scsi/bnx2fc/bnx2fc_hwi.c will
dereference a NULL pointer on the CQ completion fast path:

	/* Tell the compiler that there is an alias for tgt->tgt_lock. */
	__assume_ctx_lock(&io_req->cb_arg->aborted_io_req->tgt->tgt_lock);


[Severity: Medium]
Are the __acquire() annotations in pqi_process_soft_reset() masking an
unbalanced unlock from the static analyzer?

By enabling context analysis, it looks like this exposes a mismatch in the
contract for pqi_ofa_quiesce_worker() in drivers/scsi/smartpqi/smartpqi_ini=
t.c.

The worker is incorrectly annotated as returning with the scan_mutex and
lun_reset_mutex held:

static void pqi_ofa_quiesce_worker(struct work_struct *work)
	__acquires(&quiesce_work_to_ctrl_info(work)->scan_mutex)
	__acquires(&quiesce_work_to_ctrl_info(work)->lun_reset_mutex)

However, the worker calls pqi_process_soft_reset(), which unconditionally
drops these locks in all execution paths.

It looks like fake __acquire() macros were added to pqi_process_soft_reset()
to trick the analyzer into ignoring the unbalanced unlocks:

	/* What guarantees that these mutexes are held here? */
	__acquire(&ctrl_info->lun_reset_mutex);
	__acquire(&ctrl_info->ofa_mutex);
	__acquire(&ctrl_info->scan_mutex);
	pqi_ctrl_ofa_done(ctrl_info);
	pqi_ofa_ctrl_unquiesce(ctrl_info);

Does this intentionally hide the dynamic lock release pattern from the stat=
ic
analyzer instead of correctly annotating the function contract?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D56
