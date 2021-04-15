Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87ACFC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6F561165
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 16:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhDOQm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 12:42:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35164 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhDOQm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 12:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618504925; x=1650040925;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OMUkNAfY7ePatloNoEPpTvAlKh5zC5EAXg/FPXrh/Sg=;
  b=M0+CZktzeev9LuwkwsVKGSnI3qShH1rVvPTZUJ673PCO99lQ90R/8mYv
   FhHjEC1M8b0IYMxQXhRJDPa3MN08uRcnferykRQVY18OG0mRIbE9eB3NE
   yeHtmLdSQao4a3C6HOp6iDgmM/02AdbpvvrNUGWlh6si0P6wYyZD4lpWV
   85mJv0msf7TP8qbCr3IT6FBgnVbVNcPcqF04sKwxVvrfu36Hd4yZ7o01n
   9whAWWsPYRRgHxMuvkTwNtvcOyHoduFn48aYCS1Ep1oKUAXukbLdWKm4P
   4QP5v1kxImXzGpptjQc2FysMGzcpdbP10KnhFRPf2uTIX2ACf6enARPDk
   A==;
IronPort-SDR: UNk3md10ZHpBl04lUHQj0KgzWuipyaqRvtIWwLj0Nap3JkqCRYAHN44Alj2lG4wcsPwgQBG1m1
 VYVQtGfcAQtDnPbWJYqdcURLmdSMdfiNdJ8s5dCu7ETHxk3F8hWNQN8w9WzT3fZE17YhTXScWl
 HIfNEw5MdONUWZAvrZ4Gdfn61NHDBHqE1BMajOP6gHLi8achwIO0GT2hUgK1pMbm2mOdJNEqgG
 EXmF/qmdfLRvkeILpFgbMklOZALIHSzAEmurQBR15xIetBlvS+ZbmJ/J4GI9Lfnfqsz2CtacUW
 fbg=
X-IronPort-AV: E=Sophos;i="5.82,225,1613458800"; 
   d="scan'208";a="117169982"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 09:42:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 09:42:05 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 15 Apr 2021 09:42:04 -0700
Subject: [PATCH 1/2] smartpqi: fix blocks_per_row static checker issue
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 15 Apr 2021 11:42:04 -0500
Message-ID: <161850492435.7302.392780350442938047.stgit@brunhilda>
In-Reply-To: <161850488487.7302.7018870513204678832.stgit@brunhilda>
References: <161850488487.7302.7018870513204678832.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dan Carpenter found a possible divide by 0 issue in the smartpqi driver
in functions pci_get_aio_common_raid_map_values and
pqi_calc_aio_r5_or_r6.  The variable rmd->blocks_per_row is
used as a divisor and could be 0.

Link: https://lore.kernel.org/linux-scsi/YG%2F5kWHHAr7w5dU5@mwanda/
Fixes: 6702d2c40f31 ("scsi: smartpqi: Add support for RAID5 and RAID6 writes")
       Using rmd->blocks_per_row as a divisor without checking
       it for 0 first.

Correct these possible divide by 0 conditions by insuring that
rmd->blocks_per_row is not zero before usage.
The check for non-0 was too late to prevent a divide by 0 condition.
Add in a comment to explain why the check for non-zero
is necessary. If the member is 0, return PQI_RAID_BYPASS_INELIGIBLE
before any division is performed.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b0f281daa2b..797ac699b7ff 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2510,6 +2510,8 @@ static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
 
 	/* Calculate stripe information for the request. */
 	rmd->blocks_per_row = rmd->data_disks_per_row * rmd->strip_size;
+	if (rmd->blocks_per_row == 0) /* Used as a divisor in many calculations */
+		return PQI_RAID_BYPASS_INELIGIBLE;
 #if BITS_PER_LONG == 32
 	tmpdiv = rmd->first_block;
 	do_div(tmpdiv, rmd->blocks_per_row);
@@ -2559,6 +2561,10 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 #if BITS_PER_LONG == 32
 	u64 tmpdiv;
 #endif
+
+	if (rmd->blocks_per_row == 0) /* Used as a divisor in many calculations */
+		return PQI_RAID_BYPASS_INELIGIBLE;
+
 	/* RAID 50/60 */
 	/* Verify first and last block are in same RAID group. */
 	rmd->stripesize = rmd->blocks_per_row * rmd->layout_map_count;
@@ -2662,8 +2668,6 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 			rmd->q_parity_it_nexus = raid_map->disk_data[index + 1].aio_handle;
 			rmd->xor_mult = raid_map->disk_data[rmd->map_index].xor_mult[1];
 		}
-		if (rmd->blocks_per_row == 0)
-			return PQI_RAID_BYPASS_INELIGIBLE;
 #if BITS_PER_LONG == 32
 		tmpdiv = rmd->first_block;
 		do_div(tmpdiv, rmd->blocks_per_row);

