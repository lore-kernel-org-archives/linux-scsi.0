From: Finn Thain <fthain@telegraphics.com.au>
Subject: scsi/NCR5380: Suppress SDTR and WDTR message logging
Date: Thu, 26 Oct 2017 16:51:50 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1710261632460.3@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The 5380 drivers only support asynchronous transfers and the 5380
controllers only have narrow busses. Hence, the core driver will reject 
any SDTR and WDTR messages from target devices. Don't log this, it's 
expected behaviour. Also, fix the off-by-one array indices in the 
arguments to scmd_printk().

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index acc33440bca0..3cf16bca0dc6 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1907,8 +1907,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						switch (extended_msg[2]) {
 						case EXTENDED_SDTR:
 						case EXTENDED_WDTR:
-						case EXTENDED_MODIFY_DATA_POINTER:
-						case EXTENDED_EXTENDED_IDENTIFY:
 							tmp = 0;
 						}
 					} else if (len) {
@@ -1931,18 +1929,14 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 * reject it.
 					 */
 				default:
-					if (!tmp) {
-						shost_printk(KERN_ERR, instance, "rejecting message ");
-						spi_print_msg(extended_msg);
-						printk("\n");
-					} else if (tmp != EXTENDED_MESSAGE)
-						scmd_printk(KERN_INFO, cmd,
-						            "rejecting unknown message %02x\n",
-						            tmp);
-					else
+					if (tmp == EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
 						            "rejecting unknown extended message code %02x, length %d\n",
-						            extended_msg[1], extended_msg[0]);
+						            extended_msg[2], extended_msg[1]);
+					else if (tmp)
+						scmd_printk(KERN_INFO, cmd,
+						            "rejecting unknown message code %02x\n",
+						            tmp);
 
 					msgout = MESSAGE_REJECT;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
