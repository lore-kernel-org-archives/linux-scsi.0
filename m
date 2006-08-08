From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Tue, 08 Aug 2006 11:11:19 -0500
Message-ID: <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
References: <20060808120507.GA20032@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11917 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964924AbWHHQMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 12:12:33 -0400
In-Reply-To: <20060808120507.GA20032@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, promise_linux@promise.com, akpm@osdl.org

On Tue, 2006-08-08 at 08:05 -0400, Jeff Garzik wrote:
> Adds the 'stex' driver for Promise SuperTrak EX storage controllers.
> These controllers present themselves as SCSI, though like 3ware,
> megaraid and others, the underlying storage may or may not be SCSI.
> 
> As discussed, the block tagging stuff is a post-merge todo item.

That's not exactly my recollection of the discussion:  I thought we were
still discussing the chicken and egg issue (which is we have APIs to do
this per host tagging which stex duplicates on the grounds no-one's
using the current APIs).  Jens and I seem to be in agreement that stex
should try the API's and well make any changes that become necessary to
block or SCSI happen.


> +	switch (cmd->cmnd[0]) {
> +	case MODE_SENSE_10:
> +	{
> +		static char mode_sense10[8] = { 0, 6, 0, 0, 0, 0, 0, 0 };
> +
> +		stex_direct_copy(cmd, mode_sense10, sizeof(mode_sense10));
> +		cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		done(cmd);
> +		return 0;
> +	}

This looks like it will trick the sd driver into reading uninitialised
data for the drive caching parameters ... there are obviously faults on
both sides, but I think when you ask for a mode page and you get a
success return, you're entitled to think you got it ...


> +	case INQUIRY:
> +		if (id != ST_MAX_ARRAY_SUPPORTED)
> +			break;
> +		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
> +			stex_direct_copy(cmd, console_inq_page,
> +				sizeof(console_inq_page));
> +			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		} else
> +			cmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
> +		done(cmd);

The error return isn't correct you should never use DID_ERROR for an
uncorrectable error because it will cause a retry (which you'll fail
again).  For an unsupported inquiry the correct return should be Check
Condition/Illegal Request/Invalid Field in CDB

> +	case INQUIRY:
> +		if (id != ST_MAX_ARRAY_SUPPORTED)
> +			break;
> +		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
> +			stex_direct_copy(cmd, console_inq_page,
> +				sizeof(console_inq_page));
> +			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
> +		} else
> +			cmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
> +		done(cmd);

The error return here looks like it shouldn't be DID_ERROR either.  I
assume the error is a format one and uncorrectable by a retry?

> +	}
> +
> +	hba->dma_mem = pci_alloc_consistent(pdev,
> +		STEX_BUFFER_SIZE, &hba->dma_handle);
> +	if (!hba->dma_mem) {
> +		err = -ENOMEM;
> +		printk(KERN_ERR DRV_NAME "(%s): dma mem alloc failed\n",
> +			pci_name(pdev));
> +		goto out_iounmap;
> +	}

This should be dma_alloc_coherent, not pci_alloc_consistent.

James


