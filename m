From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] a100u2w: Convert into Linux style
Date: Fri, 15 Jun 2007 00:11:22 +0100
Message-ID: <20070615001122.0abccc5e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55202 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753372AbXFNXGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 19:06:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mr Bowtie <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I was investigating strange driver behaviour and thought that readable
code and proper visible types might help explain why it didn't work right
the moment a second SCB was outstanding to the controller. I was right

- Cleanup, linuxise, demacro
- Remove the BSD dual licence on the new work
- Switch the if ALPHA to if __LP64__. (struct size is then right elsewhere)
- Fix the recursive locking on a reset. This is the only actual real code
change (I hope ;)).

I'm not clear what the right way to handle the BIOS param stuff is on n
on x86-32/64. Using phys_to_virt and stuff is ugly and probably doesn't
make sense elsewhere

Still has a couple of odd things - and there seems to be a commonly shared
EEPROM handling error several drivers have. Roughly speaking several SCSI
drivers go

	try and read EEPROM
	It failed..
	Write any changes between the default and the data we read

	Which is great as for some paths we've no idea what was in before, so
	each boot won't write it all back, won't checksum but will repeat the bug

Also it can still sleep for a second with IRQ off, and there is some dubious
looking error path locking marked FIXME in case anyone feels inspired to work
on it. Not a newly introduced bug, and at least its now marked.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/a100u2w.c linux-2.6.22-rc4-mm2/drivers/scsi/a100u2w.c
--- linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/a100u2w.c	2007-06-07 14:26:09.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/scsi/a100u2w.c	2007-06-14 16:59:06.000000000 +0100
@@ -19,27 +19,6 @@
  * along with this program; see the file COPYING.  If not, write to
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * --------------------------------------------------------------------------
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Where this Software is combined with software released under the terms of 
- * the GNU General Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
- *
  * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
  * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
@@ -75,6 +54,8 @@
  * 9/28/04 Christoph Hellwig <hch@lst.de>
  *	    - merge the two source files
  *	    - remove internal queueing code
+ * 14/06/07 Alan Cox <alan@redhat.com>
+ *	 - Grand cleanup and Linuxisation
  */
 
 #include <linux/module.h>
@@ -102,14 +83,12 @@
 #include "a100u2w.h"
 
 
-#define JIFFIES_TO_MS(t) ((t) * 1000 / HZ)
-#define MS_TO_JIFFIES(j) ((j * HZ) / 1000)
+static struct orc_scb *__orc_alloc_scb(struct orc_host * host);
+static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb);
 
-static ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
-static void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
+static struct orc_nvram nvram, *nvramp = &nvram;
 
-static NVRAM nvram, *nvramp = &nvram;
-static UCHAR dftNvRam[64] =
+static u8 default_nvram[64] =
 {
 /*----------header -------------*/
 	0x01,			/* 0x00: Sub System Vendor ID 0 */
@@ -158,815 +137,882 @@
 };
 
 
-/***************************************************************************/
-static void waitForPause(unsigned amount)
-{
-	ULONG the_time = jiffies + MS_TO_JIFFIES(amount);
-	while (time_before_eq(jiffies, the_time))
-		cpu_relax();
-}
-
-/***************************************************************************/
-static UCHAR waitChipReady(ORC_HCS * hcsp)
+static u8 wait_chip_ready(struct orc_host * host)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
-		if (ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & HOSTSTOP)	/* Wait HOSTSTOP set */
+		if (inb(host->base + ORC_HCTRL) & HOSTSTOP)	/* Wait HOSTSTOP set */
 			return 1;
-		waitForPause(100);	/* wait 100ms before try again  */
+		mdelay(100);
 	}
 	return 0;
 }
 
-/***************************************************************************/
-static UCHAR waitFWReady(ORC_HCS * hcsp)
+static u8 wait_firmware_ready(struct orc_host * host)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
-		if (ORC_RD(hcsp->HCS_Base, ORC_HSTUS) & RREADY)		/* Wait READY set */
+		if (inb(host->base + ORC_HSTUS) & RREADY)		/* Wait READY set */
 			return 1;
-		waitForPause(100);	/* wait 100ms before try again  */
+		mdelay(100);	/* wait 100ms before try again  */
 	}
 	return 0;
 }
 
 /***************************************************************************/
-static UCHAR waitSCSIRSTdone(ORC_HCS * hcsp)
+static u8 wait_scsi_reset_done(struct orc_host * host)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
-		if (!(ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & SCSIRST))	/* Wait SCSIRST done */
+		if (!(inb(host->base + ORC_HCTRL) & SCSIRST))	/* Wait SCSIRST done */
 			return 1;
-		waitForPause(100);	/* wait 100ms before try again  */
+		mdelay(100);	/* wait 100ms before try again  */
 	}
 	return 0;
 }
 
 /***************************************************************************/
-static UCHAR waitHDOoff(ORC_HCS * hcsp)
+static u8 wait_HDO_off(struct orc_host * host)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
-		if (!(ORC_RD(hcsp->HCS_Base, ORC_HCTRL) & HDO))		/* Wait HDO off */
+		if (!(inb(host->base + ORC_HCTRL) & HDO))		/* Wait HDO off */
 			return 1;
-		waitForPause(100);	/* wait 100ms before try again  */
+		mdelay(100);	/* wait 100ms before try again  */
 	}
 	return 0;
 }
 
 /***************************************************************************/
-static UCHAR waitHDIset(ORC_HCS * hcsp, UCHAR * pData)
+static u8 wait_hdi_set(struct orc_host * host, u8 * data)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {	/* Wait 1 second for report timeout     */
-		if ((*pData = ORC_RD(hcsp->HCS_Base, ORC_HSTUS)) & HDI)
+		if ((*data = inb(host->base + ORC_HSTUS)) & HDI)
 			return 1;	/* Wait HDI set */
-		waitForPause(100);	/* wait 100ms before try again  */
+		mdelay(100);	/* wait 100ms before try again  */
 	}
 	return 0;
 }
 
 /***************************************************************************/
-static unsigned short get_FW_version(ORC_HCS * hcsp)
+static unsigned short orc_read_fwrev(struct orc_host * host)
 {
-	UCHAR bData;
-	union {
-		unsigned short sVersion;
-		unsigned char cVersion[2];
-	} Version;
-
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_VERSION);
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	u16 version;
+	u8 data;
+	
+	outb(ORC_CMD_VERSION, host->base + ORC_HDATA);
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+	if (wait_hdi_set(host, &data) == 0)	/* Wait HDI set   */
 		return 0;
-	Version.cVersion[0] = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
-	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI            */
+	version = inb(host->base + ORC_HDATA);
+	outb(data, host->base + ORC_HSTUS);	/* Clear HDI            */
 
-	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+	if (wait_hdi_set(host, &data) == 0)	/* Wait HDI set   */
 		return 0;
-	Version.cVersion[1] = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
-	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI            */
+	version |= inb(host->base + ORC_HDATA) << 8;
+	outb(data, host->base + ORC_HSTUS);	/* Clear HDI            */
 
-	return (Version.sVersion);
+	return version;
 }
 
 /***************************************************************************/
-static UCHAR set_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char value)
+static u8 orc_nv_write(struct orc_host * host, unsigned char address, unsigned char value)
 {
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_SET_NVM);	/* Write command */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(ORC_CMD_SET_NVM, host->base + ORC_HDATA);	/* Write command */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, address);	/* Write address */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(address, host->base + ORC_HDATA);	/* Write address */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, value);	/* Write value  */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(value, host->base + ORC_HDATA);	/* Write value  */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
 	return 1;
 }
 
 /***************************************************************************/
-static UCHAR get_NVRAM(ORC_HCS * hcsp, unsigned char address, unsigned char *pDataIn)
+static u8 orc_nv_read(struct orc_host * host, u8 address, u8 *ptr)
 {
-	unsigned char bData;
+	unsigned char data;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_GET_NVM);	/* Write command */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(ORC_CMD_GET_NVM, host->base + ORC_HDATA);	/* Write command */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, address);	/* Write address */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(address, host->base + ORC_HDATA);	/* Write address */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+	if (wait_hdi_set(host, &data) == 0)	/* Wait HDI set   */
 		return 0;
-	*pDataIn = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
-	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI    */
+	*ptr = inb(host->base + ORC_HDATA);
+	outb(data, host->base + ORC_HSTUS);	/* Clear HDI    */
 
 	return 1;
+
 }
 
-/***************************************************************************/
-static void orc_exec_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
+/**
+ *	orc_exec_sb		-	Queue an SCB with the HA
+ *	@host: host adapter the SCB belongs to
+ *	@scb: SCB to queue for execution
+ */
+
+static void orc_exec_scb(struct orc_host * host, struct orc_scb * scb)
 {
-	scbp->SCB_Status = ORCSCB_POST;
-	ORC_WR(hcsp->HCS_Base + ORC_PQUEUE, scbp->SCB_ScbIdx);
-	return;
+	scb->status = ORCSCB_POST;
+	outb(scb->scbidx, host->base + ORC_PQUEUE);
 }
 
 
-/***********************************************************************
- Read SCSI H/A configuration parameters from serial EEPROM
-************************************************************************/
-static int se2_rd_all(ORC_HCS * hcsp)
+/**
+ *	se2_rd_all	-	read SCSI parameters from EEPROM
+ *	@host: Host whose EEPROM is being loaded
+ *
+ *	Read SCSI H/A configuration parameters from serial EEPROM
+ */
+
+static int se2_rd_all(struct orc_host * host)
 {
 	int i;
-	UCHAR *np, chksum = 0;
+	u8 *np, chksum = 0;
 
-	np = (UCHAR *) nvramp;
+	np = (u8 *) nvramp;
 	for (i = 0; i < 64; i++, np++) {	/* <01> */
-		if (get_NVRAM(hcsp, (unsigned char) i, np) == 0)
+		if (orc_nv_read(host, (u8) i, np) == 0)
 			return -1;
-//      *np++ = get_NVRAM(hcsp, (unsigned char ) i);
 	}
 
-/*------ Is ckecksum ok ? ------*/
-	np = (UCHAR *) nvramp;
+	/*------ Is ckecksum ok ? ------*/
+	np = (u8 *) nvramp;
 	for (i = 0; i < 63; i++)
 		chksum += *np++;
 
-	if (nvramp->CheckSum != (UCHAR) chksum)
+	if (nvramp->CheckSum != (u8) chksum)
 		return -1;
 	return 1;
 }
 
