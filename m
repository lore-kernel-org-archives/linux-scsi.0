From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Sun, 29 Nov 2015 14:50:53 +0100
Message-ID: <CAMuHMdXwckticSMQpK6Fmm-ACJtqebTZXT9YGvJ3v1RWDD0fdA@mail.gmail.com>
References: <20151118083455.331768508@telegraphics.com.au>
	<201511252259.26792.linux@rainbow-software.org>
	<alpine.LNX.2.00.1511261130120.12333@nippy.intranet>
	<201511262035.40920.linux@rainbow-software.org>
	<alpine.LNX.2.00.1511270930280.723@nippy.intranet>
	<CAMuHMdWt5Vf=iOg0BcqTwE-Md75dTmygVOmw45MXVhKuDDQXxA@mail.gmail.com>
	<alpine.LNX.2.00.1511292106140.32336@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511292106140.32336@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Sun, Nov 29, 2015 at 11:25 AM, Finn Thain <fthain@telegraphics.com.a=
u> wrote:
> On Sun, 29 Nov 2015, Geert Uytterhoeven wrote:
>> This still heavily depends on the processing time spent in
>> NCR5380_read(). You should never use a value derived from
>> loops_per_jiffy for a non-empty loop,
>
> Sure but the time-out condition isn't supposed to be precise.
> Plus/minus a jiffy is no problem. Plus/minus a second is no good.

If an ISA access takes 8 =C2=B5s, while the CPU runs at 1 GHz, i.e. 500=
M loops/s,
the difference will be huge.

>> as it may take much longer. Always compare with an maximum end time
>> instead.
>
> That can't work with interrupts disabled, which was the problem I was
> trying to solve by use of loops_per_jiffy.

Then you indeed can't use jiffies.
Perhaps you can calibrate an NCR5380_read() loop at driver init time,
and use the calibration value later?

> NCR5380_poll_politely() in mainline doesn't work with interrupts disa=
bled
> either, hence patch 21.
>
>> E.g.:
>>
>>         end =3D jiffies + 2;        /* 1 jiffie + 1 safeguard */
>>         do {
>>                  if ((NCR5380_read(reg1) & bit1) =3D=3D val1)
>>                          return 0;
>>                  cpu_relax();
>>         } while (time_before(jiffies, end);
>>
>> And a similar loop for "Busy-wait for up to 20 ms".
>
> Interrupts may be disabled during that loop also. Please refer to (an=
d/or
> respond to) patch 21, "ncr5380: Sleep when polling, if possible", in =
which
> these changes were made.

So the above loop may never terminate. Oops...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
