From: LEROY Christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Sun, 30 Dec 2018 18:50:02 +0100
Message-ID: <20181230185002.Horde.AdSknvcs4hP1Kh_T_Cos6w8@messagerie.si.c-s.fr>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
 <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
 <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>
 <alpine.LNX.2.21.1812291050330.152@nippy.intranet>
 <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
 <alpine.LNX.2.21.1812291327380.152@nippy.intranet>
 <5e901432-65e2-c87b-31e3-36a394687a9a@gmail.com>
 <CAK8P3a1J3sy55nd5QbxR5AjxkLyE-RE=bDNKB9sG27xx=mZ60A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1J3sy55nd5QbxR5AjxkLyE-RE=bDNKB9sG27xx=mZ60A@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Finn Thain <fthain@telegraphics.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> a écrit :

> On Sat, Dec 29, 2018 at 3:51 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>
>> Hi Finn,
>>
>> Am 29.12.2018 um 15:34 schrieb Finn Thain:
>> > On Sat, 29 Dec 2018, Michael Schmitz wrote:
>> >
>> >>
>> >> IS_BUILTIN(CONFIG_NVRAM) is probably what Christophe really  
>> meant to suggest.
>> >>
>> >> Or (really going out on a limb here):
>> >>
>> >> IS_BUILTIN(CONFIG_NVRAM) ||
>> >> ( IS_MODULE(CONFIG_ATARI_SCSI) && IS_ENABLED(CONFIG_NVRAM) )
>> >>
>> >> Not that I'd advocate that, for this series.
>> >>
>> >
>> > Well, you are a maintainer for atari_scsi.c.
>> >
>> > Are you saying that you want IS_BUILTIN(CONFIG_NVRAM) used here instead of
>> > ifdef?
>>
>> No, just pointing out that there would be a way to avoid the ifdef
>> without messing up driver behaviour. I'm fine with the ifdef - not least
>> because it clearly eliminates code that would be unreachable.
>>
>> (On second thought - I don't want to speculate whether there's weird
>> compiler options that could result in the nvram_check_checksum and
>> nvram_read_bytes symbols to still be referenced in the final link, even
>> though IS_BUILTIN(CONFIG_NVRAM) always evaluates to false. Best leave
>> this as-is.)
>
> As far as I know, it's totally reliable with the supported compilers  
> (gcc-4.6+).
> In the older compilers (e.g. 4.1), there was a corner case, where it could
> have failed to eliminate a function that was only referenced through  
> a pointer
> from a discarded variable, but a plain IS_ENABLED() check like the one here
> was still ok, and lots of code relies on that.
>
> Other than that, I agree either way is totally fine here, so no objections
> to using the #ifdef.

As far as I know, kernel codying style promotes the use of  
IS_ENABLED() etc. instead of #ifdefs when possible.

Christophe

>
>       Arnd