-/************************************************************************
- Update SCSI H/A configuration parameters from serial EEPROM
-*************************************************************************/
-static void se2_update_all(ORC_HCS * hcsp)
+/**
+ *	se2_update_all		-	update the EEPROM
+ *	@host: Host whose EEPROM is being updated
+ *
+ *	Update changed bytes in the EEPROM image.
+ */
+
+static void se2_update_all(struct orc_host * host)
 {				/* setup default pattern  */
 	int i;
-	UCHAR *np, *np1, chksum = 0;
+	u8 *np, *np1, chksum = 0;
 
 	/* Calculate checksum first   */
-	np = (UCHAR *) dftNvRam;
+	np = (u8 *) default_nvram;
 	for (i = 0; i < 63; i++)
 		chksum += *np++;
 	*np = chksum;
 
-	np = (UCHAR *) dftNvRam;
-	np1 = (UCHAR *) nvramp;
+	np = (u8 *) default_nvram;
+	np1 = (u8 *) nvramp;
 	for (i = 0; i < 64; i++, np++, np1++) {
-		if (*np != *np1) {
-			set_NVRAM(hcsp, (unsigned char) i, *np);
-		}
+		if (*np != *np1)
+			orc_nv_write(host, (u8) i, *np);
 	}
-	return;
 }
 
-/*************************************************************************
- Function name  : read_eeprom
-**************************************************************************/
-static void read_eeprom(ORC_HCS * hcsp)
+/**
+ *	read_eeprom		-	load EEPROM
+ *	@host: Host EEPROM to read
+ *
+ *	Read the EEPROM for a given host. If it is invalid or fails
+ *	the restore the defaults and use them.
+ */
+
+static void read_eeprom(struct orc_host * host)
 {
-	if (se2_rd_all(hcsp) != 1) {
-		se2_update_all(hcsp);	/* setup default pattern        */
-		se2_rd_all(hcsp);	/* load again                   */
+	if (se2_rd_all(host) != 1) {
+		se2_update_all(host);	/* setup default pattern        */
+		se2_rd_all(host);	/* load again                   */
 	}
 }
 
 
-/***************************************************************************/
-static UCHAR load_FW(ORC_HCS * hcsp)
-{
-	U32 dData;
-	USHORT wBIOSAddress;
-	USHORT i;
-	UCHAR *pData, bData;
-
+/**
+ *	orc_load_firmware	-	initialise firmware
+ *	@host: Host to set up
+ *
+ *	Load the firmware from the EEPROM into controller SRAM. This
+ *	is basically a 4K block copy and then a 4K block read to check
+ *	correctness. The rest is convulted by the indirect interfaces
+ *	in the hardware
+ */
 
-	bData = ORC_RD(hcsp->HCS_Base, ORC_GCFG);
-	ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData | EEPRG);	/* Enable EEPROM programming */
-	ORC_WR(hcsp->HCS_Base + ORC_EBIOSADR2, 0x00);
-	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x00);
-	if (ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA) != 0x55) {
-		ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
+static u8 orc_load_firmware(struct orc_host * host)
+{
+	u32 data32;
+	u16 bios_addr;
+	u16 i;
+	u8 *data32_ptr, data;
+
+
+	/* Set up the EEPROM for access */
+	
+	data = inb(host->base + ORC_GCFG);
+	outb(data | EEPRG, host->base + ORC_GCFG);	/* Enable EEPROM programming */
+	outb(0x00, host->base + ORC_EBIOSADR2);
+	outw(0x0000, host->base + ORC_EBIOSADR0);
+	if (inb(host->base + ORC_EBIOSDATA) != 0x55) {
+		outb(data, host->base + ORC_GCFG);	/* Disable EEPROM programming */
 		return 0;
 	}
-	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x01);
-	if (ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA) != 0xAA) {
-		ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
+	outw(0x0001, host->base + ORC_EBIOSADR0);
+	if (inb(host->base + ORC_EBIOSDATA) != 0xAA) {
+		outb(data, host->base + ORC_GCFG);	/* Disable EEPROM programming */
 		return 0;
 	}
-	ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST | DOWNLOAD);	/* Enable SRAM programming */
-	pData = (UCHAR *) & dData;
-	dData = 0;		/* Initial FW address to 0 */
-	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x10);
-	*pData = ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA);		/* Read from BIOS */
-	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x11);
-	*(pData + 1) = ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA);	/* Read from BIOS */
-	ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, 0x12);
-	*(pData + 2) = ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA);	/* Read from BIOS */
-	ORC_WR(hcsp->HCS_Base + ORC_EBIOSADR2, *(pData + 2));
-	ORC_WRLONG(hcsp->HCS_Base + ORC_FWBASEADR, dData);	/* Write FW address */
+	
+	outb(PRGMRST | DOWNLOAD, host->base + ORC_RISCCTL);	/* Enable SRAM programming */
+	data32_ptr = (u8 *) & data32;
+	data32 = 0;		/* Initial FW address to 0 */
+	outw(0x0010, host->base + ORC_EBIOSADR0);
+	*data32_ptr = inb(host->base + ORC_EBIOSDATA);		/* Read from BIOS */
+	outw(0x0011, host->base + ORC_EBIOSADR0);
+	*(data32_ptr + 1) = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
+	outw(0x0012, host->base + ORC_EBIOSADR0);
+	*(data32_ptr + 2) = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
+	outw(*(data32_ptr + 2), host->base + ORC_EBIOSADR2);
+	outl(data32, host->base + ORC_FWBASEADR);		/* Write FW address */
 
-	wBIOSAddress = (USHORT) dData;	/* FW code locate at BIOS address + ? */
-	for (i = 0, pData = (UCHAR *) & dData;	/* Download the code    */
+	/* Copy the code from the BIOS to the SRAM */
+
+	bios_addr = (u16) data32;	/* FW code locate at BIOS address + ? */
+	for (i = 0, data32_ptr = (u8 *) & data32;	/* Download the code    */
 	     i < 0x1000;	/* Firmware code size = 4K      */
-	     i++, wBIOSAddress++) {
-		ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, wBIOSAddress);
-		*pData++ = ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA);	/* Read from BIOS */
+	     i++, bios_addr++) {
+		outw(bios_addr, host->base + ORC_EBIOSADR0);
+		*data32_ptr++ = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
 		if ((i % 4) == 3) {
-			ORC_WRLONG(hcsp->HCS_Base + ORC_RISCRAM, dData);	/* Write every 4 bytes */
-			pData = (UCHAR *) & dData;
+			outl(data32, host->base + ORC_RISCRAM);	/* Write every 4 bytes */
+			data32_ptr = (u8 *) & data32;
 		}
 	}
 
-	ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST | DOWNLOAD);	/* Reset program count 0 */
-	wBIOSAddress -= 0x1000;	/* Reset the BIOS adddress      */
-	for (i = 0, pData = (UCHAR *) & dData;	/* Check the code       */
+	/* Go back and check they match */
+
+	outb(PRGMRST | DOWNLOAD, host->base + ORC_RISCCTL);	/* Reset program count 0 */
+	bios_addr -= 0x1000;	/* Reset the BIOS adddress      */
+	for (i = 0, data32_ptr = (u8 *) & data32;	/* Check the code       */
 	     i < 0x1000;	/* Firmware code size = 4K      */
-	     i++, wBIOSAddress++) {
-		ORC_WRSHORT(hcsp->HCS_Base + ORC_EBIOSADR0, wBIOSAddress);
-		*pData++ = ORC_RD(hcsp->HCS_Base, ORC_EBIOSDATA);	/* Read from BIOS */
+	     i++, bios_addr++) {
+		outw(bios_addr, host->base + ORC_EBIOSADR0);
+		*data32_ptr++ = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
 		if ((i % 4) == 3) {
-			if (ORC_RDLONG(hcsp->HCS_Base, ORC_RISCRAM) != dData) {
-				ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST);	/* Reset program to 0 */
-				ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/*Disable EEPROM programming */
+			if (inl(host->base + ORC_RISCRAM) != data32) {
+				outb(PRGMRST, host->base + ORC_RISCCTL);	/* Reset program to 0 */
+				outb(data, host->base + ORC_GCFG);	/*Disable EEPROM programming */
 				return 0;
 			}
-			pData = (UCHAR *) & dData;
+			data32_ptr = (u8 *) & data32;
 		}
 	}
-	ORC_WR(hcsp->HCS_Base + ORC_RISCCTL, PRGMRST);	/* Reset program to 0   */
-	ORC_WR(hcsp->HCS_Base + ORC_GCFG, bData);	/* Disable EEPROM programming */
+	
+	/* Success */
+	outb(PRGMRST, host->base + ORC_RISCCTL);	/* Reset program to 0   */
+	outb(data, host->base + ORC_GCFG);	/* Disable EEPROM programming */
 	return 1;
 }
 
 /***************************************************************************/
-static void setup_SCBs(ORC_HCS * hcsp)
+static void setup_SCBs(struct orc_host * host)
 {
-	ORC_SCB *pVirScb;
+	struct orc_scb *scb;
 	int i;
-	ESCB *pVirEscb;
-	dma_addr_t pPhysEscb;
+	struct orc_extended_scb *escb;
+	dma_addr_t escb_phys;
 
-	/* Setup SCB HCS_Base and SCB Size registers */
-	ORC_WR(hcsp->HCS_Base + ORC_SCBSIZE, ORC_MAXQUEUE);	/* Total number of SCBs */
-	/* SCB HCS_Base address 0      */
-	ORC_WRLONG(hcsp->HCS_Base + ORC_SCBBASE0, hcsp->HCS_physScbArray);
-	/* SCB HCS_Base address 1      */
-	ORC_WRLONG(hcsp->HCS_Base + ORC_SCBBASE1, hcsp->HCS_physScbArray);
+	/* Setup SCB base and SCB Size registers */
+	outb(ORC_MAXQUEUE, host->base + ORC_SCBSIZE);	/* Total number of SCBs */
+	/* SCB base address 0      */
+	outl(host->scb_phys, host->base + ORC_SCBBASE0);
+	/* SCB base address 1      */
+	outl(host->scb_phys, host->base + ORC_SCBBASE1);
 
 	/* setup scatter list address with one buffer */
-	pVirScb = hcsp->HCS_virScbArray;
-	pVirEscb = hcsp->HCS_virEscbArray;
+	scb = host->scb_virt;
+	escb = host->escb_virt;
 
 	for (i = 0; i < ORC_MAXQUEUE; i++) {
-		pPhysEscb = (hcsp->HCS_physEscbArray + (sizeof(ESCB) * i));
-		pVirScb->SCB_SGPAddr = (U32) pPhysEscb;
-		pVirScb->SCB_SensePAddr = (U32) pPhysEscb;
-		pVirScb->SCB_EScb = pVirEscb;
-		pVirScb->SCB_ScbIdx = i;
-		pVirScb++;
-		pVirEscb++;
+		escb_phys = (host->escb_phys + (sizeof(struct orc_extended_scb) * i));
+		scb->sg_addr = (u32) escb_phys;
+		scb->sense_addr = (u32) escb_phys;
+		scb->escb = escb;
+		scb->scbidx = i;
+		scb++;
+		escb++;
 	}
-
-	return;
 }
 
