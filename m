From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 63/78] atari_NCR5380: Remove HOSTNO macro from printk() and seq_printf() calls
Date: Sun, 03 Jan 2016 16:06:04 +1100
Message-ID: <20160103050517.744166880@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-remove-HOSTNO-printk
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the HOSTNO macro that is peculiar to atari_NCR5380.c and
contributes to the problem of divergence of the NCR5380 core drivers.
Keep NCR5380.c in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   17 +++++++++--------
 drivers/scsi/atari_NCR5380.c |   23 +++++++++--------------
 2 files changed, 18 insertions(+), 22 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:32.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:33.000000000 +1100
@@ -569,12 +569,12 @@ static void NCR5380_print_phase(struct S
 
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
-		printk(KERN_DEBUG "scsi%d: REQ not asserted, phase unknown.\n", HOSTNO);
+		shost_printk(KERN_DEBUG, instance, "REQ not asserted, phase unknown.\n");
 	else {
 		for (i = 0; (phases[i].value != PHASE_UNKNOWN) &&
 		     (phases[i].value != (status & PHASE_MASK)); ++i)
 			;
-		printk(KERN_DEBUG "scsi%d: phase %s\n", HOSTNO, phases[i].name);
+		shost_printk(KERN_DEBUG, instance, "phase %s\n", phases[i].name);
 	}
 }
 
@@ -1428,8 +1428,7 @@ static struct scsi_cmnd *NCR5380_select(
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		printk(KERN_ERR "scsi%d: reselection after won arbitration?\n",
-		       HOSTNO);
+		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
 		goto out;
 	}
 
@@ -1957,8 +1956,7 @@ static void NCR5380_information_transfer
 			switch (phase) {
 			case PHASE_DATAOUT:
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
-				printk("scsi%d: NDEBUG_NO_DATAOUT set, attempted DATAOUT "
-				       "aborted\n", HOSTNO);
+				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
@@ -2219,13 +2217,11 @@ static void NCR5380_information_transfer
 							tmp = 0;
 						}
 					} else if (len) {
-						printk(KERN_NOTICE "scsi%d: error receiving "
-						       "extended message\n", HOSTNO);
+						shost_printk(KERN_ERR, instance, "error receiving extended message\n");
 						tmp = 0;
 					} else {
-						printk(KERN_NOTICE "scsi%d: extended message "
-							   "code %02x length %d is too long\n",
-							   HOSTNO, extended_msg[2], extended_msg[1]);
+						shost_printk(KERN_NOTICE, instance, "extended message code %02x length %d is too long\n",
+						             extended_msg[2], extended_msg[1]);
 						tmp = 0;
 					}
 
@@ -2241,8 +2237,7 @@ static void NCR5380_information_transfer
 					 */
 				default:
 					if (!tmp) {
-						printk(KERN_INFO "scsi%d: rejecting message ",
-						       instance->host_no);
+						shost_printk(KERN_ERR, instance, "rejecting message ");
 						spi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
@@ -2291,7 +2286,7 @@ static void NCR5380_information_transfer
 				cmd->SCp.Status = tmp;
 				break;
 			default:
-				printk("scsi%d: unknown phase\n", HOSTNO);
+				shost_printk(KERN_ERR, instance, "unknown phase\n");
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			} /* switch(phase) */
 		} else {
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:32.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:33.000000000 +1100
@@ -418,10 +418,10 @@ static void NCR5380_print_phase(struct S
 
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
-		printk("scsi%d : REQ not asserted, phase unknown.\n", instance->host_no);
+		shost_printk(KERN_DEBUG, instance, "REQ not asserted, phase unknown.\n");
 	else {
 		for (i = 0; (phases[i].value != PHASE_UNKNOWN) && (phases[i].value != (status & PHASE_MASK)); ++i);
-		printk("scsi%d : phase %s\n", instance->host_no, phases[i].name);
+		shost_printk(KERN_DEBUG, instance, "phase %s\n", phases[i].name);
 	}
 }
 #endif
@@ -1247,7 +1247,7 @@ static struct scsi_cmnd *NCR5380_select(
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		printk("scsi%d : reselection after won arbitration?\n", instance->host_no);
+		shost_printk(KERN_ERR, instance, "reselection after won arbitration?\n");
 		goto out;
 	}
 
@@ -1852,7 +1852,7 @@ static void NCR5380_information_transfer
 			switch (phase) {
 			case PHASE_DATAOUT:
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
-				printk("scsi%d : NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n", instance->host_no);
+				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
@@ -2053,10 +2053,11 @@ static void NCR5380_information_transfer
 							tmp = 0;
 						}
 					} else if (len) {
-						printk("scsi%d: error receiving extended message\n", instance->host_no);
+						shost_printk(KERN_ERR, instance, "error receiving extended message\n");
 						tmp = 0;
 					} else {
-						printk("scsi%d: extended message code %02x length %d is too long\n", instance->host_no, extended_msg[2], extended_msg[1]);
+						shost_printk(KERN_NOTICE, instance, "extended message code %02x length %d is too long\n",
+						             extended_msg[2], extended_msg[1]);
 						tmp = 0;
 					}
 
@@ -2072,7 +2073,7 @@ static void NCR5380_information_transfer
 					 */
 				default:
 					if (!tmp) {
-						printk("scsi%d: rejecting message ", instance->host_no);
+						shost_printk(KERN_ERR, instance, "rejecting message ");
 						spi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
@@ -2118,7 +2119,7 @@ static void NCR5380_information_transfer
 				cmd->SCp.Status = tmp;
 				break;
 			default:
-				printk("scsi%d : unknown phase\n", instance->host_no);
+				shost_printk(KERN_ERR, instance, "unknown phase\n");
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			}	/* switch(phase) */
 		} else {
