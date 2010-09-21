From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Wed, 22 Sep 2010 01:35:10 +0800
Message-ID: <AANLkTikFT3kS66r7tixPgrL5sM4CDzzGNWNjgQRPxA4V@mail.gmail.com>
References: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
	<1285083682.16440.36.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58729 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab0IURfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 13:35:12 -0400
Received: by wyf22 with SMTP id 22so5633439wyf.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 10:35:11 -0700 (PDT)
In-Reply-To: <1285083682.16440.36.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 21, 2010 at 11:41 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Tue, 2010-09-21 at 23:19 +0800, Hillf Danton wrote:
>> The tests for QUEUE_FLAG_REENTER seem unnecessary.
>> And check for get_device() is added.
>
> OK, so you've done a few newbie patches; it's time to graduate.
>

What is the certificate :-)

>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c =C2=A0 =C2=A0=
 =C2=A0 2010-09-13
>> 07:07:38.000000000 +0800
>> +++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c =C2=A0 =C2=A0=
 =C2=A0 2010-09-21
>> 22:05:38.000000000 +0800
>> @@ -3766,16 +3766,11 @@ fc_bsg_goose_queue(struct fc_rport *rpor
>> =C2=A0 =C2=A0 =C2=A0 if (!rport->rqst_q)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>>
>> - =C2=A0 =C2=A0 get_device(&rport->dev);
>> + =C2=A0 =C2=A0 if (! get_device(&rport->dev))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>
> The expression in the if clause is never true ... can you tell me why=
?
>

It is simple. What get_device does is clear, and I am paranoid.

struct device *get_device(struct device *dev)
{
	return dev ? to_dev(kobject_get(&dev->kobj)) : NULL;
}

>> =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(rport->rqst_q->queue_lock, fl=
ags);
>> - =C2=A0 =C2=A0 flagset =3D test_bit(QUEUE_FLAG_REENTER, &rport->rqs=
t_q->queue_flags) &&
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !test_bit(QUEUE_F=
LAG_REENTER, &rport->rqst_q->queue_flags);
>> - =C2=A0 =C2=A0 if (flagset)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_flag_set(QUEUE_FLA=
G_REENTER, rport->rqst_q);
>> =C2=A0 =C2=A0 =C2=A0 __blk_run_queue(rport->rqst_q);
>> - =C2=A0 =C2=A0 if (flagset)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_flag_clear(QUEUE_F=
LAG_REENTER, rport->rqst_q);
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(rport->rqst_q->queue_loc=
k, flags);
>
> this code doesn't do anything because there's a bug in it. =C2=A0If y=
ou can
> work out what it's trying to do, you should be able to fix the bug.
>
> James
>

It is hard to point out what is the bug, since flagset never is true.
And I guess that simply calling blk_run_queue() seems fine,
leaving check for QUEUE_FLAG_REENTER to be done in block core.
Hillf


--- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-22
01:37:42.000000000 +0800
@@ -3760,24 +3760,11 @@ fail_host_msg:
 static void
 fc_bsg_goose_queue(struct fc_rport *rport)
 {
-	int flagset;
-	unsigned long flags;
-
 	if (!rport->rqst_q)
 		return;

 	get_device(&rport->dev);
-
-	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset =3D test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags)=
 &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
-
+	blk_run_queue(rport->rqst_q);
 	put_device(&rport->dev);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