-/***************************************************************************/
-static void initAFlag(ORC_HCS * hcsp)
+/**
+ *	init_alloc_map		-	initialise allocation map
+ *	@host: host map to configure
+ *
+ *	Initialise the allocation maps for this device. If the device
+ *	is not quiescent the caller must hold the allocation lock
+ */
+
+static void init_alloc_map(struct orc_host * host)
 {
-	UCHAR i, j;
+	u8 i, j;
 
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		for (j = 0; j < 8; j++) {
-			hcsp->BitAllocFlag[i][j] = 0xffffffff;
+			host->allocation_map[i][j] = 0xffffffff;
 		}
 	}
 }
 
-/***************************************************************************/
-static int init_orchid(ORC_HCS * hcsp)
+/**
+ *	init_orchid		-	initialise the host adapter
+ *	@host:host adapter to initialise
+ *
+ *	Initialise the controller and if neccessary load the firmware.
+ *
+ *	Returns -1 if the initialisation fails.
+ */
+
+static int init_orchid(struct orc_host * host)
 {
-	UBYTE *readBytep;
-	USHORT revision;
-	UCHAR i;
-
-	initAFlag(hcsp);
-	ORC_WR(hcsp->HCS_Base + ORC_GIMSK, 0xFF);	/* Disable all interrupt        */
-	if (ORC_RD(hcsp->HCS_Base, ORC_HSTUS) & RREADY) {	/* Orchid is ready              */
-		revision = get_FW_version(hcsp);
+	u8 *ptr;
+	u16 revision;
+	u8 i;
+
+	init_alloc_map(host);
+	outb(0xFF, host->base + ORC_GIMSK);	/* Disable all interrupts */
+	
+	if (inb(host->base + ORC_HSTUS) & RREADY) {	/* Orchid is ready */
+		revision = orc_read_fwrev(host);
 		if (revision == 0xFFFF) {
-			ORC_WR(hcsp->HCS_Base + ORC_HCTRL, DEVRST);	/* Reset Host Adapter   */
-			if (waitChipReady(hcsp) == 0)
-				return (-1);
-			load_FW(hcsp);	/* Download FW                  */
-			setup_SCBs(hcsp);	/* Setup SCB HCS_Base and SCB Size registers */
-			ORC_WR(hcsp->HCS_Base + ORC_HCTRL, 0);	/* clear HOSTSTOP       */
-			if (waitFWReady(hcsp) == 0)
-				return (-1);
+			outb(DEVRST, host->base + ORC_HCTRL);	/* Reset Host Adapter   */
+			if (wait_chip_ready(host) == 0)
+				return -1;
+			orc_load_firmware(host);	/* Download FW                  */
+			setup_SCBs(host);	/* Setup SCB base and SCB Size registers */
+			outb(0x00, host->base + ORC_HCTRL);	/* clear HOSTSTOP       */
+			if (wait_firmware_ready(host) == 0)
+				return -1;
 			/* Wait for firmware ready     */
 		} else {
-			setup_SCBs(hcsp);	/* Setup SCB HCS_Base and SCB Size registers */
+			setup_SCBs(host);	/* Setup SCB base and SCB Size registers */
 		}
 	} else {		/* Orchid is not Ready          */
-		ORC_WR(hcsp->HCS_Base + ORC_HCTRL, DEVRST);	/* Reset Host Adapter   */
-		if (waitChipReady(hcsp) == 0)
-			return (-1);
-		load_FW(hcsp);	/* Download FW                  */
-		setup_SCBs(hcsp);	/* Setup SCB HCS_Base and SCB Size registers */
-		ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);	/* Do Hardware Reset &  */
+		outb(DEVRST, host->base + ORC_HCTRL);	/* Reset Host Adapter   */
+		if (wait_chip_ready(host) == 0)
+			return -1;
+		orc_load_firmware(host);	/* Download FW                  */
+		setup_SCBs(host);	/* Setup SCB base and SCB Size registers */
+		outb(HDO, host->base + ORC_HCTRL);	/* Do Hardware Reset &  */
 
 		/*     clear HOSTSTOP  */
-		if (waitFWReady(hcsp) == 0)		/* Wait for firmware ready      */
-			return (-1);
+		if (wait_firmware_ready(host) == 0)		/* Wait for firmware ready      */
+			return -1;
 	}
 
-/*------------- get serial EEProm settting -------*/
-
-	read_eeprom(hcsp);
+	/* Load an EEProm copy into RAM */
+	/* Assumes single threaded at this point */
+	read_eeprom(host);
 
-	if (nvramp->Revision != 1)
-		return (-1);
-
-	hcsp->HCS_SCSI_ID = nvramp->SCSI0Id;
-	hcsp->HCS_BIOS = nvramp->BIOSConfig1;
-	hcsp->HCS_MaxTar = MAX_TARGETS;
-	readBytep = (UCHAR *) & (nvramp->Target00Config);
-	for (i = 0; i < 16; readBytep++, i++) {
-		hcsp->TargetFlag[i] = *readBytep;
-		hcsp->MaximumTags[i] = ORC_MAXTAGS;
-	}			/* for                          */
+	if (nvramp->revision != 1)
+		return -1;
 
-	if (nvramp->SCSI0Config & NCC_BUSRESET) {	/* Reset SCSI bus               */
-		hcsp->HCS_Flags |= HCF_SCSI_RESET;
+	host->scsi_id = nvramp->scsi_id;
+	host->BIOScfg = nvramp->BIOSConfig1;
+	host->max_targets = MAX_TARGETS;
+	ptr = (u8 *) & (nvramp->Target00Config);
+	for (i = 0; i < 16; ptr++, i++) {
+		host->target_flag[i] = *ptr;
+		host->max_tags[i] = ORC_MAXTAGS;
 	}
-	ORC_WR(hcsp->HCS_Base + ORC_GIMSK, 0xFB);	/* enable RP FIFO interrupt     */
-	return (0);
+
+	if (nvramp->SCSI0Config & NCC_BUSRESET)
+		host->flags |= HCF_SCSI_RESET;
+	outb(0xFB, host->base + ORC_GIMSK);	/* enable RP FIFO interrupt     */
+	return 0;
 }
 
-/*****************************************************************************
- Function name  : orc_reset_scsi_bus
- Description    : Reset registers, reset a hanging bus and
-                  kill active and disconnected commands for target w/o soft reset
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static int orc_reset_scsi_bus(ORC_HCS * pHCB)
+/**
+ *	orc_reset_scsi_bus		-	perform bus reset
+ *	@host: host being reset
+ *
+ *	Perform a full bus reset on the adapter.
+ */
+ 
+static int orc_reset_scsi_bus(struct orc_host * host)
 {				/* I need Host Control Block Information */
-	ULONG flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&(pHCB->BitAllocFlagLock), flags);
+	spin_lock_irqsave(&host->allocation_lock, flags);
 
-	initAFlag(pHCB);
+	init_alloc_map(host);
 	/* reset scsi bus */
-	ORC_WR(pHCB->HCS_Base + ORC_HCTRL, SCSIRST);
-	if (waitSCSIRSTdone(pHCB) == 0) {
-		spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
+	outb(SCSIRST, host->base + ORC_HCTRL);
+	/* FIXME: We can spend up to a second with the lock held and
+	   interrupts off here */
+	if (wait_scsi_reset_done(host) == 0) {
+		spin_unlock_irqrestore(&host->allocation_lock, flags);
 		return FAILED;
 	} else {
-		spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
+		spin_unlock_irqrestore(&host->allocation_lock, flags);
 		return SUCCESS;
 	}
 }
 
-/*****************************************************************************
- Function name  : orc_device_reset
- Description    : Reset registers, reset a hanging bus and
-                  kill active and disconnected commands for target w/o soft reset
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static int orc_device_reset(ORC_HCS * pHCB, struct scsi_cmnd *SCpnt, unsigned int target)
+/**
+ *	orc_device_reset	-	device reset handler
+ *	@host: host to reset
+ *	@cmd: command causing the reset
+ *	@target; target device
+ *
+ *	Reset registers, reset a hanging bus and kill active and disconnected
+ *	commands for target w/o soft reset
+ */
+
+static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsigned int target)
 {				/* I need Host Control Block Information */
-	ORC_SCB *pScb;
-	ESCB *pVirEscb;
-	ORC_SCB *pVirScb;
-	UCHAR i;
-	ULONG flags;
-
-	spin_lock_irqsave(&(pHCB->BitAllocFlagLock), flags);
-	pScb = (ORC_SCB *) NULL;
-	pVirEscb = (ESCB *) NULL;
+	struct orc_scb *scb;
+	struct orc_extended_scb *escb;
+	struct orc_scb *host_scb;
+	u8 i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&(host->allocation_lock), flags);
+	scb = (struct orc_scb *) NULL;
+	escb = (struct orc_extended_scb *) NULL;
 
 	/* setup scatter list address with one buffer */
-	pVirScb = pHCB->HCS_virScbArray;
+	host_scb = host->scb_virt;
 
-	initAFlag(pHCB);
-	/* device reset */
+	/* FIXME: is this safe if we then fail to issue the reset or race
+	   a completion ? */
+	init_alloc_map(host);
+	
+	/* Find the scb corresponding to the command */
 	for (i = 0; i < ORC_MAXQUEUE; i++) {
-		pVirEscb = pVirScb->SCB_EScb;
-		if ((pVirScb->SCB_Status) && (pVirEscb->SCB_Srb == SCpnt))
+		escb = host_scb->escb;
+		if (host_scb->status && escb->srb == cmd)
 			break;
-		pVirScb++;
+		host_scb++;
 	}
 
 	if (i == ORC_MAXQUEUE) {
-		printk("Unable to Reset - No SCB Found\n");
-		spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
+		printk(KERN_ERR "Unable to Reset - No SCB Found\n");
+		spin_unlock_irqrestore(&(host->allocation_lock), flags);
 		return FAILED;
 	}
