From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [11/15] qla2xxx: /proc fixes
Date: Thu, 6 May 2004 22:57:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055700.GA4953@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:54516 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262217AbUEGFzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:55:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1932 04/04/30 15:06:20 andrew.vasquez@apc.qlogic.com +1 -0
  /proc file updates:
  
  	o Address 'unaligned access' message on ia64 platorms
  	  while displaying bit-field flags.
  
  	o Iterate through the the OS target array to display 
  	  target ID bindings.
  
 drivers/scsi/qla2xxx/qla_os.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:57 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:57 2004
@@ -2322,18 +2322,17 @@
     char **start, off_t offset, int length, int inout)
 {
 	struct info_str	info;
-	int		i;
 	int             retval = -EINVAL;
 	os_lun_t	*up;
-	fc_port_t	*fcport;
+	os_tgt_t	*tq;
 	unsigned int	t, l;
 	uint32_t        tmp_sn;
-	unsigned long   *flags;
+	uint32_t	*flags;
 	uint8_t		*loop_state;
 	int	found;
 	scsi_qla_host_t *ha;
 	char fw_info[30];
-
+ 
 	DEBUG3(printk(KERN_INFO
 	    "Entering proc_info buff_in=%p, offset=0x%lx, length=0x%x\n",
 	    buffer, offset, length);)
@@ -2437,7 +2436,7 @@
 	    ha->done_q_cnt, ha->scsi_retry_q_cnt);
 
 
-	flags = (unsigned long *) &ha->flags;
+	flags = (uint32_t *) &ha->flags;
 
 	if (atomic_read(&ha->loop_state) == LOOP_DOWN) {
 		loop_state = "DOWN";
@@ -2511,24 +2510,19 @@
 	    ha->init_cb->port_name[7]);
 
 	/* Print out device port names */
-	i = 0;
- 	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (fcport->port_type != FCT_TARGET)
+	for (t = 0; t < MAX_FIBRE_DEVICES; t++) {
+		if ((tq = TGT_Q(ha, t)) == NULL)
 			continue;
 
 		copy_info(&info,
 		    "scsi-qla%d-target-%d="
-		    "%02x%02x%02x%02x%02x%02x%02x%02x:%02x%02x%02x;\n",
-		    (int)ha->instance, i,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
-		i++;
+		    "%02x%02x%02x%02x%02x%02x%02x%02x;\n",
+		    (int)ha->instance, t,
+		    tq->port_name[0], tq->port_name[1],
+		    tq->port_name[2], tq->port_name[3],
+		    tq->port_name[4], tq->port_name[5],
+		    tq->port_name[6], tq->port_name[7]);
 	}
-
 	copy_info(&info, "\nSCSI LUN Information:\n");
 	copy_info(&info,
 	    "(Id:Lun)  * - indicates lun is not registered with the OS.\n");
