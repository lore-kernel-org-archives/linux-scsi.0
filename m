Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB7EC2D0BF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 10:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A7A24655
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 10:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LVhKlAce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbfLEKcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:32:07 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:43131 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbfLEKcH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 05:32:07 -0500
Received: by mail-il1-f172.google.com with SMTP id u16so2509927ilg.10
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2019 02:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=h484k0glhkWeW7tP68ByhNvi+fZQlOfa529/H5/kNzA=;
        b=LVhKlAce8nAuTjqLQ28M/88nHeVSCvpmtTONx/gjfJqFdGC/R8/YkSGJDRpDJDSbw9
         5vPQo/2kfj2dYZWBK97sUBtvNS/Ska8w0jTzqvQbfQrwaaCmKtdqbRaJEq4UyGNfQMht
         huXO4gIrtGC2LSyy+7jgXUpMa3DNxai+/P/Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=h484k0glhkWeW7tP68ByhNvi+fZQlOfa529/H5/kNzA=;
        b=aQrkmRWtIhEYe97AmS+IXVZlrkXPeUCMZy1sejz3JMCtaSaCXqZKxVOCiTEOjvlrlV
         Fim/UtsFrU8GtuGKk7pw6XWagFWPof0X1AGYwtOqmub5FO5xH+4vhyMDvdbnOHBuV/AM
         iQc5tFoCL4oDlFquyMtpx5FKDQfo9RbaPLiToyQJSNFwHpXvYjjqlTGf3ThoS0m8YMSL
         wDJ8DMtPzYzSg72pb5C89YciFL54E3s3Z8MIY9nh0PYEMwEKefWQIXZcKsQuikhx6GBr
         MYYMldv2liWeXVH2NCD9wIqZQY+ylUSTaP9DkQVMK91kZB6zAvufGqJhgblCzyWt5dNr
         W+Gg==
X-Gm-Message-State: APjAAAUYZQH5cyPBLp//5PTD4cab7teaWpngk0KfMDKjbjgvfS+nWHtC
        g6olimMTvGqwzL/L3PH1giZ9vXr+di0n1KcQaGFryA==
X-Google-Smtp-Source: APXvYqxwhy+zfXnDguKWuxWVMyh43pDCuX4H5mcMy0JqTok7fhi3XNR7px97f46ryUjNHKzGu6gxNo0BVOSYw6Qxgrs=
X-Received: by 2002:a92:d38e:: with SMTP id o14mr8336126ilo.238.1575541926514;
 Thu, 05 Dec 2019 02:32:06 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191118103117.978-1-ming.lei@redhat.com> <20191118103117.978-2-ming.lei@redhat.com>
 <97bf460e-62c9-dc64-db4c-fb5540e70ae9@suse.de> <252362ee5ac748694d205441729c433f@mail.gmail.com>
 <20191126033755.GE24501@ming.t460p>
In-Reply-To: <20191126033755.GE24501@ming.t460p>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH3BpsAXu9UwBJw1xp6lr9PVp09cQMYv4CvAYuhPOYB9sdvUQFPdxjBpylKwxA=
Date:   Thu, 5 Dec 2019 16:02:03 +0530
Message-ID: <1925bc9a900aac610d9623ce1a96389a@mail.gmail.com>
Subject: RE: [PATCH 1/4] scsi: megaraid_sas: use private counter for tracking
 inflight per-LUN commands
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Ming - Sorry for delay. I will update this Patch. We prefer driver to
> > avoid counter for per sdev if possible. We are currently testing
> > driver using below changes.
> >
> > inline unsigned long sdev_nr_inflight_request(struct request_queue *q)
{
> >     struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[0]
> >
> >     return atomic_read(&hctx->nr_active); }
>
> OK, I am fine with this way, given it is just used for balancing irq
load.

We have removed sdev->device_busy check from megaraid_sas and mpt3sas
drive.  I am able to get required performance 3.0M IOPs on Aero controller
using <hctx->nr_active>
Since this is not urgent, we will wait for some testing done by Broadcom.
We will post this specific change as Driver update.

>
>
> Thanks,
> Ming
