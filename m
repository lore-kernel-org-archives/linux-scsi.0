From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] ZAC host-aware device support
Date: Mon, 03 Aug 2015 08:31:42 -0700
Message-ID: <1438615902.2173.14.camel@HansenPartnership.com>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
	 <1438531870.2182.23.camel@HansenPartnership.com> <55BF1749.8090606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <55BF1749.8090606@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-08-03 at 09:24 +0200, Hannes Reinecke wrote:
> On 08/02/2015 06:11 PM, James Bottomley wrote:
> > On Fri, 2015-07-31 at 15:02 +0200, Hannes Reinecke wrote:
> >> Hi all,
> >>
> >> here is a patchset for adding ZAC host-aware device support to libata.
> >> Main bits are translations for ZBC IN and ZBC OUT; others are the
> >> required plumbing like generating the correct VPD pages.
> >> James, do you require a separate patch for adding ZBC IN and ZBC OUT
> >> or is it okay to have it queued here?
> > 
> > This really belongs in the ZBC patch set, doesn't it? Why isn't it
> > there.  You can't avoid the dependency.  If it goes with the ZAC patch
> > set, then the ZBC one depends on ZAC.  If it goes properly with ZBC then
> > you need an additional patch adding the ATA translations after the ZBC
> > one.  On the whole, I'd prefer the latter so we always have the required
> > consumers of the API.
> > 
> > In fact, if I read the dependencies correctly, you need the ZBC patches
> > first, don't you ... otherwise there's nothing to drive host aware ZAC?
> > 
> No. These patches just implement a proper SATL for ZAC drives.
> So in effect they just bring libata support on par with 'real' ZBC
> drives, allowing things like 'sg_rep_zones' to work properly there.

But that was my point: the Linux SATL exists to support our ULDs on ATA
devices.  Until that support exists within SCSI, we don't really need
the SATL to support it.  You can argue it's for SG_IO, but really, if
you're doing user level control of ZAC devices, you'd use ATA commands.

> As such I've considered those patches to be a precursor for ZBC support.
> 
> But then, I don't mind how it's being handled.
> I surely can turn things around, ZBC support first, and ZAC as an
> add-on to that.
> Just say the word.

Well, um, since there's no ATA ULD, there is no real kernel handling of
ZAC devices, so doesn't that mean we have to at least have the reporting
done via block and sd before the ATA bits will do anything meaningful?

So to me, this looks very like supporting 512e: agree what parameters
block exposes and how userspace uses them, then plumb into block, then
SCSI then ATA (i.e. work down the stack, not up).

James


