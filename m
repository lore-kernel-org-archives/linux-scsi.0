Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DB5C6FA83
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 09:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiIXJtt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 05:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiIXJts (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 05:49:48 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCE1EAD2;
        Sat, 24 Sep 2022 02:49:44 -0700 (PDT)
Received: from [192.168.1.103] (178.176.77.229) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Sat, 24 Sep
 2022 12:49:33 +0300
Subject: Re: [PATCH 2/2] ata: libata-sata: Fix device queue depth control
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
References: <20220924062907.959856-1-damien.lemoal@opensource.wdc.com>
 <20220924062907.959856-3-damien.lemoal@opensource.wdc.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b1595afb-49cd-2e19-1b5f-bfbe9836784e@omp.ru>
Date:   Sat, 24 Sep 2022 12:49:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220924062907.959856-3-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.77.229]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/24/2022 09:23:18
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 172871 [Sep 23 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 499 499 6614d57ea7c6ac2e38ef0272e2cc77f73b9aae18
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_phishing_log_reg_50_60}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.77.229 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;omp.ru:7.1.1;178.176.77.229:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.77.229
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/24/2022 09:27:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/24/2022 4:23:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 9/24/22 9:29 AM, Damien Le Moal wrote:

> The function __ata_change_queue_depth() uses the helper
> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
> set that device maximum queue depth. However, when the ata device is
> managed by libsas, ata_scsi_find_dev() return NULL, turning

   Returns?

> __ata_change_queue_depth() into a nop, which prevents the user from
> setting the maximum queue depth of ATA devices used with libsas based
> HBAs.
> 
> Fix this by renaming __ata_change_queue_depth() to
> ata_change_queue_depth() and adding a pointer to the ata_device
> structure of the target device as argument. This pointer is provided by
> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case ofi

   Of?

> a libata managed device and by sas_change_queue_depth() using
> sas_to_ata_dev() in the case of a libsas managed ata device.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[...]

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index ff9602a0e54e..c63bb50323c1 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1101,6 +1101,11 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>  	if (dev->flags & ATA_DFLAG_AN)
>  		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>  
> +	pr_info("#### can queue %d, ata qd %d, scsi qd %d\n",

    Hm... isn't this a debugging pr_info() call you forgot to remove?

> +		sdev->host->can_queue,
> +		ata_id_queue_depth(dev->id),
> +		sdev->queue_depth);
> +
>  	if (dev->flags & ATA_DFLAG_NCQ)
>  		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>  	depth = min(ATA_MAX_QUEUE, depth);
[...]

MBR, Sergey
