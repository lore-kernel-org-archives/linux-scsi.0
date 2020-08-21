Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC98C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 11:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BE420738
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 11:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgHULDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 07:03:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10298 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgHULDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 07:03:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 87620D27DD56F785ED2B;
        Fri, 21 Aug 2020 19:03:32 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 21 Aug 2020
 19:03:31 +0800
Subject: Re: [PATCH v2] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20200818114235.51052-1-yuehaibing@huawei.com>
 <20200819020546.59172-1-yuehaibing@huawei.com>
 <yq1ft8gvje1.fsf@ca-mkp.ca.oracle.com>
CC:     <hare@suse.de>, <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <97fe2241-b814-d756-5e46-3c6bbca5bb76@huawei.com>
Date:   Fri, 21 Aug 2020 19:03:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <yq1ft8gvje1.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/8/21 10:21, Martin K. Petersen wrote:
> 
> YueHaibing,
> 
>> diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
>> index d8cbc9c0e766..574e842cefed 100644
>> --- a/drivers/scsi/libfc/fc_disc.c
>> +++ b/drivers/scsi/libfc/fc_disc.c
>> @@ -302,7 +302,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
>>  	unsigned long delay = 0;
>>  
>>  	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
>> -		    PTR_ERR(fp), disc->retry_count,
>> +		    IS_ERR(fp) ? PTR_ERR(fp) : 0, disc->retry_count,
>>  		    FC_DISC_RETRY_LIMIT);
>>  
>>  	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
> 
> Why not PTR_ERR_OR_ZERO()?

Thanks, will respin.
> 

