From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 12:05:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080925518.1830.93.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com>
	<1080921450.1804.66.camel@mulgrave>  <20040402164531.GB3880@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30106 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264109AbUDBRFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 12:05:54 -0500
In-Reply-To: <20040402164531.GB3880@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

On Fri, 2004-04-02 at 11:45, Mike Anderson wrote:
> Maybe some clarification here as I am unsure if we both think there
> needs to be a notification (a put call) from outside SCSI. We have
> release functions available on most objects in SCSI now. The issue is
> that when we register (add_disk, dev_set_drvdata, etc.) or pass a handle
> to another subsystem we need a reference count agreement to know when
> the other subsystem is done with the the object. Something like the
> put_device(parent) used in scsi_host_dev_release.

Actually, no, that's not the issue here, if I understand you.  The
reference counting model on the sdev->sdev_gendev seems to be working
correctly because sr.c takes a reference to the sdev_gendev on open and
drops it on close.

The problem is that ULDs are implemented as struct device_drivers and as
such, their ->remove method gets called *not* on last put of sdev_gendev
but on device_del (when there are still active references).

sr.c frees the cdinfo structure on ->remove, but still has its own
reference to sdev_gendev (because the device is still open). On final
close, the generic cdrom code tries to use cdinfo to close the device
and references a kfree'd structure.  Really what sr.c wants to be doing
is freeing the cdinfo structure on last put, not on device_del.

James


