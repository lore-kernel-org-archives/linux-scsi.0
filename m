From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 2.6] add adapter support to aacraid driver (update)
Date: Fri, 12 Mar 2004 12:47:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079124455.23909.77.camel@markh1.pdx.osdl.net>
References: <1079115773.23909.55.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38859 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262538AbUCLUrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 15:47:37 -0500
In-Reply-To: <1079115773.23909.55.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Fri, 2004-03-12 at 10:22, Mark Haverkamp wrote:
> This patch adds support for another adapter.

Mark S. said that there was another adapter added, and that they changed
the names of some boards.  Here is the updated version.

===== drivers/scsi/aacraid/linit.c 1.26 vs edited =====
--- 1.26/drivers/scsi/aacraid/linit.c	Fri Feb 13 05:57:38 2004
+++ edited/drivers/scsi/aacraid/linit.c	Fri Mar 12 11:19:14 2004
@@ -99,8 +99,8 @@
 
 	{ 0x9005, 0x0285, 0x9005, 0x0288, 0, 0, 16 }, /* Adaptec 3230S (Harrier)*/
 	{ 0x9005, 0x0285, 0x9005, 0x0289, 0, 0, 17 }, /* Adaptec 3240S (Tornado)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
+	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020 ZCR PCI-X U320 */
+	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2025 ZCR DIMM U320 */
 	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 20 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
 
 	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 21 }, /* Perc 320/DC*/
@@ -116,6 +116,8 @@
 	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* SATA 6Ch (Bearcat) */
 
 	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 31 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 32 }, /* ASR-2020SA      (ZCR PCI-X SATA) */
+	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 33 }, /* ASR-2025SA      (ZCR DIMM SATA) */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -145,8 +147,8 @@
 
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020ZCR     ", 2 }, /* ASR-2020 ZCR PCI-X U320 */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025ZCR     ", 2 }, /* ASR-2025 ZCR DIMM U320 */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
 
 	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
@@ -162,6 +164,8 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SATA 6Channel   ", 1 }, /* SATA 6Ch (Bearcat) */
 
 	{ aac_rkt_init,"aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA      ", 1 }, /* ASR-2020SA      (ZCR PCI-X SATA) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA      ", 1 }, /* ASR-2025SA      (ZCR DIMM SATA) */
 };
 
 /**

-- 
Mark Haverkamp <markh@osdl.org>

