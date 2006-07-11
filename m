From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 3/9] mptfusion: mptctl panic when loading
Date: Tue, 11 Jul 2006 17:38:43 -0600
Message-ID: <20060711233843.GA8640@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29651 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932266AbWGKXve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:51:34 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k6BNixXu004759
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 16:44:59 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k6BNpXQO012495
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 16:51:33 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix panic for when mptctl is loading at the same time
when one of the fusion llds (mptsas/mptfc/mptspi) is loading.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-07-10 11:28:52.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-07-11 12:26:19.000000000 -0600
@@ -678,19 +678,19 @@ int
 mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx)
 {
 	MPT_ADAPTER	*ioc;
+	const struct pci_device_id *id;
 
-	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS) {
+	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
 		return -EINVAL;
-	}
 
 	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
 
 	/* call per pci device probe entry point */
 	list_for_each_entry(ioc, &ioc_list, list) {
-		if(dd_cbfunc->probe) {
-			dd_cbfunc->probe(ioc->pcidev,
-			  ioc->pcidev->driver->id_table);
-  		}
+		id = ioc->pcidev->driver ?
+		    ioc->pcidev->driver->id_table : NULL;
+		if (dd_cbfunc->probe)
+			dd_cbfunc->probe(ioc->pcidev, id);
 	 }
 
 	return 0;
