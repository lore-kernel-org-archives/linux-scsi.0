From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Mon, 19 Jan 2004 14:30:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400C3E70.9040702@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:5277 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263125AbUASUbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 15:31:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:

Thanks for looking at the driver.

I removed all the includes that you suggested with the exception of:

> +#include <asm/processor.h>
> 
> Why do you need this one?

I need this for __is_processor and for defines like PV_NORTHSTAR. Look 
at the comment in ipr_invalid_adapter for an explanation.

> +#ifdef CONFIG_COMPAT
> +#include <linux/ioctl32.h>
> +#endif
> 
> Shouldn't hurt to include this unconditionally.

The reason I didn't is because the ioctl32 stuff is somewhat broken and 
should be fixed. We really need stubs for register_ioctl32_conversion 
and unregister_ioctl32_conversion when CONFIG_COMPAT is not defined. 
just haven't gotten around to submitting a patch for this yet.

> A single source-file driver shouldn't ever have non-static entry points.

Ok.

> You have lots of forward-declarations.  This is usually a sign of a bad
> source file structure as code reads much easier if functions called by another
> function are above them in the source.  Also there's some other strangeness
> in the code, e.g. modern drivers usually have the module_init/exit routines
> at the very end, before that the pci driver methods and objects, then the
> scsi host template and before it it's methods.

I'll get this cleaned up.

> +/**
> + * ipr_version_show - Show the driver version
> + * @dd:	device driver struct
> + * @buf:	buffer
> + * 
> + * Return value:
> + * 	number of bytes printed to buffer
> + **/
> +static ssize_t ipr_version_show(struct device_driver *dd, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", IPR_DRIVER_VERSION);
> +}
> +
> +static DRIVER_ATTR(version, S_IRUGO, ipr_version_show, NULL);
> 
> Please don't do this in sysfs.  We're still hoping for a MODULE_VERSION
> macro, but every driver crafting it's own version telling mechanism
> doesn't scale.

Would it be ok to rename the sysfs file to ipr_version so I have a way 
to get this information until a better way comes along?

> What about a MODULE_DESCRIPTION?

Added.

> +unsigned int ipr_ioctls[] =
> +{
> +	IPR_IOCTL_PASSTHRU,
> +	IPR_IOCTL_RUN_DIAGNOSTICS,
> +	IPR_IOCTL_DUMP_IOA,
> +	IPR_IOCTL_RESET_IOA,
> +	IPR_IOCTL_READ_DRIVER_CFG,
> +	IPR_IOCTL_WRITE_DRIVER_CFG,
> +	IPR_IOCTL_GET_BUS_CAPABILTIES,
> +	IPR_IOCTL_SET_BUS_ATTRIBUTES,
> +	IPR_IOCTL_GET_TRACE,
> +	IPR_IOCTL_RECLAIM_CACHE,
> +	IPR_IOCTL_QUERY_CONFIGURATION,
> +	IPR_IOCTL_UCODE_DOWNLOAD,
> +	IPR_IOCTL_CHANGE_ADAPTER_ASSIGNMENT
> +};
> 
> Please provide a brief explanation of every ioctl and why you need it as
> ioctl.  At least the GET_BUS_CAPABILTIES / SET_BUS_ATTRIBUTES seem to be
> better expressed in the transport sysfs API discussed on linux-scsi

IPR_IOCTL_READ_DRIVER_CFG, IPR_IOCTL_WRITE_DRIVER_CFG, 
IPR_IOCTL_RUN_DIAGNOSTICS, IPR_IOCTL_RESET_IOA, 
IPR_IOCTL_CHANGE_ADAPTER_ASSIGNMENT: these could be sysfs files.

IPR_IOCTL_PASSTHRU: Allows user space to build adapter/device commands 
to send to the adapter. This includes RAID configuration, cache recovery 
commands, etc. This ioctl allows me to push all the RAID configuration 
complexity into userspace.

IPR_IOCTL_RUN_DIAGNOSTICS: This one could be a sysfs file.

IPR_IOCTL_DUMP_IOA: This ioctl is called by a userspace daemon. When 
called, it goes to sleep and waits (interruptibly) for a severe adapter 
error to occur. When this happens, the driver "dumps" the adapter's 
memory. After the adapter is reset, the daemon wakes up and writes the 
dump file to the filesystem. The dump file is usually around 2-4Meg in 
size.

IPR_IOCTL_GET_TRACE: This returns the driver's internal trace. This one 
needs a buffer > 4k. I could create a binary sysfs file for it since, 
AFAIK, this size limitation does not exist for binary sysfs files.

IPR_IOCTL_RECLAIM_CACHE: This is used to perform cache storage 
reclaimation on the adapter. It takes parameters from userspace, sends a 
command to the adapter, resets the adapter, then returns data to the user.

