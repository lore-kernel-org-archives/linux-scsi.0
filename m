Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC0BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB5A61153
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbhHSK6L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:58:11 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3675 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhHSK6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 06:58:11 -0400
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gr1sy3pY0z6BGF1;
        Thu, 19 Aug 2021 18:56:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 12:57:33 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 11:57:32 +0100
Subject: Re: [PATCH 1/4] scsi: Introduct scsi_cmd_to_tag()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Bart Van Assche" <bvanassche@acm.org>
References: <20210819084007.79233-1-hare@suse.de>
 <20210819084007.79233-2-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0613a10b-9293-38a5-41e6-a43418ce3e05@huawei.com>
Date:   Thu, 19 Aug 2021 11:57:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210819084007.79233-2-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/2021 09:40, Hannes Reinecke wrote:
> Introduce a wrapper to get the tag from a SCSI command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   include/scsi/scsi_cmnd.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index eaf04c9a1dfc..f3cc3aa0eb04 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -165,6 +165,13 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>   	return *(struct scsi_driver **)rq->rq_disk->private_data;
>   }
>   
> +static inline u32 scsi_cmd_to_tag(struct scsi_cmnd *cmd)

I'd call it scsi_cmd_to_rq_tag(), especially since scsi_cmnd.tag is 
hanging for dear life and I assume you want this helper regardless of 
what happens there, but it's just a name...

> +{
> +	struct request *rq = scsi_cmd_to_rq(cmd);
> +
> +	return rq->tag; > +}
> +
>   extern void scsi_finish_command(struct scsi_cmnd *cmd);
>   
>   extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
> 

Reviewed-by: John Garry <john.garry@huawei.com>

