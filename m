From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/18]  qla2xxx: Initialization fixes
Date: Mon, 21 Jun 2004 22:52:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055247.GA8425@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:43686 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266595AbUFVFtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:49:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1842 04/06/03 17:02:04 andrew.vasquez@apc.qlogic.com +3 -0
  Small initialization fixes:
  
  	o 'point-to-point preferred, else loop' is not a safe
  	  connection mode setting for ISP2200 boards.  Use 
  	  'loop preferred, else point-to-point.'
  
  	o Add modules parameter to enable ZIO -- Support mode
  	  5 only.
  
  	o No point in doing a PRLI (process login) to the SNS
  	  port.
  
  	o Fix problem where the driver would incorrectly skip
  	  ports with the same domain and area of the HBA.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |   54 +++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++++
 3 files changed, 37 insertions(+), 25 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:37:41 -07:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-21 15:37:41 -07:00
@@ -64,6 +64,7 @@
 extern int ql2xmaxqdepth;
 extern int displayConfig;
 extern int ql2xplogiabsentdevice;
+extern int ql2xenablezio;
 extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:37:40 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:37:40 -07:00
@@ -1110,7 +1110,7 @@
 	nvram_t *nv    = (nvram_t *)ha->request_ring;
 	uint16_t  *wptr  = (uint16_t *)ha->request_ring;
 	device_reg_t *reg = ha->iobase;
-	uint16_t  timer_mode;
+	uint8_t  timer_mode;
 
 	rval = QLA_SUCCESS;
 
@@ -1164,7 +1164,7 @@
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
-			nv->add_firmware_options[0] = BIT_5 | BIT_4;
+			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
 			nv->frame_payload_size = __constant_cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
@@ -1262,6 +1262,16 @@
 		}
 	} else if (IS_QLA2200(ha)) {
 		nv->firmware_options[0] |= BIT_2;
+		/*
+		 * 'Point-to-point preferred, else loop' is not a safe
+		 * connection mode setting.
+		 */
+		if ((nv->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) ==
+		    (BIT_5 | BIT_4)) {
+			/* Force 'loop preferred, else point-to-point'. */
+			nv->add_firmware_options[0] &= ~(BIT_6 | BIT_5 | BIT_4);
+			nv->add_firmware_options[0] |= BIT_5;
+		}
 		strcpy(ha->model_number, "QLA22xx");
 	} else /*if (IS_QLA2100(ha))*/ {
 		strcpy(ha->model_number, "QLA2100");
@@ -1417,23 +1427,22 @@
 
 		ha->flags.process_response_queue = 1;
 	} else {
-		/* TEST ZIO:
-		 *
-		 * icb->add_firmware_options[0] &=
-		 *    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
-		 * icb->add_firmware_options[0] |= (BIT_2 | BIT_0);
-		 */
+		/* Enable ZIO -- Support mode 5 only. */
 		timer_mode = icb->add_firmware_options[0] &
 		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
-		if (timer_mode == 5) {
+		icb->add_firmware_options[0] &=
+		    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		if (ql2xenablezio)
+			timer_mode = BIT_2 | BIT_0;
+		if (timer_mode == (BIT_2 | BIT_0)) {
 			DEBUG2(printk("scsi(%ld): ZIO enabled; timer delay "
 			    "(%d).\n", ha->host_no, ql2xintrdelaytimer));
 			qla_printk(KERN_INFO, ha,
 			    "ZIO enabled; timer delay (%d).\n",
 			    ql2xintrdelaytimer);
 
+			icb->add_firmware_options[0] |= timer_mode;
 			icb->interrupt_delay_timer = ql2xintrdelaytimer;
-	
 			ha->flags.process_response_queue = 1;
 		}
 	}
@@ -2328,7 +2337,7 @@
 	do {
 		/* Ensure we are logged into the SNS. */
 		qla2x00_login_fabric(ha, SIMPLE_NAME_SERVER, 0xff, 0xff, 0xfc,
-		    mb, BIT_0);
+		    mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
 			qla_printk(KERN_INFO, ha,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
@@ -2578,11 +2587,6 @@
 		if ((new_fcport->d_id.b.domain & 0xf0) == 0xf0)
 			continue;
 
-		/* Bypass if same domain and area of adapter. */
-		if ((new_fcport->d_id.b24 & 0xffff00) ==
-		    (ha->d_id.b24 & 0xffff00))
-			continue;
-
 		/* Locate matching device in database. */
 		found = 0;
 		list_for_each_entry(fcport, &ha->fcports, list) {
@@ -2593,6 +2597,15 @@
 			found++;
 
 			/*
+			 * If address the same and state FCS_ONLINE, nothing
+			 * changed.
+			 */
+			if (fcport->d_id.b24 == new_fcport->d_id.b24 &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) {
+				break;
+			}
+
+			/*
 			 * If device was not a fabric device before.
 			 */
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
@@ -2601,15 +2614,6 @@
 				fcport->flags |= (FCF_FABRIC_DEVICE |
 				    FCF_LOGIN_NEEDED);
 				fcport->flags &= ~FCF_PERSISTENT_BOUND;
-				break;
-			}
-
-			/*
-			 * If address the same and state FCS_ONLINE, nothing
-			 * changed.
-			 */
-			if (fcport->d_id.b24 == new_fcport->d_id.b24 &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				break;
 			}
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:40 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:41 -07:00
@@ -79,6 +79,13 @@
 		"a Fabric scan.  This is needed for several broken switches."
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
 
+int ql2xenablezio = 0;
+module_param(ql2xenablezio, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xenablezio,
+		"Option to enable ZIO:If 1 then enable it otherwise" 
+		" use the default set in the NVRAM."
+		" Default is 0 : disabled");
+
 int ql2xintrdelaytimer = 10;
 module_param(ql2xintrdelaytimer, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xintrdelaytimer,
