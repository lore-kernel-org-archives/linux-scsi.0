Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB00C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiI0C2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiI0C2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:28:12 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F2DAB19A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245690; x=1695781690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dtpZvmFtYIdkdXBy+L2NjqNKdBMsA002GGQLmcuex7k=;
  b=D7w08nDTJBMuGPgZeYfOJi/r6QHqZquFPtYuFw598bnY0icBv84gL61i
   THkJnHoa6bJWHggG4i5IqCxjRgXqxkiyM3zA/c/FVtkXqfuc8vkQS8YMU
   /KGHOZcWZwTdsGcJk9Qvzgy5b8FTSwQ4BUE28KP0/LlotP5Uf11TDgm+f
   N+lYvgYjI0Tbf9k6pPR5ZhAjgFDrcjxBjVb8Z3qz3Cha1NdOkNY6vTU+N
   ZkD0b0Z9Imx8ZTa70bwNCWbgOfBDIoAA2tdLVQ/Mzpxx/3LoMHPJL3Wj5
   64eJ+MsZPzzqq1IRnXiD7P9O3MTau8lRbShQlJ+VBsWTERGi7M4Tb+tBm
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="210704773"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:28:09 +0800
IronPort-SDR: 0rk6mmc4rYfcJxwddU3oVnuuZxGs4R8CferuQDAgI4CA0u9/Xxp9LoMIaax3sbmRc1reIYmD1F
 ESvqnGk319oK6P1umlv5x9bmY/IitvjlgjkBbGclTzgumB7/VKeReFs96huq3Kn12Q3zAbcr+C
 cppeWdKUTKYIIv9XhA9uJ+z1DpQmZkFbE+H1CbEAgbs8P2X9a0+u9M5K6gHYhNXr//lhx6DR3r
 qDYgJ2DXAukZ5oe3ivtpDjLCb/OYGXNqI1AZsFfezlvxmCro0TDWZTaZeuR1kpWAUmaZHQGPJk
 kO6c0J74RKChgjZWwOGcJsEi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:42:35 -0700
IronPort-SDR: SNPDAJ2p6kQhciwwky9bfZ5jSH4Oo1LUgtPNLgY75Hzpa0tYypmeGSxQc4ORg9DGsRVO7fPoit
 0G3qlP6qlvOWE7jCd/48YMcSasXLSvZ9vjykpji1Ypl5fPv5A8QFuj/nImzUrGokh3Xazk3Xda
 DC92x2skY9ffB8F9LvE0aXK/Vq4OIGf6z/PyJn9RH/ye8C5sJdrHhM34qj5Q+kxGjkKPBY8aP5
 U1JqcC+bbKIrbyvYMKua4PuSABlehM3GN5bdNzsHgeTSMZxGEaHnOXCsc5WGvWMmfUa9hK0w/n
 lRc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:28:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3Sm620Fz1RvTp
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:28:08 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245688; x=1666837689; bh=dtpZvmFtYIdkdXBy+L2NjqNKdBMsA002GGQ
        Lmcuex7k=; b=X8DFloejAxpZb/j/MJILnW0ULQSpx1imZ2DWIwvFLnRss1+3hO3
        1EyzSguoUXVjC2Kg6FHEVJCzFLYOoYjnL8jxC5aV57cek8LTm85DL8t5GkPkoKG5
        05LTnfA7XJNynWun3VpQm6PzlpjsyFWKELTmjgIlsmvaAJNVHtHjZnvXevIBShtM
        piYkmJ7mrJXwSd0l5TFhnobgXEgU1NlUGWBiHcMny4phMQOi1Dr1f6TCqpZlktNl
        iSz57FsIaQ5V9pE0b1vjaV6dihWIVLhnEyt8hDyoDMuTuxEkDv6VMwZ/5oIY2c4J
        IdlOKTPlEQYZ94ifG5AAHH0hI7QPczVf+PQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fRurg9GwC473 for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:28:08 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3Sk4BF5z1RvLy;
        Mon, 26 Sep 2022 19:28:06 -0700 (PDT)
Message-ID: <6654484e-70ce-d34f-ec48-44b0eb2bd0a5@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:28:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 5/8] scsi: hisi_sas: use sas_find_attathed_phy()
 instead of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-6-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-6-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> The attached phy finding is open coded. Now we can replace it with
> sas_find_attached_phy().
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Jack Wang <jinpu.wang@ionos.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 33af5b8dede2..995ccb13fb9d 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -792,17 +792,9 @@ static int hisi_sas_dev_found(struct domain_device *device)
>  
>  	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
>  		int phy_no;
> -		u8 phy_num = parent_dev->ex_dev.num_phys;
> -		struct ex_phy *phy;
>  
> -		for (phy_no = 0; phy_no < phy_num; phy_no++) {
> -			phy = &parent_dev->ex_dev.ex_phy[phy_no];
> -			if (SAS_ADDR(phy->attached_sas_addr) ==
> -				SAS_ADDR(device->sas_addr))
> -				break;
> -		}
> -
> -		if (phy_no == phy_num) {
> +		phy_no = sas_find_attached_phy(&parent_dev->ex_dev, device);
> +		if (phy_no == -ENODEV) {
>  			dev_info(dev, "dev found: no attached "
>  				 "dev:%016llx at ex:%016llx\n",
>  				 SAS_ADDR(device->sas_addr),

-- 
Damien Le Moal
Western Digital Research

