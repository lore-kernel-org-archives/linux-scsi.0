Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941FDC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 00:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699026161F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 00:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhEKAy1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 20:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhEKAy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 May 2021 20:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620694400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQ3gkSBPzPzqQG3dgvJ3x0/jyj50xlvHB4Qu61/jDzk=;
        b=SXaGqmSStCZLgGPkOBoHZl7aviv5pun1TlUe1vctvKGckBW/FMYUcr23LlW8Q1fCnD1AwG
        Q/Y9Ket/0XVTFU4sb8VYanrVGIHhVYbIBSIKILyrg1Iq3HwFXLRk76UVUuYzoee9ZbgU3c
        MvxDGJOivOkbDsRGzgvAS5y32cWsA0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-WrwrASQEPzGgbYKcXwfZEA-1; Mon, 10 May 2021 20:53:18 -0400
X-MC-Unique: WrwrASQEPzGgbYKcXwfZEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F03A4501E1;
        Tue, 11 May 2021 00:53:16 +0000 (UTC)
Received: from T590 (ovpn-12-106.pek2.redhat.com [10.72.12.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04BDC60BF1;
        Tue, 11 May 2021 00:53:03 +0000 (UTC)
Date:   Tue, 11 May 2021 08:52:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com
Subject: Re: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
Message-ID: <YJnVasOcaVU+4+Au@T590>
References: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 03, 2021 at 06:22:13PM +0800, John Garry wrote:
> The tags used for an IO scheduler are currently per hctx.
> 
> As such, when q->nr_hw_queues grows, so does the request queue total IO
> scheduler tag depth.
> 
> This may cause problems for SCSI MQ HBAs whose total driver depth is
> fixed.
> 
> Ming and Yanhui report higher CPU usage and lower throughput in scenarios
> where the fixed total driver tag depth is appreciably lower than the total
> scheduler tag depth:
> https://lore.kernel.org/linux-block/440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com/T/#mc0d6d4f95275a2743d1c8c3e4dc9ff6c9aa3a76b
> 

No difference any more wrt. fio running on scsi_debug with this patch in
Yanhui's test machine:

	modprobe scsi_debug host_max_queue=128 submit_queues=32 virtual_gb=256 delay=1
vs.
	modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256 delay=1

Without this patch, the latter's result is 30% higher than the former's.

note: scsi_debug's queue depth needs to be updated to 128 for avoiding io hang,
which is another scsi issue.


Thanks, 
Ming

