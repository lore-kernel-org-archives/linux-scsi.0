Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80EDC6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiI0C1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiI0C1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:27:40 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D4DAA4E7
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245659; x=1695781659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D758pODE4Rzvgl7azCFI6oT2++v17lWNbGobwyoSx90=;
  b=gISDVypE0SN/mGtZQs7rFCwOa3mb6LT5x1Y/SqBvHSTJ5MoeVlhFhrmo
   veQh4RMwj+IyKBGBSlxX3CA/DHRO5PYQhzbQDx0ALMYur8tPazKzXC7NK
   sk9yyBHwKeOPpbH5NE3HK+6+m/Pk1Fdrocjw/D+6i+1I0ctsIoKQKwIhk
   YQSmsrtmojWOH+juu5N3x/bukGKRiyaT8ZNL/CHbonDTUx1cWOIYmq+jh
   WzZAhZX2LcxD+QjqsQwbyccgZgVAhia5mlm4rN8q0moS5VrBxmKYk77GY
   399Ec8qhk8TClZTa7S3VUXvWk3e10z1AOe3iL0fvTV4Yse0wWLjhF/glm
   A==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="217515691"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:27:36 +0800
IronPort-SDR: +QjOYdZ5UrnD23QYAnGtATFymtVZyhUK8MzgiiGXAnpo9xjGlXCbmU9S/zX2lbQ3Ro8qemyl1w
 7TYEu+o6c/+ZOeuxlFWSSjb6y1Dyngez7hiddRoTT1umhDiyhOZYKRrFjz90BOqgBZpevwNVUi
 0USP64X201ebzQsdcmXtHS74/ruJ1XChd1Uekb3IOazoLxe+AJHa5xttIP4KnxzWliVpKDUmXM
 dp42EidsM6yxfLWeO3+g4s9n3jB6NJ9v0KI/3dZCEduCkhlotNGb5QgKIYCD7ywuqbfL36IgMr
 U6XKCJM8X+2rTLeQlrXLbm+z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:42:02 -0700
IronPort-SDR: PtHa2gjfm5z729J6SwXLUvAB2LpbExBhByjQ4FDkeS98YDKVwpe8zwoml+YeXNsKFA1DS0x9SQ
 XKE0Sh0xK9jlCdL7QKtAvB7a5CM0YQczCF3LhoqaBzqBqUb18Wt0Umz2F+t/ZQdqt7+wCzNwAG
 QCivPbP2fvOYPURT8C9x9movi1JIlwUYp/vXRI2PWSV6zo71oA4dqHqBmQn1Px4f6ttwRPfFwL
 1vwb07449WMbLcwJ2NUDVrLigvEzWi9QbU0cTjg8mB/ynasFDjN9Fo0OUhGkNmvFLpkiRITZ7a
 cDk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:27:36 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3S75P94z1RwvT
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:27:35 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245655; x=1666837656; bh=D758pODE4Rzvgl7azCFI6oT2++v17lWNbGo
        bwyoSx90=; b=Ps4/HGV9jjgaCQqhcLwpgU1kvjSap4SjXRshFoq7fBlOba4EU27
        gnSUjne7YEoHrVyic49CUbYMifhiMnmCuhWHhg2h/wEije1mEbncsxlKv9dTv/IN
        v5ia1aTmIKenHWLwmXBKeIdwXMb782ZRqEuf4MOzOjUiKlOi/wu6/TUXtD7/3V3J
        H43GfzJftpx7lDoEchChmXzuM18CbkB3fjuJB9h3WIpu+0lR+1N5uYMBFg52Mb+o
        1hCLxl53FCE7usynTmr828IP9Fy3o20loz+moJLVFkU46h7QkldouozmHBpCXfFZ
        CN0a39KdJritfTfDJ8S4/L/4G2QIo5IIJ1w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oNqJ7Tz9dcsh for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:27:35 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3S50V6Qz1RvLy;
        Mon, 26 Sep 2022 19:27:32 -0700 (PDT)
Message-ID: <7f557035-0f9d-d93d-ce19-a73116076497@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:27:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 4/8] scsi: mvsas: use sas_find_attached_phy() instead
 of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-5-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-5-yanaijie@huawei.com>
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
>  drivers/scsi/mvsas/mv_sas.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index a6867dae0e7c..f6576ffabe9f 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1190,23 +1190,16 @@ static int mvs_dev_found_notify(struct domain_device *dev, int lock)
>  	mvi_device->sas_device = dev;
>  	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
>  		int phy_id;
> -		u8 phy_num = parent_dev->ex_dev.num_phys;
> -		struct ex_phy *phy;
> -		for (phy_id = 0; phy_id < phy_num; phy_id++) {
> -			phy = &parent_dev->ex_dev.ex_phy[phy_id];
> -			if (SAS_ADDR(phy->attached_sas_addr) ==
> -				SAS_ADDR(dev->sas_addr)) {
> -				mvi_device->attached_phy = phy_id;
> -				break;
> -			}
> -		}
>  
> -		if (phy_id == phy_num) {
> +		phy_id = sas_find_attached_phy(&parent_dev->ex_dev, dev);
> +		if (phy_id == -ENODEV) {
>  			mv_printk("Error: no attached dev:%016llx"
>  				"at ex:%016llx.\n",
>  				SAS_ADDR(dev->sas_addr),
>  				SAS_ADDR(parent_dev->sas_addr));
>  			res = -1;

Would be nice to keep the -ENODEV error here instead of this generic, and
meaningless, "-1" code. Same for the previous patch too.

> +		} else {
> +			mvi_device->attached_phy = phy_id;
>  		}
>  	}
>  

-- 
Damien Le Moal
Western Digital Research

