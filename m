Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB71C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B79611AC
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhFGL60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFGL60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623066995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x297pJ4qNClRpGz4tcEFjKRldNlQgCMtMi+4r8amkkw=;
        b=eyEBPpByw1RgjPrGMEDULXbu66i8+F8Jn4oJD3ykRQbX8c4v6J6AxRZ5gJ+T6sbqRKR2Rb
        kYedhwppahlPPxNERxeD4s9EMH2kdkcgzHTvJC7oqYk+BuiFX/lSykuoFnvR1bV5xjhKOh
        pPvyHMroCfy660TXEZ4gNiwT+UwjkqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-Mii3UAxqPECzTcWodunnVg-1; Mon, 07 Jun 2021 07:56:33 -0400
X-MC-Unique: Mii3UAxqPECzTcWodunnVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B1E9654;
        Mon,  7 Jun 2021 11:56:32 +0000 (UTC)
Received: from T590 (ovpn-13-182.pek2.redhat.com [10.72.13.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B35B5C22B;
        Mon,  7 Jun 2021 11:56:26 +0000 (UTC)
Date:   Mon, 7 Jun 2021 19:56:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 4/4] scsi: core: only put parent device if host state
 isn't in SHOST_CREATED
Message-ID: <YL4JZYSG/s+Zf2nH@T590>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-5-ming.lei@redhat.com>
 <40e024d4-87d6-ca11-8b68-d15f2e772ecc@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40e024d4-87d6-ca11-8b68-d15f2e772ecc@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 07, 2021 at 01:41:36PM +0200, Hannes Reinecke wrote:
> On 6/2/21 3:30 PM, Ming Lei wrote:
> > get_device(shost->shost_gendev.parent) is called after host state is
> > changed to SHOST_RUNNING. So scsi_host_dev_release() shouldn't release
> > the parent device if host state is still SHOST_CREATED.
> > 
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: John Garry <john.garry@huawei.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/hosts.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 7049844adb6b..34db5be7a562 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -350,7 +350,7 @@ static void scsi_host_dev_release(struct device *dev)
> >  
> >  	ida_simple_remove(&host_index_ida, shost->host_no);
> >  
> > -	if (parent)
> > +	if (shost->shost_state != SHOST_CREATED)
> >  		put_device(parent);
> >  	kfree(shost);
> >  }
> > 
> What happened to the check 'if (parent)'?

put_device() is just like kfree(), and it will handle null 'parent'.

Thanks,
Ming

