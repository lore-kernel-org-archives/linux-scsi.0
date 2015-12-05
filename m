From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Sat, 5 Dec 2015 12:32:16 +1100
Message-ID: <CAGRGNgVMOuWbeq8B-hrwtLvwdsVqdLV5UvCw8K6+JF5p0DHRoQ@mail.gmail.com>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
 <CAGRGNgU=6=XBGxpwe+Z+uU-Pq-L=aTyG2GukkWAqFVnJHTY3Og@mail.gmail.com> <alpine.LNX.2.00.1512041857160.13680@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512041857160.13680@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Fri, Dec 4, 2015 at 7:38 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>
> On Fri, 4 Dec 2015, Julian Calaby wrote:
>
>> > -               if (overrides[current_override].board == BOARD_NCR53C400A) {
>> > +               if (overrides[current_override].board == BOARD_NCR53C400A ||
>> > +                   overrides[current_override].board == BOARD_DTC3181E) {
>>
>> These if statements are starting to get a bit long, would it make
>> sense to replace them with a flag or equivalent?
>
> To what end? Shorter lines? As in,

Pretty much, each expression is quite long and they seem to be growing
fairly rapidly as you and Ondrej discover similar boards.

>
>         if (board_is_ncr53c400a || board_is_dtc3181e) {
>                 /* ... */
>         }
>
> I suppose that could be an improvement if new flags would entirely replace
> the override.board struct member and the existing switch statement,
>
>         switch (overrides[current_override].board) {
>                 /* ... */
>         }
>
> Or maybe you meant testing a new flag something like this,
>
>         if (hostdata->ncr53c400_compatible) {
>                 /* ... */
>         }
>
> If your concern is the Don't Repeat Yourself rule, I'm not sure that new
> flag would get tested more than once (?) And it would still have to be
> assigned using an "objectionably" long expression, e.g.
>
>         hostdata->ncr53c400_compatible =
>                 overrides[current_override].board == BOARD_NCR53C400 ||
>                 overrides[current_override].board == BOARD_NCR53C400A ||
>                 overrides[current_override].board == BOARD_DTC3181E;
>
> Rather than add new flags, perhaps a 'switch' statement instead of an 'if'
> statement would be shorter (if the size of the expression is the problem).

I think switch statements would be cleaner in this particular
instance. I was thinking something like:

if (somthing->flags & NCR53C400_COMPATIBLE) {
    /* ... */
}

but if it's only ever going to be used once, then it's pretty
pointless and switch statements are cleaner.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
