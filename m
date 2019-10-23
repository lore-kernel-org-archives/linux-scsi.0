Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6901DCA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 07:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E89214B2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 07:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NeCLbHbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389996AbfJWHqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 03:46:52 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44414 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389298AbfJWHqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 03:46:52 -0400
Received: by mail-io1-f68.google.com with SMTP id w12so23740676iol.11
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 00:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=q0e/9CxeRutenKBmdJQpC7NiIqVlkcA6K4uzWSSUi8o=;
        b=NeCLbHbRvUyx7yGz1U2/4vdlveC7nhhDzlVkUiECah5jYsMNrAaddvWXUsFusfEB9C
         nwBT4HxZ40Fjv58rr+/B1crAgtR+rTYIvarKszija0l1Hke8V1Jkq0kGrPAOTYI1Ha4S
         Wjyhsl8HoZ/eNYxCsnH2DdAByvBGQhbIA6ejo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=q0e/9CxeRutenKBmdJQpC7NiIqVlkcA6K4uzWSSUi8o=;
        b=dwctyX4JBQsWzdAw6W+r1JDQBQhONc0qVfsP+VtD5CdhlHzsnadvvE6pK9pGQB4f8v
         XuLJZyWCYTMGrtv7sGCF8svbBFsiuAuE3iE6NH7FkFqa+m9FdoXbGGnnGbObpb2LoTl0
         O+3mIKUM+iYQCG7VZLUqkJFf2qI/CQaCOzmEOcevlsUJbLOXxb3ipTe3R34iQ9srMin2
         GX6i29d365sXRyO4wYCDLt470QKiyaCEk5Lc4HyMbjF0EBL8/5HRL0OqWLc9XHcc/+BW
         Nci2yokT8HyjJLxLKx+POjuBdy6ZfCGfCWA+miFm15/Ma/Zkdw+d3RUcHDc1ojxEAo0/
         L+wg==
X-Gm-Message-State: APjAAAWK3QZeS6aN/2UZAwasVlaZ7cVskAT524xFGSheedCdJQYbjlap
        NYLI65gMVK8HhpGutuAyPk9RNKRWDMhj2auws5D1Tw==
X-Google-Smtp-Source: APXvYqz+pfOnKk1jk3VI/4TsKC0C1gckdkoFyC4BM6MkevRLO/JvZEpW5SHEOyyZ4TdKnY89493XVCOToRJpBznh9Bw=
X-Received: by 2002:a6b:e30f:: with SMTP id u15mr1854804ioc.96.1571816811517;
 Wed, 23 Oct 2019 00:46:51 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191009093241.21481-1-ming.lei@redhat.com> <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org> <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p>
In-Reply-To: <20191023012838.GB18083@ming.t460p>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ+aAV5wNbUGIJ6nkm2Ot6VMXRpiQIhodcgAyzU6WgBsIy1CAFrdb8spdLE/MA=
Date:   Wed, 23 Oct 2019 13:16:48 +0530
Message-ID: <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
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

V4 2/2] scsi: core: don't limit per-LUN queue depth
> for SSD
>
> On Fri, Oct 18, 2019 at 12:00:07AM +0530, Kashyap Desai wrote:
> > > On 10/9/19 2:32 AM, Ming Lei wrote:
> > > > @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device
> > > > *sdev,
> > > struct scsi_cmnd *cmd)
> > > >   	if (starget->can_queue > 0)
> > > >   		atomic_dec(&starget->target_busy);
> > > >
> > > > -	atomic_dec(&sdev->device_busy);
> > > > +	if (!blk_queue_nonrot(sdev->request_queue))
> > > > +		atomic_dec(&sdev->device_busy);
> > > >   }
> > > >
> > >
> > > Hi Ming,
> > >
> > > Does this patch impact the meaning of the queue_depth sysfs
> > > attribute (see also sdev_store_queue_depth()) and also the queue
> > > depth ramp up/down mechanism (see also
> scsi_handle_queue_ramp_up())?
> > > Have you considered to enable/disable busy tracking per LUN
> > > depending on whether or not sdev-
> > > >queue_depth < shost->can_queue?
> > >
> > > The megaraid and mpt3sas drivers read sdev->device_busy directly. Is
> > > the current version of this patch compatible with these drivers?
> >
> > We need to know per scsi device outstanding in mpt3sas and
> > megaraid_sas driver.
>
> Is the READ done in fast path or slow path? If it is on slow path, it
should be
> easy to do via blk_mq_in_flight_rw().

READ is done in fast path.

>
> > Can we get supporting API from block layer (through SML)  ? something
> > similar to "atomic_read(&hctx->nr_active)" which can be derived from
> > sdev->request_queue->hctx ?
> > At least for those driver which is nr_hw_queue = 1, it will be useful
> > and we can avoid sdev->device_busy dependency.
>
> If you mean to add new atomic counter, we just move the .device_busy
into
> blk-mq, that can become new bottleneck.

How about below ? We define and use below API instead of
"atomic_read(&scp->device->device_busy) >" and it is giving expected
value. I have not captured performance impact on max IOPs profile.

Inline unsigned long sdev_nr_inflight_request(struct request_queue *q)
{
        struct blk_mq_hw_ctx *hctx;
        unsigned long nr_requests = 0;
        int i;

        queue_for_each_hw_ctx(q, hctx, i)
                nr_requests += atomic_read(&hctx->nr_active);

        return nr_requests;
}

Kashyap

>
>
> thanks,
> Ming