-	if ((pScb = orc_alloc_scb(pHCB)) == NULL) {
-		spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
+	
+	/* Allocate a new SCB for the reset command to the firmware */
+	if ((scb = __orc_alloc_scb(host)) == NULL) {
+		/* Can't happen.. */
+		spin_unlock_irqrestore(&(host->allocation_lock), flags);
 		return FAILED;
 	}
-	pScb->SCB_Opcode = ORC_BUSDEVRST;
-	pScb->SCB_Target = target;
-	pScb->SCB_HaStat = 0;
-	pScb->SCB_TaStat = 0;
-	pScb->SCB_Status = 0x0;
-	pScb->SCB_Link = 0xFF;
-	pScb->SCB_Reserved0 = 0;
-	pScb->SCB_Reserved1 = 0;
-	pScb->SCB_XferLen = 0;
-	pScb->SCB_SGLen = 0;
-
-	pVirEscb->SCB_Srb = NULL;
-	pVirEscb->SCB_Srb = SCpnt;
-	orc_exec_scb(pHCB, pScb);	/* Start execute SCB            */
-	spin_unlock_irqrestore(&(pHCB->BitAllocFlagLock), flags);
+	
+	/* Reset device is handled by the firmare, we fill in an SCB and
+	   fire it at the controller, it does the rest */
+	scb->opcode = ORC_BUSDEVRST;
+	scb->target = target;
+	scb->hastat = 0;
+	scb->tastat = 0;
+	scb->status = 0x0;
+	scb->link = 0xFF;
+	scb->reserved0 = 0;
+	scb->reserved1 = 0;
+	scb->xferlen = 0;
+	scb->sg_len = 0;
+
+	escb->srb = NULL;
+	escb->srb = cmd;
+	orc_exec_scb(host, scb);	/* Start execute SCB            */
+	spin_unlock_irqrestore(&host->allocation_lock, flags);
 	return SUCCESS;
 }
 
+/**
+ *	__orc_alloc_scb		-		allocate an SCB
+ *	@host: host to allocate from
+ *
+ *	Allocate an SCB and return a pointer to the SCB object. NULL
+ *	is returned if no SCB is free. The caller must already hold
+ *	the allocator lock at this point.
+ */
 
-/***************************************************************************/
-static ORC_SCB *__orc_alloc_scb(ORC_HCS * hcsp)
+
+static struct orc_scb *__orc_alloc_scb(struct orc_host * host)
 {
-	ORC_SCB *pTmpScb;
-	UCHAR Ch;
-	ULONG idx;
-	UCHAR index;
-	UCHAR i;
+	u8 channel;
+	unsigned long idx;
+	u8 index;
+	u8 i;
 
-	Ch = hcsp->HCS_Index;
+	channel = host->index;
 	for (i = 0; i < 8; i++) {
 		for (index = 0; index < 32; index++) {
-			if ((hcsp->BitAllocFlag[Ch][i] >> index) & 0x01) {
-				hcsp->BitAllocFlag[Ch][i] &= ~(1 << index);
+			if ((host->allocation_map[channel][i] >> index) & 0x01) {
+				host->allocation_map[channel][i] &= ~(1 << index);
 				break;
 			}
 		}
 		idx = index + 32 * i;
-		pTmpScb = (ORC_SCB *) ((ULONG) hcsp->HCS_virScbArray + (idx * sizeof(ORC_SCB)));
-		return (pTmpScb);
+		/* Translate the index to a structure instance */
+		return (struct orc_scb *) ((unsigned long) host->scb_virt + (idx * sizeof(struct orc_scb)));
 	}
-	return (NULL);
+	return NULL;
 }
 
-static ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp)
+/**
+ *	orc_alloc_scb		-		allocate an SCB
+ *	@host: host to allocate from
+ *
+ *	Allocate an SCB and return a pointer to the SCB object. NULL
+ *	is returned if no SCB is free.
+ */
+
+static struct orc_scb *orc_alloc_scb(struct orc_host * host)
 {
-	ORC_SCB *pTmpScb;
-	ULONG flags;
+	struct orc_scb *scb;
+	unsigned long flags;
 
-	spin_lock_irqsave(&(hcsp->BitAllocFlagLock), flags);
-	pTmpScb = __orc_alloc_scb(hcsp);
-	spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
-	return (pTmpScb);
+	spin_lock_irqsave(&host->allocation_lock, flags);
+	scb = __orc_alloc_scb(host);
+	spin_unlock_irqrestore(&host->allocation_lock, flags);
+	return scb;
 }
 
-
-/***************************************************************************/
-static void orc_release_scb(ORC_HCS * hcsp, ORC_SCB * scbp)
+/**
+ *	orc_release_scb			-	release an SCB
+ *	@host: host owning the SCB
+ *	@scb: SCB that is now free
+ *
+ *	Called to return a completed SCB to the allocation pool. Before
+ *	calling the SCB must be out of use on both the host and the HA.
+ */
+ 
+static void orc_release_scb(struct orc_host *host, struct orc_scb *scb)
 {
-	ULONG flags;
-	UCHAR Index;
-	UCHAR i;
-	UCHAR Ch;
-
-	spin_lock_irqsave(&(hcsp->BitAllocFlagLock), flags);
-	Ch = hcsp->HCS_Index;
-	Index = scbp->SCB_ScbIdx;
-	i = Index / 32;
-	Index %= 32;
-	hcsp->BitAllocFlag[Ch][i] |= (1 << Index);
-	spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
+	unsigned long flags;
+	u8 index, i, channel;
+
+	spin_lock_irqsave(&(host->allocation_lock), flags);
+	channel = host->index;	/* Channel */
+	index = scb->scbidx;
+	i = index / 32;
+	index %= 32;
+	host->allocation_map[channel][i] |= (1 << index);
+	spin_unlock_irqrestore(&(host->allocation_lock), flags);
 }
 
-/*****************************************************************************
- Function name  : abort_SCB
- Description    : Abort a queued command.
-	                 (commands that are on the bus can't be aborted easily)
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static int abort_SCB(ORC_HCS * hcsp, ORC_SCB * pScb)
+/**
+ *	orchid_abort_scb	-	abort a command
+ *
+ *	Abort a queued command that has been passed to the firmware layer
+ *	if possible. This is all handled by the firmware. We aks the firmware
+ *	and it either aborts the command or fails
+ */
+ 
+static int orchid_abort_scb(struct orc_host * host, struct orc_scb * scb)
 {
-	unsigned char bData, bStatus;
+	unsigned char data, status;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, ORC_CMD_ABORT_SCB);	/* Write command */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(ORC_CMD_ABORT_SCB, host->base + ORC_HDATA);	/* Write command */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	ORC_WR(hcsp->HCS_Base + ORC_HDATA, pScb->SCB_ScbIdx);	/* Write address */
-	ORC_WR(hcsp->HCS_Base + ORC_HCTRL, HDO);
-	if (waitHDOoff(hcsp) == 0)	/* Wait HDO off   */
+	outb(scb->scbidx, host->base + ORC_HDATA);	/* Write address */
+	outb(HDO, host->base + ORC_HCTRL);
+	if (wait_HDO_off(host) == 0)	/* Wait HDO off   */
 		return 0;
 
-	if (waitHDIset(hcsp, &bData) == 0)	/* Wait HDI set   */
+	if (wait_hdi_set(host, &data) == 0)	/* Wait HDI set   */
 		return 0;
-	bStatus = ORC_RD(hcsp->HCS_Base, ORC_HDATA);
-	ORC_WR(hcsp->HCS_Base + ORC_HSTUS, bData);	/* Clear HDI    */
+	status = inb(host->base + ORC_HDATA);
+	outb(data, host->base + ORC_HSTUS);	/* Clear HDI    */
 
-	if (bStatus == 1)	/* 0 - Successfully               */
+	if (status == 1)	/* 0 - Successfully               */
 		return 0;	/* 1 - Fail                     */
 	return 1;
 }
 
-/*****************************************************************************
- Function name  : inia100_abort
- Description    : Abort a queued command.
-	                 (commands that are on the bus can't be aborted easily)
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static int orc_abort_srb(ORC_HCS * hcsp, struct scsi_cmnd *SCpnt)
+static int inia100_abort_cmd(struct orc_host * host, struct scsi_cmnd *cmd)
 {
-	ESCB *pVirEscb;
-	ORC_SCB *pVirScb;
-	UCHAR i;
-	ULONG flags;
-
-	spin_lock_irqsave(&(hcsp->BitAllocFlagLock), flags);
-
-	pVirScb = hcsp->HCS_virScbArray;
-
-	for (i = 0; i < ORC_MAXQUEUE; i++, pVirScb++) {
-		pVirEscb = pVirScb->SCB_EScb;
-		if ((pVirScb->SCB_Status) && (pVirEscb->SCB_Srb == SCpnt)) {
-			if (pVirScb->SCB_TagMsg == 0) {
-				spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
-				return FAILED;
+	struct orc_extended_scb *escb;
+	struct orc_scb *scb;
+	u8 i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&(host->allocation_lock), flags);
+
+	scb = host->scb_virt;
+
+	/* Walk the queue until we find the SCB that belongs to the command
+	   block. This isn't a performance critical path so a walk in the park
+	   here does no harm */
+
+	for (i = 0; i < ORC_MAXQUEUE; i++, scb++) {
+		escb = scb->escb;
+		if (scb->status && escb->srb == cmd) {
+			if (scb->tag_msg == 0) {
+				goto out;
 			} else {
-				if (abort_SCB(hcsp, pVirScb)) {
-					pVirEscb->SCB_Srb = NULL;
-					spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
+				/* Issue an ABORT to the firmware */
+				if (orchid_abort_scb(host, scb)) {
+					escb->srb = NULL;
+					spin_unlock_irqrestore(&host->allocation_lock, flags);
 					return SUCCESS;
-				} else {
-					spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
-					return FAILED;
-				}
+				} else
+					goto out;
 			}
 		}
 	}
-	spin_unlock_irqrestore(&(hcsp->BitAllocFlagLock), flags);
+out:	
+	spin_unlock_irqrestore(&host->allocation_lock, flags);
 	return FAILED;
 }
 
-/***********************************************************************
- Routine Description:
-	  This is the interrupt service routine for the Orchid SCSI adapter.
-	  It reads the interrupt register to determine if the adapter is indeed
-	  the source of the interrupt and clears the interrupt at the device.
- Arguments:
-	  HwDeviceExtension - HBA miniport driver's adapter data storage
- Return Value:
-***********************************************************************/
-static void orc_interrupt(
-			  ORC_HCS * hcsp
-)
+/**
+ *	orc_interrupt		-	IRQ processing
+ *	@host: Host causing the interrupt
+ *
+ *	This function is called from the IRQ handler and protected
+ *	by the host lock. While the controller reports that there are
+ *	scb's for processing we pull them off the controller, turn the
+ *	index into a host address pointer to the scb and call the scb
+ *	handler.
+ *
+ *	Returns IRQ_HANDLED if any SCBs were processed, IRQ_NONE otherwise
+ */
+
+static irqreturn_t orc_interrupt(struct orc_host * host)
 {
-	BYTE bScbIdx;
-	ORC_SCB *pScb;
+	u8 scb_index;
+	struct orc_scb *scb;
 
-	if (ORC_RD(hcsp->HCS_Base, ORC_RQUEUECNT) == 0) {
-		return;		// 0;
+	/* Check if we have an SCB queued for servicing */
+	if (inb(host->base + ORC_RQUEUECNT) == 0)
+		return IRQ_NONE;
 
-	}
 	do {
-		bScbIdx = ORC_RD(hcsp->HCS_Base, ORC_RQUEUE);
-
-		pScb = (ORC_SCB *) ((ULONG) hcsp->HCS_virScbArray + (ULONG) (sizeof(ORC_SCB) * bScbIdx));
-		pScb->SCB_Status = 0x0;
-
-		inia100SCBPost((BYTE *) hcsp, (BYTE *) pScb);
-	} while (ORC_RD(hcsp->HCS_Base, ORC_RQUEUECNT));
-	return;			//1;
+		/* Get the SCB index of the SCB to service */
+		scb_index = inb(host->base + ORC_RQUEUE);
 
+		/* Translate it back to a host pointer */
+		scb = (struct orc_scb *) ((unsigned long) host->scb_virt + (unsigned long) (sizeof(struct orc_scb) * scb_index));
+		scb->status = 0x0;
+		/* Process the SCB */
+		inia100_scb_handler(host, scb);
+	} while (inb(host->base + ORC_RQUEUECNT));
+	return IRQ_HANDLED;
 }				/* End of I1060Interrupt() */
 
