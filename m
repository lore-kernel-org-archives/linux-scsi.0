From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ServeRAID Seeing DADSI Devices
Date: Tue, 31 Jan 2006 13:17:55 -0500
Message-ID: <43DFA9D3.9030408@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:43974 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751314AbWAaSSK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 13:18:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

A critical thing the ServeRAID driver MUST do is hide the physical DASDI
devices from the OS. It does this by intercepting the INQUIRY commands. 

In recent 2.6.15 testing, I discovered this to be failing. 

The cause was the driver assuming that the INQUIRY response data was in a
simple single buffer, when it was actually a 1 element scatter gather list.

This patch makes ips always look at the correct data when examining an
INQUIRY response.

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>


--- a/drivers/scsi/ips.c	Mon Jan 30 13:34:41 2006
+++ b/drivers/scsi/ips.c	Mon Jan 30 13:47:00 2006
@@ -3496,6 +3496,7 @@
 	int device_error;
 	uint32_t transfer_len;
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
+	IPS_SCSI_INQ_DATA inquiryData;
 
 	METHOD_TRACE("ips_map_status", 1);
 
@@ -3554,13 +3555,13 @@
 				errcode = DID_OK;
 
 				/* Restrict access to physical DASD */
-				if ((scb->scsi_cmd->cmnd[0] == INQUIRY) &&
-				    ((((char *) scb->scsi_cmd->
-				       buffer)[0] & 0x1f) == TYPE_DISK)) {
-					/* underflow -- no error               */
-					/* restrict access to physical DASD    */
-					errcode = DID_TIME_OUT;
-					break;
+				if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
+				    ips_scmd_buf_read(scb->scsi_cmd, 
+                                      &inquiryData, sizeof (inquiryData));
+ 				    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK) {
+				        errcode = DID_TIME_OUT;
+				        break;
+				    }
 				}
 			} else
 				errcode = DID_ERROR;
@@ -4132,6 +4133,7 @@
 	uint8_t basic_status;
 	uint8_t ext_status;
 	int errcode;
+	IPS_SCSI_INQ_DATA inquiryData;
 
 	METHOD_TRACE("ips_chkstatus", 1);
 
@@ -4252,11 +4254,11 @@
 			scb->scsi_cmd->result = errcode << 16;
 		} else {	/* bus == 0 */
 			/* restrict access to physical drives */
-			if ((scb->scsi_cmd->cmnd[0] == INQUIRY) &&
-			    ((((char *) scb->scsi_cmd->buffer)[0] & 0x1f) ==
-			     TYPE_DISK)) {
-
-				scb->scsi_cmd->result = DID_TIME_OUT << 16;
+			if (scb->scsi_cmd->cmnd[0] == INQUIRY) { 
+			    ips_scmd_buf_read(scb->scsi_cmd, 
+                                  &inquiryData, sizeof (inquiryData));
+			    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK) 
+			        scb->scsi_cmd->result = DID_TIME_OUT << 16;
 			}
 		}		/* else */
 	} else {		/* recovered error / success */

