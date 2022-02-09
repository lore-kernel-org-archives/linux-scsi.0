Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A8AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 03:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243635AbiBIDDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 22:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354103AbiBICuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 21:50:00 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E246DC0401CE
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 18:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644374698; x=1675910698;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H7X0q8+8Rf4sF4doHl8BZDH9YkalaHuLv0owIfyARug=;
  b=Ph65vEWGJNpJ1Hin7N9q1i4iHq3HNPr0jz8cBYUVEoSUxrksRr7+vJ9u
   cLazqBO9p43qXVirhOiR+56bIRA4U0SL082FfHqAios3MsZQVvWmwPbur
   W4uyKcAqGysqF8QVqDoQ0tZgPsv5M7FIZvZto6P4B1oU5Xx8BItzaXCMs
   gHjrW9CoRcUyzYPMPM9O50vOlwtJlGfV5Bao3oA2M+9zS41JDnhhiY4TP
   +mThcwcE5kyaw/IPBsiu6VEXuj1EckhuM1ip+WEPfkAKhHdWam1KuDDLe
   1nTof2mTtMAOln2s17aH1JYiPzK5sTFxrPwxBH0DgpnI7681vo/5tc1Id
   g==;
X-IronPort-AV: E=Sophos;i="5.88,354,1635177600"; 
   d="scan'208";a="191407414"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 10:44:58 +0800
IronPort-SDR: tQ4UdizJSi4LawxPB+koAn0aRjL3CjJgQbizE1ByRCOKJ3waDkskYALiIJq2VAedvSPeEjue2t
 GJK08IGe6J8yZkNz7M4ECwdKNqu6qcwivPArJwOK4rr3lDkL7M6SYoDuKr3vW6gsoGe08k9oX1
 Q9eq2V0gKgnFbkQ344Mz7Snr/3PrzMYFJu5V6Az1P35B0G5JzT1OLyJBr4F3OXjuN8JFL/VajQ
 8HIuGu0dnloJLR5XP1xFvRGUd/c4arJQCNfHWO2GKtHfi41btbbH8WwNMA6ea3jUCgC8M42ebJ
 ZuE3nKcwoo/w1Qdc5lfqpqK4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 18:17:57 -0800
IronPort-SDR: BUoM+Wepv2J62l3QIMX9ZG3orRdvIcgRUpCXLZpcR3jss57uGUMJjSR+RnN2rjfwFVL3lnm4TV
 Y2JwsBkTcCDKiH5SV8ypMsW4Worv3aujpsSW+ql+5GyNDbvbYeOl/LCI0m+SeY6p2E6gpd3o0l
 3X5rFFK7iJfZV+i8AQ/Fm4kqnq2LwchaZlOCZAMZNjGoMSp/EKOQ3zKHKYCoQc2u4l1GV6MzpY
 Mohb1c/FRccFtE0Z+/+KMhOmDmbA0ACPmVhhMv/sw7cjNiEmnkSP9VyVZi7MhXBaaitizoISRP
 Tc4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 18:44:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtkkK6zsWz1SVp3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 18:44:57 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644374697; x=1646966698; bh=H7X0q8+8Rf4sF4doHl8BZDH9YkalaHuLv0o
        wIfyARug=; b=NIZHhXC5BMH8G9DXKULPfh+366lZiFY2U/NyqMHo7oTLM/RkiiZ
        jsW+5QJRigcxQHA1vn6zHPLECk1UzjcHjxyj1hmjcFvE41bDzpBO0aZZsgpX8WOI
        HY9IwbN2ntIN4ygXsiD+tbSbabU4ZOpq3WNmBRPzFuDLF/u/MulOvw/CmcLP1qx5
        o8V0y2IYt7ZfJ25zurmleBUanPfduREQfTO5rCVYUMPdeuhIRn9PaU7xjBph2MjF
        ZXfGglBdEjeGbv7doqq3mYpfTWj3Qs54qsp/35GBJP4n7N03T25QkbqWLA4GqrP8
        PHIqAlUB7elkRXSqYZfCGrLwyR+xFIxDGZg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hK8PCMmTw1QD for <linux-scsi@vger.kernel.org>;
        Tue,  8 Feb 2022 18:44:57 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtkkH2fzGz1Rwrw;
        Tue,  8 Feb 2022 18:44:55 -0800 (PST)