-/*****************************************************************************
- Function name  : inia100BuildSCB
- Description    : 
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static void inia100BuildSCB(ORC_HCS * pHCB, ORC_SCB * pSCB, struct scsi_cmnd * SCpnt)
+/**
+ *	inia100_build_scb	-	build SCB
+ *	@host: host owing the control block
+ *	@scb: control block to use
+ *	@cmd: Mid layer command
+ *
+ *	Build a host adapter control block from the SCSI mid layer command
+ */
+
+static void inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struct scsi_cmnd * cmd)
 {				/* Create corresponding SCB     */
 	struct scatterlist *sg;
-	ORC_SG *pSG;		/* Pointer to SG list           */
+	struct orc_sgent *sgent;		/* Pointer to SG list           */
 	int i, count_sg;
-	ESCB *pEScb;
+	struct orc_extended_scb *escb;
 
-	pEScb = pSCB->SCB_EScb;
-	pEScb->SCB_Srb = SCpnt;
-	pSG = NULL;
-
-	pSCB->SCB_Opcode = ORC_EXECSCSI;
-	pSCB->SCB_Flags = SCF_NO_DCHK;	/* Clear done bit               */
-	pSCB->SCB_Target = SCpnt->device->id;
-	pSCB->SCB_Lun = SCpnt->device->lun;
-	pSCB->SCB_Reserved0 = 0;
-	pSCB->SCB_Reserved1 = 0;
-	pSCB->SCB_SGLen = 0;
+	/* Links between the escb, scb and Linux scsi midlayer cmd */
+	escb = scb->escb;
+	escb->srb = cmd;
+	sgent = NULL;
+
+	/* Set up the SCB to do a SCSI command block */
+	scb->opcode = ORC_EXECSCSI;
+	scb->flags = SCF_NO_DCHK;	/* Clear done bit               */
+	scb->target = cmd->device->id;
+	scb->lun = cmd->device->lun;
+	scb->reserved0 = 0;
+	scb->reserved1 = 0;
+	scb->sg_len = 0;
 
-	pSCB->SCB_XferLen = (U32) scsi_bufflen(SCpnt);
-	pSG = (ORC_SG *) & pEScb->ESCB_SGList[0];
+	scb->xferlen = (u32) scsi_bufflen(cmd);
+	sgent = (struct orc_sgent *) & escb->sglist[0];
 
-	count_sg = scsi_dma_map(SCpnt);
+	count_sg = scsi_dma_map(cmd);
 	BUG_ON(count_sg < 0);
+	
+	/* Build the scatter gather lists */
 	if (count_sg) {
-		pSCB->SCB_SGLen = (U32) (count_sg * 8);
-		scsi_for_each_sg(SCpnt, sg, count_sg, i) {
-			pSG->SG_Ptr = (U32) sg_dma_address(sg);
-			pSG->SG_Len = (U32) sg_dma_len(sg);
-			pSG++;
+		scb->sg_len = (u32) (count_sg * 8);
+		scsi_for_each_sg(cmd, sg, count_sg, i) {
+			sgent->base = (u32) sg_dma_address(sg);
+			sgent->length = (u32) sg_dma_len(sg);
+			sgent++;
 		}
 	} else {
-		pSCB->SCB_SGLen = 0;
-		pSG->SG_Ptr = 0;
-		pSG->SG_Len = 0;
-	}
-	pSCB->SCB_SGPAddr = (U32) pSCB->SCB_SensePAddr;
-	pSCB->SCB_HaStat = 0;
-	pSCB->SCB_TaStat = 0;
-	pSCB->SCB_Link = 0xFF;
-	pSCB->SCB_SenseLen = SENSE_SIZE;
-	pSCB->SCB_CDBLen = SCpnt->cmd_len;
-	if (pSCB->SCB_CDBLen >= IMAX_CDB) {
-		printk("max cdb length= %x\b", SCpnt->cmd_len);
-		pSCB->SCB_CDBLen = IMAX_CDB;
-	}
-	pSCB->SCB_Ident = SCpnt->device->lun | DISC_ALLOW;
-	if (SCpnt->device->tagged_supported) {	/* Tag Support                  */
-		pSCB->SCB_TagMsg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
+		scb->sg_len = 0;
+		sgent->base = 0;
+		sgent->length = 0;
+	}
+	scb->sg_addr = (u32) scb->sense_addr;
+	scb->hastat = 0;
+	scb->tastat = 0;
+	scb->link = 0xFF;
+	scb->sense_len = SENSE_SIZE;
+	scb->cdb_len = cmd->cmd_len;
+	if (scb->cdb_len >= IMAX_CDB) {
+		printk("max cdb length= %x\b", cmd->cmd_len);
+		scb->cdb_len = IMAX_CDB;
+	}
+	scb->ident = cmd->device->lun | DISC_ALLOW;
+	if (cmd->device->tagged_supported) {	/* Tag Support                  */
+		scb->tag_msg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
 	} else {
-		pSCB->SCB_TagMsg = 0;	/* No tag support               */
+		scb->tag_msg = 0;	/* No tag support               */
 	}
-	memcpy(&pSCB->SCB_CDB[0], &SCpnt->cmnd, pSCB->SCB_CDBLen);
-	return;
+	memcpy(&scb->cdb[0], &cmd->cmnd, scb->cdb_len);
 }
 
-/*****************************************************************************
- Function name  : inia100_queue
- Description    : Queue a command and setup interrupts for a free bus.
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static int inia100_queue(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
+/**
+ *	inia100_queue		-	queue command with host
+ *	@cmd: Command block
+ *	@done: Completion function
+ *
+ *	Called by the mid layer to queue a command. Process the command
+ *	block, build the host specific scb structures and if there is room
+ *	queue the command down to the controller
+ */
+
+static int inia100_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
-	register ORC_SCB *pSCB;
-	ORC_HCS *pHCB;		/* Point to Host adapter control block */
+	struct orc_scb *scb;
+	struct orc_host *host;		/* Point to Host adapter control block */
 
-	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
-	SCpnt->scsi_done = done;
+	host = (struct orc_host *) cmd->device->host->hostdata;
+	cmd->scsi_done = done;
 	/* Get free SCSI control block  */
-	if ((pSCB = orc_alloc_scb(pHCB)) == NULL)
+	if ((scb = orc_alloc_scb(host)) == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	inia100BuildSCB(pHCB, pSCB, SCpnt);
-	orc_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
-
-	return (0);
+	inia100_build_scb(host, scb, cmd);
+	orc_exec_scb(host, scb);	/* Start execute SCB            */
+	return 0;
 }
 
 /*****************************************************************************
  Function name  : inia100_abort
  Description    : Abort a queued command.
 	                 (commands that are on the bus can't be aborted easily)
- Input          : pHCB  -       Pointer to host adapter structure
+ Input          : host  -       Pointer to host adapter structure
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_abort(struct scsi_cmnd * SCpnt)
+static int inia100_abort(struct scsi_cmnd * cmd)
 {
-	ORC_HCS *hcsp;
+	struct orc_host *host;
 
-	hcsp = (ORC_HCS *) SCpnt->device->host->hostdata;
-	return orc_abort_srb(hcsp, SCpnt);
+	host = (struct orc_host *) cmd->device->host->hostdata;
+	return inia100_abort_cmd(host, cmd);
 }
 
 /*****************************************************************************
  Function name  : inia100_reset
  Description    : Reset registers, reset a hanging bus and
                   kill active and disconnected commands for target w/o soft reset
- Input          : pHCB  -       Pointer to host adapter structure
+ Input          : host  -       Pointer to host adapter structure
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_bus_reset(struct scsi_cmnd * SCpnt)
+static int inia100_bus_reset(struct scsi_cmnd * cmd)
 {				/* I need Host Control Block Information */
-	ORC_HCS *pHCB;
-	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
-	return orc_reset_scsi_bus(pHCB);
+	struct orc_host *host;
+	host = (struct orc_host *) cmd->device->host->hostdata;
+	return orc_reset_scsi_bus(host);
 }
 
 /*****************************************************************************
  Function name  : inia100_device_reset
  Description    : Reset the device
- Input          : pHCB  -       Pointer to host adapter structure
+ Input          : host  -       Pointer to host adapter structure
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_device_reset(struct scsi_cmnd * SCpnt)
+static int inia100_device_reset(struct scsi_cmnd * cmd)
 {				/* I need Host Control Block Information */
-	ORC_HCS *pHCB;
-	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
-	return orc_device_reset(pHCB, SCpnt, scmd_id(SCpnt));
+	struct orc_host *host;
+	host = (struct orc_host *) cmd->device->host->hostdata;
+	return orc_device_reset(host, cmd, scmd_id(cmd));
 
 }
 
