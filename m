From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 15/17] scsi_transport_srp: Suppress a W=1 compiler warning
Date: Fri, 25 Aug 2017 13:46:41 -0700
Message-ID: <20170825204643.25043-16-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29708 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbdHYUsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:48:40 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

Avoid that the following compiler warning is reported when building
with W=1:

drivers/scsi/scsi_transport_srp.c:92:19: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 include/scsi/scsi_transport_srp.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 698cc4681706..4f6f01cf9968 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -78,7 +78,7 @@ static inline struct srp_rport *shost_to_rport(struct Scsi_Host *shost)
  * parameters must be such that multipath can detect failed paths timely.
  * Hence do not allow all three parameters to be disabled simultaneously.
  */
-int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
+int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, long dev_loss_tmo)
 {
 	if (reconnect_delay < 0 && fast_io_fail_tmo < 0 && dev_loss_tmo < 0)
 		return -EINVAL;
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index dd096330734e..56ae198acc73 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -111,7 +111,7 @@ extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
 extern int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo,
-			 int dev_loss_tmo);
+			 long dev_loss_tmo);
 int srp_parse_tmo(int *tmo, const char *buf);
 extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
-- 
2.14.1
