From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/08] mptfusion: Corrected declaration of device_missing_delay
Date: Thu, 17 Jun 2010 14:39:25 +0530
Message-ID: <20100617090916.GD29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:59419 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320Ab0FQJpB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:45:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

device missing delay is 8 bit value in io unit pg1. Making correct variable
declaration for device_missing_delay.

The driver is storing the calculated device missing delay in IOC structure
as a u8 instead of a u16. It needs to be a u16 if the delay is > 255.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b613eb3..453bcb7 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -601,7 +601,7 @@ typedef struct _MPT_ADAPTER
 	u16			 nvdata_version_default;
 	int			 debug_level;
 	u8			 io_missing_delay;
-	u8			 device_missing_delay;
+	u16			 device_missing_delay;
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
 	u8			 bus_type;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ac000e8..1caf03e 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2364,7 +2364,7 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 	SasIOUnitPage1_t *buffer;
 	dma_addr_t dma_handle;
 	int error;
-	u16 device_missing_delay;
+	u8 device_missing_delay;
 
 	memset(&hdr, 0, sizeof(ConfigExtendedPageHeader_t));
 	memset(&cfg, 0, sizeof(CONFIGPARMS));
@@ -2401,7 +2401,7 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 
 	ioc->io_missing_delay  =
 	    le16_to_cpu(buffer->IODeviceMissingDelay);
-	device_missing_delay = le16_to_cpu(buffer->ReportDeviceMissingDelay);
+	device_missing_delay = buffer->ReportDeviceMissingDelay;
 	ioc->device_missing_delay = (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_UNIT_16) ?
 	    (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16 :
 	    device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
