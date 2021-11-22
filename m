Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28967C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhKVN3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:29:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232089AbhKVN3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 08:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637587598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oalec0n4qeLKP6WG5TThGvL/7+vKr5m1+M6UMeUuzNM=;
        b=Yli0xuigolwMw04mmMBLdeMULgk3Ghm5K9+iCeD4ZwMTdOLyH7oBYRE5WeF8xQ6vh3fd3J
        DjCKrqUbBC4tI6Ko+w4BKD12ARHO7591lj6ovYZ4vXCAphZ63PyfPrdZfSyUWNufKpEmCi
        6Vv8dYoYhM/reRHzw9TSzsta+rvkHnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172--vk2ugstMdeICkgiPk5IDQ-1; Mon, 22 Nov 2021 08:26:35 -0500
X-MC-Unique: -vk2ugstMdeICkgiPk5IDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BE448066EC;
        Mon, 22 Nov 2021 13:26:34 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F37C908B;
        Mon, 22 Nov 2021 13:26:29 +0000 (UTC)
Date:   Mon, 22 Nov 2021 21:26:24 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
Message-ID: <YZuagPbZJ6CjiUNi@T590>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 22, 2021 at 09:56:10AM +0200, Sagi Grimberg wrote:
> 
> > Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
> > queues in parallel, then we can just wait once if global quiesce wait
> > is allowed.
> 
> blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
> obviously it has a scope.

How about blk_mq_shared_quiesce_wait()? or any suggestion?


Thanks,
Ming

