From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix the poll method of bsg file operations in Block layer
 SCSI generic driver
Date: Thu, 11 Nov 2010 21:42:47 +0800
Message-ID: <AANLkTimSm687VOENtqBbrK+LyQYndGaLX4yB683=8C4G@mail.gmail.com>
References: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
	<1289400533.2208.6.camel@cowboy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0KKNmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 08:42:50 -0500
In-Reply-To: <1289400533.2208.6.camel@cowboy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dave@gnu.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>

On Wed, Nov 10, 2010 at 10:48 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> On Wed, 2010-11-10 at 21:58 +0800, Hillf Danton wrote:
>> Though it looks like a typo, the check for POLLOUT is computed incor=
rectly.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/block/bsg.c =C2=A0 =C2=A0 2010-09-13 07:07:38.000000000 +0800
>> +++ b/block/bsg.c =C2=A0 =C2=A0 2010-11-10 21:40:30.000000000 +0800
>> @@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
>> =C2=A0 =C2=A0 =C2=A0 if (!list_empty(&bd->done_list))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask |=3D POLLIN | =
POLLRDNORM;
>> =C2=A0 =C2=A0 =C2=A0 if (bd->queued_cmds >=3D bd->max_queue)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ;
>> + =C2=A0 =C2=A0 else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask |=3D POLLOUT;
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(&bd->lock);
>
> How about something more like this:
>
> diff --git a/block/bsg.c b/block/bsg.c
> index f20d6a7..2663db3 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -870,7 +870,7 @@ static unsigned int bsg_poll(struct file *file,
> poll_table *wait)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&bd->lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!list_empty(&bd->done_list))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mask |=3D POLL=
IN | POLLRDNORM;
> - =C2=A0 =C2=A0 =C2=A0 if (bd->queued_cmds >=3D bd->max_queue)
> + =C2=A0 =C2=A0 =C2=A0 if (bd->queued_cmds < bd->max_queue)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mask |=3D POLL=
OUT;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&bd->lock);
>
>
> Thanks,
> Davidlohr
>
cool, thanks//Hillf

>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kern=
el" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
