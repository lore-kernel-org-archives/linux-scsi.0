Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3F9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 10:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhLVKkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 05:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236501AbhLVKkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 05:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640169654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DIgp+1RwfiQEASOLtNQFMakDtZWWFX/t8Wbzaw0z2SM=;
        b=SMpZLA4wFrAr+gWj3Ch7ICiidqFAkrUY2onwpgOiJHl45Otnf6qmx4kl7+QN10fFGMxP0V
        9hiq1v8tXzJZTw77wYFPBhz2iVM3TSu/4MDJJaj4Xdn4yKBck1IemWr5gYHEkA7YbmF4ec
        4EVz38bKGJnkQiTBO4PQLLEQZQfPD/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-ygNwBc_4MLOkF9v9HCYHwQ-1; Wed, 22 Dec 2021 05:40:50 -0500
X-MC-Unique: ygNwBc_4MLOkF9v9HCYHwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05BD610151E0;
        Wed, 22 Dec 2021 10:40:50 +0000 (UTC)
Received: from localhost (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 500D678DDB;
        Wed, 22 Dec 2021 10:40:49 +0000 (UTC)
Date:   Wed, 22 Dec 2021 18:40:46 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
Message-ID: <20211222104046.GB23698@MiWiFi-R3L-srv>
References: <20211222090842.920724-1-hch@lst.de>
 <20211222093707.GA23698@MiWiFi-R3L-srv>
 <20211222094216.GA28018@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222094216.GA28018@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/21 at 10:42am, Christoph Hellwig wrote:
> On Wed, Dec 22, 2021 at 05:37:07PM +0800, Baoquan He wrote:
> > >  	/* allocate transfer buffer */
> > > -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> > > +	buffer = kmalloc(512, GFP_KERNEL);
> > 
> > Thanks a lot for doing this. When I browsed the code path, I come to
> > blk_rq_map_kern() but I am not sure if blk_queue_may_bounce() is true in
> > the sr_probe() case, then it may enter into bio_map_kern().
> 
> blk_queue_may_bounce will be entered for the few drives that set
> BLK_BOUNCE_HIGH because they can't handle highmem (which is a subset
> of the non-ZONE_DMA memory).  The only driver that actually requires
> ZONE_DMA based bouncing is ps3rom, and that driver does a manual
> and ubconditional bounce buffering.

Got it now, thx.

> 
> > Next I will post my original patchset to mute the allocation failure if
> > it's requesting page from DMA zone and DMA zone has no managed page. And
> > meanwhile, I will try to collect those places of kmalloc(GFP_DMA) into a
> > RFC mail, see if we can change them one by one. Anyone can pick one
> > place to fix if interested or knowing it well.
> 
> I've already sent out patches for all of drivers/scsi/ today, except
> for the ps3rom bounce buffer alllocation which is fine but should
> probably be changed to use the page allocator directly.

Sounds really great. 

Any thought or plan for those callsites in other places? Possibly we can
skip those s390 related drivers since s390 only has DMA zone, no DMA32,
it should be OK.

And could you please also add me to CC when send out these patches? We
have this problem in our RHEL8 which is based on kernel4.18, if finally
removing dma-kmalloc(), we need back port these driver fixes too. If
not paying attention, these patches may scatter in different
sub-components and unnoticable.

> 
> > Finally, we can remove the
> > need of dma-kmalloc() as people suggested. Any comment?
> 
> Yes.
> 

