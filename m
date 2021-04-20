Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35352C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E784F6100A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhDTOjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:39:53 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2890 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhDTOjv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 10:39:51 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FPmN44VYpz68Bqq;
        Tue, 20 Apr 2021 22:31:48 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 16:39:17 +0200
Received: from [10.47.91.165] (10.47.91.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Apr
 2021 15:39:16 +0100
Subject: Re: [PATCH v2] mpt3sas: Added support for shared host tagset for
 cpuhotplug
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <sathya.prakash@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>,
        <kashyap.desai@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210202095832.23072-1-sreekanth.reddy@broadcom.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <fb7eb3b5-0a2e-c94b-4eb5-a69bae810f8f@huawei.com>
Date:   Tue, 20 Apr 2021 15:36:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210202095832.23072-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.165]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/02/2021 09:58, Sreekanth Reddy wrote:
> d transport support for SAS 3.0 HBA devices */
> @@ -12028,6 +12053,21 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	} else
>   		ioc->hide_drives = 0;
>   
> +	shost->host_tagset = 0;
> +	shost->nr_hw_queues = 1;
> +
> +	if (ioc->is_gen35_ioc && ioc->reply_queue_count > 1 &&
> +	    host_tagset_enable && ioc->smp_affinity_enable) {
> +

I wanted to test host_tagset_enable feature on my LSI 3008 card (I think 
that it uses MP25 version), but is_gen35_ioc is not set there - is there 
some specific reason for which we can't support on that HW rev?

> +		shost->host_tagset = 1;
> +		shost->nr_hw_queues =
> +		    ioc->reply_queue_count - ioc->high_iops_queues;
> +
> +		dev_info(&ioc->pdev->dev,
> +		    "Max SCSIIO MPT commands: %d shared with nr_hw_queues = %d\n",
> +		    shost->can_queue, shost->nr_hw_queues);
> +	}

Thanks,
John