-/*****************************************************************************
- Function name  : inia100SCBPost
- Description    : This is callback routine be called when orc finish one
-			SCSI command.
- Input          : pHCB  -       Pointer to host adapter control block.
-		  pSCB  -       Pointer to SCSI control block.
- Output         : None.
- Return         : None.
-*****************************************************************************/
-static void inia100SCBPost(BYTE * pHcb, BYTE * pScb)
+/**
+ *	inia100_scb_handler	-	interrupt callback
+ *	@host: Host causing the interrupt
+ *	@scb: SCB the controller returned as needing processing
+ *
+ *	Perform completion processing on a control block. Do the conversions
+ *	from host to SCSI midlayer error coding, save any sense data and
+ *	the complete with the midlayer and recycle the scb.
+ */
+
+static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 {
-	struct scsi_cmnd *pSRB;	/* Pointer to SCSI request block */
-	ORC_HCS *pHCB;
-	ORC_SCB *pSCB;
-	ESCB *pEScb;
-
-	pHCB = (ORC_HCS *) pHcb;
-	pSCB = (ORC_SCB *) pScb;
-	pEScb = pSCB->SCB_EScb;
-	if ((pSRB = (struct scsi_cmnd *) pEScb->SCB_Srb) == 0) {
-		printk("inia100SCBPost: SRB pointer is empty\n");
-		orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
+	struct scsi_cmnd *cmd;	/* Pointer to SCSI request block */
+	struct orc_extended_scb *escb;
+
+	escb = scb->escb;
+	if ((cmd = (struct scsi_cmnd *) escb->srb) == NULL) {
+		printk(KERN_ERR "inia100_scb_handler: SRB pointer is empty\n");
+		orc_release_scb(host, scb);	/* Release SCB for current channel */
 		return;
 	}
-	pEScb->SCB_Srb = NULL;
+	escb->srb = NULL;
 
-	switch (pSCB->SCB_HaStat) {
+	switch (scb->hastat) {
 	case 0x0:
 	case 0xa:		/* Linked command complete without error and linked normally */
 	case 0xb:		/* Linked command complete without error interrupt generated */
-		pSCB->SCB_HaStat = 0;
+		scb->hastat = 0;
 		break;
 
 	case 0x11:		/* Selection time out-The initiator selection or target
 				   reselection was not complete within the SCSI Time out period */
-		pSCB->SCB_HaStat = DID_TIME_OUT;
+		scb->hastat = DID_TIME_OUT;
 		break;
 
 	case 0x14:		/* Target bus phase sequence failure-An invalid bus phase or bus
 				   phase sequence was requested by the target. The host adapter
 				   will generate a SCSI Reset Condition, notifying the host with
 				   a SCRD interrupt */
-		pSCB->SCB_HaStat = DID_RESET;
+		scb->hastat = DID_RESET;
 		break;
 
 	case 0x1a:		/* SCB Aborted. 07/21/98 */
-		pSCB->SCB_HaStat = DID_ABORT;
+		scb->hastat = DID_ABORT;
 		break;
 
 	case 0x12:		/* Data overrun/underrun-The target attempted to transfer more data
@@ -976,38 +1022,41 @@
 	case 0x16:		/* Invalid CCB Operation Code-The first byte of the CCB was invalid. */
 
 	default:
-		printk("inia100: %x %x\n", pSCB->SCB_HaStat, pSCB->SCB_TaStat);
-		pSCB->SCB_HaStat = DID_ERROR;	/* Couldn't find any better */
+		printk(KERN_DEBUG "inia100: %x %x\n", scb->hastat, scb->tastat);
+		scb->hastat = DID_ERROR;	/* Couldn't find any better */
 		break;
 	}
 
-	if (pSCB->SCB_TaStat == 2) {	/* Check condition              */
-		memcpy((unsigned char *) &pSRB->sense_buffer[0],
-		   (unsigned char *) &pEScb->ESCB_SGList[0], SENSE_SIZE);
-	}
-	pSRB->result = pSCB->SCB_TaStat | (pSCB->SCB_HaStat << 16);
-
-	scsi_dma_unmap(pSRB);
-
-	pSRB->scsi_done(pSRB);	/* Notify system DONE           */
-
-	orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
+	if (scb->tastat == 2) {	/* Check condition              */
+		memcpy((unsigned char *) &cmd->sense_buffer[0],
+		   (unsigned char *) &escb->sglist[0], SENSE_SIZE);
+	}
+	cmd->result = scb->tastat | (scb->hastat << 16);
+	scsi_dma_unmap(cmd);
+	cmd->scsi_done(cmd);	/* Notify system DONE           */
+	orc_release_scb(host, scb);	/* Release SCB for current channel */
 }
 
-/*
- * Interrupt handler (main routine of the driver)
+/**
+ *	inia100_intr		-	interrupt handler
+ *	@irqno: Interrupt value
+ *	@devid: Host adapter
+ *
+ *	Entry point for IRQ handling. All the real work is performed
+ *	by orc_interrupt.
  */
 static irqreturn_t inia100_intr(int irqno, void *devid)
 {
-	struct Scsi_Host *host = (struct Scsi_Host *)devid;
-	ORC_HCS *pHcb = (ORC_HCS *)host->hostdata;
+	struct Scsi_Host *shost = (struct Scsi_Host *)devid;
+	struct orc_host *host = (struct orc_host *)shost->hostdata;
 	unsigned long flags;
+	irqreturn_t res;
 
-	spin_lock_irqsave(host->host_lock, flags);
-	orc_interrupt(pHcb);
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
+	res = orc_interrupt(host);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	return IRQ_HANDLED;
+	return res;
 }
 
 static struct scsi_host_template inia100_template = {
@@ -1028,12 +1077,12 @@
 		const struct pci_device_id *id)
 {
 	struct Scsi_Host *shost;
-	ORC_HCS *pHCB;
+	struct orc_host *host;
 	unsigned long port, bios;
 	int error = -ENODEV;
 	u32 sz;
-	unsigned long dBiosAdr;
-	char *pbBiosAdr;
+	unsigned long biosaddr;
+	char *bios_phys;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -1052,55 +1101,55 @@
 	}
 
 	/* <02> read from base address + 0x50 offset to get the bios value. */
-	bios = ORC_RDWORD(port, 0x50);
+	bios = inw(port + 0x50);
 
 
-	shost = scsi_host_alloc(&inia100_template, sizeof(ORC_HCS));
+	shost = scsi_host_alloc(&inia100_template, sizeof(struct orc_host));
 	if (!shost)
 		goto out_release_region;
 
-	pHCB = (ORC_HCS *)shost->hostdata;
-	pHCB->pdev = pdev;
-	pHCB->HCS_Base = port;
-	pHCB->HCS_BIOS = bios;
-	spin_lock_init(&pHCB->BitAllocFlagLock);
+	host = (struct orc_host *)shost->hostdata;
+	host->pdev = pdev;
+	host->base = port;
+	host->BIOScfg = bios;
+	spin_lock_init(&host->allocation_lock);
 
 	/* Get total memory needed for SCB */
-	sz = ORC_MAXQUEUE * sizeof(ORC_SCB);
-	pHCB->HCS_virScbArray = pci_alloc_consistent(pdev, sz,
-			&pHCB->HCS_physScbArray);
-	if (!pHCB->HCS_virScbArray) {
+	sz = ORC_MAXQUEUE * sizeof(struct orc_scb);
+	host->scb_virt = pci_alloc_consistent(pdev, sz,
+			&host->scb_phys);
+	if (!host->scb_virt) {
 		printk("inia100: SCB memory allocation error\n");
 		goto out_host_put;
 	}
-	memset(pHCB->HCS_virScbArray, 0, sz);
+	memset(host->scb_virt, 0, sz);
 
 	/* Get total memory needed for ESCB */
-	sz = ORC_MAXQUEUE * sizeof(ESCB);
-	pHCB->HCS_virEscbArray = pci_alloc_consistent(pdev, sz,
-			&pHCB->HCS_physEscbArray);
-	if (!pHCB->HCS_virEscbArray) {
+	sz = ORC_MAXQUEUE * sizeof(struct orc_extended_scb);
+	host->escb_virt = pci_alloc_consistent(pdev, sz,
+			&host->escb_phys);
+	if (!host->escb_virt) {
 		printk("inia100: ESCB memory allocation error\n");
 		goto out_free_scb_array;
 	}
-	memset(pHCB->HCS_virEscbArray, 0, sz);
+	memset(host->escb_virt, 0, sz);
 
-	dBiosAdr = pHCB->HCS_BIOS;
-	dBiosAdr = (dBiosAdr << 4);
-	pbBiosAdr = phys_to_virt(dBiosAdr);
-	if (init_orchid(pHCB)) {	/* Initialize orchid chip */
+	biosaddr = host->BIOScfg;
+	biosaddr = (biosaddr << 4);
+	bios_phys = phys_to_virt(biosaddr);
+	if (init_orchid(host)) {	/* Initialize orchid chip */
 		printk("inia100: initial orchid fail!!\n");
 		goto out_free_escb_array;
 	}
 
-	shost->io_port = pHCB->HCS_Base;
+	shost->io_port = host->base;
 	shost->n_io_port = 0xff;
 	shost->can_queue = ORC_MAXQUEUE;
 	shost->unique_id = shost->io_port;
-	shost->max_id = pHCB->HCS_MaxTar;
+	shost->max_id = host->max_targets;
 	shost->max_lun = 16;
-	shost->irq = pHCB->HCS_Intr = pdev->irq;
-	shost->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index */
+	shost->irq = pdev->irq;
+	shost->this_id = host->scsi_id;	/* Assign HCS index */
 	shost->sg_tablesize = TOTAL_SG_ENTRY;
 
 	/* Initial orc chip           */
@@ -1121,36 +1170,36 @@
 	scsi_scan_host(shost);
 	return 0;
 
- out_free_irq:
+out_free_irq:
         free_irq(shost->irq, shost);
- out_free_escb_array:
-	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ESCB),
-			pHCB->HCS_virEscbArray, pHCB->HCS_physEscbArray);
- out_free_scb_array:
-	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
-			pHCB->HCS_virScbArray, pHCB->HCS_physScbArray);
- out_host_put:
+out_free_escb_array:
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(struct orc_extended_scb),
+			host->escb_virt, host->escb_phys);
+out_free_scb_array:
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(struct orc_scb),
+			host->scb_virt, host->scb_phys);
+out_host_put:
 	scsi_host_put(shost);
- out_release_region:
+out_release_region:
         release_region(port, 256);
- out_disable_device:
+out_disable_device:
 	pci_disable_device(pdev);
- out:
+out:
 	return error;
 }
 
 static void __devexit inia100_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	ORC_HCS *pHCB = (ORC_HCS *)shost->hostdata;
+	struct orc_host *host = (struct orc_host *)shost->hostdata;
 
 	scsi_remove_host(shost);
 
         free_irq(shost->irq, shost);
-	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ESCB),
-			pHCB->HCS_virEscbArray, pHCB->HCS_physEscbArray);
-	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
-			pHCB->HCS_virScbArray, pHCB->HCS_physScbArray);
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(struct orc_extended_scb),
+			host->escb_virt, host->escb_phys);
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(struct orc_scb),
+			host->scb_virt, host->scb_phys);
         release_region(shost->io_port, 256);
 
 	scsi_host_put(shost);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/a100u2w.h linux-2.6.22-rc4-mm2/drivers/scsi/a100u2w.h
--- linux.vanilla-2.6.22-rc4-mm2/drivers/scsi/a100u2w.h	2007-06-07 14:24:28.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/scsi/a100u2w.h	2007-06-14 16:01:01.000000000 +0100
@@ -18,27 +18,6 @@
  * along with this program; see the file COPYING.  If not, write to
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * --------------------------------------------------------------------------
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Where this Software is combined with software released under the terms of 
- * the GNU General Public License ("GPL") and the terms of the GPL would require the 
- * combined work to also be released under the terms of the GPL, the terms
- * and conditions of this License will apply in addition to those of the
- * GPL with the exception of any terms or conditions of this License that
- * conflict with, or are expressly prohibited by, the GPL.
- *
  * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
  * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
