Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0FEC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 03:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF3A26145C
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 03:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240417AbhDWDxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 23:53:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240392AbhDWDx3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 23:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619149972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpHaIQ8iyyfWBb93DRoUn8ou8+eNrSDwzEQOdt4rc7E=;
        b=DxwnCMMYiLBFKzaUx5iz7Ic6eS7Edg08anl9guUCUyo81H8nS6uzTlEtE54zeEBPX4TmoW
        fDRad3OZiRIXbZD2YgE6B969mmeD5Fx2xAqewMGK7hN9ogBTtsWnRVEgJqvtGHg9LttxLN
        jJhGdQVE5NKq0sNtO517iiRar2MZVLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-kQ8Fk8qDN4y5VhbvdD4aiQ-1; Thu, 22 Apr 2021 23:52:48 -0400
X-MC-Unique: kQ8Fk8qDN4y5VhbvdD4aiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C42C1B18BD2;
        Fri, 23 Apr 2021 03:52:46 +0000 (UTC)
Received: from T590 (ovpn-13-78.pek2.redhat.com [10.72.13.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 689D576C1D;
        Fri, 23 Apr 2021 03:52:34 +0000 (UTC)
Date:   Fri, 23 Apr 2021 11:52:35 +0800
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
Message-ID: <YIJEg9DLWoOJ06Kc@T590>
References: <20210421000235.2028-1-bvanassche@acm.org>
 <20210421000235.2028-4-bvanassche@acm.org>
 <YIDqa6YkNoD5OiKN@T590>
 <b717ffc0-a434-738f-9c63-32901bd164b2@acm.org>
 <YIEiElb9wxReV/oL@T590>
 <32a121b7-2444-ac19-420d-4961f2a18129@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a121b7-2444-ac19-420d-4961f2a18129@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 22, 2021 at 08:51:06AM -0700, Bart Van Assche wrote:
> On 4/22/21 12:13 AM, Ming Lei wrote:
> > On Wed, Apr 21, 2021 at 08:54:30PM -0700, Bart Van Assche wrote:
> >> On 4/21/21 8:15 PM, Ming Lei wrote:
> >>> On Tue, Apr 20, 2021 at 05:02:33PM -0700, Bart Van Assche wrote:
> >>>> +static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
> >>>> +{
> >>>> +	struct bt_tags_iter_data *iter_data = data;
> >>>> +	struct blk_mq_tags *tags = iter_data->tags;
> >>>> +	bool res;
> >>>> +
> >>>> +	if (iter_data->flags & BT_TAG_ITER_MAY_SLEEP) {
> >>>> +		down_read(&tags->iter_rwsem);
> >>>> +		res = __bt_tags_iter(bitmap, bitnr, data);
> >>>> +		up_read(&tags->iter_rwsem);
> >>>> +	} else {
> >>>> +		rcu_read_lock();
> >>>> +		res = __bt_tags_iter(bitmap, bitnr, data);
> >>>> +		rcu_read_unlock();
> >>>> +	}
> >>>> +
> >>>> +	return res;
> >>>> +}
> >>>
> >>> Holding one rwsem or rcu read lock won't avoid the issue completely
> >>> because request may be completed remotely in iter_data->fn(), such as
> >>> nbd_clear_req(), nvme_cancel_request(), complete_all_cmds_iter(),
> >>> mtip_no_dev_cleanup(), because blk_mq_complete_request() may complete
> >>> request in softirq, remote IPI, even wq, and the request is still
> >>> referenced in these contexts after bt_tags_iter() returns.
> >>
> >> The rwsem and RCU read lock are used to serialize iterating over
> >> requests against blk_mq_sched_free_requests() calls. I don't think it
> >> matters for this patch from which context requests are freed.
> > 
> > Requests still can be referred in other context after blk_mq_wait_for_tag_iter()
> > returns, then follows freeing request pool. And use-after-free exists too, doesn't it?
> 
> The request pool should only be freed after it has been guaranteed that
> all pending requests have finished and also that no new requests will be
> started. This patch series adds two blk_mq_wait_for_tag_iter() calls.
> Both calls happen while the queue is frozen so I don't think that the
> issue mentioned in your email can happen.

For example, scsi aacraid normal completion vs. reset together with elevator
switch, aacraid is one single queue HBA, and the request will be completed
via IPI or softirq asynchronously, that said request isn't really completed
after blk_mq_complete_request() returns.

1) interrupt comes, and request A is completed via blk_mq_complete_request()
from aacraid's interrupt handler via ->scsi_done()

2) _aac_reset_adapter() comes because of reset event which can be
triggered by sysfs store or whatever, irq is drained in 
_aac_reset_adpter(), so blk_mq_complete_request(request A) from aacraid irq
context is done, but request A is just scheduled to be completed via IPI
or softirq asynchronously, not really done yet.

3) scsi_host_complete_all_commands() is called from _aac_reset_adapter() for
failing all pending requests. request A is still visible in
scsi_host_complete_all_commands, because its tag isn't freed yet. But the
tag & request A can be completed & freed exactly after scsi_host_complete_all_commands()
reads ->rqs[bitnr] in bt_tags_iter(), which calls complete_all_cmds_iter()
-> .scsi_done() -> blk_mq_complete_request(), and same request A is scheduled via
IPI or softirq, and request A is addded in ipi or softirq list.

4) meantime request A is freed from normal completion triggered by interrupt, one
pending elevator switch can move on since request A drops the last reference; and
bt_tags_iter() returns from reset path, so blk_mq_wait_for_tag_iter() can return
too, then the whole scheduler request pool is freed now.

5) request A in ipi/softirq list scheduled from _aac_reset_adapter is read , UAF
is triggered.

It is supposed that driver covers normal completion vs. error handling, but wrt.
remove completion, not sure driver is capable of covering that.

Thanks,
Ming

