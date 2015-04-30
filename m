From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/12] scsi_transport_srp: Reduce failover time
Date: Thu, 30 Apr 2015 10:59:45 +0200
Message-ID: <5541EF01.3030008@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:54248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbbD3I7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 04:59:55 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Unlike FC, there is no risk that SCSI devices will be offlined
by the error handler if it is started while a reconnect attempt
is ongoing. Hence report timeout errors as soon as possible
if a higher software layer (e.g. multipathd) needs to be informed
about a timeout. It is assumed that if both fast_io_fail_tmo < 0
and rport->dev_loss_tmo < 0 that this means that there is no
need to report timeouts quickly.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 4a44337..6667c2b 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -61,6 +61,11 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
 	return dev_to_shost(r->dev.parent);
 }
 
+static inline struct srp_rport *shost_to_rport(struct Scsi_Host *shost)
+{
+	return transport_class_to_srp_rport(&shost->shost_gendev);
+}
+
 /**
  * srp_tmo_valid() - check timeout combination validity
  * @reconnect_delay: Reconnect delay in seconds.
@@ -626,9 +631,11 @@ static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct srp_internal *i = to_srp_internal(shost->transportt);
+	struct srp_rport *rport = shost_to_rport(shost);
 
 	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
-	return i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
+	return rport->fast_io_fail_tmo < 0 && rport->dev_loss_tmo < 0 &&
+		i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
 		BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
 }
 
-- 
2.1.4

