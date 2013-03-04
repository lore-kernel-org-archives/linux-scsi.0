From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH 0/2] LSI SAS device removal fixes
Date: Mon, 4 Mar 2013 10:52:18 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:38699 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab3CDP4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 10:56:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com, support@lsi.com, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bjorn Helgaas <bhelgaas@google.com>, Joe Lawrence <joe.lawrence@stratus.com>

Hi folks,

I have two LSI fusion / mpt2sas / mpt3sas device removal patches. These
changes were tested against 3.8.0, but still apply cleanly to scsi.git,
branch "misc".

The first deletes pci_stop_and_remove_bus_device() calls from the three
drivers. I don't believe that this call is safe with respect to PCI
hotplug.  Interestingly these are the only SCSI LLD that attempt to do
this.

The second is an optimization in mpt2sas / mpt3sas for when an HBA is
removed during an async scan.  If the driver has determined that the HBA
is dead (once set, never cleared), it should not wait the entire async
scan timeout period of five minutes.

Joe Lawrence (2):
  mptfusion, mpt2sas, mpt3sas: Don't remove dead IOC PCI device
  mpt2sas, mpt3sas: set async scan finished on adapter removal

 drivers/message/fusion/mptbase.c     | 41 +----------------------------------
 drivers/scsi/mpt2sas/mpt2sas_base.c  | 42 ++----------------------------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 10 +++++++--
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 40 ++--------------------------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 ++++++++---
 5 files changed, 22 insertions(+), 123 deletions(-)

-- 
1.8.1.2

