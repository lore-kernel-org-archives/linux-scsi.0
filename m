From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix scsi cmnd retries in error handling
Date: Mon, 1 Nov 2010 21:53:28 +0800
Message-ID: <AANLkTikgNf=+7cWH0L3uUA5jMH88q4hEp3G+GWRdnyLm@mail.gmail.com>
References: <AANLkTikYv-4STgVob=7j70Mo2fuLOR=zc3=WTD7x3Kig@mail.gmail.com>
	<1288618715.3056.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab0KANx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 09:53:29 -0400
Received: by wyf28 with SMTP id 28so5534283wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 06:53:28 -0700 (PDT)
In-Reply-To: <1288618715.3056.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 1, 2010 at 9:38 PM, James Bottomley <James.Bottomley@suse.d=
e> wrote:
> On Mon, 2010-11-01 at 21:02 +0800, Hillf Danton wrote:
>> There are two instances of increment and test of retries of scsi cmn=
d
>> in functions scsi_decide_disposition() and scsi_eh_flush_done_q()
>> respectively.
>
> This analysis is incomplete. =C2=A0Those two functions are called in

Though incomplete, there is chance they could be threaded up by
scsi_unjam_host(). //Hillf

> completely separate paths, so you can't remove the increment from one
> and expect the other to compensate.
>
> James
>
>> One of the increments is overwork when the corresponding cmnds are s=
ame.
>> The overwork is fixed in scsi_decide_disposition().
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/scsi_error.c =C2=A0 =C2=A0 =C2=A0 2010-09-13 07:0=
7:38.000000000 +0800
>> +++ b/drivers/scsi/scsi_error.c =C2=A0 =C2=A0 =C2=A0 2010-11-01 20:3=
9:38.000000000 +0800
>> @@ -1541,7 +1541,7 @@ int scsi_decide_disposition(struct scsi_
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* the request was not marked fast fail. =C2=
=A0Note that above,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* even if the request is marked fast fail=
, we still requeue
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0* for queue congestion conditions (QUEUE_=
=46ULL or BUSY) */
>> - =C2=A0 =C2=A0 if ((++scmd->retries) <=3D scmd->allowed
>> + =C2=A0 =C2=A0 if (scmd->retries < scmd->allowed
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && !scsi_noretry_cmd(scmd)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NEEDS_RETRY;
>> =C2=A0 =C2=A0 =C2=A0 } else {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
