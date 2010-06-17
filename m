From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/08] mptfusion: Set fw_events_off to 1 at driver load time.
Date: Thu, 17 Jun 2010 14:35:46 +0530
Message-ID: <20100617090538.GB29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55725 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568Ab0FQJlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:41:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


fw_events_off is flag checking for driver to do Event handling or not.
Normally it should be OFF at the time of initialization. Only enable it at
the time of INTR enable of device first time. This will always occur only
after resource allocation.

ioc->fw_events_off = 1 is set in mpt_attach()

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a6a5701..49005e1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1913,6 +1913,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->msi_enable = 0;
 		break;
 	}
+
+	ioc->fw_events_off = 1;
+
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
 
