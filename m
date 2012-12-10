From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Sun, 9 Dec 2012 20:27:02 -0600
Message-ID: <8766C19D-D366-4E5B-8210-019074C8D82F@cs.wisc.edu>
References: <1354891880-16159-1-git-send-email-hare@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47527 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJC2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Dec 2012 21:28:01 -0500
In-Reply-To: <1354891880-16159-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>


On Dec 7, 2012, at 8:51 AM, Hannes Reinecke <hare@suse.de> wrote:
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 8f92732..d6555aa 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -793,7 +793,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
> 	.queuecommand = bfad_im_queuecommand,
> 	.eh_abort_handler = bfad_im_abort_handler,
> 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
> -	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
> +	.eh_bus_reset_handler = fc_eh_reset_it_nexus_handler,
> 
> 	.slave_alloc = bfad_im_slave_alloc,
> 	.slave_configure = bfad_im_slave_configure,
> @@ -815,7 +815,7 @@ struct scsi_host_template bfad_im_vport_template = {
> 	.queuecommand = bfad_im_queuecommand,
> 	.eh_abort_handler = bfad_im_abort_handler,
> 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
> -	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
> +	.eh_bus_reset_handler = fc_eh_reset_it_nexus_handler,
> 
> 	.slave_alloc = bfad_im_slave_alloc,
> 	.slave_configure = bfad_im_slave_configure,
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 60e5a17..2fd67c1 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5136,7 +5136,7 @@ struct scsi_host_template lpfc_template = {
> 	.eh_abort_handler	= lpfc_abort_handler,
> 	.eh_device_reset_handler = lpfc_device_reset_handler,
> 	.eh_target_reset_handler = lpfc_target_reset_handler,
> -	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
> +	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
> 	.eh_host_reset_handler  = lpfc_host_reset_handler,
> 	.slave_alloc		= lpfc_slave_alloc,
> 	.slave_configure	= lpfc_slave_configure,
> @@ -5160,7 +5160,7 @@ struct scsi_host_template lpfc_vport_template = {
> 	.eh_abort_handler	= lpfc_abort_handler,
> 	.eh_device_reset_handler = lpfc_device_reset_handler,
> 	.eh_target_reset_handler = lpfc_target_reset_handler,
> -	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
> +	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
> 	.slave_alloc		= lpfc_slave_alloc,
> 	.slave_configure	= lpfc_slave_configure,
> 	.slave_destroy		= lpfc_slave_destroy,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 3a1661c..5d59284 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -246,7 +246,7 @@ struct scsi_host_template qla2xxx_driver_template = {
> 	.eh_abort_handler	= qla2xxx_eh_abort,
> 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
> 	.eh_target_reset_handler = qla2xxx_eh_target_reset,
> -	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
> +	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
> 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,


Hey,

One other comment. I do not think we can use the bus reset callout as is. I think for all fc drivers but mptfc, the channel is always 0. All targets on those hosts have the same channel value, and it seems  this code in scsi_error.c:scsi_eh_bus_reset():

                rtn = scsi_try_bus_reset(chan_scmd);
                if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
                        list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
                                if (channel == scmd_channel(scmd)) {

would end up matching all the commands on the host instead of just the commands on the specific target that was passed into scsi_try_bus_reset if SUCCESS or FAST_IO_FAIL was returned by scsi_try_bus_reset. If there were 2 faulty targets on a host, you would end up calling fc_eh_reset_it_nexus_handler on only 1.