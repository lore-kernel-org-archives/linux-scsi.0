From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: WWN on FC LUN targets
Date: Wed, 28 Jul 2004 10:09:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA5E8B762.2396C914-ON88256EDF.005D04E1-88256EDF.005E281C@us.ibm.com>
References: <20040728154614.53413.qmail@web41406.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:138 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267341AbUG1RKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 13:10:22 -0400
In-Reply-To: <20040728154614.53413.qmail@web41406.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Rock Gordon <rockgordon@yahoo.com>
Cc: "David Peterson (Eng)" <david_peterson@cnt.com>, linux-scsi@vger.kernel.org

>The need is to be able to
>identifiy logical units (which I refer to as LUNs)
>uniquely, no matter where they are and to whichever FC
>network they might end up getting connected to at any
>given point in time.

That's exactly what the SCSI device ID is for.

>Hence anything that is not portable or not unique
>world-wide is suspect. I feel the SCSI device ID falls
>in this category.

The SCSI device ID, the NAA version in particular, is designed to be 
world-wide unique and portable (stays the same no matter where or how in 
the world you attach the device).

Since you're working with filesystems, another thing you should consider 
is a filesystem serial number.  The device ID has the problem that if you 
move your filesystem to another logical unit, its ID changes.  And if you 
replace the filesystem on a logical unit with another filesystem, the new 
filesystem has the same ID as the former one.  An ext3 filesystem has a 
UUID which is supposed to be worldwide unique identifier of the 
filesystem.  Your idea of placing your own ID file in the filesystem is 
similar.

>Yet another approach would be to record the
>host/bus/target/lun of each logical unit. However this
>might not work in case of a re-arrangement of the
>network or even re-seating HBAs inside the servers
>themselves; am I right?

Yes, you should cross that one out.  It's only slightly better than using 
/dev/sdX.

>So if a [WWNN] is indeed assigned to a single SCSI LUN,

It isn't.  It's assigned to the target.  Each target can have multiple 
logical units.  Each logical unit can have multiple LUNs.  And since it 
isn't a SCSI concept, there's no standard interface in Linux for querying 
it.  Various FC hardware and driver software have various ways to query 
such fibre channel info.

