From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: JMS56x not working reliably with uas driver
Date: Fri, 23 Dec 2016 09:22:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1612230918500.31927-100000@netrider.rowland.org>
References: <64608b5d-e90f-3839-eb80-7e3cd042a887@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:42989 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S936747AbcLWOWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2016 09:22:36 -0500
In-Reply-To: <64608b5d-e90f-3839-eb80-7e3cd042a887@caviumnetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Cc: oneukum@suse.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, hdegoede@redhat.com

On Fri, 23 Dec 2016, George Cherian wrote:

> >> 2) On disconnect I am seeing the following issue
> >>
> >>    scsi host4: uas_post_reset: alloc streams error -19 after reset
> >>    sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> >>
> >> This is more fatal because after these messages the USB port becomes
> >> unusable. Even an lsusb invocation hangs for ever.
> > This problem looks pretty simple.  uas doesn't check properly to see if
> > the device was disconnected following a reset.
> >
> > Try changing the line in uas_post_reset() that says:
> >
> > 	if (devinfo->shutdown)
> >
> > to:
> >
> > 	if (devinfo->shutdown ||
> > 			devinfo->udev->state == USB_STATE_NOTATTACHED)
> Yes this works for me but with a little bit change as follows, But am 
> not sure whether we should goto reset_scsi in case of shutdown.
> Please advice.
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 5ef014b..24db3fd 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1072,8 +1072,8 @@ static int uas_post_reset(struct usb_interface *intf)
>          unsigned long flags;
>          int err;
> 
> -       if (devinfo->shutdown)
> -               return 0;
> +       if (devinfo->shutdown || devinfo->udev->state == 
> USB_STATE_NOTATTACHED)
> +               goto reset_scsi;
> 
>          err = uas_configure_endpoints(devinfo);
>          if (err) {
> @@ -1083,6 +1083,7 @@ static int uas_post_reset(struct usb_interface *intf)
>                  return 1;
>          }
> 
> +reset_scsi:
>          spin_lock_irqsave(shost->host_lock, flags);
>          scsi_report_bus_reset(shost, 0);
>          spin_unlock_irqrestore(shost->host_lock, flags);

As far as I can tell, adding the "goto reset_scsi" line does not help 
at all.  There's no reason to report that the bus has been reset after 
the device is gone.

Alan Stern

