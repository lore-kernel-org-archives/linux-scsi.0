Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68431C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 01:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41BDB613D0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 01:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFBB5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 21:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhFBB5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 21:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622598947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8mYRgxyo5QC5FGm0znPbUl/7vpY7fmgqCU3p39SQeTc=;
        b=Ct2LoC+sizfv3l19jNJdgn1I79iwXSPqcEH41SGFMq0u3+fvK2ywKoeUwp6c56exrn+Zeq
        ZH1lNn1ZkhudPzHlPLgnevkMc3Wxo3wvdlKk9qNwc7gi4GHZaLfmER+CKz4ladTM7MUx6B
        NssScrSh5olzmmbzxajdPkikJklj57c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-zew82V4YNiuNIvwiTe8ypw-1; Tue, 01 Jun 2021 21:55:44 -0400
X-MC-Unique: zew82V4YNiuNIvwiTe8ypw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D1601009460;
        Wed,  2 Jun 2021 01:55:43 +0000 (UTC)
Received: from T590 (ovpn-13-164.pek2.redhat.com [10.72.13.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49D0860CCC;
        Wed,  2 Jun 2021 01:55:35 +0000 (UTC)
Date:   Wed, 2 Jun 2021 09:55:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 0/3] scsi: two fixes in scsi_add_host_with_dma
Message-ID: <YLblEz2xDZfWZ6jA@T590>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <d37d30cf-8293-e34e-0b4f-eebfcfa56bc9@huawei.com>
 <YLYx//I7J2kcnrtN@T590>
 <17786916-5e1f-8387-344c-55bb1020b09e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17786916-5e1f-8387-344c-55bb1020b09e@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2021 at 04:07:05PM +0100, John Garry wrote:
> On 01/06/2021 14:11, Ming Lei wrote:
> > > We don't call scsi_host_cls_release() either, so I guess a ref count is
> > > leaked for shost_dev - I see its refcount is 1 at exit in
> > > scsi_add_host_with_dma(). We have the device_initialize(), device_add(),
> > > device_del() in the alloc and add host functions, but I don't know who is
> > > responsible for the final "device put".
> > Hammm, we still need to put ->shost_dev before returning the error, and the
> > following delta patch can fix the issue, and it should have been wrapped
> > into the 1st one.
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 22a58e453a0c..532165462a42 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -306,6 +306,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >   	pm_runtime_set_suspended(&shost->shost_gendev);
> >   	pm_runtime_put_noidle(&shost->shost_gendev);
> >    fail:
> > +	/* drop ref of ->shost_dev so that caller can release this host */
> > +	put_device(&shost->shost_dev);
> >   	return error;
> >   }
> >   EXPORT_SYMBOL(scsi_add_host_with_dma);
> 
> That looks better now.
> 
> And we can see the equivalent on the normal removal path in
> scsi_remove_host() -> device_unregister(&shost->shost_dev), which does a
> device_del()+put_device().
> 
> So could we actually just have:
> out_del_dev:
> 	unregister_dev(&shost->shost_dev)
> 

No, we still have to call put_device(&shost->shost_dev) only in case of
failure before adding &shost->shost_dev.

> I am not sure if we are required to keep that shost_dev reference all the
> way until the exit, as you do.

That has been done in this way, the problem is that both .shost_dev and
.shost_gendev share same lifetime and memory(same struct Scsi_Host instance),
this kind of pattern isn't one usual driver core use case, and we have to
handle it carefully.


Thanks,
Ming

