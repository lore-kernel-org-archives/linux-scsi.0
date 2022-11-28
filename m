Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE614C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 03:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiK1D3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Nov 2022 22:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiK1D3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Nov 2022 22:29:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B90C744
        for <linux-scsi@vger.kernel.org>; Sun, 27 Nov 2022 19:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669606085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9szJ/bHUVM/RqeT4MKHPahkxnQImAqd4WFTZsdRbYws=;
        b=KsKw+lxOcPYLEY6yC7/oFYkCppntgIFEoCUGJ2t6tR7NjnDlqmB1JFu7SZUKHGHtVhl4G/
        UWTd1ue+/MDiFK1JQejqMo1zOaku9LBCqNKMnlfO6L7C007PZYL2bct8ci878RuRRJMU0Q
        zWT2FMydDGa5XynKrDoLRjeAqII9DR4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-RI9nIoAHPwqdd8p2323KfA-1; Sun, 27 Nov 2022 22:28:00 -0500
X-MC-Unique: RI9nIoAHPwqdd8p2323KfA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0ED6811E67;
        Mon, 28 Nov 2022 03:27:59 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42E12492B05;
        Mon, 28 Nov 2022 03:27:54 +0000 (UTC)
Date:   Mon, 28 Nov 2022 11:27:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC] scsi: core: remove unsed 'restarts' from scsi_device
Message-ID: <Y4QqtbXsuYmkOe88@T590>
References: <20221118113052.1324140-1-yukuai1@huaweicloud.com>
 <cefdae2e-67e3-b4b4-f569-31db960e991f@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cefdae2e-67e3-b4b4-f569-31db960e991f@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 26, 2022 at 04:54:46PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/11/18 19:30, Yu Kuai 写道:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > During code review, I found that 'restarts' is not useful anymore after
> > the following commits:
> > 
> > 1) commit ab3cee3762e5 ("blk-mq: In blk_mq_dispatch_rq_list() "no budget"
> > is a reason to kick")
> > 2) commit d3b38596875d ("blk-mq: run queue no matter whether the request
> > is the last request")
> > 3) commit 673235f91531 ("scsi: core: Fix race between handling STS_RESOURCE
> > and completion")
> > 
> > Now that if get budget ever failed, block layer will make sure to
> > trigger new run queue for the hctx. Hence there is no need to run queue
> > from scsi layer in this case.
> > 

But scsi_run_queue_async() needs to run all hw queue because budget is
actually LUN/request queue wide.

> 
> Does anyone has suggestions about this patch?
> 
> More info why I tried to remove this:
> 
> while testing megaraid with 4 nvme with none elevator, the default
> queue_depth is 128, while I test it with fio 128 jobs and 1 iodepth,
> bw is about 4Gib/s, however, if I test with 128 jobs and 2 iodepth,
> bw is decreased to about 0.8Gib/s, and with this patch applied,
> bw can stay 4Gib/s in the later case.

What is .can_queue and nr_hw_queues in your setting?



thanks,
Ming

