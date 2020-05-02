Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1DFC4724C
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 03:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FA2720643
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 03:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KukU07T0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgEBDLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 23:11:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29582 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgEBDLe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 23:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588389093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nz5MYjY4CYp2seE9EtYG5G3kvR32HBDMeG9CsyVGpXQ=;
        b=KukU07T0cQerMSLf+1U1XA1g1CZZsjmLfYV8nqAufJxH3W7d+XvjhHgAMWhqNZtBrIksyx
        yqERJ2qrcQdfSdBAeWh3qCMUTGImBCCbdICSyReSOpUTtptvpe27lw+TdGEMO2CC4L8wMh
        Vs8YgV1sE7ZXGqbWYO1exnI4r9xmJ74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Q0FMxJkIM56JSz99otgCIw-1; Fri, 01 May 2020 23:11:29 -0400
X-MC-Unique: Q0FMxJkIM56JSz99otgCIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02FB41009619;
        Sat,  2 May 2020 03:11:28 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8FAB61535;
        Sat,  2 May 2020 03:11:20 +0000 (UTC)
Date:   Sat, 2 May 2020 11:11:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
Message-ID: <20200502031115.GB1013372@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de>
 <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590>
 <20200501174505.GC23795@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501174505.GC23795@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 01, 2020 at 07:45:05PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
> > > We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
> > > which seems to relate to a hardware setting.
> > > 
> > > But I can see to update the reserved command functionality for allowing to
> > > fetch commands from the normal I/O tag pool; in the case of LUN reset it
> > > shouldn't make much of a difference as the all I/O is quiesced anyway.
> > 
> > It isn't related with reset.
> > 
> > This patch reduces active IO queue depth by 1 anytime no matter there is reset
> > or not, and this way may cause performance regression.
> 
> But isn't it the right thing to do?  How else do we guarantee that
> there always is a tag available for the LU reset?

If that is case, some of these patches should be bug-fix, but nothing
about this kind of comment is provided. If it is true, please update
the commit log and explain the current issue in detail, such as,
what is the side-effect of 'overwriting the original command'?

And we might need to backport it to stable tree because storage error
recovery is very key function.

Even though it is true, still not sure if this patch is the correct
way to fix the issue cause IO performance drop might be caused.


Thanks,
Ming

