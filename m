From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/10] zfcp: Use correct width for timer_interval field
Date: Fri, 16 Jul 2010 15:37:36 +0200
Message-ID: <20100716134300.146501000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:42876 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965477Ab0GPNnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:02 -0400
Content-Disposition: inline; filename=706-zfcp-timer-interval.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The timer_interval is 14 bits in width. Introduce a define for
properly masking the value.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -495,7 +495,7 @@ static int zfcp_fsf_exchange_config_eval
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
 	adapter->hydra_version = bottom->adapter_type;
-	adapter->timer_ticks = bottom->timer_interval;
+	adapter->timer_ticks = bottom->timer_interval & ZFCP_FSF_TIMER_INT_MASK;
 	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
 					 (u16)FSF_STATUS_READS_RECOM);
 
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -352,6 +352,8 @@ struct fsf_qtcb_bottom_support {
 	u8  els[256];
 } __attribute__ ((packed));
 
+#define ZFCP_FSF_TIMER_INT_MASK	0x3FFF
+
 struct fsf_qtcb_bottom_config {
 	u32 lic_version;
 	u32 feature_selection;

