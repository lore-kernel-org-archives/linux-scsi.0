Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BC0C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiK3Kgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiK3Kg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:36:29 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB96046674
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669804588; x=1701340588;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aaN/TCcDcEMrsfundSGzEqGZfHbmcd18C1rNf576Cz8=;
  b=PhCXxO9DXupZrPZSXEf4b/HBcRK+0h9XtXiY8Em6wys5sT6S/dudNt5R
   yZQyjbKVJ02mnyYaS6kNnkN0n91n2+jCLbuxIwWeeJT+CJ+elolbqGcCd
   a6bB/LvnMJ9iWCYwr1BmzWDFHu2FadfZTgCjzdL7ArfgU9xEim15kgoMx
   UJwTd2BWuy3sunFnwbcxb5Zyau4p/7vuN+9mHI/gFjk8S3fN5VJr9HFNh
   46l7ofJfT5GZrr0AXdtIM89J81I6FJnNHp4cIyKUIU3Q1nHrKVa4siD9h
   aQsZnLWPYkI3XmvOXXscAM9mDv8Dhx8/97bYzwqH0FOnhmVVBDxlRX20D
   w==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="215774492"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 18:36:28 +0800
IronPort-SDR: kCLva7zFGfEEfk/JzUj1G4Irkhb0lGpFeRAxpq2gN7L7nQ6SlNz+lXXysCNuzBTfXzVLNXyohN
 lYuYJ5rbYLE5rlYjwWAYIRMl+2hF2YffzvRUkz3f03YBkc5L8jBYz7+2vJl9L19LW/UoZPMO6m
 QaXKyceM6wMA4DAvu5Bsi7rbkXiQum0LuVhWh48ilAT6VW4C5zK0coYaDmrLqVyw4KpxRA6Hi0
 LZ44RF9TEwE7JUgb4PJHqpd8DQrLYY/1tE1foFe0U9rMHG0qGzlJmAUTT60HBVyzUHNRR1WoHd
 Tq0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Nov 2022 01:55:07 -0800
IronPort-SDR: JthIX5vRhOuhaDnRaMmQ9oLMpbaYbiDJWWn6xcH6xu20RiKpabN6G93Tp466gGpIMWQs/WWigh
 hBrZopO9JhG0e6KmlI1dj9b0h9l+69/MzzuE1iyrruqCybrMUgTXIj4deBseak/pAkUzlPbjCR
 iw5CjyB/uTCx7qRJ4RKpZv3P3y7HANlJN8y9rANDzdyRZg8RPrGV9lhWqE37bFfMk5dMGeO5gM
 SfL3HhWov34mi2KWE+sCG+32sZB1kRrjF499a7PgCJKnoxRKNLjzi9NHF0kMFoNUxK717qMxr5
 o5E=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
  by uls-op-cesaip02.wdc.com with ESMTP; 30 Nov 2022 02:36:27 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5] scsi: sd_zbc: trace zone append emulation
Date:   Wed, 30 Nov 2022 02:36:16 -0800
Message-Id: <d103bcf5f90139143469f2a0084c74bd9e03ad4a.1669804487.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add tracepoints to the SCSI zone append emulation, in order to trace the
zone start to write-pointer aligned LBA translation and the corresponding
completion.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

---
Changes to v4:
- Move tracepoint header to drivers/scsi

Changes to v3:
- Move tracepoints into own sd trace events header

Changes to v2:
- Fix linking when SCSI is a module

Changes to v1:
- Fix style issues pointed out by Damien
---
 drivers/scsi/sd_trace.h | 85 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd_zbc.c   |  6 +++
 2 files changed, 91 insertions(+)
 create mode 100644 drivers/scsi/sd_trace.h

diff --git a/drivers/scsi/sd_trace.h b/drivers/scsi/sd_trace.h
new file mode 100644
index 000000000000..69350c2f67d1
--- /dev/null
+++ b/drivers/scsi/sd_trace.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Western Digital Corporation or its affiliates.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sd
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE sd_trace
+
+#if !defined(_SD_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(scsi_prepare_zone_append,
+
+	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t lba,
+		     unsigned int wp_offset),
+
+	    TP_ARGS(cmnd, lba, wp_offset),
+
+	    TP_STRUCT__entry(
+		     __field( unsigned int, host_no )
+		     __field( unsigned int, channel )
+		     __field( unsigned int, id )
+		     __field( unsigned int, lun )
+		     __field( sector_t,     lba )
+		     __field( unsigned int, wp_offset )
+	    ),
+
+	    TP_fast_assign(
+		__entry->host_no	= cmnd->device->host->host_no;
+		__entry->channel	= cmnd->device->channel;
+		__entry->id		= cmnd->device->id;
+		__entry->lun		= cmnd->device->lun;
+		__entry->lba		= lba;
+		__entry->wp_offset	= wp_offset;
+	    ),
+
+	    TP_printk("host_no=%u, channel=%u id=%u lun=%u lba=%llu wp_offset=%u",
+		      __entry->host_no, __entry->channel, __entry->id,
+		      __entry->lun, __entry->lba, __entry->wp_offset)
+);
+
+TRACE_EVENT(scsi_zone_wp_update,
+
+	    TP_PROTO(struct scsi_cmnd *cmnd, sector_t rq_sector,
+		     unsigned int wp_offset, unsigned int good_bytes),
+
+	    TP_ARGS(cmnd, rq_sector, wp_offset, good_bytes),
+
+	    TP_STRUCT__entry(
+		     __field( unsigned int, host_no )
+		     __field( unsigned int, channel )
+		     __field( unsigned int, id )
+		     __field( unsigned int, lun )
+		     __field( sector_t,     rq_sector )
+		     __field( unsigned int, wp_offset )
+		     __field( unsigned int, good_bytes )
+	    ),
+
+	    TP_fast_assign(
+		__entry->host_no	= cmnd->device->host->host_no;
+		__entry->channel	= cmnd->device->channel;
+		__entry->id		= cmnd->device->id;
+		__entry->lun		= cmnd->device->lun;
+		__entry->rq_sector	= rq_sector;
+		__entry->wp_offset	= wp_offset;
+		__entry->good_bytes	= good_bytes;
+	    ),
+
+	    TP_printk("host_no=%u, channel=%u id=%u lun=%u rq_sector=%llu" \
+		      " wp_offset=%u good_bytes=%u",
+		      __entry->host_no, __entry->channel, __entry->id,
+		      __entry->lun, __entry->rq_sector, __entry->wp_offset,
+		      __entry->good_bytes)
+);
+#endif /* _SD_TRACE_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/scsi
+#include <trace/define_trace.h>
+
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..a039245a8a5e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -20,6 +20,9 @@
 
 #include "sd.h"
 
+#define CREATE_TRACE_POINTS
+#include "sd_trace.h"
+
 /**
  * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
  * @zone: Zone for which to return the write pointer offset.
@@ -450,6 +453,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 			break;
 		}
 
+		trace_scsi_prepare_zone_append(cmd, *lba, wp_offset);
 		*lba += wp_offset;
 	}
 	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
@@ -558,6 +562,8 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 
 	switch (op) {
 	case REQ_OP_ZONE_APPEND:
+		trace_scsi_zone_wp_update(cmd, rq->__sector,
+				  sdkp->zones_wp_offset[zno], good_bytes);
 		rq->__sector += sdkp->zones_wp_offset[zno];
 		fallthrough;
 	case REQ_OP_WRITE_ZEROES:
-- 
2.38.1

