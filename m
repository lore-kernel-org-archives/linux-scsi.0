From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] libfc: fix mem leak in fc_seq_assign()
Date: Wed, 20 Oct 2010 22:40:20 +0800
Message-ID: <AANLkTikup9smn6bb82YCjXLnTGOXcj_qstjq9rLMGKZk@mail.gmail.com>
References: <AANLkTimLBm2z=nWb_Q3MsyzFo_r6omMMQKnZ9FD2rtwW@mail.gmail.com>
	<4CBDD579.2010101@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64228 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0JTOkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2010 10:40:21 -0400
Received: by wyb28 with SMTP id 28so3842001wyb.19
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2010 07:40:20 -0700 (PDT)
In-Reply-To: <4CBDD579.2010101@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Wed, Oct 20, 2010 at 1:29 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
>
> On 10/19/10 7:17 AM, Hillf Danton wrote:
>> There seems exchs should get released in cases that FC_RJT_NONE is
>> returned, or they will no longer get freed.
>>
>> It also looks a typo like the following,
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_seq_loo=
kup_recip(lport, ema->mp, fp) !=3D FC_RJT_NONE)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_seq_loo=
kup_recip(lport, ema->mp, fp) =3D=3D FC_RJT_NONE)
>
> True.
>
>>
>> but I am not sure.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-09-13 07:07:38.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-10-19 21:48:22.=
000000000 +0800
>> @@ -3,6 +3,9 @@
>> =C2=A0 * Copyright(c) 2008 Red Hat, Inc. =C2=A0All rights reserved.
>> =C2=A0 * Copyright(c) 2008 Mike Christie
>> =C2=A0 *
>> + * Copyright(c) Oct 19, 2010 Hillf Danton
>> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 minor fix of memory leakage
>> + *
>
> Thanks for fixing the bug, but I don't think you should add a copyrig=
ht.

Node

> I didn't add a copyright when I created the bug.

The cool comment I ever seen, haha.

And the true patch will be prepared and delivered soon.

thanks //Hillf

>> =C2=A0 * This program is free software; you can redistribute it and/=
or modify it
>> =C2=A0 * under the terms and conditions of the GNU General Public Li=
cense,
>> =C2=A0 * version 2, as published by the Free Software Foundation.
>> @@ -1246,9 +1249,16 @@ static struct fc_seq *fc_seq_assign(stru
>> =C2=A0 =C2=A0 =C2=A0 fr_seq(fp) =3D NULL;
>>
>> =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(ema, &lport->ema_list, ema_=
list)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((!ema->match || ema-=
>match(fp)) &&
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_seq_loo=
kup_recip(lport, ema->mp, fp) !=3D FC_RJT_NONE)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (! ema->match || ema-=
>match(fp))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (fc_seq_lookup_recip(lport, ema->mp, fp) !=3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FC_RJT_NONE)
>
> Should continue in this case ... we hope to find the exchange in anot=
her
> exchange manager.
>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct fc_seq *seq =3D fr_seq(fp);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct fc_exch *exch =3D fc_seq_exch(se=
q);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_exch_release(exch);
>
> I want the sequence to be held by the frame, so don't do the release.
> In this case we should break, since we found the frame.
>
> This function is currently only used by target modules. =C2=A0A later
> patch exposes a release so they can release the sequence/exchange.
>
> So, my original code was right except for the !=3D vs =3D=3D bug.
> That turns out not to cause major problems if the first exchange
> manager assigns the exchange, which is why I didn't see the bug.
>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 return fr_seq(fp);
>> =C2=A0}
>
> By the way, I think patches to libfc, libfcoe, and fcoe should go to
> the open-fcoe list only, not to SCSI. =C2=A0Robert Love as the open-f=
coe
> maintainer will forward them after testing to the SCSI list.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Regards,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Joe
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
