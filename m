From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Mon, 30 Nov 2015 13:12:45 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511301310210.10574@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511252259.26792.linux@rainbow-software.org> <alpine.LNX.2.00.1511261130120.12333@nippy.intranet> <201511262035.40920.linux@rainbow-software.org> <alpine.LNX.2.00.1511270930280.723@nippy.intranet>
 <CAMuHMdWt5Vf=iOg0BcqTwE-Md75dTmygVOmw45MXVhKuDDQXxA@mail.gmail.com> <alpine.LNX.2.00.1511292106140.32336@nippy.intranet> <CAMuHMdXwckticSMQpK6Fmm-ACJtqebTZXT9YGvJ3v1RWDD0fdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXwckticSMQpK6Fmm-ACJtqebTZXT9YGvJ3v1RWDD0fdA@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k <linux-m68k@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Geert Uytterhoeven wrote:

> If an ISA access takes 8 us, while the CPU runs at 1 GHz, i.e. 500M 
> loops/s, the difference will be huge.

Ondrej showed that an ISA access can take about 1.6 us. I don't know what 
to make of the "8 uS" comment in the mainline driver. Maybe it was an even 
slower ISA card.

Anyway, I made a measurement on my hardware and confirmed that lpj is a 
very bad proxy for device register access throughput. The "loops per 
access" gap is several orders of magnitude:

                                      lpj   HZ    access time (us)  lpa
------------------------------------------------------------------------
Ondrej's 5380 ISA card (PC):      4797252   250   1.6               1.9k
My DMX3191D PCI card (PowerMac):   167079   100   0.42              7.0

> 
> Perhaps you can calibrate an NCR5380_read() loop at driver init time, 
> and use the calibration value later?

I had the same idea but I didn't think that the complexity was justified 
by the low precision requirement. But now that I have some timings I have 
to agree.

-- 
