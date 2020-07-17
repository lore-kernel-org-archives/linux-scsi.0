Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6811C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 02:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC1C20838
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 02:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgGQCRQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 22:17:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbgGQCRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jul 2020 22:17:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5777E2397207D260FF2C;
        Fri, 17 Jul 2020 10:17:12 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.91) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 10:17:02 +0800
Subject: Re: [PATCH -next] scsi: hisi_sas: Convert to DEFINE_SHOW_ATTRIBUTE
To:     luojiaxing <luojiaxing@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Garry <john.garry@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200716084714.7872-1-miaoqinglang@huawei.com>
 <c3bc1f66-2eae-1f9b-58bf-7eacb25739e1@huawei.com>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <a02d6696-f23c-08d0-d29c-0cb136c63835@huawei.com>
Date:   Fri, 17 Jul 2020 10:17:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c3bc1f66-2eae-1f9b-58bf-7eacb25739e1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/7/16 20:39, luojiaxing 写道:
> Hi, Qinglang
> 
> On 2020/7/16 16:47, Qinglang Miao wrote:
>> From: Yongqiang Liu <liuyongqiang13@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
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
>> -static int hisi_sas_debugfs_global_open(struct inode *inode, struct 
>> file *filp)
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
> 
> 
> I saw that your code is different from code in kernel 5.8-rc4, and it 
> should be as follow:
> 
> static const struct file_operations hisi_sas_debugfs_global_fops = {
>      .open = hisi_sas_debugfs_global_open,
>      .read = seq_read,
>      .llseek = seq_lseek,
>      .release = single_release,
>      .owner = THIS_MODULE,
> };
> 
Sorry I didn't mention it in commit log, but this patch is based on 
linux-next where commit <4d4901c6d7> has switched over direct  seq_read 
method calls to seq_read_iter. I can send a new patch based on  v5.8-rc 
if you don't mind.
> 
> Plus, if we use this macro directly when we write this code, it really 
> makes the code simpler. But if we accept the cleanup now,
> 
> we might need to consider evading compilation failures when we merge 
> these code back to some older kernel (e.g kernel 4.14 for centOS 7.6).
> 
> I think this marco is introduced into kernel 4.16-rc2.
> 
Yes, you're right, the macro and commit <4d4901c6d7> need to be  applied 
before this clean up patch. But I don't think this patch as well as 
commit<4d4901c6d7> need to be merged back to older kernel.
> 
> So I don't see much additional benefit to us from this simplification. 
> But this marco is quite helpful and I think I will use it somewhere else.
> 
> Thanks
> 
> Jiaxing
> 
Glad to know your opnions.

Thanks.
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_global);
>>   static int hisi_sas_debugfs_axi_show(struct seq_file *s, void *p)
>>   {
>> @@ -2897,19 +2885,7 @@ static int hisi_sas_debugfs_axi_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_axi_open(struct inode *inode, struct file 
>> *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_axi_show,
>> -               inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_axi_fops = {
>> -    .open = hisi_sas_debugfs_axi_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_axi);
>>   static int hisi_sas_debugfs_ras_show(struct seq_file *s, void *p)
>>   {
>> @@ -2924,19 +2900,7 @@ static int hisi_sas_debugfs_ras_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_ras_open(struct inode *inode, struct file 
>> *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_ras_show,
>> -               inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_ras_fops = {
>> -    .open = hisi_sas_debugfs_ras_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_ras);
>>   static int hisi_sas_debugfs_port_show(struct seq_file *s, void *p)
>>   {
>> @@ -2951,18 +2915,7 @@ static int hisi_sas_debugfs_port_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_port_open(struct inode *inode, struct 
>> file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_port_show, 
>> inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_port_fops = {
>> -    .open = hisi_sas_debugfs_port_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_port);
>>   static void hisi_sas_show_row_64(struct seq_file *s, int index,
>>                    int sz, __le64 *ptr)
>> @@ -3019,18 +2972,7 @@ static int hisi_sas_debugfs_cq_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_cq_open(struct inode *inode, struct file 
>> *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_cq_show, 
>> inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_cq_fops = {
>> -    .open = hisi_sas_debugfs_cq_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_cq);
>>   static void hisi_sas_dq_show_slot(struct seq_file *s, int slot, void 
>> *dq_ptr)
>>   {
>> @@ -3052,18 +2994,7 @@ static int hisi_sas_debugfs_dq_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_dq_open(struct inode *inode, struct file 
>> *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_dq_show, 
>> inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_dq_fops = {
>> -    .open = hisi_sas_debugfs_dq_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_dq);
>>   static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
>>   {
>> @@ -3080,18 +3011,7 @@ static int hisi_sas_debugfs_iost_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_iost_open(struct inode *inode, struct 
>> file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_iost_show, 
>> inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_iost_fops = {
>> -    .open = hisi_sas_debugfs_iost_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_iost);
>>   static int hisi_sas_debugfs_iost_cache_show(struct seq_file *s, void 
>> *p)
>>   {
>> @@ -3117,20 +3037,7 @@ static int 
>> hisi_sas_debugfs_iost_cache_show(struct seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_iost_cache_open(struct inode *inode,
>> -                        struct file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_iost_cache_show,
>> -               inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_iost_cache_fops = {
>> -    .open = hisi_sas_debugfs_iost_cache_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_iost_cache);
>>   static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
>>   {
>> @@ -3147,18 +3054,7 @@ static int hisi_sas_debugfs_itct_show(struct 
>> seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_itct_open(struct inode *inode, struct 
>> file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_itct_show, 
>> inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_itct_fops = {
>> -    .open = hisi_sas_debugfs_itct_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_itct);
>>   static int hisi_sas_debugfs_itct_cache_show(struct seq_file *s, void 
>> *p)
>>   {
>> @@ -3184,20 +3080,7 @@ static int 
>> hisi_sas_debugfs_itct_cache_show(struct seq_file *s, void *p)
>>       return 0;
>>   }
>> -static int hisi_sas_debugfs_itct_cache_open(struct inode *inode,
>> -                        struct file *filp)
>> -{
>> -    return single_open(filp, hisi_sas_debugfs_itct_cache_show,
>> -               inode->i_private);
>> -}
>> -
>> -static const struct file_operations hisi_sas_debugfs_itct_cache_fops = {
>> -    .open = hisi_sas_debugfs_itct_cache_open,
>> -    .read_iter = seq_read_iter,
>> -    .llseek = seq_lseek,
>> -    .release = single_release,
>> -    .owner = THIS_MODULE,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_itct_cache);
>>   static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
>>   {
> 
> .

