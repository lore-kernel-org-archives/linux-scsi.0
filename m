From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 17 Mar 2012 16:28:53 +0100
Message-ID: <20120317162853.13afa28b@stein>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
	<20120317142255.GB26403@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57552 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2CQP3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Mar 2012 11:29:31 -0400
In-Reply-To: <20120317142255.GB26403@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mar 17 Wakko Warner wrote:
> Stefan Richter wrote:
> > On Mar 15 Wakko Warner wrote:
> > > I'm having problems doing this.
> > > 
> > > When I burn a single disk, wodim shows the drive buf @ 99% consistently. 
> > > The instant that a 2nd disk is being burned, the drive buf on the first one
> > > starts to drop and data stops when the 2nd wodim is performing OPC.
> > > 
> > > During the burn of both discs, the drive buf will drop on both until one of
> > > them finishes.  Both drives see under runs.
> > > 
> > > When one starts fixating, the other will hang until the fixation is
> > > completed.
> > > 
> > > During the burns, the fifo of both never drop below 99%
> > > 
> > > There are no logs that are produced.
> > > 
> > > My burners are:
> > > [6:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr7
> > > [7:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr8
> > > 
> > > Both are SATA drives attached to the onboard sata controller
> > > 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller (rev 09)
> > > 00:1f.2 0106: 8086:2681 (rev 09)
[...]
> > This is likely due to serialization by a global mutex in the sr driver.
> > Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive performance,
> > remove BKL replacement" from February. https://lkml.org/lkml/2012/2/28/230
> 
> Thanks.  I looked at the patch.  I would just like to confirm that I can
> patch my 3.0.0 vanilla kernel, compile the sr module, unload the current and
> load the patched one without the need to reboot.

Yes, this should be possible.

Oh, I only noticed just know that you also wrote:

> > > The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)

In 2.6.35, the Big Kernel Lock was still in place there.  That lock
behaved differently from a plain mutex --- notably it was released when a
thread went to sleep --- so maybe there is more to your problem than just
sr_mutex blocking unrelated sr accesses.
-- 
Stefan Richter
-=====-===-- --== =---=
http://arcgraph.de/sr/
