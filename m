From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Thu, 6 Jun 2013 12:23:20 -0400
Message-ID: <20130606162320.GC16616@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <1370511835-50072-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59415 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3FFRwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 13:52:31 -0400
Content-Disposition: inline
In-Reply-To: <1370511835-50072-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, 6 June 2013 11:43:54 +0200, Hannes Reinecke wrote:
>=20
> When a command runs into a timeout we need to send an 'ABORT TASK'
> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
>=20
> Conceptually, however, this function is a normal SCSI command, so
> there is no need to enter the error handler.
>=20
> This patch implements a new scsi_abort_command() function which
> invokes an asynchronous function scsi_eh_abort_handler() to
> abort the commands via 'eh_abort_handler'.
>=20
> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
> command will be retried if possible. If no retries are allowed
> the command will be returned immediately, as we have to assume
> the TMF succeeded and the command is completed with the LLDD.
> For any other return code from 'eh_abort_handler' the command
> will be pushed onto the existing SCSI EH handler, or aborted
> with DID_TIME_OUT if that fails.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c        | 79 ++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/scsi_scan.c         |  3 ++
>  drivers/scsi/scsi_transport_fc.c |  3 +-
>  include/scsi/scsi_cmnd.h         |  1 +
>  include/scsi/scsi_device.h       |  2 +
>  5 files changed, 87 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 96b4bb6..0a6b21c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -55,6 +55,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd);
>  #define HOST_RESET_SETTLE_TIME  (10)
> =20
>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
> +static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
> +				 struct scsi_cmnd *scmd);
> =20
>  /* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
> @@ -90,6 +92,83 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>  EXPORT_SYMBOL_GPL(scsi_schedule_eh);
> =20
>  /**
> + * scsi_eh_abort_handler - Handle command aborts
> + * @work:	sdev on which commands should be aborted.
> + */
> +void
> +scsi_eh_abort_handler(struct work_struct *work)
> +{
> +	struct scsi_device *sdev =3D
> +		container_of(work, struct scsi_device, abort_work);
> +	struct Scsi_Host *shost =3D sdev->host;
> +	struct scsi_cmnd *scmd, *tmp;
> +	unsigned long flags;
> +	int rtn;
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	list_for_each_entry_safe(scmd, tmp, &sdev->eh_abort_list, eh_entry)=
 {
> +		list_del_init(&scmd->eh_entry);

The _init bit is not needed.  I prefer list_del, as the poisoning
sometimes helps catching bugs.

> +		spin_unlock_irqrestore(&sdev->list_lock, flags);
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "aborting command %p\n", scmd));
> +		rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
> +		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL) {
> +			if (((scmd->request->cmd_flags & REQ_FAILFAST_DEV) ||

Am I being stupid again or should this be negated?

> +			     (scmd->request->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)) &&
> +			    (++scmd->retries <=3D scmd->allowed)) {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "retry aborted command\n"));
> +
> +				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> +			} else {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "fast fail aborted command\n"));
> +				scmd->result |=3D DID_TRANSPORT_FAILFAST << 16;
> +				scsi_finish_command(scmd);
> +			}
> +		} else {
> +			if (!scsi_eh_scmd_add(scmd, 0)) {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "terminate aborted command\n"));
> +				scmd->result |=3D DID_TIME_OUT << 16;
> +				scsi_finish_command(scmd);
> +			}
> +		}
> +		spin_lock_irqsave(&sdev->list_lock, flags);
> +	}
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +}
> +
> +/**
> + * scsi_abort_command - schedule a command abort
> + * @scmd:	scmd to abort.
> + *
> + * We only need to abort commands after a command timeout
> + */
> +void
> +scsi_abort_command(struct scsi_cmnd *scmd)
> +{
> +	unsigned long flags;
> +	int kick_worker =3D 0;
> +	struct scsi_device *sdev =3D scmd->device;
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	if (list_empty(&sdev->eh_abort_list))
> +		kick_worker =3D 1;
> +	list_add(&scmd->eh_entry, &sdev->eh_abort_list);
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		scmd_printk(KERN_INFO, scmd, "adding to eh_abort_list\n"));

The printk can be moved outside the spinlock.  Who knows, maybe this
will become a scalability bottleneck before the millenium is over.

> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	if (kick_worker)
> +		schedule_work(&sdev->abort_work);
> +}
> +EXPORT_SYMBOL_GPL(scsi_abort_command);
> +
> +/**
>   * scsi_eh_scmd_add - add scsi cmd to error handling.
>   * @scmd:	scmd to run eh on.
>   * @eh_flag:	optional SCSI_EH flag.
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..f9cc6fc 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struct=
 scsi_target *starget,
>  	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
>  	extern void scsi_evt_thread(struct work_struct *work);
>  	extern void scsi_requeue_run_queue(struct work_struct *work);
> +	extern void scsi_eh_abort_handler(struct work_struct *work);

=46unction declarations in a .c file?  Ick!

> =20
>  	sdev =3D kzalloc(sizeof(*sdev) + shost->transportt->device_size,
>  		       GFP_ATOMIC);
> @@ -251,9 +252,11 @@ static struct scsi_device *scsi_alloc_sdev(struc=
t scsi_target *starget,
>  	INIT_LIST_HEAD(&sdev->cmd_list);
>  	INIT_LIST_HEAD(&sdev->starved_entry);
>  	INIT_LIST_HEAD(&sdev->event_list);
> +	INIT_LIST_HEAD(&sdev->eh_abort_list);
>  	spin_lock_init(&sdev->list_lock);
>  	INIT_WORK(&sdev->event_work, scsi_evt_thread);
>  	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
> +	INIT_WORK(&sdev->abort_work, scsi_eh_abort_handler);
> =20
>  	sdev->sdev_gendev.parent =3D get_device(&starget->dev);
>  	sdev->sdev_target =3D starget;
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index e106c27..09237bf 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2079,7 +2079,8 @@ fc_timed_out(struct scsi_cmnd *scmd)
>  	if (rport->port_state =3D=3D FC_PORTSTATE_BLOCKED)
>  		return BLK_EH_RESET_TIMER;
> =20
> -	return BLK_EH_NOT_HANDLED;
> +	scsi_abort_command(scmd);
> +	return BLK_EH_SCHEDULED;
>  }
> =20
>  /*
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index de5f5d8..460e514 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -144,6 +144,7 @@ extern void scsi_put_command(struct scsi_cmnd *);
>  extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd =
*,
>  			       struct device *);
>  extern void scsi_finish_command(struct scsi_cmnd *cmd);
> +extern void scsi_abort_command(struct scsi_cmnd *cmd);
> =20
>  extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_coun=
t,
>  				 size_t *offset, size_t *len);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index cc64587..e03d379 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -80,6 +80,7 @@ struct scsi_device {
>  	spinlock_t list_lock;
>  	struct list_head cmd_list;	/* queue of in use SCSI Command structur=
es */
>  	struct list_head starved_entry;
> +	struct list_head eh_abort_list;
>  	struct scsi_cmnd *current_cmnd;	/* currently active command */
>  	unsigned short queue_depth;	/* How deep of a queue we want */
>  	unsigned short max_queue_depth;	/* max queue depth */
> @@ -180,6 +181,7 @@ struct scsi_device {
> =20
>  	struct execute_work	ew; /* used to get process context on put */
>  	struct work_struct	requeue_work;
> +	struct work_struct	abort_work;
> =20
>  	struct scsi_dh_data	*scsi_dh_data;
>  	enum scsi_device_state sdev_state;
> --=20
> 1.7.12.4
>=20

J=C3=B6rn

--
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
