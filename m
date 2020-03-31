Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CEBC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 18:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFDC22054F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 18:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PGbHZFmN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCaSGR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 14:06:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50190 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgCaSGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 14:06:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id t128so3588706wma.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rdHIFzp6WyS0NijgnSKxc0qBm0w7b6RkFiTqIi5G0RI=;
        b=PGbHZFmNgek1IF9cb9XkbLzdCxHpn4Gh5pLqY2lNXlPYj2wgdW2tpOyQfxRW+lADlM
         BMGcDDbQ2/yv6YArqmRRlo7X7B7yryVBNiJbkHmb2bDeEO64PVl/wdpd5zGAvGkTqhtq
         uYAw9gYLQAyVV8jj+4SPAqa6Ydz5DH9zM2nwcHPyYJq6Qk8Td29I8douEblKObLiexak
         x1MpLaxLZjIScdnqlbeK0d8rCrxP/0iKBBR2PkGXXWziupX0gRV3DYVXQH+S2RMUoBpJ
         PSLt9c3LjYT3vExYUvVEmcbD97MSoJhpftyBhiRnQgNH2lIEG+9mHNLTrHR4WN4G/HS7
         ObIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=rdHIFzp6WyS0NijgnSKxc0qBm0w7b6RkFiTqIi5G0RI=;
        b=Qew2EQ9RbV887zRRQi9Z13+RNBZKobon4Wzgd6oJnpB7lSneMtRiOPEvgEvezwKwPD
         CW6d+wYGKp1CTJzM+bHvF6MtKBDxSvTXyNCfaXmMF4122fp7YD9/sPSKsJEfneZeRK7o
         LoEfq0VENsyKs3c1kOsxHtYOKe3J6Q8kGJiokqABtVRZM8QKq4SBZN7dPHjO4Dg5ilRX
         sPWhWHUgtHWUtQbxfjcsV1qKISUcBH0L4YgHTJDBLD6oseJimN1BJZYoGtq2c8/fheoh
         XuOsen+k71zLX9ECByDTuz7Icq5cmIZhu4m2PNGI2Q/tKjoQubSOUxDF5zTeF+iVugIA
         3+1A==
X-Gm-Message-State: AGi0Puaw0WHkfu3iGfksoX7AtpjDTYbr5PjMAnYxlKx+YjGmbfz6WWve
        JM2Qlq89bn41EJzbOZPy6bAnSQ==
X-Google-Smtp-Source: APiQypID0x6nOClfq+P0TTy8TSQdW9f1BCd93MzMM1F4FQaFe2EeZjymclbKAMKVAxxzX94LrjBXSQ==
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr23109wmj.77.1585677972371;
        Tue, 31 Mar 2020 11:06:12 -0700 (PDT)
Received: from [192.168.0.102] ([84.33.138.35])
        by smtp.gmail.com with ESMTPSA id y11sm4580878wmi.13.2020.03.31.11.06.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 11:06:11 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <20200331014109.GA20230@ming.t460p>
Date:   Tue, 31 Mar 2020 20:07:35 +0200
Cc:     Douglas Anderson <dianders@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-scsi@vger.kernel.org, sqazi@google.com,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
References: <20200330144907.13011-1-dianders@chromium.org>
 <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p>
To:     Ming Lei <ming.lei@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Il giorno 31 mar 2020, alle ore 03:41, Ming Lei <ming.lei@redhat.com> =
ha scritto:
>=20
> On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
>> It is possible for two threads to be running
>> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
>> This is because there can be more than one caller to
>> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
>> prevent more than one thread from entering.
>>=20
>> If more than one thread is running blk_mq_do_dispatch_sched() at the
>> same time with the same "hctx", they may have contention acquiring
>> budget.  The blk_mq_get_dispatch_budget() can eventually translate
>> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
>> uncommon) then only one of the two threads will be the one to
>> increment "device_busy" to 1 and get the budget.
>>=20
>> The losing thread will break out of blk_mq_do_dispatch_sched() and
>> will stop dispatching requests.  The assumption is that when more
>> budget is available later (when existing transactions finish) the
>> queue will be kicked again, perhaps in scsi_end_request().
>>=20
>> The winning thread now has budget and can go on to call
>> dispatch_request().  If dispatch_request() returns NULL here then we
>> have a potential problem.  Specifically we'll now call
>=20
> I guess this problem should be BFQ specific. Now there is definitely
> requests in BFQ queue wrt. this hctx. However, looks this request is
> only available from another loser thread, and it won't be retrieved in
> the winning thread via e->type->ops.dispatch_request().
>=20
> Just wondering why BFQ is implemented in this way?
>=20

BFQ inherited this powerful non-working scheme from CFQ, some age ago.

