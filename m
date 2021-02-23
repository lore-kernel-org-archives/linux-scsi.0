Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8295C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 15:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8234564E60
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 15:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhBWPzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 10:55:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:42778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233349AbhBWPzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Feb 2021 10:55:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F057CAC1D;
        Tue, 23 Feb 2021 15:54:24 +0000 (UTC)
Date:   Tue, 23 Feb 2021 12:54:22 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] scsi: smartpqi: create module parameters for LUN
 reset
Message-ID: <20210223155422.d7x5zm5ozot6dmaq@hyori>
References: <20210121170339.11891-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210121170339.11891-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 01/21, Enzo Matsumiya wrote:
>Commit c2922f174fa0 ("scsi: smartpqi: fix LUN reset when fw bkgnd thread is hung")
>added support for a timeout on LUN resets.
>
>However, when there are 2 or more devices connected to the same
>controller and you hot-remove one of them, I/O will stall on the
>devices still online for PQI_LUN_RESET_RETRIES * PQI_LUN_RESET_RETRY_INTERVAL_MSECS
>miliseconds.
>
>This commit makes those values configurable via module parameters.
>
>Changing the bail out condition on rc in _pqi_device_reset() might be possible,
>but could also break the original purpose of commit c2922f174fa0.
>
>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>---
> drivers/scsi/smartpqi/smartpqi_init.c | 18 ++++++++++++++----
> 1 file changed, 14 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
>index c53f456fbd09..9835b2e5b91a 100644
>--- a/drivers/scsi/smartpqi/smartpqi_init.c
>+++ b/drivers/scsi/smartpqi/smartpqi_init.c
>@@ -157,6 +157,18 @@ module_param_named(hide_vsep,
> MODULE_PARM_DESC(hide_vsep,
> 	"Hide the virtual SEP for direct attached drives.");
>
>+static int pqi_lun_reset_retries = 3;
>+module_param_named(lun_reset_retries,
>+	pqi_lun_reset_retries, int, 0644);
>+MODULE_PARM_DESC(lun_reset_retries,
>+	"Number of retries when resetting a LUN");
>+
>+static int pqi_lun_reset_tmo_interval = 10000;
>+module_param_named(lun_reset_tmo_interval,
>+	pqi_lun_reset_tmo_interval, int, 0644);
>+MODULE_PARM_DESC(lun_reset_tmo_interval,
>+	"LUN reset timeout interval (in miliseconds)");
>+
> static char *raid_levels[] = {
> 	"RAID-0",
> 	"RAID-4",
>@@ -5687,8 +5699,6 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
>
> /* Performs a reset at the LUN level. */
>
>-#define PQI_LUN_RESET_RETRIES			3
>-#define PQI_LUN_RESET_RETRY_INTERVAL_MSECS	10000
> #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS	120
>
> static int _pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
>@@ -5700,9 +5710,9 @@ static int _pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
>
> 	for (retries = 0;;) {
> 		rc = pqi_lun_reset(ctrl_info, device);
>-		if (rc == 0 || ++retries > PQI_LUN_RESET_RETRIES)
>+		if (rc == 0 || ++retries > pqi_lun_reset_retries)
> 			break;
>-		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
>+		msleep(pqi_lun_reset_tmo_interval);
> 	}
>
> 	timeout_secs = rc ? PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS : NO_TIMEOUT;
>-- 
>2.30.0
>

Can anyone give me some feedback on this please?


Cheers,

Enzo
