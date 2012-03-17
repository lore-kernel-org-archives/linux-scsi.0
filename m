From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 17 Mar 2012 09:56:44 +0100
Message-ID: <20120317095644.145d0588@stein>
References: <20120315225310.GB3152@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120315225310.GB3152@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mar 15 Wakko Warner wrote:
> I'm having problems doing this.
> 
> When I burn a single disk, wodim shows the drive buf @ 99% consistently. 
> The instant that a 2nd disk is being burned, the drive buf on the first one
> starts to drop and data stops when the 2nd wodim is performing OPC.
> 
> During the burn of both discs, the drive buf will drop on both until one of
> them finishes.  Both drives see under runs.
> 
> When one starts fixating, the other will hang until the fixation is
> completed.
> 
> During the burns, the fifo of both never drop below 99%
> 
> There are no logs that are produced.
> 
> My burners are:
> [6:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr7
> [7:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr8
> 
> Both are SATA drives attached to the onboard sata controller
> 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller (rev 09)
> 00:1f.2 0106: 8086:2681 (rev 09)
> 
> The kernel is a vanilla kernel v3.0.0.  (This also happened with 2.6.35)
> 
> I don't believe it matters, but the data is coming over NFS via gigabit
> ethernet.  Each burn process uses a 768M host buffer.  As I stated, the host
> fifo on wodim never goes below 99%
> 
> The system motherboard is a SuperMicro X7DA8

This is likely due to serialization by a global mutex in the sr driver.
Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive performance,
remove BKL replacement" from February. https://lkml.org/lkml/2012/2/28/230
-- 
Stefan Richter
-=====-===-- --== =---=
http://arcgraph.de/sr/
