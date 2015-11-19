From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2] st: fix potential null pointer dereference.
Date: Thu, 19 Nov 2015 16:13:41 +0100
Message-ID: <1447946021.10313.13.camel@suse.de>
References: <1447857164-2043-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722AbbKSPNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 10:13:44 -0500
In-Reply-To: <1447857164-2043-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, 2015-11-18 at 15:32 +0100, Maurizio Lombardi wrote:
> If cdev_add() returns an error, the code calls
> cdev_del() passing the STm->cdevs[rew] pointer as parameter;
> the problem is that the pointer has not been initialized yet.
>=20
> This patch fixes the problem by moving the STm->cdevs[rew] pointer
> initialization before the call to cdev_add().
> It also sets STm->devs[rew] and STm->cdevs[rew] to NULL in
> case of failure.
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> =C2=A0drivers/scsi/st.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e0a1e52..2e52295 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4083,6 +4083,7 @@ static int create_one_cdev(struct scsi_tape
> *tape, int mode, int rew)
> =C2=A0	}
> =C2=A0	cdev->owner =3D THIS_MODULE;
> =C2=A0	cdev->ops =3D &st_fops;
> +	STm->cdevs[rew] =3D cdev;
> =C2=A0
> =C2=A0	error =3D cdev_add(cdev, cdev_devno, 1);
> =C2=A0	if (error) {
> @@ -4091,7 +4092,6 @@ static int create_one_cdev(struct scsi_tape
> *tape, int mode, int rew)
> =C2=A0		pr_err("st%d: Device not attached.\n", dev_num);
> =C2=A0		goto out_free;
> =C2=A0	}
> -	STm->cdevs[rew] =3D cdev;
> =C2=A0
> =C2=A0	i =3D mode << (4 - ST_NBR_MODE_BITS);
> =C2=A0	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
> @@ -4110,8 +4110,9 @@ static int create_one_cdev(struct scsi_tape
> *tape, int mode, int rew)
> =C2=A0	return 0;
> =C2=A0out_free:
> =C2=A0	cdev_del(STm->cdevs[rew]);
> -	STm->cdevs[rew] =3D NULL;
> =C2=A0out:
> +	STm->cdevs[rew] =3D NULL;
> +	STm->devs[rew] =3D NULL;
> =C2=A0	return error;
> =C2=A0}
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
