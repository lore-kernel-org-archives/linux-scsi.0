From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Wed, 03 Feb 2016 14:55:10 -0800
Message-ID: <1454540110.2338.14.camel@HansenPartnership.com>
References: <568FE922.9090004@sandisk.com>
	 <yq1oachqehs.fsf@sermon.lab.mkp.net>
	 <1453251809.2320.56.camel@HansenPartnership.com>
	 <56B025E4.9010009@sandisk.com>
	 <1454413585.2349.11.camel@HansenPartnership.com>
	 <20160203233816.00004da7@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56670 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbcBCWzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 17:55:12 -0500
In-Reply-To: <20160203233816.00004da7@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-02-03 at 23:38 +0100, Sebastian Herbszt wrote:
> James Bottomley wrote:
> > On Mon, 2016-02-01 at 19:43 -0800, Bart Van Assche wrote:
> > > On 01/19/16 17:03, James Bottomley wrote:
> > > > On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
> > > > > > > > > > "Bart" == Bart Van Assche <
> > > > > > > > > > bart.vanassche@sandisk.com>
> > > > > > > > > > writes:
> > > > > 
> > > > > Bart> Instead of representing the states "visible in sysfs"
> > > > > and
> > > > > "has
> > > > > Bart> been removed from the target list" by a single state
> > > > > variable,
> > > > > use
> > > > > Bart> two variables to represent this information.
> > > > > 
> > > > > James: Are you happy with the latest iteration of this?
> > > > > Should I
> > > > > queue
> > > > > it?
> > > > 
> > > > Well, I'm OK with the patch: it's a simple transformation of
> > > > the
> > > > enumerated state to a two bit state.  What I can't see is how
> > > > it
> > > > fixes
> > > > any soft lockup.
> > > > 
> > > > The only change from the current workflow is that the DEL
> > > > transition
> > > > (now the reaped flag) is done before the spin lock is dropped
> > > > which
> > > > would fix a tiny window for two threads both trying to remove
> > > > the
> > > > same
> > > > target, but there's nothing that could possibly fix an
> > > > iterative
> > > > soft
> > > > lockup caused by restarting the loop, which is what the
> > > > changelog
> > > > says.
> > > 
> > > Hello James,
> > > 
> > > scsi_remove_target() doesn't lock the scan_mutex which means that
> > > concurrent SCSI scanning activity is not prohibited. Such
> > > scanning 
> > > activity can postpone the transition of the state of a SCSI
> > > target 
> > > into STARGET_DEL. I think if the scheduler decides to run the
> > > thread 
> > > that executes scsi_remove_target() on the same CPU as the
> > > scanning 
> > > code after the scanning code has obtained a reap ref and before
> > > the 
> > > scanning code has released the reap ref again that the soft
> > > lockup 
> > > can be triggered that has been reported by Sebastian Herbszt.
> > 
> > OK, I finally understand the scenario;  I'm not sure I understand
> > how
> > we're getting concurrent scanning and removal from a simple rmmod
> > ... I
> > take it this is insmod rmmod in a tight loop?
> 
> I am able to trigger the soft lockup with this test case run once:
> 
> modprobe lpfc
> run fio for 10 seconds
> rmmod lpfc
> 
> My test setup involves running qla2xxx in target mode (SCST) and
> lpfc as initiator on the same system with one exported volume.

Hm, that doesn't seem to involve scanning colliding with removal. 
 Probably something else is pinning the target for some reason ...
unless there's some instability or constant change on the FC fabric
itself?  FC is hotplug, so if devices continually appear and disappear,
they'd effectively cause a scan of the added device to take place even
during the rmmod.

Anyway, does the last_scan patch fix the issue?

James


> Dick, how did you trigger the lockup?
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

