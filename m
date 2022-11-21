Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1250FC43217
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 14:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiKUO2h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 09:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKUO2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 09:28:36 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7635800B;
        Mon, 21 Nov 2022 06:28:35 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NG8r41wqLz15Mnk;
        Mon, 21 Nov 2022 22:28:04 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 22:28:32 +0800
Subject: Re:
To:     Denis Arefev <arefev@swemel.ru>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>
CC:     Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <trufanov@swemel.ru>, <vfh@swemel.ru>
References: <20221121111104.7186-1-arefev@swemel.ru>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <7819ba3e-e434-80e7-7681-29791843c94d@huawei.com>
Date:   Mon, 21 Nov 2022 22:28:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20221121111104.7186-1-arefev@swemel.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

You may need a real subject, not a subject text in the email.

type "git help send-email" if you don't know how to use it.

On 2022/11/21 19:11, Denis Arefev wrote:
> Date: Mon, 21 Nov 2022 13:29:03 +0300
> Subject: [PATCH] scsi:bfa: Eliminated buffer overflow
> 
> Buffer 'cmd->adapter_hwpath' of size 32 accessed at
> bfad_bsg.c:101:103 can overflow, since its index 'i'
> can have value 32 that is out of range.
> 
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
> ---
>   drivers/scsi/bfa/bfad_bsg.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
> index be8dfbe13e90..78615ffc62ef 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -98,9 +98,9 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, void *cmd)
>   
>   	/* set adapter hw path */
>   	strcpy(iocmd->adapter_hwpath, bfad->pci_name);
> -	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
> +	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32-2; i++)
>   		;
> -	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32; )
> +	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32-1; )
>   		;
>   	iocmd->adapter_hwpath[i] = '\0';
>   	iocmd->status = BFA_STATUS_OK;
> 
