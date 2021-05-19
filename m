Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441A7C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBB5613BF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 09:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbhESJku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 05:40:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3026 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhESJku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 05:40:50 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlSRM3JhkzQnGk;
        Wed, 19 May 2021 17:35:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 17:39:28 +0800
Received: from [10.47.24.60] (10.47.24.60) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 19 May
 2021 10:39:26 +0100
Subject: Re: [PATCH v2 1/3] libsas: Introduce more SAM status code aliases in
 enum exec_status
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Tom Rix <trix@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Jolly Shah" <jollys@google.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
References: <20210518175006.21308-1-bvanassche@acm.org>
 <20210518175006.21308-2-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <87680d53-6af9-81bd-88e0-fd331776d4dc@huawei.com>
Date:   Wed, 19 May 2021 10:38:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210518175006.21308-2-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.60]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/05/2021 18:50, Bart Van Assche wrote:
> index 9271d7a49b90..e68327fa4835 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -474,10 +474,16 @@ enum service_response {
>   };
>   
>   enum exec_status {
> -	/* The SAM_STAT_.. codes fit in the lower 6 bits, alias some of
> -	 * them here to silence 'case value not in enumerated type' warnings
> +	/*
> +	 * Values 0..0x7f are used to return the SAM_STAT_* codes.  To avoid
> +	 * 'case value not in enumerated type' compiler warnings every value
> +	 * returned through the exec_status enum needs an alias with the SAS_
> +	 * prefix here.
>   	 */
> -	__SAM_STAT_CHECK_CONDITION = SAM_STAT_CHECK_CONDITION,
> +	SAS_STAT_GOOD = SAM_STAT_GOOD,
> +	SAS_STAT_BUSY = SAM_STAT_BUSY,
> +	SAS_STAT_TASK_ABORTED = SAM_STAT_TASK_ABORTED,
> +	SAS_STAT_CHECK_CONDITION = SAM_STAT_CHECK_CONDITION,
>   

Personally I prefer SAS_SAM_STAT_xxx, as Christoph mentioned in v1. This 
helps us know the SAS error codes are aliased from the SAM error codes. 
And only SAS_STAT_CHECK_CONDITION becomes long, with that suggestion.

I know that you did ask about this solution in v1 series, without reply 
- sorry.

Ignoring this preference, it looks ok:
Reviewed-by: John Garry <john.garry@huawei.com>
