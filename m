From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi core: fix uninitialized variable error
Date: Sun, 5 Feb 2006 16:45:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602051634200.5858-100000@netrider.rowland.org>
References: <20060205213049.GG16090@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:42501 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1750745AbWBEVpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 16:45:18 -0500
In-Reply-To: <20060205213049.GG16090@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 5 Feb 2006, Matthew Wilcox wrote:

> Perhaps the better way to think about this usage of
> scsi_probe_and_add_lun() is "If it finds an sdev, then we should return
> it".  Right now, we're assuming that returning SCSI_SCAN_LUN_PRESENT is
> equivalent to having found an sdev.
> 
> The real problem is that scsi_probe_and_add_lun() has an enormously
> complicated interface.  The good news is that it's static, so we can see
> all its callers.  The bad news is that the kernel-doc comment is out of
> date and not terribly helpful.
> 
> Its callers are:
> 
> scsi_sequential_lun_scan()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(!= SCSI_SCAN_LUN_PRESENT)
> scsi_report_lun_scan()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(== SCSI_SCAN_NO_RESPONSE)
> __scsi_add_device()
> 	scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata)
> 		(== SCSI_SCAN_LUN_PRESENT in current, unused in my patch)
> __scsi_scan_target()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(unused)
> 	scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL)
> 		(== SCSI_SCAN_LUN_PRESENT or SCSI_SCAN_TARGET_PRESENT)
> 
> I can see some ways to simplify this interface.  As noted in a comment:
> 
>                  * XXX add a bflags to scsi_device, and replace the
>                  * corresponding bit fields in scsi_device, so bflags
>                  * need not be passed as an argument.
> 
> I *think* we can get rid of the hostdata parameter.  The only non-NULL
> caller is __scsi_add_device().  The only caller of __scsi_add_device()
> which specifies hostdata is i2o_scsi.  I don't see why it can't use a
> ->slave_alloc in the host template to set hostdata rather than passing
> it in.
> 
> That'd get us down from a 6-argument function to a 4-argument one.  We
> still have the problem of wanting to return multiple things (a SCSI_SCAN
> constant in most cases and an sdev in another).  Maybe we could do something
> like ERR_PTR/IS_ERR ...

That sounds good to me.  It looks like the possible responses fall into 
three classes: LUN present (and return the sdev pointer), LUN not present 
but target present (needs an ERR_PTR value), and no response (simply 
return NULL).  If you want to write those changes, I'll endorse it.

The whole bflags thing is badly in need of updating.  There really should
be a bflags field in the sdev structure, so that the flags can be tailored
for individual devices instead of using a common blacklist entry.  There
already _is_ a similar field in the target structure, although it's not
used for much.  And there already are a number of bitfields in the sdev
structure to hold information which should exist in a single bflags field
-- in effect, people have already started moving the flags into the sdev
but have done it piecemeal.  Of course, this is a separate issue from
scsi_probe_and_add_lun.

Alan Stern

