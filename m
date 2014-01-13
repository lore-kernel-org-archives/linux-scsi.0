From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Mon, 13 Jan 2014 15:30:26 -0800
Message-ID: <20140113233026.GA3200@linux.intel.com>
References: <20140108005607.GB29556@linux.intel.com>
 <20140111191315.GC3257@mtj.dyndns.org>
 <20140113195544.GA13900@linux.intel.com>
 <20140113203007.GA3480@mtj.dyndns.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbaAMXbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 18:31:51 -0500
Content-Disposition: inline
In-Reply-To: <20140113203007.GA3480@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, rjw@rjwysocki.net

On Mon, Jan 13, 2014 at 03:30:07PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 13, 2014 at 11:55:44AM -0800, Todd E Brandt wrote:
> > I see your point, why have two paths if one will do. The only thing that
> > worries me is that the PM resume from hibernate function doesn't have
> > an error handler. What happens when it tries to read the image from swap
> > and the disk is still spinning up? The scsi layer has an error handler so
> 
> The request gets blocked on EH.
> 
> > it just keeps retrying every few seconds, but the PM core reads directly
> > from the swap disk's block device.
> 
> Why would that matter?  Resume is handled by EH.  While EH is in
> progress, all commands are blocked.  Am I missing something?

No, I am. You're right, there shouldn't be an issue. I'm just sketchy about
new changes that I haven't tested. Lemme code up the change and do some
stress testing to be sure there are no issues.

> 
> > > So, can't just everything become async?  Are there cases where we
> > > *need* synchronous PM behaviors?
> > 
> > I think suspend still needs to be synchronous, because the PM core needs
> > to be sure that the disks are actually spun down before it can attempt
> > to shut the system down. I'm adding Raphael to the thread. Raphael, is 
> > this correct?
> 
> Yeah, we definitely should wait for suspend to complete before
> entering suspend state.  I was referring to the resume path.

Ahh, sorry, yea I think async should work for the entire resume pathway. Would
you be willing to accept this ata patch separately from the scsi one? It
wouldn't provide any performance benefit on its own, but would pave the way
for performance benefit by removing the ATA resume lag time (Which would then
put the ball in the scsi layer's court to finish the optimization). I've 
tested both patches separately and both work without issue. Also, this patch
appears to be a pre-requisite to both mine and Phillip Susi's solution, so 
it would really hope move things along regardless of which direction is
ultimately chosen in the SCSI layer.

> 
> Thanks.
> 
> -- 
> tejun
