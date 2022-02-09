Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD1FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 02:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbiBICmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 21:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344414AbiBIClP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 21:41:15 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45495C043188
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 18:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644374413; x=1675910413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5jGen3hKuAqmZCUZesezMs0C28vFlrjgrYakLwisLjM=;
  b=UIbZILIqJObY3cTGaziPmhJ0km6mrQPlKTPEraki+cyY5YXonY4SdX8Z
   wqhl01QaMIIFgwjjS+6U6WiMVbKvbi7Hp8vHI/TfpSyVjX68Q9xp8j/bn
   x0Lux8STon+3SvBqCBOjLmRZmB2cbdHR9/OTcrid4mf65h2+MESnteOGS
   pp/2r0qWJVUnGse0F0wWIgPQ2j+yenSuEdJLTRPGb2n0kHG+gM9rhmU1G
   +t2PTTJvv3L6wQDCGFSmE4sYAcKRrct05VdhPbOxdBPsZODmjgx85HeLA
   emiU4dga7Dpurr+ZtnwJ6rLnoLTp3pHXn02QPvb38i2VdH/c3C4x1MxLL
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,354,1635177600"; 
   d="scan'208";a="193449710"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 10:40:12 +0800
IronPort-SDR: 4utaCFH9B/rOPrmv815jnrknRVdygFGRRwVmo+x0Zx0hN+E/7xg7ZS1KPMMvAfTMm8NGaBO/pi
 BTl0kEsp+a8gkMdGrM+wTeqk6GbWaUokSM32awYtnCM1AtcWtRpYXOis0g2Fn4h/6pV7f3nnO2
 JTurBJt3wPwX7Dh6G6ZDc2M1zN2aFr/tO6oVXH8/Pj47d6mmefrg6eEao671SgLmGJOK0KUyiP
 uGFUECJZOQpPigMFq3TPjYpEbkvku1rMM6c0oyiy/ATvvB8pW/RPYz7aNEmUrCaZxT892iWbbC
 wqs6vNbIBFn1o9YNL8ZKlFPH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 18:12:01 -0800
IronPort-SDR: Ds/6Zn1VadRp17hNiZy0qbV48vuvDoSYdZBS0MU2pPj1yizGCJEbUTddh32fktDBDMuwxs3EKs
 n0ubn7cQguVGSmjFwIEczD0CEPZF3CT8zYsukY/teC4WZYO+Tg76UZiKRzbO0aN9zYh8B1wP+/
 gXKzU4BeNpJyr7QfK8MzTGlOzHgWW1y6QsGjDS6lIcrihapYKcS/XfAI8G1FVjO+pkcO/I064A
 t7uCalKKEvUCWfEWiT/5xYbTNWMdyeWPCbiXmWiP1Ot+5NOvCXq373yx2UXtxg5VuPqVyWmv3+
 6fE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 18:40:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jtkcq5NtLz1SVp3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 18:40:11 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644374410; x=1646966411; bh=5jGen3hKuAqmZCUZesezMs0C28vFlrjgrYa
        kLwisLjM=; b=b5vxNOXovYZpnITGpEvJ4Vr4BmUY9xkeyqQubYzQRSo317/KyUx
        XdqsSzfDK8Nppd2BEZFG0GgvRyJHrNfJ/Jn0FHKxMYgogDO/51MVmU5qYYNebiSz
        fzTZqxmcCdxYg/GRmLWpK04k4p1Slk1tg+J7oE9AAL7z1LE5xl9euMB2Co3JOVfQ
        4OZW/Qi3ANlf2SOp4RT4SQdlt2Say/QfNQeA3lcEacEhpA2nVRI8tJXiYtNoHKvi
        /PsjX5Stam2mDF25DsD8C6et4KnZ+tM5BfU58nH+p3FU70GHv8grXJXxxuBLSW3Y
        ioeJz0mLZB0eM3ik1VWHfiz85WSzbMWkmRg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pj8m-gAzNVdW for <linux-scsi@vger.kernel.org>;
        Tue,  8 Feb 2022 18:40:10 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jtkcm6B4Xz1Rwrw;
        Tue,  8 Feb 2022 18:40:08 -0800 (PST)
Message-ID: <a0ec0411-6388-197f-abaa-08b2dc9dac4d@opensource.wdc.com>
Date:   Wed, 9 Feb 2022 11:40:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: ibmvfc: replace snprintf with sysfs_emit
Content-Language: en-US
To:     davidcomponentone@gmail.com, tyreld@linux.ibm.com
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <b4c150c86f539d3bac3fc8885252adb9f24ee48f.1644286482.git.yang.guang5@zte.com.cn>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <b4c150c86f539d3bac3fc8885252adb9f24ee48f.1644286482.git.yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 09:43, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> coccinelle report:
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3453:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3416:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3436:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3426:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3445:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/scsi/ibmvscsi/ibmvfc.c:3406:8-16:
> WARNING: use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index d0eab5700dc5..d5a197d17e0a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -3403,7 +3403,7 @@ static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			vhost->login_buf->resp.partition_name);
>  }
>  
> @@ -3413,7 +3413,7 @@ static ssize_t ibmvfc_show_host_device_name(struct device *dev,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			vhost->login_buf->resp.device_name);
>  }
>  
> @@ -3423,7 +3423,7 @@ static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			vhost->login_buf->resp.port_loc_code);
>  }
>  
> @@ -3433,7 +3433,7 @@ static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			vhost->login_buf->resp.drc_name);
>  }
>  
> @@ -3442,7 +3442,7 @@ static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
> -	return snprintf(buf, PAGE_SIZE, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
> +	return sysfs_emit(buf, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));

The format should be %u, not %d. And while at it, please add a blank
line after the declarations.

>  }
>  
>  static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
> @@ -3450,7 +3450,7 @@ static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ibmvfc_host *vhost = shost_priv(shost);
> -	return snprintf(buf, PAGE_SIZE, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
> +	return sysfs_emit(buf, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
>  }

Ditto for the blank line.

>  
>  /**
> @@ -3471,7 +3471,7 @@ static ssize_t ibmvfc_show_log_level(struct device *dev,
>  	int len;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->log_level);
> +	len = sysfs_emit(buf, "%d\n", vhost->log_level);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	return len;
>  }
> @@ -3509,7 +3509,7 @@ static ssize_t ibmvfc_show_scsi_channels(struct device *dev,
>  	int len;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->client_scsi_channels);
> +	len = sysfs_emit(buf, "%d\n", vhost->client_scsi_channels);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	return len;
>  }


-- 
Damien Le Moal
Western Digital Research
