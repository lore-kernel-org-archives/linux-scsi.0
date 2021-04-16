Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0272C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73351610CB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 08:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbhDPI1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 04:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240309AbhDPI1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 04:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618561619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JqIk+NI7RGPoK6EACFBG1tGnl5jNqjLrWCVCFnrQnJE=;
        b=SONowhx7ehJaHGk6QG5Q0pOcDfLVe+yVLLU214x4OakB+48bkiIW9axuWMI4f9SiDIrnfS
        1WVaRseoR/PekycCdxBP+Or2+Y/rpCaUIz6vQq+ljGG+1DpW/9M5uNW6ajEHJf0LJHK+D7
        kkRnrmgrKctLzeI0yBpq1XUqRMJiq10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-w5658VfKMe-7WFUe_1cm8A-1; Fri, 16 Apr 2021 04:26:57 -0400
X-MC-Unique: w5658VfKMe-7WFUe_1cm8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B09E01854E23;
        Fri, 16 Apr 2021 08:26:55 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E02891349A;
        Fri, 16 Apr 2021 08:26:48 +0000 (UTC)
Date:   Fri, 16 Apr 2021 16:26:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com,
        axboe@kernel.dk
Subject: Re: [PATCH] scsi_debug: fix cmd_per_lun, set to max_queue
Message-ID: <YHlKRDOmMRPMKl5x@T590>
References: <20210415015031.607153-1-dgilbert@interlog.com>
 <580349dc-0152-8f39-5f3c-be9115e3bf12@huawei.com>
 <YHjsXaVJJsQXwEPW@T590>
 <bd33c000-905a-b881-06ea-eef51c77566e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd33c000-905a-b881-06ea-eef51c77566e@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 16, 2021 at 09:17:09AM +0100, John Garry wrote:
> On 16/04/2021 02:46, Ming Lei wrote:
> > >   	int display_failure_msg = 1, ret;
> > >   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> > > +	int depth;
> > > 
> > >   	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
> > >   		       GFP_KERNEL);
> > > @@ -276,8 +277,13 @@ static struct scsi_device *scsi_alloc_sdev(struct
> > > scsi_target *starget,
> > >   	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
> > >   	sdev->request_queue->queuedata = sdev;
> > > 
> > > -	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
> > > -					sdev->host->cmd_per_lun : 1);
> > > +	if (sdev->host->cmd_per_lun)
> > > +		depth = min_t(int, sdev->host->cmd_per_lun,
> > > +			      sdev->host->can_queue);
> > > +	else
> > > +		depth = 1;
> > > +
> > > +	scsi_change_queue_depth(sdev, depth);
> > 'cmd_per_lun' should have been set as correct from the beginning instead
> > of capping it for changing queue depth:
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 697c09ef259b..0d9954eabbb8 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -414,7 +414,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
> >   	shost->can_queue = sht->can_queue;
> >   	shost->sg_tablesize = sht->sg_tablesize;
> >   	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
> > -	shost->cmd_per_lun = sht->cmd_per_lun;
> > +	shost->cmd_per_lun = min_t(int, sht->cmd_per_lun, shost->can_queue);
> >   	shost->no_write_same = sht->no_write_same;
> >   	shost->host_tagset = sht->host_tagset;
> 
> My concern here is that it is a common pattern in LLDDs to overwrite the
> initial shost member values between scsi_host_alloc() and scsi_add_host().

OK, then can we move the fix into beginning of scsi_add_host()?


Thanks,
Ming

