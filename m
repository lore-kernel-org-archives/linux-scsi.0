From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Fri, 2 Apr 2004 08:45:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402164531.GB3880@us.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com> <1080921450.1804.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 130-94-160-149-dsl.hevanet.com ([130.94.160.149]:10880 "EHLO
	hmsbounty.us.ibm.com") by vger.kernel.org with ESMTP
	id S264105AbUDBQpi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 11:45:38 -0500
Content-Disposition: inline
In-Reply-To: <1080921450.1804.66.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

James Bottomley [James.Bottomley@steeleye.com] wrote:
> > Recently I have not been spending the proper time looking at this, but
> > last look it appeared that we needed to  add a release / put method call
> > to the gendisk disk_release routine. The release function or object to do
> > the put on would need to be set prior to the call to add_disk.
> 
> Actually, I can't believe this problem to be local entirely to SCSI. 
> So, a simpler mechanism (and more globally useful) might be to have a
> two phase driver release in sysfs:

I would agree this should be more general than SCSI, but if kobjects are
being passed during the registration / setup in other subsystem
interfaces than this could already be handled.

> 
> - the current ->remove would stay where it is (as a notify on
> device_del).  On receving this the driver begins clean up enough to drop
> any internal references to the device it is holding.
> - then introduce a ->release which is called as part of dropping the
> last device reference where the driver cleans up any resources the
> driver was keeping to service the removed but not released device.
> 
> Then, we'd obviously not call unregister_cdrom and kfree the scsi_cd
> structure until ->release time.

Maybe some clarification here as I am unsure if we both think there
needs to be a notification (a put call) from outside SCSI. We have
release functions available on most objects in SCSI now. The issue is
that when we register (add_disk, dev_set_drvdata, etc.) or pass a handle
to another subsystem we need a reference count agreement to know when
the other subsystem is done with the the object. Something like the
put_device(parent) used in scsi_host_dev_release.

-andmike
--
Michael Anderson
andmike@us.ibm.com

