From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380
 drivers
Date: Thu, 6 Nov 2014 15:50:01 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411061507240.20750@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <5455C107.6040500@gmail.com> <alpine.LNX.2.00.1411021710210.27266@nippy.intranet> <5455E340.7080305@gmail.com> <CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
 <CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com> <CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com> <CAOmrzkLW+cRi1p7Wa63L-Tf-hCtVkkcFxGmqQVBQHL4A3F+hKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAOmrzkLW+cRi1p7Wa63L-Tf-hCtVkkcFxGmqQVBQHL4A3F+hKQ@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, =?ISO-8859-15?Q?David_G=E1lvez?= <dgalvez75@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, aniplay@wanadoo.fr
List-Id: linux-scsi@vger.kernel.org


On Thu, 6 Nov 2014, Michael Schmitz wrote:

> Leaves the current instability - I did some work on the CT60 accelerator 
> (reflashed the firmware so I can use the CTPCI board). This might have 
> caused the system to become more unstable. Needs more investigation.

I gather from the emails we've exchanged that the "current" instability 
(data corruption) dates back to March or thereabouts, so it is unrelated 
to this patch series.

The lockups have been resolved, which leaves only the ST DMA FIFO issue, 
which seems to be an old problem. From the comments in atari_scsi, it 
doesn't look like this was ever resolved.

        /* If the DMA was active, but now bit 1 is not clear, it is some
         * other 5380 interrupt that finishes the DMA transfer. We have to
         * calculate the number of residual bytes and give a warning if
         * bytes are stuck in the ST-DMA fifo (there's no way to reach them!)
         */
        if (atari_dma_active && (dma_stat & 0x02)) {
                unsigned long transferred;

                transferred = SCSI_DMA_GETADR() - atari_dma_startaddr;
                /* The ST-DMA address is incremented in 2-byte steps, but the
                 * data are written only in 16-byte chunks. If the number of
                 * transferred bytes is not divisible by 16, the remainder is
                 * lost somewhere in outer space.
                 */
                if (transferred & 15)
                        printk(KERN_ERR "SCSI DMA error: %ld bytes lost in "
                               "ST-DMA fifo\n", transferred & 15);

Presuming that this is an old issue (apparently timing sensitive), we can 
conclude that no regressions were observed in your tests. I'm content with 
this presumption. I gather that you are too, or you would not have sent a 
"tested-by" tag. Which seems to put the ball in Geert's court?

-- 
