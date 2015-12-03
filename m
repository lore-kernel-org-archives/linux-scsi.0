From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] scsi: make asynchronous aborts mandatory
Date: Thu, 03 Dec 2015 10:13:25 +0100
Message-ID: <1449134005.3311.9.camel@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
	 <1449127063-94512-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644AbbLCJN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:13:27 -0500
In-Reply-To: <1449127063-94512-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:17 +0100, Hannes Reinecke wrote:
> There hasn't been any reports for HBAs where asynchronous abort
> would not work, so we should make it mandatory and remove
> the fallback.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0Documentation/scsi/scsi_eh.txt | 28 +++++++--------
> =C2=A0drivers/scsi/scsi_error.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| =
81 ++++----------------------------------
> ----
> =C2=A0drivers/scsi/scsi_lib.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/scsi_priv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A03 +-
> =C2=A0include/scsi/scsi_host.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A05 ---
> =C2=A05 files changed, 22 insertions(+), 97 deletions(-)
>=20
> diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi=
_eh.txt
> index 745eed5..6e07245fb 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -70,7 +70,7 @@ with the command.
> =C2=A0	scmd is requeued to blk queue.
> =C2=A0
> =C2=A0 - otherwise
> -	scsi_eh_scmd_add(scmd, 0) is invoked for the command.=C2=A0=C2=A0Se=
e
> +	scsi_eh_scmd_add(scmd) is invoked for the command.=C2=A0=C2=A0See
> =C2=A0	[1-3] for details of this function.
> =C2=A0
> =C2=A0
> @@ -103,13 +103,15 @@ function
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0eh_timed_out() =
callback did not handle the command.
> =C2=A0	Step #2 is taken.
> =C2=A0
> - 2. If the host supports asynchronous completion (as indicated by th=
e
> -=C2=A0=C2=A0=C2=A0=C2=A0no_async_abort setting in the host template)=
 scsi_abort_command()
> -=C2=A0=C2=A0=C2=A0=C2=A0is invoked to schedule an asynchrous abort. =
If that fails
> -=C2=A0=C2=A0=C2=A0=C2=A0Step #3 is taken.
> + 2. scsi_abort_command() is invoked to schedule an asynchrous abort
> +=C2=A0=C2=A0=C2=A0=C2=A0(Seee [1-3] for more information).
> +=C2=A0=C2=A0=C2=A0=C2=A0Asynchronous abort are not invoked for comma=
nds which have
> +=C2=A0=C2=A0=C2=A0=C2=A0SCSI_EH_ABORT_SCHEDULED set (this indicates =
that the command
> +=C2=A0=C2=A0=C2=A0=C2=A0already had been aborted once, and this is a=
 retry which failed),
> +=C2=A0=C2=A0=C2=A0=C2=A0or when the EH deadline is expired. In these=
 case Step #3 is taken.
