From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 17:35:46 +0100
Message-ID: <1333730146.2953.13.camel@dabdike>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org>
	  <4F7E0EBF.80407@cs.wisc.edu> <4F7EBD3A.8070509@redhat.com>
	 <1333725609.2953.12.camel@dabdike> <4F7F1687.9000309@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33775 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab2DFQfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 12:35:52 -0400
In-Reply-To: <4F7F1687.9000309@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On Fri, 2012-04-06 at 16:15 +0000, Bart Van Assche wrote:
> On 04/06/12 15:20, James Bottomley wrote:
> 
> > On Fri, 2012-04-06 at 11:54 +0200, Tomas Henzl wrote:
> >> I like this idea(try_module_get) it is easy/elegant and it is used in scsi_rescan_device,
> >> but a scan can take a lot of time and during that time the driver couldn't be removed.
> >> When a flag in scsi_remove_host is set then the scan can be cancelled, if the user 
> >> rmmods the driver.
> > 
> > This is my preferred solution too.  The rule for async stuff is either
> > cancel or wait and since we can't cancel, we need to ensure the wait by
> > holding the module until the async event has finished.
> > 
> > Since the whole of the host scan must complete, we need to hold the
> > module across that, but I bet we also need to hold it across user
> > triggered target scans as well.
> 
> 
> As far as I can see the queuecommand call in scsi_dispatch_cmd() can
> race with module removal - that call can be triggered while the host
> template is being unloaded. I'm not sure though what the best approach
> is to fix that race.

Um, it's a bit hard to see how.  It's not really possible to trigger
queuecommand except in the initial probe without an open device ... and
opening the device holds the module.

James


