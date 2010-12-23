From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH (trivial) 2/2] SCSI: simplify scsi_remove_target()
Date: Thu, 23 Dec 2010 09:19:34 -0600
Message-ID: <1293117574.3029.1.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1011151603300.1370-100000@iolanthe.rowland.org>
	 <alpine.LNX.2.00.1012221220560.16569@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0LWPTj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2010 10:19:39 -0500
In-Reply-To: <alpine.LNX.2.00.1012221220560.16569@pobox.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2010-12-22 at 12:21 +0100, Jiri Kosina wrote:
> On Mon, 15 Nov 2010, Alan Stern wrote:
> 
> > This trivial patch (as1340) eliminates an unnecessary local variable
> > from scsi_remove_target().
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > ---
> > 
> > Index: usb-2.6/drivers/scsi/scsi_sysfs.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
> > +++ usb-2.6/drivers/scsi/scsi_sysfs.c
> > @@ -1020,16 +1020,14 @@ static int __remove_child (struct device
> >   */
> >  void scsi_remove_target(struct device *dev)
> >  {
> > -	struct device *rdev;
> > -
> >  	if (scsi_is_target_device(dev)) {
> >  		__scsi_remove_target(to_scsi_target(dev));
> >  		return;
> >  	}
> >  
> > -	rdev = get_device(dev);
> > +	get_device(dev);
> >  	device_for_each_child(dev, NULL, __remove_child);
> > -	put_device(rdev);
> > +	put_device(dev);
> >  }
> >  EXPORT_SYMBOL(scsi_remove_target);
> 
> The code seems to be reshuffled a little bit in -next, so this'd better go 
> through SCSI tree to avoid unnecessary conflicts between trees in next.
> 
> James, are you going to pick it up?

I've got it in my queue ... it depends how much more trouble we get
integrating driver patches (and the tightness of the merge window
deadline, since some people suspect a christmas release).

James