> =C2=A0
> - 2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
> -=C2=A0=C2=A0=C2=A0=C2=A0command.=C2=A0=C2=A0See [1-3] for more infor=
mation.
> + 3. scsi_eh_scmd_add(scmd) is invoked for the
> +=C2=A0=C2=A0=C2=A0=C2=A0command.=C2=A0=C2=A0See [1-4] for more infor=
mation.
> =C2=A0
> =C2=A0[1-3] Asynchronous command aborts
> =C2=A0
> @@ -124,16 +126,13 @@ function
> =C2=A0
> =C2=A0 scmds enter EH via scsi_eh_scmd_add(), which does the followin=
g.
> =C2=A0
> - 1. Turns on scmd->eh_eflags as requested.=C2=A0=C2=A0It's 0 for err=
or
> -=C2=A0=C2=A0=C2=A0=C2=A0completions and SCSI_EH_CANCEL_CMD for timeo=
uts.
> + 1. Links scmd->eh_entry to shost->eh_cmd_q
> =C2=A0
> - 2. Links scmd->eh_entry to shost->eh_cmd_q
> + 2. Sets SHOST_RECOVERY bit in shost->shost_state
> =C2=A0
> - 3. Sets SHOST_RECOVERY bit in shost->shost_state
> + 3. Increments shost->host_failed
> =C2=A0
> - 4. Increments shost->host_failed
> -
> - 5. Wakes up SCSI EH thread if shost->host_busy =3D=3D shost->host_f=
ailed
> + 4. Wakes up SCSI EH thread if shost->host_busy =3D=3D shost->host_f=
ailed
> =C2=A0
> =C2=A0 As can be seen above, once any scmd is added to shost->eh_cmd_=
q,
> =C2=A0SHOST_RECOVERY shost_state bit is turned on.=C2=A0=C2=A0This pr=
events any new
> @@ -249,7 +248,6 @@ scmd->allowed.
> =C2=A0
> =C2=A0 1. Error completion / time out
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ACTION: scsi_eh_scmd_add() is invoked f=
or scmd
> -	- set scmd->eh_eflags
> =C2=A0	- add scmd to shost->eh_cmd_q
> =C2=A0	- set SHOST_RECOVERY
> =C2=A0	- shost->host_failed++
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index eb0f19f..cf47b81 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -162,7 +162,7 @@ scmd_eh_abort_handler(struct work_struct *work)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	scsi_eh_scmd_add(scmd, 0);
> +	scsi_eh_scmd_add(scmd);
> =C2=A0}
> =C2=A0
> =C2=A0/**
> @@ -216,9 +216,8 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> =C2=A0/**
> =C2=A0 * scsi_eh_scmd_add - add scsi cmd to error handling.
> =C2=A0 * @scmd:	scmd to run eh on.
> - * @eh_flag:	optional SCSI_EH flag.
> =C2=A0 */
> -void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
> +void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
> =C2=A0{
> =C2=A0	struct Scsi_Host *shost =3D scmd->device->host;
> =C2=A0	unsigned long flags;
> @@ -236,9 +235,6 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd, int
> eh_flag)
> =C2=A0	if (shost->eh_deadline !=3D -1 && !shost->last_reset)
> =C2=A0		shost->last_reset =3D jiffies;
> =C2=A0
> -	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
> -		eh_flag &=3D ~SCSI_EH_CANCEL_CMD;
> -	scmd->eh_eflags |=3D eh_flag;
> =C2=A0	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
> =C2=A0	shost->host_failed++;
> =C2=A0	scsi_eh_wakeup(shost);
> @@ -273,10 +269,9 @@ enum blk_eh_timer_return scsi_times_out(struct r=
equest
> *req)
> =C2=A0		rtn =3D host->hostt->eh_timed_out(scmd);
> =C2=A0
> =C2=A0	if (rtn =3D=3D BLK_EH_NOT_HANDLED) {
> -		if (host->hostt->no_async_abort ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0scsi_abort_command(scmd) !=3D SUCCESS) {
> +		if (scsi_abort_command(scmd) !=3D SUCCESS) {
> =C2=A0			set_host_byte(scmd, DID_TIME_OUT);
> -			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
> +			scsi_eh_scmd_add(scmd);
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> @@ -329,7 +324,7 @@ static inline void scsi_eh_prt_fail_stats(struct
> Scsi_Host *shost,
> =C2=A0		list_for_each_entry(scmd, work_q, eh_entry) {
> =C2=A0			if (scmd->device =3D=3D sdev) {
> =C2=A0				++total_failures;
> -				if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD)
> +				if (scmd->eh_eflags &
> SCSI_EH_ABORT_SCHEDULED)
> =C2=A0					++cmd_cancel;
> =C2=A0				else
> =C2=A0					++cmd_failed;
> @@ -1152,8 +1147,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
> =C2=A0	=C2=A0* should not get sense.
> =C2=A0	=C2=A0*/
> =C2=A0	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> -		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0(scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED=
) ||
> +		if ((scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0SCSI_SENSE_VALID(scmd))
> =C2=A0			continue;
> =C2=A0
> @@ -1293,61 +1287,6 @@ static int scsi_eh_test_devices(struct list_he=
ad
> *cmd_list,
> =C2=A0	return list_empty(work_q);
> =C2=A0}
> =C2=A0
> -
> -/**
> - * scsi_eh_abort_cmds - abort pending commands.
> - * @work_q:	&list_head for pending commands.
> - * @done_q:	&list_head for processed commands.
> - *
> - * Decription:
> - *=C2=A0=C2=A0=C2=A0=C2=A0Try and see whether or not it makes sense =
to try and abort the
> - *=C2=A0=C2=A0=C2=A0=C2=A0running command.=C2=A0=C2=A0This only work=
s out to be the case if we have one
> - *=C2=A0=C2=A0=C2=A0=C2=A0command that has timed out.=C2=A0=C2=A0If =
the command simply failed, it makes
> - *=C2=A0=C2=A0=C2=A0=C2=A0no sense to try and abort the command, sin=
ce as far as the shost
> - *=C2=A0=C2=A0=C2=A0=C2=A0adapter is concerned, it isn't running.
> - */
> -static int scsi_eh_abort_cmds(struct list_head *work_q,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head *done_q)
> -{
> -	struct scsi_cmnd *scmd, *next;
> -	LIST_HEAD(check_list);
> -	int rtn;
> -	struct Scsi_Host *shost;
> -
> -	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> -		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
> -			continue;
> -		shost =3D scmd->device->host;
> -		if (scsi_host_eh_past_deadline(shost)) {
> -			list_splice_init(&check_list, work_q);
> -			SCSI_LOG_ERROR_RECOVERY(3,
> -				scmd_printk(KERN_INFO, scmd,
> -					=C2=A0=C2=A0=C2=A0=C2=A0"%s: skip aborting cmd, past eh
> deadline\n",
> -					=C2=A0=C2=A0=C2=A0=C2=A0current->comm));
> -			return list_empty(work_q);
> -		}
> -		SCSI_LOG_ERROR_RECOVERY(3,
> -			scmd_printk(KERN_INFO, scmd,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"%s: aborting cmd\n", current->com=
m));
> -		rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
> -		if (rtn =3D=3D FAILED) {
> -			SCSI_LOG_ERROR_RECOVERY(3,
> -				scmd_printk(KERN_INFO, scmd,
> -					=C2=A0=C2=A0=C2=A0=C2=A0"%s: aborting cmd failed\n",
> -					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0current->comm));
> -			list_splice_init(&check_list, work_q);
> -			return list_empty(work_q);
> -		}
> -		scmd->eh_eflags &=3D ~SCSI_EH_CANCEL_CMD;
> -		if (rtn =3D=3D FAST_IO_FAIL)
> -			scsi_eh_finish_cmd(scmd, done_q);
> -		else
> -			list_move_tail(&scmd->eh_entry, &check_list);
> -	}
> -
> -	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
> -}
> -
> =C2=A0/**
> =C2=A0 * scsi_eh_try_stu - Send START_UNIT to device.
> =C2=A0 * @scmd:	&scsi_cmnd to send START_UNIT
> @@ -1690,11 +1629,6 @@ static void scsi_eh_offline_sdevs(struct list_=
head
> *work_q,
> =C2=A0		sdev_printk(KERN_INFO, scmd->device, "Device offlined - "
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"not ready after error recovery\n");
> =C2=A0		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
> -		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
> -			/*
> -			=C2=A0* FIXME: Handle lost cmds.
> -			=C2=A0*/
> -		}
> =C2=A0		scsi_eh_finish_cmd(scmd, done_q);
> =C2=A0	}
> =C2=A0	return;
> @@ -2138,8 +2072,7 @@ static void scsi_unjam_host(struct Scsi_Host *s=
host)
> =C2=A0	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost,
> &eh_work_q));
> =C2=A0
> =C2=A0	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
> -		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
> -			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
> +		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
> =C2=A0
> =C2=A0	spin_lock_irqsave(shost->host_lock, flags);
> =C2=A0	if (shost->eh_deadline !=3D -1)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2dd7d0a..616e074 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1647,7 +1647,7 @@ static void scsi_softirq_done(struct request *r=
q)
> =C2=A0			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> =C2=A0			break;
> =C2=A0		default:
> -			scsi_eh_scmd_add(cmd, 0);
> +			scsi_eh_scmd_add(cmd);
> =C2=A0			break;
> =C2=A0	}
> =C2=A0}
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 8c26823..5534825 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -18,7 +18,6 @@ struct scsi_nl_hdr;
> =C2=A0/*
> =C2=A0 * Scsi Error Handler Flags
> =C2=A0 */
> -#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
> =C2=A0#define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been
> scheduled */
> =C2=A0
> =C2=A0#define SCSI_SENSE_VALID(scmd) \
> @@ -71,7 +70,7 @@ extern enum blk_eh_timer_return scsi_times_out(stru=
ct
> request *req);
> =C2=A0extern int scsi_error_handler(void *host);
> =C2=A0extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
> =C2=A0extern void scsi_eh_wakeup(struct Scsi_Host *shost);
> -extern void scsi_eh_scmd_add(struct scsi_cmnd *, int);
> +extern void scsi_eh_scmd_add(struct scsi_cmnd *);
> =C2=A0void scsi_eh_ready_devs(struct Scsi_Host *shost,
> =C2=A0			struct list_head *work_q,
> =C2=A0			struct list_head *done_q);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index ed52712..ef7fff6 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -444,11 +444,6 @@ struct scsi_host_template {
> =C2=A0	unsigned no_write_same:1;
> =C2=A0
> =C2=A0	/*
> -	=C2=A0* True if asynchronous aborts are not supported
> -	=C2=A0*/
> -	unsigned no_async_abort:1;
> -
> -	/*
> =C2=A0	=C2=A0* Countdown for host blocking with no commands outstandi=
ng.
> =C2=A0	=C2=A0*/
> =C2=A0	unsigned int max_host_blocked;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
