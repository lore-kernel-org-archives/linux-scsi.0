From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 3 Nov 2011 12:08:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1111031205470.2136-100000@iolanthe.rowland.org>
References: <CAOS58YN1WByGtr1MNH12vbPVa-vyWa-LiHYgMWSJt1WbfK-vtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47212 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933739Ab1KCQIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 12:08:54 -0400
In-Reply-To: <CAOS58YN1WByGtr1MNH12vbPVa-vyWa-LiHYgMWSJt1WbfK-vtw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>

On Thu, 3 Nov 2011, Tejun Heo wrote:

> Hello,
> 
> On Thu, Nov 3, 2011 at 8:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> I don't know. I haven't really thought about it but as it's currently
> >> designed, I don't think it'll be possible to avoid going through EH to
> >> put ATA ports into suspend mode.
> >
> > Why not?
> 
> It's just how things are designed now.  There's no reason why it's
> fundamentally impossible but going around that would require some
> amount of hackery or preferably re-design.  Synchronization against
> command processing, interrupts and all are built around EH.

Then it sounds like the best idea is something like what Ming proposed 
earlier: Have the error handler make some sort of test to determine 
whether it has been invoked for suspend/resume handling, and skip the 
runtime-PM calls on the host if it has.

This new test, whatever it is, should apply both to system suspend and 
runtime suspend.  By the way, what would happen if a system suspend 
occurred while the ATA port was already runtime-suspended?

Alan Stern