IPR_IOCTL_UCODE_DOWNLOAD: Used to update the microcode on the adapter 
and on the physical disks in RAID arrays (these devices are not seen by 
the SCSI midlayer). These microcode images are generally between 500k 
and 1M in size.

Overall the issues I struggled with regarding removing all the IOCTLs 
stemmed from bidirectional data flow, and large amounts of data. sysfs 
does not seem to be able to accomplish this. One suggestion made to me 
was to create a filesystem to get this work done, but I'm not sure that 
would be any cleaner.

> +/**
> + * ipr_get_mode_page - Locate specified mode page
> + * @mode_pages:	mode page buffer
> + * @page_code:	page code to find
> + * @len:		minimum required length for mode page
> + *
> + * Return value:
> + * 	pointer to mode page / NULL on failure
> + **/
> +static void *ipr_get_mode_page(struct ipr_mode_pages *mode_pages,
> +			       u32 page_code, u32 len)
> 
> Okay, this isn't good at all.  A LLDD driver shouldn't care about mode
> pages and all the stuff you do with it.  Please do it from userspace using
> the sg driver.

Ok. Here are my reasons:

1. First of all, this driver is setting up mode pages for devices 
according to how the adapter requires them to be setup to run properly. 
Arguably, the adapter should do this, but it doesn't.

2. There are 2 types of devices that I setup mode pages for. The first 
are generic SCSI disk devices. These are seen by the mid-layer and could 
feasibly have their mode pages setup by userspace. But, the adapter 
requires qerr=1 in order to run TCQing. So I am setting that up. If I 
moved that into userspace, then I couldn't run TCQing until userspace 
setup mode page 0x0A. The other type of device is a physical disk in a 
RAID array. These devices are not seen by the mid-layer. The only way 
for userspace to talk to them (at least in the current implementation) 
is through the adapter ioctl interface discussed above. For these 
devices, the adapter requires the mode pages to be setup as I am doing 
in order to run reliably.

> +	spin_lock_init(&ipr_driver_lock);
> +	INIT_LIST_HEAD(&ipr_ioa_head);
> 
> These could be initialized at compile-time (but shouldn't be needed at all
> without the character devices)

Ok.

> +	ipr_regs = (unsigned long)ioremap(ipr_regs_pci,
> +					  pci_resource_len(pdev, 0));
> 
> You need to check the return value.

Ok.

> +/**
> + * ipr_scan_vsets - Scans for VSET devices
> + * @ioa_cfg:	ioa config struct
> + *
> + * Description: Since the VSET resources do not follow SAM in that we can have
> + * sparse LUNs with no LUN 0, we have to scan for these ourselves.
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_scan_vsets(struct ipr_ioa_cfg *ioa_cfg)
> +{
> +	int target, lun;
> +
> +	for (target = 0; target < IPR_MAX_NUM_TARGETS_PER_BUS; target++)
> +		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++ )
> +			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS, target, lun);
> +}
> 
> Can you explain what these vsets are supposed to do?  And why a scsi_scan quirk can't
> be done instead of doing this in a LLDD?

I was expecting this one;) VSET stands for Volume Set. A VSET is a 
logical disk created by the adapter firmware representing a disk array. 
The reason a scsi_scan quirk does not work is because they also do not 
have any reasonable product ID in their standard inquiry data to parse on.

> +/**
> + * ipr_inquiry - Send an Inquiry to the adapter.
> + * @ipr_cmd:	ipr command struct
> + *
> + * This utility function sends an inquiry to the adapter.
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_inquiry(struct ipr_cmnd *ipr_cmd, u8 flags, u8 page,
> +			u32 dma_addr, u8 xfer_len)
> 
> Doing inquiries from a LLDD looks very, very wrong.  Explanations please.

Ok. This particular inquiry is an inquiry to the adapter, not a device. 
However, I do inquiries to devices that are in disk arrays, but only 
because I need to (ipr_std_inquiry). This stems from the fact that the 
adapter will not start any new advanced function (RAID, adapter write 
caching, etc) to a device until it is told by the system that the device 
is a "supported device" by using the "set supported devices" command.

Complicated example: You have a RAID 5 disk array with n devices. One of 
them fails. You put in a replacement device of a different type. In 
order to be able to rebuild the disk array using the new device, the 
adapter needs to have a set supported devices command sent down with the 
vendor/product ID of the replacement device. An inquiry has to be done 
to get this data.

> +/**
> + * ipr_find_ses_entry - Find matching SES in SES table
> + * @res:	resource entry struct of SES
> + * 
> + * Return value:
> + * 	pointer to SES table entry / NULL on failure
> + **/
> 
> This is an extreme layering violation.  Any SES handling belongs into an
> upper level scsi driver (or userspace via sg)

