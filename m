From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/5] scsi_error: do not escalate failed EH command
Date: Thu, 03 Dec 2015 10:15:12 +0100
Message-ID: <1449134112.3311.10.camel@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
	 <1449127063-94512-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbbLCJPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:15:13 -0500
In-Reply-To: <1449127063-94512-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:17 +0100, Hannes Reinecke wrote:
> When a command is sent as part of the error handling there
> is not point whatsoever to start EH escalation when that
> command fails; we are _already_ in the error handler,
> and the escalation is about to commence anyway.
> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
> commands and let the main EH routine handle the rest.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_error.c | 11 +----------
> =C2=A01 file changed, 1 insertion(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index cf47b81..0159498 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -870,15 +870,6 @@ static int scsi_try_to_abort_cmd(struct
> scsi_host_template *hostt,
> =C2=A0	return hostt->eh_abort_handler(scmd);
> =C2=A0}
> =C2=A0
> -static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
> -{
> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) !=3D
> SUCCESS)
> -		if (scsi_try_bus_device_reset(scmd) !=3D SUCCESS)
> -			if (scsi_try_target_reset(scmd) !=3D SUCCESS)
> -				if (scsi_try_bus_reset(scmd) !=3D SUCCESS)
> -					scsi_try_host_reset(scmd);
> -}
> -
> =C2=A0/**
> =C2=A0 * scsi_eh_prep_cmnd=C2=A0=C2=A0- Save a scsi command info as p=
art of error recovery
> =C2=A0 * @scmd:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SCSI command=
 structure to hijack
> @@ -1063,7 +1054,7 @@ retry:
> =C2=A0			break;
> =C2=A0		}
> =C2=A0	} else if (rtn !=3D FAILED) {
> -		scsi_abort_eh_cmnd(scmd);
> +		scsi_try_to_abort_cmd(shost->hostt, scmd);
> =C2=A0		rtn =3D FAILED;
> =C2=A0	}
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
