Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56636C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC2061139
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 14:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbhDUOGr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:06:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243313AbhDUOGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 10:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619013973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CRLa2JCfYvN/vCiE/deGYt7ZkkHWFGnEKxzfxa/cxQ=;
        b=T1V2bktbHCddhOE7QumcM4c56gXyJRk8P8f+rQFZW0IrH+p6DOEVloYX5zgkleARdCQM14
        nfZ+ZXd+vByx+mXsiXEsC3EiWkovB5pmdh7Dpsf4MyZs/cLTAnwSj8CXrZq25aFyw5NqU0
        uT+4bxYiEY77AwnYd4HgdxPJCQ2I1Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-nQI5F6_BMIyqH9fy47vICg-1; Wed, 21 Apr 2021 10:06:09 -0400
X-MC-Unique: nQI5F6_BMIyqH9fy47vICg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B00F15F9FB;
        Wed, 21 Apr 2021 14:05:06 +0000 (UTC)
Received: from T590 (ovpn-12-35.pek2.redhat.com [10.72.12.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAA9619704;
        Wed, 21 Apr 2021 14:05:02 +0000 (UTC)
Date:   Wed, 21 Apr 2021 22:05:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 0/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk
 scsi commands
Message-ID: <YIAxD+5G8Ra43CB/@T590>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
 <fce30dfdee0eed3959358d4b8b826ecc20f5f7bd.camel@suse.com>
 <YIABO6e3VLDCFU1b@T590>
 <fd6f98c269e95d9cd0a36cf4b62d290e612ba006.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd6f98c269e95d9cd0a36cf4b62d290e612ba006.camel@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 21, 2021 at 02:33:46PM +0200, Martin Wilck wrote:
> On Wed, 2021-04-21 at 18:40 +0800, Ming Lei wrote:
> > On Wed, Apr 21, 2021 at 12:19:00PM +0200, Martin Wilck wrote:
> > > On Wed, 2021-04-21 at 15:55 +0800, Ming Lei wrote:
> > > > Hello Guys,
> > > > 
> > > > fnic uses the following way to walk scsi commands in failure
> > > > handling,
> > > > which is obvious wrong, because caller of scsi_host_find_tag has
> > > > to
> > > > guarantee that the tag is active.
> > > > 
> > > >         for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
> > > >                                 ...
> > > >                 sc = scsi_host_find_tag(fnic->lport->host, tag);
> > > >                                 ...
> > > >                 }
> > > > 
> > > > Fix the issue by using blk_mq_tagset_busy_iter() to walk
> > > > request/scsi_command.
> > > 
> > > How does this relate to Hannes' previous patch?
> > > https://marc.info/?l=linux-scsi&m=161400059528859&w=2
> > 
> > oops, this patch is actually same or similar with Hannes's.
> > 
> > Given these patches are bug fix, can we cherry-pick them for 5.13?
> 
> No objections in principle, but the differences between your patch and
> Hannes' are pretty large. I couldn't tell which one is more
> appropriate.
> 
> Question: Both your patch set and Hannes' patch replace a couple of
> scsi_host_find_tag() calls in the fnic driver, while leaving some
> others in place. It's not clear to me why we can be sure that no
> corruption occurs in any of the latter. Could you explain?

Caller of scsi_host_find_tag() has to guarantee that the passed tag
is active.

The changed functions do pass invalid tag to scsi_host_find_tag(), so
we need to fix them.


Thanks,
Ming

