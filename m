Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1BEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 12:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 229DD22227
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 12:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Db1ynEQ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgGNMFH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:05:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726630AbgGNMFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 08:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594728306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wLFpwPALQaMw7V+5hH97aK5GuabLV1b+VtMlx9TuSek=;
        b=Db1ynEQ4t2fKV6R8PrF+RF3b14HWtHo2OuLmsdeDN4DcljIWI8wtdlesCxZRr5ptijCFY/
        pEFl+vAdRIY4zSBNQlpHes39p4k+gonH6XSd36vB3xTQ8dim8YA+rxU3mMXRBUymPVNho0
        52izddgLVwp2wQvI8EwVJUlczHUAAOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-FQb8WSDJMsuxqlvVoUkw_w-1; Tue, 14 Jul 2020 08:05:02 -0400
X-MC-Unique: FQb8WSDJMsuxqlvVoUkw_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62EE4100A8EB;
        Tue, 14 Jul 2020 12:04:59 +0000 (UTC)
Received: from T590 (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4775872E62;
        Tue, 14 Jul 2020 12:04:47 +0000 (UTC)
Date:   Tue, 14 Jul 2020 20:04:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>, don.brace@microsemi.com,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Message-ID: <20200714120443.GC602708@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <20200714080631.GA600766@T590>
 <3584bcc3-830a-d50d-bb55-8ac0b686cdc0@huawei.com>
 <799af415-cb02-278e-1af2-c6179a94a8a8@suse.de>
 <20200714104437.GB602708@T590>
 <2da0e06c-f6b5-ee5a-1806-e5356ccf8841@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da0e06c-f6b5-ee5a-1806-e5356ccf8841@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 11:52:52AM +0100, John Garry wrote:
> > 
> > In my machine, there are 32 queues(32 cpu cores), each queue has 1013
> > tags, so there can be 32*1013 requests coming from block layer, meantime
> > smartpqi can only handles 1013 requests. I guess it isn't hard to
> > trigger softlock by running heavy/concurrent smartpqi IO.
> 
> Since pqi_alloc_io_request() does not use spinlock, disable preemption,

rcu read lock is held when calling .queue_rq(), and preempt_disable() is
implied in case that CONFIG_PREEMPT_RCU is off.

A CPU looping in an RCU read-side critical section may cause some
related issues, cause RCU's CPU Stall Detector will warn on that.

> etc., so I guess that there is more of a chance of simply IO timeout.
> 
> But I see in pqi_get_physical_disk_info() that there is some intelligence to
> set the queue depth, which may reduce chance of timeout (by reducing disk
> queue depth). Not sure.

It may not work, see:

[root@hp-dl380g10-01 mingl]# cat /sys/block/sd[a-f]/device/queue_depth
1013
1013
1013
1013
1013
1013

All sd[a-f] are smartpqi LUNs.

Thanks, 
Ming

