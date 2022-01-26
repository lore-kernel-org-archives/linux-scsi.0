Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BD1C5AC75
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 01:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiAZB0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:26:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232531AbiAZB0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 20:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643160362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dgl7eHDXxIR3cG6ko/Vb1Y4EDtbBcCShRJOKmtmL6eA=;
        b=UJ/ymM0HLY8qOuJRGc2qUvw2f+wNYgYlSnHHaN/YLmHS8Y4gs7WK4bzsrGU6oToqzqUSyO
        G4XE7gS5/Ih0qcQA2B3gifMiGP4qv7GhRmg6eTWH43LZfJk2Fo24Cfq44qNvOP8vPdIlEp
        oN3tkUFfgdxCqMBrudNZ+ifoDAO1ebg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-linFexfQNSKl4NRGtU7agw-1; Tue, 25 Jan 2022 20:25:58 -0500
X-MC-Unique: linFexfQNSKl4NRGtU7agw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4421E80D690;
        Wed, 26 Jan 2022 01:25:57 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 291F81000358;
        Wed, 26 Jan 2022 01:25:51 +0000 (UTC)
Date:   Wed, 26 Jan 2022 09:25:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <YfCjGrZFsIfe+m94@T590>
References: <YdZcABq/pxMMh3X0@T590>
 <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
 <YdcEJngPYrZk691Q@T590>
 <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
 <YdcNrSJJGllQzWOB@T590>
 <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
 <YdcZwVUFGUPgkbLn@T590>
 <Ydug9nWg4loEVkJw@T590>
 <419311a6df021b0ba7b7e710caeb7e649ce8eeb1.camel@suse.com>
 <53cb63b07b187ed608d9c93bbde11d1c8953113c.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53cb63b07b187ed608d9c93bbde11d1c8953113c.camel@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 04:29:37PM +0000, Martin Wilck wrote:
> On Wed, 2022-01-12 at 17:59 +0100, Martin Wilck wrote:
> > On Mon, 2022-01-10 at 10:59 +0800, Ming Lei wrote:
> > > 
> > > Hello Martin Wilck,
> > > 
> > > Can you test the following change and report back the result?
> > > 
> > > From 480a61a85e9669d3487ebee8db3d387df79279fc Mon Sep 17 00:00:00
> > > 2001
> > > From: Ming Lei <ming.lei@redhat.com>
> > > Date: Mon, 10 Jan 2022 10:26:59 +0800
> > > Subject: [PATCH] scsi: core: reallocate scsi device's budget map if
> > > default
> > >  queue depth is changed
> > > 
> > > Martin reported that sdev->queue_depth can often be changed in
> > > ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> > > depth for setting up sdev->budget_map. And some extreme -
> > > >cmd_per_lun
> > > or ->can_queue won't be used at default actually, if we they are
> > > used
> > > to allocate sdev->budget_map, huge memory may be consumed just
> > > because
> > > of bad ->cmd_per_lun.
> > > 
> > > Fix the issue by reallocating sdev->budget_map after -
> > > > slave_configure()
> > > returns, at that time, queue_depth should be much more reasonable.
> > > 
> > > Reported-by: Martin Wilck <martin.wilck@suse.com>
> > > Suggested-by: Martin Wilck <martin.wilck@suse.com>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > 
> > This looks good. I added a few pr_infos, and for the strange mpt3sas
> > devices I reported, I get this:
> > 
> > # first allocation with depth=7 (cmds_per_lun)
> > Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 7 0-
> > >0 
> >    (these numbers are: depth old_shift->new_shift)
> > Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map:
> > map_nr = 1024
> > 
> > # after slave_alloc() with depth 254
> > Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 254
> > 0->5
> > Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map:
> > map_nr = 32
> > 
> > So the depth changed from 7 to 254, the shift from 0 to 5, and the
> > memory size of the
> > sbitmap was reduced by a factor of 32. Nice!
> > 
> > Tested-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> So, how do we proceed with this patch?

Looks 5.18/scsi is open now, I will submit one formal patch on linux-scsi
soon.


Thanks,
Ming

