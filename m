Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E03FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350053AbiFAKo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbiFAKoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 06:44:23 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jun 2022 03:44:20 PDT
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6727CB4E;
        Wed,  1 Jun 2022 03:44:20 -0700 (PDT)
Received: from [192.168.1.103] (31.173.86.38) by msexch01.omp.ru (10.188.4.12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Wed, 1 Jun 2022
 13:29:11 +0300
Subject: Re: [PATCH 1/2] [PATCH v1 1/2] libata: fix reading concurrent
 positioning ranges log
To:     Tyler Erickson <tyler.erickson@seagate.com>,
        <damien.lemoal@opensource.wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <muhammad.ahmad@seagate.com>,
        Tyler Erickson <tyler.j.erickson@seagate.com>,
        Michael English <michael.english@seagate.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
 <20220531175009.850-2-tyler.erickson@seagate.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <1051b626-63a5-5a97-e3c5-4d89e1f7a229@omp.ru>
Date:   Wed, 1 Jun 2022 13:29:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220531175009.850-2-tyler.erickson@seagate.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.173.86.38]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/01/2022 10:09:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 170829 [Jun 01 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 480 480 261f383ad0914b4f7c346116c50b8459e26206b6
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.86.38 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.86.38 in (user) dbl.spamhaus.org}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: {fromrtbl complete}
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.173.86.38
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=none header.from=omp.ru;spf=none
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/01/2022 10:12:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 6/1/2022 8:40:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 5/31/22 8:50 PM, Tyler Erickson wrote:

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

   Maybe *unsigned int*? The 'buf_len' variable below is 'size_t' which is *unsigned* type...

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
> +		goto out;
> +
> +	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
> +	if (buf_len == 0)
>  		goto out;
[...]

MBR, Sergey
