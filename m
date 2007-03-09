From: Judith Lebzelter <judith@linux-foundation.org>
Subject: [ PATCH ] mptsas: Fix oops for insmod during kexec
Date: Fri, 9 Mar 2007 13:07:44 -0800
Message-ID: <20070309210744.GD1006@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992557AbXCIVHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2007 16:07:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mpt_linux_developer@lsi.com, Eric.Moore@lsi.com, James.Bottomley@SteelEye.com

Hello,

This patch is to fix an oops on insmod for mptsas during kexec.
This applies to 2.6.21-rc3.

Signed-off-by:  Judith Lebzelter <judith@osdl.org

---


Index: linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.21-rc3.orig/drivers/message/fusion/mptsas.c
+++ linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
@@ -815,7 +815,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
 static int
 mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	MPT_SCSI_HOST	*hd;
 	struct mptsas_target_reset_event *target_reset_list, *n;
 	int rc;
 
@@ -827,7 +827,10 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int r
 	if (reset_phase != MPT_IOC_POST_RESET)
 		goto out;
 
-	if (!hd || !hd->ioc)
+	if (!ioc->sh || !ioc->sh->hostdata)
+		goto out;
+	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	if (!hd->ioc)
 		goto out;
 
 	if (list_empty(&hd->target_reset_list))

