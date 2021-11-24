Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA629C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 08:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhKXI5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 03:57:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32134 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKXI5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 03:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637744082; x=1669280082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EpBoV5l+PUkM9KJcNq/tLNQiPHG+sHbuidudthSDcIg=;
  b=qe8GGx2W+uCfSRtsaallgNQbuqhwivkWNVaK0GdyeYaIOmWcI/N60Y+U
   wjc9J5rGwVUTJQd0IjJug9cfV4ldzXqe5rgtYoC0Y00Fy//VomeQu6mOC
   s6Zvwaz+G0fJWuglDrGtl7yef8ex5wcAjTJOFLTK87WFN3WZd+WNLbPnk
   2krKQFje8xwqW+Mqcp5qfVYjRbWNr6m7rXRO1FKESyuYZhOuKYNsNeNLF
   NE79lWx9lNNItfNWggnj8uGzqvOl7v2Xcnf3Lld8AxpFZMf+MQBVZaAUu
   U0hDG3dwAIALhPa6Xt7eCsABSO0H+vU/MEu40iK0uKDz8FBjSkSdyp6oU
   A==;
X-IronPort-AV: E=Sophos;i="5.87,260,1631548800"; 
   d="scan'208";a="187511637"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2021 16:54:40 +0800
IronPort-SDR: +tL7UKupCs9ZVxSYosRzgjtZLRc0R4C5Zqe9tTfIxZhjw7lDTfrL5cIJRavFuNRQUlZHm2/f92
 jH3N4GaHikpMwvwZQaippL5SbIvPghSzb4S6eETY9FKjGpiE+tbwX9d0BeyArvyAAHECb2XtHR
 19+9f4eqlzIOBVJ56ZwTHX14sn6LgT6S+IIP6PXGuQc9ePJ9k4rRzH9Evd83L+teWMYIR3GQZ2
 gzZQO/LayOhpDzrfVTJvi8pXxrC5S7oSAsaRSzrgBKgJGPpXOA4dV326i0qVgzECrT3soM4v8m
 Yn0SPkwQeokPxKoFP8hJtbzB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 00:28:00 -0800
IronPort-SDR: uVf9h2FAa09sTpvL3igZeFyRxG6auCeJ0PotsZ27hena4TMrqE8nR+W98Ql/nKx5bG5zuV52FH
 //Kgg2cbskhj2wMN/C7OLBENmzegijPOOrQXN0IiQwxIbyC7DuRKr6FM6d2iKyOe5K54oxfniR
 oGRERZXlUT9GeflqUisoMGRO+/LZLTBaXPgjdMSDabZPvNl+Cdtkl89v0aV8jQrA641ttEToKQ
 ueX3AaEgms+vfPP592WeO33DCWX+3KWSmQOLXu0Tfp4zU+AyPw0dlhM6OgB6/aETgQnid/L9iQ
 ZNQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 00:54:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HzZZQ6bLjz1RtVn
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 00:54:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637744078; x=1640336079; bh=EpBoV5l+PUkM9KJcNq/tLNQiPHG+sHbuidu
        dthSDcIg=; b=gUn+5W62TXrTCKEFOOpCplWNMrQqgv0AZMC1cQYeMFZvjwDkXiD
        AxurNBC30yhN44JraU1/h//ydKaDELjamwIHhdEi5LZAnJAPrNRcGzzEczy+GM3r
        5kZSymD9zl7x1AKjzaUDAdteu4K/ZeVnNS4l4ox4GHj/tvh4OrFJAfNXsR53/a+j
        +vtBR0l6GLew3Ig6YQA5bRCh/WPHapJJSlvEP3nFiRFQNvsnRTEx3q1/quvPmH+A
        bQO/KYQkCrdk73J0ZFzuCwk1rpBv2+ANuno196W80bC0gvmN8+zVaLPXI/M2Oeu4
        jo94Om5+zN/3SE2zP8nCUOryTpBZO7IY3dg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oKCliqGOLwqg for <linux-scsi@vger.kernel.org>;
        Wed, 24 Nov 2021 00:54:38 -0800 (PST)
Received: from [10.89.87.131] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.87.131])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HzZZP53HHz1RtVl;
        Wed, 24 Nov 2021 00:54:37 -0800 (PST)
Message-ID: <26e883cd-3337-5875-47e1-d94f96be1ec5@opensource.wdc.com>
Date:   Wed, 24 Nov 2021 17:54:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH 05/13] scsi: ata: Declare 'ata_ncq_sdev_attrs' static
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <20211124005217.2300458-1-bvanassche@acm.org>
 <20211124005217.2300458-6-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211124005217.2300458-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/24 9:52, Bart Van Assche wrote:
> Fix the following kernel-doc warning:
> 
> 'ata_ncq_sdev_attrs' is only used in one source file. Hence declare this
> array static.
> 
> Fixes: c3f69c7f629f ("scsi: ata: Switch to attribute groups")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ata/libata-sata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 4e88597aa9df..5b78e86e3459 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -922,7 +922,7 @@ DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
>  	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
>  EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
>  
> -struct attribute *ata_ncq_sdev_attrs[] = {
> +static struct attribute *ata_ncq_sdev_attrs[] = {
>  	&dev_attr_unload_heads.attr,
>  	&dev_attr_ncq_prio_enable.attr,
>  	&dev_attr_ncq_prio_supported.attr,
> 

Already fixed in rc2.
See commit cac7e8b5f5fa94e28d581fbb9e76cb1c0c7fd56a.

-- 
Damien Le Moal
Western Digital Research
