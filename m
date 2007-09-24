From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 12:33:22 +0200
Message-ID: <200709241233.23028.oliver@neukum.org>
References: <200709181032.29864.oliver@neukum.org> <200709181615.46537.oliver@neukum.org> <1190125566.3375.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:39309 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753520AbXIXKcc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 06:32:32 -0400
In-Reply-To: <1190125566.3375.9.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

Am Dienstag 18 September 2007 schrieb James Bottomley:
> On Tue, 2007-09-18 at 16:15 +0200, Oliver Neukum wrote:
> > Am Dienstag 18 September 2007 schrieb James Bottomley:
> > > On Tue, 2007-09-18 at 10:32 +0200, Oliver Neukum wrote:
> > > > which function should a lldd call to make the scsi layer flush
> > > > a device's buffers and spin it down? Which kind of locking is
> > > > required?
> > > 
> > > Depends on the context. Is this for suspend? If so it's done
> > > automatically by the sd driver, but the device has to be marked for it
> > > in the manage_start_stop attributes.
> > 
> > It is for runtime power management. We've gotten a bug report about
> > a drive enclosure that doesn't properly park heads if the usb device is
> > simply suspended. Apparently it simply cuts power so the cache can
> > be lost, too.
> 
> But even for runtime, if you want to suspend the device, shouldn't you
> be calling the suspend methods in the device tree?

Very good question. It seems to that yes indeed, we should. But we don't
in case of autosuspend. We simply suspend the interfaces:

static int usb_suspend_both(struct usb_device *udev, pm_message_t msg)

[..]
	/* Suspend all the interfaces and then udev itself */
	if (udev->actconfig) {
		for (; i < udev->actconfig->desc.bNumInterfaces; i++) {
			intf = udev->actconfig->interface[i];
			status = usb_suspend_interface(intf, msg);
			if (status != 0)
				break;
		}
	}

without involving the driver core.

Is this a design bug?

	Regards
		Oliver
