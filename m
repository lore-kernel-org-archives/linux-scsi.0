Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8106C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 13:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A031610CC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 13:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbhHTNp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 09:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhHTNp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 09:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629467088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a+ZiHy0S2JzjGTtry4ktJ98yuVUDhxplVu+BcUWdd38=;
        b=KtuKT5lRsUzRNilua+a4IfJGi+i14KGAtXBbzJgEudi5Z6pcxF19syIIwbH6KPQfzz2KAI
        2dkz3lL16BUUvwb2dKThLhJU/JKEkI3HZQvC4Dpr6elatRoRkJDBJ0tjIZ63tDXAjSXS4Q
        0r08ztVqbok6H5HMuz1y0txAyQq/fx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-IPnf2KVKP76iHbEqplX-Sw-1; Fri, 20 Aug 2021 09:44:46 -0400
X-MC-Unique: IPnf2KVKP76iHbEqplX-Sw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C53F6192D785;
        Fri, 20 Aug 2021 13:44:44 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D315D741;
        Fri, 20 Aug 2021 13:44:23 +0000 (UTC)
Date:   Fri, 20 Aug 2021 21:42:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        blankburian@uni-muenster.de
Subject: Re: [PATCH 8/9] block: hold a request_queue reference for the
 lifetime of struct gendisk
Message-ID: <YR+xYi3VX8MFilud@T590>
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816131910.615153-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2021 at 03:19:09PM +0200, Christoph Hellwig wrote:
> Acquire the queue ref dropped in disk_release in __blk_alloc_disk so any
> allocate gendisk always has a queue reference.

BTW, today Markus reported that request queue is released when the
disk is still live.

And looks it is triggered when running virtio-scsi hotplug from qemu
side, and the reason could be that we grab the request queue refcount
after disk is added to driver core, so there is small race window in
which the request queue is released before we grab it in __device_add_disk().

I guess this patch could fix the issue, but it is hard to verify
since it takes days to reproduce.


Thanks,
Ming

