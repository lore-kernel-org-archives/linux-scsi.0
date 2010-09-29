From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 20:54:13 -0400
Message-ID: <20100929005413.GB4689@linux.intel.com>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com>
 <1285668896-6356-2-git-send-email-willy@linux.intel.com>
 <201009281513.53869.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0I2Ay1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 20:54:27 -0400
Content-Disposition: inline
In-Reply-To: <201009281513.53869.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>


[Could you trim a little when replying?]

On Tue, Sep 28, 2010 at 03:13:53PM +0200, Oliver Neukum wrote:
> Am Dienstag, 28. September 2010, 12:14:56 schrieb Matthew Wilcox:
> > +static void uas_do_work(struct work_struct *work)
> > +{
> > +	struct uas_cmd_info *cmdinfo;
> > +	struct list_head list;
> > +
> > +	spin_lock_irq(&uas_work_lock);
> > +	list_replace_init(&uas_work_list, &list);
> > +	spin_unlock_irq(&uas_work_lock);
> > +
> > +	list_for_each_entry(cmdinfo, &list, list) {
> > +		struct scsi_pointer *scp = (void *)cmdinfo;
> > +		struct scsi_cmnd *cmnd = container_of(scp,
> > +							struct scsi_cmnd, SCp);
> > +		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
> 
> Deadlocky, use GFP_NOIO

ACK.  I thought I'd fixed this already.

> > +static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
> > +{
> > +	struct sense_iu *sense_iu = urb->transfer_buffer;
> > +	struct scsi_device *sdev = cmnd->device;
> > +
> > +	if (urb->actual_length > 16) {
> > +		unsigned len = be16_to_cpup(&sense_iu->len);
> > +		if (len + 16 != urb->actual_length) {
> > +			int newlen = min(len + 16, urb->actual_length) - 16;
> > +			if (newlen < 0)
> > +				newlen = 0;
> > +			sdev_printk(KERN_INFO, sdev, "%s: urb length %d "
> > +				"disagrees with IU sense data length %d, "
> > +				"using %d bytes of sense data\n", __func__,
> > +					urb->actual_length, len, newlen);
> > +			len = newlen;
> > +		}
> > +		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
> > +	}
> > +
> > +	cmnd->result = sense_iu->status;
> > +	if (sdev->current_cmnd)
> > +		sdev->current_cmnd = NULL;
> 
> the condition is absolutely senseless

That's not true.  Avoiding dirtying a cacheline is important for
performance.

> > +static void uas_stat_cmplt(struct urb *urb)
> > +{
> > +	struct iu *iu = urb->transfer_buffer;
> > +	struct scsi_device *sdev = urb->context;
> > +	struct uas_dev_info *devinfo = sdev->hostdata;
> > +	struct scsi_cmnd *cmnd;
> > +	u16 tag;
> > +
> > +	if (urb->status) {
> > +		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
> > +		usb_free_urb(urb);
> > +		return;
> > +	}
> > +
> > +	tag = be16_to_cpup(&iu->tag) - 1;
> > +	if (sdev->current_cmnd)
> > +		cmnd = sdev->current_cmnd;
> > +	else
> > +		cmnd = scsi_find_tag(sdev, tag);
> > +	if (!cmnd)
> > +		return;
> 
> Where is the URB freed?

Good point.  Will fix.

> > +static int uas_pre_reset(struct usb_interface *intf)
> > +{
> > +/* XXX: Need to return 1 if it's not our device in error handling */
> > +	return 0;
> > +}
> 
> You should probably make sure that no further commands are
> queued from this point on.

Yeah, there's a whole bunch of problems around error handling.

> > +static void uas_disconnect(struct usb_interface *intf)
> > +{
> > +	struct usb_device *udev = interface_to_usbdev(intf);
> > +	struct usb_host_endpoint *eps[3];
> > +	struct Scsi_Host *shost = usb_get_intfdata(intf);
> > +	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
> > +
> > +	scsi_remove_host(shost);
> > +
> > +	eps[0] = usb_pipe_endpoint(udev, devinfo->status_pipe);
> > +	eps[1] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
> > +	eps[2] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
> > +	usb_free_streams(intf, eps, 3, GFP_KERNEL);
> 
> This implies that this can fail due to a lack of memory.
> Then what?

Uhh.  I think I'll have to get Sarah to answer that question.  We probably
end up resetting the endpoints instead of telling the endpoint to stop
doing streams.


Thanks for the review.
