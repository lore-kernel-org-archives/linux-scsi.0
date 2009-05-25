From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Mon, 25 May 2009 16:14:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905251555050.26833-100000@netrider.rowland.org>
References: <1243275596.2975.4.camel@poy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1243275596.2975.4.camel@poy>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 May 2009, Kay Sievers wrote:

> On Mon, 2009-05-25 at 11:49 -0400, Alan Stern wrote:
> > Since this appears to be a bug in the SCSI layer, let's add some SCSI
> > people to the CC: list.
> > 
> > To summarize the problem: The SCSI core tries to unregister a host 
> > while its sysfs directory is still non-empty because the target hasn't 
> > been unregistered yet.
> 
> > Can you provide more of the context?  I'd like to see the log starting 
> > from when these devices were first registered.
> 
> I was able to trigger it with a USB storage device only, connected to a
> hub, and I removed the hub from the host.

Okay, it's a long log dump, but useful.  Evidently the problem is
caused by the fact that scsi_target_reap() is called by
scsi_device_dev_release_usercontext() instead of by
__scsi_remove_device() (both functions in drivers/scsi/scsi_sysfs.c).

There's probably a reason for this, but I don't know what it is.  Maybe 
James can explain.

Alan Stern

