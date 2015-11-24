From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Tue, 24 Nov 2015 22:40:24 +0100
Message-ID: <201511242240.24959.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511240904.55085.linux@rainbow-software.org> <alpine.LNX.2.00.1511241932130.7196@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:51759 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbbKXVke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 16:40:34 -0500
In-Reply-To: <alpine.LNX.2.00.1511241932130.7196@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday 24 November 2015 10:13:17 Finn Thain wrote:
> 
> On Tue, 24 Nov 2015, Ondrej Zary wrote:
> 
> > On Tuesday 24 November 2015, Finn Thain wrote:
> > > 
> > > On Mon, 23 Nov 2015, Ondrej Zary wrote:
> > > 
> > > > 
> > > > PDMA seems to be broken in multiple ways. NCR5380_pread cannot 
> > > > process less than 128 bytes. In fact, 53C400 datasheet says that 
> > > > it's HW limitation: non-modulo-128-byte transfers should use PIO.
> > > > 
> > > > Adding
> > > >         transfersize = round_down(transfersize, 128);
> > > > to generic_NCR5380_dma_xfer_len() improves the situation a bit.
> > > > 
> > > > After modprobe, some small reads (8, 4, 24 and 64 bytes) are done 
> > > > using PIO, then eight 512-byte reads using PDMA and then it fails on 
> > > > a 254-byte read. First 128 bytes are read using PDMA and the next 
> > > > PDMA operation hangs waiting forever for the host buffer to be 
> > > > ready.
> > > > 
> > > 
> > > A 128-byte PDMA receive followed by 126-byte PDMA receive? I don't see 
> > > how that is possible given round_down(126, 128) == 0. Was this the 
> > > actual 'len' argument to NCR5380_pread() in g_NCR5380.c?
> > 
> > No 126-byte PDMA. The 126 bytes were probably lost (or mixed with the 
> > next read?).
> 
> When you said, the "PDMA operation hangs waiting forever", I figured that 
> you had hit an infinite loop in NCR5380_pread()... but now I'm lost.
> 
> My main concern here is to confirm that I didn't break anything e.g. with 
> patch 24 or 41. It would be nice to know that this hang is not the result 
> of a new bug.
> 
> > The next read was also 254 bytes so another 128-byte PDMA transfer.
> > 
> > Then modified NCR5380_information_transfer() to transfer the remaining 
> > data (126 bytes in this case) using PIO. It did not help, the next PDMA 
> > transfer failed too.
> > 
> 
> AFAICT, no change to NCR5380_information_transfer() should be needed. It 
> was always meant to cope with the need to split a transfer between (P)DMA 
> and PIO.

Instead of fixing split transfers, simply forced everything non-modulo-128 to
PIO:
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -703,6 +703,10 @@ static int generic_NCR5380_dma_xfer_len(struct scsi_cmnd *cmd)
 	    !(cmd->SCp.this_residual % transfersize))
 		transfersize = 32 * 1024;

+	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
+	if (transfersize % 128)
+		transfersize = 0;
+
 	return transfersize;
 }

It seems to work and greatly improves performance:
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   4 MB in  4.84 seconds = 846.15 kB/sec

-- 
Ondrej Zary
