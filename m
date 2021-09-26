Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFE3C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 02:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB00861090
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 02:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhIZCCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 22:02:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230205AbhIZCCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 22:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632621633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=040oIl6zBrwYwN4KEUOPnof9/L/lrCQC7B42b76Xk3I=;
        b=GDUhY8b7G3tLlsEyKlShAqc1rAtGS/COWWVrBZ0TmrTkyC9nvxFoxPpH2KdnmWHCYH6+oa
        xSDZ3aHU8DrlszU1RiwESioxKyTdcO5RX84wLKojfv9x6Q4KVEeaKODmnVrV15sBi/CC3d
        jyMxpC3m53GB9QXtkBI6paqx1c2yiA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-SWEqkh6fNmSskSxBhcVQ9A-1; Sat, 25 Sep 2021 22:00:31 -0400
X-MC-Unique: SWEqkh6fNmSskSxBhcVQ9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4912B824FA6;
        Sun, 26 Sep 2021 02:00:30 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B2BB60C05;
        Sun, 26 Sep 2021 02:00:14 +0000 (UTC)
Date:   Sun, 26 Sep 2021 10:00:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        hare@suse.de
Subject: Re: [PATCH v4 10/13] blk-mq: Add blk_mq_alloc_map_and_rqs()
Message-ID: <YU/UPeIm3a1KjRHk@T590>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-11-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632472110-244938-11-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 04:28:27PM +0800, John Garry wrote:
> Add a function to combine allocating tags and the associated requests,
> and factor out common patterns to use this new function.
> 
> Some function only call blk_mq_alloc_map_and_rqs() now, but more
> functionality will be added later.
> 
> Also make blk_mq_alloc_rq_map() and blk_mq_alloc_rqs() static since they
> are only used in blk-mq.c, and finally rename some functions for
> conciseness and consistency with other function names:
> - __blk_mq_alloc_map_and_{request -> rqs}()
> - blk_mq_alloc_{map_and_requests -> set_map_and_rqs}()
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

