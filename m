From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Thu, 6 Nov 2014 15:09:54 +1300
Message-ID: <CAOmrzkLW+cRi1p7Wa63L-Tf-hCtVkkcFxGmqQVBQHL4A3F+hKQ@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<5455C107.6040500@gmail.com>
	<alpine.LNX.2.00.1411021710210.27266@nippy.intranet>
	<5455E340.7080305@gmail.com>
	<CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
	<CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com>
	<CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?UTF-8?Q?David_G=C3=A1lvez?= <dgalvez75@gmail.com>, Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, aniplay@wanadoo.fr
List-Id: linux-scsi@vger.kernel.org

David, Geert,

my Falcon has some variant of this clock patch installed - it may not
be precisely the one described but reasonably close. It also has one
of the old 030 accelerator tricks (clock doubling of the 030 if the
CPU does not do bus cycles - named Skunk) fitted; the clock patch was
installed at the same time.

The Falcon ran stable with just SCSI disks in use (so no locking
races) until a few years ago when I started to use it for kernel
hacking. There were the occasional SCSI lockups which I attributed to
the SCSI clock problem, for want of a better explanation. IIRC when
the clock signal to the 5380 becomes unstable, the chip locks up and
needs to be reset. With the old 2.4 kernels, recovery from reset
worked OK and I've not seen disk corruption or hard read errors.

2.6 kernels changed a lot of things around SCSI midlevel and error
handling. I could never make error recovery from these SCSI lockups
work in 2.6 or 3.x until Arnd's locking fixes (and my patch to defer
command queueing if the lock had been taken by IDE). The lockups did
not stop happening until Finn's patches - and I probably need to
emphasize again that they are gone entirely now. It does seem 2.4
suffered from similar race problems, the driver just managed to
recover from those.

Leaves the current instability - I did some work on the CT60
accelerator (reflashed the firmware so I can use the CTPCI board).
This might have caused the system to become more unstable. Needs more
investigation.

Cheers,

  Michael


On Wed, Nov 5, 2014 at 9:10 PM, Geert Uytterhoeven <geert@linux-m68k.or=
g> wrote:
> On Wed, Nov 5, 2014 at 8:56 AM, David G=C3=A1lvez <dgalvez75@gmail.co=
m> wrote:
>> Do you know about the Falcon's disturbance in the SDMA clock signal
>> hardware problem?
>> Most Falcons, specially those used in music studios, have a hardware
>> patch to fix this, it's normally called SCSI patch.
>>
>> Some more info:
>>
>> http://didierm.pagesperso-orange.fr/doc/eng/c_0a.htm
>
> So this adds additional buffering to the clock.
>
> Note that input pins 3 and 5 of the 74HC04 are left floating!
> I recommend tying them to either GND (pin 7) or VCC (pin 14), to avoi=
d
> them picking up high-frequency signals and consuming power.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linu=
x-m68k.org
>
> In personal conversations with technical people, I call myself a hack=
er. But
> when I'm talking to journalists I just say "programmer" or something =
like that.
>                                 -- Linus Torvalds