@@ -50,30 +29,19 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
- */
-
-/*
+ *
  * Revision History:
  * 06/18/98 HL, Initial production Version 1.02
  * 12/19/98 bv, Use spinlocks for 2.1.95 and up
  * 06/25/02 Doug Ledford <dledford@redhat.com>
  *	 - This and the i60uscsi.h file are almost identical,
  *	   merged them into a single header used by both .c files.
+ * 14/06/07 Alan Cox <alan@redhat.com>
+ *	 - Grand cleanup and Linuxisation
  */
 
 #define inia100_REVID "Initio INI-A100U2W SCSI device driver; Revision: 1.02d"
 
-#define ULONG   unsigned long
-#define USHORT  unsigned short
-#define UCHAR   unsigned char
-#define BYTE    unsigned char
-#define WORD    unsigned short
-#define DWORD   unsigned long
-#define UBYTE   unsigned char
-#define UWORD   unsigned short
-#define UDWORD  unsigned long
-#define U32     u32
-
 #if 1
 #define ORC_MAXQUEUE		245
 #define ORC_MAXTAGS		64
@@ -90,10 +58,10 @@
 /************************************************************************/
 /*              Scatter-Gather Element Structure                        */
 /************************************************************************/
-typedef struct ORC_SG_Struc {
-	U32 SG_Ptr;		/* Data Pointer */
-	U32 SG_Len;		/* Data Length */
-} ORC_SG;
+struct orc_sgent {
+	u32 base;		/* Data Pointer */
+	u32 length;		/* Data Length */
+};
 
 /* SCSI related definition                                              */
 #define DISC_NOT_ALLOW          0x80	/* Disconnect is not allowed    */
@@ -165,42 +133,45 @@
 #define	ORC_PRGMCTR1	0xE3	/* RISC program counter           */
 #define	ORC_RISCRAM	0xEC	/* RISC RAM data port 4 bytes     */
 
-typedef struct orc_extended_scb {	/* Extended SCB                 */
-	ORC_SG ESCB_SGList[TOTAL_SG_ENTRY];	/*0 Start of SG list              */
-	struct scsi_cmnd *SCB_Srb;	/*50 SRB Pointer */
-} ESCB;
+struct orc_extended_scb {	/* Extended SCB                 */
+	struct orc_sgent sglist[TOTAL_SG_ENTRY];	/*0 Start of SG list              */
+	struct scsi_cmnd *srb;	/*50 SRB Pointer */
+};
 
 /***********************************************************************
 		SCSI Control Block
+		
+		0x40 bytes long, the last 8 are user bytes
 ************************************************************************/
-typedef struct orc_scb {	/* Scsi_Ctrl_Blk                */
-	UBYTE SCB_Opcode;	/*00 SCB command code&residual  */
-	UBYTE SCB_Flags;	/*01 SCB Flags                  */
-	UBYTE SCB_Target;	/*02 Target Id                  */
-	UBYTE SCB_Lun;		/*03 Lun                        */
-	U32 SCB_Reserved0;	/*04 Reserved for ORCHID must 0 */
-	U32 SCB_XferLen;	/*08 Data Transfer Length       */
-	U32 SCB_Reserved1;	/*0C Reserved for ORCHID must 0 */
-	U32 SCB_SGLen;		/*10 SG list # * 8              */
-	U32 SCB_SGPAddr;	/*14 SG List Buf physical Addr  */
-	U32 SCB_SGPAddrHigh;	/*18 SG Buffer high physical Addr */
-	UBYTE SCB_HaStat;	/*1C Host Status                */
-	UBYTE SCB_TaStat;	/*1D Target Status              */
-	UBYTE SCB_Status;	/*1E SCB status                 */
-	UBYTE SCB_Link;		/*1F Link pointer, default 0xFF */
-	UBYTE SCB_SenseLen;	/*20 Sense Allocation Length    */
-	UBYTE SCB_CDBLen;	/*21 CDB Length                 */
-	UBYTE SCB_Ident;	/*22 Identify                   */
-	UBYTE SCB_TagMsg;	/*23 Tag Message                */
-	UBYTE SCB_CDB[IMAX_CDB];	/*24 SCSI CDBs                  */
-	UBYTE SCB_ScbIdx;	/*3C Index for this ORCSCB      */
-	U32 SCB_SensePAddr;	/*34 Sense Buffer physical Addr */
-
-	ESCB *SCB_EScb;		/*38 Extended SCB Pointer       */
-#ifndef ALPHA
-	UBYTE SCB_Reserved2[4];	/*3E Reserved for Driver use    */
+struct orc_scb {	/* Scsi_Ctrl_Blk                */
+	u8 opcode;	/*00 SCB command code&residual  */
+	u8 flags;	/*01 SCB Flags                  */
+	u8 target;	/*02 Target Id                  */
+	u8 lun;		/*03 Lun                        */
+	u32 reserved0;	/*04 Reserved for ORCHID must 0 */
+	u32 xferlen;	/*08 Data Transfer Length       */
+	u32 reserved1;	/*0C Reserved for ORCHID must 0 */
+	u32 sg_len;		/*10 SG list # * 8              */
+	u32 sg_addr;	/*14 SG List Buf physical Addr  */
+	u32 sg_addrhigh;	/*18 SG Buffer high physical Addr */
+	u8 hastat;	/*1C Host Status                */
+	u8 tastat;	/*1D Target Status              */
+	u8 status;	/*1E SCB status                 */
+	u8 link;		/*1F Link pointer, default 0xFF */
+	u8 sense_len;	/*20 Sense Allocation Length    */
+	u8 cdb_len;	/*21 CDB Length                 */
+	u8 ident;	/*22 Identify                   */
+	u8 tag_msg;	/*23 Tag Message                */
+	u8 cdb[IMAX_CDB];	/*24 SCSI CDBs                  */
+	u8 scbidx;	/*3C Index for this ORCSCB      */
+	u32 sense_addr;	/*34 Sense Buffer physical Addr */
+
+	struct orc_extended_scb *escb; /*38 Extended SCB Pointer       */
+        /* 64bit pointer or 32bit pointer + reserved ? */
+#ifndef __LP64__
+	u8 reserved2[4];	/*3E Reserved for Driver use    */
 #endif
-} ORC_SCB;
+};
 
 /* Opcodes of ORCSCB_Opcode */
 #define ORC_EXECSCSI	0x00	/* SCSI initiator command with residual */
@@ -239,13 +210,13 @@
 		Target Device Control Structure
 **********************************************************************/
 
-typedef struct ORC_Tar_Ctrl_Struc {
-	UBYTE TCS_DrvDASD;	/* 6 */
-	UBYTE TCS_DrvSCSI;	/* 7 */
-	UBYTE TCS_DrvHead;	/* 8 */
-	UWORD TCS_DrvFlags;	/* 4 */
-	UBYTE TCS_DrvSector;	/* 7 */
-} ORC_TCS;
+struct orc_target {
+	u8 TCS_DrvDASD;	/* 6 */
+	u8 TCS_DrvSCSI;	/* 7 */
+	u8 TCS_DrvHead;	/* 8 */
+	u16 TCS_DrvFlags;	/* 4 */
+	u8 TCS_DrvSector;	/* 7 */
+};
 
 /* Bit Definition for TCF_DrvFlags */
 #define	TCS_DF_NODASD_SUPT	0x20	/* Suppress OS/2 DASD Mgr support */
@@ -255,32 +226,23 @@
 /***********************************************************************
               Host Adapter Control Structure
 ************************************************************************/
-typedef struct ORC_Ha_Ctrl_Struc {
-	USHORT HCS_Base;	/* 00 */
-	UBYTE HCS_Index;	/* 02 */
-	UBYTE HCS_Intr;		/* 04 */
-	UBYTE HCS_SCSI_ID;	/* 06    H/A SCSI ID */
-	UBYTE HCS_BIOS;		/* 07    BIOS configuration */
-
-	UBYTE HCS_Flags;	/* 0B */
-	UBYTE HCS_HAConfig1;	/* 1B    SCSI0MAXTags */
-	UBYTE HCS_MaxTar;	/* 1B    SCSI0MAXTags */
-
-	USHORT HCS_Units;	/* Number of units this adapter  */
-	USHORT HCS_AFlags;	/* Adapter info. defined flags   */
-	ULONG HCS_Timeout;	/* Adapter timeout value   */
-	ORC_SCB *HCS_virScbArray;	/* 28 Virtual Pointer to SCB array */
-	dma_addr_t HCS_physScbArray;	/* Scb Physical address */
-	ESCB *HCS_virEscbArray;	/* Virtual pointer to ESCB Scatter list */
-	dma_addr_t HCS_physEscbArray;	/* scatter list Physical address */
-	UBYTE TargetFlag[16];	/* 30  target configuration, TCF_EN_TAG */
-	UBYTE MaximumTags[16];	/* 40  ORC_MAX_SCBS */
-	UBYTE ActiveTags[16][16];	/* 50 */
-	ORC_TCS HCS_Tcs[16];	/* 28 */
-	U32 BitAllocFlag[MAX_CHANNELS][8];	/* Max STB is 256, So 256/32 */
-	spinlock_t BitAllocFlagLock;
+struct orc_host {
+	unsigned long base;	/* Base address */
+	u8 index;		/* Index (Channel)*/
+	u8 scsi_id;		/* H/A SCSI ID */
+	u8 BIOScfg;		/*BIOS configuration */
+	u8 flags;
+	u8 max_targets;		/* SCSI0MAXTags */
+	struct orc_scb *scb_virt;	/* Virtual Pointer to SCB array */
+	dma_addr_t scb_phys;	/* Scb Physical address */
+	struct orc_extended_scb *escb_virt; /* Virtual pointer to ESCB Scatter list */
+	dma_addr_t escb_phys;	/* scatter list Physical address */
+	u8 target_flag[16];	/* target configuration, TCF_EN_TAG */
+	u8 max_tags[16];	/* ORC_MAX_SCBS */
+	u32 allocation_map[MAX_CHANNELS][8];	/* Max STB is 256, So 256/32 */
+	spinlock_t allocation_lock;
 	struct pci_dev *pdev;
-} ORC_HCS;
+};
 
 /* Bit Definition for HCS_Flags */
 
@@ -301,79 +263,79 @@
 #define	HCS_AF_DISABLE_RESET	0x10	/* Adapter disable reset  */
 #define	HCS_AF_DISABLE_ADPT	0x80	/* Adapter disable                */
 
