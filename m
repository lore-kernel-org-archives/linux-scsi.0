From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: fix error handling in fc_exch_rrq_resp()
Date: Mon, 25 Oct 2010 21:16:39 +0800
Message-ID: <AANLkTikJYd4jGt_E5TfL4gKQ1o9GMHtoe06q0wH5Szdw@mail.gmail.com>
References: <AANLkTik3GbuiEGVPigGZp+=RH7qRMarn0cdZJ49Toso7@mail.gmail.com>
	<4CC1DEAF.50403@cisco.com>
	<AANLkTi=K=1hE4-D0gsTsSRAj3bE0Y+=B1BQH3AH7DW8m@mail.gmail.com>
	<4CC521C7.4010001@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JYNQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 09:16:40 -0400
Received: by wyf28 with SMTP id 28so3382057wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 06:16:39 -0700 (PDT)
In-Reply-To: <4CC521C7.4010001@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Mon, Oct 25, 2010 at 2:20 PM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
> <dropped scsi alias>
>
> On 10/23/10 12:56 AM, Hillf Danton wrote:
>>
>> On Sat, Oct 23, 2010 at 2:57 AM, Joe Eykholt<jeykholt@cisco.com> =C2=
=A0wrote:
>>>
>>>
>>> On 10/22/10 8:21 AM, Hillf Danton wrote:
>>>>
>>>> There seems no cleanup left when FC_EX_CLOSED encountered, which m=
ay
>>>> be from fc_exch_reset().
>>>
>>> Are you sure? =C2=A0It seems that the RRQ exchange has a hold on an=
other
>>> exchange, the one that's the subject of the RRQ. =C2=A0That exchang=
e
>>
>> In case of fc_exch_pool_reset(), each exch on ex_list is delivered t=
o
>> fc_exch_reset(), =C2=A0so "another" and "that" exch are treated in s=
ame way.
>
> True, but nothing else is going to release the other exchange.

Here is snippet from fc_exch_reset(),

	if (ep->esb_stat & ESB_ST_REC_QUAL)
		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec_qual */
	ep->esb_stat &=3D ~ESB_ST_REC_QUAL;

the hold does get dropped, based upon which it looks the cleanup in
fc_exch_reset() gets no more work left for response-handler.

>
>> After cleanup, then the resp handler, if attached, is issued with
>> FC_EX_CLOSED,
>> so no more work left for the resp handler.
>>
>> If still needed, overwork occurs before calling resp handler.
>
> This happens so infrequently that the amount of extra work, if any,
> is not significant.
>
>>> still needs to be released. =C2=A0I could be wrong, it's been a whi=
le.
>>>
>>>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>>>> ---
>>>>
>>>> --- a/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-09-13 07:07:3=
8.000000000
>>>> +0800
>>>> +++ b/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-10-22 23:17:5=
0.000000000
>>>> +0800
>>>> @@ -1827,7 +1827,9 @@ static void fc_exch_rrq_resp(struct fc_s
>>>> =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(fp)) {
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err =3D PTR_E=
RR(fp);
>>>>
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_=
CLOSED || err =3D=3D -FC_EX_TIMEOUT)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_=
CLOSED)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_=
TIMEOUT)
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto cleanup;
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FC_EXCH_DBG(abort=
ed_ep, "Cannot process RRQ, "
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 "frame error %d\n", err);
>>>> _______________________________________________
>>>> devel mailing list
>>>> devel@open-fcoe.org
>>>> http://www.open-fcoe.org/mailman/listinfo/devel
>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
