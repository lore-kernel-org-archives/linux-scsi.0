From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 03/43] hpsa: rework controller command submission
Date: Fri, 17 Apr 2015 14:57:57 +0200
Message-ID: <55310355.8090701@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134658.30238.76254.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbbDQM57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 08:57:59 -0400
In-Reply-To: <20150416134658.30238.76254.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Hi Don,

some comments inline.

On 04/16/2015 03:46 PM, Don Brace wrote:
> From: Webb Scales <webb.scales@hp.com>
>=20
> Allow driver initiated commands to have a timeout.  It does not
> yet try to do anything with timeouts on such commands.
>=20
> We are sending a reset in order to get rid of a command we want to ab=
ort.
> If we make it return on the same reply queue as the command we want t=
o abort,
> the completion of the aborted command will not race with the completi=
on of
> the reset command.
>=20
> Rename hpsa_scsi_do_simple_cmd_core() to hpsa_scsi_do_simple_cmd(), s=
ince
> this function is the interface for issuing commands to the controller=
 and
> not the "core" of that implementation.  Add a parameter to it which a=
llows
> the caller to specify the reply queue to be used.  Modify existing ca=
llers
> to specify the default reply queue.
>=20
> Rename __hpsa_scsi_do_simple_cmd_core() to hpsa_scsi_do_simple_cmd_co=
re(),
> since this routine is the "core" implementation of the "do simple com=
mand"
> function and there is no longer any other function with a similar nam=
e.
> Modify the existing callers of this routine (other than
> hpsa_scsi_do_simple_cmd()) to instead call hpsa_scsi_do_simple_cmd(),=
 since
> it will now accept the reply_queue paramenter, and it provides a cont=
roller
> lock-up check.  (Also, tweak two related message strings to make them
> distinct from each other.)
>=20
> Submitting a command to a locked up controller always results in a ti=
meout,
> so check for controller lock-up before submitting.
>=20
> This is to enable fixing a race between command completions and
> abort completions on different reply queues in a subsequent patch.
> We want to be able to specify which reply queue an abort completion
> should occur on so that it cannot race the completion of the command
> it is trying to abort.
>=20
> The following race was possible in theory:
>=20
>   1. Abort command is sent to hardware.
>   2. Command to be aborted simultaneously completes on another
>      reply queue.
>   3. Hardware receives abort command, decides command has already
>      completed and indicates this to the driver via another different
>      reply queue.
>   4. driver processes abort completion finds that the hardware does n=
ot know
>      about the command, concludes that therefore the command cannot c=
omplete,
>      returns SUCCESS indicating to the mid-layer that the scsi_cmnd m=
ay be
>      re-used.
>   5. Command from step 2 is processed and completed back to scsi mid
>      layer (after we already promised that would never happen.)
>=20
> Fix by forcing aborts to complete on the same reply queue as the comm=
and
> they are aborting.
>=20
> Piggybacking device rescanning functionality onto the lockup
> detection thread is not a good idea because if the controller
> locks up during device rescanning, then the thread could get
> stuck, then the lockup isn't detected.  Use separate work
> queues for device rescanning and lockup detection.
>=20
> Detect controller lockup in abort handler.
>=20
> After a lockup is detected, return DO_NO_CONNECT which results in imm=
ediate
> termination of commands rather than DID_ERR which results in retries.
>=20
> Modify detect_controller_lockup() to return the result, to remove the=
 need for a separate check.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  329 ++++++++++++++++++++++++++++++++++++-=
----------
>  drivers/scsi/hpsa_cmd.h |    5 +
>  2 files changed, 257 insertions(+), 77 deletions(-)
>=20
[ .. ]
> @@ -4375,13 +4469,46 @@ static int hpsa_eh_device_reset_handler(struc=
t scsi_cmnd *scsicmd)
>  			"device lookup failed.\n");
>  		return FAILED;
>  	}
> -	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
> -		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
> +
> +	/* if controller locked up, we can guarantee command won't complete=
 */
> +	if (lockup_detected(h)) {
> +		dev_warn(&h->pdev->dev,
> +			"scsi %d:%d:%d:%d RESET FAILED, lockup detected\n",
> +			h->scsi_host->host_no, dev->bus, dev->target,
> +			dev->lun);
> +		return FAILED;
> +	}
> +
> +	/* this reset request might be the result of a lockup; check */
> +	if (detect_controller_lockup(h)) {
> +		dev_warn(&h->pdev->dev,
> +			 "scsi %d:%d:%d:%d RESET FAILED, new lockup detected\n",
> +			 h->scsi_host->host_no, dev->bus, dev->target,
> +			 dev->lun);
> +		return FAILED;
> +	}
> +
> +	dev_warn(&h->pdev->dev,
> +		"scsi %d:%d:%d:%d: %s %.8s %.16s resetting RAID-%s SSDSmartPathCap=
%c En%c Exp=3D%d\n",
> +		h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
> +		scsi_device_type(dev->devtype),
> +		dev->vendor,
> +		dev->model,
> +		dev->raid_level > RAID_UNKNOWN ?
> +			"RAID-?" : raid_label[dev->raid_level],
> +		dev->offload_config ? '+' : '-',
> +		dev->offload_enabled ? '+' : '-',
> +		dev->expose_state);
> +
Didn't you just reworked the message logging in the previous patch?
Why can't you use it here?

