Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC942255D;
	Wed, 15 Jul 2026 09:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107218; cv=none; b=eeLoyFTkctRHkknUgDQmlVaEK6UQrTRyDonpkzKlIm1RPAarExKhjrKeHMOdKtx0WH5iewIsEHw5jahpeGFyd5chiNwvQmKpgSu29VUM7JSFwiU7qkOBXfnAP3VP+c60CtU5ERxakfuEC4FHP4WwtmM8l1zgEzGBtw1IOug0u9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107218; c=relaxed/simple;
	bh=SPvT2fwtVxOg4QF/WI3FqLnw09C2kwdUM/LB626BWCs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G8OlvyyAFyv7Lse0Youd37yv+PYB6RPeGZ+Aw/XIBDmq2yPrylaZibgONdvAe6uZUg7cnJ2rvqaOjSZj3Ru/JFVeZty+59XdtmaFX/LrL+NQmUtKrwkP5OTEqcAAbo4/CrrUncLmsqTPCLe6QXBxCIf5TmBWh4vhyjRxDR7ISt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2qLOFgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2qLOFgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CBF1F000E9;
	Wed, 15 Jul 2026 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784107217;
	bh=qnVMwIQULdtInfB0DlZZ1AJhT7oYSm1kwUWGDsZykf0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z2qLOFgX30oeIyHt/B1iqND8YjXtQtiZmun4MHQu7GCBtRJzx9KbequlXwJzM+BxD
	 KKZSDCK+fO7gQwmdYXpWJFEJm/C0omIYz0iclQ7MAAJnnOKWiYNZp/82nmhjBQQF6n
	 KJpGSBGEjCoDPuQl7zF1RdZQawQYRP6JaF6LZCLYxKOUvMt+YERWysMK3IDaCVcD7K
	 QGwBx3MUFvLBQc8mLEW0V3b7Ge3/RzV2df5JNi46ydngahRzNMiGp+XEAy25JEl9tG
	 JUMbMoqkFXD8EyV5Mp6PbzQiPXO4CNRIY5QvnTcOwmtPZRUkVhGRa64IBlODXFTx6u
	 CR8lU89cfDD7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260715085824.854200-2-dlemoal@kernel.org>
References: <20260715085824.854200-1-dlemoal@kernel.org>
 <20260715085824.854200-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 09:20:16 +0000
Message-Id: <20260715092017.05CBF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Deferred commands retried via `ata_eh_retry_deferred_qc` will be e=
rroneously processed as ghost timeouts during SCSI EH, leading to lost retr=
ies or erroneous `DRIVER_TIMEOUT` failures for unissued commands, and `host=
_failed` underflows.
--

--- Patch [1]: [PATCH v4 1/2] ata: libata-scsi: terminate deferred commands=
 on time out ---
commit 40daf934a62cbe822fdf8ae16b1ee66e4ac23f37
Author: Damien Le Moal <dlemoal@kernel.org>

ata: libata-scsi: terminate deferred commands on time out

This patch introduces ata_scsi_eh_timed_out() to immediately schedule a ret=
ry
of all waiting deferred QCs using the eh_timed_out SCSI host template
operation. It implements ata_eh_retry_deferred_qc() to schedule the retry
through libata EH with ata_qc_schedule_eh() and flags waiting QCs with
ATA_QCFLAG_RETRY.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")

> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 05df7ea6954a9..5c56e1dd580b6 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -546,6 +546,27 @@ static void ata_eh_unload(struct ata_port *ap)
>  	spin_unlock_irqrestore(ap->lock, flags);
>  }
> =20
> +void ata_eh_retry_deferred_qc(struct ata_port *ap,
> +			      struct scsi_cmnd *timedout_scmd)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct ata_link *link;
> +
> +	lockdep_assert_held(ap->lock);
> +
> +	/* Trigger EH for retrying any deferred qc that has not timed out. */
> +	ata_for_each_link(link, ap, PMP_FIRST) {
> +		qc =3D link->deferred_qc;
> +		if (!qc || qc->scsicmd =3D=3D timedout_scmd)
> +			continue;
> +
> +		link->deferred_qc =3D NULL;
> +		cancel_work(&link->deferred_qc_work);
> +		qc->flags |=3D ATA_QCFLAG_RETRY;

[Severity: High]
Does clearing link->deferred_qc here break the deferred QC lookup in
ata_scsi_cmd_error_handler()?

When the SCSI EH thread runs ata_scsi_cmd_error_handler(), it attempts to
identify the deferred QC:

drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
    ...
    if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
        qc =3D=3D qc->dev->link->deferred_qc)
        break;
    ...
}

Because ATA_QCFLAG_ACTIVE is not set on deferred commands and we have alrea=
dy
cleared link->deferred_qc to NULL above, the condition fails. The loop
finishes without breaking and falls through to the ghost timeout branch:

drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
    ...
    } else {
        /* Normal completion occurred after
         * SCSI timeout but before this point.
         * Successfully complete it.
         */
        scmd->retries =3D scmd->allowed;
        scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
    }
}

Will this cause the retry budget for the deferred command to be artificially
exhausted, resulting in erroneous DRIVER_TIMEOUT failures for unissued
commands?

Additionally, when libata EH later processes this same qc in ata_eh_finish()
and calls ata_eh_qc_retry(), it will execute __ata_eh_qc_complete() and call
scsi_eh_finish_cmd() a second time for the same command. Could this double
completion cause host_failed to underflow and corrupt the SCSI EH state
machine?

> +		ata_qc_schedule_eh(qc);
> +	}
> +}
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715085824.8542=
00-1-dlemoal@kernel.org?part=3D1
