From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH  V2 1/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Tue, 23 Apr 2013 16:52:57 +0200
Message-ID: <5176A049.3090407@suse.de>
References: <20130416202625.962009312@linux.vnet.ibm.com> <20130416203310.517593092@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab3DWOw7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Apr 2013 10:52:59 -0400
In-Reply-To: <20130416203310.517593092@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On 04/16/2013 10:26 PM, wenxiong@linux.vnet.ibm.com wrote:
> We discussed James's concern. We intergated James's patch and generat=
ed
> this updated patch.
>=20
> Fix scsi_send_eh_cmnd to check the return code of queuecommand when
> sending commands and retry for a bit if the LLDD returns a busy respo=
nse.
> This fixes an issue seen with the ipr driver where an ipr initiated r=
eset
> immediately following an eh_host_reset caused EH initiated commands t=
o fail,
> resulting in devices being taken offline. This patch resolves the iss=
ue.
>=20
>=20
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_error.c |   34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
>=20
> Index: b/drivers/scsi/scsi_error.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/scsi/scsi_error.c	2013-04-16 12:56:16.617857960 -0500
> +++ b/drivers/scsi/scsi_error.c	2013-04-16 12:57:00.279108838 -0500
> @@ -791,18 +791,21 @@ static int scsi_send_eh_cmnd(struct scsi
>  	struct scsi_device *sdev =3D scmd->device;
>  	struct Scsi_Host *shost =3D sdev->host;
>  	DECLARE_COMPLETION_ONSTACK(done);
> -	unsigned long timeleft;
> +	unsigned long timeleft =3D timeout;
>  	struct scsi_eh_save ses;
> +	const int stall_for =3D min(HZ/10, 1);
>  	int rtn;
> =20
>  	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
> +retry:
>  	shost->eh_action =3D &done;
> =20
>  	scsi_log_send(scmd);
>  	scmd->scsi_done =3D scsi_eh_done;
> -	shost->hostt->queuecommand(shost, scmd);
> +	rtn =3D shost->hostt->queuecommand(shost, scmd);
> =20
> -	timeleft =3D wait_for_completion_timeout(&done, timeout);
> +	if (!rtn)
> +		timeleft =3D wait_for_completion_timeout(&done, timeout);
> =20
>  	shost->eh_action =3D NULL;
> =20
Hmm. This seems to be a generic bug fix here; it is perfectly
ok for queuecommand() to return a non-zero value without calling
->scsi_done. At which point ->complete is pointless to try as no
completion ever would be invoked.

Mind separating that out as a separate patch?

> @@ -819,10 +822,19 @@ static int scsi_send_eh_cmnd(struct scsi
>  	 * about this command.
>  	 */
>  	if (timeleft) {
> -		rtn =3D scsi_eh_completed_normally(scmd);
> -		SCSI_LOG_ERROR_RECOVERY(3,
> -			printk("%s: scsi_eh_completed_normally %x\n",
> -			       __func__, rtn));
> +		switch (rtn) {
> +		case 0:
> +			rtn =3D scsi_eh_completed_normally(scmd);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				printk("%s: scsi_eh_completed_normally %x\n",
> +				       __func__, rtn));
> +			break;
> +		case FAILED:
> +			break;
> +		default:
> +			rtn =3D ADD_TO_MLQUEUE;
> +			break;
> +		}
> =20
>  		switch (rtn) {
>  		case SUCCESS:
Bzzt.
'FAILED' is a valid response for scsi_eh_completed_normally, but not
for ->queuecommand.

> @@ -831,8 +843,12 @@ static int scsi_send_eh_cmnd(struct scsi
>  		case TARGET_ERROR:
>  			break;
>  		case ADD_TO_MLQUEUE:
> -			rtn =3D NEEDS_RETRY;
> -			break;
> +			if (timeleft > stall_for) {
> +				timeout =3D timeleft - stall_for;
> +				msleep(stall_for);
> +				goto retry;
> +			}
> +			/* fall through */
>  		default:
>  			rtn =3D FAILED;
>  			break;
>=20
We're already calling 'wait_for_completion_timeout'.
So normally the 'msleep' wouldn't be necessary.
It's only required for the case when ->queuecommand
returns non-zero.
So I'd rather see to have the msleep into section
where the return command from queuecommand is evaluated;
here we'll actually decrease responsiveness as
we're always waiting for X seconds, even if the command
would've been completed during that time.

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
