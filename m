From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [10/15] qla2xxx: Use fcports list for targets
Date: Sun, 14 Mar 2004 00:25:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082535.GA3451@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:57525 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263322AbUCNIXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:05 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1666 04/03/01 15:37:16 andrew.vasquez@apc.qlogic.com +1 -0
  Consistently use the fcports list of an HA to iterate through the
  known target devices.

 drivers/scsi/qla2xxx/qla_os.c |   47 ++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 22 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/19_use_fcport_list.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:08:49 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:08:49 2004
@@ -2270,10 +2270,10 @@
     char **start, off_t offset, int length, int inout)
 {
 	struct info_str	info;
-	int             i;
+	int		i;
 	int             retval = -EINVAL;
 	os_lun_t	*up;
-	os_tgt_t	*tq;
+	fc_port_t	*fcport;
 	unsigned int	t, l;
 	uint32_t        tmp_sn;
 	unsigned long   *flags;
@@ -2459,20 +2459,23 @@
 	    ha->init_cb->port_name[7]);
 
 	/* Print out device port names */
-	for (i = 0; i < MAX_TARGETS; i++) {
-		if ((tq = TGT_Q(ha, i)) == NULL)
+	i = 0;
+ 	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (fcport->port_type != FCT_TARGET)
 			continue;
 
 		copy_info(&info,
 		    "scsi-qla%d-target-%d="
-		    "%02x%02x%02x%02x%02x%02x%02x%02x;\n",
+		    "%02x%02x%02x%02x%02x%02x%02x%02x:%02x%02x%02x;\n",
 		    (int)ha->instance, i,
-		    tq->port_name[0], tq->port_name[1],
-		    tq->port_name[2], tq->port_name[3],
-		    tq->port_name[4], tq->port_name[5],
-		    tq->port_name[6], tq->port_name[7]);
-
-	} /* 2.25 node/port display to proc */
+		    fcport->port_name[0], fcport->port_name[1],
+		    fcport->port_name[2], fcport->port_name[3],
+		    fcport->port_name[4], fcport->port_name[5],
+		    fcport->port_name[6], fcport->port_name[7],
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa);
+		i++;
+	}
 
 	copy_info(&info, "\nSCSI LUN Information:\n");
 	copy_info(&info,
@@ -2776,11 +2779,11 @@
 void
 qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha) 
 {
-	struct list_head	*fcpl;
-	fc_port_t		*fcport;
+	fc_port_t *fcport;
 
-	list_for_each(fcpl, &ha->fcports) {
-		fcport = list_entry(fcpl, fc_port_t, list);
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (fcport->port_type != FCT_TARGET)
+			continue;
 
 		/*
 		 * No point in marking the device as lost, if the device is
@@ -3140,7 +3143,6 @@
 {
 	DECLARE_MUTEX_LOCKED(sem);
 	scsi_qla_host_t *ha;
-	struct list_head *fcpl;
 	fc_port_t	*fcport;
 	os_lun_t        *q;
 	srb_t           *sp;
@@ -3339,9 +3341,10 @@
 			    ha->host_no));
 
 			next_loopid = 0;
-			list_for_each(fcpl, &ha->fcports) {
-				fcport = list_entry(fcpl, fc_port_t, list);
-				
+			list_for_each_entry(fcport, &ha->fcports, list) {
+				if (fcport->port_type != FCT_TARGET)
+					continue;
+
 				/*
 				 * If the port is not ONLINE then try to login
 				 * to it if we haven't run out of retries.
@@ -3643,7 +3646,6 @@
 {
 	int		t,l;
 	unsigned long	cpu_flags = 0;
-	struct list_head	*fcpl;
 	fc_port_t	*fcport;
 	os_lun_t *lq;
 	os_tgt_t *tq;
@@ -3678,8 +3680,9 @@
 	 * the port it marked DEAD. 
 	 */
 	t = 0;
-	list_for_each(fcpl, &ha->fcports) {
-		fcport = list_entry(fcpl, fc_port_t, list);
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (fcport->port_type != FCT_TARGET)
+			continue;
 
 		if (atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
 
