Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946D9C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58A3761222
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhDOMTe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231391AbhDOMTd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618489149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+nSR8Fdn/QFee9fygyqORQIyEydWILjxfded0NRyhqc=;
        b=PfNPbpePieqmUYVn09CS10W0kt0jWcqEs6gKKRjiAFric5yGfncdJxvCXaeUCShF2IaFJZ
        HRf7oQ7ijMHywdxlA2GZTjoPEQoLV5PwRU8YTa0Yi/w8C1goCYExe/9hLLcfr2tDkPdwrZ
        X4jOieWh5zwPrvzw96+keGkiN+eAqPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-6wCv39xSO6eqsS-E4o6z4g-1; Thu, 15 Apr 2021 08:19:07 -0400
X-MC-Unique: 6wCv39xSO6eqsS-E4o6z4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40F2664149;
        Thu, 15 Apr 2021 12:19:06 +0000 (UTC)
Received: from T590 (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C38D60CC5;
        Thu, 15 Apr 2021 12:19:01 +0000 (UTC)
Date:   Thu, 15 Apr 2021 20:18:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHgvMAHqIq9f6pQn@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 15, 2021 at 11:41:52AM +0100, John Garry wrote:
> Hi Ming,
> 
> I'll have a look.
> 
> BTW, are you intentionally using scsi_debug over null_blk? null_blk supports
> shared sbitmap as well, and performance figures there are generally higher
> than scsi_debug for similar fio settings.

I use both, but scsi_debug can cover scsi stack test.

Thanks,
Ming

> 
> Thanks,
> john
> 
> EOM
> 
> 
> > > 		IOPs
> > > mq-deadline	usr=21.72%, sys=44.18%,		423K
> > > none		usr=23.15%, sys=74.01%		450K
> > Today I re-run the scsi_debug test on two server hardwares(32cores, dual
> > numa nodes), and the CPU utilization issue can be reproduced, follow
> > the test result:
> > 
> > 1) randread test on ibm-x3850x6[*] with deadline
> > 
> >                |IOPS    | FIO CPU util
> > ------------------------------------------------
> > hosttags      | 94k    | usr=1.13%, sys=14.75%
> > ------------------------------------------------
> > non hosttags  | 124k   | usr=1.12%, sys=10.65%,
> > 
> > 
> > 2) randread test on ibm-x3850x6[*] with none
> >                |IOPS    | FIO CPU util
> > ------------------------------------------------
> > hosttags      | 120k   | usr=0.89%, sys=6.55%
> > ------------------------------------------------
> > non hosttags  | 121k   | usr=1.07%, sys=7.35%
> > ------------------------------------------------
> > 
> >   *:
> >   	- that is the machine Yanhui reported VM cpu utilization increased by 20%
> > 	- kernel: latest linus tree(v5.12-rc7, commit: 7f75285ca57)
> > 	- also run same test on another 32cores machine, IOPS drop isn't
> > 	  observed, but CPU utilization is increased obviously
> > 
> > 3) test script
> > #/bin/bash
> > 
> > run_fio() {
> > 	RTIME=$1
> > 	JOBS=$2
> > 	DEVS=$3
> > 	BS=$4
> > 
> > 	QD=64
> > 	BATCH=16
> > 
> > 	fio --bs=$BS --ioengine=libaio \
> > 		--iodepth=$QD \
> > 	    --iodepth_batch_submit=$BATCH \
> > 		--iodepth_batch_complete_min=$BATCH \
> > 		--filename=$DEVS \
> > 		--direct=1 --runtime=$RTIME --numjobs=$JOBS --rw=randread \
> > 		--name=test --group_reporting
> > }
> > 
> > SCHED=$1
> > 
> > NRQS=`getconf _NPROCESSORS_ONLN`
> > 
> > rmmod scsi_debug
> > modprobe scsi_debug host_max_queue=128 submit_queues=$NRQS virtual_gb=256
> > sleep 2
> > DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
> > echo $SCHED >/sys/block/`basename $DEV`/queue/scheduler
> > echo 128 >/sys/block/`basename $DEV`/device/queue_depth
> > run_fio 20 16 $DEV 8K
> > 
> > 
> > rmmod scsi_debug
> > modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256
> > sleep 2
> > DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
> > echo $SCHED >/sys/block/`basename $DEV`/queue/scheduler
> > echo 128 >/sys/block/`basename $DEV`/device/queue_depth
> > run_fio 20 16 $DEV 8k
> 
> 

-- 
Ming

