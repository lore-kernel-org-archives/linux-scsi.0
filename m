From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 16:20:09 +0100
Message-ID: <1333725609.2953.12.camel@dabdike>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>
	 <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33607 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab2DFPUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 11:20:15 -0400
In-Reply-To: <4F7EBD3A.8070509@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On Fri, 2012-04-06 at 11:54 +0200, Tomas Henzl wrote:
> > Tomas's bug occurs when drivers use scsi_scan_host, use the async scsi
> > device scanning, and then rmmod the LLD while the scan is still in progress.
> >
> > I think a general problem that we might hit similar to Tomas's issue is
> > when scanning from userspace then rmmoding the driver. Maybe that means
> > we need a more generic fix? Or, maybe that could be handled by having
> > scsi_scan() do a try_module_get before scanning.
> I like this idea(try_module_get) it is easy/elegant and it is used in scsi_rescan_device,
> but a scan can take a lot of time and during that time the driver couldn't be removed.
> When a flag in scsi_remove_host is set then the scan can be cancelled, if the user 
> rmmods the driver.

This is my preferred solution too.  The rule for async stuff is either
cancel or wait and since we can't cancel, we need to ensure the wait by
holding the module until the async event has finished.

Since the whole of the host scan must complete, we need to hold the
module across that, but I bet we also need to hold it across user
triggered target scans as well.

James