Message-ID: <9fc56cf0-1a8c-fa9b-60ce-74b7c7104902@opensource.wdc.com>
Date:   Wed, 9 Feb 2022 11:44:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: arcmsr: replace snprintf with sysfs_emit
Content-Language: en-US
To:     davidcomponentone@gmail.com, jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, yang.guang5@zte.com.cn,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
References: <1c5ade32e6e60c94dd357c4a159df64a7e311459.1644283712.git.yang.guang5@zte.com.cn>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1c5ade32e6e60c94dd357c4a159df64a7e311459.1644283712.git.yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 09:47, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> coccinelle report:
> ./drivers/scsi/arcmsr/arcmsr_attr.c:297:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:273:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:285:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:261:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:374:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:309:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:348:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:335:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:361:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/arcmsr/arcmsr_attr.c:322:8-16:
> WARNING: use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_attr.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
> index baeb5e795690..e66d761926e9 100644
> --- a/drivers/scsi/arcmsr/arcmsr_attr.c
> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c
> @@ -258,8 +258,7 @@ static ssize_t
>  arcmsr_attr_host_driver_version(struct device *dev,
>  				struct device_attribute *attr, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE,
> -			"%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			ARCMSR_DRIVER_VERSION);

No need for the line break.

>  }
>  
> @@ -270,8 +269,7 @@ arcmsr_attr_host_driver_posted_cmd(struct device *dev,
>  	struct Scsi_Host *host = class_to_shost(dev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			atomic_read(&acb->ccboutstandingcount));
>  }
>  
> @@ -282,8 +280,7 @@ arcmsr_attr_host_driver_reset(struct device *dev,
>  	struct Scsi_Host *host = class_to_shost(dev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->num_resets);

Please add a blank line after the declarations and there is no need for
the line break. The format should be %4u (unsigned value).

>  }
>  
> @@ -294,8 +291,7 @@ arcmsr_attr_host_driver_abort(struct device *dev,
>  	struct Scsi_Host *host = class_to_shost(dev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->num_aborts);

Same comments (all of them).

>  }
>  
> @@ -306,8 +302,7 @@ arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute *attr,
>  	struct Scsi_Host *host = class_to_shost(dev);
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
> -	return snprintf(buf, PAGE_SIZE,
> -			"%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			acb->firm_model);

blank line and line break comments apply.

>  }
>  
> @@ -319,8 +314,7 @@ arcmsr_attr_host_fw_version(struct device *dev,
>  	struct AdapterControlBlock *acb =
>  			(struct AdapterControlBlock *) host->hostdata;
>  
> -	return snprintf(buf, PAGE_SIZE,
> -			"%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			acb->firm_version);

line break not needed.

>  }
>  
> @@ -332,8 +326,7 @@ arcmsr_attr_host_fw_request_len(struct device *dev,
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
>  
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->firm_request_len);

line break not needed and %u format.

>  }
>  
> @@ -345,8 +338,7 @@ arcmsr_attr_host_fw_numbers_queue(struct device *dev,
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
>  
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->firm_numbers_queue);

Same.

>  }
>  
> @@ -358,8 +350,7 @@ arcmsr_attr_host_fw_sdram_size(struct device *dev,
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
>  
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->firm_sdram_size);

Again same.

>  }
>  
> @@ -371,8 +362,7 @@ arcmsr_attr_host_fw_hd_channels(struct device *dev,
>  	struct AdapterControlBlock *acb =
>  		(struct AdapterControlBlock *) host->hostdata;
>  
> -	return snprintf(buf, PAGE_SIZE,
> -			"%4d\n",
> +	return sysfs_emit(buf, "%4d\n",
>  			acb->firm_hd_channels);
>  }

And here too.


-- 
Damien Le Moal
Western Digital Research
