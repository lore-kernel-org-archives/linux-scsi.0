From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Sat, 29 Dec 2018 15:50:23 +1300
Message-ID: <5e901432-65e2-c87b-31e3-36a394687a9a@gmail.com>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
 <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
 <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>
 <alpine.LNX.2.21.1812291050330.152@nippy.intranet>
 <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
 <alpine.LNX.2.21.1812291327380.152@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1812291327380.152@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: LEROY Christophe <christophe.leroy@c-s.fr>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 29.12.2018 um 15:34 schrieb Finn Thain:
> On Sat, 29 Dec 2018, Michael Schmitz wrote:
>
>>
>> IS_BUILTIN(CONFIG_NVRAM) is probably what Christophe really meant to suggest.
>>
>> Or (really going out on a limb here):
>>
>> IS_BUILTIN(CONFIG_NVRAM) ||
>> ( IS_MODULE(CONFIG_ATARI_SCSI) && IS_ENABLED(CONFIG_NVRAM) )
>>
>> Not that I'd advocate that, for this series.
>>
>
> Well, you are a maintainer for atari_scsi.c.
>
> Are you saying that you want IS_BUILTIN(CONFIG_NVRAM) used here instead of
> ifdef?

No, just pointing out that there would be a way to avoid the ifdef 
without messing up driver behaviour. I'm fine with the ifdef - not least 
because it clearly eliminates code that would be unreachable.

(On second thought - I don't want to speculate whether there's weird 
compiler options that could result in the nvram_check_checksum and 
nvram_read_bytes symbols to still be referenced in the final link, even 
though IS_BUILTIN(CONFIG_NVRAM) always evaluates to false. Best leave 
this as-is.)

> OTOH, if you approve of the existing patch, please send your acked-by.

Of course - I'd seen Geert's acked-by on some of the patches and forgot 
to check which still required acks.

Cheers,

	Michael
