From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 17 Mar 2012 10:22:56 -0400
Message-ID: <20120317142255.GB26403@animx.eu.org>
References: <20120315225310.GB3152@animx.eu.org>
 <20120317095644.145d0588@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120317095644.145d0588@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> On Mar 15 Wakko Warner wrote:
> > I'm having problems doing this.
> > 
> > When I burn a single disk, wodim shows the drive buf @ 99% consistently. 
> > The instant that a 2nd disk is being burned, the drive buf on the first one
> > starts to drop and data stops when the 2nd wodim is performing OPC.
> > 
> > During the burn of both discs, the drive buf will drop on both until one of
> > them finishes.  Both drives see under runs.
> > 
> > When one starts fixating, the other will hang until the fixation is
> > completed.
> > 
> > During the burns, the fifo of both never drop below 99%
> > 
> > There are no logs that are produced.
> > 
> > My burners are:
> > [6:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr7
> > [7:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr8
> > 
> > Both are SATA drives attached to the onboard sata controller
> > 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller (rev 09)
> > 00:1f.2 0106: 8086:2681 (rev 09)
> > 
> > The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)
> > 
> > I don't believe it matters, but the data is coming over NFS via gigabit
> > ethernet.  Each burn process uses a 768M host buffer.  As I stated, the host
> > fifo on wodim never goes below 99%
> > 
> > The system motherboard is a SuperMicro X7DA8
> 
> This is likely due to serialization by a global mutex in the sr driver.
> Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive performance,
> remove BKL replacement" from February. https://lkml.org/lkml/2012/2/28/230

Thanks.  I looked at the patch.  I would just like to confirm that I can
patch my 3.0.0 vanilla kernel, compile the sr module, unload the current and
load the patched one without the need to reboot.

I do not use udisks.

Thanks for the responce, I'll try this when I have more discs to burn.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
