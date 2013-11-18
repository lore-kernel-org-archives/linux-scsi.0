From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add "missing" sysfs attribute to scsi_device
 structure
Date: Mon, 18 Nov 2013 13:28:28 -0500
Message-ID: <1384799308.3839.25.camel@localhost.localdomain>
References: <1384794656-9449-1-git-send-email-emilne@redhat.com>
	 <1384796756.5985.3.camel@dabdike.int.hansenpartnership.com>
	 <1384797558.3839.19.camel@localhost.localdomain>
	 <1384798546.5985.7.camel@dabdike.int.hansenpartnership.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3KRS2b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 13:28:31 -0500
In-Reply-To: <1384798546.5985.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-11-18 at 10:15 -0800, James Bottomley wrote:
> On Mon, 2013-11-18 at 12:59 -0500, Ewan Milne wrote:
> > On Mon, 2013-11-18 at 09:45 -0800, James Bottomley wrote:
> > > On Mon, 2013-11-18 at 12:10 -0500, Ewan D. Milne wrote:
> > > > From: "Ewan D. Milne" <emilne@redhat.com>
> > > > 
> > > > This change adds a "missing" sysfs attribute to scsi_device
> > > > which is set when a previously scanned device no longer appears
> > > > in the REPORT LUNS inventory.
> > > 
> > > A sysfs parameter with time and external input dependent semantics
> > > really doesn't look like a good idea.  What is it you're trying to
> > > achieve that you can't achieve from userspace by watching for the
> > > events?
> > > 
> > > James
> > > 
> > > 
> > 
> > Ideally, one would like to remove SCSI LUNs that are no longer being
> > presented by the device.  The information about which LUNs are no
> > longer there could, I suppose, be obtained from userspace by sending
> > a REPORT LUNS command, but that is somewhat redundant because the
> > kernel will issue one anyway when it is instructed to scan the target
> > for new LUNs.  This patch just makes the information visible.
> 
> But that's the problem, it doesn't.  missing gets reset on every REPORT
> LUN, that makes the information potentially inaccurate, particularly if
> the device triggers multiple change events.
> 
> > Yes, the information is only valid at a point in time, but that is
> > true of REPORT LUNS any time it is used.  If the LUN inventory changes
> > again, there will be a new event generated that can be processed.
> > 
> > A udev event handler tell the kernel to scan for new LUNs, and then
> > potentially tell the kernel to delete scsi_devices that are now missing.
> 
> I don't see what's wrong with sending REPORT LUNS from user space and
> pruning devices that no longer exist.  You should probably do that
> before you trigger a REPORT LUN scan; that way anything that reappeared
> gets put back, so there's no chance of losing a LUN.

Well, yes, except that deleting it first and then (potentially)
re-adding it would leave a period of time when the LUN isn't there.
But, that's exactly what the target reported, so I guess that's OK.

I appreciate the feedback, I'll look at issuing REPORT LUNS from
userspace.

-Ewan

> 
> James
> 
> 


