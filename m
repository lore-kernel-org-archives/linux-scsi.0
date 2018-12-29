From: LEROY Christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Sat, 29 Dec 2018 17:55:02 +0100
Message-ID: <20181229175502.Horde.OaGr035vfDpvlvNGdmoaOQ2@messagerie.si.c-s.fr>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
 <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
 <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>
 <alpine.LNX.2.21.1812291050330.152@nippy.intranet>
 <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>
List-Id: linux-scsi@vger.kernel.org

Michael Schmitz <schmitzmic@gmail.com> a écrit :

> Hi Finn,
>
> Am 29.12.2018 um 14:06 schrieb Finn Thain:
>> On Fri, 28 Dec 2018, LEROY Christophe wrote:
>>>> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
>>>> index 89f5154c40b6..99e5729d910d 100644
>>>> --- a/drivers/scsi/atari_scsi.c
>>>> +++ b/drivers/scsi/atari_scsi.c
>>>> @@ -755,9 +755,10 @@ static int __init atari_scsi_probe(struct
>>>> platform_device *pdev)
>>>> 	if (ATARIHW_PRESENT(TT_SCSI) && setup_sg_tablesize >= 0)
>>>> 		atari_scsi_template.sg_tablesize = setup_sg_tablesize;
>>>>
>>>> -	if (setup_hostid >= 0) {
>>>> +	if (setup_hostid >= 0)
>>>> 		atari_scsi_template.this_id = setup_hostid & 7;
>>>> -	} else {
>>>> +#ifdef CONFIG_NVRAM
>>>> +	else
>>>
>>> Such ifdefs should be avoided in C files.
>>> It would be better to use
>>>
>>> } else if (IS_ENABLED(CONFIG_NVRAM)) {
>>>
>>
>> I don't like #ifdefs either. However, as the maintainer of this file, I am
>> okay with this one.
>>
>> The old #ifdef CONFIG_NVRAM conditional compilation convention that gets
>> used here and under drivers/video/fbdev could probably be improved upon
>> but I consider this to be out-of-scope for this series, which is
>> complicated enough.
>>
>> And as explained in the commit log, CONFIG_NVRAM=y and CONFIG_NVRAM=m are
>> treaded differently by drivers. Therefore, IS_ENABLED would be incorrect.
>
> IS_BUILTIN(CONFIG_NVRAM) is probably what Christophe really meant to suggest.

Doesn't #ifdef means either y or m ? So the same as IS_ENABLED() ?

Christophe

>
> Or (really going out on a limb here):
>
> IS_BUILTIN(CONFIG_NVRAM) ||
> ( IS_MODULE(CONFIG_ATARI_SCSI) && IS_ENABLED(CONFIG_NVRAM) )
>
> Not that I'd advocate that, for this series.
>
> Cheers,
>
> 	Michael
