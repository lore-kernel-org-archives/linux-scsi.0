From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Sat, 29 Sep 2007 18:12:11 +0200
Message-ID: <200709291812.12225.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709291151030.29112-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:50586 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXI2QLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 12:11:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709291151030.29112-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Samstag 29 September 2007 schrieb Alan Stern:
> On Fri, 28 Sep 2007, Oliver Neukum wrote:
> 
> > Unless I am very mistaken, further down in storage_suspend, I call
> > 
> > +	/* In case of autosuspend device must be unblocked again */
> > +	if (us->pusb_dev->auto_pm) {
> > +err_unblock:
> > +		shost_for_each_device(sdev, host) {
> > +			if (sdev == sdev2) {
> > +				scsi_device_put(sdev);
> > +				break;
> > +			}
> > +			scsi_device_resume(sdev);
> > 
> > which again allows normal io, so the autoresume is triggered.
> > It may deadlock, you are right about that, but it is definitely triggered.
> > I verified that experimentally.
> 
> Yes, okay, sorry, I didn't read far enough into the patch.
> 
> Still, doesn't it seem peculiar that to implement autosuspend you have 
> to quiesce the device and then reactivate it?  In fact, it's not clear 
> why you want to call scsi_device_quiesce() in the first place.  The 
> fact that scsi_bus_suspend() does it isn't a good reason.

I can't have the buffers be dirtied after flushing them.

	Regards
		Oliver
