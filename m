Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFD8C33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 09:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CBDA2187F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 09:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgANJQa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 04:16:30 -0500
Received: from smtp.infotech.no ([82.134.31.41]:58755 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgANJQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 04:16:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4A4DC2041C0;
        Tue, 14 Jan 2020 10:16:27 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oDhR2PIkz+Yy; Tue, 14 Jan 2020 10:16:27 +0100 (CET)
Received: from [82.134.31.177] (unknown [82.134.31.177])
        by smtp.infotech.no (Postfix) with ESMTPA id 29DF7204188;
        Tue, 14 Jan 2020 10:16:27 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v6 07/37] sg: move header to uapi section
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Hannes Reinecke <hare@suse.com>
References: <20200112235755.14197-8-dgilbert@interlog.com>
 <202001131301.p9xuUbaz%lkp@intel.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <a83b4b1b-ff1d-d3b0-46bf-cdc012d369d6@interlog.com>
Date:   Tue, 14 Jan 2020 10:16:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202001131301.p9xuUbaz%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-13 6:34 a.m., kbuild test robot wrote:
> Hi Douglas,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on linus/master v5.5-rc5]
> [cannot apply to mkp-scsi/for-next next-20200110]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-add-v4-interface/20200113-080059
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: x86_64-randconfig-d003-20200112 (attached as .config)
> compiler: gcc-7 (Debian 7.5.0-3) 7.5.0
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
>>> ./usr/include/scsi/sg.h:44:2: error: unknown type name 'size_t'
>       size_t iov_len;  /* Length in bytes */
>       ^~~~~~

That patch never touched "./usr/include/scsi/sg.h" but the error line
does correspond with include/uapi/scsi/sg.h . That file does include
<linux/types.h> on line 31 which should take care of defining size_t
within the kernel.

But is this a user space compilation check? According to cppreference.com
for C size_t is defined in:
   Defined in header <stddef.h>
   Defined in header <stdio.h>
   Defined in header <stdlib.h>
   Defined in header <string.h>
   Defined in header <time.h>
   Defined in header <uchar.h>  (since C11)
   Defined in header <wchar.h>  (since C95)

So is a solution to include <stddef.h> ? Or should <linux/types.h> do
that if it only conditionally defines size_t ? Or am I on the wrong
track?

Doug Gilbert

