Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AD4C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 13:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06823224D1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 13:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGNNSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 09:18:30 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2476 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbgGNNSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 09:18:30 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 71E29A971B2DBEB6B293;
        Tue, 14 Jul 2020 14:18:28 +0100 (IST)
Received: from [127.0.0.1] (10.47.10.169) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 14 Jul
 2020 14:18:26 +0100
Subject: Re: [PATCH RFC v7 11/12] smartpqi: enable host tagset
From:   John Garry <john.garry@huawei.com>
To:     <don.brace@microsemi.com>, <hare@suse.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-12-git-send-email-john.garry@huawei.com>
Message-ID: <a8afea5c-97f2-ac84-f4b5-155963bebb2c@huawei.com>
Date:   Tue, 14 Jul 2020 14:16:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1591810159-240929-12-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.169]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

>   static struct pqi_io_request *pqi_alloc_io_request(
> -	struct pqi_ctrl_info *ctrl_info)
> +	struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
>   {
>   	struct pqi_io_request *io_request;
> +	unsigned int limit = PQI_RESERVED_IO_SLOTS;
>   	u16 i = ctrl_info->next_io_request_slot;	/* benignly racy */
>   
> -	while (1) {
> +	if (scmd) {
> +		u32 blk_tag = blk_mq_unique_tag(scmd->request);
> +
> +		i = blk_mq_unique_tag_to_tag(blk_tag) + limit;
>   		io_request = &ctrl_info->io_request_pool[i];

This looks ok

> -		if (atomic_inc_return(&io_request->refcount) == 1)
> -			break;
> -		atomic_dec(&io_request->refcount);
> -		i = (i + 1) % ctrl_info->max_io_slots;
> +		if (WARN_ON(atomic_inc_return(&io_request->refcount) > 1)) {
> +			atomic_dec(&io_request->refcount);
> +			return NULL;
> +		}
> +	} else {
> +		while (1) {
> +			io_request = &ctrl_info->io_request_pool[i];
> +			if (atomic_inc_return(&io_request->refcount) == 1)
> +				break;
> +			atomic_dec(&io_request->refcount);
> +			i = (i + 1) % limit;

To me, the range we use here looks incorrect. I would assume we should 
restrict range to [max_io_slots - PQI_RESERVED_IO_SLOTS, max_io_slots).

But then your reserved commands support would solve that.

> +		}
>   	}
>   

Thanks,
John
