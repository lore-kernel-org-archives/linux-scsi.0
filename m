Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27031C2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 08:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CB3206B8
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 08:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HBq/FbUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgDUI7F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 04:59:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726018AbgDUI7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 04:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587459543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuDb75IJ8FWCQ3cQ6m/BOpCM+BfZmjYmhG5ABwAegW4=;
        b=HBq/FbUK+ZPU7UJ0bsow1DDhPGfeHWAzKzc5VCBEGDfxV9MrjnhBhS9lJ009zCWcTAHkba
        rm8334suhat0hrG2tBOKDeHUwRJTb0lVmT1GJ4h8No35fj5iKpJrQB81uGk//gVsBZx0rB
        EeRgGVOzrG/gLyoaB1sxlpYoQ7HQoFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-IPHMGftYOmG5nkcrO-xcbQ-1; Tue, 21 Apr 2020 04:58:59 -0400
X-MC-Unique: IPHMGftYOmG5nkcrO-xcbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87635800D5B;
        Tue, 21 Apr 2020 08:58:57 +0000 (UTC)
Received: from T590 (ovpn-8-38.pek2.redhat.com [10.72.8.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69FD960C80;
        Tue, 21 Apr 2020 08:58:49 +0000 (UTC)
Date:   Tue, 21 Apr 2020 16:58:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>,
        Michael Kelley <mikelley@microsoft.com>,
        Long Li <longli@microsoft.com>
Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
 SDEV_BLOCK
Message-ID: <20200421085844.GA284628@T590>
References: <1587170445-50013-1-git-send-email-decui@microsoft.com>
 <20200418024158.GB17090@T590>
 <HK0P153MB02739AAF1415BCC36D8C4EB2BFD50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HK0P153MB02739AAF1415BCC36D8C4EB2BFD50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2020 at 03:01:34AM +0000, Dexuan Cui wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > Sent: Friday, April 17, 2020 7:42 PM
> > To: Dexuan Cui <decui@microsoft.com>
> > Cc: jejb@linux.ibm.com; martin.petersen@oracle.com;
> > linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; hch@lst.de;
> > bvanassche@acm.org; hare@suse.de; Michael Kelley
> > <mikelley@microsoft.com>; Long Li <longli@microsoft.com>
> > Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
> > SDEV_BLOCK
> > 
> > On Fri, Apr 17, 2020 at 05:40:45PM -0700, Dexuan Cui wrote:
> > > The APIs scsi_host_block()/scsi_host_unblock() are recently added by:
> > > 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
> > > and so far the APIs are only used by:
> > > 3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block I/O")
> > >
> > > However, from reading the code, I think the APIs don't really work for
> > > aacraid, because, in the resume path of hibernation, when aac_suspend() ->
> > > scsi_host_block() is called, scsi_device_quiesce() has set the state to
> > > SDEV_QUIESCE, so aac_suspend() -> scsi_host_block() returns -EINVAL.
> > >
> > > Fix the issue by allowing the state change.
> > >
> > > Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper
> > function")
> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > > ---
> > >  drivers/scsi/scsi_lib.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 47835c4b4ee0..06c260f6cdae 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -2284,6 +2284,7 @@ scsi_device_set_state(struct scsi_device *sdev,
> > enum scsi_device_state state)
> > >  		switch (oldstate) {
> > >  		case SDEV_RUNNING:
> > >  		case SDEV_CREATED_BLOCK:
> > > +		case SDEV_QUIESCE:
> > >  		case SDEV_OFFLINE:
> > >  			break;
> > >  		default:
> > 
> > Looks reasonable because SDEV_BLOCK is one more strict state than
> > QEIESCE, so:
> 
> Thanks, Ming!
> 
> > Reviewed-by: Ming Lei <ming.lei@redha.com>
> > 
> > Thanks,
> > Ming
> 
> There should be a small typo: s/redha/redhat :-)

Sorry for the fault:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