In more detail: if BFQ has at least one non-empty internal queue, then
is says of course that there is work to do.  But if the currently
in-service queue is empty, and is expected to receive new I/O, then
BFQ plugs I/O dispatch to enforce service guarantees for the
in-service queue, i.e., BFQ responds NULL to a dispatch request.

It would be very easy to change bfq_has_work so that it returns false
in case the in-service queue is empty, even if there is I/O
backlogged.  My only concern is: since everything has worked with the
current scheme for probably 15 years, are we sure that everything is
still ok after we change this scheme?

I'm confident it would be ok, because a timer fires if the in-service
queue does not receive any I/O for too long, and the handler of the
timer invokes blk_mq_run_hw_queues().

Looking forward to your feedback before proposing a change,
Paolo

>> blk_mq_put_dispatch_budget() which translates into
>> scsi_mq_put_budget().  That will mark the device as no longer busy =
but
>> doesn't do anything to kick the queue.  This violates the assumption
>> that the queue would be kicked when more budget was available.
>>=20
>> Pictorially:
>>=20
>> Thread A                          Thread B
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> blk_mq_get_dispatch_budget() =3D> 1
>> dispatch_request() =3D> NULL
>>                                  blk_mq_get_dispatch_budget() =3D> 0
>>                                  // because Thread A marked
>>                                  // "device_busy" in scsi_device
>> blk_mq_put_dispatch_budget()
>>=20
>> The above case was observed in reboot tests and caused a task to hang
>> forever waiting for IO to complete.  Traces showed that in fact two
>> tasks were running blk_mq_do_dispatch_sched() at the same time with
>> the same "hctx".  The task that got the budget did in fact see
>> dispatch_request() return NULL.  Both tasks returned and the system
>> went on for several minutes (until the hung task delay kicked in)
>> without the given "hctx" showing up again in traces.
>>=20
>> Let's attempt to fix this problem by detecting budget contention.  If
>> we're in the SCSI code's put_budget() function and we saw that =
someone
>> else might have wanted the budget we got then we'll kick the queue.
>>=20
>> The mechanism of kicking due to budget contention has the potential =
to
>> overcompensate and kick the queue more than strictly necessary, but =
it
>> shouldn't hurt.
>>=20
>> Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> ---
>>=20
>> drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
>> drivers/scsi/scsi_scan.c   |  1 +
>> include/scsi/scsi_device.h |  2 ++
>> 3 files changed, 27 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 610ee41fa54c..0530da909995 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -344,6 +344,21 @@ static void scsi_dec_host_busy(struct Scsi_Host =
*shost, struct scsi_cmnd *cmd)
>> 	rcu_read_unlock();
>> }
>>=20
>> +static void scsi_device_dec_busy(struct scsi_device *sdev)
>> +{
>> +	bool was_contention;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&sdev->budget_lock, flags);
>> +	atomic_dec(&sdev->device_busy);
>> +	was_contention =3D sdev->budget_contention;
>> +	sdev->budget_contention =3D false;
>> +	spin_unlock_irqrestore(&sdev->budget_lock, flags);
>> +
>> +	if (was_contention)
>> +		blk_mq_run_hw_queues(sdev->request_queue, true);
>> +}
>> +
>> void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd =
*cmd)
>> {
>> 	struct Scsi_Host *shost =3D sdev->host;
>> @@ -354,7 +369,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, =
struct scsi_cmnd *cmd)
>> 	if (starget->can_queue > 0)
>> 		atomic_dec(&starget->target_busy);
>>=20
>> -	atomic_dec(&sdev->device_busy);
>> +	scsi_device_dec_busy(sdev);
>> }
>>=20
>> static void scsi_kick_queue(struct request_queue *q)
>> @@ -1624,16 +1639,22 @@ static void scsi_mq_put_budget(struct =
blk_mq_hw_ctx *hctx)
>> 	struct request_queue *q =3D hctx->queue;
>> 	struct scsi_device *sdev =3D q->queuedata;
>>=20
>> -	atomic_dec(&sdev->device_busy);
>> +	scsi_device_dec_busy(sdev);
>> }
>>=20
>> static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
>> {
>> 	struct request_queue *q =3D hctx->queue;
>> 	struct scsi_device *sdev =3D q->queuedata;
>> +	unsigned long flags;
>>=20
>> -	if (scsi_dev_queue_ready(q, sdev))
>> +	spin_lock_irqsave(&sdev->budget_lock, flags);
>> +	if (scsi_dev_queue_ready(q, sdev)) {
>> +		spin_unlock_irqrestore(&sdev->budget_lock, flags);
>> 		return true;
>> +	}
>> +	sdev->budget_contention =3D true;
>> +	spin_unlock_irqrestore(&sdev->budget_lock, flags);
>=20
> No, it really hurts performance by adding one per-sdev spinlock in =
fast path,
> and we actually tried to kill the atomic variable of =
'sdev->device_busy'
> for high performance HBA.
>=20
> Thanks,
> Ming

