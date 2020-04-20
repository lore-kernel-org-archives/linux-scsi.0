Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCB3C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD08E20857
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="VHLDWqIo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgDTQg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726532AbgDTQgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 12:36:25 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D09C025492
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:36:25 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s10so9682870iln.11
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HFUgOWKf4w0+Py7DhiUyoQr4H+s4BKeAe5WdiAFlPfs=;
        b=VHLDWqIoEkcCixWyPK//br6mkLWACHyOLTnwLSW/hdEJbBu9OFINE2gwgj/AM6Dfk2
         zsrqUkeJ7zeFiQco3kYWvIe3ppxTjKTba9QKxzfesh3GyJaPQfep3iKZxs8vRFTcU+7O
         scdKaqHOw/cJ43JNuFWjxqQ5niVFhQXknBt+70QNJ2W4VCekk32r3MKToU+2FFdhlPTN
         73u/W5b0Muf813GvMGSm1S2tE+PpueqXvMMY+MhUY5e7WQOO99LfzINdMgKxuUk/POA6
         BfpQupW8cu/TEThz3BTGcbaWfGtKR6agESCM/O3F+LRPaLuvS1mU7lCie/jLdnlncvyY
         C+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFUgOWKf4w0+Py7DhiUyoQr4H+s4BKeAe5WdiAFlPfs=;
        b=DzDLkmT1DWmC+qBoHvn5rWZZq7POixaAg45ueWW5fQFpqHs+VFkTbJR9vfBrNSGXtQ
         lawY598YEQv95XIc8VkGN1OTZGEYSyp7JbjX+PA8NKE3LvHMOLSxC9er/rIAoCzikt0k
         W8C2OGhLe80QePeYfw5Tm52PQUanNrBsHgFKpUQk5QT7vUS+oDuOXdqlxy0x3HfhFZNg
         ONFyc0Tbt5E9COsiI9xPvA1l4TqApL0gAmzr3boHus+NraddEy50M9cdxFVvUDmFF34N
         RfuSr1qdAEEqwAo0WrlrR3ABh9AkUelt2fQBvwgOjjS+EANywbFShQfsNmhuQ+2vPIHO
         Mmfg==
X-Gm-Message-State: AGi0PuYZyXemhumuQxEJ7Mod6KvS4RJPYI6ezTZn0IMavrloeYaFHGhf
        l1Yc7NKsBGlO6/Bkf818WHojlg==
X-Google-Smtp-Source: APiQypJWxZK3Z97CRGtXAd/5AvKBg6SWr+l25Skb33HnkR4R+0ebhHdkEhSj8wdnSlQaZ24bKOuu5Q==
X-Received: by 2002:a92:ba51:: with SMTP id o78mr16831897ili.290.1587400583686;
        Mon, 20 Apr 2020 09:36:23 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f1sm423114iog.46.2020.04.20.09.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 09:36:23 -0700 (PDT)
Subject: Re: [PATCH v5 0/4] blk-mq: Fix two causes of IO stalls found in
 reboot testing
