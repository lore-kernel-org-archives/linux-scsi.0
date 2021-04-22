Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B0BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 14:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED6161421
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 14:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhDVOSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 10:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236092AbhDVOST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 10:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619101064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tU703VgPNI+ie8vMqrOjqXfeek+ccxpgh1+7soSqwC4=;
        b=RUT4JAoWDuytTlD0VKRum879o/aO/rXtm4Z7MV9l9dB/25JuFn/+O3d9Ez1Zxjqur+/iKf
        emu+n6uZ+ipcsSU/lfxDx3Xm54vFvJzGpDq444Wm8rr8m8gqnTLH8bLLMdLkP7Rx5Gk1Xm
        g8exnlyK3oyi9KTRtIyjAWK2rE7O5gI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-isyyPJkXPRudUILh3Bog_w-1; Thu, 22 Apr 2021 10:17:42 -0400
X-MC-Unique: isyyPJkXPRudUILh3Bog_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B90F102AC01;
        Thu, 22 Apr 2021 14:17:37 +0000 (UTC)
Received: from T590 (ovpn-13-243.pek2.redhat.com [10.72.13.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32A0C5450A;
        Thu, 22 Apr 2021 14:17:33 +0000 (UTC)
Date:   Thu, 22 Apr 2021 22:17:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH 0/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk
 scsi commands
Message-ID: <YIGFfScR3ZBluX01@T590>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
 <d251c21e-dd3e-979a-1c90-1f94b042e83c@suse.de>
 <YIC+ieKIKovpwptY@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIC+ieKIKovpwptY@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 22, 2021 at 08:08:41AM +0800, Ming Lei wrote:
> On Wed, Apr 21, 2021 at 10:14:56PM +0200, Hannes Reinecke wrote:
> > On 4/21/21 9:55 AM, Ming Lei wrote:
> > > Hello Guys,
> > > 
> > > fnic uses the following way to walk scsi commands in failure handling,
> > > which is obvious wrong, because caller of scsi_host_find_tag has to
> > > guarantee that the tag is active.
> > > 
> > >          for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
> > > 				...
> > >                  sc = scsi_host_find_tag(fnic->lport->host, tag);
> > > 				...
> > > 		}
> > > 
> > > Fix the issue by using blk_mq_tagset_busy_iter() to walk
> > > request/scsi_command.
> > > 
> > > thanks,
> > > Ming
> > > 
> > > 
> > > Ming Lei (5):
> > >    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
> > >      fnic_terminate_rport_io
> > >    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
> > >      fnic_clean_pending_aborts
> > >    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
> > >      fnic_cleanup_io
> > >    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
> > >      fnic_rport_exch_reset
> > >    scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in
> > >      fnic_is_abts_pending
> > > 
> > >   drivers/scsi/fnic/fnic_scsi.c | 933 ++++++++++++++++++----------------
> > >   1 file changed, 493 insertions(+), 440 deletions(-)
> > > 
> > > Cc: Satish Kharat <satishkh@cisco.com>
> > > Cc: Karan Tilak Kumar <kartilak@cisco.com>
> > > Cc: David Jeffery <djeffery@redhat.com>
> > > 
> > Well, this is actually not that easy for fnic.
> > Problem is the reset hack hch put in some time ago (cf
> > fnic_host_start_tag()), which will cause any TMF to use a tag which is _not_
> > visible to the busy iter.
> 
> 'git grep -n fnic_host_start_tag ./' shows nothing.
> 
> > That will cause the iter to miss any TMF, with unpredictable results if a
> > TMF is running at the same time than, say, a link bounce.
> 
> Wrt. linus tree or next tree, I don't see any issue wrt. your concern.
> 
> > 
> > I have folded this as part of my patchset for reserved commands in SCSI;
> > that way fnic can use 'normal' tags for TMFs, which are then visible to the
> > busy iter and life's good.
> 
> No, this fix is one bug fix, which can't depend on your reserved
> command in SCSI, and they need to be backported to stable tree too.

Hi Hannes,

We have customers report on this issue, could you please let us know
if you will post out one bug-fix only version?

Thanks,
Ming

