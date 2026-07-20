Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A593C3F74;
	Mon, 20 Jul 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533018; cv=none; b=DOV5E+cbHX+rzkLE7uTpU1ANacU5aUZpRgzsVame6/2O/ZJQGj2F2tChB/QVQ/5NEx44Dkcqn3yDVP0BxHDBf1VG0zM1Oe67hBgiraLLQThVZmeLkIMPBTrHCp/co2Gm9luk8xpeWBVG+AFaY+RFtAK/88nnr31t8eanmBozZwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533018; c=relaxed/simple;
	bh=pPnKZ4YclXiHwfh33fKCD8BSmy/eBQgbaEw1cZ67h/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mypt+4L7PoLJyKBAEkPwEBIsyHWBFDI+6x6TIsPCkhcK5QqvNMTzx8OvbG2EpK5ysOdLaaYEgCeB2gJYGikzDhdJ8rT3PKYwlRD8JhnlotnJIDy+dn5fK5rVDYLyQr+2KZM8GSAQkXl1659xknmLbMvEUyGD2kCpFtAerkWJ8XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bf3L1fkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bf3L1fkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991C91F000E9;
	Mon, 20 Jul 2026 07:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784533016;
	bh=UhWVtFaszsaZ7CVir3x7hFpdWPzAW78iP0KZPkwBaNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bf3L1fkxT2V2BuIFjzhiQn3sXikVsIaciEa/JVTHeZWklvmpn/1o4OP6tl89NwQeG
	 4hI90I5d5iFmHipMcAGhsuE1oXRyHwJsTlaQ67x5u9oll7gkEedgCbFF3pBYKIVBho
	 DD0WWa2jFXGV5s4vJ5IbzH1spFj+KZynC5nJ8Qi68Xmz7KOpb3D//dvQuN4Qylh1/9
	 TV75qMiADK80Qd66PJSydGtfQlaVDmPWgH2dtl0ezAxYqiaoOgH/gUxpPWDqWxQXje
	 3K4oKggwt9l7Qw5b6ovVqXg18F4kfMhPFItKxEmDRdKSJ8C8U9gRYpZF97haHkEEsb
	 JTIhnBolm6bpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] scsi: libsas: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260720071450.1877625-3-dlemoal@kernel.org>
References: <20260720071450.1877625-1-dlemoal@kernel.org>
 <20260720071450.1877625-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 07:36:56 +0000
Message-Id: <20260720073656.991C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] A race condition between the SCSI timeout handler and ata_scsi=
_requeue_deferred_qc(ap, NULL) causes timed-out deferred commands to be sil=
ently completed as SUCCESS, leading to data corruption.
--

--- Patch [2]: [PATCH v6 2/2] scsi: libsas: terminate deferred commands on =
time out ---
commit e25a34ed23fb53d891efaea25a8a4f4ff07ee231
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: libsas: terminate deferred commands on time out

This patch implements the eh_timed_out SCSI host template operation for lib=
sas.
It avoids unnecessary SCSI EH trigger wait times for deferred non-NCQ comma=
nds
by utilizing ata_scsi_retry_deferred_qc() for SATA devices, mirroring the
method used in libata-scsi.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b02b4ca5c09e2..dfd7fc2c8cb66 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1762,8 +1762,7 @@ static void ata_scsi_schedule_deferred_qc(struct at=
a_link *link)
>  		queue_work(system_highpri_wq, &link->deferred_qc_work);
>  }
> =20
> -static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
> -				       struct scsi_cmnd *scmd)
> +void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *s=
cmd)
>  {
>  	unsigned long flags;
> =20
> @@ -1771,6 +1770,7 @@ static void ata_scsi_retry_deferred_qc(struct ata_p=
ort *ap,
>  	ata_scsi_requeue_deferred_qc(ap, scmd);
>  	spin_unlock_irqrestore(ap->lock, flags);
>  }
> +EXPORT_SYMBOL_GPL(ata_scsi_retry_deferred_qc);

[Severity: Critical]
This is a pre-existing issue, but does exporting and reusing
ata_scsi_retry_deferred_qc() expose us further to a race condition with
ata_scsi_requeue_deferred_qc()?

If a deferred SATA command times out, the block layer marks its request as
MQ_RQ_COMPLETE and enters scsi_timeout(). Concurrently, if EH is scheduled =
for
another command on the same port, ata_eh_set_pending() can call
ata_scsi_requeue_deferred_qc(ap, NULL).

When called with timedout_scmd =3D=3D NULL, this clears link->deferred_qc a=
nd calls
ata_scsi_qc_done():

drivers/ata/libata-scsi.c:ata_scsi_requeue_deferred_qc() {
    ...
    if (!timedout_scmd) {
        ...
        ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
        continue;
    }
    ...
}

ata_scsi_qc_done() zeroes qc->flags via ata_qc_free(), and calls scsi_done(=
),
which the block layer ignores due to the concurrent timeout. The timeout pa=
th
then adds the command to EH.

When ata_scsi_cmd_error_handler() runs, it fails to find the QC because
qc->flags is 0, assuming normal successful completion:

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
    ...
}

Can this race cause timed-out deferred commands to be silently completed as
SUCCESS, leading to silent data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720071450.1877=
625-1-dlemoal@kernel.org?part=3D2
