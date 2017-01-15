From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sun, 15 Jan 2017 09:01:13 -0800
Message-ID: <1484499673.2405.4.camel@linux.vnet.ibm.com>
References: <20161229080250.GA11605@infradead.org>
         <1483226343.2518.32.camel@linux.vnet.ibm.com>
         <1483280506.5512.1.camel@sandisk.com>
         <20170101.113311.417107391370623850.davem@davemloft.net>
         <1483292364.2345.5.camel@linux.vnet.ibm.com>
         <bd5a8849-e533-7d27-750b-0d89b8918c22@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751153AbdAORBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Jan 2017 12:01:24 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0FGwt1u103007
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2017 12:01:23 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27yjpw0m9a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2017 12:01:23 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sun, 15 Jan 2017 10:01:22 -0700
In-Reply-To: <bd5a8849-e533-7d27-750b-0d89b8918c22@akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>, David Miller <davem@davemloft.net>, Bart.VanAssche@sandisk.com
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, sagi@grimberg.me, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, dledford@redhat.com

On Tue, 2017-01-03 at 15:46 -0500, Jason Baron wrote:
> On 01/01/2017 12:39 PM, James Bottomley wrote:
> > +	/*
> > +	 * Bug work around for firmware SATL handling
> > +	 */
> > +	if (sas_device_priv_data->ata_command_pending) {
> > +		scmd->result = SAM_STAT_BUSY;
> > +		scmd->scsi_done(scmd);
> > +		return 0;
> > +	}
> > +	set_satl_pending(scmd, true);
> > +
> >  	sas_target_priv_data = sas_device_priv_data->sas_target;
> > 
> >  	/* invalid device handle */
> 
> 
> I was also wondering if 2 threads could both fall through and do:
> 'set_satl_pending(scmd, true)'; ?
> 
> Afaict there is nothing preventing that race?

Yes, it does look like queuecommand is lockless in the mpt3sas.  How
about this version using bitops for atomicity?

James

---

>From b47c28434e9cee9cbb95a794c97ec53657408111 Mon Sep 17 00:00:00 2001
From: James Bottomley <jejb@linux.vnet.ibm.com>
Date: Sun, 1 Jan 2017 09:39:24 -0800
Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands

mp3sas has a firmware failure where it can only handle one pass
through ATA command at a time.  If another comes in, contrary to the
SAT standard, it will hang until the first one completes (causing long
commands like secure erase to timeout).  The original fix was to block
the device when an ATA command came in, but this caused a regression
with

commit 669f044170d8933c3d66d231b69ea97cb8447338
Author: Bart Van Assche <bart.vanassche@sandisk.com>
Date:   Tue Nov 22 16:17:13 2016 -0800

    scsi: srp_transport: Move queuecommand() wait code to SCSI core

So fix the original fix of the secure erase timeout by properly
returning SAM_STAT_BUSY like the SAT recommends.

Fixes: 18f6084a989ba1b38702f9af37a2e4049a924be6
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

v2 - use bitops for lockless atomicity

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 394fe13..dcb33f4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -393,6 +393,7 @@ struct MPT3SAS_TARGET {
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
  * @eedp_block_length: block size
+ * @ata_command_pending: SATL passthrough outstanding for device
  */
 struct MPT3SAS_DEVICE {
 	struct MPT3SAS_TARGET *sas_target;
@@ -404,6 +405,17 @@ struct MPT3SAS_DEVICE {
 	u8	ignore_delay_remove;
 	/* Iopriority Command Handling */
 	u8	ncq_prio_enable;
+	/*
+	 * Bug workaround for SATL handling: the mpt2/3sas firmware
+	 * doesn't return BUSY or TASK_SET_FULL for subsequent
+	 * commands while a SATL pass through is in operation as the
+	 * spec requires, it simply does nothing with them until the
+	 * pass through completes, causing them possibly to timeout if
+	 * the passthrough is a long executing command (like format or
+	 * secure erase).  This variable allows us to do the right
+	 * thing while a SATL command is pending.
+	 */
+	unsigned long ata_command_pending;
 
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..6f9b4c0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3899,9 +3899,18 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+static int set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 {
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+	struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
+
+	if  (scmd->cmnd[0] != ATA_12 && scmd->cmnd[0] != ATA_16)
+		return 0;
+
+	if (pending)
+		return test_and_set_bit(0, &priv->ata_command_pending);
+
+	clear_bit(0, &priv->ata_command_pending);
+	return 0;
 }
 
 /**
@@ -3925,9 +3934,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
-		if (ata_12_16_cmd(scmd))
-			scsi_internal_device_unblock(scmd->device,
-							SDEV_RUNNING);
+		set_satl_pending(scmd, false);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4063,13 +4070,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
-	/*
-	 * Lock the device for any subsequent command until command is
-	 * done.
-	 */
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
-
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4083,6 +4083,17 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
+	/*
+	 * Bug work around for firmware SATL handling
+	 */
+	do {
+		if (sas_device_priv_data->ata_command_pending) {
+			scmd->result = SAM_STAT_BUSY;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
+	} while (set_satl_pending(scmd, true));
+
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
 	/* invalid device handle */
@@ -4650,8 +4661,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+	set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 

