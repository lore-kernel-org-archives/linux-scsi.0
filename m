Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D202C197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 08:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjKTIv1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 03:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjKTIvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 03:51:25 -0500
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF04DA2;
        Mon, 20 Nov 2023 00:51:20 -0800 (PST)
Received: from [192.168.1.103] (31.173.86.165) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 20 Nov
 2023 11:51:05 +0300
Subject: Re: [PATCH 2/2] scsi: sd: fix system start for ATA devices
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
References: <20231120073522.34180-1-dlemoal@kernel.org>
 <20231120073522.34180-3-dlemoal@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <a3008d49-32db-51cc-f9aa-ca9ec91ec14d@omp.ru>
Date:   Mon, 20 Nov 2023 11:50:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20231120073522.34180-3-dlemoal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.173.86.165]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.0.0, Database issued on: 11/20/2023 08:21:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 181469 [Nov 20 2023]
X-KSE-AntiSpam-Info: Version: 6.0.0.2
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.173.86.165
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/20/2023 08:25:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11/20/2023 7:13:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/23 10:35 AM, Damien Le Moal wrote:

> Ti is not always possible to keep a device in the runtime suspended

   s/Ti/It? :-)

> state when a system level suspend/resume cycle is executed. E.g. for ATA
> devices connected to AHCI  adapters, system resume resets the ATA ports,
> which causes connected devices to spin up. In such case, a runtime
> suspended disk will incorrectly be seen with a suspended runtime state
> because the device is not resumed by sd_resume_system(). The power state
> seen by the user is different than the actual device physical power
> state.
> 
> Fix this issue by introducing the struct scsi_device flag
> force_runtime_start_on_system_start. When set, this flag causes
> sd_resume_system() to request a runtime resume operation for runtime
> suspended devices. This results in the user seeing the device
> runtime_state as active after a system resume, thus correctly reflecting
> the device physical power state.
> 
> Fixes: 9131bff6a9f1 ("scsi: core: pm: Only runtime resume if necessary")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[...]

MBR, Sergey
