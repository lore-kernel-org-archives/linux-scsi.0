From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] [SCSI] Fix abort state memory problem
Date: Mon, 31 Mar 2014 08:58:38 +0200
Message-ID: <5339121E.50106@suse.de>
References: <1396028874.15365.30.camel@dabdike> <1396028975.15365.31.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaCaG6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:58:39 -0400
In-Reply-To: <1396028975.15365.31.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 03/28/2014 06:49 PM, James Bottomley wrote:
> The abort state is being stored persistently across commands, meaning=
 if the
> command times out a second time, the error handler thinks an abort is=
 still
> pending.  Fix this by properly resetting the abort flag after the abo=
rt is
> finished.
>=20
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> ---
>  drivers/scsi/scsi_error.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..b9f3b07 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -869,10 +869,13 @@ static int scsi_try_bus_device_reset(struct scs=
i_cmnd *scmd)
> =20
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, s=
truct scsi_cmnd *scmd)
>  {
> -	if (!hostt->eh_abort_handler)
> -		return FAILED;
> +	int retval =3D FAILED;
> +
> +	if (hostt->eh_abort_handler)
> +		retval =3D hostt->eh_abort_handler(scmd);
> =20
> -	return hostt->eh_abort_handler(scmd);
> +	scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
> +	return retval;
>  }
> =20
>  static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>=20
Hmm. No, I don't think this is correct.

SCSI_EH_ABORT_SCHEDULED signifies whether scmd_eh_abort_handler()
needs to run. As such it needs to be reset when the workqueue item
is triggered.

Can you try with this instead?

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..9694803 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -120,6 +120,8 @@ scmd_eh_abort_handler(struct work_struct *work)
        struct scsi_device *sdev =3D scmd->device;
        int rtn;

+       scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
+
        if (scsi_host_eh_past_deadline(sdev->host)) {
                SCSI_LOG_ERROR_RECOVERY(3,
                        scmd_printk(KERN_INFO, scmd,


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
