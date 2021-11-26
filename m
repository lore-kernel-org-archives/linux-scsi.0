Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C11C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 09:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbhKZJix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 04:38:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4168 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhKZJgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 04:36:51 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J0qFw1mMhz67HKP;
        Fri, 26 Nov 2021 17:29:40 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 10:33:36 +0100
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:33:36 +0000
Subject: Re: [PATCH 06/15] hpsa: use scsi_host_busy_iter() to traverse
 outstanding commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Bart van Assche" <bvanassche@acm.org>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-7-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c65222e1-c489-e3f4-0688-c7ae7ac941e5@huawei.com>
Date:   Fri, 26 Nov 2021 09:33:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211125151048.103910-7-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml749-chm.china.huawei.com (10.201.108.199) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/11/2021 15:10, Hannes Reinecke wrote:
>   static void hpsa_drain_accel_commands(struct ctlr_info *h)
>   {
> -	struct CommandList *c = NULL;
> -	int i, accel_cmds_out;
> -	int refcount;
> +	struct hpsa_command_iter_data iter_data = {
> +		.h = h,
> +	};
>   
>   	do { /* wait for all outstanding ioaccel commands to drain out */
> -		accel_cmds_out = 0;
> -		for (i = 0; i < h->nr_cmds; i++) {
> -			c = h->cmd_pool + i;
> -			refcount = atomic_inc_return(&c->refcount);
> -			if (refcount > 1) /* Command is allocated */
> -				accel_cmds_out += is_accelerated_cmd(c);
> -			cmd_free(h, c);
> -		}
> -		if (accel_cmds_out <= 0)
> +		iter_data.count = 0;
> +		scsi_host_busy_iter(h->scsi_host,
> +				    hpsa_drain_accel_commands_iter,
> +				    &iter_data);

I haven't following this code exactly, but I assume that you want to 
iter the reserved requests as well (or in other places in others drivers 
in this series). For that to work we need to call 
blk_mq_start_request(), right? I could not see it called.

> +		if (iter_data.count <= 0)
>   			break;
>   		msleep(100);
>   	} while (1);
> -- 2.29.2

