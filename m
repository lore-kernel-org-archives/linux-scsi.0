From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Wed, 21 May 2003 10:32:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521173215.GA25137@praka.local.home>
References: <20030519225728.GA17279@praka.local.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:38799 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S262210AbTEURY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 13:24:26 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h4LHYIL13627
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2003 10:34:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20030519225728.GA17279@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <praka@san.rr.com>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

All,

If anyone is having problems with the 8.x driver and memory-mapped
I/O, attached is a small patch that should fix the problem.  The patch
is already rolled into my pre-beta3.

	pci_config_fix-v8.00.00b2.diff

Thanks go to Patrick Mansfield for reporting this.

Regards,
Andrew Vasquez

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pci_config_fix-v8.00.00b2.diff"

diff -X dontdiff -Nurd 80000b2/qla_def.h 80000b2-iobase_fix/qla_def.h
--- 80000b2/qla_def.h	2003-05-19 15:19:46.000000000 -0700
+++ 80000b2-iobase_fix/qla_def.h	2003-05-21 08:28:05.174690128 -0700
@@ -109,10 +109,8 @@
 /*
  * I/O register
 */
-/* #define MEMORY_MAPPED_IO  */    /* Enable memory mapped I/O */
-#undef MEMORY_MAPPED_IO            /* Disable memory mapped I/O */
 
-#if defined(MEMORY_MAPPED_IO)
+#if MEMORY_MAPPED_IO
 #define RD_REG_BYTE(addr)		readb(addr)
 #define RD_REG_WORD(addr)		readw(addr)
 #define RD_REG_DWORD(addr)		readl(addr)
diff -X dontdiff -Nurd 80000b2/qla_init.c 80000b2-iobase_fix/qla_init.c
--- 80000b2/qla_init.c	2003-05-19 15:19:46.000000000 -0700
+++ 80000b2-iobase_fix/qla_init.c	2003-05-21 08:32:19.771985456 -0700
@@ -496,7 +496,6 @@
 static uint8_t
 qla2x00_pci_config(scsi_qla_host_t *ha)
 {
-	uint8_t		status;
 	uint16_t	w;
 #if defined(ISP2300)
 	uint32_t	cnt;
@@ -520,8 +519,25 @@
 	pci_set_master(ha->pdev);
 	pci_read_config_word(ha->pdev, PCI_REVISION_ID, &ha->revision);
 
-	if (ha->iobase)
-		return 0;
+#if MEMORY_MAPPED_IO
+	/* Get memory mapped I/O address */
+	pci_read_config_dword(ha->pdev, PCI_BASE_ADDRESS_1, &mmapbase);
+	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
+
+	/* Find proper memory chunk for memory map I/O reg */
+	base = mmapbase & PAGE_MASK;
+	page_offset = mmapbase - base;
+
+	/* Get virtual address for I/O registers  */
+	ha->mmpbase = ioremap(base, page_offset + 256);
+	if (ha->mmpbase) {
+		ha->mmpbase += page_offset;
+		ha->iobase = (device_reg_t *)ha->mmpbase;
+	}
+#endif
+
+	if (!ha->iobase)
+		return 1;
 
 	/*
 	 * We want to respect framework's setting of PCI configuration space
@@ -599,28 +615,9 @@
 	w &= ~PCI_ROM_ADDRESS_ENABLE;
 	pci_write_config_word(ha->pdev, PCI_ROM_ADDRESS, w);
 
-	status = 0;
-#if MEMORY_MAPPED_IO
-	/* Get memory mapped I/O address */
-	pci_read_config_dword(ha->pdev, PCI_BASE_ADDRESS_1, &mmapbase);
-	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
-
-	/* Find proper memory chunk for memory map I/O reg */
-	base = mmapbase & PAGE_MASK;
-	page_offset = mmapbase - base;
-
-	/* Get virtual address for I/O registers  */
-	ha->mmpbase = ioremap(base, page_offset + 256);
-	if (ha->mmpbase) {
-		ha->mmpbase += page_offset;
-		ha->iobase = ha->mmpbase;
-		status = 0;
-	}
-#endif
-
 	LEAVE(__func__);
 
-	return (status);
+	return (0);
 }
 
 /**

--LZvS9be/3tNcYl/X--
