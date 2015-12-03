From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] cxlflash: a couple off by one bugs
Date: Thu, 03 Dec 2015 10:18:38 +0100
Message-ID: <1449134318.3311.11.camel@suse.de>
References: <1449098788-21695-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbbLCJSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:18:41 -0500
In-Reply-To: <1449098788-21695-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2015-12-02 at 17:26 -0600, Matthew R. Ochs wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> The "> MAX_CONTEXT" should be ">=3D MAX_CONTEXT".=C2=A0=C2=A0Otherwis=
e we go one
> step beyond the end of the cfg->ctx_tbl[] array.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
> This patch was originally sent by Dan Carpenter in September 2015. I =
had
> based my large patch series that went into 4.4 off of it but this pat=
ch
> appears to have not made it in. As a valid fix, I'd like to see this =
make
> it into 'next'. I've gone ahead and performed the rebase so that it
> applies cleanly.
>=20
> =C2=A0drivers/scsi/cxlflash/superpipe.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/cxlflash/superpipe.c
> b/drivers/scsi/cxlflash/superpipe.c
> index cac2e6a..34b21a0 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1380,7 +1380,7 @@ static int cxlflash_disk_attach(struct scsi_dev=
ice
> *sdev,
> =C2=A0	}
> =C2=A0
> =C2=A0	ctxid =3D cxl_process_element(ctx);
> -	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
> +	if (unlikely((ctxid >=3D MAX_CONTEXT) || (ctxid < 0))) {
> =C2=A0		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
> =C2=A0		rc =3D -EPERM;
> =C2=A0		goto err2;
> @@ -1508,7 +1508,7 @@ static int recover_context(struct cxlflash_cfg =
*cfg,
> struct ctx_info *ctxi)
> =C2=A0	}
> =C2=A0
> =C2=A0	ctxid =3D cxl_process_element(ctx);
> -	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
> +	if (unlikely((ctxid >=3D MAX_CONTEXT) || (ctxid < 0))) {
> =C2=A0		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
> =C2=A0		rc =3D -EPERM;
> =C2=A0		goto err1;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
