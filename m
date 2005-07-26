From: Ben Collins <bcollins@debian.org>
Subject: Re: Unplugging of SBP-2 devices still does not work
Date: Tue, 26 Jul 2005 00:26:41 -0400
Message-ID: <20050726042640.GA17885@phunnypharm.org>
References: <42E29DF5.5090603@s5r6.in-berlin.de> <42E2A15A.2030609@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:15792 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261626AbVGZE0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 00:26:41 -0400
Content-Disposition: inline
In-Reply-To: <42E2A15A.2030609@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Sounds like it is probably hanging in sbp2 while it is trying to logout.

Perhaps you can turn on spinlock debug to see if there is a deadlock
somewhere? Check wstat for the knodemgrd process aswell, see what it is
waiting for.

On Sat, Jul 23, 2005 at 09:58:18PM +0200, Stefan Richter wrote:
> I wrote:
> >Problem 1) Hot unplugging of SBP-2 hangs ieee1394's nodemgr
> [...]
> >[unplug disk]
> >Jul 23 20:08:53 shuttle kernel: ieee1394: Node changed: 1-01:1023 -> 
> >1-00:1023
> >Jul 23 20:08:53 shuttle kernel: ieee1394: Node suspended: 
> >ID:BUS[1-00:1023]  GUID[0001d202e0200ef1]
> >Jul 23 20:08:53 shuttle kernel: ieee1394: sbp2: sbp2_remove
> >Jul 23 20:08:53 shuttle kernel: Synchronizing SCSI cache for disk sda:
> 
> I should provide perhaps a little more background about nodemgr. It waits 
> for
> events on the FireWire bus. If it detects physical removal of a node, it 
> calls
> remove callbacks from IEEE 1394 protocol drivers such as sbp2. That's where
> sbp2_remove() kicks in. So it all happens in nodemgr's process context, 
> although
> the hang occurs somewhere in the scsi mid or high level, or perhaps in the 
> driver
> core when it is called from scsi.
> 
> [...]
> >Jul 23 21:04:49 shuttle kernel: ieee1394: GUID 0x00301bac00002ba4: 
> >bus_info_data[0] = 0x0404912b
> 
> Ignore this line. It is normally not logged by ieee1394.
> -- 
> Stefan Richter
> -=====-=-=-= -=== =-===
> http://arcgraph.de/sr/
> 
> 
> -------------------------------------------------------
> SF.Net email is sponsored by: Discover Easy Linux Migration Strategies
> from IBM. Find simple to follow Roadmaps, straightforward articles,
> informative Webcasts and more! Get everything you need to get up to
> speed, fast. http://ads.osdn.com/?ad_id=7477&alloc_id=16492&op=click
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