I'm not actually talking to the SES, I'm only looking at the adapter's 
device configuration table. What I am trying to accomplish here is I am 
looking at each SCSI bus and trying to determine the max scsi speed that 
is safe to run on them. There are certain older backplanes that do not 
run reliably at faster speeds. Hence, the SES table.

> +/**
> + * ipr_do_req -  Send driver initiated requests.
> + * @ipr_cmd:		ipr command struct
> + * @done:			done function
> + * @timeout_func:	timeout function
> + * @timeout:		timeout value
> + *
> + * This function sends the specified command to the adapter with the
> + * timeout given. The done function is invoked on command completion.
> 
> This looks very wrong.  And fortunately it seems to be only called from
> code that is totally misplaced in a LLDD anyway.  All scsi commands
> should go through the midlayer queueing.

It is primarily used when talking to devices not known to the mid-layer, 
like the adapter itself, and devices that are in a disk array.

> +/**
> + * ipr_vset_stop_unit - Send a STOP UNIT to a VSET resource
> + * @ioa_cfg:	ioa config struct
> + * @res:		resource entry struct
> + *
> + * This function sends a STOP UNIT to a VSET resource to
> + * flush the write cache..
> + *
> + * Return value:
> + * 	IOASC of the command
> + **/
> 
> Again, a LLDD is the very wrong place for something like that.
> Is there a spec for that VSET stuff somewhere?

Unfortunately no. But I can answer any questions you might have. I 
wasn't sure if this was an ok thing to do or not. The midlayer is 
unconfiguring the device, it seemed reasonable that I should have the 
adapter flush the write cache and stop talking to that logical device.

> +/**
> + * ipr_send_cmd - Build and send a mid-layer command
> + * @ioa_cfg:	ioa config struct
> + * @scsi_cmd:	scsi command struct
> + * @res:		ipr resource entry
> + *
> + * Return value:
> + * 	0 on success / SCSI_MLQUEUE_HOST_BUSY if DMA mapping fails
> + **/
> +static int ipr_send_cmd(struct ipr_ioa_cfg *ioa_cfg,
> +			struct scsi_cmnd *scsi_cmd,
> +			struct ipr_resource_entry *res)
> +{
> +	struct ipr_cmnd *ipr_cmd;
> +	int rc = 0;
> +	void (*timeout_func) (struct scsi_cmnd *);
> +	int timeout;
> +	struct ipr_ioarcb *ioarcb;
> +
> +	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
> +	ioarcb = &ipr_cmd->ioarcb;
> +
> +	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
> 
> Can you explain the per-command list mess please?  In theory a properly
> written driver shouldn't need lists like that, just start a command in
> ->queuecommand if possible, else return an error and immediately call
> ->done when you're done with a scsi command.

The command transport for the adapter is like this:

Build a command in DMA'able host memory (struct ipr_ioarcb), write the 
PCI address to a register on the adapter, the adapter DMAs down the 
control block, executes the command, writes the 
ipr_ioarcb.host_response_handle in the command control block to the host 
request/response queue in host memory, and signals an interrupt.

Does that help at all?

> +	/*
> +	 * Double the timeout value to use as we will use the adapter
> +	 * as the primary timing mechanism
> +	 */
> +	timeout_func = (void (*)(struct scsi_cmnd *)) scsi_cmd->eh_timeout.function;
> +	timeout = scsi_cmd->timeout_per_command;
> +
> +	scsi_add_timer(scsi_cmd, timeout * IPR_TIMEOUT_MULTIPLIER, timeout_func);
> 
> Okay, another driver that would like hooks into the EH timer.  We should probabl
> better fix this correctly by adding a host method for it.

That would be wonderful.

> + **/
> +int ipr_queue(struct scsi_cmnd *scsi_cmd, void (*done) (struct scsi_cmnd *))
> 
> ipr_queuecommand would be a better name.
> 
> +
> +	/* xxx can I remove some of these checks? */
> +	if (unlikely(ioa_cfg->ioa_is_dead || !res || res->del_from_ml)) {
> +		memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +		scsi_cmd->result = (DID_NO_CONNECT << 16);
> +		scsi_cmd->scsi_done(scsi_cmd);
> +		return 0;
> +	}
> 
> this should be handled by the midlayer per-device and per-host state bits.

I didn't realize a LLD was allowed to modify these.

> +	rc = ipr_send_cmd(ioa_cfg, scsi_cmd, res);
> 
> merge this into the quecommand routine?

Sure.

> +int ipr_biosparam(struct scsi_device *scsi_device,
> +		  struct block_device *block_device,
> +		  sector_t capacity, int *parm)
> +{
> +	int heads, sectors, cylinders;
> +
> +	heads = 128;
> +	sectors = 32;
> +
> +	cylinders = (capacity / (128 * 32));
> 
> You need to use sector_div here to avoid blowing up on 32bit systems.

Will do.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

