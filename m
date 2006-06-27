From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptsas: Adding 1078 ROC support
Date: Tue, 27 Jun 2006 16:09:26 -0600
Message-ID: <20060627220925.GA29350@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:703 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422676AbWF0WUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 18:20:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

* Adding 1078 ROC (Raid On Chip) Support - New host adapter

* Moving all PCI Vendor/Device ids to using internal defines; a request
from Christoph/James B. some time ago for when the next chip was added.

* Removing SAS 1066/1066E Vendor/Device IDs, as there are no plans to
manufacture that controller.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-06-27 12:17:25.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-06-27 15:22:26.000000000 -0600
@@ -1220,31 +1220,25 @@
 	port = psize = 0;
 	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
 		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
+			if (psize)
+				continue;
 			/* Get I/O space! */
 			port = pci_resource_start(pdev, ii);
 			psize = pci_resource_len(pdev,ii);
 		} else {
+			if (msize)
+				continue;
 			/* Get memmap */
 			mem_phys = pci_resource_start(pdev, ii);
 			msize = pci_resource_len(pdev,ii);
-			break;
 		}
 	}
 	ioc->mem_size = msize;
 
-	if (ii == DEVICE_COUNT_RESOURCE) {
-		printk(KERN_ERR MYNAM ": ERROR - MPT adapter has no memory regions defined!\n");
-		kfree(ioc);
-		return -EINVAL;
-	}
-
-	dinitprintk((KERN_INFO MYNAM ": MPT adapter @ %lx, msize=%dd bytes\n", mem_phys, msize));
-	dinitprintk((KERN_INFO MYNAM ": (port i/o @ %lx, psize=%dd bytes)\n", port, psize));
-
 	mem = NULL;
 	/* Get logical ptr for PciMem0 space */
 	/*mem = ioremap(mem_phys, msize);*/
-	mem = ioremap(mem_phys, 0x100);
+	mem = ioremap(mem_phys, msize);
 	if (mem == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Unable to map adapter memory!\n");
 		kfree(ioc);
@@ -1344,11 +1338,6 @@
 		ioc->bus_type = SAS;
 		ioc->errata_flag_1064 = 1;
 	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066) {
-		ioc->prod_name = "LSISAS1066";
-		ioc->bus_type = SAS;
-		ioc->errata_flag_1064 = 1;
-	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068) {
 		ioc->prod_name = "LSISAS1068";
 		ioc->bus_type = SAS;
@@ -1358,14 +1347,14 @@
 		ioc->prod_name = "LSISAS1064E";
 		ioc->bus_type = SAS;
 	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1066E) {
-		ioc->prod_name = "LSISAS1066E";
-		ioc->bus_type = SAS;
-	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068E) {
 		ioc->prod_name = "LSISAS1068E";
 		ioc->bus_type = SAS;
 	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
+		ioc->prod_name = "LSISAS1078";
+		ioc->bus_type = SAS;
+	}
 
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
@@ -3185,6 +3174,37 @@
 	u32 diag1val = 0;
 #endif
 
+	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
+		drsprintk((MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
+			"address=%p\n",  ioc->name, __FUNCTION__,
+			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
+		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
+		if (sleepFlag == CAN_SLEEP)
+			msleep(1);
+		else
+			mdelay(1);
+
+		for (count = 0; count < 60; count ++) {
+			doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
+			doorbell &= MPI_IOC_STATE_MASK;
+
+			drsprintk((MYIOC_s_INFO_FMT
+				"looking for READY STATE: doorbell=%x"
+			        " count=%d\n",
+				ioc->name, doorbell, count));
+			if (doorbell == MPI_IOC_STATE_READY) {
+				return 0;
+			}
+
+			/* wait 1 sec */
+			if (sleepFlag == CAN_SLEEP)
+				msleep(1000);
+			else
+				mdelay(1000);
+		}
+		return -1;
+	}
+
 	/* Clear any existing interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-06-27 12:22:45.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-06-27 15:24:01.000000000 -0600
@@ -308,7 +308,8 @@
 	u32	HostIndex;	/* 50     Host Index register        */
 	u32	Reserved4[15];	/* 54-8F                             */
 	u32	Fubar;		/* 90     For Fubar usage            */
-	u32	Reserved5[27];	/* 94-FF                             */
+	u32     Reserved5[1050];/* 94-10F8                           */
+	u32     Reset_1078;     /* 10FC   Reset 1078                 */
 } SYSIF_REGS;
 
 /*
diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-06-15 15:16:10.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2006-06-27 15:14:15.000000000 -0600
@@ -132,21 +132,21 @@
  */
 
 static struct pci_device_id mptfc_pci_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC909,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919X,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919X,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929X,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929X,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC939X,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC939X,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC949X,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949X,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC949ES,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-06-27 12:25:28.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-06-27 15:17:03.000000000 -0600
@@ -2757,17 +2757,15 @@
 }
 
 static struct pci_device_id mptsas_pci_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064E,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064E,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068E,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1066E,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1068E,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1078,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-06-27 15:12:53.000000000 -0600
@@ -775,9 +775,9 @@
  */
 
 static struct pci_device_id mptspi_pci_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1030,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
 		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_1030_53C1035,
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1035,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
