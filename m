Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4958AC47092
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F611613B1
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhFANN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:13:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233064AbhFANNZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622553103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q4hChKoiB3QBilQgrp7NUIesxQUu666zu0aFmZHlVnE=;
        b=ccCFS20cGlqWcOWIRru0LMl6csRrFRQ6QifQVPmrIPwGRy7mUjZOVGwB+jWSHFzucgbowN
        /cLtjw+LGaHWVxc2Rzxb5ooBKHdaIk4uO1UWSbhHf0a4ef7K6X8fumI90qDiTJx0P43TRB
        eqhgao1HXMUScWv6Ca3FwG8riEx2wz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-T2ocm6R9PdyIionRrNikAA-1; Tue, 01 Jun 2021 09:11:42 -0400
X-MC-Unique: T2ocm6R9PdyIionRrNikAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43905501E3;
        Tue,  1 Jun 2021 13:11:40 +0000 (UTC)
Received: from T590 (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9376D5D9CD;
        Tue,  1 Jun 2021 13:11:33 +0000 (UTC)
Date:   Tue, 1 Jun 2021 21:11:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 0/3] scsi: two fixes in scsi_add_host_with_dma
Message-ID: <YLYx//I7J2kcnrtN@T590>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <d37d30cf-8293-e34e-0b4f-eebfcfa56bc9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d37d30cf-8293-e34e-0b4f-eebfcfa56bc9@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2021 at 11:34:20AM +0100, John Garry wrote:
> On 31/05/2021 06:07, Ming Lei wrote:
> > Hello Martin,
> > 
> > 
> > Fix two memory leaks and one double free issue in alloc/add host
> > code path.
> > 
> > 
> > V3:
> > 	- fix memory leak caused in scsi_host_alloc
> > 	- comment typo suggested by John
> > 
> > V2:
> > 	- add patch 2 for addressing shost leak in case of adding host
> > 	  failure, reported by John Garry.
> > 
> > Ming Lei (3):
> >    scsi: core: use put_device() to release host
> >    scsi: core: fix failure handling of scsi_add_host_with_dma
> >    scsi: core: put ->shost_gendev.parent in failure handling path
> > 
> >   drivers/scsi/hosts.c | 25 ++++++++++++-------------
> >   1 file changed, 12 insertions(+), 13 deletions(-)
> > 
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: John Garry <john.garry@huawei.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> 
> 
> I tested this again with the same experiment as before to error in
> scsi_add_host_with_dma(), and we don't call scsi_host_dev_release() now. The
> shost_gendev dev refcount is 2 upon exit in scsi_add_host_with_dma().
> 
> We don't call scsi_host_cls_release() either, so I guess a ref count is
> leaked for shost_dev - I see its refcount is 1 at exit in
> scsi_add_host_with_dma(). We have the device_initialize(), device_add(),
> device_del() in the alloc and add host functions, but I don't know who is
> responsible for the final "device put".

Hammm, we still need to put ->shost_dev before returning the error, and the
following delta patch can fix the issue, and it should have been wrapped
into the 1st one.

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 22a58e453a0c..532165462a42 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -306,6 +306,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
  fail:
+	/* drop ref of ->shost_dev so that caller can release this host */
+	put_device(&shost->shost_dev);
 	return error;
 }
 EXPORT_SYMBOL(scsi_add_host_with_dma);


Thanks,
Ming

