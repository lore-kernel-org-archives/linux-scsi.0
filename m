From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 22/35] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Date: Fri, 23 Jun 2017 16:32:05 +0000
Message-ID: <1498235523.2735.2.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9390 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbdFWQdm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 12:33:42 -0400
In-Reply-To: <1498222975-71858-23-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <A47138AC6732824896E5EF6273838535@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 227dd2c..187bfaf 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -507,7 +507,7 @@
>  static int eata2x_release(struct Scsi_Host *);
>  static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>  static int eata2x_eh_abort(struct scsi_cmnd *);
> -static int eata2x_eh_host_reset(struct scsi_cmnd *);
> +static int eata2x_eh_host_reset(struct Scsi_Host *);
>  static int eata2x_bios_param(struct scsi_device *, struct block_device *=
,
>  			     sector_t, int *);
>  static int eata2x_slave_configure(struct scsi_device *);
> @@ -1896,21 +1896,16 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCar=
g)
>  	panic("%s: abort, mbox %d, invalid cp_stat.\n", ha->board_name, i);
>  }
> =20
> -static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
> +static int eata2x_eh_host_reset(struct Scsi_Host *shost)
>  {
>  	unsigned int i, time, k, c, limit =3D 0;
> -	int arg_done =3D 0;
>  	struct scsi_cmnd *SCpnt;
> -	struct Scsi_Host *shost =3D SCarg->device->host;
>  	struct hostdata *ha =3D (struct hostdata *)shost->hostdata;
> =20
> -	scmd_printk(KERN_INFO, SCarg, "reset, enter.\n");
> +	shost_printk(KERN_INFO, shost, "reset, enter.\n");
> =20
>  	spin_lock_irq(shost->host_lock);
> =20
> -	if (SCarg->host_scribble =3D=3D NULL)
> -		printk("%s: reset, inactive.\n", ha->board_name);
> -
>  	if (ha->in_reset) {
>  		printk("%s: reset, exit, already in reset.\n", ha->board_name);
>  		spin_unlock_irq(shost->host_lock);
> @@ -1967,9 +1962,6 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *S=
Carg)
>  		if (SCpnt->scsi_done =3D=3D NULL)
>  			panic("%s: reset, mbox %d, SCpnt->scsi_done =3D=3D NULL.\n",
>  			      ha->board_name, i);
> -
> -		if (SCpnt =3D=3D SCarg)
> -			arg_done =3D 1;
>  	}
> =20
>  	if (do_dma(shost->io_port, 0, RESET_PIO)) {

Please isolate the "arg_done" removal into a separate patch.

> @@ -865,23 +858,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>  	if (!ha->active)
>  		return (FAILED);
> =20
> -	/* See if the command is on the copp queue */
> -	item =3D ha->copp_waitlist.head;
> -	while ((item) && (item->scsi_cmd !=3D SC))
> -		item =3D item->next;
> -
> -	if (item) {
> -		/* Found it */
> -		ips_removeq_copp(&ha->copp_waitlist, item);
> -		return (SUCCESS);
> -	}
> -
> -	/* See if the command is on the wait queue */
> -	if (ips_removeq_wait(&ha->scb_waitlist, SC)) {
> -		/* command not sent yet */
> -		return (SUCCESS);
> -	}
> -
>  	/* An explanation for the casual observer:                             =
 */
>  	/* Part of the function of a RAID controller is automatic error        =
 */
>  	/* detection and recovery.  As such, the only problem that physically  =
 */

Shouldn't this change be isolated into a separate patch too?

> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 3c63c29..906570a 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1887,13 +1887,13 @@ static DEF_SCSI_QCMD(megaraid_queue)
> =20
> =20
>  static int
> -megaraid_reset(struct scsi_cmnd *cmd)
> +megaraid_reset(struct Scsi_Host *shost)
>  {
>  	adapter_t	*adapter;
>  	megacmd_t	mc;
>  	int		rval;
> =20
> -	adapter =3D (adapter_t *)cmd->device->host->hostdata;
> +	adapter =3D (adapter_t *)shost->hostdata;
> =20
>  #if MEGA_HAVE_CLUSTERING
>  	mc.cmd =3D MEGA_CLUSTER_CMD;
> @@ -1909,7 +1909,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
> =20
>  	spin_lock_irq(&adapter->lock);
> =20
> -	rval =3D  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
> +	rval =3D  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
> =20
>  	/*
>  	 * This is required here to complete any completed requests
> @@ -1948,7 +1948,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
> =20
>  		scb =3D list_entry(pos, scb_t, list);
> =20
> -		if (scb->cmd =3D=3D cmd) { /* Found command */
> +		if (!cmd || scb->cmd =3D=3D cmd) { /* Found command */
> =20
>  			scb->state |=3D aor;
> =20
> @@ -1977,7 +1977,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
>  					"%s-[%x], driver owner\n",
>  					(aor=3D=3DSCB_ABORT) ? "ABORTING":"RESET",
>  					scb->idx);
> -
> +				cmd =3D scb->cmd;
>  				mega_free_scb(adapter, scb);

This looks weird. Assigning scb->cmd to cmd will cause megaraid_abort_and_r=
eset()
to abort or reset the first command on pending_list if the cmd argument is =
NULL.
If the cmd argument is NULL, shouldn't all commands on pending_list be abor=
ted or
reset?

> -static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
> +static int megasas_reset_bus_host(struct Scsi_Host *shost)
>  {
>  	int ret;
>  	struct megasas_instance *instance;
> =20
> -	instance =3D (struct megasas_instance *)scmd->device->host->hostdata;
> +	instance =3D (struct megasas_instance *)shost->hostdata;
> =20
> -	scmd_printk(KERN_INFO, scmd,
> +	shost_printk(KERN_INFO, shost,
>  		"Controller reset is requested due to IO timeout\n"
> -		"SCSI command pointer: (%p)\t SCSI host state: %d\t"
> +		"SCSI host state: %d\t"
>  		" SCSI host busy: %d\t FW outstanding: %d\n",
> -		scmd, scmd->device->host->shost_state,
> -		atomic_read((atomic_t *)&scmd->device->host->host_busy),
> +		shost->shost_state,
> +		atomic_read((atomic_t *)&shost->host_busy),
>  		atomic_read(&instance->fw_outstanding));

Since host_busy already has type atomic_t and since you have to touch this
code anyway, how about leaving out the (atomic_t *) cast?

> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1047,13 +1047,28 @@ static void qla1280_mailbox_timeout(unsigned long=
 __data)
>   *     Reset the specified adapter (both channels)
>   ***********************************************************************=
***/
>  static int
> -qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
> +qla1280_eh_adapter_reset(struct Scsi_Host *shost)
>  {
>  	int rc;
> +	struct scsi_qla_host *ha =3D (struct scsi_qla_host *)shost->hostdata;
> =20
> -	spin_lock_irq(cmd->device->host->host_lock);
> -	rc =3D qla1280_error_action(cmd, ADAPTER_RESET);
> -	spin_unlock_irq(cmd->device->host->host_lock);
> +	spin_lock_irq(shost->host_lock);
> +	if (qla1280_verbose) {
> +		printk(KERN_INFO
> +		       "scsi(%ld): Issued ADAPTER RESET\n",
> +		       ha->host_no);
> +		printk(KERN_INFO "scsi(%ld): I/O processing will "
> +		       "continue automatically\n", ha->host_no);
> +	}
> +	ha->flags.reset_active =3D 1;
> +
> +	if (qla1280_abort_isp(ha) !=3D 0) {	/* it's dead */
> +		rc =3D FAILED;
> +	}
> +
> +	ha->flags.reset_active =3D 0;
> +
> +	spin_unlock_irq(shost->host_lock);
> =20
>  	return rc;
>  }

This change introduces some code duplication. Have you considered to isolat=
e
the ADAPTER_RESET code from qla1280_error_action() into a new function in a
separate patch such that that new function can be called here instead of
duplicating the ADAPTER_RESET code?

Bart.=
