From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Fri, 7 Nov 2014 07:54:45 +1300
Message-ID: <CAOmrzkKUXJaDh7gchStxkwMeR6MUDGZPD+O+iAsvSbQOT0yB2g@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<5455C107.6040500@gmail.com>
	<alpine.LNX.2.00.1411021710210.27266@nippy.intranet>
	<5455E340.7080305@gmail.com>
	<CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
	<CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com>
	<CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com>
	<CAOmrzkLW+cRi1p7Wa63L-Tf-hCtVkkcFxGmqQVBQHL4A3F+hKQ@mail.gmail.com>
	<alpine.LNX.2.00.1411061507240.20750@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:46720 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaKFSyr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 13:54:47 -0500
In-Reply-To: <alpine.LNX.2.00.1411061507240.20750@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, =?UTF-8?Q?David_G=C3=A1lvez?= <dgalvez75@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, aniplay@wanadoo.fr

Hi Finn,

>> Leaves the current instability - I did some work on the CT60 accelerator
>> (reflashed the firmware so I can use the CTPCI board). This might have
>> caused the system to become more unstable. Needs more investigation.
>
> I gather from the emails we've exchanged that the "current" instability
> (data corruption) dates back to March or thereabouts, so it is unrelated
> to this patch series.

Absolutely right - meant to add that but got interrupted in that train
of thought :-(

> The lockups have been resolved, which leaves only the ST DMA FIFO issue,
> which seems to be an old problem. From the comments in atari_scsi, it
> doesn't look like this was ever resolved.
>
>         /* If the DMA was active, but now bit 1 is not clear, it is some
>          * other 5380 interrupt that finishes the DMA transfer. We have to
>          * calculate the number of residual bytes and give a warning if
>          * bytes are stuck in the ST-DMA fifo (there's no way to reach them!)
>          */
>         if (atari_dma_active && (dma_stat & 0x02)) {
>                 unsigned long transferred;
>
>                 transferred = SCSI_DMA_GETADR() - atari_dma_startaddr;
>                 /* The ST-DMA address is incremented in 2-byte steps, but the
>                  * data are written only in 16-byte chunks. If the number of
>                  * transferred bytes is not divisible by 16, the remainder is
>                  * lost somewhere in outer space.
>                  */
>                 if (transferred & 15)
>                         printk(KERN_ERR "SCSI DMA error: %ld bytes lost in "
>                                "ST-DMA fifo\n", transferred & 15);
>
> Presuming that this is an old issue (apparently timing sensitive), we can
> conclude that no regressions were observed in your tests. I'm content with
> this presumption. I gather that you are too, or you would not have sent a
> "tested-by" tag. Which seems to put the ball in Geert's court?

Right again - though it's probably not Geert but James who needs to
give the go-ahead.

Cheers,

  Michael
