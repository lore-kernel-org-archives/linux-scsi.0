From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] libsas: Convert to host_lock less w/ interrupts
 disabled externally
Date: Wed, 17 Nov 2010 17:30:53 -0500
Message-ID: <20101117223053.GB26760@infradead.org>
References: <1290032331-4919-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934662Ab0KQWay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:30:54 -0500
Content-Disposition: inline
In-Reply-To: <1290032331-4919-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

> @@ -189,7 +189,7 @@ int sas_queue_up(struct sas_task *task)
>   * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
>   * call us without holding an IRQ spinlock...

That comment can be removed now.

>   */
> -static int sas_queuecommand_lck(struct scsi_cmnd *cmd,

That's now how the code looks like upstream.

> +static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
>  		     void (*scsi_done)(struct scsi_cmnd *))
>  	__releases(host->host_lock)
>  	__acquires(dev->sata_dev.ap->lock)

The host_lock annotations are not incorrect, and the sata_dev ones
never made sense.

> @@ -254,7 +254,7 @@ out:
>  	return res;
>  }
>  
> -DEF_SCSI_QCMD(sas_queuecommand)
> +IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)

And in addition this doesn't even seem correct to me.  First thing
sas_queuecommand upstream does is spin_unlock_irq on the host_lock
which it expects to be held, then it does a spin_lock_irqsave for the
sata case, or operations that do not appear to need a lock for the
sas case.

