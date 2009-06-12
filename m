From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
Date: Fri, 12 Jun 2009 10:23:15 -0500
Message-ID: <4A3272E3.3010000@linux.vnet.ibm.com>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <4A31319C.605@linux.vnet.ibm.com> <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48509 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZFLPXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 11:23:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5CFHPVg008942
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 11:17:25 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5CFNPjN232200
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 11:23:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5CFL5Lx008509
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 11:21:10 -0400
In-Reply-To: <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de

Grant Grundler wrote:
>>> +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
>>> +{
>>> +     struct pmcraid_resource_entry *temp, *res = NULL;
>>> +     struct pmcraid_instance *pinstance;
>>> +     u8 target, bus, lun;
>>> +     unsigned long lock_flags;
>>> +     int rc = -ENXIO;
>>> +
>>> +     pinstance = (struct pmcraid_instance *)scsi_dev->host->hostdata;
>>> +
>>> +     /* Driver exposes VSET and GSCSI resources only; all other device types
>>> +      * are not exposed. Resource list is synchronized using resource lock
>>> +      * so any traversal or modifications to the list should be done inside
>>> +      * this lock
>>> +      */
>>> +     spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
>>> +     list_for_each_entry(temp, &pinstance->used_res_q, queue) {
>>> +
>>> +             /* do not expose VSETs with order-ids >= 240 */
>>> +             if (RES_IS_VSET(temp->cfg_entry)) {
>>> +                     target = temp->cfg_entry.unique_flags1;
>>> +                     if (target >= PMCRAID_MAX_VSET_TARGETS)
>>> +                             continue;
>>> +                     bus = PMCRAID_VSET_BUS_ID;
>>> +                     lun = 0;
>>> +             } else if (RES_IS_GSCSI(temp->cfg_entry)) {
>>> +                     target = RES_TARGET(temp->cfg_entry.resource_address);
>>> +                     bus = PMCRAID_PHYS_BUS_ID;
>>> +                     lun = RES_LUN(temp->cfg_entry.resource_address);
>> I assume this means this adapter only supports single byte LUNs...
> 
> ISTR, SCSI-3 spec only defines 5-bits for the LUN field...but my SCSI-foo
> pretty old and I might misremember. It was easy to find this reference:
>     http://en.wikipedia.org/wiki/SCSI_Read_Commands
> 
> I'm sure there something better from t10.org but everything requires
> a login now and I'm sure someone here will just know this.

SCSI allows 8 byte LUNs these days. The reference you make here refers
to bits in CDB which are now reserved. 

>>> +     spin_unlock_irqrestore(&pinstance->pending_pool_lock, lock_flags);
>>> +
>>> +     /* Mulitple paths (IO path, control path) may be submitting IOARCBs,
>>> +      * hence it is necessary to protect writes to IOA's ioarrin register.
>>> +      * All writes to IOA ioarrin are synchronized with host_lock
>>> +      */
>>> +     if (lock)
>>> +             spin_lock_irqsave(pinstance->host->host_lock,
>>> +                               pinstance->host_lock_flags);
>>> +
>>> +     /* apply memory barrier */
>>> +     mb();
>>> +     /* driver writes lower 32-bit value of IOARCB address only */
>>> +     write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinstance->ioarrin);
>>> +
>>> +     if (lock)
>>> +             spin_unlock_irqrestore(pinstance->host->host_lock,
>>> +                                    pinstance->host_lock_flags);
>> Any way to get rid of this lock flag getting passed in?
> 
> And I believe due to spinlock/unlock, the mb() is not needed.
> Spin locks imply memory barriers.

Incorrect. The memory barrier here ensures that the command being
constructed for the adapter is in a consistent state and that all
the writes to the command buffer are flushed to memory before
the write64 happens, which will trigger the adapter to DMA the
command buffer and start executing the command.


>>> +
>>> +     /* If this was a SCSI read/write command keep count of errors */
>>> +     if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_READ_CMD)
>>> +             res->read_failures++;
>>> +     else if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_WRITE_CMD)
>>> +             res->write_failures++;
>> These are both getting incremented without locks, which could cause them
>> to get corrupted.
> 
> atomic_inc() should be sufficient here.
> (I didn't check the locking...assuming Brian is correct.)

Agreed. Changing this to an atomic should be fine.

>>> +/* Maximum number of adapters supported by current version of the driver */
>>> +#define PMCRAID_MAX_ADAPTERS         32
>> Why is there a limit on the max adapters supported?
> 
> Because of this code I think:
> +DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
> ...
> +       error = alloc_chrdev_region(&dev, 0,
> +                                   PMCRAID_MAX_ADAPTERS,
> +                                   PMCRAID_DEVFILE);
> 
> I don't know offhand how to avoid this. Suggestions?

Hopefully, this can be solved by removing the character device altogether.
AFAICS, its only used for the ioctls, which should be able to be converted
to use other interfaces such as sysfs or netlink.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


