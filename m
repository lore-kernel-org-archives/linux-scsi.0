Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4DBC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5EA21726
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfH2PrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:47:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42399 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2PrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:47:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1384C204191;
        Thu, 29 Aug 2019 17:47:11 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5ZkrM5D+6x05; Thu, 29 Aug 2019 17:47:09 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id B04AA204158;
        Thu, 29 Aug 2019 17:47:07 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v4 07/22] sg: move header to uapi section
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@infradead.org,
        Hannes Reinecke <hare@suse.com>
References: <20190829022659.23130-8-dgilbert@interlog.com>
 <201908291926.MPGuRgEm%lkp@intel.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <58567761-ab7e-b01e-6bb9-2494aca6d7c8@interlog.com>
Date:   Thu, 29 Aug 2019 11:47:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201908291926.MPGuRgEm%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-29 7:15 a.m., kbuild test robot wrote:
> Hi Douglas,
> 
> Thank you for the patch! Yet something to improve:

Hi Kbuild,
Both of us have something to improve. I should fix my code, but it
was correct before you told me to fix it last time!

The change that caused this error is on line 35 of include/uapi/scsi/sg.h:
     #include <uapi/linux/bsg.h>

which is indeed incorrect since no other header under include/uapi
has "uapi" in the path of one of its embedded includes. So the rule seems
to be that header files under the uapi directory implicitly refer to
other headers under the uapi directory when they "#include <filename>".

However the change in my code was a result of this kbuild report from
version 2 of this patchset:
    https://www.spinics.net/lists/linux-scsi/msg132432.html

And that earlier error report seems incorrect and indicates that your
build tree is misconfigured with respect to this directory:
     include/uapi/scsi/

The failure shown in msg132432.html indicates that when your tree resolved
this line in include/uapi/scsi/sg.h :
     #include <linux/bsg.h>

that it incorrectly included
     include/linux/bsg.h
instead of
     include/uapi/linux/bsg.h

If you concur and fix this issue, kindly add the following tag
Reported-by: Douglas Gilbert <dgilbert@interlog.com>


> [auto build test ERROR on linus/master]
> [cannot apply to v5.3-rc6 next-20190828]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-add-v4-interface/20190829-123646
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from <command-line>:32:0:
>>> ./usr/include/scsi/sg.h:35:10: fatal error: uapi/linux/bsg.h: No such file or directory
>      #include <uapi/linux/bsg.h>
>               ^~~~~~~~~~~~~~~~~~
>     compilation terminated.
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

