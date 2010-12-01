From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix scsi cmnd retries in error handling
Date: Wed, 1 Dec 2010 22:09:58 +0800
Message-ID: <AANLkTi=HWJXQpQPPtFwPvaZsKyqvbA1hW5J3sWod+qcV@mail.gmail.com>
References: <AANLkTikYv-4STgVob=7j70Mo2fuLOR=zc3=WTD7x3Kig@mail.gmail.com>
	<1288618715.3056.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58377 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0LAOKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2010 09:10:01 -0500
Received: by wwa36 with SMTP id 36so7429894wwa.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2010 06:10:00 -0800 (PST)
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
> completely separate paths, so you can't remove the increment from one
> and expect the other to compensate.
>

The delivered is not correct, and it could get fixed.


--- a/drivers/scsi/scsi_error.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-12-01 21:55:52.000000000 +0800
@@ -927,6 +927,13 @@ int scsi_eh_get_sense(struct list_head *
 			scmd->retries =3D scmd->allowed;
 		else if (rtn !=3D NEEDS_RETRY)
 			continue;
+		else if (host_byte(scmd->result) !=3D DID_IMM_RETRY)
+			/*
+			 * in case of NEEDS_RETRY, undo the increment of
+			 * retries in scsi_decide_disposition() since it
+			 * is also checked when flushing done_q.
+			 */
+			scmd->retries--;

 		scsi_eh_finish_cmd(scmd, done_q);
 	}



But there is still room for simplification,

--- a/drivers/scsi/scsi_error.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-12-01 22:08:34.000000000 +0800
@@ -896,6 +896,8 @@ int scsi_eh_get_sense(struct list_head *
 	struct scsi_cmnd *scmd, *next;
 	int rtn;

+	return list_empty(work_q);
+
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))


since SCSI_EH_CANCEL_CMD is concerned not only by scsi_eh_scmd_add() bu=
t by
scsi_eh_get_sense() also, which looks a reasonable explanation to what
they are called in
completely separate paths.

Thanks
Hillf


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
