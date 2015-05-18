From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 07/12] scsi_transport_srp: Reduce failover time
Date: Mon, 18 May 2015 13:24:38 +0200
Message-ID: <5559CBF6.8000903@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5559CB3A.6060102-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Unlike FC, there is no risk that SCSI devices will be offlined
by the SCSI error handler if the SCSI error handler is started
while a reconnect attempt is ongoing. Hence report timeout errors
as soon as possible if a higher software layer (e.g. multipathd)
needs to be informed about a timeout. It is assumed that if both
fast_io_fail_tmo < 0 and rport->dev_loss_tmo < 0 that this means
that there is no need to report timeouts quickly.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f115f67..a85292b 100644
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
@@ -628,9 +633,11 @@ static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
