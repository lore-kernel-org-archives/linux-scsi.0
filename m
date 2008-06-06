From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 05 Jun 2008 21:16:24 -0400
Message-ID: <yq1hcc7mkgn.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605104042.GB20308@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080605104042.GB20308@shareable.org> (Jamie Lokier's message of "Thu\, 5 Jun 2008 11\:40\:42 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:

Jamie> Does it handle devices with different properties in differeng
Jamie> offset ranges?  E.g. a RAID setup where the first 100GB have
Jamie> one stripe width, but the next 100GB have a different stripe
Jamie> width - as you can get if you join two different hardware RAIDs
Jamie> with LVM, for example.

I touched on this in my reply to Andreas.  The values exported in
sysfs are only part of the solution.  We'll still need some
intelligence (in libdisk or elsewhere) to traverse the stacked device.
And that's better done in user land where it's easier to notify the
operator or ask for confirmation.


Jamie> If it's a set of drives, doesn't it need to return multiple
Jamie> offsets, and drive identities?

Given the almost infinite amount of stacking and concatenation options
I think we'll quickly get into FIEMAP territory.  Add snapshots to the
mix and mapping out the characteristics quickly becomes unmanageable.

If we present the mkfs writers with a list of 200 regions with
different alignment criteria and stripe sizes I'm sure they'll get
very unhappy.

So instead of publishing all this information I'd much rather have
libdisk do a rudimentary check and make it a binary "looks good"
vs. "may have performance problems".

If some poor mkfs souls wantsto traverse the entire stack and actually
make the filesystem layout completely heterogeneous, my patch also
allows them to do that...

-- 
Martin K. Petersen	Oracle Linux Engineering

