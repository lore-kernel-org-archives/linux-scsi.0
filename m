From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Thu, 07 Mar 2013 13:19:39 -0600
Message-ID: <5138E84B.8030803@cs.wisc.edu>
References: <1355214219-17343-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51286 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3CGTVb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 14:21:31 -0500
In-Reply-To: <1355214219-17343-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

Sorry for the late reply.

On 12/11/2012 02:23 AM, Hannes Reinecke wrote:
> @@ -793,7 +793,8 @@ struct scsi_host_template bfad_im_scsi_host_template = {
>  	.queuecommand = bfad_im_queuecommand,
>  	.eh_abort_handler = bfad_im_abort_handler,
>  	.eh_device_reset_handler = bfad_im_reset_lun_handler,
> -	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
> +	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
> +	.eh_bus_reset_handler = NULL,

Don't need to set to NULL in the final patch, and don't forget to send a
patch to remove all the code we do not need anymore :)


> +fc_eh_it_nexus_loss_handler(struct scsi_cmnd *cmnd)
> +{
> +	struct fc_internal *i = to_fc_internal(cmnd->device->host->transportt);
> +	struct scsi_target *starget = scsi_target(cmnd->device);
> +	struct fc_rport *rport = starget_to_rport(starget);
> +	int ret;
> +
> +	ret = fc_block_scsi_eh(cmnd);
> +	if (i->f->eh_it_nexus_loss)
> +		ret = i->f->eh_it_nexus_loss(cmnd);
> +
> +	/* FAST_IO_FAIL indicates the port is already blocked */
> +	if (ret == FAST_IO_FAIL)
> +		return ret;
> +	if (ret == SUCCESS)
> +		/* All outstanding I/O has been aborted */
> +		__fc_remote_port_delete(rport, -1);
> +	else {
> +		/* Failed to abort outstanding I/O, trigger FAST_IO_FAIL */
> +		__fc_remote_port_delete(rport, 0);

I think it looks ok from a high level, but I am not sure how the drivers
are working here.

What happens for lpfc? It seems __fc_remote_port_delete ends up calling
the fast io fail code right away and that sets
FC_RPORT_FAST_FAIL_TIMEDOUT. We will then call lpfc_terminate_rport_io
which only will send aborts for the commands. We will then call
fc_block_scsi_eh above and that returns FAST_IO_FAIL and we will pass
that back up to the scsi eh right away.

But it seems lpfc_terminate_rport_io does not wait for the abort
reposnses and clean up the affected scsi_cmnds, and it does not seem to
do something to prevent lpfc from touching affected scsi_cmnds, does it
(I could not find the code)? If lpfc ends up touching a scsi_cmnd after
we have return FAST_IO_FAIL from this function then both lpfc and some
other code could be using the same scsi_cmnd struct.


For qla2xxx, it seems qla2x00_terminate_rport_io aborts commands, but it
looks like there is a small race where if some other thread was actually
completing the command already, then that thread could be touching the
scsi command, but this function could return and the scsi eh could end
up giving the command to some other driver or retrying while the other
thread was still touching it.

It also seems like there is a race where since
qla2x00_terminate_rport_io also calls the logout functions for the port,
then if that path was fast enough it could it lead to
fc_remote_port_delete getting called by qla2xxx while
fc_eh_it_nexus_loss_handler's call to __fc_remote_port_delete was still
running?


> +		ret = fc_block_scsi_eh(cmnd);
> +	}
> +	if (ret != FAST_IO_FAIL) {
> +		if (rport->port_state == FC_PORTSTATE_ONLINE)
> +			ret = SUCCESS;
> +		else
> +			ret = FAILED;
> +	}
> +	return ret;
> +}
