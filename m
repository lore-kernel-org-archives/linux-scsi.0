Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584F1C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 00:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B60613DE
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 00:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhDYAKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 20:10:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhDYAKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Apr 2021 20:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619309368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+++l9kf16duxNLUPF71IHHpaZ2R3yJVaFpIX+4sDlAs=;
        b=P7oSgGNig46cDHLxBT9RzKVUTZR/Pn6ksGuBeX9z4gM43rJpFF2vXpiylYtdtAK6y8fMKM
        05U3AhtdpKbjotorxdnPbpDObQgNZN+jtQpV5rteCztqA4HHjmtniD8+c6XXUXMttp4icO
        Rdu14Yn+/u8nxHFqy1eO65eLr5skVf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-6ye3G68xOXqa8aVCh9lIzQ-1; Sat, 24 Apr 2021 20:09:26 -0400
X-MC-Unique: 6ye3G68xOXqa8aVCh9lIzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E140107ACCA;
        Sun, 25 Apr 2021 00:09:25 +0000 (UTC)
Received: from T590 (ovpn-12-72.pek2.redhat.com [10.72.12.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 476AA60BE5;
        Sun, 25 Apr 2021 00:09:14 +0000 (UTC)
Date:   Sun, 25 Apr 2021 08:09:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>,
        Khazhismel Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 3/5] blk-mq: Fix races between iterating over requests
 and freeing requests
Message-ID: <YISzLal7Ur7jyuiy@T590>
References: <20210421000235.2028-1-bvanassche@acm.org>
 <20210421000235.2028-4-bvanassche@acm.org>
 <YIDqa6YkNoD5OiKN@T590>
 <b717ffc0-a434-738f-9c63-32901bd164b2@acm.org>
 <YIEiElb9wxReV/oL@T590>
 <32a121b7-2444-ac19-420d-4961f2a18129@acm.org>
 <YIJEg9DLWoOJ06Kc@T590>
 <28607d75-042f-7a6a-f5d0-2ee03754917e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28607d75-042f-7a6a-f5d0-2ee03754917e@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2021 at 10:52:43AM -0700, Bart Van Assche wrote:
> On 4/22/21 8:52 PM, Ming Lei wrote:
> > For example, scsi aacraid normal completion vs. reset together with elevator
> > switch, aacraid is one single queue HBA, and the request will be completed
> > via IPI or softirq asynchronously, that said request isn't really completed
> > after blk_mq_complete_request() returns.
> > 
> > 1) interrupt comes, and request A is completed via blk_mq_complete_request()
> > from aacraid's interrupt handler via ->scsi_done()
> > 
> > 2) _aac_reset_adapter() comes because of reset event which can be
> > triggered by sysfs store or whatever, irq is drained in 
> > _aac_reset_adpter(), so blk_mq_complete_request(request A) from aacraid irq
> > context is done, but request A is just scheduled to be completed via IPI
> > or softirq asynchronously, not really done yet.
> > 
> > 3) scsi_host_complete_all_commands() is called from _aac_reset_adapter() for
> > failing all pending requests. request A is still visible in
> > scsi_host_complete_all_commands, because its tag isn't freed yet. But the
> > tag & request A can be completed & freed exactly after scsi_host_complete_all_commands()
> > reads ->rqs[bitnr] in bt_tags_iter(), which calls complete_all_cmds_iter()
> > -> .scsi_done() -> blk_mq_complete_request(), and same request A is scheduled via
> > IPI or softirq, and request A is addded in ipi or softirq list.
> > 
> > 4) meantime request A is freed from normal completion triggered by interrupt, one
> > pending elevator switch can move on since request A drops the last reference; and
> > bt_tags_iter() returns from reset path, so blk_mq_wait_for_tag_iter() can return
> > too, then the whole scheduler request pool is freed now.
> > 
> > 5) request A in ipi/softirq list scheduled from _aac_reset_adapter is read , UAF
> > is triggered.
> > 
> > It is supposed that driver covers normal completion vs. error handling, but wrt.
> > remove completion, not sure driver is capable of covering that.
> 
> Hi Ming,
> 
> I agree that the scenario above can happen and also that a fix is
> needed. However, I do not agree that this should be fixed by modifying
> the tag iteration functions. I see scsi_host_complete_all_commands() as
> a workaround for broken storage controllers - storage controllers that
> do not have a facility for terminating all pending commands. NVMe
> controllers can be told to terminate all pending I/O commands by e.g.
> deleting all I/O submission queues. Many SCSI controllers also provide a
> facility for aborting all pending commands. For SCSI controllers that do
> not provide such a facility I propose to fix races like the race
> described above in the SCSI LLD instead of modifying the block layer tag
> iteration functions.

Hi Bart,

Terminating all pending commands can't avoid the issue wrt. request UAF,
so far blk_mq_tagset_wait_completed_request() is used for making sure
that all pending requests are really aborted.

However, blk_mq_wait_for_tag_iter() still may return before
blk_mq_wait_for_tag_iter() is done because blk_mq_wait_for_tag_iter()
supposes all request reference is just done inside bt_tags_iter(),
especially .iter_rwsem and read rcu lock is added in bt_tags_iter().

What I really meant is that .iter_rwsem/read rcu added or blk_mq_wait_for_tag_iter
can't do what is expected.


Thanks,
Ming

