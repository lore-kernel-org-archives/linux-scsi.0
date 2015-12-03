From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/5] scsi: make scsi_eh_scmd_add() always succeed
Date: Thu, 03 Dec 2015 10:07:24 +0100
Message-ID: <1449133644.3311.7.camel@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
	 <1449127063-94512-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbbLCJH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:07:26 -0500
In-Reply-To: <1449127063-94512-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:17 +0100, Hannes Reinecke wrote:
> scsi_eh_scmd_add() currently only will fail if no
> error handler thread is started (which will never be the
> case) or if the state machine encounters an illegal transition.
>=20
> But if we're encountering an invalid state transition
> chances is we cannot fixup things with the error handler.
> So better add a WARN_ON for illegal host states and
> make scsi_dh_scmd_add() a void function.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_error.c | 39 +++++++++++++-------------------=
-------
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A04 ++--
> =C2=A0drivers/scsi/scsi_priv.h=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A03 files changed, 16 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 984ddcb..deb35737 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -162,13 +162,7 @@ scmd_eh_abort_handler(struct work_struct *work)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	if (!scsi_eh_scmd_add(scmd, 0)) {
> -		SCSI_LOG_ERROR_RECOVERY(3,
> -			scmd_printk(KERN_WARNING, scmd,
> -				=C2=A0=C2=A0=C2=A0=C2=A0"terminate aborted command\n"));
> -		set_host_byte(scmd, DID_TIME_OUT);
> -		scsi_finish_command(scmd);
> -	}
> +	scsi_eh_scmd_add(scmd, 0);
> =C2=A0}
> =C2=A0
> =C2=A0/**
> @@ -224,37 +218,32 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> =C2=A0 * scsi_eh_scmd_add - add scsi cmd to error handling.
> =C2=A0 * @scmd:	scmd to run eh on.
> =C2=A0 * @eh_flag:	optional SCSI_EH flag.
> - *
> - * Return value:
> - *	0 on failure.
> =C2=A0 */
> -int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
> +void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
> =C2=A0{
> =C2=A0	struct Scsi_Host *shost =3D scmd->device->host;
> =C2=A0	unsigned long flags;
> -	int ret =3D 0;
> =C2=A0
> -	if (!shost->ehandler)
> -		return 0;
> +	WARN_ON(!shost->ehandler);
> =C2=A0
> =C2=A0	spin_lock_irqsave(shost->host_lock, flags);
> +	WARN_ON(shost->shost_state !=3D SHOST_RUNNING &&
> +		shost->shost_state !=3D SHOST_CANCEL &&
> +		shost->shost_state !=3D SHOST_RECOVERY &&
> +		shost->shost_state !=3D SHOST_CANCEL_RECOVERY);
> =C2=A0	if (scsi_host_set_state(shost, SHOST_RECOVERY))
> -		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
> -			goto out_unlock;
> +		scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
> =C2=A0
> =C2=A0	if (shost->eh_deadline !=3D -1 && !shost->last_reset)
> =C2=A0		shost->last_reset =3D jiffies;
> =C2=A0
> -	ret =3D 1;
> =C2=A0	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
> =C2=A0		eh_flag &=3D ~SCSI_EH_CANCEL_CMD;
> =C2=A0	scmd->eh_eflags |=3D eh_flag;
> =C2=A0	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
> =C2=A0	shost->host_failed++;
> =C2=A0	scsi_eh_wakeup(shost);
> - out_unlock:
> =C2=A0	spin_unlock_irqrestore(shost->host_lock, flags);
> -	return ret;
> =C2=A0}
> =C2=A0
> =C2=A0/**
> @@ -285,13 +274,11 @@ enum blk_eh_timer_return scsi_times_out(struct =
request
> *req)
> =C2=A0		rtn =3D host->hostt->eh_timed_out(scmd);
> =C2=A0
> =C2=A0	if (rtn =3D=3D BLK_EH_NOT_HANDLED) {
> -		if (!host->hostt->no_async_abort &&
> -		=C2=A0=C2=A0=C2=A0=C2=A0scsi_abort_command(scmd) =3D=3D SUCCESS)
> -			return BLK_EH_NOT_HANDLED;
> -
> -		set_host_byte(scmd, DID_TIME_OUT);
> -		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
> -			rtn =3D BLK_EH_HANDLED;
> +		if (host->hostt->no_async_abort ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0scsi_abort_command(scmd) !=3D SUCCESS) {
> +			set_host_byte(scmd, DID_TIME_OUT);
> +			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
> +		}
> =C2=A0	}
> =C2=A0
> =C2=A0	return rtn;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fa6b2c4..2dd7d0a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1647,8 +1647,8 @@ static void scsi_softirq_done(struct request *r=
q)
> =C2=A0			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> =C2=A0			break;
> =C2=A0		default:
> -			if (!scsi_eh_scmd_add(cmd, 0))
> -				scsi_finish_command(cmd);
> +			scsi_eh_scmd_add(cmd, 0);
> +			break;
> =C2=A0	}
> =C2=A0}
> =C2=A0
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 27b4d0a..8c26823 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -71,7 +71,7 @@ extern enum blk_eh_timer_return scsi_times_out(stru=
ct
> request *req);
> =C2=A0extern int scsi_error_handler(void *host);
> =C2=A0extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
> =C2=A0extern void scsi_eh_wakeup(struct Scsi_Host *shost);
> -extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
> +extern void scsi_eh_scmd_add(struct scsi_cmnd *, int);
> =C2=A0void scsi_eh_ready_devs(struct Scsi_Host *shost,
> =C2=A0			struct list_head *work_q,
> =C2=A0			struct list_head *done_q);


Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