-typedef struct _NVRAM {
+struct orc_nvram {
 /*----------header ---------------*/
-        UCHAR SubVendorID0;     /* 00 - Sub Vendor ID           */
-        UCHAR SubVendorID1;     /* 00 - Sub Vendor ID           */
-        UCHAR SubSysID0;        /* 02 - Sub System ID           */
-        UCHAR SubSysID1;        /* 02 - Sub System ID           */
-        UCHAR SubClass;         /* 04 - Sub Class               */
-        UCHAR VendorID0;        /* 05 - Vendor ID               */
-        UCHAR VendorID1;        /* 05 - Vendor ID               */
-        UCHAR DeviceID0;        /* 07 - Device ID               */
-        UCHAR DeviceID1;        /* 07 - Device ID               */
-        UCHAR Reserved0[2];     /* 09 - Reserved                */
-        UCHAR Revision;         /* 0B - Revision of data structure */
+        u8 SubVendorID0;     /* 00 - Sub Vendor ID           */
+        u8 SubVendorID1;     /* 00 - Sub Vendor ID           */
+        u8 SubSysID0;        /* 02 - Sub System ID           */
+        u8 SubSysID1;        /* 02 - Sub System ID           */
+        u8 SubClass;         /* 04 - Sub Class               */
+        u8 VendorID0;        /* 05 - Vendor ID               */
+        u8 VendorID1;        /* 05 - Vendor ID               */
+        u8 DeviceID0;        /* 07 - Device ID               */
+        u8 DeviceID1;        /* 07 - Device ID               */
+        u8 Reserved0[2];     /* 09 - Reserved                */
+        u8 revision;         /* 0B - revision of data structure */
         /* ----Host Adapter Structure ---- */
-        UCHAR NumOfCh;          /* 0C - Number of SCSI channel  */
-        UCHAR BIOSConfig1;      /* 0D - BIOS configuration 1    */
-        UCHAR BIOSConfig2;      /* 0E - BIOS boot channel&target ID */
-        UCHAR BIOSConfig3;      /* 0F - BIOS configuration 3    */
+        u8 NumOfCh;          /* 0C - Number of SCSI channel  */
+        u8 BIOSConfig1;      /* 0D - BIOS configuration 1    */
+        u8 BIOSConfig2;      /* 0E - BIOS boot channel&target ID */
+        u8 BIOSConfig3;      /* 0F - BIOS configuration 3    */
         /* ----SCSI channel Structure ---- */
         /* from "CTRL-I SCSI Host Adapter SetUp menu "  */
-        UCHAR SCSI0Id;          /* 10 - Channel 0 SCSI ID       */
-        UCHAR SCSI0Config;      /* 11 - Channel 0 SCSI configuration */
-        UCHAR SCSI0MaxTags;     /* 12 - Channel 0 Maximum tags  */
-        UCHAR SCSI0ResetTime;   /* 13 - Channel 0 Reset recovering time */
-        UCHAR ReservedforChannel0[2];   /* 14 - Reserved                */
+        u8 scsi_id;          /* 10 - Channel 0 SCSI ID       */
+        u8 SCSI0Config;      /* 11 - Channel 0 SCSI configuration */
+        u8 SCSI0MaxTags;     /* 12 - Channel 0 Maximum tags  */
+        u8 SCSI0ResetTime;   /* 13 - Channel 0 Reset recovering time */
+        u8 ReservedforChannel0[2];   /* 14 - Reserved                */
 
         /* ----SCSI target Structure ----  */
         /* from "CTRL-I SCSI device SetUp menu "                        */
-        UCHAR Target00Config;   /* 16 - Channel 0 Target 0 config */
-        UCHAR Target01Config;   /* 17 - Channel 0 Target 1 config */
-        UCHAR Target02Config;   /* 18 - Channel 0 Target 2 config */
-        UCHAR Target03Config;   /* 19 - Channel 0 Target 3 config */
-        UCHAR Target04Config;   /* 1A - Channel 0 Target 4 config */
-        UCHAR Target05Config;   /* 1B - Channel 0 Target 5 config */
-        UCHAR Target06Config;   /* 1C - Channel 0 Target 6 config */
-        UCHAR Target07Config;   /* 1D - Channel 0 Target 7 config */
-        UCHAR Target08Config;   /* 1E - Channel 0 Target 8 config */
-        UCHAR Target09Config;   /* 1F - Channel 0 Target 9 config */
-        UCHAR Target0AConfig;   /* 20 - Channel 0 Target A config */
-        UCHAR Target0BConfig;   /* 21 - Channel 0 Target B config */
-        UCHAR Target0CConfig;   /* 22 - Channel 0 Target C config */
-        UCHAR Target0DConfig;   /* 23 - Channel 0 Target D config */
-        UCHAR Target0EConfig;   /* 24 - Channel 0 Target E config */
-        UCHAR Target0FConfig;   /* 25 - Channel 0 Target F config */
-
-        UCHAR SCSI1Id;          /* 26 - Channel 1 SCSI ID       */
-        UCHAR SCSI1Config;      /* 27 - Channel 1 SCSI configuration */
-        UCHAR SCSI1MaxTags;     /* 28 - Channel 1 Maximum tags  */
-        UCHAR SCSI1ResetTime;   /* 29 - Channel 1 Reset recovering time */
-        UCHAR ReservedforChannel1[2];   /* 2A - Reserved                */
+        u8 Target00Config;   /* 16 - Channel 0 Target 0 config */
+        u8 Target01Config;   /* 17 - Channel 0 Target 1 config */
+        u8 Target02Config;   /* 18 - Channel 0 Target 2 config */
+        u8 Target03Config;   /* 19 - Channel 0 Target 3 config */
+        u8 Target04Config;   /* 1A - Channel 0 Target 4 config */
+        u8 Target05Config;   /* 1B - Channel 0 Target 5 config */
+        u8 Target06Config;   /* 1C - Channel 0 Target 6 config */
+        u8 Target07Config;   /* 1D - Channel 0 Target 7 config */
+        u8 Target08Config;   /* 1E - Channel 0 Target 8 config */
+        u8 Target09Config;   /* 1F - Channel 0 Target 9 config */
+        u8 Target0AConfig;   /* 20 - Channel 0 Target A config */
+        u8 Target0BConfig;   /* 21 - Channel 0 Target B config */
+        u8 Target0CConfig;   /* 22 - Channel 0 Target C config */
+        u8 Target0DConfig;   /* 23 - Channel 0 Target D config */
+        u8 Target0EConfig;   /* 24 - Channel 0 Target E config */
+        u8 Target0FConfig;   /* 25 - Channel 0 Target F config */
+
+        u8 SCSI1Id;          /* 26 - Channel 1 SCSI ID       */
+        u8 SCSI1Config;      /* 27 - Channel 1 SCSI configuration */
+        u8 SCSI1MaxTags;     /* 28 - Channel 1 Maximum tags  */
+        u8 SCSI1ResetTime;   /* 29 - Channel 1 Reset recovering time */
+        u8 ReservedforChannel1[2];   /* 2A - Reserved                */
 
         /* ----SCSI target Structure ----  */
         /* from "CTRL-I SCSI device SetUp menu "                                          */
-        UCHAR Target10Config;   /* 2C - Channel 1 Target 0 config */
-        UCHAR Target11Config;   /* 2D - Channel 1 Target 1 config */
-        UCHAR Target12Config;   /* 2E - Channel 1 Target 2 config */
-        UCHAR Target13Config;   /* 2F - Channel 1 Target 3 config */
-        UCHAR Target14Config;   /* 30 - Channel 1 Target 4 config */
-        UCHAR Target15Config;   /* 31 - Channel 1 Target 5 config */
-        UCHAR Target16Config;   /* 32 - Channel 1 Target 6 config */
-        UCHAR Target17Config;   /* 33 - Channel 1 Target 7 config */
-        UCHAR Target18Config;   /* 34 - Channel 1 Target 8 config */
-        UCHAR Target19Config;   /* 35 - Channel 1 Target 9 config */
-        UCHAR Target1AConfig;   /* 36 - Channel 1 Target A config */
-        UCHAR Target1BConfig;   /* 37 - Channel 1 Target B config */
-        UCHAR Target1CConfig;   /* 38 - Channel 1 Target C config */
-        UCHAR Target1DConfig;   /* 39 - Channel 1 Target D config */
-        UCHAR Target1EConfig;   /* 3A - Channel 1 Target E config */
-        UCHAR Target1FConfig;   /* 3B - Channel 1 Target F config */
-        UCHAR reserved[3];      /* 3C - Reserved                */
+        u8 Target10Config;   /* 2C - Channel 1 Target 0 config */
+        u8 Target11Config;   /* 2D - Channel 1 Target 1 config */
+        u8 Target12Config;   /* 2E - Channel 1 Target 2 config */
+        u8 Target13Config;   /* 2F - Channel 1 Target 3 config */
+        u8 Target14Config;   /* 30 - Channel 1 Target 4 config */
+        u8 Target15Config;   /* 31 - Channel 1 Target 5 config */
+        u8 Target16Config;   /* 32 - Channel 1 Target 6 config */
+        u8 Target17Config;   /* 33 - Channel 1 Target 7 config */
+        u8 Target18Config;   /* 34 - Channel 1 Target 8 config */
+        u8 Target19Config;   /* 35 - Channel 1 Target 9 config */
+        u8 Target1AConfig;   /* 36 - Channel 1 Target A config */
+        u8 Target1BConfig;   /* 37 - Channel 1 Target B config */
+        u8 Target1CConfig;   /* 38 - Channel 1 Target C config */
+        u8 Target1DConfig;   /* 39 - Channel 1 Target D config */
+        u8 Target1EConfig;   /* 3A - Channel 1 Target E config */
+        u8 Target1FConfig;   /* 3B - Channel 1 Target F config */
+        u8 reserved[3];      /* 3C - Reserved                */
         /* ---------- CheckSum ----------       */
-        UCHAR CheckSum;         /* 3F - Checksum of NVRam       */
-} NVRAM, *PNVRAM;
+        u8 CheckSum;         /* 3F - Checksum of NVRam       */
+};
 
 /* Bios Configuration for nvram->BIOSConfig1                            */
 #define NBC_BIOSENABLE  0x01    /* BIOS enable                    */
@@ -407,10 +369,3 @@
 #define NCC_RESET_TIME  0x0A    /* SCSI RESET recovering time     */
 #define NTC_DEFAULT     (NTC_1GIGA | NTC_NO_WIDESYNC | NTC_DISC_ENABLE)
 
-#define ORC_RD(x,y)             (UCHAR)(inb(  (int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-#define ORC_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-#define ORC_RDLONG(x,y)         (long)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-
-#define ORC_WR(     adr,data)   outb( (UCHAR)(data), (int)(adr))
-#define ORC_WRSHORT(adr,data)   outw( (UWORD)(data), (int)(adr))
-#define ORC_WRLONG( adr,data)   outl( (ULONG)(data), (int)(adr))
