Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE90C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 06:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiK3G6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 01:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiK3G6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 01:58:19 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CAF14D17
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2022 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669791498; x=1701327498;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FPmVFUiYTm38VIQnGOC1TKTq1WSRDBX3LDeTs6NEzZI=;
  b=pwvL8gDKknTISkfQNOz6WfTrPwtpMtXyA2+k5q2W96/hRZtVNT4Gr0i8
   uQRurf5gwuPdKHb12N1nA7G/Kk+vXnHzrwCPmyjvt2KuCqFdxeHkZq2po
   VzGWHnlf55GuAmueM+7odBv9/UQzOf/6G6NxnWgteCvb6cSBRev0q/+P8
   0YVlSVvXHsS263HQPw1HYG98h4/SfDF7Ovz/h/moR1/eXilSwTQAyKOTA
   rMCbDPEfmvf6x2GbiEixbbZwU4AFe2IhpCofFoYJFzYTAS46kjQFf6yI6
   XTSBR2mG364rloeuDOtmTsmtSc0Lz3Jv0WPU6YMI7QJa49JSkdlWsvgsw
   w==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665417600"; 
   d="scan'208";a="222683305"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 14:58:18 +0800
IronPort-SDR: aicZxQrFwrVmSQvpDUy1kMHQ11+MdeJs1Yw0Qib3ABx8w4VRSEgHywzeT6tr9Z0mGCfDWNZnyD
 UGNqwUrGzzUzWG+i6EugDVHSxCXSn5s5x0Nfbs0CBxfqIsNOSFGs9NskUw+A0kaNO6euXO//s1
 /vuw3ITO1NbY4Y2ZRbK+rjxXTYtCug1x8XtaZChELem/cbU9upAluuuyd55rbZYLcYfredKtwY
 BtEypaHU6h5o4Oui/PW0jo8RUaEOaps5y0v9P67PzmgCWPxEpz5a7PJOW7LoLzeRPpt/wMokdK
 pig=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Nov 2022 22:16:57 -0800
IronPort-SDR: tNoJaVyJAY9U+buIpK4v0xMRlpGujuZCXE3GKWUogGuX0RqHZBNftbpmmILip+3BJmNCYL6ngX
 VBh/4fgqZL1gorDUlJKyUAfNCSdqOMLL6eja2K1jRL/ALPKRYdbkO2gGqAUFv6rLzHIRFoVYyt
 GHeFDRyPwdGMFYnuGVWCMl6VL7g36dGjj0zZf1fVB6mHGwNS/EjW2EQ61K64YGez1ETGvy151h
 CTxvMZ0uIMGIyXhHXix4RoDhTLLPMbK+Gqjh8NaBqeuUYAcZKK3ySScZDIZ7hjlZDo1qfggrUi
 rus=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Nov 2022 22:58:17 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3] scsi: sd_zbc: trace zone append emulation
Date:   Tue, 29 Nov 2022 22:58:09 -0800
Message-Id: <53f2e206d85b99e8e2f2519beefc3e67262af67a.1669791411.git.johannes.thumshirn@wdc.com>
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
Changes to v2:
- Fix linking when SCSI is a module

Changes to v1:
- Fix style issues pointed out by Damien
---
 drivers/scsi/scsi_trace.c   |  1 +
 drivers/scsi/sd_zbc.c       |  8 +++++
 include/trace/events/scsi.h | 64 +++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

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
index bd15624c6322..7f4169829ff4 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -18,6 +18,11 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
+#if IS_MODULE(CONFIG_BLK_DEV_SD)
+#define CREATE_TRACE_POINTS
+#endif
+#include <trace/events/scsi.h>
+
 #include "sd.h"
 
 /**
@@ -450,6 +455,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 			break;
 		}
 
+		trace_scsi_prepare_zone_append(cmd, *lba, wp_offset);
 		*lba += wp_offset;
 	}
 	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
@@ -558,6 +564,8 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 
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
2.38.1

