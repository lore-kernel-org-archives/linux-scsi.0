Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D850DC388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 02:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86445246A2
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 02:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i50Spxwx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKQCKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 21:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgKQCKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 21:10:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605579047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w2Rh8FhHpIBZ/culaPBG6pZ40l7DsJWChqgoQcYXU0E=;
        b=i50SpxwxqieyrvNQhJCvXgfXTPmnLVXn2Afzk0lrc5p9k1CcTpAgdPEZeNMhL6AFTkqqT9
        mrthsoy2NbDJ9jOihcB84V1jDhujFHVpKv4EuKHaj/zYBDJIdk4k1mSL6T0qT6Nd5C2VIU
        q8/Mo8uvF/gWbnHNtMHaEklmbSnJw34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-7yhB8bSVMP6KLY_F9f5FCg-1; Mon, 16 Nov 2020 21:10:45 -0500
X-MC-Unique: 7yhB8bSVMP6KLY_F9f5FCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1DD21084C88;
        Tue, 17 Nov 2020 02:10:43 +0000 (UTC)
Received: from T590 (ovpn-12-215.pek2.redhat.com [10.72.12.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 281196EF40;
        Tue, 17 Nov 2020 02:10:34 +0000 (UTC)
Date:   Tue, 17 Nov 2020 10:10:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH V4 05/12] sbitmap: export sbitmap_weight
Message-ID: <20201117021030.GC56247@T590>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-6-ming.lei@redhat.com>
 <d05cb6bf-35e6-d939-30a5-6ef3a9c8a679@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d05cb6bf-35e6-d939-30a5-6ef3a9c8a679@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2020 at 10:38:58AM +0100, Hannes Reinecke wrote:
> On 11/16/20 10:07 AM, Ming Lei wrote:
> > SCSI's .device_busy will be converted to sbitmap, and sbitmap_weight
> > is needed, so export the helper.
> > 
> > Cc: Omar Sandoval <osandov@fb.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> > Cc: Ewan D. Milne <emilne@redhat.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/sbitmap.h |  9 +++++++++
> >   lib/sbitmap.c           | 11 ++++++-----
> >   2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
> > index 103b41c03311..34343ce3ef6c 100644
> > --- a/include/linux/sbitmap.h
> > +++ b/include/linux/sbitmap.h
> > @@ -346,6 +346,15 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
> >    */
> >   void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
> > +
> > +/**
> > + * sbitmap_weight() - Return how many real bits set in a &struct sbitmap.
> > + * @sb: Bitmap to check.
> > + *
> > + * Return: How many real bits set
> > + */
> > +unsigned int sbitmap_weight(const struct sbitmap *sb);
> > +
> >   /**
> >    * sbitmap_bitmap_show() - Write a hex dump of a &struct sbitmap to a &struct
> >    * seq_file.
> > diff --git a/lib/sbitmap.c b/lib/sbitmap.c
> > index dcd6a89b4d2f..fb1d3c2f70a2 100644
> > --- a/lib/sbitmap.c
> > +++ b/lib/sbitmap.c
> > @@ -342,20 +342,21 @@ static unsigned int __sbitmap_weight(const struct sbitmap *sb, bool set)
> >   	return weight;
> >   }
> > -static unsigned int sbitmap_weight(const struct sbitmap *sb)
> > +static unsigned int sbitmap_cleared(const struct sbitmap *sb)
> >   {
> > -	return __sbitmap_weight(sb, true);
> > +	return __sbitmap_weight(sb, false);
> >   }
> > -static unsigned int sbitmap_cleared(const struct sbitmap *sb)
> > +unsigned int sbitmap_weight(const struct sbitmap *sb)
> >   {
> > -	return __sbitmap_weight(sb, false);
> > +	return __sbitmap_weight(sb, true) - sbitmap_cleared(sb);
> >   }
> > +EXPORT_SYMBOL_GPL(sbitmap_weight);
> That is extremely confusing. Why do you change the meaning of
> 'sbitmap_weight' from __sbitmap_weight(sb, true) to
> __sbitmap_weight(sb, true) - __sbitmap_weight(sb, false)?

Because the only user of sbitmap_weight() just uses the following way:

	sbitmap_weight(sb) - sbitmap_cleared(sb)

Frankly, I think sbitmap_weight(sb) should return real busy bits.

> Does this mean that the original definition was wrong?
> Or does this mean that this patch implies a different meaning of
> 'sbitmap_weight'?

Yeah, this patch changes meaning of sbitmap_weight(), now it is
exported, and we should make it more accurate/readable from user view.


Thanks, 
Ming

