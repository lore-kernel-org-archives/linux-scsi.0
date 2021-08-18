Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AF8C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E8E61058
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhHRDum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 23:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236287AbhHRDul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 23:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629258607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=crpAJBvumCuaEt8C+B+Kra3+47n/05Aja6kzedcOsJc=;
        b=LX7EDcoHYBG7Vf5D0ZeMAKgS2EqJ407fvIcYEouGkHaHtoc4muTyIM40gY5xSi9aJ5P3Rp
        uJAtf/nA5CAGlFPHy9KZwfn4KH3JjkXlxrO0FRkxKwk2qz1M16g8lK+gaf02zA3ySdzoM8
        5RluDOl4szFDR4uHH54eGv18j7Kk/BI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-DAgbj7X2OAeNJl632j7qSA-1; Tue, 17 Aug 2021 23:50:03 -0400
X-MC-Unique: DAgbj7X2OAeNJl632j7qSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF2688042DB;
        Wed, 18 Aug 2021 03:50:01 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3083810429FC;
        Wed, 18 Aug 2021 03:49:52 +0000 (UTC)
Date:   Wed, 18 Aug 2021 11:49:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 03/11] blk-mq: Relocate shared sbitmap resize in
 blk_mq_update_nr_requests()
Message-ID: <YRyDWxgxOJSYhpDy@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-4-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628519378-211232-4-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2021 at 10:29:30PM +0800, John Garry wrote:
> For shared sbitmap, if the call to blk_mq_tag_update_depth() was
> successful for any hctx when hctx->sched_tags is not set, then it would be
> successful for all (due to nature in which blk_mq_tag_update_depth()
> fails).
> 
> As such, there is no need to call blk_mq_tag_resize_shared_sbitmap() for
> each hctx. So relocate the call until after the hctx iteration under the
> !q->elevator check, which is equivalent (to !hctx->sched_tags).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

