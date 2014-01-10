From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 7/9] MPT / PCI: Use pci_stop_and_remove_bus_device_locked()
Date: Fri, 10 Jan 2014 15:27:56 +0100
Message-ID: <5291802.S1gYQvjIuc@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v094114.home.net.pl ([79.96.170.134]:56641 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752314AbaAJOQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 09:16:18 -0500
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Race conditions are theoretically possible between the MPT PCI
device removal and the generic PCI bus rescan and device removal
that can be triggered via sysfs.

To avoid those race conditions make the MPT PCI code use
pci_stop_and_remove_bus_device_locked().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/message/fusion/mptbase.c    |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/scsi/mpt3sas/mpt3sas_base.c
===================================================================
--- linux-pm.orig/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ linux-pm/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -131,7 +131,7 @@ static int mpt3sas_remove_dead_ioc_func(
 	pdev = ioc->pdev;
 	if ((pdev == NULL))
 		return -1;
-	pci_stop_and_remove_bus_device(pdev);
+	pci_stop_and_remove_bus_device_locked(pdev);
 	return 0;
 }
 
Index: linux-pm/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-pm.orig/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ linux-pm/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -128,7 +128,7 @@ static int mpt2sas_remove_dead_ioc_func(
 		pdev = ioc->pdev;
 		if ((pdev == NULL))
 			return -1;
-		pci_stop_and_remove_bus_device(pdev);
+		pci_stop_and_remove_bus_device_locked(pdev);
 		return 0;
 }
 
Index: linux-pm/drivers/message/fusion/mptbase.c
===================================================================
--- linux-pm.orig/drivers/message/fusion/mptbase.c
+++ linux-pm/drivers/message/fusion/mptbase.c
@@ -346,7 +346,7 @@ static int mpt_remove_dead_ioc_func(void
 	if ((pdev == NULL))
 		return -1;
 
-	pci_stop_and_remove_bus_device(pdev);
+	pci_stop_and_remove_bus_device_locked(pdev);
 	return 0;
 }
 

