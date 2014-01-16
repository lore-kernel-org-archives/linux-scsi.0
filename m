From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 15:08:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401161505470.1109-100000@iolanthe.rowland.org>
References: <52D8275E.5060100@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751333AbaAPUIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 15:08:22 -0500
In-Reply-To: <52D8275E.5060100@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 16 Jan 2014, Phillip Susi wrote:

> On 1/16/2014 11:59 AM, Alan Stern wrote:
> > Since the START-STOP and TEST UNIT READY (or REQUEST SENSE or
> > whatever) commands are likely to take a long time, they should all
> > be carried out asynchronously with respect to the resume procedure.
> > I don't know what the best way is to implement this.  But it is
> > important to guarantee that in the RPM_ACTIVE case, the START-STOP
> > command gets sent to the disk before any other commands.  (This
> > isn't an issue in the RPM_SUSPENDED case, as the block layer will
> > prevent requests being sent out unless they have the REQ_PM flag
> > set.)
> 
> We could avoid that problem by having the resume_early issue the start
> command any time it leaves it in RPM_ACTIVE.

I don't see any advantage over issuing the start command in the resume 
callback.  Basically, the only difference between resume_early and 
resume is that runtime PM is disabled during resume_early.

Alan Stern

