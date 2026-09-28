Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C50B439F83
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614375; cv=none; b=opH7Tg1bPaKbb1FeGZuohxRe2Lt0C71RGyT42eku9812kUmFtscq9UA/pgWU31HDrJb78WrHnvH9WYonh/ZC5vTVOAXowvQ41TFPAkOa5n8tU8UKDXCEfhYybFPkkQwMO3fKWS0xByytklmmXsBIQQwEaTBzof/dVO27mKhHt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614375; c=relaxed/simple;
	bh=OzTmZmDs9YIyQS/MKM1e1ti3elTfYopzAfjynKR5Jfc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hIxSb1rvxLCrC2ekU6tOmgEQvoAmH6JIb5rg1bA2SBoy1SDPLR0uUkC9wW6NXDJAwqXqQRB74iuxB5nvC34jEayYnP/VXCpEjU7HtjkAAyl6ANvn8WzF5gopgt5/lHiXsb86pGR44jQec/LTKitjQU75ySEBjaYTA7gVLZ/JQHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKn86GC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKn86GC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FFE1F000FF;
	Mon, 28 Sep 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790614374;
	bh=CsCWbMhQ3gPaqEGzNZKJEYml9Y3yIjYDN3a7vN7SGNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cKn86GC/eiMxYQ/ivYZ08fE24svPbVEDuQSO07XCoYPG7ZDrRodGARHprAxLPSple
	 VEezcor+I4IgXO5jIPgznLEeOCLOr8AoPtwqD2/5x7TE2dIYKYhnAH1IbxKxO+VpZZ
	 gyp5AwUcLVBVMdLn1WR4C+QPa3VpsRASLmud5iTSm+HA+zO5HEJ9/ULo24mV9K358H
	 t1mSDduI1t9s30EovSUE2SOr5BseElEkTf9NkVF1PTqMvgaGN3XEUApqi98HxJl4tj
	 93bIMzdBybx+L//OlaUJLtUaV0r4w8BJcBqgpmiy1WSVAMDWvMgP4usUvlG1jZnlAx
	 9s1det4iFmB4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/1] scsi: lpfc: defer SCSI rport node put until
 devloss callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dai Ngo" <dai.ngo@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928163433.2086184-1-dai.ngo@oracle.com>
References: <20260928163433.2086184-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 16:52:53 +0000
Message-Id: <20260928165253.C0FFE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] lpfc: memory leak of lpfc_nodelist on rport reconnect or early ret=
urn
--

commit 55116da6dbf444daa1282aba1d53431f3bfd853f
Author: Dai Ngo <dai.ngo@oracle.com>
Date:   Mon Sep 28 16:31:48 2026 +0000

scsi: lpfc: defer SCSI rport node put until devloss callback

This commit defers dropping the SCSI rport node reference in the lpfc driver
until the devloss callback detaches it. It removes the immediate reference =
drop
after fc_remote_port_delete() to prevent use-after-free conditions.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index 4c673dffa671b..7a6f80ca92746 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c

[ ... ]

> @@ -271,6 +272,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>  	 * rport. Remove the association between rport and ndlp.
>  	 */
>  	ndlp->fc4_xpt_flags &=3D ~SCSI_XPT_REGD;
> +	drop_scsi_node_ref =3D true;
>  	((struct lpfc_rport_data *)rport->dd_data)->pnode =3D NULL;
>  	ndlp->rport =3D NULL;
>  	spin_unlock_irqrestore(&ndlp->lock, iflags);

[Severity: High]
This is a pre-existing issue, but by not reaching this cleanup block on ear=
ly
returns, could we leave a dangling pointer?

If lpfc_dev_loss_tmo_callbk() exits early, such as when ndlp->nlp_state is
NLP_STE_MAPPED_NODE or a dev_loss_evt is already pending, it bypasses clear=
ing
the SCSI_XPT_REGD flag and ndlp->rport.

When the SCSI transport later deletes and frees the fc_rport, wouldn't
ndlp->rport be left dangling? Then, if lpfc_nlp_unreg_node() is called:

lpfc_nlp_unreg_node() {
    ...
    if (ndlp->rport &&
        ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
        vport->phba->nport_event_cnt++;
        lpfc_unregister_remote_port(ndlp);
    ...
}

Will it pass the freed rport to fc_remote_port_delete() and cause a
use-after-free?

[ ... ]

> @@ -4577,7 +4583,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *n=
dlp)
>  			 kref_read(&ndlp->kref));
> =20
>  	fc_remote_port_delete(rport);
> -	lpfc_nlp_put(ndlp);
>  }
> =20
>  static void

[Severity: High]
By deferring this cleanup to lpfc_dev_loss_tmo_callbk(), could we leak the
node reference?

If the remote port reconnects before the dev_loss_tmo expires, the SCSI
transport calls fc_remote_port_add(), which cancels the pending
dev_loss_work timer and bypasses the devloss callback. It then clears
rport->dd_data.

When lpfc_register_remote_port() executes, it will overwrite rdata->pnode
with a new lpfc_nlp_get(ndlp) reference, permanently leaking the original
node reference.

Also, what happens if lpfc_dev_loss_tmo_callbk() does run but takes an early
return?

lpfc_dev_loss_tmo_callbk() {
    ...
    if (ndlp->nlp_state =3D=3D NLP_STE_MAPPED_NODE)
        return;
    ...
}

Does this skip the newly deferred lpfc_nlp_put() cleanup, resulting in the
same leak of the node reference?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928163433.2086=
184-1-dai.ngo@oracle.com?part=3D1
