From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 2.6: add scsi synchronize cache support.
Date: Thu, 20 Jan 2005 11:31:32 +0000
Message-ID: <20050120113132.GA391@infradead.org>
References: <1106172102.11875.18.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36266 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262124AbVATLbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:31:34 -0500
Content-Disposition: inline
In-Reply-To: <1106172102.11875.18.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> +static void synchronize_callback(void *context, struct fib * fibptr)
> +{
> +	struct aac_synchronize_reply * synchronizereply;
> +	struct scsi_cmnd * scsicmd;

Superflous whitespaces before the *.  Also the canonical name for
scsi_cmnds seems to be cmd - that makes easiert to read code.

> +
> +	scsicmd = (struct scsi_cmnd *) context;

No need to cast.  You could also move the assigment into the declaration.

> +
> +	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));

please linewrrap after 80 chars

> +	if (fibptr == NULL)
> +		BUG();

BUG_ON()

> +	synchronizereply = (struct aac_synchronize_reply *) fib_data(fibptr);

fib_data return void *, no cast needed.

> 
> +	if (le32_to_cpu(synchronizereply->status) == CT_OK) {
> +		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;

linelength again.

> 
> +	} else {
> +		struct scsi_device * device = scsicmd->device;

Canonical name is sdev, superflous space again.

> +		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,

sense_data is u8 already.

> +		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
> +		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
> +		    ? sizeof(scsicmd->sense_buffer)
> +		    : sizeof(dev->fsa_dev[cid].sense_data));

Use max here?

> +		if ((cmd != scsicmd) && (cmd->serial_number != 0)) {

superflous braces.

> +/* XXX */printk(KERN_DEBUG "aac_synchronize[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies);
> +/* XXX 	dprintk((KERN_DEBUG "aac_synchronize[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies)); */

take this out?

