Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55525C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 05:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE8B64E15
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 05:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhBKF5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 00:57:12 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:34350 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBKF5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 00:57:10 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 6574A2EA1A5;
        Thu, 11 Feb 2021 00:56:27 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id yvbXlzG+4f5a; Thu, 11 Feb 2021 00:41:18 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 71AAF2EA008;
        Thu, 11 Feb 2021 00:56:26 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3] scsi_debug: add new defer_type for mq_poll
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
References: <20210209225624.108341-1-dgilbert@interlog.com>
 <CAHsXFKEhiwHmMmJ00eeA1ikP3wdiJP2xggsuO0Qc9H1ogNXnVQ@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <c9084cf7-4f75-dc62-1927-a2695f6cc52c@interlog.com>
Date:   Thu, 11 Feb 2021 00:56:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHsXFKEhiwHmMmJ00eeA1ikP3wdiJP2xggsuO0Qc9H1ogNXnVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-09 10:08 p.m., Kashyap Desai wrote:
> On Wed, Feb 10, 2021 at 4:26 AM Douglas Gilbert <dgilbert@interlog.com> wrote:
>>
>> Add a new sdeb_defer_type enumeration: SDEB_DEFER_POLL for requests
>> that have REQ_HIPRI set in cmd_flags field. It is expected that
>> these requests will be polled via the mq_poll entry point which
>> is driven by calls to blk_poll() in the block layer. Therefore
>> timer events are not 'wired up' in the normal fashion.
>>
>> There are still cases with short delays (e.g. < 10 microseconds)
>> where by the time the command response processing occurs, the delay
>> is already exceeded in which case the code calls scsi_done()
>> directly. In such cases there is no window for mq_poll() to be
>> called.
>>
>> Add 'mq_polls' counter that increments on each scsi_done() called
>> via the mq_poll entry point. Can be used to show (with 'cat
>> /proc/scsi/scsi_debug/<host_id>') that blk_poll() is causing
>> completions rather than some other mechanism.
>>
>>
>> This patch is against the 5.12/scsi-staging branch which includes
>>     a98d6bdf181eb71bf4686666eaf47c642a061642
>>     scsi_debug : iouring iopoll support
>> which it alters. So this patch is a fix of that patch.
>>
>> Changes since version 2 [sent 20210206 to linux-scsi list]
>>    - the sdebug_blk_mq_poll() callback didn't cope with the
>>      uncommon case where sqcp->sd_dp is NULL. Fix.
> 
> Hi Doug, I tried this patch on top of below iouring patch series -
> "[v3,1/4] add io_uring with IOPOLL support in scsi layer"
> 
> After applying patch, I am seeing an IO hang issue - I see
> io_wqe_worker goes into a tight loop.
> 
> 18210 root      20   0 1316348   3552   2376 R  99.1   0.0   0:24.09
> fio                                       18303 root      20   0
> 0      0      0 D  78.8   0.0   0:01.75 io_wqe_worker-0
>             18219 root      20   0       0      0      0 R  71.7   0.0
>   0:06.59 io_wqe_worker-0
> 
> 
> I used below command -
> insmod drivers/scsi/scsi_debug.ko dev_size_mb=1024 sector_size=512
> add_host=24 per_host_store=1 ndelay=10000 host_max_queue=32
> submit_queues=76 num_parts=1 poll_queues=8
> 
> and here is my fio script -
> [global]
> ioengine=io_uring
> hipri=1
> direct=1
> runtime=30s
> rw=randread
> norandommap
> bs=4k
> iodepth=64

Kashyap,
There is another issue here, namely iodepth > host_max_queue (64 > 32)
and in my setup that is not handled well. So there is a problem with
scsi_debug *** or the mid-level in handling this case.

If you have modified the sd driver to call blk_poll() then perhaps
you could try the above test again with a reduced iodepth.

Doug Gilbert

*** the scsi_debug should either yield a TASK SET FULL status or return
     SCSI_MLQUEUE_HOST_BUSY from queuecommand() when it has run out of
     slots.

> [seqprecon]
> filename=/dev/sdd
> [seqprecon]
> filename=/dev/sde
> [seqprecon]
> filename=/dev/sdf
> 
> 
> I will ask Martin to pick all the patches from "[v3,1/4] add io_uring
> with IOPOLL support in the scsi layer" except scsi_debug. We can work
> on scsi_debug and send standalone patch.
> 
> Kashyap
