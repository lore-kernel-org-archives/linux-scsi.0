Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8E1C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiI0CXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI0CXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:23:16 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8731A9C24
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245394; x=1695781394;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CcydczoRB1wShpaonoeda496cVy8GQEVlia89fuRyPU=;
  b=Uzt6jw0Xx7iTDoxLSzer443cSyx6oHJ/LBXooARq+/oHgx/QPn/eGtnb
   lS7B29WH0Tzqc1wvntbvdfNNU2dkOrqr/1yIq4Zt79nsSHJLb5D4Xr8C9
   pNJe0iL7AwzkcHSdIrE2UGqTsMGy4Tm32mP0lrQ95w/KOx9UKfRJHhyW3
   kA3iQDRedXNczbsm32mMxFoql8gJXrb8mMEYMBGxRdjUi0oJqMEMMx0RX
   dSscdphLHFl5/Q26/+agWZRE75u9kdPzdjKbpXzplZ1c7QyOxSuIGCLG/
   bs6QDQpun1aj82M5S47lSimOeWOQyzflEA9BH+Q5AGPF231EUGC4Rdpbc
   A==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="210704489"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:23:14 +0800
IronPort-SDR: VyPRcwZsxf9grCCJbGbC1bDy27Yi6W2Fn1rVhyotVIGlABf8pcBLBysEZRDTvSCeLx6ToQT92W
 A4c03Cn0Nvl8oPAnkaCYu1lIaoq45SVyZ/DyyljigGetC3cp977DRJBnudXt9hftZXBFztzuwA
 dGCcqXt2Qn2lJ3OMWB+1+cqAzE5D0NTNFsqmTA9rYRDONKTX+VqPV2UqU9VbTL1SY98C0g7fKx
 E7ML6Nmc3/gwm4TJLQSZ7Vw4xxLESBNGcFZIoXq6nLFuZYiXMJgfb7QYys0tXT87JNN2zhS1us
 Y9Bj7/KiWPVz532ESqXD2N6X
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:37:40 -0700
IronPort-SDR: cHmnFGiN0Jgh+/yTobs7/FaRqe4T6R2cokS+IyPXFCwfZnqMypeE9/+OaY7PFdfw92F6eQDKsP
 suseGhiDwM4RR7/UFesUhuzPHbm0ok4KeMMtoWTrEe41NPej0fE8oJ2rfdKSM9/ifoqRd2uo6u
 vcFrqG8OuQaPyBe4hq8nglbfMphIkYKBUaXKKP5SlQhp+I9s+J2apx216u3zEQKJm08N0BXC9C
 DDaaUqQDKiEU+BXFErqUcoD9Gi8aiJZIQhMiyLJSPe6R4DZppavEPIwBbXliGAWzV1YY3ZhrsV
 ACY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:23:13 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3M54gZxz1RvTr
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:23:13 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245393; x=1666837394; bh=CcydczoRB1wShpaonoeda496cVy8GQEVlia
        89fuRyPU=; b=RCASez9hpIQxk/TENgJZvKTUug33qAtamS/J2XKyOWc6AY4zRSI
        aXJKuwZFPmm5fXHUqgk94P6tJPgBk69ITciOJb9GawXxZuh4FNrmXbb2Yo9wnFRb
        auFtFqPj89AP/qRhHGuKH7+wcjXv6Kzr1mupQRbC2yui9FyIgw2CcGbbQ8oG1wXK
        V2LuxpcmnhJLyGPaIhrnZdcwiCKTiTed9fnpgMFH45F3kNr/MOs0izhOQr9vrBpI
        OM9erGxUK3FwAckRO88l5wznbYpWQIZMUxhwGcdhfvYNVqaptY2T+MRozoq93HKL
        CaxeQeafB3hMZ8L5xs5NQf69mkG3IfmBnUg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BfzCq8kztb7x for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:23:13 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3M31B1rz1RvLy;
        Mon, 26 Sep 2022 19:23:10 -0700 (PDT)
Message-ID: <4e829dd7-6db3-4dbf-1b8e-9f7bb805f723@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:23:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 1/8] scsi: libsas: introduce sas address comparation
 helpers
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-2-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> Sas address comparation is widely used in libsas. However they are all

s/comparation/comparison

Here and in the patch title.

Other than that, Looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> opencoded and to avoid the line spill over 80 columns, are mostly split
> into multi-lines. Introduce some helpers to prepare some refactor.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/libsas/sas_internal.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 8d0ad3abc7b5..3384429b7eb0 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -111,6 +111,23 @@ static inline void sas_smp_host_handler(struct bsg_job *job,
>  }
>  #endif
>  
> +static inline bool sas_phy_match_dev_addr(struct domain_device *dev,
> +					 struct ex_phy *phy)
> +{
> +	return SAS_ADDR(dev->sas_addr) == SAS_ADDR(phy->attached_sas_addr);
> +}
> +
> +static inline bool sas_phy_match_port_addr(struct asd_sas_port *port,
> +					   struct ex_phy *phy)
> +{
> +	return SAS_ADDR(port->sas_addr) == SAS_ADDR(phy->attached_sas_addr);
> +}
> +
> +static inline bool sas_phy_addr_match(struct ex_phy *p1, struct ex_phy *p2)
> +{
> +	return  SAS_ADDR(p1->attached_sas_addr) == SAS_ADDR(p2->attached_sas_addr);
> +}
> +
>  static inline void sas_fail_probe(struct domain_device *dev, const char *func, int err)
>  {
>  	pr_warn("%s: for %s device %016llx returned %d\n",

-- 
Damien Le Moal
Western Digital Research

