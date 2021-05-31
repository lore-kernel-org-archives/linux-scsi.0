Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE06C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8624610A8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhEaH6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 03:58:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhEaH6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 03:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622447817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9EEz5GIam0rkftjqTzI4ilMPIWuvqekQo7iQgCx3gco=;
        b=D9JICvOTFv+T0i9F+Pxe/+wdpVFmcjfNrPrbOWd7kqarK5QWE9MsaYmaqkyaf/UKz/G8Iw
        jjt+461J5w2eDudE3yCxZHeFhKGOAYO7xqmGPMs9zT4fRYqTfkgEVEdckfVyZ9sqLFIgdk
        zDDsWg1esjeKmYp8FeoT+UxGfXWsW8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-FRAciZIYPoOvdpE6KQu1Ig-1; Mon, 31 May 2021 03:56:45 -0400
X-MC-Unique: FRAciZIYPoOvdpE6KQu1Ig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E21EC6D270;
        Mon, 31 May 2021 07:56:43 +0000 (UTC)
Received: from T590 (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A69A85D720;
        Mon, 31 May 2021 07:56:37 +0000 (UTC)
Date:   Mon, 31 May 2021 15:56:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V3 3/3] scsi: core: put ->shost_gendev.parent in failure
 handling path
Message-ID: <YLSWscVt74+2OO19@T590>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <20210531050727.2353973-4-ming.lei@redhat.com>
 <2cbcfc4a-78ae-ddc9-1386-6008fcaecb0b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cbcfc4a-78ae-ddc9-1386-6008fcaecb0b@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 31, 2021 at 08:28:49AM +0200, Hannes Reinecke wrote:
> On 5/31/21 7:07 AM, Ming Lei wrote:
> > get_device(shost->shost_gendev.parent) is called in
> > scsi_add_host_with_dma(), but its counter pair isn't called in the failure
> > path, so fix it by calling put_device(shost->shost_gendev.parent) in its
> > failure path.
> > 
> > Reported-by: John Garry <john.garry@huawei.com>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/scsi/hosts.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 6cbc3eb16525..6cc43c51b7b3 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -298,6 +298,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >    out_del_dev:
> >   	device_del(&shost->shost_dev);
> >    out_del_gendev:
> > +	put_device(shost->shost_gendev.parent);
> >   	device_del(&shost->shost_gendev);
> >    out_disable_runtime_pm:
> >   	device_disable_async_suspend(&shost->shost_gendev);
> > 
> This really needs to be folded into the first patch as it's really a bugfix
> for that.

All three are bug fixes, and this one may leak .shost_gendev's parent,
but the 1st one leaks .shost_gendev->kobj.name, so we needn't to fold
the 3rd into the 1st one.


Thanks,
Ming

