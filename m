From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: add check for host busy in scsi_run_queue()
Date: Tue, 21 Sep 2010 23:06:50 +0800
Message-ID: <AANLkTimMf89AG0YJUDiGnVzNKk30fFmd-1jhh1MmkkxM@mail.gmail.com>
References: <AANLkTi=jMYEsMtTQmnMSKxwYNzpwCLLkgsEvHAxWj8ui@mail.gmail.com>
	<1285005370.2973.272.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60956 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0IUPGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 11:06:52 -0400
Received: by wwi17 with SMTP id 17so41817wwi.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 08:06:51 -0700 (PDT)
In-Reply-To: <1285005370.2973.272.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 21, 2010 at 1:56 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Sun, 2010-09-19 at 20:53 +0800, Hillf Danton wrote:
>> It seems that check for host busy is deserved before scanning the st=
arved list.
>> And list operation is simplified.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- o/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c =C2=A0 =C2=A0 =C2=A0 =
=C2=A02010-09-13
>> 07:07:38.000000000 +0800
>> +++ m/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c =C2=A0 =C2=A0 =C2=A0 =
=C2=A02010-09-19
>> 20:32:34.000000000 +0800
>> @@ -399,18 +399,20 @@ static inline int scsi_host_is_busy(stru
>> =C2=A0 */
>> =C2=A0static void scsi_run_queue(struct request_queue *q)
>> =C2=A0{
>> - =C2=A0 =C2=A0 struct scsi_device *sdev =3D q->queuedata;
>> + =C2=A0 =C2=A0 struct scsi_device *sdev =3D q->queuedata, *safe;
>> =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *shost =3D sdev->host;
>> - =C2=A0 =C2=A0 LIST_HEAD(starved_list);
>> =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
>>
>> =C2=A0 =C2=A0 =C2=A0 if (scsi_target(sdev)->single_lun)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_single_lun_run=
(sdev);
>>
>> =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(shost->host_lock, flags);
>> - =C2=A0 =C2=A0 list_splice_init(&shost->starved_list, &starved_list=
);
>> -
>> - =C2=A0 =C2=A0 while (!list_empty(&starved_list)) {
>> + =C2=A0 =C2=A0 if (scsi_host_is_busy(shost)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(s=
host->host_lock, flags);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> + =C2=A0 =C2=A0 }
>
> To be honest, there's no real gain from this micro-optimisation.
>
>> + =C2=A0 =C2=A0 list_for_each_entry_safe(sdev, safe, &shost->starved=
_list,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 starved_ent=
ry) {
>
> And this is definitely wrong. =C2=A0The list is altered in flight so =
the
> whole purpose of the static copy is to process only what existed befo=
re
> we began; otherwise you can get a livelock.
>
node. Then the potential livelock could be fixed by
list_for_each_entry_safe_reverse().

> James
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
