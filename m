Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EAFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 23:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiA0XGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:06:24 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5574 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbiA0XGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 18:06:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643324782; x=1674860782;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QVYbW0Wb801k8+SBZmpkcQp1EgG//MCvkBVTkcz8syQ=;
  b=D3l0wOYis5Wf3FJEr3xL4ViQGFQB3vzhgTh2fXN3l+Cso77o5E0jthW9
   Qh85WaL+i9OaSu7I4tRLA5wsW5BUcfE1xibxwL+I0SQxnnsaVXKLmAuGf
   NA/0762sqb1JaQYvvDodDQalb+njbRaiQ1w27GSXprGxb+oC8/8q8H8kn
   Zq2rlMXM2+U2WnyAQNx3CmNWyMWifvSO3IwnN/bXA53zoK0RUVnh+Y0W5
   8mJ5fKZb9Rs+VIalwZYrgvudOYfGkIf9vU67gM7H0wtOr1z77TBwvGKDz
   D4dZpgFPWSWRjauiqj44CJ+G+PCsFfPAANdDiY60F4GbRY19MmjrMp5zb
   w==;
X-IronPort-AV: E=Sophos;i="5.88,321,1635177600"; 
   d="scan'208";a="303450775"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2022 07:06:22 +0800
IronPort-SDR: Xgx62IY8ZQXusowcjAEMtV0nsWn4IgQIzRyPHxgo0VJvbM7PV6EnT6kwmTGt5eueHLGpB3msdf
 iU+mrUNCE1oleXx3+ZvH15wQkvWNZMC7GfkJp2rEA2/68Z6JKCR5q5V7eJ51DrDECuopimb3Aa
 FU1zcYRlz+VNTWpecc8SkKwSVl9H5Il2jXxhbiZabYvbQSrlvgWKuHCcM2EzCcKrUP22wKFJWU
 Ph7oDYJDYK6w4aUaEB6Y+a7fmixrZWrlc502dSBTEz3TY0QzAPOYMsKVmEtiXbM7684woet4u4
 4YgkamWYSgkcJdgMO2iNOrCH
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 14:38:25 -0800
IronPort-SDR: mb1TiFVoFF2mKkxy9AUeF/PQB/yE3ETt71LofY69vAlcWzX70Ce+vKgDwNChPj5EKySgJ9Xpwh
 BUm5aR+lJkT8TX+ZykUfC3wE79Y3pqu/0YrfSDXJspQKZ94feW+SzbvTvPrF4sFuYLjZkL4uz/
 EBU1tLQL7JDaOotYdvQUR1qij5w1uhVolQjio21XrPdt7V51vaRr68orZZYsmOJ1GWWAbxi3zs
 4AbAMPZxCCQ7w0CWE31VpEABW/c4kDC05qt0s1ofnrhNGgNSsVVGeWHhR+oNUh8hxk7hVe3AB1
 TeY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:06:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JlGRd2PJ6z1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 15:06:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643324780; x=1645916781; bh=QVYbW0Wb801k8+SBZmpkcQp1EgG//MCvkBV
        Tkcz8syQ=; b=NZppG53bOl+24Lsj9ZkZKU6aOx84hgeSsENx1ySmcGKvKqbg+RW
        WNOdcsgIogd7c4Ycq9BLCacraPcjJdt51ZtQbw83+5EM0h4G2E17AY7B72Xe6mgY
        YNu0aK9w2SwjEW4PQqg9NyCcFo7X6srai/2Me9wF6ClI6fywzMg1iB3U3dR3PIRZ
        d9xlTK+Smii9Jniwv7P3YG0YKNM9yB/fHfa4pJAMVmCZ5RsgoSREMKIawtHzS3mB
        f/P06jHLnoteoNX5LX/926rW8T4EdSqBS2lId8vu0ky63SdEKaALLyKyoK9xO3BD
        UPLjl6G02XoZNS+we+UBxIR4ZeUC7d5bzoA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iexqOT_DwsTK for <linux-scsi@vger.kernel.org>;
        Thu, 27 Jan 2022 15:06:20 -0800 (PST)
Received: from [10.225.163.58] (unknown [10.225.163.58])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JlGRb1mXvz1RvlN;
        Thu, 27 Jan 2022 15:06:19 -0800 (PST)
Message-ID: <2d7788bc-eadd-5061-5241-fa141259bb30@opensource.wdc.com>
Date:   Fri, 28 Jan 2022 08:06:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] scsi: pm8001: Fix warning for undescribed param in
 process_one_iomb()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Ajish.Koshy@microchip.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viswas.G@microchip.com, chenxiang66@hisilicon.com
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com>
 <1643289172-165636-2-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1643289172-165636-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 22:12, John Garry wrote:
> make W=1 complains of an undescribed function pararm:
> 
> drivers/scsi/pm8001/pm80xx_hwi.c:3938: warning: Function parameter or member 'circularQ' not described in 'process_one_iomb'
> 
> Fix it.
> 
> Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index bbf538fe15b3..ce38a2298e75 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3931,6 +3931,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hba_info *pm8001_ha,
>  /**
>   * process_one_iomb - process one outbound Queue memory block
>   * @pm8001_ha: our hba card information
> + * @circularQ: outbound circular queue

Nit: you could remove the CaMeL case here while at it :)

>   * @piomb: IO message buffer
>   */
>  static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,

But anyway, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
