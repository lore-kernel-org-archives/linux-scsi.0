From: Gustavo Guillermo =?utf-8?q?P=C3=A9rez?= <gustavo@compunauta.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels 2.6.X
Date: Thu, 27 Apr 2006 12:40:35 -0500
Message-ID: <200604271240.35274.gustavo@compunauta.com>
References: <200604241029.14932.gustavo@compunauta.com> <200604251641.54084.gustavo@compunauta.com> <1146001711.3529.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compunauta.com ([69.36.170.169]:55220 "EHLO compunauta.com")
	by vger.kernel.org with ESMTP id S965163AbWD0Rkt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 13:40:49 -0400
In-Reply-To: <1146001711.3529.58.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

El Martes, 25 de Abril de 2006 16:48, James Bottomley escribi=C3=B3:
> OK ... My best guess has to be that this device accepted and complete=
d
> the command but is still processing it on the medium, hence the retur=
n.
> Try the attached; I think it makes for these cases.  I could be
> persuaded to drop format and reconstruction in progress, because thos=
e
> can be *very* long operations.
I was having power source failures on my neighborhood, and I was not ha=
ving=20
time to test it, today the Company was replaced the transformer and I c=
ant=20
test it now.

Let me see, the patch of course does not apply, but I can figure out ho=
w to=20
proceed on kernel 2.6.16.

But guess who, not Device busy as error, of course and NO BAD SECTORS W=
ith=20
pktcdvd UDF.

:)

Txs, do you think this modification I can use without care on Sata o ot=
her=20
devices going trow SCSI?, cause I be wonder if this could be into main =
kernel=20
line.

Regards!!!!

> James
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7b0f9a3..764a8b3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1067,16 +1067,29 @@ void scsi_io_completion(struct scsi_cmnd
>  			break;
>  		case NOT_READY:
>  			/*
> -			 * If the device is in the process of becoming ready,
> -			 * retry.
> +			 * If the device is in the process of becoming
> +			 * ready, or has a temporary blockage, retry.
>  			 */
> -			if (sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x01) {
> -				scsi_requeue_command(q, cmd);
> -				return;
> +			if (sshdr.asc =3D=3D 0x04) {
> +				switch (sshdr.ascq) {
> +				case 0x01: /* becoming ready */
> +				case 0x04: /* format in progress */
> +				case 0x05: /* rebuild in progress */
> +				case 0x06: /* recalculation in progress */
> +				case 0x07: /* operation in progress */
> +				case 0x08: /* Long write in progress */
> +				case 0x09: /* self test in progress */
> +					scsi_requeue_command(q, cmd);
> +					return;
> +				default:
> +					break;
> +				}
>  			}
> -			if (!(req->flags & REQ_QUIET))
> +			if (!(req->flags & REQ_QUIET)) {
>  				scmd_printk(KERN_INFO, cmd,
> -					   "Device not ready.\n");
> +					   "Device not ready: ");
> +				scsi_print_sense_hdr("", &sshdr);
> +			}
>  			scsi_end_request(cmd, 0, this_count, 1);
>  			return;
>  		case VOLUME_OVERFLOW:

--=20
Gustavo Guillermo P=C3=A9rez
Compunauta uLinux
www.compunauta.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
