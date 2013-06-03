From: gurinder.shergill@hp.com
Subject: [PATCH] make dev_loss_tmo checks uniform across drivers
Date: Mon,  3 Jun 2013 11:25:19 -0700
Message-ID: <1370283919-11884-1-git-send-email-gurinder.shergill@hp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4379 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3FCS3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jun 2013 14:29:17 -0400
Received: from g1t0038.austin.hp.com (g1t0038.austin.hp.com [16.236.32.44])
	by g1t0028.austin.hp.com (Postfix) with ESMTP id 127E71C34D
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2013 18:29:17 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gurinder.shergill@hp.com

The dev_loss_tmo parameter controls how long the FC transport layer
insulates a loss of a remote port. It is defined to be between 1 and
SCSI_DEVICE_BLOCK_MAX_TIMEOUT (600). Different drivers do slightly different
checks when passed this parameter. This patch makes the dev_loss_tmo setting
uniform across all the drivers by pulling the common logic into the
transport layer function which is responsible for invoking the driver
provided callouts.

In addition, this patch also fixes a issue (see below), where dev_loss_tmo
could end up with a value more than SCSI_DEVICE_BLOCK_MAX_TIMEOUT when
fast_io_fail_tmo is enabled and then disabled.  The change is to never
allow dev_loss_tmo to be out of its defined range. And, once that is a
given, then fast_io_fail_tmo can be capped by dev_loss_tmo.

$ cat fast_io_fail_tmo
off
$ echo 900 > dev_loss_tmo
-bash: echo: write error: Invalid argument

$ echo 90 > dev_loss_tmo
$ cat dev_loss_tmo
90
$ echo 5 > fast_io_fail_tmo
$ cat dev_loss_tmo
90
$ echo 900 > dev_loss_tmo
$ cat dev_loss_tmo
900
$ echo "off" > fast_io_fail_tmo
$ cat dev_loss_tmo
900

Signed-off-by: Gurinder (Sunny) Shergill <gurinder.shergill@hp.com>
---
 drivers/message/fusion/mptfc.c    |  5 +----
 drivers/scsi/bfa/bfad_attr.c      | 11 ++++-------
 drivers/scsi/csiostor/csio_attr.c |  5 +----
 drivers/scsi/fnic/fnic_main.c     |  5 +----
 drivers/scsi/ibmvscsi/ibmvfc.c    |  5 +----
 drivers/scsi/libfc/fc_rport.c     |  5 +----
 drivers/scsi/lpfc/lpfc_attr.c     |  5 +----
 drivers/scsi/qla2xxx/qla_attr.c   |  5 +----
 drivers/scsi/scsi_transport_fc.c  | 17 +++++------------
 9 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fd75108..63f0b365 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -263,10 +263,7 @@ mptfc_host_reset(struct scsi_cmnd *SCpnt)
 static void
 mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	if (timeout > 0)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = mptfc_dev_loss_tmo;
+	rport->dev_loss_tmo = timeout;
 }
 
 static int
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 72f5dc3..3540bad 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -361,13 +361,10 @@ bfad_im_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 	struct bfad_s         *bfad = itnim->im->bfad;
 	unsigned long   flags;
 
-	if (timeout > 0) {
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
-		bfa_fcpim_path_tov_set(&bfad->bfa, timeout);
-		rport->dev_loss_tmo = bfa_fcpim_path_tov_get(&bfad->bfa);
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	}
-
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcpim_path_tov_set(&bfad->bfa, timeout);
+	rport->dev_loss_tmo = bfa_fcpim_path_tov_get(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
 static int
diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index 065a87a..7f86b3f 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -367,10 +367,7 @@ csio_get_stats(struct Scsi_Host *shost)
 static void
 csio_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 
 static void
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f09d18..0acbfbb 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -117,10 +117,7 @@ static struct scsi_host_template fnic_host_template = {
 static void
 fnic_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 
 static void fnic_get_host_speed(struct Scsi_Host *shost);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4e31caa..f4b52ca 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1034,10 +1034,7 @@ static void ibmvfc_get_host_port_state(struct Scsi_Host *shost)
  **/
 static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d518d17..2cb0435 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -186,10 +186,7 @@ static const char *fc_rport_state(struct fc_rport_priv *rdata)
  */
 void fc_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3c5625b..218d06a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5054,10 +5054,7 @@ lpfc_get_starget_port_name(struct scsi_target *starget)
 static void
 lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bf60c63..a2aa2ab 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1589,10 +1589,7 @@ qla2x00_get_starget_port_id(struct scsi_target *starget)
 static void
 qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	if (timeout)
-		rport->dev_loss_tmo = timeout;
-	else
-		rport->dev_loss_tmo = 1;
+	rport->dev_loss_tmo = timeout;
 }
 
 static void
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..4eb6ab5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -865,18 +865,12 @@ static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
 	    (rport->port_state == FC_PORTSTATE_DELETED) ||
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
-	/*
-	 * Check for overflow; dev_loss_tmo is u32
-	 */
-	if (val > UINT_MAX)
-		return -EINVAL;
 
 	/*
-	 * If fast_io_fail is off we have to cap
-	 * dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT
+	 * dev_loss_tmo range is defined to be between
+	 * 1 - SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
 	 */
-	if (rport->fast_io_fail_tmo == -1 &&
-	    val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+	if ((val < 1) || (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
 		return -EINVAL;
 
 	i->f->set_rport_dev_loss_tmo(rport, val);
@@ -981,11 +975,10 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
 		if ((*cp && (*cp != '\n')) || (val < 0))
 			return -EINVAL;
 		/*
-		 * Cap fast_io_fail by dev_loss_tmo or
+		 * Cap fast_io_fail by dev_loss_tmo, which is capped by
 		 * SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
 		 */
-		if ((val >= rport->dev_loss_tmo) ||
-		    (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
+		if (val >= rport->dev_loss_tmo)
 			return -EINVAL;
 
 		rport->fast_io_fail_tmo = val;
-- 
1.7.11.7

