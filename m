Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6A3F58D9;
	Thu,  9 Jul 2026 09:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783587608; cv=none; b=ZqER5tD74eh4f36CWDDj+eseMMKZVTMDFU1jV55YQ4yhUlxlDc1vENLcqYYDAv0LioFrNqN9e7I2f+IgXiKQOazo3fA+QL+gSSJHMeowh3M53tTYi4ykmSGfP4BX0ggHEZhfE+3QHBVrD6kC2uWjUHob/iqhN128CPoNqZ7/ou8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783587608; c=relaxed/simple;
	bh=1E99Ci0HEtHJ+yVBfn3LsOa+n1VAbTwBJGx2Z+KonbQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Twfa2RJQitw7sOMq3vtvSn7Y9laGUawtnbGhA1mukebPRhm0nY7DqMIT367dram36MEsBl90bxwzRREOsPJR16OJ/vRDmf5jQeraBkHMFtSF9ehaPbbzsbIP54CilvNklTKTrlOEsUZ2D3eZKo7U4Uf7DoDjm7RvCkHtPRBEmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXGKLpS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXGKLpS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317F1F00A3A;
	Thu,  9 Jul 2026 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783587607;
	bh=ulXS0hLXPmgXwtuAo4pf/MjmR5bUjDtZ20S+kPmHfNA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BXGKLpS0kadXA86dvfIFl2YNDOr52VyHOZmdu9ugMFWoJOPEy17SEydlY3L9vGZvT
	 bstTWzf3xqDL39/Q+VRHDJrgxvMo2RITgtMMWXngEGtL7GlC04z5MPpS9jn/D2YiEi
	 yiP/33OaCcteaE5D0fL35pP+dKzrpV+ifv5EzmACao4vHb+cZwd6pk+ZofPNtHSR5Y
	 baiWvITFuvjdWGw+RPLSkYCED8s8CLTFNBBjqdhaNsPf6S6DNLM1jvZmjtBrg0iCXl
	 ZTZtP1534E0WwubTnWbHnk7R+BPfyqjVQsFsM+8XuDRi8bKcBl68WLX+jXrAGpp9JS
	 DzDIQk6Z6mNtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260709083934.1116862-2-dlemoal@kernel.org>
References: <20260709083934.1116862-1-dlemoal@kernel.org>
 <20260709083934.1116862-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 09:00:06 +0000
Message-Id: <20260709090006.F317F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The eh_timed_out handler prematurely completes the timed-out defer=
red command, freeing the libata `qc` and causing the SCSI error handler to =
permanently fail the command instead of retrying it.
--

--- Patch [1]: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands=
 on time out ---
commit 5d7ac082b6ce256e2174fbf7d209e8acc3d6b3a9
Author: Damien Le Moal <dlemoal@kernel.org>

ata: libata-scsi: terminate deferred commands on time out

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the scsi EH task is never woken up. Avoid this
unnecessary EH trigger wait time by using the eh_timed_out scsi host
template operation to terminate deferred QCs.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5868526301a2b..8328778ec0464 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -1698,12 +1699,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port=
 *ap)
>  	 */
>  	ata_for_each_link(link, ap, PMP_FIRST) {
>  		struct ata_queued_cmd *qc =3D link->deferred_qc;
> +		u32 host_byte;
> =20
> -		if (qc) {
> -			link->deferred_qc =3D NULL;
> -			cancel_work(&link->deferred_qc_work);
> -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> -		}
> +		if (!qc)
> +			continue;
> +
> +		link->deferred_qc =3D NULL;
> +		cancel_work(&link->deferred_qc_work);
> +
> +		if (qc->scsicmd =3D=3D timed_out_scmd)
> +			host_byte =3D DID_TIME_OUT;
> +		else
> +			host_byte =3D DID_REQUEUE;
> +		ata_scsi_qc_done(qc, true, host_byte << 16);

[Severity: High]
Does calling ata_scsi_qc_done() here prematurely complete the timed-out
deferred command and free the libata qc?

When a deferred command times out, ata_scsi_eh_timed_out() calls this funct=
ion
which sets the host byte to DID_TIME_OUT and calls ata_scsi_qc_done().
ata_scsi_qc_done() then frees the qc and invokes the qc->scsidone callback.

Later, when the SCSI completion softirq routes the DID_TIME_OUT command to =
the
EH queue and the EH thread runs ata_scsi_cmd_error_handler():

drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
    ...
    set_host_byte(scmd, DID_OK);
    ata_qc_for_each_raw(ap, qc, i) {
        if (qc->scsicmd !=3D scmd)
            continue;
        if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
            qc =3D=3D qc->dev->link->deferred_qc)
            break;
    }
    ...
}

Because the qc was already freed, the ATA_QCFLAG_ACTIVE flag is cleared
and deferred_qc is NULL. The loop will fail to find the active command.

It seems this causes the handler to fall into the 'raced completion' branch:

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

Could this result in the midlayer completely dropping the timed-out deferred
command (completed with DID_OK and no retries) instead of properly retrying=
 it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709083934.1116=
862-1-dlemoal@kernel.org?part=3D1
