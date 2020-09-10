Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92B5C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D8C2078E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgIJIgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 04:36:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2803 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730172AbgIJIfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 04:35:53 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id DE293607B043E8409500;
        Thu, 10 Sep 2020 09:35:50 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.235) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 10 Sep
 2020 09:35:49 +0100
Subject: Re: [PATCH v8 13/18] scsi: core: Show nr_hw_queues in sysfs
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-14-git-send-email-john.garry@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <7b9a1f0e-04c4-e473-0ff8-4843e0f1af34@huawei.com>
Date:   Thu, 10 Sep 2020 09:33:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1597850436-116171-14-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.235]
X-ClientProxiedBy: lhreml723-chm.china.huawei.com (10.201.108.74) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/2020 16:20, John Garry wrote:
> So that we don't use a value of 0 for when Scsi_Host.nr_hw_queues is unset,
> use the tag_set->nr_hw_queues (which holds 1 for this case).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Note that there has been no review on this patch yet.

It's not strictly necessary, but I see it as useful. The same info can 
be derived indirectly from block debugfs, but that's not always 
available (debugfs, that is).

Thanks,
john

> ---
>   drivers/scsi/scsi_sysfs.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 163dbcb741c1..d6e344fa33ad 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -393,6 +393,16 @@ show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
>   }
>   static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
>   
> +static ssize_t
> +show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct blk_mq_tag_set *tag_set = &shost->tag_set;
> +
> +	return snprintf(buf, 20, "%d\n", tag_set->nr_hw_queues);
> +}
> +static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
> +
>   static struct attribute *scsi_sysfs_shost_attrs[] = {
>   	&dev_attr_use_blk_mq.attr,
>   	&dev_attr_unique_id.attr,
> @@ -411,6 +421,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>   	&dev_attr_prot_guard_type.attr,
>   	&dev_attr_host_reset.attr,
>   	&dev_attr_eh_deadline.attr,
> +	&dev_attr_nr_hw_queues.attr,
>   	NULL
>   };
>   
> 

