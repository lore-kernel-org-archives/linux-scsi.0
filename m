From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: Fix NULL pointer dereference in runtime PM
Date: Mon, 7 Sep 2015 10:48:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1509071039430.32284-100000@netrider.rowland.org>
References: <4AC89B18A26BAB43B540DB1C94E2802C0921FF70@scybexdag03.amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50678 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752637AbbIGOsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2015 10:48:23 -0400
In-Reply-To: <4AC89B18A26BAB43B540DB1C94E2802C0921FF70@scybexdag03.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Xue, Ken" <Ken.Xue@amd.com>
Cc: "JBottomley@Odin.com" <JBottomley@Odin.com>, "Huang, Shane" <Shane.Huang@amd.com>, "Yu, Xiangliang" <Xiangliang.Yu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 7 Sep 2015, Xue, Ken wrote:

> Hi Alan and James,
> I found a bug about sr device runtime suspend & resume which is introduced by your patch about fixing NULL pointer dereference in runtime PM.
> You know that sr device only has runtime suspend routine but doesn't have resume routine.
> After your patch, blk_ *_ runtime_suspend  will be called when runtime suspend. But blk_ *_ runtime_resume cannot be called when resume.
> So, sr device cannot work correctly after 1st runtime suspend.

Argh.  Things just get more and more complicated...

> I want to make a dummy runtime resume routine in sr.c for fixing this runtime issue of sr device.
> If you guys think a dummy runtime routine for resume is acceptable, I can submit patch later.

A dummy routine isn't the greatest solution.  Eventually someone will 
see it, wonder why it's there, and remove it.

The real issue we need to address here is whether the driver has asked
for request-queue-oriented runtime PM by calling blk_pm_runtime_init().  
If it hasn't then we need to skip at least the calls to
blk_{pre|post}_runtime_{suspend|resume}.

The patch I wrote uses the existence of runtime-PM callbacks as an 
indicator for this, but evidently it isn't adequate.  A more direct 
approach would be to test whether sdev->request_queue->dev is non-NULL, 
but this would be a layering violation.

Should we add a SCSI-level flag to indicate that blk_pm_runtime_init() 
has been called?

Alan Stern

