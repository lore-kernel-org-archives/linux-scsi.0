Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FA1C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiI0CZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiI0CZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:25:39 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533B7A3D5C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245538; x=1695781538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lrg6l/pPX8i1bKBhQiAAkehXiG0KnY79HU2FjMsqfDU=;
  b=NZmPTTlvXMf7osHdfYO9uO0mMnG0DKwdt295aQ4OWpSj36XyRRCUYgZ7
   iKN9BzR33UtUJkIgeFZC0aSKVE5XacZyAnujLfdb8q5aZtSdmzV7Wgc24
   yCsyqPyYFaL/aICwpNz1AI+cJzi1rZob25eFvtB73ICbEbHAGg0NIpjZf
   CofoAQzSQcbX5H/qYzxsa+Zu3gNq1/+zrPv0DHjufxSDp+Yb1ko3Fi3mX
   xJi8Vb2Zc5vg2yc2j38YE+c3tg7UWTQC8RYh2ks0H9U8LbNh79RxGNSlI
   MULHmjsHABbe7qz7PFM/xvSD3mq7kv9yO0ZDNxXTaypTfLT8uR5SCi+qv
   A==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="316620404"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:25:32 +0800
IronPort-SDR: rp2yaI9ASGx/gvd0J0I4TskH+qYUZRIGvclhSSSLCJNc0yZuXDCsTJXSwRE3fIGm31f2n32nKr
 MRd8PwUcrKuPFjSkYYSXIrWYkFsZ3E20gKIw0ro/wB47RgqquXsk8IYfL699P5xUmaa97TFHpw
 c296gDzXSG3dfggkSaz3gmZdJUyDl+taA4qRtPET3ICupngJi/V8AXHnwU6vGcl/XhQoTaxqE6
 UI5SvamGq//pV41zd0wlOPPGXwgQd+71lXnVaAKrMEVBL1tILcmrnCNnBdh9j692j8u9rDTqu9
 OteJnJ4iU0phgqQFtkRIETpk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:45:29 -0700
IronPort-SDR: gEDan2ATSxm91pFhxbSH969+lmHGx3R/3142XPpiXaL1sJ+ocK1K88uWm3tMunrZFVrfV3YGgA
 xWiFGldGBkLsoJOD3a0ocWWmQGTXHVz7f7H6De+tkrR1aCq32eYm1fsgmbvDQe2beJdYIb1N++
 RmjRCYOZ5mWkOShwcokCrPsf+IO60O7EyKDWbKTyNHFrqF8BXIk/ULlJIJZeMlYbx94uuAqi18
 YKTH7IOO1wr45n6bJV3jrlqtSJemGuAiajbDvANKnvgaC+HkuZfI4gE4I7LuxRIwQZ2YEZL4G4
 DSk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:25:32 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3Pl5QM7z1Rwt8
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:25:31 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245531; x=1666837532; bh=lrg6l/pPX8i1bKBhQiAAkehXiG0KnY79HU2
        FjMsqfDU=; b=ifpIjd447X6PD39PFrTH3wwcRNYIQlE7xDKkwPQi/H/wCA2YnIt
        ixRlO81BusoEkF7Qrymits74JHwXdXSzoFaWrrgpQesAMU3LbDCWBwAsBvT+w0Dh
        6WTwxAccpj17cStcK4qcksRJRg4EWJL6u9sKPRCgDBq6047Ntjzg4WWDR8mLTxUB
        l4YVPsk8baK6Bx46j1kD+TWe29XXRHqgQn+81IfWRQvg+0zWnYwYCRlKO3RrNiPs
        B1Blc3fJ3XhSxzygtgmFmTADO7o3CTg4K+IpAOOVDECJ0fjovlN/ObEbG+tbsfAS
        Gln9Ufnwbt9dNCWwhLYm4mNJklROGJ1DptA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WOIYLTBgTwQP for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:25:31 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3Pj3Jpzz1RvLy;
        Mon, 26 Sep 2022 19:25:29 -0700 (PDT)
Message-ID: <4b38ff03-26b0-1781-b844-328159373f1e@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:25:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 3/8] scsi: pm8001: use sas_find_attached_phy() instead
 of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-4-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-4-yanaijie@huawei.com>
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
>  drivers/scsi/pm8001/pm8001_sas.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 8e3f2f9ddaac..d15a824bcea6 100644
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
> +		phy_id = sas_find_attached_phy(&parent_dev->ex_dev, dev);
> +		if (phy_id == -ENODEV) {
>  			pm8001_dbg(pm8001_ha, FAIL,
>  				   "Error: no attached dev:%016llx at ex:%016llx.\n",
>  				   SAS_ADDR(dev->sas_addr),
>  				   SAS_ADDR(parent_dev->sas_addr));
>  			res = -1;
> +		} else {
> +			pm8001_device->attached_phy = phy_id;
>  		}
>  	} else {
>  		if (dev->dev_type == SAS_SATA_DEV) {

-- 
Damien Le Moal
Western Digital Research

