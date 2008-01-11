From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 3/3] mpt fusion: Fix for module load error when mptctl and mptsas are loaded in parallel
Date: Fri, 11 Jan 2008 14:46:30 +0530
Message-ID: <20080111091630.GD4161@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56686 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYAKJUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:20:13 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m0B9HRt8009141
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 01:17:28 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch fixes a panic at mptctl_probe -> mutex_init if the mptsas and mptcl module are loaded in parallel, this is because IOC is NULL, the fix is in mpt_device_register to call probe only with non-zero IOC pointer.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d733438..042bc86 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -729,6 +729,8 @@ mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
 
 	/* call per pci device probe entry point */
 	list_for_each_entry(ioc, &ioc_list, list) {
+		if (!pci_get_drvdata(ioc->pcidev))
+			continue;
 		id = ioc->pcidev->driver ?
 		    ioc->pcidev->driver->id_table : NULL;
 		if (dd_cbfunc->probe)
