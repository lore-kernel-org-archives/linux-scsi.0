From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 2/4] Introduce xen-scsifront module
Date: Tue, 29 Jul 2014 16:57:32 +0200
Message-ID: <53D7B65C.8030701@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>	<1406288253-13293-3-git-send-email-jgross@suse.com> <20140729135300.GA20415@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140729135300.GA20415@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On 07/29/2014 03:53 PM, Christoph Hellwig wrote:
>> + * Patched to support >2TB drives
>> + * 2010, Samuel Kvasnica, IMS Nanofabrication AG
>> + */
>
> This doesn't really belong into the top of the file comment and should
> be moved to the patch description.

Okay.

>> +
>> +#include <linux/version.h>
>
> not needed.

Okay.

>> +static int get_id_from_freelist(struct vscsifrnt_info *info)
>> +{
>> +	unsigned long flags;
>> +	uint32_t free;
>> +
>> +	spin_lock_irqsave(&info->shadow_lock, flags);
>> +
>> +	free = info->shadow_free;
>> +	BUG_ON(free >= VSCSIIF_MAX_REQS);
>> +	info->shadow_free = info->shadow[free].next_free;
>> +	info->shadow[free].next_free = VSCSIIF_MAX_REQS;
>> +	info->shadow[free].wait_reset = 0;
>> +
>> +	spin_unlock_irqrestore(&info->shadow_lock, flags);
>> +
>> +	return free;
>
> Is the shadow array exposed to the hypervisor?  If not it might be a
> better idea to just allocate the driver private data with the command
> by setting the cmd_size field in the host template.  Take a look
> at the virtio_scsi driver in recent kernels for an example.

Ah, okay. I'll still need an array for managing the request ids, but
this will be much smaller...

>> +static irqreturn_t scsifront_intr(int irq, void *dev_id)
>> +{
>> +	scsifront_notify_work((struct vscsifrnt_info *)dev_id);
>> +	return IRQ_HANDLED;
>
> Seems like you should simply use threaded interrupt handlers.  If that
> doesn't work for you at least this should use a workqueue instead of
> manually reimplementing it using a kthread.

A threaded interrupt handler seems to be a good idea. I'll check if it
is working.

>> +/* debug printk to identify more missing scsi commands
>> +	shost_printk(KERN_INFO "scsicmd: ", sc->device->host,
>> +		     "len=%u %#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x\n",
>> +		     sc->cmd_len, sc->cmnd[0], sc->cmnd[1],
>> +		     sc->cmnd[2], sc->cmnd[3], sc->cmnd[4], sc->cmnd[5],
>> +		     sc->cmnd[6], sc->cmnd[7], sc->cmnd[8], sc->cmnd[9]);
>> +*/
>
> We already have pretty good ways to debug this in the midlayer, I don't
> think this is needed.

Okay, I'll remove it.

>> +	spin_lock_irqsave(shost->host_lock, flags);
>
> What's actually protected by the host lock in this driver?  It has
> ample of driver-local locking, so avoiding to touch the host lock
> would be a clear win.

The host_lock protects the ring buffers used to communicate with Dom0.
I think this is the correct lock for this operation, as there is exactly
one such ring buffer pair for each host structure allocated in
scsifront_probe().

>> +	scsi_cmd_get_serial(shost, sc);
>
> What do you need the serial number for?  Generally only legacy drivers
> use it.

Historical reasons :-)
I'll remove it.

>> +static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
>> +{
>> +	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
>> +}
>
> The amount of waiting that your command abort handler does inside
> scsifront_action_handler looks wrong to me.  Can you explain the
> theory of operation for error handling in this driver?  How much
> of error recovery is supposed to be handled by the hypervisor,
> and much is supposed to be handle in the intiator side driver?

The initiator side just forwards the abort/reset request to Dom0
and waits for an answer (okay or error).

>> +static void scsifront_free(struct vscsifrnt_info *info)
>> +{
>> +	struct Scsi_Host *host = info->host;
>> +
>> +	if (host->shost_state != SHOST_DEL)
>> +		scsi_remove_host(info->host);
>
> A driver really shouldn't look at shost_state like this.  Is there some
> SCM history explaining where this comes from?

I'll investigate it. It was added soon after the first version was
available, but I haven't found a reason yet.

>> +		switch (op) {
>> +		case VSCSIFRONT_OP_ADD_LUN:
>> +			if (device_state == XenbusStateInitialised) {
>> +				sdev = scsi_device_lookup(info->host, chn, tgt,
>> +							  lun);
>> +				if (sdev) {
>> +					dev_err(&dev->dev,
>> +						"Device already in use.\n");
>> +					scsi_device_put(sdev);
>> +					xenbus_printf(XBT_NIL, dev->nodename,
>> +						      state_str, "%d",
>> +						      XenbusStateClosed);
>> +				} else {
>> +					scsi_add_device(info->host, chn, tgt,
>> +							lun);
>> +					xenbus_printf(XBT_NIL, dev->nodename,
>> +						      state_str, "%d",
>> +						      XenbusStateConnected);
>> +				}
>> +			}
>> +			break;
>
> scsi_add_device handles an already existing device just fine, and unlike
> this construct isn't racy.

Okay. I'll change it.


Juergen
