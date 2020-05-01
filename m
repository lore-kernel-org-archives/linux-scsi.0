Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06030C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 15:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D894320857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 15:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9o+ccCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgEAPB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 11:01:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728839AbgEAPB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 11:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588345318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nplrxSmgtsfTRDFt7eCqXRGasSnPFzRq2vEM0apBRxk=;
        b=b9o+ccCibXkS7jzMhqj787KJeGbjx48BvnoIySliZu63/8NP1rQb+q7lDI3zpyycmdvN18
        eHjqFFWet/my0f3bt60vWxFKt4ktKKMNljULxa9Yk/YPU0DoEB95FBOD+R8J9hWTALF4ED
        sNFuWNSRbMOTKg3n3Xtx47xBFoCtLOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-a_Q00HaRPs2g-15X_5GFaQ-1; Fri, 01 May 2020 11:01:43 -0400
X-MC-Unique: a_Q00HaRPs2g-15X_5GFaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9659136458;
        Fri,  1 May 2020 15:01:41 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E85350F87;
        Fri,  1 May 2020 15:01:33 +0000 (UTC)
Date:   Fri, 1 May 2020 23:01:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
Message-ID: <20200501150129.GB1012188@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de>
 <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 01, 2020 at 03:01:14PM +0200, Hannes Reinecke wrote:
> On 4/30/20 5:15 PM, Ming Lei wrote:
> > On Thu, Apr 30, 2020 at 03:18:27PM +0200, Hannes Reinecke wrote:
> > > When issuing a LUN reset we should be using a reserved command
> > > to avoid overwriting the original command.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > > ---
> > >   drivers/scsi/csiostor/csio_init.c |  1 +
> > >   drivers/scsi/csiostor/csio_scsi.c | 48 +++++++++++++++++++++++----------------
> > >   2 files changed, 30 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
> > > index 8dea7d53788a..5e1b0a24caf6 100644
> > > --- a/drivers/scsi/csiostor/csio_init.c
> > > +++ b/drivers/scsi/csiostor/csio_init.c
> > > @@ -622,6 +622,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
> > >   	ln->dev_num = (shost->host_no << 16);
> > >   	shost->can_queue = CSIO_MAX_QUEUE;
> > > +	shost->nr_reserved_cmds = 1;
> > 
> > ->can_queue isn't increased by 1 given CSIO_MAX_QUEUE isn't changed, so
> > setting shost->nr_reserved_cmds as 1 will cause io queue depth reduced by 1,
> > that is supposed to not happen.
> > 
> We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
> which seems to relate to a hardware setting.
> 
> But I can see to update the reserved command functionality for allowing to
> fetch commands from the normal I/O tag pool; in the case of LUN reset it
> shouldn't make much of a difference as the all I/O is quiesced anyway.

It isn't related with reset.

This patch reduces active IO queue depth by 1 anytime no matter there is reset
or not, and this way may cause performance regression.

Thanks, 
Ming

