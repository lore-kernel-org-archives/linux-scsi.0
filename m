Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D56C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 15:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36633619B4
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 15:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhCWPaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 11:30:03 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:57012 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbhCWP3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 11:29:38 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 342E82EA319;
        Tue, 23 Mar 2021 11:29:35 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id DuPAF25aiZY6; Tue, 23 Mar 2021 11:11:45 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 339422EA3B3;
        Tue, 23 Mar 2021 11:29:34 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [scsi_debug] 20b58d1e6b: blktests.block.001.fail
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, mcgrof@kernel.org, hare@suse.de
References: <20210323132620.GA23032@xsang-OptiPlex-9020>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d771d5a1-d411-fb34-1c72-81d16e0588d4@interlog.com>
Date:   Tue, 23 Mar 2021 11:29:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210323132620.GA23032@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-23 9:26 a.m., kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 20b58d1e6b9cda142cd142a0a2f94c0d04b0a5a0 ("[RFC] scsi_debug: add hosts initialization --> worker")
> url: https://github.com/0day-ci/linux/commits/Douglas-Gilbert/scsi_debug-add-hosts-initialization-worker/20210319-230817
> base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
> 
> in testcase: blktests
> version: blktests-x86_64-a210761-1_20210124
> with following parameters:
> 
> 	disk: 1SSD
> 	test: block-group-00
> 	ucode: 0xe2
> 
> 
> 
> on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz with 32G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):

This RFC was proposed for Luis Chamberlain to consider for this report:
    https://bugzilla.kernel.org/show_bug.cgi?id=212337

Luis predicted that this change would trip up some blktests which is exactly 
what has happened here. The question here is whether it is reasonable (i.e.
a correct simulation of what real hardware does) to assume that as soon as
the loading of the scsi_debug is complete, that _all_ LUNs (devices) specified
in its parameters are ready for media access?

If yes then this RFC can be dropped or relegated to only occur when a driver
parameter is set to a non-default value.

If no then those blktest scripts need to be fixed to reflect that after a
HBA is loaded, all the targets and LUNs connected to it do _not_ immediately
become available.

Doug Gilbert


> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 2021-03-21 02:40:23 sed "s:^:block/:" /lkp/benchmarks/blktests/tests/block-group-00
> 2021-03-21 02:40:23 ./check block/001
> block/001 (stress device hotplugging)
> block/001 (stress device hotplugging)                        [failed]
>      runtime  ...  30.370s
>      --- tests/block/001.out	2021-01-24 06:04:08.000000000 +0000
>      +++ /lkp/benchmarks/blktests/results/nodev/block/001.out.bad	2021-03-21 02:40:53.652003261 +0000
>      @@ -1,4 +1,7 @@
>       Running block/001
>       Stressing sd
>      +ls: cannot access '/sys/class/scsi_device/4:0:0:0/device/block': No such file or directory
>      +ls: cannot access '/sys/class/scsi_device/5:0:0:0/device/block': No such file or directory
>       Stressing sr
>      +ls: cannot access '/sys/class/scsi_device/4:0:0:0/device/block': No such file or directory
>       Test complete
> 
> 
> 
> To reproduce:
> 
>          git clone https://github.com/intel/lkp-tests.git
>          cd lkp-tests
>          bin/lkp install                job.yaml  # job file is attached in this email
>          bin/lkp split-job --compatible job.yaml
>          bin/lkp run                    compatible-job.yaml
> 
> 
> 
> ---
> 0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
> https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation
> 
> Thanks,
> Oliver Sang
> 

