From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill a useless global array from aacraid
Date: Sat, 7 Feb 2004 15:58:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040207145831.GA19628@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:62686 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266925AbUBGO6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Feb 2004 09:58:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org

We can always get the fsa_scsi_hba from the aac_dev.  Not that I have
the slightest clue why we need two structures to start with..



--- 1.21/drivers/scsi/aacraid/aachba.c	Wed Nov 19 19:36:23 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Mon Jan 12 10:19:36 2004
@@ -195,7 +195,6 @@
  *              M O D U L E   G L O B A L S
  */
  
-static struct fsa_scsi_hba *fsa_dev[MAXIMUM_NUM_ADAPTERS];	/*  SCSI Device Instance Pointers */
 static struct sense_data sense_data[MAXIMUM_NUM_CONTAINERS];
 static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* sgmap);
 static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg);
@@ -264,7 +263,6 @@
 		}
 	}
 	fib_free(fibptr);
-	fsa_dev[instance] = fsa_dev_ptr;
 	return status;
 }
 
@@ -859,16 +857,12 @@
 int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 {
 	u32 cid = 0;
-	struct fsa_scsi_hba *fsa_dev_ptr;
-	int cardtype;
 	int ret;
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
+	struct fsa_scsi_hba *fsa_dev_ptr = &dev->fsa_dev;
+	int cardtype = dev->cardtype;
 	
-	cardtype = dev->cardtype;
-
-	fsa_dev_ptr = fsa_dev[host->unique_id];
-
 	/*
 	 *	If the bus, target or lun is out of range, return fail
 	 *	Test does not apply to ID 16, the pseudo id for the controller
