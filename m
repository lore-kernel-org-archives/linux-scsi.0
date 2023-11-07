Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A540DC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Nov 2023 04:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjKGER0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 23:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjKGERZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 23:17:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF2DED;
        Mon,  6 Nov 2023 20:17:20 -0800 (PST)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SPZbd4q3pzrTy6;
        Tue,  7 Nov 2023 12:14:05 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 7 Nov 2023 12:17:07 +0800
Message-ID: <29114526-7854-ca44-fa30-cb9a5090d9d2@huawei.com>
Date:   Tue, 7 Nov 2023 12:17:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 1/2] scsi: scsi_debug: scsi: scsi_debug: fix some bugs
 in sdebug_error_write()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        <linux-scsi@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <7733643d-e102-4581-8d29-769472011c97@moroto.mountain>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <7733643d-e102-4581-8d29-769472011c97@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/11/6 22:04, Dan Carpenter wrote:
> There are two bug in this code:
> 1) If count is zero, then it will lead to a NULL dereference.  The
>     kmalloc() will successfully allocate zero bytes and the test for
>     "if (buf[0] == '-')" will read beyond the end of the zero size buffer
>     and Oops.
> 2) The code does not ensure that the user's string is properly NUL
>     terminated which could lead to a read overflow.
> 
> Fixes: a9996d722b11 ("scsi: scsi_debug: Add interface to manage error injection for a single device")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> v2: At first I tried to use strndup_user() but that only accepts NUL
>      terminated strings and the user string is normally not terminated.
> 
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 67922e2c4c19..0dd21598f7b6 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1019,7 +1019,7 @@ static ssize_t sdebug_error_write(struct file *file, const char __user *ubuf,
>   	struct sdebug_err_inject *inject;
>   	struct scsi_device *sdev = (struct scsi_device *)file->f_inode->i_private;
>   
> -	buf = kmalloc(count, GFP_KERNEL);
> +	buf = kzalloc(count + 1, GFP_KERNEL);
>   	if (!buf)
>   		return -ENOMEM;
>   
Looks good,

Reviewed-by: Wenchao Hao <haowenchao2@huawei.com>
