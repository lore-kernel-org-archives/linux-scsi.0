Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA45FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 21:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbiEaV2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 17:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346652AbiEaV2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 17:28:18 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5713562E0
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 14:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654032496; x=1685568496;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eph88Kvdww+JqupptQgh1lunusqQ5ftnaKD8l+0Q4so=;
  b=fTwEoQaV5h6y8YQYY4vR9f3qwWmez4NkpCEO0THKuh6SzHd4j+PU4xoe
   k5jahmKNIZV4h3RTZfc3SC1q4C0JcXvbaR1NLQ73miOYBa/h+wLqjtRpT
   6Y3MWeP0YG68xC9WjBq3UGW5dlk+fTfHWqH9s7kxqsqGZlX1uHryanGqO
   S6JPr77hwE7+0RK6PE+ZYJomNbtVx/oU3B9+f4XI/I3T2rKBuBycvH5et
   E+XkPWvA5crJAZzv4lHvz3qa3/c2A+RjasPhCFLV627a44g6QEu/FNLbV
   W0j1oXsVSULl0VkX+LYSCeruWyv/MM4aChvS3ll3wmjVBOHkQU33dA2FI
   g==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="206787136"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 05:28:15 +0800
IronPort-SDR: thd5MAgrtO36u0VpXaUbh747xRDzIJTOq2+VeKhwBZEBIajnrROcudpOAt+3J0djQL2JJzFKBb
 MS7qqezRj5KkgREviw2APw8kDqaX/qQ6c2F0Uy65nbktV4ysJLEn946lNgZXcLu3POLBQpXDeg
 6VPj0fTZ0YgsnCvhvFqKLOsQ/+8gFTnzFPrhdq6FCl5iwcov26uWnPgzsE1FLcOVFVXapeiopU
 Txw+HYblhrZIW3BGo+BiYmwHC4UhNhfNQup7BabnXWBzy8Gf8VnnLxzxPntHItR80zIa8I3zCR
 IDE8tZR4VmyKo8faUZpmUMat
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 13:52:01 -0700
IronPort-SDR: KUY/fHhApbbhop8YCuNYPp856+K0nY/XAsC6XclHw+BswrBxoDY8twZGfxWP9FqW8jS/xveos7
 JQYe6DgBTqbvz2rQHLxEKZR7IRv3OEOa/9qQWO6VUBJNVEpXvd6SWj0niUNdg1RdpoFSQNqqzm
 K3artldM1MQSIAVd6PieGcgBPHm3ULnjBE0H+xc1sELQ34YSTCJBoBLNQ9NtvExgUH0HYHgs7N
 LcW1X/1qzJH5IdhMCnOOTij1nzp5W10J5WZhUZmQM9EAr3AAf9pQnoR1+mm1IcJEWKRBM2u0l+
 hf0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 14:28:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LCQPC3gF4z1SVnx
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 14:28:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654032494; x=1656624495; bh=eph88Kvdww+JqupptQgh1lunusqQ5ftnaKD
        8l+0Q4so=; b=Y4g3aiK92lLlLnrFXo1UZ5xAIGbyUTFQGzb0JdXLQHJYii6DkBB
        B137FOLc8A2P18brmETlk4BM6YGOsRDQHsFLwq6zl1GFH5QjUx8gsTondMkkJNai
        JZD4CzWFuPZBXm+8iwA+TeDsvXltgDmTtXP40I6/Wx1UO5RPuybl7gA2D+m8C39M
        BlHQLyzawfF9EuORHDiZBxjgWGiOJkQXgVCE1OaYCEpZhgs75VT90HubAVY1NLkY
        igNCJTaoaE6sCVfWfwAA3B5CbGc+rGA0W2+4vQvS/JyVbnigZENJqlnvhl/hlFgy
        cx57hbz0OHjV/2YP3L0So/dlf4+CgQ930Gg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zNCfYF_LYQ09 for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 14:28:14 -0700 (PDT)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LCQP9465tz1Rvlc;
        Tue, 31 May 2022 14:28:13 -0700 (PDT)
Message-ID: <697f58df-8409-1428-a38f-008bf372f178@opensource.wdc.com>
Date:   Wed, 1 Jun 2022 06:28:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] [PATCH v1 1/2] libata: fix reading concurrent
 positioning ranges log
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com,
        Tyler Erickson <tyler.j.erickson@seagate.com>,
        Michael English <michael.english@seagate.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
 <20220531175009.850-2-tyler.erickson@seagate.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220531175009.850-2-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/1/22 02:50, Tyler Erickson wrote:
> From: Tyler Erickson <tyler.j.erickson@seagate.com>
> 
> The concurrent positioning ranges log is not a fixed size and may depend
> on how many ranges are supported by the device. This patch uses the size
> reported in the GPL directory to determine the number of pages supported
> by the device before attempting to read this log page.
> 
> Also fixing the page length in the SCSI translation for the concurrent
> positioning ranges VPD page.
> 
> This resolves this error from the dmesg output:
>     ata6.00: Read log 0x47 page 0x00 failed, Emask 0x1
> 
> Signed-off-by: Tyler Erickson <tyler.j.erickson@seagate.com>
> Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
> Tested-by: Michael English <michael.english@seagate.com>

This needs a Fixes tag and cc stable.

> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ca64837641be..3d57fa84e2be 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2003,16 +2003,16 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>  	return err_mask;
>  }
>  
> -static bool ata_log_supported(struct ata_device *dev, u8 log)
> +static int ata_log_supported(struct ata_device *dev, u8 log)
>  {
>  	struct ata_port *ap = dev->link->ap;
>  
>  	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
> -		return false;
> +		return 0;
>  
>  	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
> -		return false;
> -	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
> +		return 0;
> +	return get_unaligned_le16(&ap->sector_buf[log * 2]);
>  }
>  
>  static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
> @@ -2448,15 +2448,20 @@ static void ata_dev_config_cpr(struct ata_device *dev)
>  	struct ata_cpr_log *cpr_log = NULL;
>  	u8 *desc, *buf = NULL;
>  
> -	if (ata_id_major_version(dev->id) < 11 ||
> -	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
> +	if (ata_id_major_version(dev->id) < 11)
> +		goto out;> +
> +	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
> +	if (buf_len == 0)
>  		goto out;
>  
>  	/*
>  	 * Read the concurrent positioning ranges log (0x47). We can have at
> -	 * most 255 32B range descriptors plus a 64B header.
> +	 * most 255 32B range descriptors plus a 64B header. This log varies in
> +	 * size, so use the size reported in the GPL directory. Reading beyond
> +	 * the supported length will result in an error.
>  	 */
> -	buf_len = (64 + 255 * 32 + 511) & ~511;
> +	buf_len <<= 9;
>  	buf = kzalloc(buf_len, GFP_KERNEL);
>  	if (!buf)
>  		goto out;
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 06c9d90238d9..0ea9c3115529 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2101,7 +2101,7 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
>  
>  	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
>  	rbuf[1] = 0xb9;
> -	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
> +	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
>  
>  	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
>  		desc[0] = cpr_log->cpr[i].num;

This scsi hunk needs to be a different patch with a fixes tag and cc stable.


-- 
Damien Le Moal
Western Digital Research
