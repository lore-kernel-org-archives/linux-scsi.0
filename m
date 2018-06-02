From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.17-rc7
Date: Sat, 02 Jun 2018 14:17:51 -0700
Message-ID: <1527974271.3158.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Eve of merge window fix: The original code was so bogus as to be
casting the wrong generic device to an rport and proceeding to take
actions based on the bogus values it found.  Fortunately it seems the
location that is dereferenced always exists, so the code hasn't oopsed
yet, but it certainly annoys the memory checkers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: scsi_transport_srp: Fix shost to rport translation

And the diffstat:

 drivers/scsi/scsi_transport_srp.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 36f6190931bc..456ce9f19569 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -51,6 +51,8 @@ struct srp_internal {
 	struct transport_container rport_attr_cont;
 };
 
+static int scsi_is_srp_rport(const struct device *dev);
+
 #define to_srp_internal(tmpl) container_of(tmpl, struct srp_internal, t)
 
 #define	dev_to_rport(d)	container_of(d, struct srp_rport, dev)
@@ -60,9 +62,24 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
 	return dev_to_shost(r->dev.parent);
 }
 
+static int find_child_rport(struct device *dev, void *data)
+{
+	struct device **child = data;
+
+	if (scsi_is_srp_rport(dev)) {
+		WARN_ON_ONCE(*child);
+		*child = dev;
+	}
+	return 0;
+}
+
 static inline struct srp_rport *shost_to_rport(struct Scsi_Host *shost)
 {
-	return transport_class_to_srp_rport(&shost->shost_gendev);
+	struct device *child = NULL;
+
+	WARN_ON_ONCE(device_for_each_child(&shost->shost_gendev, &child,
+					   find_child_rport) < 0);
+	return child ? dev_to_rport(child) : NULL;
 }
 
 /**
@@ -600,7 +617,8 @@ enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
 	struct srp_rport *rport = shost_to_rport(shost);
 
 	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
-	return rport->fast_io_fail_tmo < 0 && rport->dev_loss_tmo < 0 &&
+	return rport && rport->fast_io_fail_tmo < 0 &&
+		rport->dev_loss_tmo < 0 &&
 		i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
 		BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
 }
