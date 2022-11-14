Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F2EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 11:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiKNL03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiKNL0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 06:26:12 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CC7B92
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 03:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668424982; x=1699960982;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UhX+lK+NBUxNnBvuyP/67fIuEYgdFxFXIQTYbix1mvI=;
  b=NdOACHAInh1kbeFsW7yeoftERsOo6pOqsCqWzmbynbTXSv7NxT3wMA8B
   DNV0gTUEXhIpaPuZ9q7XXNEDTqKKHK0bYeqLv7B04Q1PqqLNyYTYE9pWK
   WNgyovoONurGQzPwcLVcvjB7UPOh2JTubb5c5wPHA98ez+6ZPRrgZYBE/
   dfiIW5/LfZWO3ykwjTV80YXww9Bj8xggcmQq39/NdWTRN5EeIIDH1T/Dz
   Et8K/LWuJKLPg+xdlhhjdb0zRt1HfZgIyAhyz1oU4wV5hReFlGPvR9Ghf
   Tj1RYwzUA+n17IlZJq4mkWKzLON+P559pJR2NV22Y7g7OVS8eWaucHQUF
   A==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="221373410"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 19:23:01 +0800
IronPort-SDR: 2r1rfu65PKEDt1XXGJxQXrvIYr7rbRQTaQJej3zu2H3joQ3BQlLb8dUZLdrIxJPPBEpTDND/E6
 2MsukTFfQ7Brd9UAEeKwoP9SIpSgH3bj2460ZyrS0vURtLbe9E/xLoQj8i85Gt/vhuD9QJaQZG
 P/YjGSDGfJyCQE7zqMek6bKy9kc3Om2SzC//yElhHDLe/mx1fxL7JN3F1IvyOilnBFrGiENs7Y
 obY/Y0ps75sWtAZVccl572VAtYoLl0SKUf4uQ4W52K0Mbik3xS93kMfUIR4IdvP/bcsXsHlzua
 FZQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Nov 2022 02:36:16 -0800
IronPort-SDR: WutOMhVkpXZ0sav+EHDvynDlREaU5VFssneVAxf4dw5tyqzE/xohsw+qxh4XHvVPVI5z68BGZh
 7t/tqS4uElOgH1RZ2642POlNYyv0AldUiB90kOSAS206gBNbx5T1QQaDNtu8nuzc2wX0OmDoqm
 mvAhs54MWhDuQDsYBkRFn/EoqYzoOlV2pl7JrmTTpiQQUbvwl0QmjXEbHIBPhyGkNtbHWO04Ow
 G3aRyFgrhZreWvqdAQoIWNm8WUMQEpuZ8CwJeaiMunSwcDEIcYW6rPohY0dBu12aAfmtDauEs5
 6x8=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 Nov 2022 03:23:00 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: sd_zbc: trace zone append emulation
Date:   Mon, 14 Nov 2022 03:22:53 -0800
Message-Id: <278ba0682187eae377f39f2c6646706c388df17b.1668415091.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.37.3
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
 drivers/scsi/sd_zbc.c       |  5 +++
 include/trace/events/scsi.h | 64 +++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..956d1982c51b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -18,6 +18,8 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
+#include <trace/events/scsi.h>
+
 #include "sd.h"
 
 /**
@@ -450,6 +452,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 			break;
 		}
 
+		trace_scsi_prepare_zone_append(cmd, *lba, wp_offset);
 		*lba += wp_offset;
 	}
 	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
@@ -558,6 +561,8 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 
 	switch (op) {
 	case REQ_OP_ZONE_APPEND:
+		trace_scsi_zone_wp_update(cmd, rq->__sector,
+				  sdkp->zones_wp_offset[zno], good_bytes);
 		rq->__sector += sdkp->zones_wp_offset[zno];
 		fallthrough;
 	case REQ_OP_WRITE_ZEROES:
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index a2c7befd451a..50d36aa417cc 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -327,6 +327,70 @@ TRACE_EVENT(scsi_eh_wakeup,
 	TP_printk("host_no=%u", __entry->host_no)
 );
 
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
+		     __field( sector_t, lba )
+		     __field( unsigned int, wp_offset)
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
+		     __field( sector_t, rq_sector )
+		     __field( unsigned int, wp_offset)
+		     __field( unsigned int, good_bytes)
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
+
 #endif /*  _TRACE_SCSI_H */
 
 /* This part must be outside protection */
-- 
2.37.3

