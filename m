Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE70C7619A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Apr 2023 04:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjDBE6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 00:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBE6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 00:58:47 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FC2FF32
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 21:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680411524; x=1711947524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Spcdt1MtsHNLI534weepBffByqig80z3Z+Ytrejt28Q=;
  b=DnM8Wdqhga8yxiqcmYlMrAzCqQm80rRIPR1Myxaduq4wWVcIlQ2dkBnx
   TmHzH3EMzKnI5dynZN7v/BgLzzvRJ4feAV0IrzKgpb+D7dnlVZ8VYY4gi
   4ZfVkU2fGrT08qVE9zQijwYmhCT1WLsUn63hqzu5DXDjYvJoQB293v2Hq
   NXAI7m83znMkJjuV3GeaL2qe7IqEyLHbHYAqlWq5ZiDaCIwZNFyS6oWAy
   ZsT2OWOqbyFBhZ+4r3sXGASe2xjBOAjy3XMFFvIed1YuX5CZHs6pYdsfK
   1U8pk3pW2Q0rqCZX4EeuK0TQ6WAkpS1fuMz5ZZMx0nz28mZ9zA6qRtybO
   w==;
X-IronPort-AV: E=Sophos;i="5.98,312,1673884800"; 
   d="scan'208";a="339150256"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2023 12:58:44 +0800
IronPort-SDR: oVCD8/tTVtoHPmkQRn+fYK0Z6XltSXAcV9oQzKKKsTWtMr1QtGtS6cjpWQ0fXy9Wzs2SmV0veS
 AHqIWr4LFGx7lHrvR2L/w/UayBzAAj50GJG9uQAgPbke4auz8wRoLVjBB2zNYCoAICkBapnxLt
 fbnCaXZWqRoSdHffSA/7rard5bjNP5VYA6sZ1RFlNKVS0Bm7A0QY/MwaTO9MSRiyY0YQYRwF31
 Qye+Balw00EVNe4hjNaTwcV6M2C1Sy7lHkb8MV4gydwslegSeQ0duhdAyoaCwYb/ESwegTDgul
 5aU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2023 21:14:49 -0700
IronPort-SDR: EDfsgdwxahNEqD8wE9nZsQmtXVR8v8LjCYsi1rGQGpj5jSjJPDPYICpvGBDPz7qMhHfDU+o1VK
 JWtuC9+thrNNPwFPpM3oiOmPskOIfwIGXEzcCcmcIOHlOMjqy79Cr+MfKAgWsdrGX8ht0XB8Ig
 sHJisv3g5VGnX0yMX1OGLTSlKLlJAlCyX8qIHf3ol8mDiYUPYPhlJimRLF9tU1NSKl7mr7D/JB
 CJg/gLtRDGj6dV3sxiAjsoh0hwhHjeb9YTzE7KvgQe8SGoWkT8IctIJ7MfnUFx8NNCzaa00Yij
 gm8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2023 21:58:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pq1yC5DJKz1RtW0
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 21:58:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680411522; x=1683003523; bh=Spcdt1MtsHNLI534weepBffByqig80z3Z+Y
        trejt28Q=; b=N/Ojdz4Q0YvUp+Er63NjFyefNCARCxRJoYJhUXB+P8EmLNX09xy
        56fnlLbnYvAvwOMgTzIYd7OHVq1qwL8i81l9rrX8ivAr2QEexUDMHTXIG3zStYl+
        UalLguUKyPopOcT9jxD7ZLPtEPaxpAbb5Fep2DD9nrFvKTcfFaqLSyQ9K+6EsUGc
        kyJdM51WFdB7CmfoKP99P81js8RtMQNy+5Ci613h4BVHz5OSNCerYfHmx1CBmfcH
        9QAjTdSHC3WgvxvJMH27ZE7yWD40kuaCiGSSbLyQCH4bsAQGSLZsh/ZHmShrWMO7
        SbS02LrHkFgGoOgi0m8mwtD8sCKlt9kagwg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v_02q3EN7o5M for <linux-scsi@vger.kernel.org>;
        Sat,  1 Apr 2023 21:58:42 -0700 (PDT)
