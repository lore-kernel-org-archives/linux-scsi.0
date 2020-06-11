Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA16C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 02:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41DB6206A4
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 02:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UmKKKX0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFKC6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 22:58:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726290AbgFKC6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 22:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591844301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HozhPc+jhF+92mc58nmdjI3auoHaR32wwEZfyjGFdlM=;
        b=UmKKKX0BrFxTBu62V/z77AG3A9U4DQT2S8nGZQIh1p9nsllPWBNfy+vurploW8+RrmgJWl
        Xltmp63CuAqjzV7MduhaXISE7giOkfg1adF8raLQdmXYC5QUDlMQBMkWlx4ZS1wEfYqZTT
        WC3+nv3+U3MOijHrsPgeCdcXhoRc6Lk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-xuS9A7T_Pm-rW-5f8IEsuQ-1; Wed, 10 Jun 2020 22:58:17 -0400
X-MC-Unique: xuS9A7T_Pm-rW-5f8IEsuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 164ED10073AC;
        Thu, 11 Jun 2020 02:58:15 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C15A5C1B0;
        Thu, 11 Jun 2020 02:58:03 +0000 (UTC)
Date:   Thu, 11 Jun 2020 10:57:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, bvanassche@acm.org, hare@suse.com,
        hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
Message-ID: <20200611025759.GA453671@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591810159-240929-3-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 11, 2020 at 01:29:09AM +0800, John Garry wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The function does not set the depth, but rather transitions from
> shared to non-shared queues and vice versa.
> So rename it to blk_mq_update_tag_set_shared() to better reflect
> its purpose.

It is fine to rename it for me, however:

This patch claims to rename blk_mq_update_tag_set_shared(), but also
change blk_mq_init_bitmap_tags's signature.

So suggest to split this patch into two or add comment log on changing
blk_mq_init_bitmap_tags().


Thanks, 
Ming

