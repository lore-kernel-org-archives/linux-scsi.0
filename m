Return-Path: <SRS0=ECI8=3U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1500C35240
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 11:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9680421734
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jan 2020 11:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UoDJlWRe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgAaLjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:39:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38982 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgAaLjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2020 06:39:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so8216906wrt.6;
        Fri, 31 Jan 2020 03:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QhYC5mE6RR4tjYtuK2g5HsZYuZDvuJqptbcVBacA2Zo=;
        b=UoDJlWRe6Fo86qb57CA6MOgUqvlRupLe1BhKKcte3rFM+IeHG7VJr/NUc4CA3vlJBa
         trPkHPRhOHa0yNmkJ58MN+kyrFGkQp9PpOfr5YBV39DRaxSxOn7j/InxE/Sm3iWm3INF
         PxuAard+utG//saqLnHU527taOKKgrkxy9xMamqpn5DSNINsCazFM7Ea+p4h7WmssLdg
         Zj/M6fxqoxBnVqomdvLeRBDrbYKGzHl4GZd31frHFpJbwTviw3hBQn4rslwhc+4NBpb3
         khGeZEnEih4CBDQUPrABpvf+kGka72hDrh0DQql8iVXVhv86jNN+dAxY7ArIYE/yWmUe
         7K9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QhYC5mE6RR4tjYtuK2g5HsZYuZDvuJqptbcVBacA2Zo=;
        b=q0TQAQzK/+NirrvZl7EKXRDPHKV+mFNJYGe9b4EMLmXKB2PrPSRGlyTbihH1nDWBB2
         E7egSgHdDY/jc2ZvZGeUcIkW+iDtn7nmJ+zn3FaFQBcduOl29Ib1XFHanxdfLEIZqVAO
         bLzs+3hgfTyDkTGWoW3MxvRbQeVZ9iidDOkF4+z4c8PGfZoCPKYqneMBdfYAjt17uKmE
         U4yyw77dqEG8O2ARIvQYjRIYt40Tv6d8h88ND2bQb1MSwEFsxUe/DFfYWPEMAOuD19OS
         iiVYjtq0IUmeQytlWpJTbfJWxzxF/oklcDpXMlOBZzL3g8KXnJd5Cw4S9T2CkNG1AGYb
         45cw==
X-Gm-Message-State: APjAAAVDV86f64Y8YY4rcQkuDFy0UXPWOzrrOLFOdJGxg+TOviaKWClF
        xvkg2urJISPvCz5s/cqOFRrfb6CdsbF7QPmRJ3Q=
X-Google-Smtp-Source: APXvYqzMxePQypAgwHTbVgQ5HeLXvX5i5zPNY8LRrRphYS8c31b9NqkQM92SZ2saOi6vydlHHZKSSuHkkm8kjV+ZbEM=
X-Received: by 2002:adf:db84:: with SMTP id u4mr11889498wri.317.1580470790057;
 Fri, 31 Jan 2020 03:39:50 -0800 (PST)
MIME-Version: 1.0
References: <20200119071432.18558-1-ming.lei@redhat.com> <20200119071432.18558-6-ming.lei@redhat.com>
 <yq1y2u1if7t.fsf@oracle.com> <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com>
 <yq1iml1ehtl.fsf@oracle.com> <f4f06cf8459c21749335c6b7a4cfe729@mail.gmail.com>
 <yq1blqo9plo.fsf@oracle.com>
In-Reply-To: <yq1blqo9plo.fsf@oracle.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Fri, 31 Jan 2020 19:39:38 +0800
Message-ID: <CACVXFVMqejMZaOT0ynnMehQF4rJf32eTW2ahoYz6oE9p+GwWEg@mail.gmail.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD
 when HBA needs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Tue, Jan 28, 2020 at 12:24 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sumanesh,
>
> > Instead of relying on QUEUE_FULL and some complex heuristics of when
> > to start tracking device_busy, why can't we simply use "
> > track_queue_depth" ( along with the other flag that Ming added) to
> > decide which devices need queue depth tracking, and track device_busy
> > only for them?
>
> Because I am interested in addressing the device_busy contention problem
> for all of our non-legacy drivers. I.e. not just for controllers that
> happen to queue internally.

Can we just do it for controllers without 'track_queue_depth' and SSD now?

>
> > I am not sure how we can suddenly start tracking device_busy on the fly,
> > if we do not know how many IO are already pending for that device?
>
> We know that from the tags. It's just not hot path material.

In case of 'track_queue_depth', cost for tracking queue depth has to be paid,
which can be too big to get expected perf on high end HBA.

sbitmap might be used for this purpose, but not sure if it can scale well enough
for this purpose.


Thanks,
Ming Lei
