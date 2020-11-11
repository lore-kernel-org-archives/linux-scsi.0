Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C60C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 14:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 003B6207BB
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 14:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVhjAGGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgKKOmd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 09:42:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbgKKOmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 09:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605105752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9m2REj3NYv96OUEBFvez8NttXf+bjO2vLB0zqsgCLak=;
        b=UVhjAGGpRR1xLdXwOwkKSJ69BHwhcRUEmk6BWfFa5MkcdLvV7z7S+yEgFW1JuwOq+gUIpv
        VA9JTNMeiD2VEZIPrdvyaTcoL5ehkaLvTsm9eASbS6gmCDlOJxJFAKH9+ofgm0RWilvihI
        vfiYuaV+4s1Vfz6XD1P09A4uEx8W52Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-2MCBYnq0PbWlVzc024DylA-1; Wed, 11 Nov 2020 09:42:27 -0500
X-MC-Unique: 2MCBYnq0PbWlVzc024DylA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DA4311CC7E0;
        Wed, 11 Nov 2020 14:42:24 +0000 (UTC)
Received: from ovpn-66-204.rdu2.redhat.com (ovpn-66-204.rdu2.redhat.com [10.10.66.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D172010013C0;
        Wed, 11 Nov 2020 14:42:17 +0000 (UTC)
Message-ID: <b6bfe375866a061c1207ada5eeb6029176cf3521.camel@redhat.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   Qian Cai <cai@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Bart Van Assche <bvanassche@acm.org>,
        dgilbert@interlog.com, paolo.valente@linaro.org,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Date:   Wed, 11 Nov 2020 09:42:17 -0500
In-Reply-To: <20201111092743.GC545929@T590>
References: <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
         <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
         <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
         <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
         <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
         <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
         <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
         <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
         <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
         <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
         <20201111092743.GC545929@T590>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 17:27 +0800, Ming Lei wrote:
> Can this issue disappear by applying the following change?

This makes the system boot again as well.

> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index e32958f0b687..b1fe6176d77f 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -469,9 +469,6 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node,
> int cmd_size,
>  	INIT_LIST_HEAD(&fq->flush_queue[1]);
>  	INIT_LIST_HEAD(&fq->flush_data_in_flight);
>  
> -	lockdep_register_key(&fq->key);
> -	lockdep_set_class(&fq->mq_flush_lock, &fq->key);
> -
>  	return fq;
>  
>   fail_rq:
> @@ -486,7 +483,6 @@ void blk_free_flush_queue(struct blk_flush_queue *fq)
>  	if (!fq)
>  		return;
>  
> -	lockdep_unregister_key(&fq->key);
>  	kfree(fq->flush_rq);
>  	kfree(fq);
>  }
> 
> 
> Thanks, 
> Ming