Received: from [10.225.163.1] (unknown [10.225.163.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pq1y91Mh2z1RtVm;
        Sat,  1 Apr 2023 21:58:40 -0700 (PDT)
Message-ID: <739e2d17-f1c6-fc33-adc4-41cb97b5950d@opensource.wdc.com>
Date:   Sun, 2 Apr 2023 13:58:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/3] scsi: libsas: Simplify sas_check_eeds()
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        john.g.garry@oracle.com
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-2-yanaijie@huawei.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230401081526.1655279-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/23 17:15, Jason Yan wrote:
> In sas_check_eeds() there is an empty branch. We can reverse the
> test expression and then remove the empty branch. Also the the test
> expression is a little bit complex so it deserves an individual
> function. And make the continuing prototype lines indented after
> the opening parenthesis to follow the standard coding style.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 38 ++++++++++++++----------------
>  1 file changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index dc670304f181..048a931d856a 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1198,37 +1198,35 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
>  		  sas_route_char(child, child_phy));
>  }
>  
> +static bool sas_eeds_valid(struct domain_device *parent, struct domain_device *child)
> +{
> +	struct sas_discovery *disc = &parent->port->disc;

Missing blank line after declaration.

> +	return (((SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr)) ||
> +		 (SAS_ADDR(disc->eeds_a) == SAS_ADDR(child->sas_addr))) &&
> +		((SAS_ADDR(disc->eeds_b) == SAS_ADDR(parent->sas_addr)) ||
> +		 (SAS_ADDR(disc->eeds_b) == SAS_ADDR(child->sas_addr))));

Drop the inner-most and outter-most parenthesis.

> +}
> +
>  static int sas_check_eeds(struct domain_device *child,
> -				 struct ex_phy *parent_phy,
> -				 struct ex_phy *child_phy)
> +			  struct ex_phy *parent_phy,
> +			  struct ex_phy *child_phy)
>  {
>  	int res = 0;
>  	struct domain_device *parent = child->parent;
> +	struct sas_discovery *disc = &parent->port->disc;
>  
> -	if (SAS_ADDR(parent->port->disc.fanout_sas_addr) != 0) {
> +	if (SAS_ADDR(disc->fanout_sas_addr) != 0) {
>  		res = -ENODEV;
>  		pr_warn("edge ex %016llx phy S:%02d <--> edge ex %016llx phy S:%02d, while there is a fanout ex %016llx\n",
>  			SAS_ADDR(parent->sas_addr),
>  			parent_phy->phy_id,
>  			SAS_ADDR(child->sas_addr),
>  			child_phy->phy_id,
> -			SAS_ADDR(parent->port->disc.fanout_sas_addr));
> -	} else if (SAS_ADDR(parent->port->disc.eeds_a) == 0) {
> -		memcpy(parent->port->disc.eeds_a, parent->sas_addr,
> -		       SAS_ADDR_SIZE);
> -		memcpy(parent->port->disc.eeds_b, child->sas_addr,
> -		       SAS_ADDR_SIZE);
> -	} else if (((SAS_ADDR(parent->port->disc.eeds_a) ==
> -		    SAS_ADDR(parent->sas_addr)) ||
> -		   (SAS_ADDR(parent->port->disc.eeds_a) ==
> -		    SAS_ADDR(child->sas_addr)))
> -		   &&
> -		   ((SAS_ADDR(parent->port->disc.eeds_b) ==
> -		     SAS_ADDR(parent->sas_addr)) ||
> -		    (SAS_ADDR(parent->port->disc.eeds_b) ==
> -		     SAS_ADDR(child->sas_addr))))
> -		;
> -	else {
> +			SAS_ADDR(disc->fanout_sas_addr));
> +	} else if (SAS_ADDR(disc->eeds_a) == 0) {
> +		memcpy(disc->eeds_a, parent->sas_addr, SAS_ADDR_SIZE);
> +		memcpy(disc->eeds_b, child->sas_addr, SAS_ADDR_SIZE);
> +	} else if (!sas_eeds_valid(parent, child)) {
>  		res = -ENODEV;
>  		pr_warn("edge ex %016llx phy%02d <--> edge ex %016llx phy%02d link forms a third EEDS!\n",
>  			SAS_ADDR(parent->sas_addr),

-- 
Damien Le Moal
Western Digital Research

