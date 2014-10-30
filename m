From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 29/36] atari_NCR5380: Refactor Falcon locking
Date: Thu, 30 Oct 2014 09:27:38 +0100
Message-ID: <5451F67A.2000708@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052614.115438637@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052614.115438637@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Simplify falcon_release_lock_if_possible() by making callers responsi=
ble for
> disabling local IRQ's, which they must do anyway to correctly synchro=
nize
> the ST DMA "lock" with core driver data structures. Move this
> synchronization logic to the core driver with which it is tightly cou=
pled.
>=20
> Other LLD's like sun3_scsi and mac_scsi that can make use of this cor=
e
> driver can just stub out the NCR5380_acquire_dma_irq() and
> NCR5380_release_dma_irq() calls so the compiler will eliminate the
> ST DMA code.
>=20
> Remove a redundant local_irq_save/restore pair (irq's are disabled fo=
r
> interrupt handlers these days). Revise the locking for
> atari_scsi_bus_reset(): use local_irq_save/restore() instead of
> atari_turnoff/turnon_irq(). There is no guarantee that atari_scsi sti=
ll
> holds the ST DMA lock during EH, so atari_turnoff/turnon_irq() could
> end up dropping an IDE or floppy interrupt.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/atari_NCR5380.c |   72 ++++++++++++++++++++++++++------=
-----------
>  drivers/scsi/atari_scsi.c    |   47 ++++++++++------------------
>  2 files changed, 62 insertions(+), 57 deletions(-)
>=20
> Index: linux/drivers/scsi/atari_NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:54.00000=
0000 +1100
> +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:55.000000000 =
+1100
> @@ -926,7 +926,7 @@ static int NCR5380_queue_command(struct
>  	 * alter queues and touch the lock.
>  	 */
>  	/* perhaps stop command timer here */
> -	if (!falcon_get_lock())
> +	if (!NCR5380_acquire_dma_irq(instance))
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	/* perhaps restart command timer here */
> =20
> @@ -962,6 +962,18 @@ static int NCR5380_queue_command(struct
>  	return 0;
>  }
> =20
> +static inline void maybe_release_dma_irq(struct Scsi_Host *instance)
> +{
> +	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> +
> +	/* Caller does the locking needed to set & test these data atomical=
ly */
> +	if (!hostdata->disconnected_queue &&
> +	    !hostdata->issue_queue &&
> +	    !hostdata->connected &&
> +	    !hostdata->retain_dma_intr)
> +		NCR5380_release_dma_irq(instance);
> +}
> +
>  /*
>   * Function : NCR5380_main (void)
>   *
> @@ -1084,9 +1096,11 @@ static void NCR5380_main(struct work_str
>  					cmd_get_tag(tmp, tmp->cmnd[0] !=3D REQUEST_SENSE);
>  #endif
>  					if (!NCR5380_select(instance, tmp)) {
> +						local_irq_disable();
>  						hostdata->retain_dma_intr--;
>  						/* release if target did not response! */
> -						falcon_release_lock_if_possible(hostdata);
> +						maybe_release_dma_irq(instance);
> +						local_irq_restore(flags);
>  						break;
>  					} else {
>  						local_irq_disable();
> @@ -2085,11 +2099,12 @@ static void NCR5380_information_transfer
>  				case COMMAND_COMPLETE:
>  					/* Accept message by clearing ACK */
>  					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> -					/* ++guenther: possible race with Falcon locking */
> -					hostdata->retain_dma_intr++;
> -					hostdata->connected =3D NULL;
>  					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu=
 "
>  						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
> +
> +					local_irq_save(flags);
> +					hostdata->retain_dma_intr++;
> +					hostdata->connected =3D NULL;
>  #ifdef SUPPORT_TAGS
>  					cmd_free_tag(cmd);
>  					if (status_byte(cmd->SCp.Status) =3D=3D QUEUE_FULL) {
> @@ -2148,17 +2163,17 @@ static void NCR5380_information_transfer
> =20
>  						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n"=
, HOSTNO);
> =20
> -						local_irq_save(flags);
>  						LIST(cmd,hostdata->issue_queue);
>  						SET_NEXT(cmd, hostdata->issue_queue);
>  						hostdata->issue_queue =3D (struct scsi_cmnd *) cmd;
> -						local_irq_restore(flags);
>  						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of=
 "
>  							  "issue queue\n", H_NO(cmd));
>  					} else {
>  						cmd->scsi_done(cmd);
>  					}
> =20
> +					local_irq_restore(flags);
> +
>  					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>  					/*
>  					 * Restore phase bits to 0 so an interrupted selection,
Probably a stupid question, but you're disabling local interrupts.
scsi_done() OTOH is triggering a soft irq. Does this work?
Shouldn't we enable interrupts before calling scsi_done() ?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
