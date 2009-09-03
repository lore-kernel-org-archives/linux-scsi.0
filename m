From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
 (fwd)
Date: Thu, 03 Sep 2009 16:33:20 -0500
Message-ID: <4AA03620.70904@linux.vnet.ibm.com>
References: <alpine.LNX.1.10.0909021704370.3751@rslab159.pmc-sierra.bc.ca> <4A9FDBE4.2090008@linux.vnet.ibm.com> <alpine.LNX.1.10.0909030959100.11364@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45419 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbZICVdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 17:33:20 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n83LVVH6021995
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 17:31:31 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n83LXMUS043336
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 17:33:22 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n83LXM5D014086
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 17:33:22 -0400
In-Reply-To: <alpine.LNX.1.10.0909030959100.11364@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de

Anil Ravindranath wrote:
> Hi Brian,
> 
> 
> On Thu, 3 Sep 2009, Brian King wrote:
> 
>> Anil,
>>
>> Taking a quick scan through the driver, I would suggest you audit your
>> logging. Looks like there is a lot of dev_err, where sdev_printk might be
>> better,
> 
> I hope I am understanding this correct...
> 
> I don't see a difference in using dev_err Vs. sdev_printk. B'coz both call
> dev_printk except the prefix of KERN_ERR. But I guess even if we use
> sdev_printk we will use KERN_ERR anyways. Also both refer "Generic device
> interface".
> 
> #define dev_err(dev, format, arg...)            \   
>         dev_printk(KERN_ERR , dev , format , ## arg)
> 
> #define sdev_printk(prefix, sdev, fmt, a...)    \
>         dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)

The difference is the dev pointer that gets passed to dev_printk. When calling
sdev_printk, the dev pointer for the scsi device gets passed, so the printk
ends up getting prefixed with the SCSI location: 0:0:0:0, for example where
you have SCSI Host:Bus:Target:LUN. The dev_err calls I see in the driver
generally pass the dev pointer of the PCI device, resulting in the PCI location
of the adapter being logged. Its just a matter of scoping the printk to the
device.

> 
> struct scsi_device {
> 
> struct device           sdev_gendev;
>  
> }
> 
>  and pmcraid_info where sdev_info might be better, etc.
> Where/what is this sdev_info?

There isn't one... I meant to say dev_info, sdev_printk, scmd_printk, etc... 


>>> +
>>> +/**
>>> + * pmcraid_eh_abort_handler - entry point for aborting a single task on errors
>>> + *
>>> + * @scsi_cmd:   scsi command struct given by mid-layer. When this is called
>>> + *		mid-layer ensures that no other commands are queued. This
>>> + *		never gets called under interrupt, but a separate eh thread.
>>> + *
>>> + * Return value:
>>> + *	 SUCCESS / FAILED
>>> + */
>>> +static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
>>> +{
>>> +	struct pmcraid_instance *pinstance;
>>> +	struct pmcraid_cmd *cmd;
>>> +	struct pmcraid_resource_entry *res;
>>> +	unsigned long host_lock_flags;
>>> +	unsigned long pending_lock_flags;
>>> +	struct pmcraid_cmd *cancel_cmd = NULL;
>>> +	int cmd_found = 0;
>>> +	int rc = FAILED;
>>> +
>>> +	pinstance =
>>> +		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
>>> +
>>> +	dev_err(&pinstance->pdev->dev,
>>> +		"I/O command timed out, aborting it.\n");

This is an example of where using:

sdev_printk(KERN_ERR, scsi_cmd->device, "I/O command timed out, aborting it.\n");

Would help isolate the command timeout issue down to the device level rather than
just the adapter level.

>>> +
>>> +	res = scsi_cmd->device->hostdata;
>>> +
>>> +	if (res == NULL)
>>> +		return rc;
>>> +
>>> +	/* If we are currently going through reset/reload, return failed.
>>> +	 * This will force the mid-layer to eventually call
>>> +	 * pmcraid_eh_host_reset which will then go to sleep and wait for the
>>> +	 * reset to complete
>>> +	 */
>>> +	spin_lock_irqsave(pinstance->host->host_lock, host_lock_flags);
>>> +
>>> +	if (pinstance->ioa_reset_in_progress ||
>>> +	    pinstance->ioa_state == IOA_STATE_DEAD) {
>>> +		spin_unlock_irqrestore(pinstance->host->host_lock,
>>> +				       host_lock_flags);
>>> +		return rc;
>>> +	}
>>> +
>>> +	/* loop over pending cmd list to find cmd corresponding to this
>>> +	 * scsi_cmd. Note that this command might not have been completed
>>> +	 * already. locking: all pending commands are protected with
>>> +	 * pending_pool_lock.
>>> +	 */
>>> +	spin_lock_irqsave(&pinstance->pending_pool_lock, pending_lock_flags);
>>> +	list_for_each_entry(cmd, &pinstance->pending_cmd_pool, free_list) {
>>> +
>>> +		if (cmd->scsi_cmd == scsi_cmd) {
>>> +			cmd_found = 1;
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	spin_unlock_irqrestore(&pinstance->pending_pool_lock,
>>> +				pending_lock_flags);
>>> +
>>> +	/* If the command to be aborted was given to IOA and still pending with
>>> +	 * it, send ABORT_TASK to abort this and wait for its completion
>>> +	 */
>>> +	if (cmd_found)
>>> +		cancel_cmd = pmcraid_abort_cmd(cmd);
>>> +
>>> +	spin_unlock_irqrestore(pinstance->host->host_lock,
>>> +			       host_lock_flags);
>>> +
>>> +	if (cancel_cmd) {
>>> +		cancel_cmd->u.res = cmd->scsi_cmd->device->hostdata;
>>> +		rc = pmcraid_abort_complete(cancel_cmd);
>>> +	}
>>> +
>>> +	return cmd_found ? rc : SUCCESS;
>>> +}


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


