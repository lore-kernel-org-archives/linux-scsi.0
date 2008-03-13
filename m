From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Thu, 13 Mar 2008 06:55:08 -0600
Message-ID: <20080313125508.GF613@parisc-linux.org>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <200803122125.50161.us-@gmx.de> <1205357733.2941.160.camel@localhost.localdomain> <200803130709.44066.us-@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50891 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYCMMzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 08:55:25 -0400
Content-Disposition: inline
In-Reply-To: <200803130709.44066.us-@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ulrich Schweitzer <us-@gmx.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Thu, Mar 13, 2008 at 07:09:43AM +0100, Ulrich Schweitzer wrote:
> If its not going to be ported, I guess we should add a sentence to the help 
> text of CONFIG_SCSI_BUSLOGIC so people like me don't think its a bug. 
> Something like "Flashpoint Host Adapter support is only available on x86 but 
> not on x86_64 systems."
> Would one of you please submit such a patch? I've never submitted a kernel 
> patch and don't know how to do it.

How does this look?  I've inverted the sense of the flashpoint config
option and neatened up the PCI-less support while I was there.

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 4d3ebb1..2d689af 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -896,7 +896,7 @@ static int __init BusLogic_InitializeFlashPointProbeInfo(struct BusLogic_HostAda
 		IRQ_Channel = PCI_Device->irq;
 		IO_Address = BaseAddress0 = pci_resource_start(PCI_Device, 0);
 		PCI_Address = BaseAddress1 = pci_resource_start(PCI_Device, 1);
-#ifndef CONFIG_SCSI_OMIT_FLASHPOINT
+#ifdef CONFIG_SCSI_FLASHPOINT
 		if (pci_resource_flags(PCI_Device, 0) & IORESOURCE_MEM) {
 			BusLogic_Error("BusLogic: Base Address0 0x%X not I/O for " "FlashPoint Host Adapter\n", NULL, BaseAddress0);
 			BusLogic_Error("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, Bus, Device, IO_Address);
@@ -1006,6 +1006,9 @@ static void __init BusLogic_InitializeProbeInfoList(struct BusLogic_HostAdapter
 }
 
 
+#else
+#define BusLogic_InitializeProbeInfoList(adapter) \
+		BusLogic_InitializeProbeInfoListISA(adapter)
 #endif				/* CONFIG_PCI */
 
 
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index bfbfb5c..73f237a 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -34,23 +34,6 @@
 #endif
 
 /*
-  FlashPoint support is only available for the Intel x86 Architecture with
-  CONFIG_PCI set.
-*/
-
-#ifndef __i386__
-#undef CONFIG_SCSI_OMIT_FLASHPOINT
-#define CONFIG_SCSI_OMIT_FLASHPOINT
-#endif
-
-#ifndef CONFIG_PCI
-#undef CONFIG_SCSI_OMIT_FLASHPOINT
-#define CONFIG_SCSI_OMIT_FLASHPOINT
-#define BusLogic_InitializeProbeInfoListISA BusLogic_InitializeProbeInfoList
-#endif
-
-
-/*
   Define the maximum number of BusLogic Host Adapters supported by this driver.
 */
 
@@ -178,7 +161,7 @@ static int BusLogic_HostAdapterAddressCount[3] = { 0, BusLogic_MultiMasterAddres
   Define macros for testing the Host Adapter Type.
 */
 
-#ifndef CONFIG_SCSI_OMIT_FLASHPOINT
+#ifdef CONFIG_SCSI_FLASHPOINT
 
 #define BusLogic_MultiMasterHostAdapterP(HostAdapter) \
   (HostAdapter->HostAdapterType == BusLogic_MultiMaster)
@@ -871,7 +854,7 @@ struct BusLogic_CCB {
 	void (*CallbackFunction) (struct BusLogic_CCB *);	/* Bytes 40-43 */
 	u32 BaseAddress;	/* Bytes 44-47 */
 	enum BusLogic_CompletionCode CompletionCode;	/* Byte 48 */
-#ifndef CONFIG_SCSI_OMIT_FLASHPOINT
+#ifdef CONFIG_SCSI_FLASHPOINT
 	unsigned char:8;	/* Byte 49 */
 	unsigned short OS_Flags;	/* Bytes 50-51 */
 	unsigned char Private[48];	/* Bytes 52-99 */
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 1c90781..b374e45 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -16,7 +16,7 @@
 */
 
 
-#ifndef CONFIG_SCSI_OMIT_FLASHPOINT
+#ifdef CONFIG_SCSI_FLASHPOINT
 
 #define MAX_CARDS	8
 #undef BUSTYPE_PCI
@@ -7626,7 +7626,7 @@ FlashPoint__HandleInterrupt(FlashPoint_CardHandle_T CardHandle)
 #define FlashPoint_InterruptPending	    FlashPoint__InterruptPending
 #define FlashPoint_HandleInterrupt	    FlashPoint__HandleInterrupt
 
-#else				/* CONFIG_SCSI_OMIT_FLASHPOINT */
+#else				/* !CONFIG_SCSI_FLASHPOINT */
 
 /*
   Define prototypes for the FlashPoint SCCB Manager Functions.
@@ -7641,4 +7641,4 @@ extern bool FlashPoint_InterruptPending(FlashPoint_CardHandle_T);
 extern int FlashPoint_HandleInterrupt(FlashPoint_CardHandle_T);
 extern void FlashPoint_ReleaseHostAdapter(FlashPoint_CardHandle_T);
 
-#endif				/* CONFIG_SCSI_OMIT_FLASHPOINT */
+#endif				/* CONFIG_SCSI_FLASHPOINT */
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c46666a..196d7d0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -588,18 +588,20 @@ config SCSI_BUSLOGIC
 	  <http://www.tldp.org/docs.html#howto>, and the files
 	  <file:Documentation/scsi/BusLogic.txt> and
 	  <file:Documentation/scsi/FlashPoint.txt> for more information.
+	  Note that support for FlashPoint is only available for 32-bit
+	  x86 configurations.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called BusLogic.
 
-config SCSI_OMIT_FLASHPOINT
-	bool "Omit FlashPoint support"
-	depends on SCSI_BUSLOGIC
+config SCSI_FLASHPOINT
+	bool "FlashPoint support"
+	depends on SCSI_BUSLOGIC && PCI && X86_32
 	help
-	  This option allows you to omit the FlashPoint support from the
+	  This option allows you to add FlashPoint support to the
 	  BusLogic SCSI driver. The FlashPoint SCCB Manager code is
-	  substantial, so users of MultiMaster Host Adapters may wish to omit
-	  it.
+	  substantial, so users of MultiMaster Host Adapters may not
+	  wish to include it.
 
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
