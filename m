From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi core: fix uninitialized variable error
Date: Sun, 5 Feb 2006 14:30:49 -0700
Message-ID: <20060205213049.GG16090@parisc-linux.org>
References: <20060205150133.GC16090@parisc-linux.org> <Pine.LNX.4.44L0.0602051107120.16521-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:4501 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750739AbWBEVav
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 16:30:51 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0602051107120.16521-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Feb 05, 2006 at 11:11:24AM -0500, Alan Stern wrote:
> > -	if (scsi_host_scan_allowed(shost)) {
> > -		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
> > -					     hostdata);
> > -		if (res != SCSI_SCAN_LUN_PRESENT)
> > -			sdev = ERR_PTR(-ENODEV);
> > -	}
> > +	if (scsi_host_scan_allowed(shost))
> > +		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
> >  	mutex_unlock(&shost->scan_mutex);
> 
> This assumes that scsi_probe_and_add_lun doesn't assign anything to the 
> &sdev pointer if it returns anything other than SCSI_SCAN_LUN_PRESENT.  
> Since that assumption is true for the current code, this version of the 
> patch will work as well as mine.

Perhaps the better way to think about this usage of
scsi_probe_and_add_lun() is "If it finds an sdev, then we should return
it".  Right now, we're assuming that returning SCSI_SCAN_LUN_PRESENT is
equivalent to having found an sdev.

The real problem is that scsi_probe_and_add_lun() has an enormously
complicated interface.  The good news is that it's static, so we can see
all its callers.  The bad news is that the kernel-doc comment is out of
date and not terribly helpful.

Its callers are:

scsi_sequential_lun_scan()
	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
		(!= SCSI_SCAN_LUN_PRESENT)
scsi_report_lun_scan()
	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
		(== SCSI_SCAN_NO_RESPONSE)
__scsi_add_device()
	scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata)
		(== SCSI_SCAN_LUN_PRESENT in current, unused in my patch)
__scsi_scan_target()
	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
		(unused)
	scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL)
		(== SCSI_SCAN_LUN_PRESENT or SCSI_SCAN_TARGET_PRESENT)

I can see some ways to simplify this interface.  As noted in a comment:

                 * XXX add a bflags to scsi_device, and replace the
                 * corresponding bit fields in scsi_device, so bflags
                 * need not be passed as an argument.

I *think* we can get rid of the hostdata parameter.  The only non-NULL
caller is __scsi_add_device().  The only caller of __scsi_add_device()
which specifies hostdata is i2o_scsi.  I don't see why it can't use a
->slave_alloc in the host template to set hostdata rather than passing
it in.

That'd get us down from a 6-argument function to a 4-argument one.  We
still have the problem of wanting to return multiple things (a SCSI_SCAN
constant in most cases and an sdev in another).  Maybe we could do something
like ERR_PTR/IS_ERR ...
