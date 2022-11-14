Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFC1C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 12:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiKNMD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 07:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbiKNMDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 07:03:00 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2823320197
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 04:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668427288; x=1699963288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cySra5ZhyL8yz4/lFjAJI73FPZDxoI6AjlsY6huWtuA=;
  b=VzffZE78gV/9kuw9xuefv3kYURGv6BlomnE2mPBj4pYRsZ8qDwDHA0LS
   wNKnUmFJScH7bpawPx0By/VrEs8RqWfHHGHJnK0y2mXhLKq81X5cYzK3Z
   LXX8BIijVmO45yal6oWzQtw0VOneXcViXVbRhllODEPEUrI/dtjblfKNp
   y5z0bX4yKUvCX0tfPXen4KsYaRDg4ehWPvBu042dIsC7wHZivFauPgcoA
   aLZ/nN6Pv6GtUe4FYXLvLljsblYsFom15eJaACHpm9LTHE++bSVoAffoc
   ra0AFOFL7wE0JmxTRxrFTC6gRFkpynM+l2M4a8b6i86EkLQYfHk+a9qM9
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665417600"; 
   d="scan'208";a="221375750"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2022 20:01:28 +0800
IronPort-SDR: FAtAFf4lT8KmInBsgpX8QA65k8QVxL9FJfKPJ2GVGxcNHM0ZI3T+KHzAFBb2Xb4aVQrse1Wqx0
 uh1w4CnDWYblWVnTUP8uGGCQlriRVFiFJqU8qNGOY5/rpXwSn8OLk32NITkdW2l0yuYVVP9Wj3
 2XHY4d9BAB7IMHdOvi9VSGiO1LfRhpTq59PImjvpbxn3+7RChbsOkfL0zfjKEcdmgrDZ7CSdFA
 3vSIf95Tm6gOwgxpdXsjmUrUMckZhv85gUyhc96F+7eSDmliDi9FkFTCEKMvsSBdZWwj/1WUrx
 P08=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Nov 2022 03:20:26 -0800
IronPort-SDR: 4lkQWIHIxegDgI4Z+pEG07xfpT5iibUhBbW7JyVwtLHDcSiyoizqvAbm7H1LoipBVWBqYDwqQX
 4hT8RBzxJAsIpzgq5rq0bDCX4nglXUnG2s69jP7r4Y7OvynZVXyAyIPCSCM0PGbMNXwj93lst8
 BBz4pOJDHaoZVlCy1TZQI9vT6H0HFTufHveMucaZYg9kScG8J0sEotxvsBvQwsueKUe/CMGIaq
 aZAiQ5IQfcNxaBmRXWGNylHM8FNMBj47iWQoxaT5qOnah7CoF1KPAW1BA7YfJB1FS68GvC3n1s
 X8A=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 Nov 2022 04:01:26 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Date:   Mon, 14 Nov 2022 04:01:18 -0800
Message-Id: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

---
Changes to v1:
- Fix style issues pointed out by Damien
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
index a2c7befd451a..851b89e1c811 100644
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
+
 #endif /*  _TRACE_SCSI_H */
 
 /* This part must be outside protection */
-- 
2.37.3

