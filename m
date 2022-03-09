Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7558DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 01:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiCIBor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiCIBoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 20:44:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 309D8E7F5C
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 17:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646790217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3gBo9lqNpleo37BkiSg29OXHQwru/d5CaOaGabOnuKE=;
        b=bcvTjPjZyMX3Y82t3qca2Jn0N5TVJDprAigGYiaEoXCnPr895uawIW6dp3em16YFPKZ0tt
        teInP1kcocU2Ag+GWPJjc6TQk0vHyFPd+hn2g1YqPA9nc31sx/gZwGvF25V3o7Ii4x0n7A
        IYYisYzmlSsSnYijckSETvQIgu+nr80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-AjrWlyGPNEyfi6YojHIt2A-1; Tue, 08 Mar 2022 20:43:34 -0500
X-MC-Unique: AjrWlyGPNEyfi6YojHIt2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC8D1006AA6;
        Wed,  9 Mar 2022 01:43:32 +0000 (UTC)
Received: from T590 (ovpn-8-34.pek2.redhat.com [10.72.8.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F4D660657;
        Wed,  9 Mar 2022 01:43:28 +0000 (UTC)
Date:   Wed, 9 Mar 2022 09:43:24 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Message-ID: <YigGPK3zLAN87mSS@T590>
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-2-michael.christie@oracle.com>
 <Yif6jjlpPTEYpcAT@T590>
 <b1b7fa2c-ade3-987d-e240-fb6acb421b99@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b7fa2c-ade3-987d-e240-fb6acb421b99@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 08, 2022 at 07:17:13PM -0600, Mike Christie wrote:
> On 3/8/22 6:53 PM, Ming Lei wrote:
> > On Mon, Mar 07, 2022 at 06:39:54PM -0600, Mike Christie wrote:
> >> The software iscsi driver's queuecommand can block and taking the extra
> >> hop from kblockd to its workqueue results in a performance hit. Allowing
> >> it to set BLK_MQ_F_BLOCKING and transmit from that context directly
> >> results in a 20-30% improvement in IOPs for workloads like:
> >>
> >> fio --filename=/dev/sdb --direct=1 --rw=randrw --bs=4k --ioengine=libaio
> >> --iodepth=128  --numjobs=1
> >>
> >> and for all write workloads.
> > 
> > This single patch shouldn't make any difference for iscsi, so please
> > make it as last one if performance improvement data is provided
> > in commit log.
> 
> Ok.
> 
> > 
> > Also is there performance effect for other worloads? such as multiple
> > jobs? iscsi is SQ hardware, so if driver is blocked in ->queuecommand()
> > via BLK_MQ_F_BLOCKING, other contexts can't submit IO to scsi ML any more.
> 
> If you mean multiple jobs running on the same connection/session then
> they are all serialized now. A connection can only do 1 cmd at a time.
> There's a big mutex around it in the network layer, so multiple jobs
> just suck no matter what.

I guess one block device can only bind to one isci connection, given the
1 cmd per connection limit, so looks multiple jobs is fine.

> 
> If you mean multiple jobs from different connection/sessions, then the
> iscsi code with this patchset blocks only because the network layer
> takes a mutex for a short time. We configure it to not block for things
> like socket space, memory allocations, we do zero copy IO normally, etc
> so it's quick.
> 
> We also can do up to workqueues max_active limit worth of calls so
> other things can normally send IO. We haven't found a need to increase
> it yet.
 
I meant that hctx->run_work is required for blk-mq to dispatch IO, iscsi is
SQ HBA, so there is only single work_struct. If one context is blocked in
->queue_rq or ->queuecommand, other contexts can't submit IO to driver any
more.


Thanks,
Ming

