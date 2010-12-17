From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] fix computation related to FC_EX_CLOSED in FC
 local port
Date: Fri, 17 Dec 2010 21:17:32 +0800
Message-ID: <AANLkTikEp2d8GZ_heoT148BUfO_5KS+hzi29n9gOX9sG@mail.gmail.com>
References: <AANLkTinZ04+m0-TOrv3vbLNH43b4VqKNJ9EyXdJYgj1A@mail.gmail.com>
	<1292529942.15910.17.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40123 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0LQNRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2010 08:17:35 -0500
Received: by wyb28 with SMTP id 28so600859wyb.19
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2010 05:17:34 -0800 (PST)
In-Reply-To: <1292529942.15910.17.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Fri, Dec 17, 2010 at 4:05 AM, Vasu Dev <vasu.dev@linux.intel.com> wr=
ote:
> On Thu, 2010-12-16 at 23:54 +0800, Hillf Danton wrote:
>> In fc_lport_error(), FC_EX_CLOSED could be understood to be no more
>> rettries, so resetting local port is reasonable and necessary.
>>
>
> It is not reasonable/necessary in this case as FC_EX_CLOSED is issued=
 on
> lport reset thru exch block reset called there, so doing lport reset
> again in same call flow is not needed unless I'm missing something to=
 do
> reset again here. Are hitting any bug which got fixed by this patch ?
>
Umm..why could lport reset then when no more retries, first?
And how about the state machine of lport then if nothing done, second?

It looks not buggy, I think.
>
>> When processing response to flogi request, FC_EX_CLOSED should be
>> treated as other errors, since the state machine of local port could
>> reach reset.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_lport.c =C2=A0 2010-11-01 19:54:12.00000=
0000 +0800
>> +++ b/drivers/scsi/libfc/fc_lport.c =C2=A0 2010-12-16 23:46:06.00000=
0000 +0800
>> @@ -1013,7 +1013,7 @@ static void fc_lport_error(struct fc_lpo
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
lport->retry_count);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (PTR_ERR(fp) =3D=3D -FC_EX_CLOSED)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto reset;
>>
>> =C2=A0 =C2=A0 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Memory allocation failure, or the excha=
nge timed out
>> @@ -1029,6 +1029,7 @@ static void fc_lport_error(struct fc_lpo
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schedule_delayed_wo=
rk(&lport->retry_work, delay);
>> =C2=A0 =C2=A0 =C2=A0 } else
>> + reset:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_lport_enter_rese=
t(lport);
>> =C2=A0}
>>
>> @@ -1428,9 +1429,6 @@ void fc_lport_flogi_resp(struct fc_seq *
>>
>> =C2=A0 =C2=A0 =C2=A0 FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc=
_els_resp_type(fp));
>>
>> - =C2=A0 =C2=A0 if (fp =3D=3D ERR_PTR(-FC_EX_CLOSED))
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> -
>
> Like other resp handlers in lport.c, above code is required instead j=
ust
> removing for =C2=A0fc_lport_flogi_resp, this is to allow exch clean u=
p on
> exch block reset.
=46irst, this error could be processed correctly after lock.
And it could be also processed with more cares not only in the above
error handler.

And the state machine of lport is the major concern of the patch,
simply returning
helps little.

Cheers
Hillf

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Vasu
>
>> =C2=A0 =C2=A0 =C2=A0 mutex_lock(&lport->lp_mutex);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (lport->state !=3D LPORT_ST_FLOGI) {
>> _______________________________________________
>> devel mailing list
>> devel@lists.open-fcoe.org
>> https://lists.open-fcoe.org/mailman/listinfo/devel
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
