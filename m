From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] libfc: fix stats computation in fc_queuecommand()
Date: Thu, 28 Oct 2010 22:24:05 +0800
Message-ID: <AANLkTi=shB6dQb9q1R=V=Cr7fFV5GUSabn3drjg-d3V+@mail.gmail.com>
References: <AANLkTimz_LBaPPJ_irEjiBy+f_MPCYYbLvD=oEw=JT-c@mail.gmail.com>
	<AANLkTimVZpakuwjAk0BJFhxtfZ5+Koard6=DE7LXVr6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64242 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0J1OYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 10:24:08 -0400
Received: by wwi18 with SMTP id 18so2938117wwi.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 07:24:06 -0700 (PDT)
In-Reply-To: <AANLkTimVZpakuwjAk0BJFhxtfZ5+Koard6=DE7LXVr6g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chetan Loke <chetanloke@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Tue, Oct 26, 2010 at 11:02 PM, Chetan Loke <chetanloke@gmail.com> wr=
ote:
> On Tue, Oct 26, 2010 at 9:01 AM, Hillf Danton <dhillf@gmail.com> wrot=
e:
>> There seems accumulation needed.
>
> I'm looking at the code but why increment in queue-command. What if
> the cmd-fails then
> we would need to decrement the counters. If not done already then
> fc_io_cmpl would be
> a nice place to handle the counters.

It is fixed for clear display somewhere else.

Though what you concern is out of the scope of this patch, patch is wel=
come.

Please patch the counters //Hillf

>
> Chetan Loke
>
>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-09-13 07=
:07:38.000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-10-26 20=
:52:46.000000000 +0800
>> @@ -1821,11 +1821,11 @@ int fc_queuecommand(struct scsi_cmnd *sc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sc_cmd->sc_data_direction =3D=3D DMA_=
=46ROM_DEVICE) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flag=
s =3D FC_SRB_READ;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->InputR=
equests++;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->InputMegab=
ytes =3D fsp->data_len;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->InputMegab=
ytes +=3D fsp->data_len;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (sc_cmd->sc_data_direction =3D=3D=
 DMA_TO_DEVICE) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flag=
s =3D FC_SRB_WRITE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->Output=
Requests++;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->OutputMega=
bytes =3D fsp->data_len;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->OutputMega=
bytes +=3D fsp->data_len;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flag=
s =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->Contro=
lRequests++;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
