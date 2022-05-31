Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDAFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 21:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbiEaVac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345809AbiEaVaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 17:30:30 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A399D4D3
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 14:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654032628; x=1685568628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BY/3N4m5k3a9PP8+kxvECWFk1mLOpm+stsGO4daEj78=;
  b=qcftYAnHMsWm78AvnhfU8eXGbphpy9O486Q2ZtgKzUTLU8j5WHimKQ/n
   orH5rar96xOR+RrwI0A68HQ2x1tgAdHwAcFBGBElICKgLwInjP9QfuxjE
   qpopcXmnFNgMO6fGL3dn9xyq2bTOUlJLG4ZoBG4z0lhYVZKO0NGiuyZCl
   WOWT/shxOF1YWZNnYpNO5POh3HeYzWl4T9tuGIMNVZ1RpHHSh0eMgUYIs
   dwDf5vdzABBizVCjUCiMS13b/WNvnl6Z8LJ4p3uoXyuvzfOtqMSy2zhs1
   SuXbYHkoEBIgbmdMRIkDavUIRuZPvsoTj6BA/gJ92T1UpJEEwmK2Voy9M
   A==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="206787239"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 05:30:27 +0800
IronPort-SDR: 8XwbYlPJ1O2hgdGWKm6SupXbFZ+ofJxeraz5WN5MEglHZFBwM7aRjHysIm1tN+4LOUlDjmnXQs
 K2PFzUZZdL5c8RE6YMLCaINVDyA/7svoPJzZNb/5SmtWGGSxTTy+EMcUSjhfwzlaA03jbpVL43
 /43Yy4a0hFm0o5Zc/lHzUfht2yTYFziM05Ki3wWM5XQXOPEkLREZXcttLD+l7lBVGBM/D60l/2
 p6hoqiDmyVelftdfO6DKiREsuux+5PRD+n/bMY84RLqQdSQ3FVqL65wcxBe8k0oJmkaoK55FVy
 MnMPXo+cwcjE+PQpO7b91nxD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 13:54:13 -0700
IronPort-SDR: 4gGQiMpr36P1Etie5UFnZ+nSxsRH3+VhDuRQ8MQSGtLiogVdwzZQYv64RB7zuv/3J9EekJUZQs
 obR44XrDTtK+y+cpYyrH1t+EIbL5HfHJBcjJc4W4WaueMMH9FytyOGoBx2/kv+y4qT5Nx+P9AJ
 XFoCQZQjP9+C1XD0+GD+uzVE+Hfq0k2526m0JdAAvTvGCgAQtsW6gjBds+/GoQmjGaLik1Ys+l
 FMf/70NUed87F3V6H6Vw25/rQHMASBBg8R/CKJh+K0piMI9aB35mItv+2YrxzZipnkilModT4W
 RIk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 14:30:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LCQRl68lwz1SHwl
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 14:30:27 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654032627; x=1656624628; bh=BY/3N4m5k3a9PP8+kxvECWFk1mLOpm+stsG
        O4daEj78=; b=NAQtIWriPdmX/XQzewvVsNznND20KxwByNPZN/tOBUIK+Rbew0w
        xHIWZ4SWaFScxpg8qtMt/P5Ej0v+qVqUK273TuyNIDUQdYcTGa9EadE7XlIEZww5
        AJTi40kl/n3AmF0S4dQ3He0JD4oapoXla7qfYx0DextIYQgQhji7YtNU60EuW4ua
        DusZIsJeYquDcq5TbCjx6nlMwRMZsOome6m9Qh+J/Tc96zEKUDdZ5OyhEN6QfjZa
        3bP9xGFrnVTHQt5ZxMUHwZXQ3vyGGQT+eUMQ3F3thI/DrzSYd4OHWGOd7rnE+wiH
        Ay98lSUEkbpFQHz2VEkOTPUzpo6dZ6NA0rQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LS3AOi-uV1QT for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 14:30:27 -0700 (PDT)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LCQRk02qXz1Rvlc;
        Tue, 31 May 2022 14:30:25 -0700 (PDT)
Message-ID: <a24e7a79-ff46-158f-92b0-1f667d4d2153@opensource.wdc.com>
Date:   Wed, 1 Jun 2022 06:30:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] [PATCH v1 2/2] sd: Fixing interpretation of VPD B9h
 length
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com,
        Michael English <michael.english@seagate.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
 <20220531175009.850-3-tyler.erickson@seagate.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220531175009.850-3-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/1/22 02:50, Tyler Erickson wrote:
> Fixing the interpretation of the length of the B9h VPD page
> (concurrent positioning ranges). Adding 4 is necessary as
> the first 4 bytes of the page is the header with page number
> and length information. Adding 3 was likely a misinterpretation
> of the SBC-5 specification which sets all offsets starting at zero.
> 
> This fixes the error in dmesg:
> [ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
> 
> Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>

This needs a fixes tag and cc stable. Your patch format is also starnge.
It is missing the "---" separator after the tags. This is not going to
apply. Did you generate this with git format-patch ?

> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index dc6e55761fd1..14867e8cd687 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3067,7 +3067,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>  		goto out;
>  
>  	/* We must have at least a 64B header and one 32B range descriptor */
> -	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
> +	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
>  	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
>  		sd_printk(KERN_ERR, sdkp,
>  			  "Invalid Concurrent Positioning Ranges VPD page\n");


-- 
Damien Le Moal
Western Digital Research