>  	/* send a reset to the SCSI LUN which the command was sent to */
> -	rc =3D hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN);
> +	rc =3D hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
> +			     DEFAULT_REPLY_QUEUE);
>  	if (rc =3D=3D 0 && wait_for_device_to_become_ready(h, dev->scsi3add=
r) =3D=3D 0)
>  		return SUCCESS;
> =20
> +	dev_warn(&h->pdev->dev,
> +		"scsi %d:%d:%d:%d reset failed\n",
> +		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
>  	return FAILED;
>  }
> =20
> @@ -4426,7 +4553,7 @@ static void hpsa_get_tag(struct ctlr_info *h,
>  }
> =20
>  static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3=
addr,
> -	struct CommandList *abort, int swizzle)
> +	struct CommandList *abort, int swizzle, int reply_queue)
>  {
>  	int rc =3D IO_OK;
>  	struct CommandList *c;
> @@ -4444,9 +4571,9 @@ static int hpsa_send_abort(struct ctlr_info *h,=
 unsigned char *scsi3addr,
>  		0, 0, scsi3addr, TYPE_MSG);
>  	if (swizzle)
>  		swizzle_abort_tag(&c->Request.CDB[4]);
> -	hpsa_scsi_do_simple_cmd_core(h, c);
> +	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
>  	hpsa_get_tag(h, abort, &taglower, &tagupper);
> -	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd_core com=
pleted.\n",
> +	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd(abort) c=
ompleted.\n",
>  		__func__, tagupper, taglower);
>  	/* no unmap needed here because no data xfer. */
> =20
> @@ -4478,7 +4605,7 @@ static int hpsa_send_abort(struct ctlr_info *h,=
 unsigned char *scsi3addr,
>   */
> =20
>  static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
> -	unsigned char *scsi3addr, struct CommandList *abort)
> +	unsigned char *scsi3addr, struct CommandList *abort, int reply_queu=
e)
>  {
>  	int rc =3D IO_OK;
>  	struct scsi_cmnd *scmd; /* scsi command within request being aborte=
d */
> @@ -4521,7 +4648,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(st=
ruct ctlr_info *h,
>  			"Reset as abort: Resetting physical device at scsi3addr 0x%02x%02=
x%02x%02x%02x%02x%02x%02x\n",
>  			psa[0], psa[1], psa[2], psa[3],
>  			psa[4], psa[5], psa[6], psa[7]);
> -	rc =3D hpsa_send_reset(h, psa, HPSA_RESET_TYPE_TARGET);
> +	rc =3D hpsa_send_reset(h, psa, HPSA_RESET_TYPE_TARGET, reply_queue)=
;
>  	if (rc !=3D 0) {
>  		dev_warn(&h->pdev->dev,
>  			"Reset as abort: Failed on physical device at scsi3addr 0x%02x%02=
x%02x%02x%02x%02x%02x%02x\n",
> @@ -4555,7 +4682,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(st=
ruct ctlr_info *h,
>   * make this true someday become false.
>   */
>  static int hpsa_send_abort_both_ways(struct ctlr_info *h,
> -	unsigned char *scsi3addr, struct CommandList *abort)
> +	unsigned char *scsi3addr, struct CommandList *abort, int reply_queu=
e)
>  {
>  	/* ioccelerator mode 2 commands should be aborted via the
>  	 * accelerated path, since RAID path is unaware of these commands,
> @@ -4563,10 +4690,20 @@ static int hpsa_send_abort_both_ways(struct c=
tlr_info *h,
>  	 * Change abort to physical device reset.
>  	 */
>  	if (abort->cmd_type =3D=3D CMD_IOACCEL2)
> -		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr, abort);
> +		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
> +							abort, reply_queue);
> +
> +	return hpsa_send_abort(h, scsi3addr, abort, 0, reply_queue) &&
> +			hpsa_send_abort(h, scsi3addr, abort, 1, reply_queue);
> +}
> =20
> -	return hpsa_send_abort(h, scsi3addr, abort, 0) &&
> -			hpsa_send_abort(h, scsi3addr, abort, 1);
> +/* Find out which reply queue a command was meant to return on */
> +static int hpsa_extract_reply_queue(struct ctlr_info *h,
> +					struct CommandList *c)
> +{
> +	if (c->cmd_type =3D=3D CMD_IOACCEL2)
> +		return h->ioaccel2_cmd_pool[c->cmdindex].reply_queue;
> +	return c->Header.ReplyQueue;
>  }
> =20
>  /* Send an abort for the specified command.
> @@ -4584,7 +4721,7 @@ static int hpsa_eh_abort_handler(struct scsi_cm=
nd *sc)
>  	char msg[256];		/* For debug messaging. */
>  	int ml =3D 0;
>  	__le32 tagupper, taglower;
> -	int refcount;
> +	int refcount, reply_queue;
> =20
>  	/* Find the controller of the command to be aborted */
>  	h =3D sdev_to_hba(sc->device);
> @@ -4592,8 +4729,23 @@ static int hpsa_eh_abort_handler(struct scsi_c=
mnd *sc)
>  			"ABORT REQUEST FAILED, Controller lookup failed.\n"))
>  		return FAILED;
> =20
> -	if (lockup_detected(h))
> +	/* If controller locked up, we can guarantee command won't complete=
 */
> +	if (lockup_detected(h)) {
> +		dev_warn(&h->pdev->dev,
> +			"scsi %d:%d:%d:%llu scmd %p ABORT FAILED, lockup detected\n",
> +			h->scsi_host->host_no, sc->device->channel,
> +			sc->device->id, sc->device->lun, sc);
>  		return FAILED;
> +	}
> +
> +	/* This is a good time to check if controller lockup has occurred *=
/
> +	if (detect_controller_lockup(h)) {
> +		dev_warn(&h->pdev->dev,
> +			 "scsi %d:%d:%d:%llu scmd %p ABORT FAILED, new lockup detected\n"=
,
> +			 h->scsi_host->host_no, sc->device->channel,
> +			 sc->device->id, sc->device->lun, sc);
> +		return FAILED;
> +	}
> =20
Same here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
