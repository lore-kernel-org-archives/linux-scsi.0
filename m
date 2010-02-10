From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: 16 commands per lun limitation bug?
Date: Wed, 10 Feb 2010 17:22:40 -0500
Message-ID: <1265840560.2769.584.camel@mulgrave.site>
References: <20100210201916.GK11649@beardog.cce.hp.com>
	 <1265839165.2769.553.camel@mulgrave.site>
	 <0F5B06BAB751E047AB5C87D1F77A778869C9E3AA47@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab0BJWWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:22:46 -0500
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778869C9E3AA47@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2010-02-10 at 22:19 +0000, Miller, Mike (OS Dev) wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@suse.de] 
> > Sent: Wednesday, February 10, 2010 3:59 PM
> > To: scameron@beardog.cce.hp.com
> > Cc: linux-scsi@vger.kernel.org; Miller, Mike (OS Dev)
> > Subject: Re: 16 commands per lun limitation bug?
> > 
> > On Wed, 2010-02-10 at 14:19 -0600, scameron@beardog.cce.hp.com wrote:
> > > We have seen the amount of commands per lun that are sent 
> > to low level 
> > > scsi driver limited to 16 commands per lun, (seemingly 
> > artificially, 
> > > well below our can_queue and cmd_per_lun limits of 1020)
> > > 
> > > 2.6.29 does not exhibit this bad behavior.
> > > 2.6.30, 2.6.31, 2.6.32 (2.6.32.1 through 2.6.32.8) do 
> > exhibit this bad 
> > > behavior
> > > 2.6.31-rc1 does not exhibit this bad behavior
> > 
> > I can't think of any reason for this.  Best guess at the fix 
> > would be the new queue full ramp up ramp down code, but no 
> > clue as to what the problem is ... no other drivers seem to 
> > have noticed the performance problems this would likely cause 
> > ... and 2.6.32 is becoming the standard enterprise kernel.
> > 
> James,
> I'm not sure there's much hardware out there that's capable of queuing
> up so many commands without choking the disks. I _think_ in most cases
> if you queue up say 64 commands on a single scsi disk that's just too
> much. But with Smart Array we can queue up to 1024 commands (on most
> controllers) and those are then distributed across all the drives in
> the array(s). IOW, we're thinking not many people would have noticed
> such a change. Hope this makes sense.

Fibre drivers to FC arrays would regard a depth of 16 as "fiddling small
change" to quote hitchhikers.  If any of the FC drivers got limited in
this regard, we'll see substantial enterprise performance drops ...
which I haven't actually heard about yet.

James


