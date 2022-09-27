Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2CDC07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiI0Cba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiI0Cb1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:31:27 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F40495AE6
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245887; x=1695781887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=maO26ivypjPINwRmECCY3/niEwSrPRX9QVMFn7Sxe24=;
  b=ARjFeRbGoD/5phvOSFreQ3v1igsn+b/2QY2pk7FkWNh0uXcp8Y7nKIhf
   XUmHFBYSmv9sa+uN25BMLLUn5C/mVKchWLvXSEDniBS7CPplbv9ljr8TZ
   HhQflLXxiTrnXSO1c7uFioxe2gQMBdEEUe9d8vMI9VjoEVAiwoOGhqf3V
   bMEimsipNkPQhkPYH/Zm6lwFlLFwju9+LQ9jRgbIuDCCxQoIim4ngCkiW
   lVoAAKvKYKOs6gYtpgu/NydFlz5M23vzztso+6yT9x+9R9GcuMxmfqD7v
   ShmzscBF219W6+Ff3ZEprtdXp5iYnVncW2Urro3jyFHqles05IJPQcmO4
   A==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="212341184"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:31:26 +0800
IronPort-SDR: 87aXfN6D9oeQJjsNd11Yk0woFX0Aoc6pnn2ZJeT6pGh2rEM4Fn8E1aq95tcJzAUnOSQOWGBtEL
 63q3xtRkgh7udtGjV3xaDwAtFgDwFOkVqGmGHvcuR/wlBc1+RW/8ZiD8r+X/YWKxAh2yCSxNXb
 VDhz/AeA1zM7xGsj4lOi4dBWH43PLhvy12BTrSpPv7quSlUxEab0Eg+eFk1310SpNHMlc3P5sZ
 zLVdYfaT3zHCdFHLxzr0Y87u9eLjjZoDI+sP4GuwjT83kcs4FuC4m3qWhCmvRLrUqzo87pjKmq
 /PmZgR7S8xm44OFyfDxEqzP8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:51:23 -0700
IronPort-SDR: L0edqQ0qx9ApbWXRgxemCczlLF1gST0yqqF7SReIEm3mI5HoKtHgbZrvz4bdfZ4CyRm81uwUBF
 VzgxWH9M/7nxrxdRK1iepPnjOeH2oCzlawf6h/9fL5diy1tZxdP7nZ9tmyTo13CVJSpx7lCXT9
 59BegKuOk1brZSkH9E6D6JdMSzND3JqFYn6PBIS5d0aK+hWW6H9ipEZLuJdIAldQ6zccNtdwcf
 qG8RbzRoi/6FcuwiV4HY7Ipy8nRg8nseN/66lLBS0gsO7+jzpScmsZcV2PNR/LBKXy7fcj9PB0
 o8c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:31:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3XY23JXz1Rwtm
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:31:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245884; x=1666837885; bh=maO26ivypjPINwRmECCY3/niEwSrPRX9QVM
        Fn7Sxe24=; b=pUqDOLF+vO6H3Bp31yGRnsz35t4STUSSNZnVMn6Vqf7JZsHQBc7
        bjXQWhAc6pAohUBUc9smzaaZrg4UmZW/UsYWALZZMua4ubbzhhLVirU9/zUY8tDz
        5H7Jvyfj+/lrkC9/DOlvc0X/z89yhKjipzTH88h1Ta3m/wUrkfVdJAy+zDidjRbT
        8BLRUM2M/14/eT67S9NfqEaBp7g5cdLDgCNhfUqzrpxYOvqpNBXlliviOge+1LDK
        ddGpoSB6kLCfmgNMLJY3+sEb6KlDpj7yDLFN1kOE3aireFE+lYS4dU1NQodUw2JZ
        jQFyQbrLlhQOBtJ6krT/DsHR0lAJeWUd7Pg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FgDGe7poV_rJ for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:31:24 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3XW1QtMz1RvLy;
        Mon, 26 Sep 2022 19:31:22 -0700 (PDT)
Message-ID: <20bbed3e-272a-0a35-c727-4b0b48d2baae@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:31:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 7/8] scsi: libsas: use sas_phy_addr_match() instead of
 open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-8-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-8-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> The sas address comparation of expander phys is open coded. Now we can
> replace it with sas_phy_addr_match().

s/comparation/comparison

All the other patches have the same typo too.

> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

With that fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_expander.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index b2b5103c3e76..f268291b7584 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2058,8 +2058,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
>  
>  			if (i == phy_id)
>  				continue;
> -			if (SAS_ADDR(phy->attached_sas_addr) ==
> -			    SAS_ADDR(changed_phy->attached_sas_addr)) {
> +			if (sas_phy_addr_match(phy, changed_phy)) {
>  				last = false;
>  				break;
>  			}

-- 
Damien Le Moal
Western Digital Research

