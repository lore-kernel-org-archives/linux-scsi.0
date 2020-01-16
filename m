Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4A8C33CB1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC4D220663
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgAPL5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:57:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8743 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726045AbgAPL5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 06:57:04 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8E698F5D170390AB16E8;
        Thu, 16 Jan 2020 19:57:00 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 19:56:50 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH 3/3] scsi: aic7xxx: remove set but not used variable 'targ'
Date:   Thu, 16 Jan 2020 19:56:03 +0800
Message-ID: <20200116115603.25386-4-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200116115603.25386-1-yukuai3@huawei.com>
References: <20200116115603.25386-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_send_async’:
drivers/scsi/aic7xxx/aic7xxx_osm.c:1611:28: warning: variable
‘targ’ set but not used [-Wunused-but-set-variable]

It is never used, and so can be removed. In this case
scsi_transport_target_data() can be removed because of no caller exist.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |  2 --
 include/scsi/scsi_transport.h      | 10 +---------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2cda0736c989..33fc55c6b2f4 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1600,7 +1600,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 	case AC_TRANSFER_NEG:
 	{
 		struct	scsi_target *starget;
-		struct	ahc_linux_target *targ;
 		struct	ahc_initiator_tinfo *tinfo;
 		struct	ahc_tmode_tstate *tstate;
 		int	target_offset;
@@ -1634,7 +1633,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 		starget = ahc->platform_data->starget[target_offset];
 		if (starget == NULL)
 			break;
-		targ = scsi_transport_target_data(starget);
 
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index a0458bda3148..2cffdb34721d 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* 
+/*
  *  Transport specific attributes.
  *
  *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
@@ -68,14 +68,6 @@ scsi_transport_reserve_device(struct scsi_transport_template * t, int space)
 	t->device_size = t->device_private_offset + space;
 }
 static inline void *
-scsi_transport_target_data(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	return (u8 *)starget->starget_data
-		+ shost->transportt->target_private_offset;
-
-}
-static inline void *
 scsi_transport_device_data(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
-- 
2.17.2

