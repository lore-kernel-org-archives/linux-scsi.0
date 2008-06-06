From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 6 Jun 2008 13:52:05 +0100
Message-ID: <20080606125205.GA19246@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605104042.GB20308@shareable.org> <yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:45567 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYFFMwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 08:52:09 -0400
Content-Disposition: inline
In-Reply-To: <yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

Martin K. Petersen wrote:
> I touched on this in my reply to Andreas.  The values exported in
> sysfs are only part of the solution.  We'll still need some
> intelligence (in libdisk or elsewhere) to traverse the stacked device.
> And that's better done in user land where it's easier to notify the
> operator or ask for confirmation.

Agree, except for one thing.  It would be good to able to get a
consistent atomic snapshot of the whole stack in one kernel call.  I
guess that's not feasible where network devices are involved, though,
without a rather complicated interface.

> Jamie> If it's a set of drives, doesn't it need to return multiple
> Jamie> offsets, and drive identities?
> 
> Given the almost infinite amount of stacking and concatenation options
> I think we'll quickly get into FIEMAP territory.  Add snapshots to the
> mix and mapping out the characteristics quickly becomes unmanageable.

Well, not unmanagable, but large and unsuitable for many programs.

> If we present the mkfs writers with a list of 200 regions with
> different alignment criteria and stripe sizes I'm sure they'll get
> very unhappy.

Probably right.  But as a database writer, I'd like the information if
I can get it.  Sometimes I'll do timing measurements, because they are
more "real" than the kernel's estimate.  But I can't measure storage
stability levels, that really needs data from the kernel (if the
kernel even has it).

> So instead of publishing all this information I'd much rather have
> libdisk do a rudimentary check and make it a binary "looks good"
> vs. "may have performance problems".

Sensible, I agree.

> If some poor mkfs souls wantsto traverse the entire stack and actually
> make the filesystem layout completely heterogeneous, my patch also
> allows them to do that...

Good, being possible is the main thing :-)

And preferably without a different interface for different kinds of
device.  So as long as there's a way to traverse the stack generically.

-- Jamie
