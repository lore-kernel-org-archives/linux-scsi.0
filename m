Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FE2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 13:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90AA861152
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 13:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhIQNnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 09:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238835AbhIQNnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 09:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631886118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qPKKKwH2jQdgPx6wq21W8Af/fgq6lGJhjobpr3nUL5w=;
        b=aqvXUYSM814ieWv38v0S9VjwETd9eE+HmZjTTBDSgFqYnL2HhWl0tXDkQZFFDS/Y4wtF3z
        c+ohLNdI4/J0S0oME7ugBpsABGLzGaYoBsO6qGl2FIgg1u01JXNN/14rSrLovB388HnW8E
        xghYxmRt9KLBjJm1444SxaPzXIx8aJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-3drzJqFtNCmlyFNSItDhQw-1; Fri, 17 Sep 2021 09:41:54 -0400
X-MC-Unique: 3drzJqFtNCmlyFNSItDhQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 453631054F90;
        Fri, 17 Sep 2021 13:41:53 +0000 (UTC)
Received: from T590 (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B3635D9C6;
        Fri, 17 Sep 2021 13:41:36 +0000 (UTC)
Date:   Fri, 17 Sep 2021 21:41:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: cleanup request queue before releasing
 gendisk
Message-ID: <YUSbHTz//2Wn5qVw@T590>
References: <YUKfl9Qqsluh+5FX@T590>
 <20210916101451.GA26782@lst.de>
 <YUM6uFHqfjWMM5BH@T590>
 <20210916142009.GA12603@lst.de>
 <YUQOBKa67R9pEunr@T590.Home>
 <20210917065305.GA24012@lst.de>
 <YURGkXQndMxDEWxW@T590.Home>
 <20210917075650.GA28455@lst.de>
 <YURSj0G5gMiSAo5j@T590.Home>
 <20210917123719.GA17003@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917123719.GA17003@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 02:37:19PM +0200, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 04:32:15PM +0800, Ming Lei wrote:
> > > Is it?  For the typical case the second free in blk_cleanp_queue will
> > > be bsically free because there is no pending I/O.  The only case
> > > where that matters if if there is pending passthrough I/O again,
> > > which can only happen with SCSI, and even there is highly unusual.
> > 
> > RCU grace period is involved in blk_freeze_queue().
> 
> where?

__percpu_ref_switch_to_atomic().

-- 
Ming

