Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4378C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D27622CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfIDIwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:52:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6637 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729253AbfIDIwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 04:52:18 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2555AAA41F4E4CCFDF5C;
        Wed,  4 Sep 2019 16:52:16 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Sep 2019
 16:52:07 +0800
Subject: Re: [PATCH] scsi: fcoe: fix null-ptr-deref Read in
 fc_release_transport
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>
References: <1566279789-58207-1-git-send-email-zhengbin13@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <b991ad99-baf6-97cf-fda3-cbaaf9703d3f@huawei.com>
Date:   Wed, 4 Sep 2019 16:51:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1566279789-58207-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ping

On 2019/8/20 13:43, zhengbin wrote:
> In fcoe_if_init, if fc_attach_transport(&fcoe_vport_fc_functions)
> fails, need to free the previously memory and return fail,
> otherwise will trigger null-ptr-deref Read in fc_release_transport.
>
> fcoe_exit
>   fcoe_if_exit
>     fc_release_transport(fcoe_vport_scsi_transport)
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 00dd47b..2f82e56 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1250,15 +1250,21 @@ static int __init fcoe_if_init(void)
>  	/* attach to scsi transport */
>  	fcoe_nport_scsi_transport =
>  		fc_attach_transport(&fcoe_nport_fc_functions);
> +	if (!fcoe_nport_scsi_transport)
> +		goto err;
> +
>  	fcoe_vport_scsi_transport =
>  		fc_attach_transport(&fcoe_vport_fc_functions);
> -
> -	if (!fcoe_nport_scsi_transport) {
> -		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
> -		return -ENODEV;
> -	}
> +	if (!fcoe_vport_scsi_transport)
> +		goto err_vport;
>
>  	return 0;
> +
> +err_vport:
> +	fc_release_transport(fcoe_nport_scsi_transport);
> +err:
> +	printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
> +	return -ENODEV;
>  }
>
>  /**
> --
> 2.7.4
>
>
> .
>

