From: Eric Moore <eric.moore@lsi.com>
Subject: RE: Mptlinux crashes on kernel 2.6.22.1
Date: Wed, 8 Aug 2007 12:12:23 -0600
Message-ID: <20070808181223.GA12287@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53950 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760901AbXHHSPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 14:15:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Thomas.Hommel@gefanuc.com

On 2007-08-02 14:16:49, Hommel, Thomas wrote:
> I am trying to use a LSI53C1020 based adapter on a PowerPC board with
> MPC8641D processor. When initializing, the driver crashes the system
> with the error message below. Kernel version is 2.6.22.1, driver
> 3.04.04. The chip on the adapter is a 53C1020, but the driver detects a
> 53C1030. Has anyone experienced similar problems already?


Try this patch out.  It appears that when loading the driver, your getting a
timeout when requesting a firmware config page. The timeout results in a
diag_reset of the controller, and all the ioc_reset callbacks are called for
every registered driver. When mptspi_ioc_reset is called, the hd object has
not be initialized.  The fix is to return when hd is NULL.  This object will
be setup once mptspi_probe has completed calling scsi_host_alloc.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-08-08 11:41:02.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-08-08 11:59:56.000000000 -0600
@@ -1249,14 +1249,20 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct _MPT_SCSI_HOST *hd = NULL;
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
+	if ((ioc->bus_type != SPI) || (!rc))
+		goto out;
 
-	if (reset_phase == MPT_IOC_POST_RESET)
-		mptspi_dv_renegotiate(hd);
+	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	if (!hd || !hd->ioc)
+		goto out;
 
+	if (ioc->active && reset_phase == MPT_IOC_POST_RESET)
+		mptspi_dv_renegotiate(hd);
+ out:
 	return rc;
 }
 

