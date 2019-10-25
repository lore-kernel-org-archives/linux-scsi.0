Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20243CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 10:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FA920663
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 10:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dhkPfUM0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393422AbfJYKEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 06:04:20 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:46586 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390461AbfJYKEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 06:04:20 -0400
Received: by mail-io1-f47.google.com with SMTP id c6so1693375ioo.13
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 03:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=wDejSyiecAnMRTYtfiCCFlfjgsZFLIsFYK2gXKx4bEY=;
        b=dhkPfUM0ZXkH9NyKk2KX3LmIK815edufBfcCn+Tf0ubWrztRKgx3SS/3XRRs/eDhvK
         KqMVWJwd0/RNmwGl96YP9rSpxD78elZlfCNRlJcCmvhJ6MPdLnW38Rh5OgVpzUrtMzSB
         dKaAcJYFZWp1RknOwkuBY5eiP1MN6pbnR/brQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=wDejSyiecAnMRTYtfiCCFlfjgsZFLIsFYK2gXKx4bEY=;
        b=a3uB2vujCOfJq8XKBdSX2OglClZE1NkIBksZ7ljfbgpbQb7HWUEzVkio8vongtMOBJ
         /9OTIeiZsedKEPrmmEoNnfSIywYmbFM+9KUW8NC7SYWv2W+bQDhidsgAi/VI18uPs4S1
         SwsWKplzcrXmEhBZz5WFKza2gVeLObjJ3hEu7+EcWd2KkFfggnPFIeT6kOjKAeYKFiWj
         Yw3bvoNG1eUy3wl2CxzkVJhgHS9WFHhZyCYZwEWmhW2AmUbscCCc6Kdgyn10BUVN1LEq
         ed8z2Xb2Cmy1+/iWZB2ciw+ArjRrHfcZTPjyQjIV6D7E96iXL2hrHXVNveCOvs9yzAfu
         sOlA==
X-Gm-Message-State: APjAAAW7kU2R0V62Wil5odBy7ZTrD2JWX4Vn9StDCo4Jz+u8HBGz1wdX
        f3hMtuGzHrpG2AElNlkyYEay9kI1Yifg8kvDaO4V3w==
X-Google-Smtp-Source: APXvYqwREUbDLaQPgk99D6RWdCJZjqXCR5TnG1iPCQ8K9FFnYZ4AkcPxwZiVo3x/bfExeJE0mDuJbE5oxAdH0mFD8nQ=
X-Received: by 2002:a6b:7a04:: with SMTP id h4mr2752142iom.210.1571997859450;
 Fri, 25 Oct 2019 03:04:19 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191009093241.21481-1-ming.lei@redhat.com> <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org> <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p> <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
 <20191024010911.GC15426@ming.t460p>
In-Reply-To: <20191024010911.GC15426@ming.t460p>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ+aAV5wNbUGIJ6nkm2Ot6VMXRpiQIhodcgAyzU6WgBsIy1CAFrdb8sAhQC8V0BsoKNY6W33gIA
Date:   Fri, 25 Oct 2019 15:34:16 +0530
Message-ID: <a7c33fc8ee31675bce38aca5894be2a6@mail.gmail.com>
Subject: RE: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> > >
> > > > Can we get supporting API from block layer (through SML)  ?
> > > > something similar to "atomic_read(&hctx->nr_active)" which can be
> > > > derived from
> > > > sdev->request_queue->hctx ?
> > > > At least for those driver which is nr_hw_queue = 1, it will be
> > > > useful and we can avoid sdev->device_busy dependency.
> > >
> > > If you mean to add new atomic counter, we just move the .device_busy
> > into
> > > blk-mq, that can become new bottleneck.
> >
> > How about below ? We define and use below API instead of
> > "atomic_read(&scp->device->device_busy) >" and it is giving expected
> > value. I have not captured performance impact on max IOPs profile.
> >
> > Inline unsigned long sdev_nr_inflight_request(struct request_queue *q)
> > {
> >         struct blk_mq_hw_ctx *hctx;
> >         unsigned long nr_requests = 0;
> >         int i;
> >
> >         queue_for_each_hw_ctx(q, hctx, i)
> >                 nr_requests += atomic_read(&hctx->nr_active);
> >
> >         return nr_requests;
> > }
>
> There is still difference between above and .device_busy in case of
none,
> because .nr_active is accounted actually when allocating the request
instead
> of getting driver tag(or before calling .queue_rq).


This will be fine as long as we get outstanding from allocation time
itself.
>
> Also the above only works in case that there are more than one active
LUNs.

I am not able to understand this part. We have tested on setup which has
only one active LUN and it works. Can you help me to understand this part
?

>
> If you don't need it in case of single LUN AND don't care the difference
in case
> of none, the above API looks fine.
>
> Thanks,
> Ming
