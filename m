Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4BDC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 03:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiCFDzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiCFDzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 22:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA5F258398
        for <linux-scsi@vger.kernel.org>; Sat,  5 Mar 2022 19:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646538861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OwJVDjgxibSv0Jky7fazN5f+YKyoyAvSJ++O6j4D3EM=;
        b=RayKXiE6ixY/Fq5GzsmFbeYJGYdTTRltrIVFkM4L66cKJUPJusi9XI5waiWSehKvpXjST9
        UPcS0Yj6LwUwT/faXrbsRPFEKdVrE4XPgu4GNu2Bm8thnMJJzRcTLv3eeoCVPKNCpq4pFP
        a6uaNWlajITBLEt6ynV5zYGpXxzJdmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-bOsUZu1yMviNw5MdXM8usw-1; Sat, 05 Mar 2022 22:54:18 -0500
X-MC-Unique: bOsUZu1yMviNw5MdXM8usw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C63F8145F7;
        Sun,  6 Mar 2022 03:54:17 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F27805DF3F;
        Sun,  6 Mar 2022 03:54:05 +0000 (UTC)
Date:   Sun, 6 Mar 2022 11:54:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/14] sd: make use of ->free_disk to simplify refcounting
Message-ID: <YiQwWMeiHNlvnLpn@T590>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304160331.399757-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2022 at 05:03:24PM +0100, Christoph Hellwig wrote:
> Implement the ->free_disk method to to put struct scsi_disk when the last
> gendisk reference count goes away.  This removes the need to clear
> ->private_data and thus freeze the queue on unbind.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

