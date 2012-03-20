From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/4] libfcoe: Add fcoe_sysfs
Date: Tue, 20 Mar 2012 14:01:50 -0700
Message-ID: <20120320210150.GA18136@kroah.com>
References: <20120316193640.5369.56932.stgit@localhost6.localdomain6>
 <20120316193656.5369.47569.stgit@localhost6.localdomain6>
 <20120317002517.GA22430@kroah.com>
 <4F63E4E9.2010504@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62362 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2CTVB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 17:01:56 -0400
Received: by dajr28 with SMTP id r28so511879daj.19
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2012 14:01:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F63E4E9.2010504@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "bprakash@broadcom.com" <bprakash@broadcom.com>

On Sat, Mar 17, 2012 at 01:12:10AM +0000, Love, Robert W wrote:
> >> +	ctlr->f = f;
> >> +	INIT_LIST_HEAD(&ctlr->fcfs);
> >> +	mutex_init(&ctlr->lock);
> >> +	device_initialize(&ctlr->dev);
> >> +	ctlr->dev.parent = get_device(parent);
> > I thought you dropped these get_device() calls on the parent?  The
> > driver core handles this for you, please don't do it here, it's not
> > needed.
> 
> How would the driver core know what this device's parent is? This is the 
> only place I do that assignment.

I'm not saying that assigning the parent is wrong, I'm saying you don't
need to grab the reference to the parent here.

The code should just be:
	ctrl->dev.parent = parent;

When you register the device, the parent will be properly reference
counted.

thanks,

greg k-h
