Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4183C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 11:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC47D206F6
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 11:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgGHLKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 07:10:01 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2439 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728655AbgGHLKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 07:10:01 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 9A33A5AA8555B3B14A29;
        Wed,  8 Jul 2020 12:09:59 +0100 (IST)
Received: from [127.0.0.1] (10.210.171.111) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 8 Jul 2020
 12:09:58 +0100
Subject: Re: [PATCH 10/21] snic: use reserved commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>
References: <20200703130122.111448-1-hare@suse.de>
 <20200703130122.111448-11-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <70beaba4-79a8-8449-0391-6560a0462fdb@huawei.com>
Date:   Wed, 8 Jul 2020 12:08:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-11-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.111]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:
>   	ret = scsi_add_host(shost, &pdev->dev);
>   	if (ret) {
> @@ -313,6 +314,12 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
>   		return ret;
>   	}
>   
> +	snic->shost_dev = scsi_get_host_dev(shost);
> +	if (!snic->shost_dev) {
> +		SNIC_HOST_ERR(shost,
> +			      "snic: scsi_get_virtual_dev failed\n");
> +		return -ENOMEM;
> +	}
>   	SNIC_BUG_ON(shost->work_q != NULL);
>   	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%d",
>   		 shost->host_no);

do we need scsi_free_host_dev() for error paths and teardown paths? That 
applies to fnic as well. Or is this done in the scsi_host teardown (I 
didn't check)?

> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index b3650c989ed4..8aa9ae75fe89 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -77,7 +77,7 @@ static const char * const snic_io_status_str[] = {
>   	[SNIC_STAT_FATAL_ERROR]	= "SNIC_STAT_FATAL_ERROR",
>   };
>   
> -static void snic_scsi_cleanup(struct snic *, int);
> +static void snic_scsi_cleanup(struct snic *);
>   
>   const char *
>   snic_state_to_str(unsigned int state)
> @@ -867,7 +867,6 @@ snic_process_itmf_cmpl(struct snic *snic,
>   		break;
>   

