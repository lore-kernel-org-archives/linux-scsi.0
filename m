From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 6 Jun 2008 14:51:50 +1000
Message-ID: <20080606045150.GL10720@disturbed>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605104042.GB20308@shareable.org> <yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 05, 2008 at 09:16:24PM -0400, Martin K. Petersen wrote:
> >>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:
> 
> Jamie> Does it handle devices with different properties in differeng
> Jamie> offset ranges?  E.g. a RAID setup where the first 100GB have
> Jamie> one stripe width, but the next 100GB have a different stripe
> Jamie> width - as you can get if you join two different hardware RAIDs
> Jamie> with LVM, for example.
> 
> I touched on this in my reply to Andreas.  The values exported in
> sysfs are only part of the solution.  We'll still need some
> intelligence (in libdisk or elsewhere) to traverse the stacked device.
> And that's better done in user land where it's easier to notify the
> operator or ask for confirmation.

So is there going to be any obvious kernel API to access all this
info? i.e. if you do an online modification of a volume (e.g.
add new storage of a different geometry to the volume) and then
do an online grow of the filesystem, how does the filesystem get
that new geometry information for the expanded area?

FWIW, I don't mind if there isn't a kernel interface for the
filesystem to get this information - we're already planning to
push complex and dynamic allocation policy configuration out
to userspace because it's easier to determine mappings and
geometries there....

> Jamie> If it's a set of drives, doesn't it need to return multiple
> Jamie> offsets, and drive identities?
> 
> Given the almost infinite amount of stacking and concatenation options
> I think we'll quickly get into FIEMAP territory.  Add snapshots to the
> mix and mapping out the characteristics quickly becomes unmanageable.
> 
> If we present the mkfs writers with a list of 200 regions with
> different alignment criteria and stripe sizes I'm sure they'll get
> very unhappy.

Most filesystems can't handle existing geometry information, let alone
variable geometry.

> So instead of publishing all this information I'd much rather have
> libdisk do a rudimentary check and make it a binary "looks good"
> vs. "may have performance problems".
>
> If some poor mkfs souls wantsto traverse the entire stack and actually
> make the filesystem layout completely heterogeneous, my patch also
> allows them to do that...

Great ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
