Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE84C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 11:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbiBQLNb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 06:13:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239762AbiBQLN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 06:13:27 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921B61E8BD1;
        Thu, 17 Feb 2022 03:13:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4kN2Gv_1645096387;
Received: from 30.225.28.137(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V4kN2Gv_1645096387)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Feb 2022 19:13:08 +0800
Message-ID: <bc301d7d-49a7-8523-0bd4-f7f2a2fbfa81@linux.alibaba.com>
Date:   Thu, 17 Feb 2022 19:13:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH 2/2] scsi:target:tcmu: reduce once copy by using uio ioctl
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Guixin Liu <kanie@linux.alibaba.com>
Cc:     bostroesser@gmail.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xlpang@linux.alibaba.com
References: <1645064962-94123-1-git-send-email-kanie@linux.alibaba.com>
 <1645064962-94123-2-git-send-email-kanie@linux.alibaba.com>
 <Yg4gL1tL7yJELNL2@kroah.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <Yg4gL1tL7yJELNL2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On Thu, Feb 17, 2022 at 10:29:22AM +0800, Guixin Liu wrote:
>> --- a/include/uapi/linux/target_core_user.h
>> +++ b/include/uapi/linux/target_core_user.h
>> @@ -185,4 +185,13 @@ enum tcmu_genl_attr {
>>   };
>>   #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
>>   
>> +struct tcmu_data_xfer {
>> +	unsigned short cmd_id;
>> +	unsigned long iov_cnt;
>> +	struct iovec __user *iovec;
>> +};
> That is no way to define a structure that crosses the user/kernel
> boundry, it just will not work at all, even if we wanted it to :(
Sorry, I don't quite understand your comments well, can you explain more 
why this structure
does not work, except that "unsigned short" or "unsigned long" here 
isn't correct, should use
u16 or u32.
Syscalls, such as readv/preadv also pass a struct iovec from user to 
kernel, thanks.


Regards,
Xiaoguang Wang
>
> sorry,
>
> greg k-h

