From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 30/36] atari_NCR5380: Merge from sun3_NCR5380.c
Date: Thu, 30 Oct 2014 09:33:58 +0100
Message-ID: <5451F7F6.3020704@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052614.365442007@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052614.365442007@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> There is very little difference between the sun3_NCR5380.c core drive=
r
> and atari_NCR5380.c. The former is a fork of the latter.
>=20
> Merge the sun3_NCR5380.c core driver into atari_NCR5380.c so that
> sun3_scsi.c can adopt the latter and the former can be deleted.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>=20
> This patch brings some undesirable #ifdef's to atari_NCR5380. It's a =
small
> price to pay for the elimination of so much duplication. Eventually, =
with
> some testing, it should be possible to remove many of these.
>=20
> Elimination of the SUN3_SCSI_VME macro is necessary to reach the goal=
 of a
> single platform driver to replace the {atari,mac,sun3,sun3_vme}_scsi =
modules.
>=20
> Elimination of the #ifdef CONFIG_SUN3 tests is not necessary. But som=
e of
> these would go away if the sun3 driver followed the atari logic more
> closely, such as use of PIO vs DMA for certain phases and transfer si=
zes.
>=20
> After applying this patch it is easy to compare the new atari_NCR5380=
=2Ec
> with sun3_NCR5380.c, to check that they are equivalent. E.g.
>=20
> $ cp drivers/scsi/{sun3,atari}_NCR5380.c /tmp
> $ sed -i -e 's/  *$//'      /tmp/{sun3,atari}_NCR5380.c
> $ scripts/Lindent -l96 -hnl /tmp/{sun3,atari}_NCR5380.c
> $ meld                      /tmp/{sun3,atari}_NCR5380.c
>=20
> One can see that the two implementations of tagged command queueing h=
ave
> diverged since the fork. The atari version has been updated and the s=
un3
> implementation is unused as sun3_scsi.c does not define SUPPORT_TAGS.
>=20
> The remaining differences are merge_contiguous_buffers() and the falc=
on
> locking code. The falcon code disappears when suitable macro definiti=
ons are
> provided in sun3_scsi.c. merge_contiguous_buffers() could be a proble=
m
> for sun3 (due to a DMA setup in an odd place) so it is #ifdef'd for s=
un3
> until the DMA setup discrepancies can be reconciled or moved out of
> the core driver.
>=20
> ---
>  drivers/scsi/atari_NCR5380.c |  210 ++++++++++++++++++++++++++++++++=
+++++++----
>  drivers/scsi/atari_scsi.c    |    1=20
>  2 files changed, 195 insertions(+), 16 deletions(-)
>=20
> Index: linux/drivers/scsi/atari_NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:55.00000=
0000 +1100
> +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:56.000000000 =
+1100
> @@ -71,6 +71,9 @@
>   * 1.  Test linked command handling code after Eric is ready with
>   *     the high level code.
>   */
> +
> +/* Adapted for the sun3 by Sam Creasey. */
> +
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_transport_spi.h>
> =20
> @@ -458,6 +461,7 @@ static void free_all_tags(void)
> =20
>  static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
>  {
> +#if !defined(CONFIG_SUN3)
>  	unsigned long endaddr;
>  #if (NDEBUG & NDEBUG_MERGING)
>  	unsigned long oldlen =3D cmd->SCp.this_residual;
> @@ -482,6 +486,7 @@ static void merge_contiguous_buffers(str
>  		dprintk(NDEBUG_MERGING, "merged %d buffers from %p, new length %08=
x\n",
>  			   cnt, cmd->SCp.ptr, cmd->SCp.this_residual);
>  #endif
> +#endif /* !defined(CONFIG_SUN3) */
>  }
> =20
>  /*
> @@ -1043,12 +1048,10 @@ static void NCR5380_main(struct work_str
>  			     prev =3D NULL; tmp; prev =3D tmp, tmp =3D NEXT(tmp)) {
>  				u8 lun =3D tmp->device->lun;
> =20
> -#if (NDEBUG & NDEBUG_LISTS)
> -				if (prev !=3D tmp)
> -					printk("MAIN tmp=3D%p   target=3D%d   busy=3D%d lun=3D%llu\n",
> -					       tmp, tmp->device->id, hostdata->busy[tmp->device->id],
> -					       lun);
> -#endif
> +				dprintk(NDEBUG_LISTS,
> +				        "MAIN tmp=3D%p target=3D%d busy=3D%d lun=3D%d\n",
> +				        tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
> +				        lun);
>  				/*  When we find one, remove it from the issue queue. */
>  				/* ++guenther: possible race with Falcon locking */
>  				if (
> @@ -1157,9 +1160,11 @@ static void NCR5380_main(struct work_str
>  static void NCR5380_dma_complete(struct Scsi_Host *instance)
>  {
>  	SETUP_HOSTDATA(instance);
> -	int transfered, saved_data =3D 0, overrun =3D 0, cnt, toPIO;
> -	unsigned char **data, p;
> +	int transfered;
> +	unsigned char **data;
>  	volatile int *count;
> +	int saved_data =3D 0, overrun =3D 0;
> +	unsigned char p;
> =20
>  	if (!hostdata->connected) {
>  		printk(KERN_WARNING "scsi%d: received end of DMA interrupt with "

nitpick: shouldn't that be 'transferred' ?

> @@ -1185,6 +1190,26 @@ static void NCR5380_dma_complete(struct
>  		   HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
>  		   NCR5380_read(STATUS_REG));
> =20
> +#if defined(CONFIG_SUN3)
> +	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request))=
)) {
> +		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal wit=
h this!\n",
> +		       instance->host_no);
> +		pr_err("please e-mail sammy@sammy.net with a description of how th=
is error was produced.\n");
> +		BUG();
> +	}
> +
> +	/* make sure we're not stuck in a data phase */
> +	if ((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_AC=
K)) =3D=3D
> +	    (BASR_PHASE_MATCH | BASR_ACK)) {
> +		pr_err("scsi%d: BASR %02x\n", instance->host_no,
> +		       NCR5380_read(BUS_AND_STATUS_REG));
> +		pr_err("scsi%d: bus stuck in data phase -- probably a single byte =
overrun!\n",
> +		       instance->host_no);
> +		pr_err("not prepared for this error! please e-mail sammy@sammy.net=
 with a description of how this error was produced.\n");
> +		BUG();
> +	}
> +#endif
> +
>  	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
>  	NCR5380_write(MODE_REG, MR_BASE);
>  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> @@ -1198,6 +1223,8 @@ static void NCR5380_dma_complete(struct
>  	*count -=3D transfered;
> =20
>  	if (hostdata->read_overruns) {
> +		int cnt, toPIO;
> +
>  		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) =3D=3D p && (p & SR_IO=
)) {
>  			cnt =3D toPIO =3D hostdata->read_overruns;
>  			if (overrun) {
> @@ -1277,11 +1304,14 @@ static irqreturn_t NCR5380_intr(int irq,
>  			{
>  /* MS: Ignore unknown phase mismatch interrupts (caused by EOP inter=
rupt) */
>  				if (basr & BASR_PHASE_MATCH)
> -					printk(KERN_NOTICE "scsi%d: unknown interrupt, "
> +					dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
>  					       "BASR 0x%x, MR 0x%x, SR 0x%x\n",
>  					       HOSTNO, basr, NCR5380_read(MODE_REG),
>  					       NCR5380_read(STATUS_REG));
>  				(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> +#ifdef SUN3_SCSI_VME
> +				dregs->csr |=3D CSR_DMA_ENABLE;
> +#endif
>  			}
>  		} /* if !(SELECTION || PARITY) */
>  		handled =3D 1;
> @@ -1290,6 +1320,9 @@ static irqreturn_t NCR5380_intr(int irq,
>  		       "BASR 0x%X, MR 0x%X, SR 0x%x\n", HOSTNO, basr,
>  		       NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
>  		(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> +#ifdef SUN3_SCSI_VME
> +		dregs->csr |=3D CSR_DMA_ENABLE;
> +#endif
>  	}
> =20
>  	if (!done) {
> @@ -1622,6 +1655,9 @@ static int NCR5380_select(struct Scsi_Ho
>  #ifndef SUPPORT_TAGS
>  	hostdata->busy[cmd->device->id] |=3D (1 << cmd->device->lun);
>  #endif
> +#ifdef SUN3_SCSI_VME
> +	dregs->csr |=3D CSR_INTR;
> +#endif
> =20
>  	initialize_SCp(cmd);
> =20
> @@ -1845,9 +1881,54 @@ static int NCR5380_transfer_dma(struct S
>  	SETUP_HOSTDATA(instance);
>  	register int c =3D *count;
>  	register unsigned char p =3D *phase;
> +	unsigned long flags;
> +
> +#if defined(CONFIG_SUN3)
> +	/* sanity check */
> +	if (!sun3_dma_setup_done) {
> +		pr_err("scsi%d: transfer_dma without setup!\n",
> +		       instance->host_no);
> +		BUG();
> +	}
> +	hostdata->dma_len =3D c;
> +
> +	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %=
p\n",
> +		instance->host_no, (p & SR_IO) ? "reading" : "writing",
> +		c, (p & SR_IO) ? "to" : "from", *data);
> +
> +	/* netbsd turns off ints here, why not be safe and do it too */
> +	local_irq_save(flags);
> +
> +	/* send start chain */
> +	sun3scsi_dma_start(c, *data);
> +
> +	if (p & SR_IO) {
> +		NCR5380_write(TARGET_COMMAND_REG, 1);
> +		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> +		NCR5380_write(INITIATOR_COMMAND_REG, 0);
> +		NCR5380_write(MODE_REG,
> +			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR)=
);
> +		NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
> +	} else {
> +		NCR5380_write(TARGET_COMMAND_REG, 0);
> +		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> +		NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_DATA);
> +		NCR5380_write(MODE_REG,
> +			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR)=
);
> +		NCR5380_write(START_DMA_SEND_REG, 0);
> +	}
> +
> +#ifdef SUN3_SCSI_VME
> +	dregs->csr |=3D CSR_DMA_ENABLE;
> +#endif
> +
> +	local_irq_restore(flags);
> +
> +	sun3_dma_active =3D 1;
> +
> +#else /* !defined(CONFIG_SUN3) */
>  	register unsigned char *d =3D *data;
>  	unsigned char tmp;
> -	unsigned long flags;
> =20
>  	if ((tmp =3D (NCR5380_read(STATUS_REG) & PHASE_MASK)) !=3D p) {
>  		*phase =3D tmp;
> @@ -1895,6 +1976,8 @@ static int NCR5380_transfer_dma(struct S
>  			NCR5380_dma_write_setup(instance, d, c);
>  		local_irq_restore(flags);
>  	}
> +#endif /* !defined(CONFIG_SUN3) */
> +
>  	return 0;
>  }
>  #endif /* defined(REAL_DMA) */
> @@ -1930,6 +2013,10 @@ static void NCR5380_information_transfer
>  	unsigned char phase, tmp, extended_msg[10], old_phase =3D 0xff;
>  	struct scsi_cmnd *cmd =3D (struct scsi_cmnd *) hostdata->connected;
> =20
> +#ifdef SUN3_SCSI_VME
> +	dregs->csr |=3D CSR_INTR;
> +#endif
> +
>  	while (1) {
>  		tmp =3D NCR5380_read(STATUS_REG);
>  		/* We only have a valid SCSI phase when REQ is asserted */
> @@ -1939,6 +2026,33 @@ static void NCR5380_information_transfer
>  				old_phase =3D phase;
>  				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
>  			}
> +#if defined(CONFIG_SUN3)
> +			if (phase =3D=3D PHASE_CMDOUT) {
> +#if defined(REAL_DMA)
> +				void *d;
> +				unsigned long count;
> +
> +				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
> +					count =3D cmd->SCp.buffer->length;
> +					d =3D sg_virt(cmd->SCp.buffer);
> +				} else {
> +					count =3D cmd->SCp.this_residual;
> +					d =3D cmd->SCp.ptr;
> +				}
> +				/* this command setup for dma yet? */
> +				if ((count >=3D DMA_MIN_SIZE) && (sun3_dma_setup_done !=3D cmd))=
 {
> +					if (cmd->request->cmd_type =3D=3D REQ_TYPE_FS) {
> +						sun3scsi_dma_setup(d, count,
> +						                   rq_data_dir(cmd->request));
> +						sun3_dma_setup_done =3D cmd;
> +					}
> +				}
> +#endif
> +#ifdef SUN3_SCSI_VME
> +				dregs->csr |=3D CSR_INTR;
> +#endif
> +			}
> +#endif /* CONFIG_SUN3 */
> =20
>  			if (sink && (phase !=3D PHASE_MSGOUT)) {
>  				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
> @@ -2000,8 +2114,11 @@ static void NCR5380_information_transfer
>  				 */
> =20
>  #if defined(REAL_DMA)
> -				if (!cmd->device->borken &&
> -				    (transfersize =3D NCR5380_dma_xfer_len(instance,cmd,phase)) =
> 31) {
> +				if (
> +#if !defined(CONFIG_SUN3)
> +				    !cmd->device->borken &&
> +#endif
> +				    (transfersize =3D NCR5380_dma_xfer_len(instance, cmd, phase)=
) >=3D DMA_MIN_SIZE) {
>  					len =3D transfersize;
>  					cmd->SCp.phase =3D phase;
>  					if (NCR5380_transfer_dma(instance, &phase,
> @@ -2038,6 +2155,11 @@ static void NCR5380_information_transfer
>  					NCR5380_transfer_pio(instance, &phase,
>  							     (int *)&cmd->SCp.this_residual,
>  							     (unsigned char **)&cmd->SCp.ptr);
> +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> +				/* if we had intended to dma that command clear it */
> +				if (sun3_dma_setup_done =3D=3D cmd)
> +					sun3_dma_setup_done =3D NULL;
> +#endif
>  				break;
>  			case PHASE_MSGIN:
>  				len =3D 1;
> @@ -2243,6 +2365,9 @@ static void NCR5380_information_transfer
>  					/* Wait for bus free to avoid nasty timeouts */
>  					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connec=
ted)
>  						barrier();
> +#ifdef SUN3_SCSI_VME
> +					dregs->csr |=3D CSR_DMA_ENABLE;
> +#endif
>  					return;
>  					/*
>  					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
> @@ -2402,17 +2527,20 @@ static void NCR5380_information_transfer
>   */
> =20
> =20
> +/* it might eventually prove necessary to do a dma setup on
> +   reselection, but it doesn't seem to be needed now -- sam */
> +
>  static void NCR5380_reselect(struct Scsi_Host *instance)
>  {
>  	SETUP_HOSTDATA(instance);
>  	unsigned char target_mask;
> -	unsigned char lun, phase;
> -	int len;
> +	unsigned char lun;
>  #ifdef SUPPORT_TAGS
>  	unsigned char tag;
>  #endif
>  	unsigned char msg[3];
> -	unsigned char *data;
> +	int __maybe_unused len;
> +	unsigned char __maybe_unused *data, __maybe_unused phase;
>  	struct scsi_cmnd *tmp =3D NULL, *prev;
> =20
>  	/*
> @@ -2449,10 +2577,18 @@ static void NCR5380_reselect(struct Scsi
>  	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
>  		;
> =20
> +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> +	/* acknowledge toggle to MSGIN */
> +	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(PHASE_MSGIN));
> +
> +	/* peek at the byte without really hitting the bus */
> +	msg[0] =3D NCR5380_read(CURRENT_SCSI_DATA_REG);
> +#else
>  	len =3D 1;
>  	data =3D msg;
>  	phase =3D PHASE_MSGIN;
>  	NCR5380_transfer_pio(instance, &phase, &len, &data);
> +#endif
> =20
>  	if (!(msg[0] & 0x80)) {
>  		printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOST=
NO);
> @@ -2462,7 +2598,7 @@ static void NCR5380_reselect(struct Scsi
>  	}
>  	lun =3D (msg[0] & 0x07);
> =20
> -#ifdef SUPPORT_TAGS
> +#if defined(SUPPORT_TAGS) && !defined(CONFIG_SUN3)
>  	/* If the phase is still MSGIN, the target wants to send some more
>  	 * messages. In case it supports tagged queuing, this is probably a
>  	 * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
> @@ -2524,9 +2660,51 @@ static void NCR5380_reselect(struct Scsi
>  		return;
>  	}
> =20
> +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> +	/* engage dma setup for the command we just saw */
> +	{
> +		void *d;
> +		unsigned long count;
> +
> +		if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
> +			count =3D tmp->SCp.buffer->length;
> +			d =3D sg_virt(tmp->SCp.buffer);
> +		} else {
> +			count =3D tmp->SCp.this_residual;
> +			d =3D tmp->SCp.ptr;
> +		}
> +		/* setup this command for dma if not already */
> +		if ((count >=3D DMA_MIN_SIZE) && (sun3_dma_setup_done !=3D tmp)) {
> +			sun3scsi_dma_setup(d, count, rq_data_dir(tmp->request));
> +			sun3_dma_setup_done =3D tmp;
> +		}
> +	}
> +
> +	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
> +#endif
> +
>  	/* Accept message by clearing ACK */
>  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> =20
> +#if defined(SUPPORT_TAGS) && defined(CONFIG_SUN3)
> +	/* If the phase is still MSGIN, the target wants to send some more
> +	 * messages. In case it supports tagged queuing, this is probably a
> +	 * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
> +	 */
> +	tag =3D TAG_NONE;
> +	if (phase =3D=3D PHASE_MSGIN && setup_use_tagged_queuing) {
> +		/* Accept previous IDENTIFY message by clearing ACK */
> +		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> +		len =3D 2;
> +		data =3D msg + 1;
> +		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
> +		    msg[1] =3D=3D SIMPLE_QUEUE_TAG)
> +			tag =3D msg[2];
> +		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d=
 at reselection\n"
> +			HOSTNO, target_mask, lun, tag);
> +	}
> +#endif
> +
>  	hostdata->connected =3D tmp;
>  	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target =3D =
%d, lun =3D %llu, tag =3D %d\n",
>  		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
> Index: linux/drivers/scsi/atari_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:55.00000000=
0 +1100
> +++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:56.000000000 +11=
00
> @@ -89,6 +89,7 @@
>  #define REAL_DMA
>  #define SUPPORT_TAGS
>  #define MAX_TAGS                        32
> +#define DMA_MIN_SIZE                    32
> =20
>  #define NCR5380_implementation_fields   /* none */
> =20
>=20
>=20
You reference a certain Sam Creasey in the code (and there is even
his email in it). Has he contributed to this patch?
If so, shouldn't he be added somewhere in the patch description,
either with 'From;' (if the patch was originally by him)
or with a 'Signed-off-by' tag?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
