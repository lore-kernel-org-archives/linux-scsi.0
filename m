Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B564C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 13:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE9620786
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 13:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pu8tcL6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGINSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 09:18:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbgGINSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 09:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pHKKeFwYHFu5EJTi0nLzJYC4uGC9l8Tnr2HEDNpR0cQ=;
        b=Pu8tcL6k9QeeI+TVaCMQ62A4mbRVLTpS8OiLiiLj3g7o8pfTZ3Y9/B7/K++Ss9FrxN15Tf
        sbjv73N7kmABf5sLqyV31cW4zZZQdx686cQbPI5oiUg9rii+n4Pts4JlOLFnuomJe5LAY6
        AR1lQhuiBd2FTmmLuzzo3vJMBGOi3Ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-KC__MPuyMEmsVIsk-rY7rw-1; Thu, 09 Jul 2020 09:18:28 -0400
X-MC-Unique: KC__MPuyMEmsVIsk-rY7rw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCED100AA21;
        Thu,  9 Jul 2020 13:18:26 +0000 (UTC)
Received: from T590 (ovpn-12-84.pek2.redhat.com [10.72.12.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA2AC1054FFD;
        Thu,  9 Jul 2020 13:18:12 +0000 (UTC)
Date:   Thu, 9 Jul 2020 21:18:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, hare@suse.com, dgilbert@interlog.com,
        kashyap.desai@broadcom.com
Subject: Re: [PATCH v2 1/2] scsi: scsi_debug: Add check for sdebug_max_queue
 during module init
Message-ID: <20200709131808.GA3393330@T590>
References: <1594297400-24756-1-git-send-email-john.garry@huawei.com>
 <1594297400-24756-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594297400-24756-2-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 09, 2020 at 08:23:19PM +0800, John Garry wrote:
> sdebug_max_queue should not exceed SDEBUG_CANQUEUE, otherwise crashes like
> this can be triggered by passing an out-of-range value:
> 
> Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019 
>  pstate: 20400009 (nzCv daif +PAN -UAO BTYPE=--) 
>  pc : schedule_resp+0x2a4/0xa70 [scsi_debug] 
>  lr : schedule_resp+0x52c/0xa70 [scsi_debug] 
>  sp : ffff800022ab36f0 
>  x29: ffff800022ab36f0 x28: ffff0023a935a610 
>  x27: ffff800008e0a648 x26: 0000000000000003 
>  x25: ffff0023e84f3200 x24: 00000000003d0900 
>  x23: 0000000000000000 x22: 0000000000000000 
>  x21: ffff0023be60a320 x20: ffff0023be60b538 
>  x19: ffff800008e13000 x18: 0000000000000000 
>  x17: 0000000000000000 x16: 0000000000000000 
>  x15: 0000000000000000 x14: 0000000000000000 
>  x13: 0000000000000000 x12: 0000000000000000 
>  x11: 0000000000000000 x10: 0000000000000000 
>  x9 : 0000000000000001 x8 : 0000000000000000 
>  x7 : 0000000000000000 x6 : 00000000000000c1 
>  x5 : 0000020000200000 x4 : dead0000000000ff 
>  x3 : 0000000000000200 x2 : 0000000000000200 
>  x1 : ffff800008e13d88 x0 : 0000000000000000 
>  Call trace: 
> schedule_resp+0x2a4/0xa70 [scsi_debug] 
> scsi_debug_queuecommand+0x2c4/0x9e0 [scsi_debug] 
> scsi_queue_rq+0x698/0x840
> __blk_mq_try_issue_directly+0x108/0x228
> blk_mq_request_issue_directly+0x58/0x98
> blk_mq_try_issue_list_directly+0x5c/0xf0 
> blk_mq_sched_insert_requests+0x18c/0x200 
> blk_mq_flush_plug_list+0x11c/0x190 
> blk_flush_plug_list+0xdc/0x110 
> blk_finish_plug+0x38/0x210 
> blkdev_direct_IO+0x450/0x4d8 
> generic_file_read_iter+0x84/0x180
> blkdev_read_iter+0x3c/0x50 
> aio_read+0xc0/0x170
> io_submit_one+0x5c8/0xc98
> __arm64_sys_io_submit+0x1b0/0x258
> el0_svc_common.constprop.3+0x68/0x170
> do_el0_svc+0x24/0x90 
> el0_sync_handler+0x13c/0x1a8 
> el0_sync+0x158/0x180 
>  Code: 528847e0 72a001e0 6b00003f 540018cd (3941c340)
> 
> In addition, it should not be less than 1.
> 
> So add checks for these, and fail the module init for those cases.
> 
> Fixes: c483739430f10 ("scsi_debug: add multiple queue support")
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/scsi_debug.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4692f5b6ad13..68534a23866e 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6613,6 +6613,12 @@ static int __init scsi_debug_init(void)
>  		pr_err("submit_queues must be 1 or more\n");
>  		return -EINVAL;
>  	}
> +
> +	if ((sdebug_max_queue > SDEBUG_CANQUEUE) || (sdebug_max_queue <= 0)) {
> +		pr_err("max_queue must be in range [1, %d]\n", SDEBUG_CANQUEUE);
> +		return -EINVAL;
> +	}
> +
>  	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
>  			       GFP_KERNEL);
>  	if (sdebug_q_arr == NULL)
> -- 
> 2.26.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

