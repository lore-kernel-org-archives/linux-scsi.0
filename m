From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 06/15] qedf: Add fka_period SCSI host attribute to show
 fip keep alive period.
Date: Wed, 24 May 2017 16:34:58 +0000
Message-ID: <1495643697.2823.21.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-7-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61835 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030748AbdEXQfD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:35:03 -0400
In-Reply-To: <20170523131931.1777-7-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <AE514F5E6F1079459D33FD3017E98AA6@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> Expose this information for interested applications.
>=20
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/qedf/qedf_attr.c | 60 +++++++++++++++++++++++++++++--------=
------
>  1 file changed, 41 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.=
c
> index 1349f8a..68e2b77 100644
> --- a/drivers/scsi/qedf/qedf_attr.c
> +++ b/drivers/scsi/qedf/qedf_attr.c
> @@ -8,6 +8,25 @@
>   */
>  #include "qedf.h"
> =20
> +inline bool qedf_is_vport(struct qedf_ctx *qedf)
> +{
> +	return (!(qedf->lport->vport =3D=3D NULL));
> +}

Have you considered to write the return statement as follows?

	return qedf->lport->vport !=3D NULL;

Checkpatch should have recommended not to use parentheses in the return
statement.

> +
> +/* Get base qedf for physical port from vport */
> +static struct qedf_ctx *qedf_get_base_qedf(struct qedf_ctx *qedf)
> +{
> +	struct fc_lport *lport;
> +	struct fc_lport *base_lport;
> +
> +	if (!(qedf_is_vport(qedf)))
> +		return NULL;
> +
> +	lport =3D qedf->lport;
> +	base_lport =3D shost_priv(vport_to_shost(lport->vport));
> +	return (struct qedf_ctx *)(lport_priv(base_lport));
> +}

lport_priv() returns a void pointer so the cast in the return statement is =
not
necessary.

> +static ssize_t
> +qedf_fka_period_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct fc_lport *lport =3D shost_priv(class_to_shost(dev));
> +	struct qedf_ctx *qedf =3D lport_priv(lport);
> +	int fka_period =3D -1;
> +
> +	if (qedf_is_vport(qedf))
> +		qedf =3D qedf_get_base_qedf(qedf);
> +
> +	if (!qedf->ctlr.sel_fcf)
> +		goto out;
> +
> +	fka_period =3D qedf->ctlr.sel_fcf->fka_period;
> +
> +out:
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", fka_period);
> +}

Do we really need a goto statement to skip a single statement? How about th=
e
following:

	if (qedf->ctlr.sel_fcf)
		fka_period =3D qedf->ctlr.sel_fcf->fka_period;

	return scnprintf(buf, PAGE_SIZE, "%d\n", fka_period);

or this:

	return scnprintf(buf, PAGE_SIZE, "%d\n",=A0qedf->ctlr.sel_fcf ?
                         qedf->ctlr.sel_fcf->fka_period : -1);

Bart.=
