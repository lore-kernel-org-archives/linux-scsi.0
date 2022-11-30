Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E46C47088
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 08:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiK3Ije (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 03:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiK3Ijd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 03:39:33 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1A3264AE
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 00:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669797571; x=1701333571;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zja+LbzYcnF6BQtQTskwMRlkiXgPBiT+s3IzI+yyHjg=;
  b=TK86O57dohGHos96vMoek+7yJKb0Uwufog9lar0MeaRDSpbsctNqBFVc
   d2ggiFNztz3Eq5E+ZQjMBC9iLJU19WsRpA8nsE5mUOEB8vS/4+oyZEX+6
   KbPiGAES+Rrdm/Pp6Fwh2uKMpmnkKbbeohXuQpZ8F3BKNW35DXycRzso8
   uRtPSSkEb7q2L8hfuc7MuqFKrR4pFp56x+qWFQBT2MyAKMgIanF35PkGy
   VCOyFCo9xnacyhfqTreooSt9evGMu9xXOaM4FkYBfWMUAFfohhMtyF7aM
   U0XoqjrkvMGzrkhDsv7yNGmxH3975CyHLXmq1gHdKgNo+1gocFODbBNRn
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665417600"; 
   d="scan'208";a="329635178"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 16:39:31 +0800
IronPort-SDR: s9ENqsMyGQOQOMjAJaDI91vKK+MpnLuJG5jZBP8qwuNo7ATi2bEbaYmcZvXK32LUc8KlxkpJab
 Us6YDQ+gCZncuLpKbJvS1JLTDc4KYFwCHQeNPBXxHFch67g6dsiX7K6BbkMXQVAoJioOOJY+rC
 v31yYhAKpetMnX1f3LT8Oer87UPfffpB0EtDAMaW9Qt+9xPpmZBESeUsyWQRaqa2xxkdXzEtaG
 aXms4qybYEh0Zpil0ylC28HeWzSZuBI+0jkXCqlkNR665A35cJDGo2oW8seylyywwR5duN+qXX
 SlY=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Nov 2022 23:58:10 -0800
IronPort-SDR: 0Q9kjnvtSik4yIsjv1DDmb2AhjekZElK3QORtkAU5tLSTfV2fNo5CBT/L4hmizVIwPO4nercnd
 AVfZOJMG1AZ9iK8poUHnml/PIryrMgnxSaeQoQ5M0MHh/EvgJu2Kzk93e9eSs2jhu/fPc/C16l
 wpMEyzlPv17ZYRRV1jOUEpZLb6VkpjN8gtjbiWIgzVWKfAtEbFpm10wusJtlFUmsCMm7Gkn3Yd
 g7e/jxDjSjLPdb1Mk+HgGmsypNq6f81XD6dLl+tYMoyzXQwdZ3o/OqFcCTVxRjL4ozjmrhfDSP
 K3k=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Nov 2022 00:39:31 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Date:   Wed, 30 Nov 2022 00:39:21 -0800
Message-Id: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
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
Changes to v3:
- Move tracepoints into own sd trace events header

Changes to v2:
- Fix linking when SCSI is a module

Changes to v1:
- Fix style issues pointed out by Damien
---
 drivers/scsi/scsi_trace.c |  1 +
 drivers/scsi/sd_zbc.c     |  6 +++
 include/trace/events/sd.h | 81 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)
 create mode 100644 include/trace/events/sd.h

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..224b38c0fb0f 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -389,3 +389,4 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_misc(p, cdb, len);
 	}
 }
+EXPORT_SYMBOL(scsi_trace_parse_cdb);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..8985681cffbd 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -18,6 +18,9 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/sd.h>
+
 #include "sd.h"
 
 /**
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
diff --git a/include/trace/events/sd.h b/include/trace/events/sd.h
new file mode 100644
index 000000000000..0b11fed8327b
--- /dev/null
+++ b/include/trace/events/sd.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Western Digital Corporation or its affiliates.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sd
+
+#if !defined(_SD_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
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
+#include <trace/define_trace.h>
+
-- 
2.38.1

