Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E4ECA9EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 02:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02C7520679
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 02:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408293AbfJXCrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 22:47:16 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53471 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406591AbfJXCrQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 22:47:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9E17F204197;
        Thu, 24 Oct 2019 04:47:13 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cdu34Sz1H51N; Thu, 24 Oct 2019 04:47:08 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id CAEAC20415B;
        Thu, 24 Oct 2019 04:47:06 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v5 13/23] sg: ioctl handling
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20191008075022.30055-1-dgilbert@interlog.com>
 <20191008075022.30055-14-dgilbert@interlog.com>
 <dbb1089b-dc56-7e6d-e969-6b0f8c9fd167@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <26687707-445a-374f-d2af-84a0d13d64dc@interlog.com>
Date:   Wed, 23 Oct 2019 22:47:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <dbb1089b-dc56-7e6d-e969-6b0f8c9fd167@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-18 6:12 a.m., Hannes Reinecke wrote:
> On 10/8/19 9:50 AM, Douglas Gilbert wrote:
>> Shorten sg_ioctl() by adding some helper functions. sg_ioctl()
>> is the main entry point for ioctls used on this driver's
>> devices.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 325 ++++++++++++++++++++++++++++------------------
>>   1 file changed, 200 insertions(+), 125 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 2796fef42837..90753f7759c7 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -72,6 +72,9 @@ static char *sg_version_date = "20190606";
>>    */
>>   #define SG_MAX_CDB_SIZE 252
>>   
>> +#define uptr64(val) ((void __user *)(uintptr_t)(val))
>> +#define cuptr64(val) ((const void __user *)(uintptr_t)(val))
>> +
>>   #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
>>   
>>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
> 
> These defines are used only once; I'd rather drop them and do the
> conversion in-place.

Okay, I'll take them out. And they will go back in in patch 28
as their main use is to handle the way the sg v4 interface
send pointers through 64 bit integers. The first one should be
familiar to anyone who has worked on block/bsg.h .

Doug Gilbert
