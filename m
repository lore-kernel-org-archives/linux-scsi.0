From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
Date: Fri, 9 Sep 2016 14:00:18 +0200
Message-ID: <CAMuHMdUVtX8ngof4RPstxvR7qSF+uBTTRmKTXKQ8jnBFAvnvbg@mail.gmail.com>
References: <20160827022959.303563262@telegraphics.com.au> <20160831044453.413698369@telegraphics.com.au>
 <yq1r38tfh1l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r38tfh1l.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 9, 2016 at 1:28 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:
>
> Finn> Large PIO transfers are broken up into chunks to try to avoid
> Finn> disabling local IRQs for long periods. But IRQs are still disabled
> Finn> for too long and this causes SCC FIFO overruns during serial port
> Finn> transfers.
>
> Finn> This patch reduces the PIO chunk size to reduce interrupt latency
> Finn> to something on the order of milliseconds, at the expense of
> Finn> additional CPU overhead from extra iterations of the
> Finn> NCR5380_main() loop.
>
> Finn> That CPU overhead is a problem for slow machines (e.g. mac_scsi on
> Finn> 25 MHz
> Finn> 68030) but these machines generally use PDMA not PIO. This patch
> Finn>        doesn't
> Finn> make the overhead any worse on my Mac LC III (because it only gets
> Finn> about 510 accesses per ms).
>
> Finn> This patch decreases disk performance by a fraction of one percent
> Finn> for dmx3191d on my 333 MHz PowerPC 750. Other affected hardware
> Finn> (such as g_NCR5380 on x86) was not tested but 5380 ISA cards
> Finn> generally use PDMA and not PIO.
>
> Geert?

No comments from my side.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
