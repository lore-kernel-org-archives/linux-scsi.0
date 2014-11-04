From: Hannes Reinecke <hare@suse.de>
Subject: Re: [ V2 PATCH 1/2] scsi: call device handler for failed TUR command
Date: Tue, 04 Nov 2014 08:33:42 +0100
Message-ID: <54588156.3070703@suse.de>
References: <20141103212857.791977005@linux.vnet.ibm.com> <20141103212948.123730327@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKDHdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 02:33:44 -0500
In-Reply-To: <20141103212948.123730327@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On 11/03/2014 10:28 PM, wenxiong@linux.vnet.ibm.com wrote:
> Multipath devices using the TUR path checker need to see the sense
> code for a failed TUR command in their device handler.  Since commit
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/
> drivers/scsi/scsi_error.c?id=3D14216561e164671ce147458653b1fea06a
> we always return success for mid layer issued TUR commands before
> calling the device handler, which stopped the TUR path checker from w=
orking.
>=20
> Move the call to the device handler check sense method before the ear=
ly
> return for TUR commands to give the device handler a chance to interc=
ept
> them.
>=20
> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_error.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> Index: b/drivers/scsi/scsi_error.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/scsi/scsi_error.c	2014-10-23 12:54:16.000000000 -0500
> +++ b/drivers/scsi/scsi_error.c	2014-10-23 12:57:44.642078988 -0500
> @@ -459,14 +459,6 @@ static int scsi_check_sense(struct scsi_
>  	if (! scsi_command_normalize_sense(scmd, &sshdr))
>  		return FAILED;	/* no valid sense data */
> =20
> -	if (scmd->cmnd[0] =3D=3D TEST_UNIT_READY && scmd->scsi_done !=3D sc=
si_eh_done)
> -		/*
> -		 * nasty: for mid-layer issued TURs, we need to return the
> -		 * actual sense data without any recovery attempt.  For eh
> -		 * issued ones, we need to try to recover and interpret
> -		 */
> -		return SUCCESS;
> -
>  	scsi_report_sense(sdev, &sshdr);
> =20
>  	if (scsi_sense_is_deferred(&sshdr))
> @@ -482,6 +474,14 @@ static int scsi_check_sense(struct scsi_
>  		/* handler does not care. Drop down to default handling */
>  	}
> =20
> +	if (scmd->cmnd[0] =3D=3D TEST_UNIT_READY && scmd->scsi_done !=3D sc=
si_eh_done)
> +		/*
> +		 * nasty: for mid-layer issued TURs, we need to return the
> +		 * actual sense data without any recovery attempt.  For eh
> +		 * issued ones, we need to try to recover and interpret
> +		 */
> +		return SUCCESS;
> +
>  	/*
>  	 * Previous logic looked for FILEMARK, EOM or ILI which are
>  	 * mainly associated with tapes and returned SUCCESS.
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
