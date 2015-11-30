From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Mon, 30 Nov 2015 14:40:04 +0100
Message-ID: <201511301440.04626.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <1448789980-30094-2-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1511302255470.17483@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511302255470.17483@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 30 November 2015, Finn Thain wrote:
> 
> On Sun, 29 Nov 2015, Ondrej Zary wrote:
> 
> > Add I/O register mapping for NCR53C400A and enable PDMA mode to
> > improve performance and fix non-working IRQ.
> > 
> 
> Is CONFIG_SCSI_GENERIC_NCR53C400 is still needed? Can the driver be fully 
> configured at runtime now?

Things depending on CONFIG_SCSI_GENERIC_NCR53C400:

#ifdef CONFIG_SCSI_GENERIC_NCR53C400
#define PSEUDO_DMA
#endif

Defining PSEUDO_DMA should not break anything, just makes code bigger a bit. We can probably just define it always in g_NCR5380.c.


This looks weird. I don't have any card with a BIOS to test.
#ifdef CONFIG_SCSI_GENERIC_NCR53C400
#define BIOSPARAM
#define NCR5380_BIOSPARAM generic_NCR5380_biosparam
#else
#define NCR5380_BIOSPARAM NULL
#endif


This looks very wrong and should be done at runtime:
#ifdef CONFIG_SCSI_GENERIC_NCR53C400
#define NCR5380_region_size 16
#else
#define NCR5380_region_size 8
#endif


> > Tested with HP C2502 (and user-space enabler).
> > 
> 
> It would be nice if the enabler was documented.  
> Documentation/scsi/g_NCR5380.txt might be a good place for that. That file 
> could perhaps be updated (?) Certainly obsolete and misleading information 
> should be removed if you see any.
 
I'll integrate the enabler into the driver. It's like "wakeup sequence for the NCR53C400A and DTC3181E */" in g_NCR5380.c, only the magic numbers are different.

-- 
Ondrej Zary
