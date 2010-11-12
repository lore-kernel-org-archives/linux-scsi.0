From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/11] mpt2sas: Added loadtime para for IOMissingDelay and DMD
Date: Sat, 13 Nov 2010 04:32:18 +0530
Message-ID: <20101112230211.GE853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:45970 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab0KLXom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:44:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Ability to override/set the ReportDeviceMissingDelay and
IODeviceMissingDelay from driver: Add new command line option missing_delay,
this is an array, where the first element is the device missing delay,
and the second element is io missing delay.  The driver will program
sas iounit page 1 with the new setting when the driver loads. This is
programmed to the current and persistent configuration page so this takes
immediately, as will be sticky across host reboots.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d1c5345..3a4404e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -79,6 +79,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
 /* diag_buffer_enable is bitwise
  * bit 0 set = TRACE
  * bit 1 set = SNAPSHOT
@@ -1823,6 +1827,97 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * _base_update_missing_delay - change the missing delay timers
+ * @ioc: per adapter object
+ * @device_missing_delay: amount of time till device is reported missing
+ * @io_missing_delay: interval IO is returned when there is a missing device
+ *
+ * Return nothing.
+ *
+ * Passed on the command line, this function will modify the device missing
+ * delay, as well as the io missing delay. This should be called at driver
+ * load time.
+ */
+static void
+_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay)
+{
+	u16 dmd, dmd_new, dmd_orignal;
+	u8 io_missing_delay_original;
+	u16 sz;
+	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi2ConfigReply_t mpi_reply;
+	u8 num_phys = 0;
+	u16 ioc_status;
+
+	mpt2sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys)
+		return;
+
+	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (num_phys *
+	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg1) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	if ((mpt2sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz))) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	/* device missing delay */
+	dmd = sas_iounit_pg1->ReportDeviceMissingDelay;
+	if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+		dmd = (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+	else
+		dmd = dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+	dmd_orignal = dmd;
+	if (device_missing_delay > 0x7F) {
+		dmd = (device_missing_delay > 0x7F0) ? 0x7F0 :
+		    device_missing_delay;
+		dmd = dmd / 16;
+		dmd |= MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16;
+	} else
+		dmd = device_missing_delay;
+	sas_iounit_pg1->ReportDeviceMissingDelay = dmd;
+
+	/* io missing delay */
+	io_missing_delay_original = sas_iounit_pg1->IODeviceMissingDelay;
+	sas_iounit_pg1->IODeviceMissingDelay = io_missing_delay;
+
+	if (!mpt2sas_config_set_sas_iounit_pg1(ioc, &mpi_reply, sas_iounit_pg1,
+	    sz)) {
+		if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+			dmd_new = (dmd &
+			    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+		else
+			dmd_new =
+		    dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+		printk(MPT2SAS_INFO_FMT "device_missing_delay: old(%d), "
+		    "new(%d)\n", ioc->name, dmd_orignal, dmd_new);
+		printk(MPT2SAS_INFO_FMT "ioc_missing_delay: old(%d), "
+		    "new(%d)\n", ioc->name, io_missing_delay_original,
+		    io_missing_delay);
+		ioc->device_missing_delay = dmd_new;
+		ioc->io_missing_delay = io_missing_delay;
+	}
+
+out:
+	kfree(sas_iounit_pg1);
+}
+
+/**
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
  *
@@ -1859,6 +1954,7 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING;
 	ioc->iounit_pg1.Flags = cpu_to_le32(iounit_pg1_flags);
 	mpt2sas_config_set_iounit_pg1(ioc, &mpi_reply, &ioc->iounit_pg1);
+
 }
 
 /**
@@ -3720,6 +3816,10 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
+	if (missing_delay[0] != -1 && missing_delay[1] != -1)
+		_base_update_missing_delay(ioc, missing_delay[0],
+		    missing_delay[1]);
+
 	mpt2sas_base_start_watchdog(ioc);
 	return 0;
 
