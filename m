Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B238DC31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 00:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0C5206A2
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 00:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfHMAV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:21:57 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39120 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfHMAV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 20:21:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B02F620419A;
        Tue, 13 Aug 2019 02:21:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O3NawSWrJCI0; Tue, 13 Aug 2019 02:21:46 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 8243D204150;
        Tue, 13 Aug 2019 02:21:45 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 07/20] sg: move header to uapi section
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        linux-spdx@vger.kernel.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-8-dgilbert@interlog.com>
 <20190812142451.GG8105@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <3814ca94-886d-b6c4-c58e-505cce9eff76@interlog.com>
Date:   Mon, 12 Aug 2019 20:21:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812142451.GG8105@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:24 a.m., Christoph Hellwig wrote:
> [note: question for the linux-spdx audience below]
> 
>> -
>>   #ifdef __KERNEL__
>>   extern int sg_big_buff; /* for sysctl */
>>   #endif
> 
> FYI, these __KERNEL__ ifdefs in non-uapi headers should go away.

Yes, that could be removed, but perhaps not yet, see below.

>> +/*
>> + * In version 3.9.01 of the sg driver, this file was spilt in two, with the
>> + * bulk of the user space interface being placed in the file being included
>> + * in the following line.
>> + */
>> +#include <uapi/scsi/sg.h>
> 
> Splitting uapi headers is standard practive, no need for the comment,
> especially not with a meaningless driver version number.

The "meaningless driver version number" is in the sg (and bsg and
generalized ioctl(SG_IO)) API via ioctl(SG_GET_VERSION_NUM). All
versions of Windows have driver version numbers. So no, one kernel
version number doesn't tell the full story. FreeBSD implements a
subset of the sg driver, and I hope to expand that. The driver version
number will be useful to differentiate the driver API there too.

My libsgutils library which is under the sg3_utils, sdparm and ddpt
packages now acts on that version number when run on Linux. When it
is between 4.0.0 and 4.0.29 then the driver API as per the end of
this patchset is assumed. If the driver version number is 4.0.30
or above the sg interface as defined here:
http://sg.danny.cz/sg/sg_v40.html  is assumed.

Also version numbers are more human friendly and convey an ordering
unlike git with its handles, for example:
   c578603bab2ec27dd6bb2d38ad4c3fc44423c570
which obviously is this patch.


That comment is a heads up to the GNU library folks who need to
be careful when the publicly visible part of an API is moved from
say include/scsi/sg.h to include/uapi/scsi/sg.h . After that move
and without that __KERNEL__ conditional then user code will break in
compilation if the former (non-uapi) header is accidentally included.
Lack of that conditional will also catch out those who include:
    /lib/modules/<kernel_version>/build/include/scsi/sg.h

Doug Gilbert

>> diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
>> new file mode 100644
>> index 000000000000..072b45bd732f
>> --- /dev/null
>> +++ b/include/uapi/scsi/sg.h
>> @@ -0,0 +1,329 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
> 
> This needs the syscall noticed for uapi headers.  FYI, what is our
> stance of just adding that notice to headers newly moved to UAPI?
> Do we need agreement from everyone who touched the file?  Or just
> after we started the split and SPDX annotations, as in this case
> this header used to be available to user programs?
> 

