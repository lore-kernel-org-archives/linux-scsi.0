From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ips.c - remove "Version Matching"
Date: Thu, 03 Nov 2005 09:46:00 -0500
Message-ID: <436A22A8.4090408@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4278 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030199AbVKCOqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2005 09:46:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

IBM has finally agreed that the "Version Matching" between firmware and 
drivers ( and the resulting warning messages ) is no longer necessary.
This patch will remove those functions from the ServeRAID driver.

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>


--- 2.6.14-rc4/drivers/scsi/ips.c	Fri Oct 21 13:58:06 2005
+++ devel/drivers/scsi/ips.c	Thu Nov  3 09:27:30 2005
@@ -139,6 +139,7 @@
 /*          - Remove 3 unused "inline" functions                             */
 /* 7.12.xx  - Use STATIC functions whereever possible                        */
 /*          - Clean up deprecated MODULE_PARM calls                          */
+/* 7.12.05  - Remove Version Matching per IBM request                        */
 /*****************************************************************************/
 
 /*
@@ -210,7 +211,7 @@
  * DRIVER_VER
  */
 #define IPS_VERSION_HIGH        "7.12"
-#define IPS_VERSION_LOW         ".02 "
+#define IPS_VERSION_LOW         ".05 "
 
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
@@ -350,8 +351,6 @@
 static int ips_host_info(ips_ha_t *, char *, off_t, int);
 static void copy_mem_info(IPS_INFOSTR *, char *, int);
 static int copy_info(IPS_INFOSTR *, char *, ...);
-static int ips_get_version_info(ips_ha_t * ha, dma_addr_t, int intr);
-static void ips_version_check(ips_ha_t * ha, int intr);
 static int ips_abort_init(ips_ha_t * ha, int index);
 static int ips_init_phase2(int index);
 
@@ -406,8 +405,6 @@
 #endif
 };
 
