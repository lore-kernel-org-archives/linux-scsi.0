Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85F9C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 13:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D64720739
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 13:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgGPNE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:04:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40934 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728119AbgGPNE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jul 2020 09:04:29 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F3C45DF5121E4CB53979;
        Thu, 16 Jul 2020 21:04:24 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.91) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Jul 2020
 21:04:08 +0800
Subject: Re: [PATCH -next] scsi: hisi_sas: Convert to DEFINE_SHOW_ATTRIBUTE
To:     John Garry <john.garry@huawei.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20200716084714.7872-1-miaoqinglang@huawei.com>
 <801e6d49-9bd5-8079-bb83-9f67591a9158@huawei.com>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <98e26dfe-b6f9-5730-097e-95ff2db5c987@huawei.com>
Date:   Thu, 16 Jul 2020 21:04:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <801e6d49-9bd5-8079-bb83-9f67591a9158@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2020/7/16 17:25, John Garry 写道:
> On 16/07/2020 09:47, Qinglang Miao wrote:
>
> Not sure why you cc Greg, but SCSI maintainers should have been - 
> James and Martin
>
>> From: Yongqiang Liu <liuyongqiang13@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
>
> The sender is not the author, so your signed-off-by should also be 
> here (after sign off from Yongqiang Liu)
>
Sorry for not knowing this rule, I will send a new patch later on if you 
don't mind.
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_main.c | 137 ++------------------------
>>   1 file changed, 10 insertions(+), 127 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> index 852d2620e..f50b0c78f 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> @@ -2870,19 +2870,7 @@ static int hisi_sas_debugfs_global_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>>   -static int hisi_sas_debugfs_global_open(struct inode *inode, 
>> struct file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_global_show,
>> -               inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_global_fops = {
>> -    .open = hisi_sas_debugfs_global_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_global);
>
> I couldn't see an equivalent for file_operations which have a read and 
> write method, and the driver has a few of those.
Yes, you're right. There's no equivalence when drivers have read and  
write method. So the file_operations we cleaned up are those without  
write method, like hisi_sas_debugfs_global_fops.
>
> Thanks
> .
Thanks
  .

