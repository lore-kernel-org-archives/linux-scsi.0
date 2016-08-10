From: Tejun Heo <tj@kernel.org>
Subject: Re: Regarding AHCI_MAX_SG and (ATA_HORKAGE_MAX_SEC_1024)
Date: Tue, 9 Aug 2016 23:26:13 -0400
Message-ID: <20160810032613.GA25053@mtj.duckdns.org>
References: <CAGnHSEnsfmO8ydLZGBmEXgRCYTZfy+sR3knCWfBhCz6_vLZMEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEnsfmO8ydLZGBmEXgRCYTZfy+sR3knCWfBhCz6_vLZMEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-ide@vger.kernel.org, dmilburn@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Tom.

On Sun, Aug 07, 2016 at 10:10:17PM +0800, Tom Yan wrote:
> So the (not so) recent bump of BLK_DEF_MAX_SECTORS from 1024 to 2560
> (commit d2be537c3ba3) seemed to have caused trouble to some of the ATA
> devices, which were then worked around with ATA_HORKAGE_MAX_SEC_1024.
> 
> However, I am suspecting that the bump of BLK_DEF_MAX_SECTORS is not
> the "real" cause of the trouble, but the fact that AHCI_MAX_SG has
> been set to a weird value of 168 (with a comment "hardware max is
> 64K", which neither seem to make any sense).

Hmmm.. why not?  The hardware limit is 64k and the driver is using a
lower limit of 168 most likely because it doesn't make noticeable
difference beyond certain point and it determines the size of
contiguous memory which has to be allocated for the command table.
Each sg entry is 16 bytes.  Pushing it to the hardware limit would
require an order 9 allocation for each port.

> AHCI_MAX_SG is used to set the sg_tablesize (i.e. max_segments,
> apparently), which is apparently used to derive the actual "request
> size" (that is, if it is lower than max_sectors(_kb), it will be the
> limiting factor instead).
>
> For example, no matter if the drive has max_sectors set to 2560, or to
> 65535 (by adding it as the Optimal Transfer Length to libata's SATL,
> which is also max_hw_sectors that is set from ATA_MAX_SECTORS_LBA48),
> "avgrq-sz" in `iostat` will be capped at 1344 (168 * 8).

Not necessarily.  A single sg entry can point to an area larger than
PAGE_SIZE.

> However, if I change AHCI_MAX_SG to 128 (which is also the
> sg_tablesize set in libata.h from LIBATA_MAX_PRD), "avgrq-sz" in
> `iostat` will be capped at 1024 (128 * 8), which should make
> ATA_HORKAGE_MAX_SEC_1024 unnecessary.
> 
> So why has AHCI_MAX_SG been set to 168 anyway?

As written above, that probably makes the ahci command table size
nicely aligned.

Thanks.

-- 
tejun