-static IPS_DEFINE_COMPAT_TABLE( Compatable );	/* Version Compatability Table      */
-
 
 /* This table describes all ServeRAID Adapters */
 static struct  pci_device_id  ips_pci_table[] = {
@@ -5813,7 +5810,7 @@
 	strncpy((char *) ha->nvram->bios_high, ha->bios_version, 4);
 	strncpy((char *) ha->nvram->bios_low, ha->bios_version + 4, 4);
 
-	ips_version_check(ha, intr);	/* Check BIOS/FW/Driver Versions */
+	ha->nvram->versioning = 0;	/* Indicate the Driver Does Not Support Versioning */
 
 	/* now update the page */
 	if (!ips_readwrite_page5(ha, TRUE, intr)) {
@@ -6728,135 +6725,6 @@
 	else
 		/* success */
 		return (0);
-}
-
-/*---------------------------------------------------------------------------*/
-/*   Routine Name: ips_version_check                                         */
-/*                                                                           */
-/*   Dependencies:                                                           */
-/*     Assumes that ips_read_adapter_status() is called first filling in     */
-/*     the data for SubSystem Parameters.                                    */
-/*     Called from ips_write_driver_status() so it also assumes NVRAM Page 5 */
-/*     Data is available.                                                    */
-/*                                                                           */
-/*---------------------------------------------------------------------------*/
-static void
-ips_version_check(ips_ha_t * ha, int intr)
-{
-	IPS_VERSION_DATA *VersionInfo;
-	uint8_t FirmwareVersion[IPS_COMPAT_ID_LENGTH + 1];
-	uint8_t BiosVersion[IPS_COMPAT_ID_LENGTH + 1];
-	int MatchError;
-	int rc;
-	char BiosString[10];
-	char FirmwareString[10];
-
-	METHOD_TRACE("ips_version_check", 1);
-
-	VersionInfo = ( IPS_VERSION_DATA * ) ha->ioctl_data;
-
-	memset(FirmwareVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
-	memset(BiosVersion, 0, IPS_COMPAT_ID_LENGTH + 1);
-
-	/* Get the Compatible BIOS Version from NVRAM Page 5 */
-	memcpy(BiosVersion, ha->nvram->BiosCompatibilityID,
-	       IPS_COMPAT_ID_LENGTH);
-
-	rc = IPS_FAILURE;
-	if (ha->subsys->param[4] & IPS_GET_VERSION_SUPPORT) {	/* If Versioning is Supported */
-		/* Get the Version Info with a Get Version Command */
-		memset( VersionInfo, 0, sizeof (IPS_VERSION_DATA));
-		rc = ips_get_version_info(ha, ha->ioctl_busaddr, intr);
-		if (rc == IPS_SUCCESS)
-			memcpy(FirmwareVersion, VersionInfo->compatibilityId,
-			       IPS_COMPAT_ID_LENGTH);
-	}
-
-	if (rc != IPS_SUCCESS) {	/* If Data Not Obtainable from a GetVersion Command */
-		/* Get the Firmware Version from Enquiry Data */
-		memcpy(FirmwareVersion, ha->enq->CodeBlkVersion,
-		       IPS_COMPAT_ID_LENGTH);
-	}
-
-	/* printk(KERN_WARNING "Adapter's BIOS Version  = %s\n", BiosVersion);          */
-	/* printk(KERN_WARNING "BIOS Compatible Version = %s\n", IPS_COMPAT_BIOS);      */
-	/* printk(KERN_WARNING "Adapter's Firmware Version  = %s\n", FirmwareVersion);  */
-	/* printk(KERN_WARNING "Firmware Compatible Version = %s \n", Compatable[ ha->nvram->adapter_type ]); */
-
-	MatchError = 0;
-
-	if (strncmp
-	    (FirmwareVersion, Compatable[ha->nvram->adapter_type],
-	     IPS_COMPAT_ID_LENGTH) != 0)
-		MatchError = 1;
-
-	if (strncmp(BiosVersion, IPS_COMPAT_BIOS, IPS_COMPAT_ID_LENGTH) != 0)
-		MatchError = 1;
-
-	ha->nvram->versioning = 1;	/* Indicate the Driver Supports Versioning */
-
-	if (MatchError) {
-		ha->nvram->version_mismatch = 1;
-		if (ips_cd_boot == 0) {
-			strncpy(&BiosString[0], ha->nvram->bios_high, 4);
-			strncpy(&BiosString[4], ha->nvram->bios_low, 4);
-			BiosString[8] = 0;
-
-			strncpy(&FirmwareString[0], ha->enq->CodeBlkVersion, 8);
-			FirmwareString[8] = 0;
-
-			IPS_PRINTK(KERN_WARNING, ha->pcidev,
-				   "Warning ! ! ! ServeRAID Version Mismatch\n");
-			IPS_PRINTK(KERN_WARNING, ha->pcidev,
-				   "Bios = %s, Firmware = %s, Device Driver = %s%s\n",
-				   BiosString, FirmwareString, IPS_VERSION_HIGH,
-				   IPS_VERSION_LOW);
-			IPS_PRINTK(KERN_WARNING, ha->pcidev,
-				   "These levels should match to avoid possible compatibility problems.\n");
-		}
-	} else {
-		ha->nvram->version_mismatch = 0;
-	}
-
-	return;
-}
-
-/*---------------------------------------------------------------------------*/
-/*   Routine Name: ips_get_version_info                                      */
-/*                                                                           */
-/*   Routine Description:                                                    */
-/*     Issue an internal GETVERSION Command                                  */
-/*                                                                           */
-/*   Return Value:                                                           */
-/*     0 if Successful, else non-zero                                        */
-/*---------------------------------------------------------------------------*/
-static int
-ips_get_version_info(ips_ha_t * ha, dma_addr_t Buffer, int intr)
-{
-	ips_scb_t *scb;
-	int rc;
-
-	METHOD_TRACE("ips_get_version_info", 1);
-
-	scb = &ha->scbs[ha->max_cmds - 1];
-
-	ips_init_scb(ha, scb);
-
-	scb->timeout = ips_cmd_timeout;
-	scb->cdb[0] = IPS_CMD_GET_VERSION_INFO;
-	scb->cmd.version_info.op_code = IPS_CMD_GET_VERSION_INFO;
-	scb->cmd.version_info.command_id = IPS_COMMAND_ID(ha, scb);
-	scb->cmd.version_info.reserved = 0;
-	scb->cmd.version_info.count = sizeof (IPS_VERSION_DATA);
-	scb->cmd.version_info.reserved2 = 0;
-	scb->data_len = sizeof (IPS_VERSION_DATA);
-	scb->data_busaddr = Buffer;
-	scb->cmd.version_info.buffer_addr = Buffer;
-	scb->flags = 0;
-
-	/* issue command */
-	rc = ips_send_wait(ha, scb, ips_cmd_timeout, intr);
-	return (rc);
 }
 
 /****************************************************************************/

