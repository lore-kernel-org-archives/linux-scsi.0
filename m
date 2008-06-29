From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 08/13] libfc fcoe: use shost_priv
Date: Sun, 29 Jun 2008 13:23:58 -0500
Message-ID: <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-8-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

Use shost_priv.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/fcoe/fcoe_if.c  |   46 +++++++++++++++++++++---------------------
 drivers/scsi/libfc/fc_attr.c |    8 +++---
 drivers/scsi/libfc/fc_scsi.c |    8 +++---
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_if.c b/drivers/scsi/fcoe/fcoe_if.c
index a955994..3c21e05 100644
--- a/drivers/scsi/fcoe/fcoe_if.c
+++ b/drivers/scsi/fcoe/fcoe_if.c
@@ -94,9 +94,9 @@ fc_wwn_t fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], uint scheme,
 /*
  * Scsi_Host class Attributes helper functions
  */
-char *fcoe_info(struct Scsi_Host *host)
+char *fcoe_info(struct Scsi_Host *shost)
 {
-	struct fc_lport *lp = (struct fc_lport *)host->hostdata;
+	struct fc_lport *lp = shost_priv(shost);
 	static char buf[256];
 	int len = 0;
 
@@ -125,23 +125,23 @@ static ssize_t fcoe_name_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
+	struct Scsi_Host *shost = class_to_shost(dev);
 
-	return snprintf(buf, PAGE_SIZE, "FCOEHBA%d\n", host->host_no);
+	return snprintf(buf, PAGE_SIZE, "FCOEHBA%d\n", shost->host_no);
 }
 static ssize_t fcoe_info_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
