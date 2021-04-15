Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4330BC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 00:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8FC613C3
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 00:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhDOA7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 20:59:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhDOA7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 20:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618448312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XnPCEVIdxYCsS8gproXXaTnFS7nmBynsTat3IoG/ov8=;
        b=jM8oSH+ssO+9kfJv1lbU6LLEzhNCGbgBfd1su0qyK/ntKSOQcjyF1Q1WZasGC/l8VCLBMN
        wBLeROV0jqGacc4W370MhKw6viSryNfpfkcLBgf7Fl0+Vvm0zYqZEW8NRUuNAyM4S/xia9
        moMLztqwa2ZEnoQWvqXp19DjkOYdHKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-m6FwddKAOECh47N005bXqA-1; Wed, 14 Apr 2021 20:58:30 -0400
X-MC-Unique: m6FwddKAOECh47N005bXqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 745A387A82A;
        Thu, 15 Apr 2021 00:58:29 +0000 (UTC)
Received: from T590 (ovpn-12-113.pek2.redhat.com [10.72.12.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7657E60877;
        Thu, 15 Apr 2021 00:58:25 +0000 (UTC)
Date:   Thu, 15 Apr 2021 08:58:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHePrQluaOJG/P8w@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <b41586781cffea03c5fd6b0849e2b9e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b41586781cffea03c5fd6b0849e2b9e4@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 14, 2021 at 07:29:07PM +0530, Kashyap Desai wrote:
> > > I tried both - 5.12.0-rc1 and 5.11.0-rc2+ and there is a same
> behavior.
> > > Let me also check  megaraid_sas and see if anything generic or this is
> > > a special case of scsi_debug.
> >
> > As I mentioned, it could be one generic issue wrt. SCHED_RESTART.
> > shared tags might have to restart all hctx since all share same tags.
> 
> Ming - I tried many combination on MR shared host tag driver but there is
> no single instance of IO hang.
> I will keep trying, but when I look at scsi_debug driver code I found
> below odd settings in scsi_debug driver.
> can_queue of adapter is set to 128 but queue_depth of sdev is set to 255.
> 
> If I apply below patch, scsi_debug driver's hang is also resolved. Ideally
> sdev->queue depth cannot exceed shost->can_queue.
> Not sure why cmd_per_lun is 255 in scsi_debug driver which can easily
> exceed can_queue.  I will simulate something similar in MR driver and see
> how it behaves w.r.t IO hang issue.
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 70165be10f00..dded762540ee 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -218,7 +218,7 @@ static const char *sdebug_version_date = "20200710";
>   */
>  #define SDEBUG_CANQUEUE_WORDS  3       /* a WORD is bits in a long */
>  #define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
> -#define DEF_CMD_PER_LUN  255
> +#define DEF_CMD_PER_LUN  SDEBUG_CANQUEUE
> 
>  /* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
>  #define F_D_IN                 1       /* Data-in command (e.g. READ) */
> @@ -7558,6 +7558,7 @@ static int sdebug_driver_probe(struct device *dev)
>         sdbg_host = to_sdebug_host(dev);
> 
>         sdebug_driver_template.can_queue = sdebug_max_queue;
> +       sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
>         if (!sdebug_clustering)
>                 sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;

Yeah, the change makes the issue disappear. That looks scsi's restart
(scsi_run_queue_async<-scsi_end_request) finally restarts the queue.


Thanks,
Ming

