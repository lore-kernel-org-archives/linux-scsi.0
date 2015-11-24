From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Tue, 24 Nov 2015 19:04:24 +0100
Message-ID: <201511241904.26525.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <alpine.LNX.2.00.1511241932130.7196@nippy.intranet> <201511241303.17899.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201511241303.17899.linux@rainbow-software.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 24 November 2015 13:03:17 Ondrej Zary wrote:
> On Tuesday 24 November 2015, Finn Thain wrote:
> > 
> > On Tue, 24 Nov 2015, Ondrej Zary wrote:
> > 
> > > On Tuesday 24 November 2015, Finn Thain wrote:
> > > > 
> > > > On Mon, 23 Nov 2015, Ondrej Zary wrote:
> > > > 
> > > > > 
> > > > > PDMA seems to be broken in multiple ways. NCR5380_pread cannot 
> > > > > process less than 128 bytes. In fact, 53C400 datasheet says that 
> > > > > it's HW limitation: non-modulo-128-byte transfers should use PIO.
> > > > > 
> > > > > Adding
> > > > >         transfersize = round_down(transfersize, 128);
> > > > > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > > > > 
> > > > > After modprobe, some small reads (8, 4, 24 and 64 bytes) are done 
> > > > > using PIO, then eight 512-byte reads using PDMA and then it fails on 
> > > > > a 254-byte read. First 128 bytes are read using PDMA and the next 
> > > > > PDMA operation hangs waiting forever for the host buffer to be 
> > > > > ready.
> > > > > 
> > > > 
> > > > A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't see 
> > > > how that is possible given round_down(126, 128) == 0. Was this the 
> > > > actual 'len' argument to NCR5380_pread() in g_NCR5380.c?
> > > 
> > > No 126-byte PDMA. The 126 bytes were probably lost (or mixed with the 
> > > next read?).
> > 
> > When you said, the "PDMA operation hangs waiting forever", I figured that 
> > you had hit an infinite loop in NCR5380_pread()... but now I'm lost.
> 
> The first 128-byte PDMA ended successfully (ignoring what happened to the
> remaining 126 bytes), then a next request for 254 bytes came. This resulted
> in a new 128-byte PDMA and that hanged (in one of its possibly infinite loops
> without a timeout).
> 
> > My main concern here is to confirm that I didn't break anything e.g. with 
> > patch 24 or 41. It would be nice to know that this hang is not the result 
> > of a new bug.
> 
> PDMA was already broken before so it's hard to tell. I can try to modify
> the unpatched driver to see if PDMA is broken the same way.

Just tested the driver without your patches and it's broken exactly the same
way.

-- 
Ondrej Zary
