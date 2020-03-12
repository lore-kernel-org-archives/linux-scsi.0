Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4BBC1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 09:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131FA206FA
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 09:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCLJZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 05:25:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgCLJZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 05:25:24 -0400
Received: from lhreml707-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id E56ACA9738624BA68024;
        Thu, 12 Mar 2020 09:25:22 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml707-cah.china.huawei.com (10.201.108.48) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 12 Mar 2020 09:25:22 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 12 Mar
 2020 09:25:22 +0000
Subject: Re: [PATCH 7/8] scsi: core: Use scnprintf() for avoiding potential
 buffer overflow
To:     Takashi Iwai <tiwai@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20200311091630.22565-1-tiwai@suse.de>
 <20200311091630.22565-8-tiwai@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3f9458e6-c00e-52c1-aa99-1a2845d13ed2@huawei.com>
Date:   Thu, 12 Mar 2020 09:25:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200311091630.22565-8-tiwai@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/03/2020 09:16, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>   drivers/scsi/scsi_sysfs.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index c3a30ba4ae08..6b3644246d3a 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1045,14 +1045,14 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
>   			name = sdev_bflags_name[i];
>   
>   		if (name)
> -			len += snprintf(buf + len, PAGE_SIZE - len,
> +			len += scnprintf(buf + len, PAGE_SIZE - len,
>   					"%s%s", len ? " " : "", name);

It would be nice to ensure that alignment with the parenthesis is maintained

Thanks

>   		else
> -			len += snprintf(buf + len, PAGE_SIZE - len,
> +			len += scnprintf(buf + len, PAGE_SIZE - len,
>   					"%sINVALID_BIT(%d)", len ? " " : "", i);
>   	}
>   	if (len)
> -		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
> +		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
>   	return len;
>   }
>   static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
> 

