From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Thu, 19 Mar 2009 12:19:17 -0500
Message-ID: <49C27E95.4050401@cs.wisc.edu>
References: <200903142003.n2EK39r4031547@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759978AbZCSRTl@vger.kernel.org>
In-Reply-To: <200903142003.n2EK39r4031547@blc-10-6.brocade.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

some quick general comments:

- Patch needs to be run through checkpatch.pl again.
- If you are not implementing a callout like issue_lip then you do not 
need to implement a function that does nothing.
- Remove the OS compat stuff that just calls right into the linux 
function. For example kill bfad_os_pci_probe.

Jing Huang wrote:
> +
> +/**
> + * Allocate a Scsi_Host for a port.
> + */
> +int
> +bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
> +{
> +	int error = 1;
> +
> +	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
> +		printk(KERN_WARNING "idr_pre_get failure\n");
> +		goto out;
> +	}
> +
> +	error = idr_get_new(&bfad_im_port_index, im_port,
> +					 &im_port->idr_id);
> +	if (error) {
> +		printk(KERN_WARNING "idr_get_new failure\n");
> +		goto out;
> +	}
> +
> +	im_port->shost = bfad_os_scsi_host_alloc(im_port, bfad);
> +	if (!im_port->shost) {
> +		error = 1;
> +		goto out_free_idr;
> +	}
> +
> +	im_port->shost->hostdata[0] = (unsigned long)im_port;



I think I asked about this before. Why do you just not allocate the bfad 
or im_port in the hostdata? What is the struct hierarchy? Do you have 
one bfad for the entire HBA/pci_device then have a im_port for each port 
on the hba?



> +	im_port->shost->unique_id = im_port->idr_id;
> +	im_port->shost->this_id = -1;
> +	im_port->shost->max_id = MAX_FCP_TARGET;
> +	im_port->shost->max_lun = MAX_FCP_LUN;
> +	im_port->shost->max_cmd_len = 16;
> +	im_port->shost->can_queue = bfad->cfg_data.ioc_queue_depth;
> +	im_port->shost->transportt = bfad_im_scsi_transport_template;
> +
> +	error = bfad_os_scsi_add_host(im_port->shost, im_port, bfad);
> +	if (error) {
> +		printk(KERN_WARNING "bfad_os_scsi_add_host failure %d\n",
> +							error);
> +		goto out_fc_rel;
> +	}
> +
> +	/* setup host fixed attribute if the lk supports */
> +	bfad_os_fc_host_init(im_port);
> +
> +	return 0;
> +
> +out_fc_rel:
> +	scsi_host_put(im_port->shost);
> +
> +out_free_idr:
> +	idr_remove(&bfad_im_port_index, im_port->idr_id);
> +out:
> +	return error;
> +}
> +
