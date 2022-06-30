Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FDBC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 01:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiF3BB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiF3BB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 21:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 107C03EAB5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 18:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656550915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wBO2+hQsK034NSOPv3z/ANtlGcCRIrio+RKYvxxPL6s=;
        b=c2/a/HGdGfXnBYCrp2yVf0UWFOGR4w/qOeRxC5Mr8scKcQg7FsFdVk4l9mWDD6NRwqBOlV
        +JJ2uocwS9RA6jIjHvvACsa3E+5EOSLw/NmhehdIKM32MhrQG0uNBdPkzQtvd7axW1pguo
        7yM0+1P/cKx5L9wbvEfUCdMys2X6/k8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-azI2VJ6lN7eMFPDPbWue-g-1; Wed, 29 Jun 2022 21:01:51 -0400
X-MC-Unique: azI2VJ6lN7eMFPDPbWue-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF3F71C01B45;
        Thu, 30 Jun 2022 01:01:50 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF11A1415108;
        Thu, 30 Jun 2022 01:01:44 +0000 (UTC)
Date:   Thu, 30 Jun 2022 09:01:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <Yrz18+1iFb/QkiBZ@T590>
References: <20220628175612.2157218-1-bvanassche@acm.org>
 <YruoKUbpBZvAkZ4L@T590>
 <8e464697-e179-19f7-e417-be089821a861@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e464697-e179-19f7-e417-be089821a861@acm.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I'd rather to understand the issue first.

On Wed, Jun 29, 2022 at 02:49:27PM -0700, Bart Van Assche wrote:
> On 6/28/22 18:17, Ming Lei wrote:
> > On Tue, Jun 28, 2022 at 10:56:12AM -0700, Bart Van Assche wrote:
> > > There are two .exit_cmd_priv implementations. Both implementations use the
> > > SCSI host pointer. Make sure that the SCSI host pointer is valid when
> > > .exit_cmd_priv is called by moving the .exit_cmd_priv calls from
> > > scsi_device_dev_release() to scsi_forget_host(). Moving

.exit_cmd_priv is actually called from scsi_host_dev_release() instead
of scsi_device_dev_release(). Both scsi host pointer and host->shost_data is
still valid when calling .exit_cmd_priv via scsi_mq_destroy_tags().

Previously I fixed[1] one similar issue, and that is caused by early module
unloading, and anywhere host->hostt is referred, the scsi driver module
should be prevented from being unloaded.


[1] f2b85040acec scsi: core: Put LLD module refcnt after SCSI device is released


Thanks,
Ming

