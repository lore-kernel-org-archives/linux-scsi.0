From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Tue, 26 Jan 2016 08:56:26 +1300
Message-ID: <CAOmrzkLccCjboTpQo05UjDr=Evwd_nF7e3SK+r2y3zkzTjdh_g@mail.gmail.com>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050510.031796194@telegraphics.com.au>
	<CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com>
	<alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
	<CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

On Mon, Jan 25, 2016 at 9:05 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

>>> Perhaps this is an ARAnyM quirk?
>
>> The MR_ARBITRATE bit should remain set until the driver clears it (or the
>> reset logic clears it). But it looks like aranym simply discards writes to
>> the mode register, such that reads always return 0.
>>
>> Compare
>>   http://sourceforge.net/p/aranym/code/ci/master/tree/src/ncr5380.cpp
>> with the MAME/MESS emulated device
>>   https://github.com/mamedev/mame/blob/master/src/devices/machine/ncr5380.cpp
>>
>> I don't know what the Hatari emulator does.
>>
>> In principle I think that Linux drivers should not carry workarounds for
>> emulators.
>
> Please consider ARAnyM is the current m68k workhorse, so it would be
> nice to handle this someway.
>
> Alternatively, we need to fix ARAnyM, or can make the creation of the
> atari_scsi platform device conditional on not running under ARAnyM.

Should be possible based on the machine cookie, unless that gets
munged by kernel startup code.

(Making the 5380 emulation a bit more complete such as in the MAME
source snippet would be my preference, too)

Cheers,

  Michael


>
> Thanks!
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
