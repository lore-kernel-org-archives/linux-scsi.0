Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B21BC04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 07:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbiI1HCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 03:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiI1HCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 03:02:37 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679DBB02B6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 00:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664348549; x=1695884549;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qOEW5f8ioGdKEGmbuw9N3Q7nWNbHA0O8JWBj8guvtZQ=;
  b=Ckw9sTwGevr+Vav3csa0Wh3V3gm7txS3WMMCtN0ryqJtFWOUAdz/0ypX
   QoC7ltPWAC8o/ZMTOtnbViW/tQ7NvqwNSLlgVenoI5xWh87kuzRS2DkRh
   dN5gYM668fSfndJW1lSB8JdBJ8JfE91UinRU+tD3PgcXp0KLBL+21V0lY
   5N7wj4laAwCVjZEzBlBAR9ku3eS8uYNzlIVVGylKBXxZiW6oMLPMtKycz
   aQmZ09vJ12vksXZiIfPbFnivHQOPr5EeW30n8sOUkIWo/XjDr46yMPL5D
   O2Kkg/EBK3JA51ipewX6fVhBWkPwl6IMmc5+9Bm/b7ccrf9DRq0H9h/26
   w==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654531200"; 
   d="scan'208";a="217642621"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2022 15:02:25 +0800
IronPort-SDR: Ro1yWhvjoVqIruuj/LEv65uY1UXvHui/g4BxuNBQJ8WOXQKAAJ7Iw6DqClOAX2B5QDabAdkbU2
 8C4cvfdH2goWlVWcwVfzcbxOw8bXub5fA0FRXVzGuMAn6aKcr1zgu3mwWsOmifXdP0XViGPodh
 p7OGg7ZNm3Zgd8iWIOFveolTtfIREtuIq+x/NSxrjFub3Tv+LXm2FhFL11AcXkvg0l46W9D+RL
 nQeGh6Co/Ky91xux10nlEXtezBAa8BPtDY3MctHbpUCBYBYjxIdLN0q4pY6BL/wbjvz6uvfgJ4
 BmDzegLfPw/xM+Ha0pX3RFnw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 23:16:49 -0700
IronPort-SDR: ZFqbSzP6EVHQ/MSJ+TI8Jv/IUILwwTeKTwoEccOedCVoototptqro5U6DsVlZejE1PYUP9if7q
 rnSnshdoi8rWYBcqJVcF/KsZp7zPaiuEjPOXrpeZEeQkd7phMGG+d+dFexRHDc497lCTiGPBoS
 6v57Wy6/xiVBpdIZjll21CAJkx5hA1uU6OJwXg3MTy4N4iTXVQWEDFboiGLbb5wx1kUQzxB3Ng
 hgCfi1pjcFunXs1Vt2MNJ9G5YNRe1TkZrONFyxWLC00X35oEIM1lQQMle/T90zsk8zFQd+jSDe
 3TQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 00:02:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McnVn02v4z1Rwtm
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 00:02:24 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664348544; x=1666940545; bh=qOEW5f8ioGdKEGmbuw9N3Q7nWNbHA0O8JWB
        j8guvtZQ=; b=ATjCGLQOJlxI0DE3dotUOlFGytsjJ81/2B8H1gmKwJFHH74BjxX
        AgFONfzJFyuoXw1chT41K1kkfVKD1AjDWC+TMru6/HsXyPIt2sKagOGBiC5l8v9L
        g8MAZme+A5kmR3l5rUG0Y1MlzMy2ajgwOIiML8YDV/QFUvTA0XX00PG3a1hR1PCr
        oQ+M85Wr0zzmm2OzS/bBtWyfL/lHrWofqbRDhNWdRGx7yi4YzfSWdd039hdqtKi2
        wITRws1CXGkX2bS5DoXE8W91yA1CiIGuYA789UbVXSc33wAsclofGE2KWITRn8Cg
        GDLKWUadu8NBNsWCCjGsFVBk1Whop+81fPQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cqjfIiQ0BGxi for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 00:02:24 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McnVk33Jbz1RvLy;
        Wed, 28 Sep 2022 00:02:22 -0700 (PDT)
Message-ID: <e3bfbe7e-baee-9f4a-7d55-c6dc27e3eba1@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 16:02:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 3/8] scsi: pm8001: use sas_find_attached_phy_id()
 instead of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220928070130.3657183-1-yanaijie@huawei.com>
 <20220928070130.3657183-4-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220928070130.3657183-4-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 16:01, Jason Yan wrote:
> The attached phy id finding is open coded. Now we can replace it with
> sas_find_attached_phy_id(). To keep consistent, the return value of
> pm8001_dev_found_notify() is also changed to -ENODEV after calling
> sas_find_attathed_phy_id() failed.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Looks good.

Note for future patches: if you change a patch, it needs to be reviewed
again. So please drop any review tag from the patch commit message to make
that clear.

> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 8e3f2f9ddaac..b4007c4f157d 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -645,22 +645,16 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
>  	pm8001_device->dcompletion = &completion;
>  	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
>  		int phy_id;
> -		struct ex_phy *phy;
> -		for (phy_id = 0; phy_id < parent_dev->ex_dev.num_phys;
> -		phy_id++) {
> -			phy = &parent_dev->ex_dev.ex_phy[phy_id];
> -			if (SAS_ADDR(phy->attached_sas_addr)
> -				== SAS_ADDR(dev->sas_addr)) {
> -				pm8001_device->attached_phy = phy_id;
> -				break;
> -			}
> -		}
> -		if (phy_id == parent_dev->ex_dev.num_phys) {
> +
> +		phy_id = sas_find_attached_phy_id(&parent_dev->ex_dev, dev);
> +		if (phy_id < 0) {
>  			pm8001_dbg(pm8001_ha, FAIL,
>  				   "Error: no attached dev:%016llx at ex:%016llx.\n",
>  				   SAS_ADDR(dev->sas_addr),
>  				   SAS_ADDR(parent_dev->sas_addr));
> -			res = -1;
> +			res = phy_id;
> +		} else {
> +			pm8001_device->attached_phy = phy_id;
>  		}
>  	} else {
>  		if (dev->dev_type == SAS_SATA_DEV) {

-- 
Damien Le Moal
Western Digital Research

