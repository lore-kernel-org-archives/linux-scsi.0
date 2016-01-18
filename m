From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 5/9] aacraid: Set correct msix count for EEH recovery
Date: Mon, 18 Jan 2016 12:18:13 +0100
Message-ID: <20160118111813.GI2742@c203.arch.suse.de>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbcARLSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 06:18:16 -0500
Content-Disposition: inline
In-Reply-To: <1452842182-684-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com, David.Carroll@pmcs.com

On Thu, Jan 14, 2016 at 11:16:18PM -0800, Raghava Aditya Renukunta wrot=
e:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> During EEH recovery number of online CPU's might change thereby chang=
ing
> the number of MSIx vectors. Since each fib is allocated to a vector,
> changes in the number of vectors causes fib to be sent thru invalid
> vectors.In addition the correct number of MSIx vectors is not
> updated in the INIT struct sent to the controller, when it is
> reinitialized.
>=20
> Fixed by reassigning vectors to fibs based on the updated number of M=
SIx
> vectors and updating the INIT structure before sending to controller.
>=20
> Changes in V2:
> Replaced fib vector allocation code with aac_fib_vector_assign
>=20
> Changes in V3:
> None
>=20
> Fixes: MSI-X vector calculation for suspend/resume
> Cc: stable@vger.kernel.org
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/aacraid/linit.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 08c6835..6d79181 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1410,8 +1410,18 @@ static int aac_acquire_resources(struct aac_de=
v *dev)
> =20
>  	aac_adapter_enable_int(dev);
> =20
> -	if (!dev->sync_mode)
> +	/*max msix may change  after EEH
> +	 * Re-assign vectors to fibs
> +	 */
> +	aac_fib_vector_assign(dev);
> +
> +	if (!dev->sync_mode) {
> +		/* After EEH recovery or suspend resume, max_msix count
> +		 * may change, therfore updating in init as well.
> +		 */
>  		aac_adapter_start(dev);
> +		dev->init->Sa_MSIXVectors =3D cpu_to_le32(dev->max_msix);
> +	}
>  	return 0;
> =20
>  error_iounmap:
> --=20
> 1.9.1
>=20

Looks good,

Reviewed-by: Johannes Thumshirn <jthushirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
