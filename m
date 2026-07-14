Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C0D12C534
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990931; cv=none; b=cOeYQ0CgvIHxgARxbwmymSGcyKCnd895X650N6zQeHkL1ktemLUSXcLY+VmMbja1Mvk4NRrdzeJxqjZOx4GvjxMYohE6zxJWChkigYhqnLoNBzRxkfH6ERzQhL4qZPp9W6wQsac4gumoqFwuqFzbQ6y/mLA+qOxz8JCSykczi+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990931; c=relaxed/simple;
	bh=49bB7ILMoH+tB1V1i2agu/y96e8OGIPbwxlBwsLFIbM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T5DWX4Xyaem+qd82JF56AaijB1RsLl4O+nZMOf8vTBvPsDG+Cm2AfR4zZ2I1z+cZBYiQ9v14JrRSTPdQaoUoaVm0gYMKmM9jQaIbe81PQS0utQsRjDBON/8fe6JBSq1bAhnhnpgNbGNdqMpNJo1N1uMjlN0zD0q16KP8ym247pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZW1wijQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZW1wijQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC841F000E9;
	Tue, 14 Jul 2026 01:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990930;
	bh=QsOapW3Vku1mLl2Ti217jhqadLNZCfKvFsTXEUUPjwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EZW1wijQcD+WYMBybyK6BzQkysNdtlIpNWU4wMV31NfH6xKnPzVERVgMs7cOnanfI
	 7m4AfjodLZ3lFWMn7aehJrUXiiW1odSg4sapjOawHqPzwsUqOERGHvBDnNWDvDdgA9
	 i2hqWE1EuFW/nBRslXNbBshZZfTjdMDPKYl2dXnQZho52ciskB6MWQEQbwamasyb34
	 8IKvpQU4RXCF5AuHHuIOSZ3gSw9jgwyfLN85acjJQatQXiJ9EHs+c/jxxyOezktXf0
	 XrZ5bsyz0M7qSSfehAE5aZvPp3QXyyh/biyvffmy4N04PRjSYA+nH2uDEU+Jsf0xqN
	 EdvVGgmRgY3dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/14] lpfc: Add handling for when PLOGI or PRLI is
 dropped during link failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-6-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-6-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 01:02:09 +0000
Message-Id: <20260714010209.CDC841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The vport-wide counter fc_prli_sent is modified under a node-speci=
fic spinlock (ndlp->lock), leading to data races during concurrent PRLI ope=
rations.
- [High] The patch only cleans up state flags for PLOGI and PRLI in the lin=
k down completion handler, completely missing identical cleanup requirement=
s for LOGO and ADISC, which causes the session to remain irrecoverably stuc=
k.
--

--- Patch [5]: [PATCH v3 05/14] lpfc: Add handling for when PLOGI or PRLI i=
s dropped during link failure ---
commit ef308ec0ae24b6ee74db89f761bac77e41718c55
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Add handling for when PLOGI or PRLI is dropped during link failure

This commit modifies the link down completion handler to clear the=20
NLP_PLOGI_SND and NLP_PRLI_SND flags and decrement the fc_prli_sent=20
counters. This ensures that normal cleanup actions are not missed when=20
PLOGI or PRLI commands are aborted due to a link failure. The fix=20
helps prevent recovery failures for login sessions.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c

[ ... ]

> @@ -1237,17 +1239,40 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, st=
ruct lpfc_iocbq *cmdiocb,
>  	ulp_status =3D get_job_ulpstatus(phba, rspiocb);
>  	ulp_word4 =3D get_job_word4(phba, rspiocb);
> =20

[ ... ]

> +	if (cmd =3D=3D ELS_CMD_PLOGI) {
> +		/* A PLOGI ELS IO needs to clear the PLOGI_SND flag to
> +		 * acknowledge the ELS completion and allow recovery. Otherwise
> +		 * a subsequent PLOGI gets rejected as a duplicate.
> +		 */
> +		clear_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
> +	} else if (cmd =3D=3D ELS_CMD_PRLI || cmd =3D=3D ELS_CMD_NVMEPRLI) {

[Severity: High]
This isn't a bug introduced by this patch, but does this handler also need =
to
clean up state flags for LOGO and ADISC?

If a LOGO or ADISC ELS command is aborted by a link down event and routed to
lpfc_cmpl_els_link_down(), it appears the NLP_LOGO_SND and NLP_ADISC_SND
flags are not cleared.

Could this permanently block subsequent connection or management commands to
this node? For example, would lpfc_rcv_plogi() silently ignore incoming PLO=
GIs=20
if NLP_LOGO_SND remains set?

> +		/* A PRLI ELS IO needs to decrement the fc4_prli_sent count
> +		 * added by the lpfc_issue_els_prli function.  A nonzero count
> +		 * stops transport registrations.
> +		 */
> +		clear_bit(NLP_PRLI_SND, &ndlp->nlp_flag);
> +		spin_lock_irq(&ndlp->lock);
> +		vport->fc_prli_sent--;
> +		ndlp->fc4_prli_sent--;
> +		spin_unlock_irq(&ndlp->lock);

[Severity: High]
This is a pre-existing issue, but can modifying the shared vport-wide count=
er
vport->fc_prli_sent under a localized node-specific lock (ndlp->lock) lead =
to
data races?

If concurrent ELS PRLI completions or issues on different nodes within the =
same
virtual port occur, each thread might acquire its own localized ndlp->lock =
and
perform a read-modify-write on vport->fc_prli_sent without mutual exclusion.

Could this lost update leave the counter permanently non-zero, causing
lpfc_scan_finished() to hang indefinitely and block SCSI device discovery?

>  	}
> =20
>  	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D5