To:     Douglas Anderson <dianders@chromium.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        sqazi@google.com, groeck@chromium.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        paolo.valente@linaro.org,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
References: <20200420162454.48679-1-dianders@chromium.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f9a5e9d-4485-aa46-be31-f561ba5363c8@kernel.dk>
Date:   Mon, 20 Apr 2020 10:36:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420162454.48679-1-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/20 10:24 AM, Douglas Anderson wrote:
> While doing reboot testing, I found that occasionally my device would
> trigger the hung task detector.  Many tasks were stuck waiting for the
> a blkdev mutex, but at least one task in the system was always sitting
> waiting for IO to complete (and holding the blkdev mutex).  One
> example of a task that was just waiting for its IO to complete on one
> reboot:
> 
>  udevd           D    0  2177    306 0x00400209
>  Call trace:
>   __switch_to+0x15c/0x17c
>   __schedule+0x6e0/0x928
>   schedule+0x8c/0xbc
>   schedule_timeout+0x9c/0xfc
>   io_schedule_timeout+0x24/0x48
>   do_wait_for_common+0xd0/0x160
>   wait_for_completion_io_timeout+0x54/0x74
>   blk_execute_rq+0x9c/0xd8
>   __scsi_execute+0x104/0x198
>   scsi_test_unit_ready+0xa0/0x154
>   sd_check_events+0xb4/0x164
>   disk_check_events+0x58/0x154
>   disk_clear_events+0x74/0x110
>   check_disk_change+0x28/0x6c
>   sd_open+0x5c/0x130
>   __blkdev_get+0x20c/0x3d4
>   blkdev_get+0x74/0x170
>   blkdev_open+0x94/0xa8
>   do_dentry_open+0x268/0x3a0
>   vfs_open+0x34/0x40
>   path_openat+0x39c/0xdf4
>   do_filp_open+0x90/0x10c
>   do_sys_open+0x150/0x3c8
>   ...
> 
> I've reproduced this on two systems: one boots from an internal UFS
> disk and one from eMMC.  Each has a card reader attached via USB with
> an SD card plugged in.  On the USB-attached SD card is a disk with 12
> partitions (a Chrome OS test image), if it matters.  The system
> doesn't do much with the USB disk other than probe it (it's plugged in
> my system to help me recover).
> 
> From digging, I believe that there are two separate but related
> issues.  Both issues relate to the SCSI code saying that there is no
> budget.
> 
> I have done testing with only one or the other of the two patches in
> this series and found that I could still encounter hung tasks if only
> one of the two patches was applied.  This deserves a bit of
> explanation.  To me, it's fairly obvious that the first fix wouldn't
> fix the problems talked about in the second patch.  However, it's less
> obvious why the second patch doesn't fix the problems in
> blk_mq_dispatch_rq_list().  It turns out that it _almost_ does
> (problems become much more rare), but I did manage to get a single
> trace where the "kick" scheduled by the second patch happened really
> quickly.  The scheduled kick then ran and found nothing to do.  This
> happened in parallel to a task running in blk_mq_dispatch_rq_list()
> which hadn't gotten around to splicing the list back into
> hctx->dispatch.  This is why we need both fixes.
> 
> Most of my testing has been atop Chrome OS 5.4's kernel tree which
> currently has v5.4.30 merged in.  The Chrome OS 5.4 tree also has a
> patch by Salman Qazi, namely ("block: Limit number of items taken from
> the I/O scheduler in one go").  Reverting that patch didn't make the
> hung tasks go away, so I kept it in for most of my testing.
> 
> I have also done some testing on mainline Linux (most on what git
> describe calls v5.6-rc7-227-gf3e69428b5e2) even without Salman's
> patch.  I found that I could reproduce the problems there and that
> traces looked about the same as I saw on the downstream branch.  These
> patches were also confirmed to fix the problems on mainline.
> 
> Chrome OS is currently setup to use the BFQ scheduler and I found that
> I couldn't reproduce the problems without BFQ.  As discussed in the
> second patch this is believed to be because BFQ sometimes returns
> "true" from has_work() but then NULL from dispatch_request().
> 
> I'll insert my usual caveat that I'm sending patches to code that I
> know very little about.  If I'm making a total bozo patch here, please
> help me figure out how I should fix the problems I found in a better
> way.
> 
> If you want to see a total ridiculous amount of chatter where I
> stumbled around a whole bunch trying to figure out what was wrong and
> how to fix it, feel free to read <https://crbug.com/1061950>.  I
> promise it will make your eyes glaze over right away if this cover
> letter didn't already do that.  Specifically comment 79 in that bug
> includes a link to my ugly prototype of making BFQ's has_work() more
> exact (I only managed it by actually defining _both_ an exact and
> inexact function to avoid circular locking problems when it was called
> directly from blk_mq_hctx_has_pending()).  Comment 79 also has more
> thoughts about alternatives considered.
> 
> I don't know if these fixes represent a regression of some sort or are
> new.  As per above I could only reproduce with BFQ enabled which makes
> it nearly impossible to go too far back with this.  I haven't listed
> any "Fixes" tags here, but if someone felt it was appropriate to
> backport this to some stable trees that seems like it'd be nice.
> Presumably at least 5.4 stable would make sense.
> 
> Thanks to Salman Qazi, Paolo Valente, and Guenter Roeck who spent a
> bunch of time helping me trawl through some of this code and reviewing
> early versions of this patch.

Applied, thanks.

-- 
Jens Axboe

