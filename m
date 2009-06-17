From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
Date: Wed, 17 Jun 2009 10:09:48 -0500
Message-ID: <4A39073C.6070202@linux.vnet.ibm.com>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <4A31319C.605@linux.vnet.ibm.com> <alpine.LNX.1.10.0906160546520.6270@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47592 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbZFQPKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 11:10:13 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e9.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5HEvfZr025951
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 10:57:41 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5HFA43K1404946
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 11:10:07 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5HF9oLg018726
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 09:09:55 -0600
In-Reply-To: <alpine.LNX.1.10.0906160546520.6270@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de

Anil Ravindranath wrote:
>>> +/*
>>> + * Supporting user-level control interface through IOCTL commands.
>>> + * pmcraid_major - major number to use
>>> + * pmcraid_minor - minor number(s) to use
>>> + */
>>> +static unsigned int pmcraid_major;
>>> +static struct class *pmcraid_class;
>>> +DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
>> New IOCTL interfaces are generally not acceptable in a new driver. Some alternative
>> interfaces include sysfs, netlink, and debugfs. Refer to the ipr driver for
>> an example of avoiding using IOCTLs. Additional comments below on how to
>> remove the dependency.
>>
> 
> 
> 1.We want to have a single RAID management Appliction interface to support 
> multiple wide range of OS platforms. IOCTL is the best approach as this 
> interface is available in all OS platforms.

This can also be accomplished with an OS abstraction layer in the management
application.


> 2.Also we have commands which requires additional command parameters 
> which need to be passed down to FW and we think IOCTL is best approach to send 
> these parameters down field by field. We didn't find any other cleaner way 
> to pass these additional command parameters seperately from the usual 
> data buffer.
> 
> 3. we chose IOCTL as we want our Application interface to have full  
> control of filling in the fields(like FW specific headers) as passthru to driver.

The ipr driver has similar requirements, but after taking a good look at
what the user space management application required, I was able to use SG_IO to
send these commands to either the adapter itself or the associated disks or disk
arrays. I'm not sure if you can do this or not, but I would encourage you to take
a look at it. Here are some of the advantages of this approach:

1. No need to duplicate any error handling for these commands. SCSI core handles
   timeouts and error recovery like all other commands.
2. Reduces code in the driver. All commands now come through queuecommand.
3. scsi_block_requests holds off these commands when blocked like all other commands
4. All commands flow through one path rather than having a side door which allows
   you to send commands not only to the adapter but also the disks, if I read the code
   correctly.
5. No need to worry about host or device queue depths being exceeded


> Question:
> 
> Below I see a bunch of inputs regarding using netlink. 
> 
> For all driver to appl async events processing we chose SIGIO approach 
> followed by an ioctl to collect the data from driver. 
> 
> Is it okay if we stick to SIGIO way or should we change it to netlink?

The part that looks ugly with the SIGIO implementation to me is the fact
that you have the 5 second delay after an AEN occurs, waiting for the user
applications to read the buffer. In my experience delays like this often cause
problems. If the system is very heavily loaded 5 seconds may not be long enough.
Knowing the best time to use is always the tricky part. 

Using an interface like netlink would allow you to just fire the data off
to userspace and forget about it. Any applications registered to receive
the notifications would receive them and the driver would not need to care.

In the ipr driver I have a similar requirement, but don't actually send any data
back up to userspace. I simply generate a KOBJ_CHANGE kobject_uevent. The user space
apps then trigger on that to go figure out what changed. If you use kobject_uevent_env
you can also pass some data up to the application to make figuring this out easier.


>>> +static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
>>> +{
>>> +	struct scsi_cmnd *scsi_cmd = cmd->scsi_cmd;
>>> +	struct pmcraid_resource_entry *res = scsi_cmd->device->hostdata;
>>> +	struct pmcraid_instance *pinstance = cmd->drv_inst;
>>> +	struct pmcraid_ioasa *ioasa = &cmd->ioa_cb->ioasa;
>>> +	u32 ioasc = le32_to_cpu(ioasa->ioasc);
>>> +	u32 masked_ioasc = ioasc & PMCRAID_IOASC_SENSE_MASK;
>>> +
>>> +	if (!res) {
>>> +		pmcraid_info("resource pointer is NULL\n");
>>> +		return 0;
>>> +	}
>> There seems to be a fair amount of code here that runs without locks that reads
>> and writes shared data structures which has me concerned that you could have
>> some very hard to track down bugs in the future...
>>
> If you are refering to the above code(pmcraid_error_code), I don't see a 
> reason why need a lock here.

I guess I wasn't referring to this patch of code in particular, just speaking in
general. One example would be in the ioctl path. There you make a bunch of checks
of the state of the adapter without holding any locks, then proceed to build and
send the command. From the time you last check the state of the adapter to
the point where you actually send the command to the adapter you could have
taken an error interrupt and be in the process of resetting the adapter. Not sure
what happens if you issue an MMIO on this hardware while you are resetting it,
I know there is plenty of hardware that doesn't like this.


>>> +static ssize_t pmcraid_show_drv_version(
>>> +	struct device *dev,
>>> +	struct device_attribute *attr,
>>> +	char *buf
>>> +)
>>> +{
>>> +	return snprintf(buf, PAGE_SIZE, "version: %s, build date: %s\n",
>>> +			PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
>>> +}
>>> +
>>> +static struct device_attribute pmcraid_driver_version_attr = {
>>> +	.attr = {
>>> +		 .name = "drv_version",
>>> +		 .mode = S_IRUGO,
>>> +		 },
>>> +	.show = pmcraid_show_drv_version,
>> Should be able to just use MODULE_VERSION instead.
>>
> we just kept so that if somebody looks and wants to know. We have used 
> MODULE_VERSION also.

Since you are using MODULE_VERSION, this information is already available
in /sys/module/pmcraid/version, so this becomes redundant.


>>> +
>>> +#define PMCRAID_IOCTL_GET_DRIVER_STATISTICS  \
>>> +	DRV_IOCTL(3, _ARGSIZE(struct pmcraid_driver_statistics))
>> I would think this could be implemented with device and host sysfs
>> attributes instead.
>>
>>> +
>>> +#define PMCRAID_IOCTL_GET_ADAPTER_ID         \
>>> +	DRV_IOCTL(4, _ARGSIZE(union pmcraid_adapter_id))
>> A scsi host sysfs attribute should work here
>>
>>> +
>>> +#define PMCRAID_IOCTL_RESET_ADAPTER          \
>>> +	DRV_IOCTL(5, sizeof(struct pmcraid_ioctl_header))
>> A writable sysfs file should work for this
>>
> 
> Since our Appl needs this info thru IOCTLs we are using this.

The advantage of using sdev_attrs and shost_attrs for these
is that allows the information to be available to the user without
the need of special utilities. 

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


