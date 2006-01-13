From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ips - Mode Sense ( Caching Page ) fix
Date: Fri, 13 Jan 2006 08:30:38 -0500
Message-ID: <43C7AB7E.7050400@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:33952 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S932678AbWAMNap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 08:30:45 -0500
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 682B73991
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 05:30:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The ServeRAID driver ( ips ) does not recognize and respond properly to a 
Mode Sense - Caching Page request. This causes sd.c to display the message

                   "sda: got wrong page"

The following patch for creates a valid response to this request.


Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>



--- a/drivers/scsi/ips.c	Mon Jan  2 22:21:10 2006
+++ b/drivers/scsi/ips.c	Thu Jan 12 15:45:42 2006
@@ -3745,6 +3745,7 @@
 	int device_error;
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	int TimeOut;
+	uint8_t cachePageResponse[22];
 
	METHOD_TRACE("ips_send_cmd", 1);
 
@@ -3949,6 +3950,24 @@
 			break;
 
 		case MODE_SENSE:
+			if ((scb->scsi_cmd->cmnd[2] & 0x3F) == 8) // Caching Page Request
+			{
+				memset(cachePageResponse, 0, sizeof (cachePageResponse));
+				                              // Bytes 0-3 are the Mode Parameter Header
+				cachePageResponse[0] = 0x15;  //       Mode Data Length
+ 				cachePageResponse[1] = 0x00;  //       Medium Type = Default
+				cachePageResponse[2] = 0x00;  //       Device Specific Parmeters 
+				cachePageResponse[3] = 0x00;  //       No Block Descriptors 
+				                              // Actual Caching Page Data Starts Here
+				cachePageResponse[4] = 0x08;  //       Page Code 8 ( Caching Page )
+				cachePageResponse[5] = 0x12;  //       Page Length
+ 				cachePageResponse[6] = 0x00;  //       WCE is OFF !   
+
+				ips_scmd_buf_write(scb->scsi_cmd, cachePageResponse, sizeof (cachePageResponse));
+ 				scb->scsi_cmd->result = DID_OK << 16;
+				break;
+			}
+
 			scb->cmd.basic_io.op_code = IPS_CMD_ENQUIRY;
 			scb->cmd.basic_io.command_id = IPS_COMMAND_ID(ha, scb);
 			scb->cmd.basic_io.segment_4G = 0;
