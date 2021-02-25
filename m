Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949F7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 07:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623DE64E85
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 07:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhBYHJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:09:39 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:45332 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhBYHIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 02:08:10 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id B19BC2A0F1;
        Thu, 25 Feb 2021 02:07:21 -0500 (EST)
Date:   Thu, 25 Feb 2021 18:07:22 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
cc:     tanxiaofei <tanxiaofei@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>
Subject: RE: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage optimization
 for SCSI drivers
In-Reply-To: <79b5bdb1b5d94b248671bf99a930d971@hisilicon.com>
Message-ID: <96385966-f423-4218-bd7-1bc7d8e6113f@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com> <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au> <e949a474a9284ac6951813bfc8b34945@hisilicon.com> <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
 <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com> <588a87f-ae42-0b7-749e-c780ce5c3e4f@telegraphics.com.au> <8c99b5c060eb4e5aa5b604666a8db516@hisilicon.com> <f38b950-c76e-39da-f386-9e77cfcecb3@telegraphics.com.au> <4d2f90d2157045a7b0800a4004f539ba@hisilicon.com>
 <7293ba4c-c5ab-528f-1feb-dc59bfb0df2d@telegraphics.com.au> <79b5bdb1b5d94b248671bf99a930d971@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Feb 2021, Song Bao Hua (Barry Song) wrote:

> 
> Realtime requirement is definitely a true requirement on ARM Linux.
> 
> I once talked/worked  with some guys who were using ARM for realtime
> system.
> The feasible approaches include:
> 1. Dual OS(RTOS + Linux): e.g.  QNX+Linux XENOMAI+Linux L4+Linux
> 2. preempt-rt
> Which is continuously maintained like:
> https://lore.kernel.org/lkml/20210218201041.65fknr7bdplwqbez@linutronix.de/
> 3. bootargs isolcpus=
> to isolate a cpu for a specific realtime task or interrupt
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_for_real_time/7/html/tuning_guide/isolating_cpus_using_tuned-profiles-realtime
> 4. ARM FIQ which has separate fiq API, an example in fsl sound:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/soc/fsl/imx-pcm-fiq.c
> 5. Let one core invisible to Linux
> Running non-os system and rtos on the core
> 

Regarding Linux systems, it appears that approach 3 could theoretically 
achieve minimal interrupt latency for a given device without requiring any 
interrupt nesting. But the price is one CPU core which is not going to 
work on a uniprocessor system.

> Honestly, I've never seen anyone who depends on irq priority to support 
> realtime in ARM Linux though ARM's RTOS-es use it quite commonly.
> 

Perhaps you don't work with uniprocessor ARM Linux systems?

> Once preempt_rt is enabled, those who want a fast irq environment need a 
> no_thread flag, or need to set its irq thread to higher sched_fifo/rr 
> priority.
> 

Thanks for the tip.

> [...]
> 
> Anyway, the debate is long enough, let's move to some more important 
> things. I appreciate that you shared a lot of knowledge of m68k.
> 

No problem.

> Thanks
> Barry
> 
