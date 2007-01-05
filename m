From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Thu, 4 Jan 2007 20:46:13 -0700
Message-ID: <20070105034613.GA14118@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43913 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030315AbXAEDo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:44:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Simialar to the previous bug fix, this patch avoids
inifinite retries. This is replicated in Vmware environment
when the guest OS is using the 53c1030 as a emulated storage controller.
This patch will restore original driver behavior for SPI from about
a year ago, though keeping same behavor for FC/SAS for which it
solved a failover issue.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-12-25 01:51:26.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2006-12-25 01:55:05.000000000 -0700
@@ -779,7 +779,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			sc->resid=0;
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			if (scsi_status == MPI_SCSI_STATUS_BUSY)
+			if (ioc->bus_type != SPI && scsi_status == MPI_SCSI_STATUS_BUSY)
 				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
 			else
 				sc->result = (DID_OK << 16) | scsi_status;