-	return snprintf(buf, PAGE_SIZE, "%s", fcoe_info(host));
+	struct Scsi_Host *shost = class_to_shost(dev);
+	return snprintf(buf, PAGE_SIZE, "%s", fcoe_info(shost));
 }
 static ssize_t fcoe_state_show(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
-	struct fc_lport *lp = (struct fc_lport *)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lp = shost_priv(shost);
 	ssize_t len;
 
 	switch (lp->state) {
@@ -173,8 +173,8 @@ static ssize_t fcoe_stop(struct device *dev,
 			 struct device_attribute *attr,
 			 const char *buffer, size_t size)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
-	struct fc_lport *lp = (struct fc_lport *)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lp = shost_priv(shost);
 
 	if (buffer == NULL)
 		return size;
@@ -195,8 +195,8 @@ static ssize_t fcoe_start(struct device *dev,
 			  struct device_attribute *attr,
 			  const char *buffer, size_t size)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
-	struct fc_lport *lp = (struct fc_lport *)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lp = shost_priv(shost);
 
 	if (buffer == NULL)
 		return size;
@@ -217,8 +217,8 @@ static ssize_t fcoe_reset(struct device *dev,
 			  struct device_attribute *attr,
 			  const char *buffer, size_t size)
 {
-	struct Scsi_Host *host = class_to_shost(dev);
-	struct fc_lport *lp = (struct fc_lport *)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lp = shost_priv(shost);
 
 	if (buffer == NULL)
 		return size;
@@ -436,7 +436,7 @@ int fcoe_create_interface(const char *ifname)
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *p;
 	struct net_device *net_dev;
-	struct Scsi_Host *host;
+	struct Scsi_Host *shost;
 	struct fcoe_info *fci = &fcoei;
 
 	u32 mfs;
@@ -458,22 +458,22 @@ int fcoe_create_interface(const char *ifname)
 		goto out_put_dev;
 	}
 
-	host = scsi_host_alloc(&fcoe_driver_template,
+	shost = scsi_host_alloc(&fcoe_driver_template,
 			       sizeof(struct fc_lport) +
 			       sizeof(struct fcoe_softc));
 
-	if (host == NULL) {
+	if (shost == NULL) {
 		FC_DBG("openfc: Could not allocate host structure\n");
 		rc = -ENOMEM;
 		goto out_put_dev;
 	}
 
-	host->transportt = fcoe_transport_template;
+	shost->transportt = fcoe_transport_template;
 
 	/* Set structure relationships */
-	lp = (struct fc_lport *)host->hostdata;
+	lp = shost_priv(shost);
 	memset(lp, 0, sizeof(struct fc_lport));
-	lp->host = host;
+	lp->host = shost;
 	lp->drv_priv = (void *)(lp + 1);
 	fc = (struct fcoe_softc *)lp->drv_priv;
 	memset(fc, 0, sizeof(struct fcoe_softc));
@@ -484,9 +484,9 @@ int fcoe_create_interface(const char *ifname)
 	memcpy(&lp->tt, &fcoe_libfc_transport_template, sizeof(struct fc_transport_template));
 
 	/* Configure the scsi_host */
-	host->max_lun = FC_MAX_LUN;
-	host->max_id = FC_MAX_FCP_TARGET;
-	host->max_channel = 0;
+	shost->max_lun = FC_MAX_LUN;
+	shost->max_id = FC_MAX_FCP_TARGET;
+	shost->max_channel = 0;
 
 	/* Allocate an EM for this driver */
 	lp->emp = fc_exch_mgr_alloc(FC_CLASS_3, 0, 0);
diff --git a/drivers/scsi/libfc/fc_attr.c b/drivers/scsi/libfc/fc_attr.c
index 97cd1a9..23ecad6 100644
--- a/drivers/scsi/libfc/fc_attr.c
+++ b/drivers/scsi/libfc/fc_attr.c
@@ -31,7 +31,7 @@ MODULE_LICENSE("GPL");
 
 void fc_get_host_port_id(struct Scsi_Host *shost)
 {
-	struct fc_lport *lp = (struct fc_lport *)shost->hostdata;
+	struct fc_lport *lp = shost_priv(shost);
 
 	fc_host_port_id(shost) = fc_lport_get_fid(lp);
 }
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(fc_get_host_port_type);
 
 void fc_get_host_fabric_name(struct Scsi_Host *shost)
 {
-	struct fc_lport *lp = (struct fc_lport *)shost->hostdata;
+	struct fc_lport *lp = shost_priv(shost);
 
 	fc_host_fabric_name(shost) = lp->wwnn;
 }
@@ -94,11 +94,11 @@ void fc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 }
 EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shp)
+struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 {
 	int i;
 	struct fc_host_statistics *fcoe_stats;
-	struct fc_lport *lp = (struct fc_lport *)shp->hostdata;
+	struct fc_lport *lp = shost_priv(shost);
 	struct timespec v0, v1;
 
 	fcoe_stats = &lp->openfc_host_stat;
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index e9a704d..bc2f1ac 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -1727,7 +1727,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
-	lp = (struct fc_lport *)sc_cmd->device->host->hostdata;
+	lp = shost_priv(sc_cmd->device->host);
 
 	if (lp->state != FC_RUNNING) {
 		if (lp->status & FC_PAUSE) {
@@ -1970,8 +1970,8 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_scsi_pkt *sp;
 	struct fc_lport *lp;
 	int rc = FAILED;
-	lp = (struct fc_lport *)sc_cmd->device->host->hostdata;
 
+	lp = shost_priv(sc_cmd->device->host);
 	if (lp->state != FC_RUNNING) {
 		return rc;
 	} else if (!(lp->status & FC_LINK_UP)) {
@@ -2027,7 +2027,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 
 	rp = rport->dd_data;
 	if (rp != NULL) {
-		lp = (struct fc_lport *)sc_cmd->device->host->hostdata;
+		lp = shost_priv(sc_cmd->device->host);
 
 		if (lp->state != FC_RUNNING)
 			return rc;
@@ -2066,7 +2066,7 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 {
 	struct fc_lport *lp;
 
-	lp = (struct fc_lport *)sc_cmd->device->host->hostdata;
+	lp = shost_priv(sc_cmd->device->host);
 	return (lp->tt.reset_if(lp));
 }
 EXPORT_SYMBOL(fc_eh_host_reset);
-- 
1.5.4.1
