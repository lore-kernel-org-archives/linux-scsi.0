Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C476C001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 01:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjGTBx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGTBx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 21:53:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F6A1FF3;
        Wed, 19 Jul 2023 18:53:23 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R5wfP3kWczVjkc;
        Thu, 20 Jul 2023 09:51:57 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 09:53:21 +0800
Subject: Re: [PATCH v2 5/8] ata: inline ata_port_probe()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-6-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <e30662f3-a515-f24d-729d-d7b7a285e8ab@huawei.com>
Date:   Thu, 20 Jul 2023 09:53:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230720004257.307031-6-nks@flawful.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/7/20 8:42, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Just used in one place.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-core.c | 11 ++---------
>   1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 1f0306522649..c5e93e1a560d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5884,14 +5884,6 @@ void __ata_port_probe(struct ata_port *ap)
>   	spin_unlock_irqrestore(ap->lock, flags);
>   }
>   
> -int ata_port_probe(struct ata_port *ap)
> -{
> -	__ata_port_probe(ap);
> -	ata_port_wait_eh(ap);
> -	return 0;
> -}
> -
> -
>   static void async_port_probe(void *data, async_cookie_t cookie)
>   {
>   	struct ata_port *ap = data;
> @@ -5906,7 +5898,8 @@ static void async_port_probe(void *data, async_cookie_t cookie)
>   	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
>   		async_synchronize_cookie(cookie);
>   
> -	(void)ata_port_probe(ap);
> +	__ata_port_probe(ap);
> +	ata_port_wait_eh(ap);
>   
>   	/* in order to keep device order, we need to synchronize at this point */
>   	async_synchronize_cookie(cookie);
> 

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
Jason
