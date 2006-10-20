From: akpm@osdl.org
Subject: [patch 29/45] scsi: Scsi_Cmnd conversion in psi240i driver
Date: Fri, 20 Oct 2006 14:48:28 -0700
Message-ID: <200610202148.k9KLmSMc004162@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60294 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992793AbWJTVsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Changes the obsolete Scsi_Cmnd to struct scsi_cmnd in psi240i-driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/psi240i.c |   31 ++++++++++++++++++-------------
 drivers/scsi/psi240i.h |    6 +++---
 2 files changed, 21 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/psi240i.c~scsi-scsi_cmnd-convertion-in-psi240i-driver drivers/scsi/psi240i.c
--- a/drivers/scsi/psi240i.c~scsi-scsi_cmnd-convertion-in-psi240i-driver
+++ a/drivers/scsi/psi240i.c
@@ -87,11 +87,11 @@ typedef struct
 	{
 	USHORT		 ports[13];
 	OUR_DEVICE	 device[8];
-	Scsi_Cmnd	*pSCmnd;
+	struct scsi_cmnd *pSCmnd;
 	IDE_STRUCT	 ide;
 	ULONG		 startSector;
 	USHORT		 sectorCount;
-	Scsi_Cmnd	*SCpnt;
+	struct scsi_cmnd *SCpnt;
 	VOID		*buffer;
 	USHORT		 expectingIRQ;
 	}	ADAPTER240I, *PADAPTER240I;
@@ -253,12 +253,12 @@ static ULONG DecodeError (struct Scsi_Ho
  ****************************************************************/
 static void Irq_Handler (int irq, void *dev_id)
 	{
-	struct Scsi_Host   *shost;			// Pointer to host data block
-	PADAPTER240I		padapter;		// Pointer to adapter control structure
-	USHORT		 	   *pports;			// I/O port array
-	Scsi_Cmnd		   *SCpnt;
-	UCHAR				status;
-	int					z;
+	struct Scsi_Host *shost;	// Pointer to host data block
+	PADAPTER240I padapter;		// Pointer to adapter control structure
+	USHORT *pports;			// I/O port array
+	struct scsi_cmnd *SCpnt;
+	UCHAR status;
+	int z;
 
 	DEB(printk ("\npsi240i received interrupt\n"));
 
@@ -389,12 +389,17 @@ static irqreturn_t do_Irq_Handler (int i
  *	Returns:		Status code.
  *
  ****************************************************************/
-static int Psi240i_QueueCommand (Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int Psi240i_QueueCommand(struct scsi_cmnd *SCpnt,
+				void (*done)(struct scsi_cmnd *))
 	{
-	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
-	PADAPTER240I	padapter = HOSTDATA (SCpnt->device->host); 			// Pointer to adapter control structure
-	POUR_DEVICE 		pdev	 = &padapter->device [SCpnt->device->id];// Pointer to device information
-	UCHAR			rc;											// command return code
+	UCHAR *cdb = (UCHAR *)SCpnt->cmnd;
+	// Pointer to SCSI CDB
+	PADAPTER240I padapter = HOSTDATA (SCpnt->device->host);
+	// Pointer to adapter control structure
+	POUR_DEVICE pdev = &padapter->device [SCpnt->device->id];
+	// Pointer to device information
+	UCHAR rc;
+	// command return code
 
 	SCpnt->scsi_done = done;
 	padapter->ide.ide.ides.spigot = pdev->spigot;
diff -puN drivers/scsi/psi240i.h~scsi-scsi_cmnd-convertion-in-psi240i-driver drivers/scsi/psi240i.h
--- a/drivers/scsi/psi240i.h~scsi-scsi_cmnd-convertion-in-psi240i-driver
+++ a/drivers/scsi/psi240i.h
@@ -309,7 +309,7 @@ typedef struct _IDENTIFY_DATA2 {
 #endif	// PSI_EIDE_SCSIOP
 
 // function prototypes
-int Psi240i_Command			(Scsi_Cmnd *SCpnt);
-int Psi240i_Abort			(Scsi_Cmnd *SCpnt);
-int Psi240i_Reset			(Scsi_Cmnd *SCpnt, unsigned int flags);
+int Psi240i_Command(struct scsi_cmnd *SCpnt);
+int Psi240i_Abort(struct scsi_cmnd *SCpnt);
+int Psi240i_Reset(struct scsi_cmnd *SCpnt, unsigned int flags);
 #endif
_
