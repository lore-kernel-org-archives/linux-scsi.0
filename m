Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ED8C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2CDE2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGPJ05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:26:57 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2485 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgGPJ05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jul 2020 05:26:57 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 06F15AF99CCF2B8A8616;
        Thu, 16 Jul 2020 10:26:56 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.254) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 16 Jul
 2020 10:26:55 +0100
Subject: Re: [PATCH -next] scsi: hisi_sas: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Qinglang Miao <miaoqinglang@huawei.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20200716084714.7872-1-miaoqinglang@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <801e6d49-9bd5-8079-bb83-9f67591a9158@huawei.com>
Date:   Thu, 16 Jul 2020 10:25:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200716084714.7872-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.254]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/07/2020 09:47, Qinglang Miao wrote:

Not sure why you cc Greg, but SCSI maintainers should have been - James 
and Martin

> From: Yongqiang Liu <liuyongqiang13@huawei.com>
> 
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>

The sender is not the author, so your signed-off-by should also be here 
(after sign off from Yongqiang Liu)

> ---
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 137 ++------------------------
>   1 file changed, 10 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 852d2620e..f50b0c78f 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2870,19 +2870,7 @@ static int hisi_sas_debugfs_global_show(struct seq_file *s, void *p)
>   	return 0;
>   }
>   
> -static int hisi_sas_debugfs_global_open(struct inode *inode, struct file *filp)
> -{
> -	return single_open(filp, hisi_sas_debugfs_global_show,
> -			   inode->i_private);
> -}
> -
> -static const struct file_operations hisi_sas_debugfs_global_fops = {
> -	.open = hisi_sas_debugfs_global_open,
> -	.read_iter = seq_read_iter,
> -	.llseek = seq_lseek,
> -	.release = single_release,
> -	.owner = THIS_MODULE,
> -};
> +DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_global);

I couldn't see an equivalent for file_operations which have a read and 
write method, and the driver has a few of those.

Thanks
