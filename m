From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] scsi: make eh_eflags persistent
Date: Thu, 03 Dec 2015 10:08:44 +0100
Message-ID: <1449133724.3311.8.camel@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
	 <1449127063-94512-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbbLCJIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:08:45 -0500
In-Reply-To: <1449127063-94512-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:17 +0100, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0Documentation/scsi/scsi_eh.txt | 3 ---
> =C2=A0drivers/scsi/scsi_error.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| =
4 ++--
> =C2=A0include/scsi/scsi_eh.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 1 +
> =C2=A03 files changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi=
_eh.txt
> index 8638f61..745eed5 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -264,7 +264,6 @@ scmd->allowed.
> =C2=A0 3. scmd recovered
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ACTION: scsi_eh_finish_cmd() is invoked=
 to EH-finish scmd
> =C2=A0	- shost->host_failed--
> -	- clear scmd->eh_eflags
> =C2=A0	- scsi_setup_cmd_retry()
> =C2=A0	- move from local eh_work_q to local eh_done_q
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0LOCKING: none
> @@ -452,8 +451,6 @@ except for #1 must be implemented by
> eh_strategy_handler().
> =C2=A0
> =C2=A0 - shost->host_failed is zero.
> =C2=A0
> - - Each scmd's eh_eflags field is cleared.
> -
> =C2=A0 - Each scmd is in such a state that scsi_setup_cmd_retry() on =
the
> =C2=A0=C2=A0=C2=A0=C2=A0scmd doesn't make any difference.
> =C2=A0
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index deb35737..eb0f19f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -182,7 +182,6 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> =C2=A0		/*
> =C2=A0		=C2=A0* Retry after abort failed, escalate to next level.
> =C2=A0		=C2=A0*/
> -		scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
> =C2=A0		SCSI_LOG_ERROR_RECOVERY(3,
> =C2=A0			scmd_printk(KERN_INFO, scmd,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0"previous abort failed\n"));
> @@ -919,6 +918,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, st=
ruct
> scsi_eh_save *ses,
> =C2=A0	ses->result =3D scmd->result;
> =C2=A0	ses->underflow =3D scmd->underflow;
> =C2=A0	ses->prot_op =3D scmd->prot_op;
> +	ses->eh_eflags =3D scmd->eh_eflags;
> =C2=A0
> =C2=A0	scmd->prot_op =3D SCSI_PROT_NORMAL;
> =C2=A0	scmd->eh_eflags =3D 0;
> @@ -982,6 +982,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,=
 struct
> scsi_eh_save *ses)
> =C2=A0	scmd->result =3D ses->result;
> =C2=A0	scmd->underflow =3D ses->underflow;
> =C2=A0	scmd->prot_op =3D ses->prot_op;
> +	scmd->eh_eflags =3D ses->eh_eflags;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(scsi_eh_restore_cmnd);
> =C2=A0
> @@ -1115,7 +1116,6 @@ static int scsi_eh_action(struct scsi_cmnd *scm=
d, int
> rtn)
> =C2=A0void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_hea=
d *done_q)
> =C2=A0{
> =C2=A0	scmd->device->host->host_failed--;
> -	scmd->eh_eflags =3D 0;
> =C2=A0	list_move_tail(&scmd->eh_entry, done_q);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(scsi_eh_finish_cmd);
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index dbb8c64..f2f876c 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -30,6 +30,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, i=
nt
> __user *);
> =C2=A0struct scsi_eh_save {
> =C2=A0	/* saved state */
> =C2=A0	int result;
> +	int eh_eflags;
> =C2=A0	enum dma_data_direction data_direction;
> =C2=A0	unsigned underflow;
> =C2=A0	unsigned char cmd_len;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
