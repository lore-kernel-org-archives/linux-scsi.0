From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: fix error handling in fc_exch_rrq_resp()
Date: Sat, 23 Oct 2010 15:56:50 +0800
Message-ID: <AANLkTi=K=1hE4-D0gsTsSRAj3bE0Y+=B1BQH3AH7DW8m@mail.gmail.com>
References: <AANLkTik3GbuiEGVPigGZp+=RH7qRMarn0cdZJ49Toso7@mail.gmail.com>
	<4CC1DEAF.50403@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34619 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0JWH4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 03:56:53 -0400
Received: by wwe15 with SMTP id 15so1730801wwe.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 Oct 2010 00:56:52 -0700 (PDT)
In-Reply-To: <4CC1DEAF.50403@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Sat, Oct 23, 2010 at 2:57 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
>
>
> On 10/22/10 8:21 AM, Hillf Danton wrote:
>> There seems no cleanup left when FC_EX_CLOSED encountered, which may
>> be from fc_exch_reset().
>
> Are you sure? =C2=A0It seems that the RRQ exchange has a hold on anot=
her
> exchange, the one that's the subject of the RRQ. =C2=A0That exchange

In case of fc_exch_pool_reset(), each exch on ex_list is delivered to
fc_exch_reset(),  so "another" and "that" exch are treated in same way.

After cleanup, then the resp handler, if attached, is issued with FC_EX=
_CLOSED,
so no more work left for the resp handler.

If still needed, overwork occurs before calling resp handler.

> still needs to be released. =C2=A0I could be wrong, it's been a while=
=2E
>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-09-13 07:07:38.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_exch.c =C2=A0 =C2=A02010-10-22 23:17:50.=
000000000 +0800
>> @@ -1827,7 +1827,9 @@ static void fc_exch_rrq_resp(struct fc_s
>> =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(fp)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err =3D PTR_ERR=
(fp);
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_CL=
OSED || err =3D=3D -FC_EX_TIMEOUT)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_CL=
OSED)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D -FC_EX_TI=
MEOUT)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto cleanup;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FC_EXCH_DBG(aborted=
_ep, "Cannot process RRQ, "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "frame error %d\n", err);
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
