Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B05EC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 01:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24C46140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 01:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhDUBlM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 21:41:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231475AbhDUBlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 21:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618969238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNULbDnpSimOTQAcT2jSWY/VMJYJG/d2KtMhkgEm6JM=;
        b=aXEfl1McLsDfGDiYfIExLQO2gVwaLZG8KdSBokx/r2CgNErdc/NY4NJDlx4cj3cfzplZRt
        iK+jXhdqwnDePB58tu+Tui18Ypf5d2ba7jG0VcjkqMjXbSYaKLNZ5xEv8bKKIfPfNsAQLP
        1NOa798AeLQ6+gBB6dJViKZeegVp1Ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-iUMw-Wd2MQum5w5VhMgEdg-1; Tue, 20 Apr 2021 21:40:35 -0400
X-MC-Unique: iUMw-Wd2MQum5w5VhMgEdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C57BE835B4C;
        Wed, 21 Apr 2021 01:40:33 +0000 (UTC)
Received: from T590 (ovpn-13-15.pek2.redhat.com [10.72.13.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 394E910016F4;
        Wed, 21 Apr 2021 01:40:25 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:40:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YH+CicpLh8Ay1XYC@T590>
References: <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com>
 <YHjeUrCTbrSft18t@T590>
 <217e4cc1-c915-0e95-1d1c-4a11496080d6@huawei.com>
 <YHlNS3RqsYDMA3jQ@T590>
 <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com>
 <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
 <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org>
 <993c3ae5-a7e2-aa6d-a6f3-147f06e9d015@interlog.com>
 <CAFj5m9LPe=TdJgz2iJ7U6UT4=x-5aE=YbRgOQ80RHfpp62GQQQ@mail.gmail.com>
 <acb407c9-c9ab-4783-e526-e5d34876e57b@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb407c9-c9ab-4783-e526-e5d34876e57b@interlog.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2021 at 04:22:53PM -0400, Douglas Gilbert wrote:
> On 2021-04-20 2:52 a.m., Ming Lei wrote:
> > On Tue, Apr 20, 2021 at 12:54 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
> > > 
> > > On 2021-04-19 11:22 p.m., Bart Van Assche wrote:
> > > > On 4/19/21 8:06 PM, Douglas Gilbert wrote:
> > > > > I have always suspected under extreme pressure the block layer (or scsi
> > > > > mid-level) does strange things, like an IO hang, attempts to prove that
> > > > > usually lead back to my own code :-). But I have one example recently
> > > > > where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
> > > > > and the following one stalled (all on the same thread). Seconds later
> > > > > those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
> > > > > my dd variant went to its conclusion (reporting 10 errors). Following
> > > > > copies showed no ill effects.
> > > > > 
> > > > > My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
> > > > > two monitor for stalls during the copy. Each submitted READ and WRITE
> > > > > command gets its pack_id from an incrementing atomic and a management
> > > > > thread in those copies checks every 300 milliseconds that that atomic
> > > > > value is greater than the previous check. If not, dump the state of the
> > > > > sg driver. The stalled request was in busy state with a timeout of 1
> > > > > nanosecond which indicated that blk_execute_rq_nowait() had not been
> > > > > called. So the chief suspect would be blk_get_request() followed by
> > > > > the bio setup calls IMO.
> > > > > 
> > > > > So it certainly looked like an IO hang, not a locking, resource nor
> > > > > corruption issue IMO. That was with a branch off MKP's
> > > > > 5.13/scsi-staging branch taken a few weeks back. So basically
> > > > > lk 5.12.0-rc1 .
> > > > 
> > > > Hi Doug,
> > > > 
> > > > If it would be possible to develop a script that reproduces this hang and
> > > > if that script can be shared I will help with root-causing and fixing this
> > > > hang.
> > > 
> > > Possible, but not very practical:
> > >      1) apply supplied 83 patches to sg driver
> > >      2) apply pending patch to scsi_debug driver
> > >      3) find a stable kernel platform (perhaps not lk 5.12.0-rc1)
> > >      4) run supplied scripts for three weeks
> > >      5) dig through the output and maybe find one case (there were lots
> > >         of EAGAINs from blk_get_request() but they are expected when
> > >         thrashing the storage layers)
> > 
> > Or collecting the debugfs log after IO hang is triggered in your test:
> > 
> > (cd /sys/kernel/debug/block/$SDEV && find . -type f -exec grep -aH . {} \;)
> > 
> > $SDEV is the disk on which IO hang is observed.
> 
> Thanks. I'll try adding that to my IO hang trigger code.
> 
> My patches on the sg driver add debugfs support so these produce
> the same output:
>     cat /proc/scsi/sg/debug
>     cat /sys/kernel/debug/scsi_generic/snapshot
> 
> There is also a /sys/kernel/debug/scsi_generic/snapped file whose
> contents reflect the driver's state when ioctl(<sg_fd>, SG_DEBUG, &one)
> was last called.
> 
> When I test, the root file system is usually on a NVMe SSD so the
> state of all SCSI disks present should be dumped as they are part
> of my test. Also I find the netconsole module extremely useful and
> have an old laptop on my network running:
>    socat udp-recv:6665 - > socat.txt
> 
> picking up the UDP packets from netconsole on port 6665. Not quite as
> good as monitoring a hardware serial console, but less fiddly. And
> most modern laptops don't have access to a serial console so
> netconsole is the only option.

Yeah, years ago netconsole does help me much when serial console isn't
available, especially ssh doesn't work at that time, such as kernel
panic.

> 
> Another observation: upper level issues seem to impact the submission
> side of request handling (e.g. the IO hang I was trying to describe)
> while error injection I can do (e.g. using the scsi_debug driver)
> impacts the completion side (obviously). Are there any tools to inject
> errors into the block layer submission code?

block layer supports fault injection in submission side, see
should_fail_bio() which is called from submit_bio_checks().


thanks, 
Ming

