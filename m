Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47FFC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C1920704
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgGQH4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:56:11 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbgGQH4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 03:56:11 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 5B32DF424CF03846E4F6;
        Fri, 17 Jul 2020 08:56:09 +0100 (IST)
Received: from [127.0.0.1] (10.210.167.164) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 17 Jul
 2020 08:56:08 +0100
Subject: Re: [PATCH] [SCSI] libsas: add missing newline when printing 'enable'
 by sysfs
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
References: <1594971374-40210-1-git-send-email-wangxiongfeng2@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <648c18d0-cc0a-f444-e774-e0938f697e90@huawei.com>
Date:   Fri, 17 Jul 2020 08:54:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1594971374-40210-1-git-send-email-wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.167.164]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/07/2020 08:36, Xiongfeng Wang wrote:

Hi,

I think "scsi: scsi_transport_sas: " would be a better subject prefix, 
as this is not libsas code.

> When I cat sysfs file 'enable' below 'sas_phy', it displays as follows.
> It's better to add a newline for easy reading.
> 
> [root@localhost ~]# cat /sys/devices/pci0000:00/0000:00:0d.0/0000:0f:00.0/host3/phy-3:2/sas_phy/phy-3:2/enable
> 1[root@localhost ~]#
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>

Apart from above,
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/scsi_transport_sas.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 182fd25..e443dee 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -563,7 +563,7 @@ static ssize_t do_sas_phy_enable(struct device *dev,
>   {
>   	struct sas_phy *phy = transport_class_to_phy(dev);
>   
> -	return snprintf(buf, 20, "%d", phy->enabled);
> +	return snprintf(buf, 20, "%d\n", phy->enabled);
>   }
>   
>   static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR, show_sas_phy_enable,
> 

