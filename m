From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 09/12] [SCSI] mpt2sas : Set the phy identifier of the end
 device to the phy number of the parent device it is linked to
Date: Tue, 20 Mar 2012 12:08:40 +0530
Message-ID: <201203200638.q2K6c8tl000305@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:52445 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030265Ab2CTGiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:38:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Set the phy identifier of the end device to to the phy number of the parent device 
it is linked to. 

The phy_identifier inside the routine _transport_set_identify()
is set to sas_device_page_zero->PhyNum. This returns the
phy number of the parent device this device is linked to.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 3d04aca..5aaf42a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -169,6 +169,9 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	/* sas_address */
 	identify->sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
 
+	/* phy number of the parent device this device is linked to */
+	identify->phy_identifier = sas_device_pg0.PhyNum;
+
 	/* device_type */
 	switch (device_info & MPI2_SAS_DEVICE_INFO_MASK_DEVICE_TYPE) {
 	case MPI2_SAS_DEVICE_INFO_NO_DEVICE:
