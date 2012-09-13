From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 12:16:33 +0200
Message-ID: <39641980.Xo4Ylv7ahU@linux-lqwf.site>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com> <5051A25F.7040704@intel.com> <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab2IMKSF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2012 06:18:05 -0400
In-Reply-To: <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On Thursday 13 September 2012 10:26:44 James Bottomley wrote:
> On Thu, 2012-09-13 at 17:07 +0800, Aaron Lu wrote:

> > So I think this is basically 2 things, one is the runtime suspend of the
> > disk, another is when it is runtime suspended, how to remove its power.
> > I'm currently doing the latter one, which is simpler, so I want to do it
> > first :-)
> 
> Well, I don't like the way the interaction of the patches is going.
> You're the one proposing powering down the device outside of the
> standards defined transitions, so you need to be responsible for the
> actions that necessitates, including synchronizing the cache.  The specs
> (SPC-4) say that cache management is explicitly unnecessary for the
> standard SCSI power states (Active, Idle, Standby and Stopped), so
> someone at some point is going to read that and remove the unnecessary
> cache sync in the code.  When that happens, you'll start getting data
> loss.

The cache is handled identically in sd_suspend() and sd_shutdown().
In fact sd_shutdown() will skip handling it if the device has already been
suspended, so the assumption is built into the code and has been so
for a long time.

Though it wouldn't hurt to add a comment that says that the system going
to S3 or S4 will cut power to a lot of disk so that the cache needs to be synced
even if the spec says we need not. Runtime PM doesn't much alter the
situation.

	Regards
		Oliver

