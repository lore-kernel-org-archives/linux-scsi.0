From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] initio: Convert into a real Linux driver and update to
 modern style
Date: Mon, 21 May 2007 15:06:43 +0100
Message-ID: <20070521150643.3fdc3b6e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57469 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755925AbXEUOC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 10:02:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org, James Bottomley <James.Bottomley@SteelEye.com>

This is a mix of a grand clean up I did and a reworking of the hotplug
support by Christoph. In testing it works as well as the previous code
did (that is -quite badly-) but we can now read it and as it settles in
actually debug the long standing problems it shares with the old driver.

Signed-off-by: Alan Cox <alan@redhat.com>

(Wants a signed-off-by from Christoph)


I don't know if this should be merged to replace the old driver in -mmdiff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/drivers/scsi/initio.c linux-2.6.22-rc1-mm1/drivers/scsi/initio.c
--- linux.vanilla-2.6.22-rc1-mm1/drivers/scsi/initio.c	2007-04-30 11:00:04.000000000 +0100
+++ linux-2.6.22-rc1-mm1/drivers/scsi/initio.c	2007-05-18 16:37:10.000000000 +0100
@@ -3,7 +3,8 @@
  *
  * Copyright (c) 1994-1998 Initio Corporation
  * Copyright (c) 1998 Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
- * All rights reserved.
+ * Copyright (c) 2004 Christoph Hellwig <hch@lst.de>
+ * Copyright (c) 2007 Red Hat <alan@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -19,38 +20,6 @@
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
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
  *
  *************************************************************************
  *
@@ -70,14 +39,14 @@
  *		- Fix memory allocation problem
  * 03/04/98 hc	- v1.01l
  *		- Fix tape rewind which will hang the system problem
- *		- Set can_queue to tul_num_scb
+ *		- Set can_queue to initio_num_scb
  * 06/25/98 hc	- v1.01m
  *		- Get it work for kernel version >= 2.1.75
- *		- Dynamic assign SCSI bus reset holding time in init_tulip()
+ *		- Dynamic assign SCSI bus reset holding time in initio_init()
  * 07/02/98 hc	- v1.01n
  *		- Support 0002134A
  * 08/07/98 hc  - v1.01o
- *		- Change the tul_abort_srb routine to use scsi_done. <01>
+ *		- Change the initio_abort_srb routine to use scsi_done. <01>
  * 09/07/98 hl  - v1.02
  *              - Change the INI9100U define and proc_dir_entry to
  *                reflect the newer Kernel 2.1.118, but the v1.o1o
@@ -150,23 +119,13 @@
 static unsigned int i91u_debug = DEBUG_DEFAULT;
 #endif
 
-#define TUL_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
-
-typedef struct PCI_ID_Struc {
-	unsigned short vendor_id;
-	unsigned short device_id;
-} PCI_ID;
-
-static int tul_num_ch = 4;	/* Maximum 4 adapters           */
-static int tul_num_scb;
-static int tul_tag_enable = 1;
-static SCB *tul_scb;
+static int initio_tag_enable = 1;
 
 #ifdef DEBUG_i91u
 static int setup_debug = 0;
 #endif
 
-static void i91uSCBPost(BYTE * pHcb, BYTE * pScb);
+static void i91uSCBPost(u8 * pHcb, u8 * pScb);
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id i91u_pci_devices[] = {
@@ -184,74 +143,66 @@
 #define DEBUG_STATE     0
 #define INT_DISC	0
 
-/*--- external functions --*/
-static void tul_se2_wait(void);
+/*--- forward references ---*/
+static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun);
+static struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host * host);
+
+static int tulip_main(struct initio_host * host);
+
+static int initio_next_state(struct initio_host * host);
+static int initio_state_1(struct initio_host * host);
+static int initio_state_2(struct initio_host * host);
+static int initio_state_3(struct initio_host * host);
+static int initio_state_4(struct initio_host * host);
+static int initio_state_5(struct initio_host * host);
+static int initio_state_6(struct initio_host * host);
+static int initio_state_7(struct initio_host * host);
+static int initio_xfer_data_in(struct initio_host * host);
+static int initio_xfer_data_out(struct initio_host * host);
+static int initio_xpad_in(struct initio_host * host);
+static int initio_xpad_out(struct initio_host * host);
+static int initio_status_msg(struct initio_host * host);
+
+static int initio_msgin(struct initio_host * host);
+static int initio_msgin_sync(struct initio_host * host);
+static int initio_msgin_accept(struct initio_host * host);
+static int initio_msgout_reject(struct initio_host * host);
+static int initio_msgin_extend(struct initio_host * host);
+
+static int initio_msgout_ide(struct initio_host * host);
+static int initio_msgout_abort_targ(struct initio_host * host);
+static int initio_msgout_abort_tag(struct initio_host * host);
+
+static int initio_bus_device_reset(struct initio_host * host);
+static void initio_select_atn(struct initio_host * host, struct scsi_ctrl_blk * scb);
+static void initio_select_atn3(struct initio_host * host, struct scsi_ctrl_blk * scb);
+static void initio_select_atn_stop(struct initio_host * host, struct scsi_ctrl_blk * scb);
+static int int_initio_busfree(struct initio_host * host);
+static int int_initio_scsi_rst(struct initio_host * host);
+static int int_initio_bad_seq(struct initio_host * host);
+static int int_initio_resel(struct initio_host * host);
+static int initio_sync_done(struct initio_host * host);
+static int wdtr_done(struct initio_host * host);
+static int wait_tulip(struct initio_host * host);
+static int initio_wait_done_disc(struct initio_host * host);
+static int initio_wait_disc(struct initio_host * host);
+static void tulip_scsi(struct initio_host * host);
+static int initio_post_scsi_rst(struct initio_host * host);
+
+static void initio_se2_ew_en(unsigned long base);
+static void initio_se2_ew_ds(unsigned long base);
+static int initio_se2_rd_all(unsigned long base);
+static void initio_se2_update_all(unsigned long base);	/* setup default pattern */
+static void initio_read_eeprom(unsigned long base);
 
-/*--- forward refrence ---*/
-static SCB *tul_find_busy_scb(HCS * pCurHcb, WORD tarlun);
-static SCB *tul_find_done_scb(HCS * pCurHcb);
-
-static int tulip_main(HCS * pCurHcb);
-
-static int tul_next_state(HCS * pCurHcb);
-static int tul_state_1(HCS * pCurHcb);
-static int tul_state_2(HCS * pCurHcb);
-static int tul_state_3(HCS * pCurHcb);
-static int tul_state_4(HCS * pCurHcb);
-static int tul_state_5(HCS * pCurHcb);
-static int tul_state_6(HCS * pCurHcb);
-static int tul_state_7(HCS * pCurHcb);
-static int tul_xfer_data_in(HCS * pCurHcb);
-static int tul_xfer_data_out(HCS * pCurHcb);
-static int tul_xpad_in(HCS * pCurHcb);
-static int tul_xpad_out(HCS * pCurHcb);
-static int tul_status_msg(HCS * pCurHcb);
-
-static int tul_msgin(HCS * pCurHcb);
-static int tul_msgin_sync(HCS * pCurHcb);
-static int tul_msgin_accept(HCS * pCurHcb);
-static int tul_msgout_reject(HCS * pCurHcb);
-static int tul_msgin_extend(HCS * pCurHcb);
-
-static int tul_msgout_ide(HCS * pCurHcb);
-static int tul_msgout_abort_targ(HCS * pCurHcb);
-static int tul_msgout_abort_tag(HCS * pCurHcb);
-
-static int tul_bus_device_reset(HCS * pCurHcb);
-static void tul_select_atn(HCS * pCurHcb, SCB * pCurScb);
-static void tul_select_atn3(HCS * pCurHcb, SCB * pCurScb);
-static void tul_select_atn_stop(HCS * pCurHcb, SCB * pCurScb);
-static int int_tul_busfree(HCS * pCurHcb);
-static int int_tul_scsi_rst(HCS * pCurHcb);
-static int int_tul_bad_seq(HCS * pCurHcb);
-static int int_tul_resel(HCS * pCurHcb);
-static int tul_sync_done(HCS * pCurHcb);
-static int wdtr_done(HCS * pCurHcb);
-static int wait_tulip(HCS * pCurHcb);
-static int tul_wait_done_disc(HCS * pCurHcb);
-static int tul_wait_disc(HCS * pCurHcb);
-static void tulip_scsi(HCS * pCurHcb);
-static int tul_post_scsi_rst(HCS * pCurHcb);
-
-static void tul_se2_ew_en(WORD CurBase);
-static void tul_se2_ew_ds(WORD CurBase);
-static int tul_se2_rd_all(WORD CurBase);
-static void tul_se2_update_all(WORD CurBase);	/* setup default pattern */
-static void tul_read_eeprom(WORD CurBase);
-
-				/* ---- INTERNAL VARIABLES ---- */
-static HCS tul_hcs[MAX_SUPPORTED_ADAPTERS];
-static INI_ADPT_STRUCT i91u_adpt[MAX_SUPPORTED_ADAPTERS];
+/* ---- INTERNAL VARIABLES ---- */
 
-/*NVRAM nvram, *nvramp = &nvram; */
 static NVRAM i91unvram;
 static NVRAM *i91unvramp;
 
-
-
-static UCHAR i91udftNvRam[64] =
+static u8 i91udftNvRam[64] =
 {
-/*----------- header -----------*/
+	/*----------- header -----------*/
 	0x25, 0xc9,		/* Signature    */
 	0x40,			/* Size         */
 	0x01,			/* Revision     */
@@ -289,7 +240,7 @@
 	0, 0};			/*      - CheckSum -            */
 
 
-static UCHAR tul_rate_tbl[8] =	/* fast 20      */
+static u8 initio_rate_tbl[8] =	/* fast 20      */
 {
 				/* nanosecond devide by 4 */
 	12,			/* 50ns,  20M   */
@@ -302,53 +253,17 @@
 	62			/* 250ns, 4M    */
 };
 
-static void tul_do_pause(unsigned amount)
-{				/* Pause for amount jiffies */
+static void initio_do_pause(unsigned amount)
+{		
+	/* Pause for amount jiffies */
 	unsigned long the_time = jiffies + amount;
 
-	while (time_before_eq(jiffies, the_time));
+	while (time_before_eq(jiffies, the_time))
+		cpu_relax();
 }
 
 /*-- forward reference --*/
 
-/*******************************************************************
-	Use memeory refresh time        ~ 15us * 2
-********************************************************************/
-void tul_se2_wait(void)
-{
-#if 1
-	udelay(30);
-#else
-	UCHAR readByte;
-
-	readByte = TUL_RD(0, 0x61);
-	if ((readByte & 0x10) == 0x10) {
-		for (;;) {
-			readByte = TUL_RD(0, 0x61);
-			if ((readByte & 0x10) == 0x10)
-				break;
-		}
-		for (;;) {
-			readByte = TUL_RD(0, 0x61);
-			if ((readByte & 0x10) != 0x10)
-				break;
-		}
-	} else {
-		for (;;) {
-			readByte = TUL_RD(0, 0x61);
-			if ((readByte & 0x10) == 0x10)
-				break;
-		}
-		for (;;) {
-			readByte = TUL_RD(0, 0x61);
-			if ((readByte & 0x10) != 0x10)
-				break;
-		}
-	}
-#endif
-}
-
-
 /******************************************************************
  Input: instruction for  Serial E2PROM
 
@@ -379,1174 +294,1026 @@
 
 
 ******************************************************************/
-static void tul_se2_instr(WORD CurBase, UCHAR instr)
+
+/**
+ *	initio_se2_instr	-	bitbang an instruction
+ *	@base: Base of InitIO controller
+ *	@instr: Instruction for serial E2PROM
+ *
+ *	Bitbang an instruction out to the serial E2Prom
+ */
+
+static void initio_se2_instr(unsigned long base, u8 instr)
 {
 	int i;
-	UCHAR b;
+	u8 b;
 
-	TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2DO);	/* cs+start bit */
-	tul_se2_wait();
-	TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2CLK | SE2DO);	/* +CLK */
-	tul_se2_wait();
+	outb(SE2CS | SE2DO, base + TUL_NVRAM);		/* cs+start bit */
+	udelay(30);
+	outb(SE2CS | SE2CLK | SE2DO, base + TUL_NVRAM);	/* +CLK */
+	udelay(30);
 
 	for (i = 0; i < 8; i++) {
 		if (instr & 0x80)
-			b = SE2CS | SE2DO;	/* -CLK+dataBit */
+			b = SE2CS | SE2DO;		/* -CLK+dataBit */
 		else
-			b = SE2CS;	/* -CLK */
-		TUL_WR(CurBase + TUL_NVRAM, b);
-		tul_se2_wait();
-		TUL_WR(CurBase + TUL_NVRAM, b | SE2CLK);	/* +CLK */
-		tul_se2_wait();
+			b = SE2CS;			/* -CLK */
+		outb(b, base + TUL_NVRAM);
+		udelay(30);
+		outb(b | SE2CLK, base + TUL_NVRAM);	/* +CLK */
+		udelay(30);
 		instr <<= 1;
 	}
-	TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK */
-	tul_se2_wait();
-	return;
+	outb(SE2CS, base + TUL_NVRAM);			/* -CLK */
+	udelay(30);
 }
 
 
-/******************************************************************
- Function name  : tul_se2_ew_en
- Description    : Enable erase/write state of serial EEPROM
-******************************************************************/
-void tul_se2_ew_en(WORD CurBase)
+/**
+ *	initio_se2_ew_en	-	Enable erase/write
+ *	@base: Base address of InitIO controller
+ *
+ *	Enable erase/write state of serial EEPROM
+ */
+ 
+void initio_se2_ew_en(unsigned long base)
 {
-	tul_se2_instr(CurBase, 0x30);	/* EWEN */
-	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
-	tul_se2_wait();
-	return;
+	initio_se2_instr(base, 0x30);	/* EWEN */
+	outb(0, base + TUL_NVRAM);	/* -CS  */
+	udelay(30);
 }
 
 
-/************************************************************************
- Disable erase/write state of serial EEPROM
-*************************************************************************/
-void tul_se2_ew_ds(WORD CurBase)
-{
-	tul_se2_instr(CurBase, 0);	/* EWDS */
-	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
-	tul_se2_wait();
-	return;
+/**
+ *	initio_se2_ew_ds	-	Disable erase/write
+ *	@base: Base address of InitIO controller
+ *
+ *	Disable erase/write state of serial EEPROM
+ */
+ 
+void initio_se2_ew_ds(unsigned long base)
+{
+	initio_se2_instr(base, 0);	/* EWDS */
+	outb(0, base + TUL_NVRAM);	/* -CS  */
+	udelay(30);
 }
 
 
-/******************************************************************
-	Input  :address of Serial E2PROM
-	Output :value stored in  Serial E2PROM
-*******************************************************************/
-static USHORT tul_se2_rd(WORD CurBase, ULONG adr)
+/**
+ *	initio_se2_rd		-	read E2PROM word
+ *	@base: Base of InitIO controller
+ *	@addr: Address of word in E2PROM
+ *
+ *	Read a word from the NV E2PROM device
+ */
+ 
+static u16 initio_se2_rd(unsigned long base, u8 addr)
 {
-	UCHAR instr, readByte;
-	USHORT readWord;
+	u8 instr, rb;
+	u16 val = 0;
 	int i;
 
-	instr = (UCHAR) (adr | 0x80);
-	tul_se2_instr(CurBase, instr);	/* READ INSTR */
-	readWord = 0;
+	instr = (u8) (addr | 0x80);
+	initio_se2_instr(base, instr);	/* READ INSTR */
 
 	for (i = 15; i >= 0; i--) {
-		TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2CLK);	/* +CLK */
-		tul_se2_wait();
-		TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK */
+		outb(SE2CS | SE2CLK, base + TUL_NVRAM);	/* +CLK */
+		udelay(30);
+		outb(SE2CS, base + TUL_NVRAM);		/* -CLK */
 
 		/* sample data after the following edge of clock  */
-		readByte = TUL_RD(CurBase, TUL_NVRAM);
-		readByte &= SE2DI;
-		readWord += (readByte << i);
-		tul_se2_wait();	/* 6/20/95 */
+		rb = inb(base + TUL_NVRAM);
+		rb &= SE2DI;
+		val += (rb << i);
+		udelay(30);	/* 6/20/95 */
 	}
 
-	TUL_WR(CurBase + TUL_NVRAM, 0);		/* no chip select */
-	tul_se2_wait();
-	return readWord;
+	outb(0, base + TUL_NVRAM);		/* no chip select */
+	udelay(30);
+	return val;
 }
 
+/**
+ *	initio_se2_wr		-	read E2PROM word
+ *	@base: Base of InitIO controller
+ *	@addr: Address of word in E2PROM
+ *	@val: Value to write
+ *
+ *	Write a word to the NV E2PROM device. Used when recovering from
+ *	a problem with the NV.
+ */
+ 
 
-/******************************************************************
- Input: new value in  Serial E2PROM, address of Serial E2PROM
-*******************************************************************/
-static void tul_se2_wr(WORD CurBase, UCHAR adr, USHORT writeWord)
+static void initio_se2_wr(unsigned long base, u8 addr, u16 val)
 {
-	UCHAR readByte;
-	UCHAR instr;
+	u8 rb;
+	u8 instr;
 	int i;
 
-	instr = (UCHAR) (adr | 0x40);
-	tul_se2_instr(CurBase, instr);	/* WRITE INSTR */
+	instr = (u8) (addr | 0x40);
+	initio_se2_instr(base, instr);	/* WRITE INSTR */
 	for (i = 15; i >= 0; i--) {
-		if (writeWord & 0x8000)
-			TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2DO);	/* -CLK+dataBit 1 */
+		if (val & 0x8000)
+			outb(SE2CS | SE2DO, base + TUL_NVRAM);	/* -CLK+dataBit 1 */
 		else
-			TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK+dataBit 0 */
-		tul_se2_wait();
-		TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2CLK);	/* +CLK */
-		tul_se2_wait();
-		writeWord <<= 1;
-	}
-	TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK */
-	tul_se2_wait();
-	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
-	tul_se2_wait();
+			outb(SE2CS, base + TUL_NVRAM);		/* -CLK+dataBit 0 */
+		udelay(30);
+		outb(SE2CS | SE2CLK, base + TUL_NVRAM);		/* +CLK */
+		udelay(30);
+		val <<= 1;
+	}
+	outb(SE2CS, base + TUL_NVRAM);				/* -CLK */
+	udelay(30);
+	outb(0, base + TUL_NVRAM);				/* -CS  */
+	udelay(30);
 
-	TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* +CS  */
-	tul_se2_wait();
+	outb(SE2CS, base + TUL_NVRAM);				/* +CS  */
+	udelay(30);
 
 	for (;;) {
-		TUL_WR(CurBase + TUL_NVRAM, SE2CS | SE2CLK);	/* +CLK */
-		tul_se2_wait();
-		TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK */
-		tul_se2_wait();
-		if ((readByte = TUL_RD(CurBase, TUL_NVRAM)) & SE2DI)
+		outb(SE2CS | SE2CLK, base + TUL_NVRAM);		/* +CLK */
+		udelay(30);
+		outb(SE2CS, base + TUL_NVRAM);			/* -CLK */
+		udelay(30);
+		if ((rb = inb(base + TUL_NVRAM)) & SE2DI)
 			break;	/* write complete */
 	}
-	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS */
-	return;
+	outb(0, base + TUL_NVRAM);				/* -CS */
 }
 
+/**
+ *	initio_se2_rd_all	-	read hostadapter NV configuration
+ *	@base: Base address of InitIO controller
+ *
+ *	Reads the E2PROM data into main memory. Ensures that the checksum
+ *	and header marker are valid. Returns 1 on success -1 on error.
+ */
 
-/***********************************************************************
- Read SCSI H/A configuration parameters from serial EEPROM
-************************************************************************/
-int tul_se2_rd_all(WORD CurBase)
+static int initio_se2_rd_all(unsigned long base)
 {
 	int i;
-	ULONG chksum = 0;
-	USHORT *np;
+	u16 chksum = 0;
+	u16 *np;
 
 	i91unvramp = &i91unvram;
-	np = (USHORT *) i91unvramp;
-	for (i = 0; i < 32; i++) {
-		*np++ = tul_se2_rd(CurBase, i);
-	}
+	np = (u16 *) i91unvramp;
+	for (i = 0; i < 32; i++)
+		*np++ = initio_se2_rd(base, i);
 
-/*--------------------Is signature "ini" ok ? ----------------*/
+	/* Is signature "ini" ok ? */
 	if (i91unvramp->NVM_Signature != INI_SIGNATURE)
 		return -1;
-/*---------------------- Is ckecksum ok ? ----------------------*/
-	np = (USHORT *) i91unvramp;
+	/* Is ckecksum ok ? */
+	np = (u16 *) i91unvramp;
 	for (i = 0; i < 31; i++)
 		chksum += *np++;
-	if (i91unvramp->NVM_CheckSum != (USHORT) chksum)
+	if (i91unvramp->NVM_CheckSum != chksum)
 		return -1;
 	return 1;
 }
 
-
-/***********************************************************************
- Update SCSI H/A configuration parameters from serial EEPROM
-************************************************************************/
-void tul_se2_update_all(WORD CurBase)
+/**
+ *	initio_se2_update_all		-	Update E2PROM
+ *	@base: Base of InitIO controller
+ *
+ *	Update the E2PROM by wrting any changes into the E2PROM
+ *	chip, rewriting the checksum.
+ */
+ 
+static void initio_se2_update_all(unsigned long base)
 {				/* setup default pattern */
 	int i;
-	ULONG chksum = 0;
-	USHORT *np, *np1;
+	u16 chksum = 0;
+	u16 *np, *np1;
 
 	i91unvramp = &i91unvram;
 	/* Calculate checksum first */
-	np = (USHORT *) i91udftNvRam;
+	np = (u16 *) i91udftNvRam;
 	for (i = 0; i < 31; i++)
 		chksum += *np++;
-	*np = (USHORT) chksum;
-	tul_se2_ew_en(CurBase);	/* Enable write  */
+	*np = chksum;
+	initio_se2_ew_en(base);	/* Enable write  */
 
-	np = (USHORT *) i91udftNvRam;
-	np1 = (USHORT *) i91unvramp;
+	np = (u16 *) i91udftNvRam;
+	np1 = (u16 *) i91unvramp;
 	for (i = 0; i < 32; i++, np++, np1++) {
-		if (*np != *np1) {
-			tul_se2_wr(CurBase, i, *np);
-		}
+		if (*np != *np1)
+			initio_se2_wr(base, i, *np);
 	}
-
-	tul_se2_ew_ds(CurBase);	/* Disable write   */
-	return;
+	initio_se2_ew_ds(base);	/* Disable write   */
 }
 
-/*************************************************************************
- Function name  : read_eeprom
-**************************************************************************/
-void tul_read_eeprom(WORD CurBase)
-{
-	UCHAR gctrl;
-
-	i91unvramp = &i91unvram;
-/*------Enable EEProm programming ---*/
-	gctrl = TUL_RD(CurBase, TUL_GCTRL);
-	TUL_WR(CurBase + TUL_GCTRL, gctrl | TUL_GCTRL_EEPROM_BIT);
-	if (tul_se2_rd_all(CurBase) != 1) {
-		tul_se2_update_all(CurBase);	/* setup default pattern */
-		tul_se2_rd_all(CurBase);	/* load again  */
-	}
-/*------ Disable EEProm programming ---*/
-	gctrl = TUL_RD(CurBase, TUL_GCTRL);
-	TUL_WR(CurBase + TUL_GCTRL, gctrl & ~TUL_GCTRL_EEPROM_BIT);
-}				/* read_eeprom */
+/**
+ *	initio_read_eeprom		-	Retrieve configuration
+ *	@base: Base of InitIO Host Adapter
+ *
+ *	Retrieve the host adapter configuration data from E2Prom. If the
+ *	data is invalid then the defaults are used and are also restored
+ *	into the E2PROM. This forms the access point for the SCSI driver
+ *	into the E2PROM layer, the other functions for the E2PROM are all
+ *	internal use.
+ *
+ *	Must be called single threaded, uses a shared global area.
+ */
 
-static int Addi91u_into_Adapter_table(WORD wBIOS, WORD wBASE, BYTE bInterrupt,
-				      BYTE bBus, BYTE bDevice)
+static void initio_read_eeprom(unsigned long base)
 {
-	int i, j;
+	u8 gctrl;
 
-	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {
-		if (i91u_adpt[i].ADPT_BIOS < wBIOS)
-			continue;
-		if (i91u_adpt[i].ADPT_BIOS == wBIOS) {
-			if (i91u_adpt[i].ADPT_BASE == wBASE) {
-				if (i91u_adpt[i].ADPT_Bus != 0xFF)
-					return 1;
-			} else if (i91u_adpt[i].ADPT_BASE < wBASE)
-					continue;
-		}
-		for (j = MAX_SUPPORTED_ADAPTERS - 1; j > i; j--) {
-			i91u_adpt[j].ADPT_BASE = i91u_adpt[j - 1].ADPT_BASE;
-			i91u_adpt[j].ADPT_INTR = i91u_adpt[j - 1].ADPT_INTR;
-			i91u_adpt[j].ADPT_BIOS = i91u_adpt[j - 1].ADPT_BIOS;
-			i91u_adpt[j].ADPT_Bus = i91u_adpt[j - 1].ADPT_Bus;
-			i91u_adpt[j].ADPT_Device = i91u_adpt[j - 1].ADPT_Device;
-		}
-		i91u_adpt[i].ADPT_BASE = wBASE;
-		i91u_adpt[i].ADPT_INTR = bInterrupt;
-		i91u_adpt[i].ADPT_BIOS = wBIOS;
-		i91u_adpt[i].ADPT_Bus = bBus;
-		i91u_adpt[i].ADPT_Device = bDevice;
-		return 0;
-	}
-	return 1;
+	i91unvramp = &i91unvram;
+	/* Enable EEProm programming */
+	gctrl = inb(base + TUL_GCTRL);
+	outb(gctrl | TUL_GCTRL_EEPROM_BIT, base + TUL_GCTRL);
+	if (initio_se2_rd_all(base) != 1) {
+		initio_se2_update_all(base);	/* setup default pattern */
+		initio_se2_rd_all(base);	/* load again  */
+	}
+	/* Disable EEProm programming */
+	gctrl = inb(base + TUL_GCTRL);
+	outb(gctrl & ~TUL_GCTRL_EEPROM_BIT, base + TUL_GCTRL);
 }
 
-static void init_i91uAdapter_table(void)
-{
-	int i;
-
-	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {	/* Initialize adapter structure */
-		i91u_adpt[i].ADPT_BIOS = 0xffff;
-		i91u_adpt[i].ADPT_BASE = 0xffff;
-		i91u_adpt[i].ADPT_INTR = 0xff;
-		i91u_adpt[i].ADPT_Bus = 0xff;
-		i91u_adpt[i].ADPT_Device = 0xff;
-	}
-	return;
-}
+/**
+ *	initio_stop_bm		-	stop bus master
+ *	@host: InitIO we are stopping
+ *
+ *	Stop any pending DMA operation, aborting the DMA if neccessary
+ */
 
-static void tul_stop_bm(HCS * pCurHcb)
+static void initio_stop_bm(struct initio_host * host)
 {
 
-	if (TUL_RD(pCurHcb->HCS_Base, TUL_XStatus) & XPEND) {	/* if DMA xfer is pending, abort DMA xfer */
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_X_ABT | TAX_X_CLR_FIFO);
+	if (inb(host->addr + TUL_XStatus) & XPEND) {	/* if DMA xfer is pending, abort DMA xfer */
+		outb(TAX_X_ABT | TAX_X_CLR_FIFO, host->addr + TUL_XCmd);
 		/* wait Abort DMA xfer done */
-		while ((TUL_RD(pCurHcb->HCS_Base, TUL_Int) & XABT) == 0);
+		while ((inb(host->addr + TUL_Int) & XABT) == 0)
+			cpu_relax();
 	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
+	outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 }
 
-/***************************************************************************/
-static void get_tulipPCIConfig(HCS * pCurHcb, int ch_idx)
-{
-	pCurHcb->HCS_Base = i91u_adpt[ch_idx].ADPT_BASE;	/* Supply base address  */
-	pCurHcb->HCS_BIOS = i91u_adpt[ch_idx].ADPT_BIOS;	/* Supply BIOS address  */
-	pCurHcb->HCS_Intr = i91u_adpt[ch_idx].ADPT_INTR;	/* Supply interrupt line */
-	return;
-}
+/**
+ *	initio_reset_scsi		-	Reset SCSI host controller
+ *	@host: InitIO host to reset
+ *	@seconds: Recovery time
+ *
+ *	Perform a full reset of the SCSI subsystem.
+ */
 
-/***************************************************************************/
-static int tul_reset_scsi(HCS * pCurHcb, int seconds)
+static int initio_reset_scsi(struct initio_host * host, int seconds)
 {
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_RST_BUS);
+	outb(TSC_RST_BUS, host->addr + TUL_SCtrl0);
 
-	while (!((pCurHcb->HCS_JSInt = TUL_RD(pCurHcb->HCS_Base, TUL_SInt)) & TSS_SCSIRST_INT));
-	/* reset tulip chip */
+	while (!((host->jsint = inb(host->addr + TUL_SInt)) & TSS_SCSIRST_INT))
+		cpu_relax();
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, 0);
+	/* reset tulip chip */
+	outb(0, host->addr + TUL_SSignal);
 
 	/* Stall for a while, wait for target's firmware ready,make it 2 sec ! */
 	/* SONY 5200 tape drive won't work if only stall for 1 sec */
-	tul_do_pause(seconds * HZ);
-
-	TUL_RD(pCurHcb->HCS_Base, TUL_SInt);
+	/* FIXME: this is a very long busy wait right now */
+	initio_do_pause(seconds * HZ);
 
-	return (SCSI_RESET_SUCCESS);
+	inb(host->addr + TUL_SInt);
+	return SCSI_RESET_SUCCESS;
 }
 
-/***************************************************************************/
-static int init_tulip(HCS * pCurHcb, SCB * scbp, int tul_num_scb,
-		      BYTE * pbBiosAdr, int seconds)
+/**
+ *	initio_init		-	set up an InitIO host adapter
+ *	@host: InitIO host adapter
+ *	@num_scbs: Number of SCBS
+ *	@bios_addr: BIOS address
+ *
+ *	Set up the host adapter and devices according to the configuration
+ *	retrieved from the E2PROM.
+ *
+ *	Locking: Calls E2PROM layer code which is not re-enterable so must
+ *	run single threaded for now.
+ */
+
+static void initio_init(struct initio_host * host, u8 *bios_addr)
 {
 	int i;
-	BYTE *pwFlags;
-	BYTE *pbHeads;
-	SCB *pTmpScb, *pPrevScb = NULL;
-
-	pCurHcb->HCS_NumScbs = tul_num_scb;
-	pCurHcb->HCS_Semaph = 1;
-	spin_lock_init(&pCurHcb->HCS_SemaphLock);
-	pCurHcb->HCS_JSStatus0 = 0;
-	pCurHcb->HCS_Scb = scbp;
-	pCurHcb->HCS_NxtPend = scbp;
-	pCurHcb->HCS_NxtAvail = scbp;
-	for (i = 0, pTmpScb = scbp; i < tul_num_scb; i++, pTmpScb++) {
-		pTmpScb->SCB_TagId = i;
-		if (i != 0)
-			pPrevScb->SCB_NxtScb = pTmpScb;
-		pPrevScb = pTmpScb;
-	}
-	pPrevScb->SCB_NxtScb = NULL;
-	pCurHcb->HCS_ScbEnd = pTmpScb;
-	pCurHcb->HCS_FirstAvail = scbp;
-	pCurHcb->HCS_LastAvail = pPrevScb;
-	spin_lock_init(&pCurHcb->HCS_AvailLock);
-	pCurHcb->HCS_FirstPend = NULL;
-	pCurHcb->HCS_LastPend = NULL;
-	pCurHcb->HCS_FirstBusy = NULL;
-	pCurHcb->HCS_LastBusy = NULL;
-	pCurHcb->HCS_FirstDone = NULL;
-	pCurHcb->HCS_LastDone = NULL;
-	pCurHcb->HCS_ActScb = NULL;
-	pCurHcb->HCS_ActTcs = NULL;
+	u8 *flags;
+	u8 *heads;
 
-	tul_read_eeprom(pCurHcb->HCS_Base);
-/*---------- get H/A configuration -------------*/
+	/* Get E2Prom configuration */
+	initio_read_eeprom(host->addr);
 	if (i91unvramp->NVM_SCSIInfo[0].NVM_NumOfTarg == 8)
-		pCurHcb->HCS_MaxTar = 8;
+		host->max_tar = 8;
 	else
-		pCurHcb->HCS_MaxTar = 16;
+		host->max_tar = 16;
 
-	pCurHcb->HCS_Config = i91unvramp->NVM_SCSIInfo[0].NVM_ChConfig1;
+	host->config = i91unvramp->NVM_SCSIInfo[0].NVM_ChConfig1;
 
-	pCurHcb->HCS_SCSI_ID = i91unvramp->NVM_SCSIInfo[0].NVM_ChSCSIID;
-	pCurHcb->HCS_IdMask = ~(1 << pCurHcb->HCS_SCSI_ID);
+	host->scsi_id = i91unvramp->NVM_SCSIInfo[0].NVM_ChSCSIID;
+	host->idmask = ~(1 << host->scsi_id);
 
 #ifdef CHK_PARITY
 	/* Enable parity error response */
-	TUL_WR(pCurHcb->HCS_Base + TUL_PCMD, TUL_RD(pCurHcb->HCS_Base, TUL_PCMD) | 0x40);
+	outb(inb(host->addr + TUL_PCMD) | 0x40, host->addr + TUL_PCMD);
 #endif
 
 	/* Mask all the interrupt       */
-	TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
+	outb(0x1F, host->addr + TUL_Mask);
 
-	tul_stop_bm(pCurHcb);
+	initio_stop_bm(host);
 	/* --- Initialize the tulip --- */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_RST_CHIP);
+	outb(TSC_RST_CHIP, host->addr + TUL_SCtrl0);
 
 	/* program HBA's SCSI ID        */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SScsiId, pCurHcb->HCS_SCSI_ID << 4);
+	outb(host->scsi_id << 4, host->addr + TUL_SScsiId);
 
 	/* Enable Initiator Mode ,phase latch,alternate sync period mode,
 	   disable SCSI reset */
-	if (pCurHcb->HCS_Config & HCC_EN_PAR)
-		pCurHcb->HCS_SConf1 = (TSC_INITDEFAULT | TSC_EN_SCSI_PAR);
+	if (host->config & HCC_EN_PAR)
+		host->sconf1 = (TSC_INITDEFAULT | TSC_EN_SCSI_PAR);
 	else
-		pCurHcb->HCS_SConf1 = (TSC_INITDEFAULT);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurHcb->HCS_SConf1);
+		host->sconf1 = (TSC_INITDEFAULT);
+	outb(host->sconf1, host->addr + TUL_SConfig);
 
-	/* Enable HW reselect           */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);
+	/* Enable HW reselect */
+	outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SPeriod, 0);
+	outb(0, host->addr + TUL_SPeriod);
 
 	/* selection time out = 250 ms */
-	TUL_WR(pCurHcb->HCS_Base + TUL_STimeOut, 153);
+	outb(153, host->addr + TUL_STimeOut);
 
-/*--------- Enable SCSI terminator -----*/
-	TUL_WR(pCurHcb->HCS_Base + TUL_XCtrl, (pCurHcb->HCS_Config & (HCC_ACT_TERM1 | HCC_ACT_TERM2)));
-	TUL_WR(pCurHcb->HCS_Base + TUL_GCTRL1,
-	       ((pCurHcb->HCS_Config & HCC_AUTO_TERM) >> 4) | (TUL_RD(pCurHcb->HCS_Base, TUL_GCTRL1) & 0xFE));
+	/* Enable SCSI terminator */
+	outb((host->config & (HCC_ACT_TERM1 | HCC_ACT_TERM2)),
+		host->addr + TUL_XCtrl);
+	outb(((host->config & HCC_AUTO_TERM) >> 4) | 
+		(inb(host->addr + TUL_GCTRL1) & 0xFE),
+		host->addr + TUL_GCTRL1);
 
 	for (i = 0,
-	     pwFlags = & (i91unvramp->NVM_SCSIInfo[0].NVM_Targ0Config),
-	     pbHeads = pbBiosAdr + 0x180;
-	     i < pCurHcb->HCS_MaxTar;
-	     i++, pwFlags++) {
-		pCurHcb->HCS_Tcs[i].TCS_Flags = *pwFlags & ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
-		if (pCurHcb->HCS_Tcs[i].TCS_Flags & TCF_EN_255)
-			pCurHcb->HCS_Tcs[i].TCS_DrvFlags = TCF_DRV_255_63;
+	     flags = & (i91unvramp->NVM_SCSIInfo[0].NVM_Targ0Config),
+	     heads = bios_addr + 0x180;
+	     i < host->max_tar;
+	     i++, flags++) {
+		host->targets[i].flags = *flags & ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
+		if (host->targets[i].flags & TCF_EN_255)
+			host->targets[i].drv_flags = TCF_DRV_255_63;
 		else
-			pCurHcb->HCS_Tcs[i].TCS_DrvFlags = 0;
-		pCurHcb->HCS_Tcs[i].TCS_JS_Period = 0;
-		pCurHcb->HCS_Tcs[i].TCS_SConfig0 = pCurHcb->HCS_SConf1;
-		pCurHcb->HCS_Tcs[i].TCS_DrvHead = *pbHeads++;
-		if (pCurHcb->HCS_Tcs[i].TCS_DrvHead == 255)
-			pCurHcb->HCS_Tcs[i].TCS_DrvFlags = TCF_DRV_255_63;
+			host->targets[i].drv_flags = 0;
+		host->targets[i].js_period = 0;
+		host->targets[i].sconfig0 = host->sconf1;
+		host->targets[i].heads = *heads++;
+		if (host->targets[i].heads == 255)
+			host->targets[i].drv_flags = TCF_DRV_255_63;
 		else
-			pCurHcb->HCS_Tcs[i].TCS_DrvFlags = 0;
-		pCurHcb->HCS_Tcs[i].TCS_DrvSector = *pbHeads++;
-		pCurHcb->HCS_Tcs[i].TCS_Flags &= ~TCF_BUSY;
-		pCurHcb->HCS_ActTags[i] = 0;
-		pCurHcb->HCS_MaxTags[i] = 0xFF;
+			host->targets[i].drv_flags = 0;
+		host->targets[i].sectors = *heads++;
+		host->targets[i].flags &= ~TCF_BUSY;
+		host->act_tags[i] = 0;
+		host->max_tags[i] = 0xFF;
 	}			/* for                          */
 	printk("i91u: PCI Base=0x%04X, IRQ=%d, BIOS=0x%04X0, SCSI ID=%d\n",
-	       pCurHcb->HCS_Base, pCurHcb->HCS_Intr,
-	       pCurHcb->HCS_BIOS, pCurHcb->HCS_SCSI_ID);
-/*------------------- reset SCSI Bus ---------------------------*/
-	if (pCurHcb->HCS_Config & HCC_SCSI_RESET) {
-		printk("i91u: Reset SCSI Bus ... \n");
-		tul_reset_scsi(pCurHcb, seconds);
-	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCFG1, 0x17);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SIntEnable, 0xE9);
-	return (0);
+	       host->addr, host->irq,
+	       host->bios_addr, host->scsi_id);
+	/* Reset SCSI Bus */
+	if (host->config & HCC_SCSI_RESET) {
+		printk(KERN_INFO "i91u: Reset SCSI Bus ... \n");
+		initio_reset_scsi(host, 10);
+	}
+	outb(0x17, host->addr + TUL_SCFG1);
+	outb(0xE9, host->addr + TUL_SIntEnable);
 }
 
-/***************************************************************************/
-static SCB *tul_alloc_scb(HCS * hcsp)
+/**
+ *	initio_alloc_scb		-	Allocate an SCB
+ *	@host: InitIO host we are allocating for
+ *
+ *	Walk the SCB list for the controller and allocate a free SCB if 
+ *	one exists.
+ */
+ 
+static struct scsi_ctrl_blk *initio_alloc_scb(struct initio_host *host)
 {
-	SCB *pTmpScb;
-	ULONG flags;
-	spin_lock_irqsave(&(hcsp->HCS_AvailLock), flags);
-	if ((pTmpScb = hcsp->HCS_FirstAvail) != NULL) {
+	struct scsi_ctrl_blk *scb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->avail_lock, flags);
+	if ((scb = host->first_avail) != NULL) {
 #if DEBUG_QUEUE
-		printk("find scb at %08lx\n", (ULONG) pTmpScb);
+		printk("find scb at %p\n", scb);
 #endif
-		if ((hcsp->HCS_FirstAvail = pTmpScb->SCB_NxtScb) == NULL)
-			hcsp->HCS_LastAvail = NULL;
-		pTmpScb->SCB_NxtScb = NULL;
-		pTmpScb->SCB_Status = SCB_RENT;
+		if ((host->first_avail = scb->next) == NULL)
+			host->last_avail = NULL;
+		scb->next = NULL;
+		scb->status = SCB_RENT;
 	}
-	spin_unlock_irqrestore(&(hcsp->HCS_AvailLock), flags);
-	return (pTmpScb);
+	spin_unlock_irqrestore(&host->avail_lock, flags);
+	return scb;
 }
 
-/***************************************************************************/
-static void tul_release_scb(HCS * hcsp, SCB * scbp)
+/**
+ *	initio_release_scb		-	Release an SCB
+ *	@host: InitIO host that owns the SCB
+ *	@cmnd: SCB command block being returned
+ *
+ *	Return an allocated SCB to the host free list
+ */
+
+static void initio_release_scb(struct initio_host * host, struct scsi_ctrl_blk * cmnd)
 {
-	ULONG flags;
+	unsigned long flags;
 
 #if DEBUG_QUEUE
-	printk("Release SCB %lx; ", (ULONG) scbp);
+	printk("Release SCB %p; ", cmnd);
 #endif
-	spin_lock_irqsave(&(hcsp->HCS_AvailLock), flags);
-	scbp->SCB_Srb = NULL;
-	scbp->SCB_Status = 0;
-	scbp->SCB_NxtScb = NULL;
-	if (hcsp->HCS_LastAvail != NULL) {
-		hcsp->HCS_LastAvail->SCB_NxtScb = scbp;
-		hcsp->HCS_LastAvail = scbp;
+	spin_lock_irqsave(&(host->avail_lock), flags);
+	cmnd->srb = NULL;
+	cmnd->status = 0;
+	cmnd->next = NULL;
+	if (host->last_avail != NULL) {
+		host->last_avail->next = cmnd;
+		host->last_avail = cmnd;
 	} else {
-		hcsp->HCS_FirstAvail = scbp;
-		hcsp->HCS_LastAvail = scbp;
+		host->first_avail = cmnd;
+		host->last_avail = cmnd;
 	}
-	spin_unlock_irqrestore(&(hcsp->HCS_AvailLock), flags);
+	spin_unlock_irqrestore(&(host->avail_lock), flags);
 }
 
 /***************************************************************************/
-static void tul_append_pend_scb(HCS * pCurHcb, SCB * scbp)
+static void initio_append_pend_scb(struct initio_host * host, struct scsi_ctrl_blk * scbp)
 {
 
 #if DEBUG_QUEUE
-	printk("Append pend SCB %lx; ", (ULONG) scbp);
+	printk("Append pend SCB %p; ", scbp);
 #endif
-	scbp->SCB_Status = SCB_PEND;
-	scbp->SCB_NxtScb = NULL;
-	if (pCurHcb->HCS_LastPend != NULL) {
-		pCurHcb->HCS_LastPend->SCB_NxtScb = scbp;
-		pCurHcb->HCS_LastPend = scbp;
+	scbp->status = SCB_PEND;
+	scbp->next = NULL;
+	if (host->last_pending != NULL) {
+		host->last_pending->next = scbp;
+		host->last_pending = scbp;
 	} else {
-		pCurHcb->HCS_FirstPend = scbp;
-		pCurHcb->HCS_LastPend = scbp;
+		host->first_pending = scbp;
+		host->last_pending = scbp;
 	}
 }
 
 /***************************************************************************/
-static void tul_push_pend_scb(HCS * pCurHcb, SCB * scbp)
+static void initio_push_pend_scb(struct initio_host * host, struct scsi_ctrl_blk * scbp)
 {
 
 #if DEBUG_QUEUE
-	printk("Push pend SCB %lx; ", (ULONG) scbp);
+	printk("Push pend SCB %p; ", scbp);
 #endif
-	scbp->SCB_Status = SCB_PEND;
-	if ((scbp->SCB_NxtScb = pCurHcb->HCS_FirstPend) != NULL) {
-		pCurHcb->HCS_FirstPend = scbp;
+	scbp->status = SCB_PEND;
+	if ((scbp->next = host->first_pending) != NULL) {
+		host->first_pending = scbp;
 	} else {
-		pCurHcb->HCS_FirstPend = scbp;
-		pCurHcb->HCS_LastPend = scbp;
+		host->first_pending = scbp;
+		host->last_pending = scbp;
 	}
 }
 
-/***************************************************************************/
-static SCB *tul_find_first_pend_scb(HCS * pCurHcb)
+static struct scsi_ctrl_blk *initio_find_first_pend_scb(struct initio_host * host)
 {
-	SCB *pFirstPend;
+	struct scsi_ctrl_blk *first;
 
 
-	pFirstPend = pCurHcb->HCS_FirstPend;
-	while (pFirstPend != NULL) {
-		if (pFirstPend->SCB_Opcode != ExecSCSI) {
-			return (pFirstPend);
-		}
-		if (pFirstPend->SCB_TagMsg == 0) {
-			if ((pCurHcb->HCS_ActTags[pFirstPend->SCB_Target] == 0) &&
-			    !(pCurHcb->HCS_Tcs[pFirstPend->SCB_Target].TCS_Flags & TCF_BUSY)) {
-				return (pFirstPend);
-			}
+	first = host->first_pending;
+	while (first != NULL) {
+		if (first->opcode != ExecSCSI)
+			return first;
+		if (first->tagmsg == 0) {
+			if ((host->act_tags[first->target] == 0) &&
+			    !(host->targets[first->target].flags & TCF_BUSY))
+				return first;
 		} else {
-			if ((pCurHcb->HCS_ActTags[pFirstPend->SCB_Target] >=
-			  pCurHcb->HCS_MaxTags[pFirstPend->SCB_Target]) |
-			    (pCurHcb->HCS_Tcs[pFirstPend->SCB_Target].TCS_Flags & TCF_BUSY)) {
-				pFirstPend = pFirstPend->SCB_NxtScb;
+			if ((host->act_tags[first->target] >=
+			  host->max_tags[first->target]) |
+			    (host->targets[first->target].flags & TCF_BUSY)) {
+				first = first->next;
 				continue;
 			}
-			return (pFirstPend);
+			return first;
 		}
-		pFirstPend = pFirstPend->SCB_NxtScb;
+		first = first->next;
 	}
-
-
-	return (pFirstPend);
+	return first;
 }
-/***************************************************************************/
-static void tul_unlink_pend_scb(HCS * pCurHcb, SCB * pCurScb)
+
+static void initio_unlink_pend_scb(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
-	SCB *pTmpScb, *pPrevScb;
+	struct scsi_ctrl_blk *tmp, *prev;
 
 #if DEBUG_QUEUE
-	printk("unlink pend SCB %lx; ", (ULONG) pCurScb);
+	printk("unlink pend SCB %p; ", scb);
 #endif
 
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstPend;
-	while (pTmpScb != NULL) {
-		if (pCurScb == pTmpScb) {	/* Unlink this SCB              */
-			if (pTmpScb == pCurHcb->HCS_FirstPend) {
-				if ((pCurHcb->HCS_FirstPend = pTmpScb->SCB_NxtScb) == NULL)
-					pCurHcb->HCS_LastPend = NULL;
+	prev = tmp = host->first_pending;
+	while (tmp != NULL) {
+		if (scb == tmp) {	/* Unlink this SCB              */
+			if (tmp == host->first_pending) {
+				if ((host->first_pending = tmp->next) == NULL)
+					host->last_pending = NULL;
 			} else {
-				pPrevScb->SCB_NxtScb = pTmpScb->SCB_NxtScb;
-				if (pTmpScb == pCurHcb->HCS_LastPend)
-					pCurHcb->HCS_LastPend = pPrevScb;
+				prev->next = tmp->next;
+				if (tmp == host->last_pending)
+					host->last_pending = prev;
 			}
-			pTmpScb->SCB_NxtScb = NULL;
+			tmp->next = NULL;
 			break;
 		}
-		pPrevScb = pTmpScb;
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		prev = tmp;
+		tmp = tmp->next;
 	}
-	return;
 }
-/***************************************************************************/
-static void tul_append_busy_scb(HCS * pCurHcb, SCB * scbp)
+
+static void initio_append_busy_scb(struct initio_host * host, struct scsi_ctrl_blk * scbp)
 {
 
 #if DEBUG_QUEUE
-	printk("append busy SCB %lx; ", (ULONG) scbp);
+	printk("append busy SCB %o; ", scbp);
 #endif
-	if (scbp->SCB_TagMsg)
-		pCurHcb->HCS_ActTags[scbp->SCB_Target]++;
+	if (scbp->tagmsg)
+		host->act_tags[scbp->target]++;
 	else
-		pCurHcb->HCS_Tcs[scbp->SCB_Target].TCS_Flags |= TCF_BUSY;
-	scbp->SCB_Status = SCB_BUSY;
-	scbp->SCB_NxtScb = NULL;
-	if (pCurHcb->HCS_LastBusy != NULL) {
-		pCurHcb->HCS_LastBusy->SCB_NxtScb = scbp;
-		pCurHcb->HCS_LastBusy = scbp;
+		host->targets[scbp->target].flags |= TCF_BUSY;
+	scbp->status = SCB_BUSY;
+	scbp->next = NULL;
+	if (host->last_busy != NULL) {
+		host->last_busy->next = scbp;
+		host->last_busy = scbp;
 	} else {
-		pCurHcb->HCS_FirstBusy = scbp;
-		pCurHcb->HCS_LastBusy = scbp;
+		host->first_busy = scbp;
+		host->last_busy = scbp;
 	}
 }
 
 /***************************************************************************/
-static SCB *tul_pop_busy_scb(HCS * pCurHcb)
+static struct scsi_ctrl_blk *initio_pop_busy_scb(struct initio_host * host)
 {
-	SCB *pTmpScb;
+	struct scsi_ctrl_blk *tmp;
 
 
-	if ((pTmpScb = pCurHcb->HCS_FirstBusy) != NULL) {
-		if ((pCurHcb->HCS_FirstBusy = pTmpScb->SCB_NxtScb) == NULL)
-			pCurHcb->HCS_LastBusy = NULL;
-		pTmpScb->SCB_NxtScb = NULL;
-		if (pTmpScb->SCB_TagMsg)
-			pCurHcb->HCS_ActTags[pTmpScb->SCB_Target]--;
+	if ((tmp = host->first_busy) != NULL) {
+		if ((host->first_busy = tmp->next) == NULL)
+			host->last_busy = NULL;
+		tmp->next = NULL;
+		if (tmp->tagmsg)
+			host->act_tags[tmp->target]--;
 		else
-			pCurHcb->HCS_Tcs[pTmpScb->SCB_Target].TCS_Flags &= ~TCF_BUSY;
+			host->targets[tmp->target].flags &= ~TCF_BUSY;
 	}
 #if DEBUG_QUEUE
-	printk("Pop busy SCB %lx; ", (ULONG) pTmpScb);
+	printk("Pop busy SCB %p; ", tmp);
 #endif
-	return (pTmpScb);
+	return tmp;
 }
 
 /***************************************************************************/
-static void tul_unlink_busy_scb(HCS * pCurHcb, SCB * pCurScb)
+static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
-	SCB *pTmpScb, *pPrevScb;
+	struct scsi_ctrl_blk *tmp, *prev;
 
 #if DEBUG_QUEUE
-	printk("unlink busy SCB %lx; ", (ULONG) pCurScb);
+	printk("unlink busy SCB %p; ", scb);
 #endif
 
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstBusy;
-	while (pTmpScb != NULL) {
-		if (pCurScb == pTmpScb) {	/* Unlink this SCB              */
-			if (pTmpScb == pCurHcb->HCS_FirstBusy) {
-				if ((pCurHcb->HCS_FirstBusy = pTmpScb->SCB_NxtScb) == NULL)
-					pCurHcb->HCS_LastBusy = NULL;
+	prev = tmp = host->first_busy;
+	while (tmp != NULL) {
+		if (scb == tmp) {	/* Unlink this SCB              */
+			if (tmp == host->first_busy) {
+				if ((host->first_busy = tmp->next) == NULL)
+					host->last_busy = NULL;
 			} else {
-				pPrevScb->SCB_NxtScb = pTmpScb->SCB_NxtScb;
-				if (pTmpScb == pCurHcb->HCS_LastBusy)
-					pCurHcb->HCS_LastBusy = pPrevScb;
-			}
-			pTmpScb->SCB_NxtScb = NULL;
-			if (pTmpScb->SCB_TagMsg)
-				pCurHcb->HCS_ActTags[pTmpScb->SCB_Target]--;
+				prev->next = tmp->next;
+				if (tmp == host->last_busy)
+					host->last_busy = prev;
+			}
+			tmp->next = NULL;
+			if (tmp->tagmsg)
+				host->act_tags[tmp->target]--;
 			else
-				pCurHcb->HCS_Tcs[pTmpScb->SCB_Target].TCS_Flags &= ~TCF_BUSY;
+				host->targets[tmp->target].flags &= ~TCF_BUSY;
 			break;
 		}
-		pPrevScb = pTmpScb;
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		prev = tmp;
+		tmp = tmp->next;
 	}
 	return;
 }
 
-/***************************************************************************/
-SCB *tul_find_busy_scb(HCS * pCurHcb, WORD tarlun)
+struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
 {
-	SCB *pTmpScb, *pPrevScb;
-	WORD scbp_tarlun;
+	struct scsi_ctrl_blk *tmp, *prev;
+	u16 scbp_tarlun;
 
 
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstBusy;
-	while (pTmpScb != NULL) {
-		scbp_tarlun = (pTmpScb->SCB_Lun << 8) | (pTmpScb->SCB_Target);
+	prev = tmp = host->first_busy;
+	while (tmp != NULL) {
+		scbp_tarlun = (tmp->lun << 8) | (tmp->target);
 		if (scbp_tarlun == tarlun) {	/* Unlink this SCB              */
 			break;
 		}
-		pPrevScb = pTmpScb;
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		prev = tmp;
+		tmp = tmp->next;
 	}
 #if DEBUG_QUEUE
-	printk("find busy SCB %lx; ", (ULONG) pTmpScb);
+	printk("find busy SCB %p; ", tmp);
 #endif
-	return (pTmpScb);
+	return tmp;
 }
 
-/***************************************************************************/
-static void tul_append_done_scb(HCS * pCurHcb, SCB * scbp)
+static void initio_append_done_scb(struct initio_host * host, struct scsi_ctrl_blk * scbp)
 {
-
 #if DEBUG_QUEUE
-	printk("append done SCB %lx; ", (ULONG) scbp);
+	printk("append done SCB %p; ", scbp);
 #endif
 
-	scbp->SCB_Status = SCB_DONE;
-	scbp->SCB_NxtScb = NULL;
-	if (pCurHcb->HCS_LastDone != NULL) {
-		pCurHcb->HCS_LastDone->SCB_NxtScb = scbp;
-		pCurHcb->HCS_LastDone = scbp;
+	scbp->status = SCB_DONE;
+	scbp->next = NULL;
+	if (host->last_done != NULL) {
+		host->last_done->next = scbp;
+		host->last_done = scbp;
 	} else {
-		pCurHcb->HCS_FirstDone = scbp;
-		pCurHcb->HCS_LastDone = scbp;
+		host->first_done = scbp;
+		host->last_done = scbp;
 	}
 }
 
-/***************************************************************************/
-SCB *tul_find_done_scb(HCS * pCurHcb)
+struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host * host)
 {
-	SCB *pTmpScb;
+	struct scsi_ctrl_blk *tmp;
 
-
-	if ((pTmpScb = pCurHcb->HCS_FirstDone) != NULL) {
-		if ((pCurHcb->HCS_FirstDone = pTmpScb->SCB_NxtScb) == NULL)
-			pCurHcb->HCS_LastDone = NULL;
-		pTmpScb->SCB_NxtScb = NULL;
+	if ((tmp = host->first_done) != NULL) {
+		if ((host->first_done = tmp->next) == NULL)
+			host->last_done = NULL;
+		tmp->next = NULL;
 	}
 #if DEBUG_QUEUE
-	printk("find done SCB %lx; ", (ULONG) pTmpScb);
+	printk("find done SCB %p; ",tmp);
 #endif
-	return (pTmpScb);
+	return tmp;
 }
 
-/***************************************************************************/
-static int tul_abort_srb(HCS * pCurHcb, struct scsi_cmnd *srbp)
+static int initio_abort_srb(struct initio_host * host, struct scsi_cmnd *srbp)
 {
-	ULONG flags;
-	SCB *pTmpScb, *pPrevScb;
+	unsigned long flags;
+	struct scsi_ctrl_blk *tmp, *prev;
 
-	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
+	spin_lock_irqsave(&host->semaph_lock, flags);
 
-	if ((pCurHcb->HCS_Semaph == 0) && (pCurHcb->HCS_ActScb == NULL)) {
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
+	if ((host->semaph == 0) && (host->active == NULL)) {
 		/* disable Jasmin SCSI Int        */
-
-                spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-		tulip_main(pCurHcb);
-
-        	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-		pCurHcb->HCS_Semaph = 1;
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
-
-		spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
+		outb(0x1F, host->addr + TUL_Mask);
+                spin_unlock_irqrestore(&host->semaph_lock, flags);
+                /* FIXME: synchronize_irq needed ? */
+		tulip_main(host);
+        	spin_lock_irqsave(&host->semaph_lock, flags);
+		host->semaph = 1;
+		outb(0x0F, host->addr + TUL_Mask);
+		spin_unlock_irqrestore(&host->semaph_lock, flags);
 		return SCSI_ABORT_SNOOZE;
 	}
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstPend;	/* Check Pend queue */
-	while (pTmpScb != NULL) {
+	prev = tmp = host->first_pending;	/* Check Pend queue */
+	while (tmp != NULL) {
 		/* 07/27/98 */
-		if (pTmpScb->SCB_Srb == srbp) {
-			if (pTmpScb == pCurHcb->HCS_ActScb) {
-				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+		if (tmp->srb == srbp) {
+			if (tmp == host->active) {
+				spin_unlock_irqrestore(&host->semaph_lock, flags);
 				return SCSI_ABORT_BUSY;
-			} else if (pTmpScb == pCurHcb->HCS_FirstPend) {
-				if ((pCurHcb->HCS_FirstPend = pTmpScb->SCB_NxtScb) == NULL)
-					pCurHcb->HCS_LastPend = NULL;
+			} else if (tmp == host->first_pending) {
+				if ((host->first_pending = tmp->next) == NULL)
+					host->last_pending = NULL;
 			} else {
-				pPrevScb->SCB_NxtScb = pTmpScb->SCB_NxtScb;
-				if (pTmpScb == pCurHcb->HCS_LastPend)
-					pCurHcb->HCS_LastPend = pPrevScb;
-			}
-			pTmpScb->SCB_HaStat = HOST_ABORTED;
-			pTmpScb->SCB_Flags |= SCF_DONE;
-			if (pTmpScb->SCB_Flags & SCF_POST)
-				(*pTmpScb->SCB_Post) ((BYTE *) pCurHcb, (BYTE *) pTmpScb);
-			spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+				prev->next = tmp->next;
+				if (tmp == host->last_pending)
+					host->last_pending = prev;
+			}
+			tmp->hastat = HOST_ABORTED;
+			tmp->flags |= SCF_DONE;
+			if (tmp->flags & SCF_POST)
+				(*tmp->post) ((u8 *) host, (u8 *) tmp);
+			spin_unlock_irqrestore(&host->semaph_lock, flags);
 			return SCSI_ABORT_SUCCESS;
 		}
-		pPrevScb = pTmpScb;
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		prev = tmp;
+		tmp = tmp->next;
 	}
 
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstBusy;	/* Check Busy queue */
-	while (pTmpScb != NULL) {
-
-		if (pTmpScb->SCB_Srb == srbp) {
-
-			if (pTmpScb == pCurHcb->HCS_ActScb) {
-				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+	prev = tmp = host->first_busy;	/* Check Busy queue */
+	while (tmp != NULL) {
+		if (tmp->srb == srbp) {
+			if (tmp == host->active) {
+				spin_unlock_irqrestore(&host->semaph_lock, flags);
 				return SCSI_ABORT_BUSY;
-			} else if (pTmpScb->SCB_TagMsg == 0) {
-				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+			} else if (tmp->tagmsg == 0) {
+				spin_unlock_irqrestore(&host->semaph_lock, flags);
 				return SCSI_ABORT_BUSY;
 			} else {
-				pCurHcb->HCS_ActTags[pTmpScb->SCB_Target]--;
-				if (pTmpScb == pCurHcb->HCS_FirstBusy) {
-					if ((pCurHcb->HCS_FirstBusy = pTmpScb->SCB_NxtScb) == NULL)
-						pCurHcb->HCS_LastBusy = NULL;
+				host->act_tags[tmp->target]--;
+				if (tmp == host->first_busy) {
+					if ((host->first_busy = tmp->next) == NULL)
+						host->last_busy = NULL;
 				} else {
-					pPrevScb->SCB_NxtScb = pTmpScb->SCB_NxtScb;
-					if (pTmpScb == pCurHcb->HCS_LastBusy)
-						pCurHcb->HCS_LastBusy = pPrevScb;
+					prev->next = tmp->next;
+					if (tmp == host->last_busy)
+						host->last_busy = prev;
 				}
-				pTmpScb->SCB_NxtScb = NULL;
+				tmp->next = NULL;
 
 
-				pTmpScb->SCB_HaStat = HOST_ABORTED;
-				pTmpScb->SCB_Flags |= SCF_DONE;
-				if (pTmpScb->SCB_Flags & SCF_POST)
-					(*pTmpScb->SCB_Post) ((BYTE *) pCurHcb, (BYTE *) pTmpScb);
-				spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+				tmp->hastat = HOST_ABORTED;
+				tmp->flags |= SCF_DONE;
+				if (tmp->flags & SCF_POST)
+					(*tmp->post) ((u8 *) host, (u8 *) tmp);
+				spin_unlock_irqrestore(&host->semaph_lock, flags);
 				return SCSI_ABORT_SUCCESS;
 			}
 		}
-		pPrevScb = pTmpScb;
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		prev = tmp;
+		tmp = tmp->next;
 	}
-	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-	return (SCSI_ABORT_NOT_RUNNING);
+	spin_unlock_irqrestore(&host->semaph_lock, flags);
+	return SCSI_ABORT_NOT_RUNNING;
 }
 
 /***************************************************************************/
-static int tul_bad_seq(HCS * pCurHcb)
-{
-	SCB *pCurScb;
-
-	printk("tul_bad_seg c=%d\n", pCurHcb->HCS_Index);
-
-	if ((pCurScb = pCurHcb->HCS_ActScb) != NULL) {
-		tul_unlink_busy_scb(pCurHcb, pCurScb);
-		pCurScb->SCB_HaStat = HOST_BAD_PHAS;
-		pCurScb->SCB_TaStat = 0;
-		tul_append_done_scb(pCurHcb, pCurScb);
-	}
-	tul_stop_bm(pCurHcb);
-
-	tul_reset_scsi(pCurHcb, 8);	/* 7/29/98 */
-
-	return (tul_post_scsi_rst(pCurHcb));
-}
-
-#if 0
-
-/************************************************************************/
-static int tul_device_reset(HCS * pCurHcb, struct scsi_cmnd *pSrb,
-			    unsigned int target, unsigned int ResetFlags)
+static int initio_bad_seq(struct initio_host * host)
 {
-	ULONG flags;
-	SCB *pScb;
-	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-	if (ResetFlags & SCSI_RESET_ASYNCHRONOUS) {
-
-		if ((pCurHcb->HCS_Semaph == 0) && (pCurHcb->HCS_ActScb == NULL)) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
-			/* disable Jasmin SCSI Int        */
-
-        		spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-			tulip_main(pCurHcb);
-
-        		spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-			pCurHcb->HCS_Semaph = 1;
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
+	struct scsi_ctrl_blk *scb;
 
-			spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+	printk("initio_bad_seg c=%d\n", host->index);
 
-			return SCSI_RESET_SNOOZE;
-		}
-		pScb = pCurHcb->HCS_FirstBusy;	/* Check Busy queue */
-		while (pScb != NULL) {
-			if (pScb->SCB_Srb == pSrb)
-				break;
-			pScb = pScb->SCB_NxtScb;
-		}
-		if (pScb == NULL) {
-			printk("Unable to Reset - No SCB Found\n");
-
-			spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-			return SCSI_RESET_NOT_RUNNING;
-		}
-	}
-	if ((pScb = tul_alloc_scb(pCurHcb)) == NULL) {
-		spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-		return SCSI_RESET_NOT_RUNNING;
-	}
-	pScb->SCB_Opcode = BusDevRst;
-	pScb->SCB_Flags = SCF_POST;
-	pScb->SCB_Target = target;
-	pScb->SCB_Mode = 0;
-
-	pScb->SCB_Srb = NULL;
-	if (ResetFlags & SCSI_RESET_SYNCHRONOUS) {
-		pScb->SCB_Srb = pSrb;
-	}
-	tul_push_pend_scb(pCurHcb, pScb);	/* push this SCB to Pending queue */
-
-	if (pCurHcb->HCS_Semaph == 1) {
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
-		/* disable Jasmin SCSI Int        */
-		pCurHcb->HCS_Semaph = 0;
-
-        	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-		tulip_main(pCurHcb);
-
-                spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-		pCurHcb->HCS_Semaph = 1;
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
+	if ((scb = host->active) != NULL) {
+		initio_unlink_busy_scb(host, scb);
+		scb->hastat = HOST_BAD_PHAS;
+		scb->tastat = 0;
+		initio_append_done_scb(host, scb);
 	}
-	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-	return SCSI_RESET_PENDING;
+	initio_stop_bm(host);
+	initio_reset_scsi(host, 8);	/* 7/29/98 */
+	return initio_post_scsi_rst(host);
 }
 
-static int tul_reset_scsi_bus(HCS * pCurHcb)
-{
-	ULONG flags;
-
-	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-	TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
-	pCurHcb->HCS_Semaph = 0;
-
-	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-	tul_stop_bm(pCurHcb);
-
-	tul_reset_scsi(pCurHcb, 2);	/* 7/29/98 */
-
-	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-	tul_post_scsi_rst(pCurHcb);
-
-        spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-	tulip_main(pCurHcb);
-
-        spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-	pCurHcb->HCS_Semaph = 1;
-	TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
-	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-	return (SCSI_RESET_SUCCESS | SCSI_RESET_HOST_RESET);
-}
-
-#endif  /*  0  */
 
 /************************************************************************/
-static void tul_exec_scb(HCS * pCurHcb, SCB * pCurScb)
+static void initio_exec_scb(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
-	ULONG flags;
+	unsigned long flags;
 
-	pCurScb->SCB_Mode = 0;
+	scb->mode = 0;
 
-	pCurScb->SCB_SGIdx = 0;
-	pCurScb->SCB_SGMax = pCurScb->SCB_SGLen;
+	scb->sgidx = 0;
+	scb->sgmax = scb->sglen;
 
-	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
+	spin_lock_irqsave(&host->semaph_lock, flags);
 
-	tul_append_pend_scb(pCurHcb, pCurScb);	/* Append this SCB to Pending queue */
+	initio_append_pend_scb(host, scb);	/* Append this SCB to Pending queue */
 
 /* VVVVV 07/21/98 */
-	if (pCurHcb->HCS_Semaph == 1) {
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
-		/* disable Jasmin SCSI Int        */
-		pCurHcb->HCS_Semaph = 0;
-
-        	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-
-		tulip_main(pCurHcb);
-
-        	spin_lock_irqsave(&(pCurHcb->HCS_SemaphLock), flags);
-
-		pCurHcb->HCS_Semaph = 1;
-		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
+	if (host->semaph == 1) {
+		/* Disable Jasmin SCSI Int */
+		outb(0x1F, host->addr + TUL_Mask);
+		host->semaph = 0;
+        	spin_unlock_irqrestore(&host->semaph_lock, flags);
+
+		tulip_main(host);
+
+        	spin_lock_irqsave(&host->semaph_lock, flags);
+		host->semaph = 1;
+		outb(0x0F, host->addr + TUL_Mask);
 	}
-	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
+	spin_unlock_irqrestore(&host->semaph_lock, flags);
 	return;
 }
 
 /***************************************************************************/
-static int tul_isr(HCS * pCurHcb)
+static int initio_isr(struct initio_host * host)
 {
-	/* Enter critical section       */
-
-	if (TUL_RD(pCurHcb->HCS_Base, TUL_Int) & TSS_INT_PENDING) {
-		if (pCurHcb->HCS_Semaph == 1) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x1F);
+	if (inb(host->addr + TUL_Int) & TSS_INT_PENDING) {
+		if (host->semaph == 1) {
+			outb(0x1F, host->addr + TUL_Mask);
 			/* Disable Tulip SCSI Int */
-			pCurHcb->HCS_Semaph = 0;
+			host->semaph = 0;
 
-			tulip_main(pCurHcb);
+			tulip_main(host);
 
-			pCurHcb->HCS_Semaph = 1;
-			TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
-			return (1);
+			host->semaph = 1;
+			outb(0x0F, host->addr + TUL_Mask);
+			return 1;
 		}
 	}
-	return (0);
+	return 0;
 }
 
-/***************************************************************************/
-int tulip_main(HCS * pCurHcb)
+static int tulip_main(struct initio_host * host)
 {
-	SCB *pCurScb;
+	struct scsi_ctrl_blk *scb;
 
 	for (;;) {
+		tulip_scsi(host);	/* Call tulip_scsi              */
 
-		tulip_scsi(pCurHcb);	/* Call tulip_scsi              */
-
-		while ((pCurScb = tul_find_done_scb(pCurHcb)) != NULL) {	/* find done entry */
-			if (pCurScb->SCB_TaStat == INI_QUEUE_FULL) {
-				pCurHcb->HCS_MaxTags[pCurScb->SCB_Target] =
-				    pCurHcb->HCS_ActTags[pCurScb->SCB_Target] - 1;
-				pCurScb->SCB_TaStat = 0;
-				tul_append_pend_scb(pCurHcb, pCurScb);
+		/* Walk the list of completed SCBs */
+		while ((scb = initio_find_done_scb(host)) != NULL) {	/* find done entry */
+			if (scb->tastat == INI_QUEUE_FULL) {
+				host->max_tags[scb->target] =
+				    host->act_tags[scb->target] - 1;
+				scb->tastat = 0;
+				initio_append_pend_scb(host, scb);
 				continue;
 			}
-			if (!(pCurScb->SCB_Mode & SCM_RSENS)) {		/* not in auto req. sense mode */
-				if (pCurScb->SCB_TaStat == 2) {
+			if (!(scb->mode & SCM_RSENS)) {		/* not in auto req. sense mode */
+				if (scb->tastat == 2) {
 
 					/* clr sync. nego flag */
 
-					if (pCurScb->SCB_Flags & SCF_SENSE) {
-						BYTE len;
-						len = pCurScb->SCB_SenseLen;
+					if (scb->flags & SCF_SENSE) {
+						u8 len;
+						len = scb->senselen;
 						if (len == 0)
 							len = 1;
-						pCurScb->SCB_BufLen = pCurScb->SCB_SenseLen;
-						pCurScb->SCB_BufPtr = pCurScb->SCB_SensePtr;
-						pCurScb->SCB_Flags &= ~(SCF_SG | SCF_DIR);	/* for xfer_data_in */
-/*                      pCurScb->SCB_Flags |= SCF_NO_DCHK;      */
-						/* so, we won't report worng direction in xfer_data_in,
+						scb->buflen = scb->senselen;
+						scb->bufptr = scb->senseptr;
+						scb->flags &= ~(SCF_SG | SCF_DIR);	/* for xfer_data_in */
+						/* so, we won't report wrong direction in xfer_data_in,
 						   and won't report HOST_DO_DU in state_6 */
-						pCurScb->SCB_Mode = SCM_RSENS;
-						pCurScb->SCB_Ident &= 0xBF;	/* Disable Disconnect */
-						pCurScb->SCB_TagMsg = 0;
-						pCurScb->SCB_TaStat = 0;
-						pCurScb->SCB_CDBLen = 6;
-						pCurScb->SCB_CDB[0] = SCSICMD_RequestSense;
-						pCurScb->SCB_CDB[1] = 0;
-						pCurScb->SCB_CDB[2] = 0;
-						pCurScb->SCB_CDB[3] = 0;
-						pCurScb->SCB_CDB[4] = len;
-						pCurScb->SCB_CDB[5] = 0;
-						tul_push_pend_scb(pCurHcb, pCurScb);
+						scb->mode = SCM_RSENS;
+						scb->ident &= 0xBF;	/* Disable Disconnect */
+						scb->tagmsg = 0;
+						scb->tastat = 0;
+						scb->cdblen = 6;
+						scb->cdb[0] = SCSICMD_RequestSense;
+						scb->cdb[1] = 0;
+						scb->cdb[2] = 0;
+						scb->cdb[3] = 0;
+						scb->cdb[4] = len;
+						scb->cdb[5] = 0;
+						initio_push_pend_scb(host, scb);
 						break;
 					}
 				}
 			} else {	/* in request sense mode */
 
-				if (pCurScb->SCB_TaStat == 2) {		/* check contition status again after sending
+				if (scb->tastat == 2) {		/* check contition status again after sending
 									   requset sense cmd 0x3 */
-					pCurScb->SCB_HaStat = HOST_BAD_PHAS;
+					scb->hastat = HOST_BAD_PHAS;
 				}
-				pCurScb->SCB_TaStat = 2;
+				scb->tastat = 2;
 			}
-			pCurScb->SCB_Flags |= SCF_DONE;
-			if (pCurScb->SCB_Flags & SCF_POST) {
-				(*pCurScb->SCB_Post) ((BYTE *) pCurHcb, (BYTE *) pCurScb);
+			scb->flags |= SCF_DONE;
+			if (scb->flags & SCF_POST) {
+				/* FIXME: only one post method and lose casts */
+				(*scb->post) ((u8 *) host, (u8 *) scb);
 			}
 		}		/* while */
-
 		/* find_active: */
-		if (TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0) & TSS_INT_PENDING)
+		if (inb(host->addr + TUL_SStatus0) & TSS_INT_PENDING)
 			continue;
-
-		if (pCurHcb->HCS_ActScb) {	/* return to OS and wait for xfer_done_ISR/Selected_ISR */
+		if (host->active)	/* return to OS and wait for xfer_done_ISR/Selected_ISR */
 			return 1;	/* return to OS, enable interrupt */
-		}
 		/* Check pending SCB            */
-		if (tul_find_first_pend_scb(pCurHcb) == NULL) {
+		if (initio_find_first_pend_scb(host) == NULL)
 			return 1;	/* return to OS, enable interrupt */
-		}
 	}			/* End of for loop */
 	/* statement won't reach here */
 }
 
-
-
-
-/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-/***************************************************************************/
-/***************************************************************************/
-/***************************************************************************/
-/***************************************************************************/
-
-/***************************************************************************/
-void tulip_scsi(HCS * pCurHcb)
+static void tulip_scsi(struct initio_host * host)
 {
-	SCB *pCurScb;
-	TCS *pCurTcb;
+	struct scsi_ctrl_blk *scb;
+	struct target_control *active_tc;
 
 	/* make sure to service interrupt asap */
-
-	if ((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0)) & TSS_INT_PENDING) {
-
-		pCurHcb->HCS_Phase = pCurHcb->HCS_JSStatus0 & TSS_PH_MASK;
-		pCurHcb->HCS_JSStatus1 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus1);
-		pCurHcb->HCS_JSInt = TUL_RD(pCurHcb->HCS_Base, TUL_SInt);
-		if (pCurHcb->HCS_JSInt & TSS_SCSIRST_INT) {	/* SCSI bus reset detected      */
-			int_tul_scsi_rst(pCurHcb);
+	if ((host->jsstatus0 = inb(host->addr + TUL_SStatus0)) & TSS_INT_PENDING) {
+		host->phase = host->jsstatus0 & TSS_PH_MASK;
+		host->jsstatus1 = inb(host->addr + TUL_SStatus1);
+		host->jsint = inb(host->addr + TUL_SInt);
+		if (host->jsint & TSS_SCSIRST_INT) {	/* SCSI bus reset detected      */
+			int_initio_scsi_rst(host);
 			return;
 		}
-		if (pCurHcb->HCS_JSInt & TSS_RESEL_INT) {	/* if selected/reselected interrupt */
-			if (int_tul_resel(pCurHcb) == 0)
-				tul_next_state(pCurHcb);
+		if (host->jsint & TSS_RESEL_INT) {	/* if selected/reselected interrupt */
+			if (int_initio_resel(host) == 0)
+				initio_next_state(host);
 			return;
 		}
-		if (pCurHcb->HCS_JSInt & TSS_SEL_TIMEOUT) {
-			int_tul_busfree(pCurHcb);
+		if (host->jsint & TSS_SEL_TIMEOUT) {
+			int_initio_busfree(host);
 			return;
 		}
-		if (pCurHcb->HCS_JSInt & TSS_DISC_INT) {	/* BUS disconnection            */
-			int_tul_busfree(pCurHcb);	/* unexpected bus free or sel timeout */
+		if (host->jsint & TSS_DISC_INT) {	/* BUS disconnection            */
+			int_initio_busfree(host);	/* unexpected bus free or sel timeout */
 			return;
 		}
-		if (pCurHcb->HCS_JSInt & (TSS_FUNC_COMP | TSS_BUS_SERV)) {	/* func complete or Bus service */
-			if ((pCurScb = pCurHcb->HCS_ActScb) != NULL)
-				tul_next_state(pCurHcb);
+		if (host->jsint & (TSS_FUNC_COMP | TSS_BUS_SERV)) {	/* func complete or Bus service */
+			if ((scb = host->active) != NULL)
+				initio_next_state(host);
 			return;
 		}
 	}
-	if (pCurHcb->HCS_ActScb != NULL)
+	if (host->active != NULL)
 		return;
 
-	if ((pCurScb = tul_find_first_pend_scb(pCurHcb)) == NULL)
+	if ((scb = initio_find_first_pend_scb(host)) == NULL)
 		return;
 
 	/* program HBA's SCSI ID & target SCSI ID */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SScsiId,
-	     (pCurHcb->HCS_SCSI_ID << 4) | (pCurScb->SCB_Target & 0x0F));
-	if (pCurScb->SCB_Opcode == ExecSCSI) {
-		pCurTcb = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
+	outb((host->scsi_id << 4) | (scb->target & 0x0F), 
+		host->addr + TUL_SScsiId);
+	if (scb->opcode == ExecSCSI) {
+		active_tc = &host->targets[scb->target];
 
-		if (pCurScb->SCB_TagMsg)
-			pCurTcb->TCS_DrvFlags |= TCF_DRV_EN_TAG;
+		if (scb->tagmsg)
+			active_tc->drv_flags |= TCF_DRV_EN_TAG;
 		else
-			pCurTcb->TCS_DrvFlags &= ~TCF_DRV_EN_TAG;
+			active_tc->drv_flags &= ~TCF_DRV_EN_TAG;
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SPeriod, pCurTcb->TCS_JS_Period);
-		if ((pCurTcb->TCS_Flags & (TCF_WDTR_DONE | TCF_NO_WDTR)) == 0) {	/* do wdtr negotiation          */
-			tul_select_atn_stop(pCurHcb, pCurScb);
+		outb(active_tc->js_period, host->addr + TUL_SPeriod);
+		if ((active_tc->flags & (TCF_WDTR_DONE | TCF_NO_WDTR)) == 0) {	/* do wdtr negotiation          */
+			initio_select_atn_stop(host, scb);
 		} else {
-			if ((pCurTcb->TCS_Flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {	/* do sync negotiation          */
-				tul_select_atn_stop(pCurHcb, pCurScb);
+			if ((active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {	/* do sync negotiation          */
+				initio_select_atn_stop(host, scb);
 			} else {
-				if (pCurScb->SCB_TagMsg)
-					tul_select_atn3(pCurHcb, pCurScb);
+				if (scb->tagmsg)
+					initio_select_atn3(host, scb);
 				else
-					tul_select_atn(pCurHcb, pCurScb);
+					initio_select_atn(host, scb);
 			}
 		}
-		if (pCurScb->SCB_Flags & SCF_POLL) {
-			while (wait_tulip(pCurHcb) != -1) {
-				if (tul_next_state(pCurHcb) == -1)
+		if (scb->flags & SCF_POLL) {
+			while (wait_tulip(host) != -1) {
+				if (initio_next_state(host) == -1)
 					break;
 			}
 		}
-	} else if (pCurScb->SCB_Opcode == BusDevRst) {
-		tul_select_atn_stop(pCurHcb, pCurScb);
-		pCurScb->SCB_NxtStat = 8;
-		if (pCurScb->SCB_Flags & SCF_POLL) {
-			while (wait_tulip(pCurHcb) != -1) {
-				if (tul_next_state(pCurHcb) == -1)
+	} else if (scb->opcode == BusDevRst) {
+		initio_select_atn_stop(host, scb);
+		scb->next_state = 8;
+		if (scb->flags & SCF_POLL) {
+			while (wait_tulip(host) != -1) {
+				if (initio_next_state(host) == -1)
 					break;
 			}
 		}
-	} else if (pCurScb->SCB_Opcode == AbortCmd) {
-		if (tul_abort_srb(pCurHcb, pCurScb->SCB_Srb) != 0) {
-
-
-			tul_unlink_pend_scb(pCurHcb, pCurScb);
-
-			tul_release_scb(pCurHcb, pCurScb);
+	} else if (scb->opcode == AbortCmd) {
+		if (initio_abort_srb(host, scb->srb) != 0) {
+			initio_unlink_pend_scb(host, scb);
+			initio_release_scb(host, scb);
 		} else {
-			pCurScb->SCB_Opcode = BusDevRst;
-			tul_select_atn_stop(pCurHcb, pCurScb);
-			pCurScb->SCB_NxtStat = 8;
+			scb->opcode = BusDevRst;
+			initio_select_atn_stop(host, scb);
+			scb->next_state = 8;
 		}
-
-/* 08/03/98 */
 	} else {
-		tul_unlink_pend_scb(pCurHcb, pCurScb);
-		pCurScb->SCB_HaStat = 0x16;	/* bad command */
-		tul_append_done_scb(pCurHcb, pCurScb);
+		initio_unlink_pend_scb(host, scb);
+		scb->hastat = 0x16;	/* bad command */
+		initio_append_done_scb(host, scb);
 	}
 	return;
 }
 
+/**
+ *	initio_next_state		-	Next SCSI state
+ *	@host: InitIO host we are processing
+ *
+ *	Progress the active command block along the state machine
+ *	until we hit a state which we must wait for activity to occur.
+ *
+ *	Returns zero or a negative code.
+ */
 
-/***************************************************************************/
-int tul_next_state(HCS * pCurHcb)
+static int initio_next_state(struct initio_host * host)
 {
 	int next;
 
-	next = pCurHcb->HCS_ActScb->SCB_NxtStat;
+	next = host->active->next_state;
 	for (;;) {
 		switch (next) {
 		case 1:
-			next = tul_state_1(pCurHcb);
+			next = initio_state_1(host);
 			break;
 		case 2:
-			next = tul_state_2(pCurHcb);
+			next = initio_state_2(host);
 			break;
 		case 3:
-			next = tul_state_3(pCurHcb);
+			next = initio_state_3(host);
 			break;
 		case 4:
-			next = tul_state_4(pCurHcb);
+			next = initio_state_4(host);
 			break;
 		case 5:
-			next = tul_state_5(pCurHcb);
+			next = initio_state_5(host);
 			break;
 		case 6:
-			next = tul_state_6(pCurHcb);
+			next = initio_state_6(host);
 			break;
 		case 7:
-			next = tul_state_7(pCurHcb);
+			next = initio_state_7(host);
 			break;
 		case 8:
-			return (tul_bus_device_reset(pCurHcb));
+			return initio_bus_device_reset(host);
 		default:
-			return (tul_bad_seq(pCurHcb));
+			return initio_bad_seq(host);
 		}
 		if (next <= 0)
 			return next;
@@ -1554,338 +1321,363 @@
 }
 
 
-/***************************************************************************/
-/* sTate after selection with attention & stop */
-int tul_state_1(HCS * pCurHcb)
+/**
+ *	initio_state_1		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ *	Perform SCSI state processing for Select/Attention/Stop
+ */
+
+static int initio_state_1(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
 #if DEBUG_STATE
 	printk("-s1-");
 #endif
 
-	tul_unlink_pend_scb(pCurHcb, pCurScb);
-	tul_append_busy_scb(pCurHcb, pCurScb);
+	/* Move the SCB from pending to busy */
+	initio_unlink_pend_scb(host, scb);
+	initio_append_busy_scb(host, scb);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurTcb->TCS_SConfig0);
+	outb(active_tc->sconfig0, host->addr + TUL_SConfig );
 	/* ATN on */
-	if (pCurHcb->HCS_Phase == MSG_OUT) {
-
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, (TSC_EN_BUS_IN | TSC_HW_RESELECT));
-
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_Ident);
-
-		if (pCurScb->SCB_TagMsg) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_TagMsg);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_TagId);
-		}
-		if ((pCurTcb->TCS_Flags & (TCF_WDTR_DONE | TCF_NO_WDTR)) == 0) {
-
-			pCurTcb->TCS_Flags |= TCF_WDTR_DONE;
-
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_EXTEND);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 2);	/* Extended msg length */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 3);	/* Sync request */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 1);	/* Start from 16 bits */
-		} else if ((pCurTcb->TCS_Flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {
-
-			pCurTcb->TCS_Flags |= TCF_SYNC_DONE;
-
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_EXTEND);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 3);	/* extended msg length */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 1);	/* sync request */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, tul_rate_tbl[pCurTcb->TCS_Flags & TCF_SCSI_RATE]);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MAX_OFFSET);	/* REQ/ACK offset */
-		}
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-		if (wait_tulip(pCurHcb) == -1)
-			return (-1);
-	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, (TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)));
-	return (3);
+	if (host->phase == MSG_OUT) {
+		outb(TSC_EN_BUS_IN | TSC_HW_RESELECT, host->addr + TUL_SCtrl1);
+		outb(scb->ident, host->addr + TUL_SFifo);
+
+		if (scb->tagmsg) {
+			outb(scb->tagmsg, host->addr + TUL_SFifo);
+			outb(scb->tagid, host->addr + TUL_SFifo);
+		}
+		if ((active_tc->flags & (TCF_WDTR_DONE | TCF_NO_WDTR)) == 0) {
+			active_tc->flags |= TCF_WDTR_DONE;
+			outb(MSG_EXTEND, host->addr + TUL_SFifo);
+			outb(2, host->addr + TUL_SFifo);	/* Extended msg length */
+			outb(3, host->addr + TUL_SFifo);	/* Sync request */
+			outb(1, host->addr + TUL_SFifo);	/* Start from 16 bits */
+		} else if ((active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {
+			active_tc->flags |= TCF_SYNC_DONE;
+			outb(MSG_EXTEND, host->addr + TUL_SFifo);
+			outb(3, host->addr + TUL_SFifo);	/* extended msg length */
+			outb(1, host->addr + TUL_SFifo);	/* sync request */
+			outb(initio_rate_tbl[active_tc->flags & TCF_SCSI_RATE], host->addr + TUL_SFifo);
+			outb(MAX_OFFSET, host->addr + TUL_SFifo);	/* REQ/ACK offset */
+		}
+		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
+	}
+	outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+	outb((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)), host->addr + TUL_SSignal);
+	/* Into before CDB xfer */
+	return 3;
 }
 
 
-/***************************************************************************/
-/* state after selection with attention */
-/* state after selection with attention3 */
-int tul_state_2(HCS * pCurHcb)
+/**
+ *	initio_state_2		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ * state after selection with attention
+ * state after selection with attention3
+ */
+
+static int initio_state_2(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
 #if DEBUG_STATE
 	printk("-s2-");
 #endif
 
-	tul_unlink_pend_scb(pCurHcb, pCurScb);
-	tul_append_busy_scb(pCurHcb, pCurScb);
+	initio_unlink_pend_scb(host, scb);
+	initio_append_busy_scb(host, scb);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurTcb->TCS_SConfig0);
+	outb(active_tc->sconfig0, host->addr + TUL_SConfig);
 
-	if (pCurHcb->HCS_JSStatus1 & TSS_CMD_PH_CMP) {
-		return (4);
-	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, (TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)));
-	return (3);
+	if (host->jsstatus1 & TSS_CMD_PH_CMP)
+		return 4;
+
+	outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+	outb((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)), host->addr + TUL_SSignal);
+	/* Into before CDB xfer */
+	return 3;
 }
 
-/***************************************************************************/
-/* state before CDB xfer is done */
-int tul_state_3(HCS * pCurHcb)
+/**
+ *	initio_state_3		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ * state before CDB xfer is done
+ */
+
+static int initio_state_3(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
 	int i;
 
 #if DEBUG_STATE
 	printk("-s3-");
 #endif
 	for (;;) {
-		switch (pCurHcb->HCS_Phase) {
+		switch (host->phase) {
 		case CMD_OUT:	/* Command out phase            */
-			for (i = 0; i < (int) pCurScb->SCB_CDBLen; i++)
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_CDB[i]);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-			if (wait_tulip(pCurHcb) == -1)
-				return (-1);
-			if (pCurHcb->HCS_Phase == CMD_OUT) {
-				return (tul_bad_seq(pCurHcb));
-			}
-			return (4);
+			for (i = 0; i < (int) scb->cdblen; i++)
+				outb(scb->cdb[i], host->addr + TUL_SFifo);
+			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+			if (wait_tulip(host) == -1)
+				return -1;
+			if (host->phase == CMD_OUT)
+				return initio_bad_seq(host);
+			return 4;
 
 		case MSG_IN:	/* Message in phase             */
-			pCurScb->SCB_NxtStat = 3;
-			if (tul_msgin(pCurHcb) == -1)
-				return (-1);
+			scb->next_state = 3;
+			if (initio_msgin(host) == -1)
+				return -1;
 			break;
 
 		case STATUS_IN:	/* Status phase                 */
-			if (tul_status_msg(pCurHcb) == -1)
-				return (-1);
+			if (initio_status_msg(host) == -1)
+				return -1;
 			break;
 
 		case MSG_OUT:	/* Message out phase            */
-			if (pCurTcb->TCS_Flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) {
-
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_NOP);		/* msg nop */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-				if (wait_tulip(pCurHcb) == -1)
-					return (-1);
-
+			if (active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) {
+				outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+				if (wait_tulip(host) == -1)
+					return -1;
 			} else {
-				pCurTcb->TCS_Flags |= TCF_SYNC_DONE;
+				active_tc->flags |= TCF_SYNC_DONE;
 
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_EXTEND);
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 3);	/* ext. msg len */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 1);	/* sync request */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, tul_rate_tbl[pCurTcb->TCS_Flags & TCF_SCSI_RATE]);
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MAX_OFFSET);	/* REQ/ACK offset */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-				if (wait_tulip(pCurHcb) == -1)
-					return (-1);
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-				TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7));
+				outb(MSG_EXTEND, host->addr + TUL_SFifo);
+				outb(3, host->addr + TUL_SFifo);	/* ext. msg len */
+				outb(1, host->addr + TUL_SFifo);	/* sync request */
+				outb(initio_rate_tbl[active_tc->flags & TCF_SCSI_RATE], host->addr + TUL_SFifo);
+				outb(MAX_OFFSET, host->addr + TUL_SFifo);	/* REQ/ACK offset */
+				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+				if (wait_tulip(host) == -1)
+					return -1;
+				outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+				outb(inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7), host->addr + TUL_SSignal);
 
 			}
 			break;
-
 		default:
-			return (tul_bad_seq(pCurHcb));
+			return initio_bad_seq(host);
 		}
 	}
 }
 
+/**
+ *	initio_state_4		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ *	SCSI state machine. State 4
+ */
 
-/***************************************************************************/
-int tul_state_4(HCS * pCurHcb)
+static int initio_state_4(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 
 #if DEBUG_STATE
 	printk("-s4-");
 #endif
-	if ((pCurScb->SCB_Flags & SCF_DIR) == SCF_NO_XF) {
-		return (6);	/* Go to state 6                */
+	if ((scb->flags & SCF_DIR) == SCF_NO_XF) {
+		return 6;	/* Go to state 6 (After data) */
 	}
 	for (;;) {
-		if (pCurScb->SCB_BufLen == 0)
-			return (6);	/* Go to state 6                */
+		if (scb->buflen == 0)
+			return 6;
 
-		switch (pCurHcb->HCS_Phase) {
+		switch (host->phase) {
 
 		case STATUS_IN:	/* Status phase                 */
-			if ((pCurScb->SCB_Flags & SCF_DIR) != 0) {	/* if direction bit set then report data underrun */
-				pCurScb->SCB_HaStat = HOST_DO_DU;
-			}
-			if ((tul_status_msg(pCurHcb)) == -1)
-				return (-1);
+			if ((scb->flags & SCF_DIR) != 0)	/* if direction bit set then report data underrun */
+				scb->hastat = HOST_DO_DU;
+			if ((initio_status_msg(host)) == -1)
+				return -1;
 			break;
 
 		case MSG_IN:	/* Message in phase             */
-			pCurScb->SCB_NxtStat = 0x4;
-			if (tul_msgin(pCurHcb) == -1)
-				return (-1);
+			scb->next_state = 0x4;
+			if (initio_msgin(host) == -1)
+				return -1;
 			break;
 
 		case MSG_OUT:	/* Message out phase            */
-			if (pCurHcb->HCS_JSStatus0 & TSS_PAR_ERROR) {
-				pCurScb->SCB_BufLen = 0;
-				pCurScb->SCB_HaStat = HOST_DO_DU;
-				if (tul_msgout_ide(pCurHcb) == -1)
-					return (-1);
-				return (6);	/* Go to state 6                */
+			if (host->jsstatus0 & TSS_PAR_ERROR) {
+				scb->buflen = 0;
+				scb->hastat = HOST_DO_DU;
+				if (initio_msgout_ide(host) == -1)
+					return -1;
+				return 6;
 			} else {
-				TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_NOP);		/* msg nop */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-				if (wait_tulip(pCurHcb) == -1)
-					return (-1);
+				outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+				outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+				if (wait_tulip(host) == -1)
+					return -1;
 			}
 			break;
 
 		case DATA_IN:	/* Data in phase                */
-			return (tul_xfer_data_in(pCurHcb));
+			return initio_xfer_data_in(host);
 
 		case DATA_OUT:	/* Data out phase               */
-			return (tul_xfer_data_out(pCurHcb));
+			return initio_xfer_data_out(host);
 
 		default:
-			return (tul_bad_seq(pCurHcb));
+			return initio_bad_seq(host);
 		}
 	}
 }
 
 
-/***************************************************************************/
-/* state after dma xfer done or phase change before xfer done */
-int tul_state_5(HCS * pCurHcb)
+/**
+ *	initio_state_5		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ *	State after dma xfer done or phase change before xfer done
+ */
+
+static int initio_state_5(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 	long cnt, xcnt;		/* cannot use unsigned !! code: if (xcnt < 0) */
 
 #if DEBUG_STATE
 	printk("-s5-");
 #endif
-/*------ get remaining count -------*/
+	/*------ get remaining count -------*/
+	cnt = inl(host->addr + TUL_SCnt0) & 0x0FFFFFF;
 
-	cnt = TUL_RDLONG(pCurHcb->HCS_Base, TUL_SCnt0) & 0x0FFFFFF;
-
-	if (TUL_RD(pCurHcb->HCS_Base, TUL_XCmd) & 0x20) {
+	if (inb(host->addr + TUL_XCmd) & 0x20) {
 		/* ----------------------- DATA_IN ----------------------------- */
 		/* check scsi parity error */
-		if (pCurHcb->HCS_JSStatus0 & TSS_PAR_ERROR) {
-			pCurScb->SCB_HaStat = HOST_DO_DU;
-		}
-		if (TUL_RD(pCurHcb->HCS_Base, TUL_XStatus) & XPEND) {	/* DMA xfer pending, Send STOP  */
+		if (host->jsstatus0 & TSS_PAR_ERROR)
+			scb->hastat = HOST_DO_DU;
+		if (inb(host->addr + TUL_XStatus) & XPEND) {	/* DMA xfer pending, Send STOP  */
 			/* tell Hardware  scsi xfer has been terminated */
-			TUL_WR(pCurHcb->HCS_Base + TUL_XCtrl, TUL_RD(pCurHcb->HCS_Base, TUL_XCtrl) | 0x80);
+			outb(inb(host->addr + TUL_XCtrl) | 0x80, host->addr + TUL_XCtrl);
 			/* wait until DMA xfer not pending */
-			while (TUL_RD(pCurHcb->HCS_Base, TUL_XStatus) & XPEND);
+			while (inb(host->addr + TUL_XStatus) & XPEND)
+				cpu_relax();
 		}
 	} else {
-/*-------- DATA OUT -----------*/
-		if ((TUL_RD(pCurHcb->HCS_Base, TUL_SStatus1) & TSS_XFER_CMP) == 0) {
-			if (pCurHcb->HCS_ActTcs->TCS_JS_Period & TSC_WIDE_SCSI)
-				cnt += (TUL_RD(pCurHcb->HCS_Base, TUL_SFifoCnt) & 0x1F) << 1;
+		/*-------- DATA OUT -----------*/
+		if ((inb(host->addr + TUL_SStatus1) & TSS_XFER_CMP) == 0) {
+			if (host->active_tc->js_period & TSC_WIDE_SCSI)
+				cnt += (inb(host->addr + TUL_SFifoCnt) & 0x1F) << 1;
 			else
-				cnt += (TUL_RD(pCurHcb->HCS_Base, TUL_SFifoCnt) & 0x1F);
+				cnt += (inb(host->addr + TUL_SFifoCnt) & 0x1F);
 		}
-		if (TUL_RD(pCurHcb->HCS_Base, TUL_XStatus) & XPEND) {	/* if DMA xfer is pending, abort DMA xfer */
-			TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_X_ABT);
+		if (inb(host->addr + TUL_XStatus) & XPEND) {	/* if DMA xfer is pending, abort DMA xfer */
+			outb(TAX_X_ABT, host->addr + TUL_XCmd);
 			/* wait Abort DMA xfer done */
-			while ((TUL_RD(pCurHcb->HCS_Base, TUL_Int) & XABT) == 0);
+			while ((inb(host->addr + TUL_Int) & XABT) == 0)
+				cpu_relax();
 		}
-		if ((cnt == 1) && (pCurHcb->HCS_Phase == DATA_OUT)) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-			if (wait_tulip(pCurHcb) == -1) {
-				return (-1);
-			}
+		if ((cnt == 1) && (host->phase == DATA_OUT)) {
+			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+			if (wait_tulip(host) == -1)
+				return -1;
 			cnt = 0;
 		} else {
-			if ((TUL_RD(pCurHcb->HCS_Base, TUL_SStatus1) & TSS_XFER_CMP) == 0)
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
+			if ((inb(host->addr + TUL_SStatus1) & TSS_XFER_CMP) == 0)
+				outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 		}
 	}
-
 	if (cnt == 0) {
-		pCurScb->SCB_BufLen = 0;
-		return (6);	/* Go to state 6                */
+		scb->buflen = 0;
+		return 6;	/* After Data */
 	}
 	/* Update active data pointer */
-	xcnt = (long) pCurScb->SCB_BufLen - cnt;	/* xcnt== bytes already xferred */
-	pCurScb->SCB_BufLen = (U32) cnt;	/* cnt == bytes left to be xferred */
-	if (pCurScb->SCB_Flags & SCF_SG) {
-		register SG *sgp;
-		ULONG i;
-
-		sgp = &pCurScb->SCB_SGList[pCurScb->SCB_SGIdx];
-		for (i = pCurScb->SCB_SGIdx; i < pCurScb->SCB_SGMax; sgp++, i++) {
-			xcnt -= (long) sgp->SG_Len;
+	xcnt = (long) scb->buflen - cnt;	/* xcnt== bytes already xferred */
+	scb->buflen = (u32) cnt;		/* cnt == bytes left to be xferred */
+	if (scb->flags & SCF_SG) {
+		struct sg_entry *sgp;
+		unsigned long i;
+
+		sgp = &scb->sglist[scb->sgidx];
+		for (i = scb->sgidx; i < scb->sgmax; sgp++, i++) {
+			xcnt -= (long) sgp->len;
 			if (xcnt < 0) {		/* this sgp xfer half done */
-				xcnt += (long) sgp->SG_Len;	/* xcnt == bytes xferred in this sgp */
-				sgp->SG_Ptr += (U32) xcnt;	/* new ptr to be xfer */
-				sgp->SG_Len -= (U32) xcnt;	/* new len to be xfer */
-				pCurScb->SCB_BufPtr += ((U32) (i - pCurScb->SCB_SGIdx) << 3);
+				xcnt += (long) sgp->len;	/* xcnt == bytes xferred in this sgp */
+				sgp->data += (u32) xcnt;	/* new ptr to be xfer */
+				sgp->len -= (u32) xcnt;	/* new len to be xfer */
+				scb->bufptr += ((u32) (i - scb->sgidx) << 3);
 				/* new SG table ptr */
-				pCurScb->SCB_SGLen = (BYTE) (pCurScb->SCB_SGMax - i);
+				scb->sglen = (u8) (scb->sgmax - i);
 				/* new SG table len */
-				pCurScb->SCB_SGIdx = (WORD) i;
+				scb->sgidx = (u16) i;
 				/* for next disc and come in this loop */
-				return (4);	/* Go to state 4                */
+				return 4;	/* Go to state 4                */
 			}
 			/* else (xcnt >= 0 , i.e. this sgp already xferred */
 		}		/* for */
-		return (6);	/* Go to state 6                */
+		return 6;	/* Go to state 6                */
 	} else {
-		pCurScb->SCB_BufPtr += (U32) xcnt;
+		scb->bufptr += (u32) xcnt;
 	}
-	return (4);		/* Go to state 4                */
+	return 4;		/* Go to state 4                */
 }
 
-/***************************************************************************/
-/* state after Data phase */
-int tul_state_6(HCS * pCurHcb)
+/**
+ *	initio_state_6		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ *	State after Data phase
+ */
+
+static int initio_state_6(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 
 #if DEBUG_STATE
 	printk("-s6-");
 #endif
 	for (;;) {
-		switch (pCurHcb->HCS_Phase) {
+		switch (host->phase) {
 		case STATUS_IN:	/* Status phase                 */
-			if ((tul_status_msg(pCurHcb)) == -1)
-				return (-1);
+			if ((initio_status_msg(host)) == -1)
+				return -1;
 			break;
 
 		case MSG_IN:	/* Message in phase             */
-			pCurScb->SCB_NxtStat = 6;
-			if ((tul_msgin(pCurHcb)) == -1)
-				return (-1);
+			scb->next_state = 6;
+			if ((initio_msgin(host)) == -1)
+				return -1;
 			break;
 
 		case MSG_OUT:	/* Message out phase            */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_NOP);		/* msg nop */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-			if (wait_tulip(pCurHcb) == -1)
-				return (-1);
+			outb(MSG_NOP, host->addr + TUL_SFifo);		/* msg nop */
+			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+			if (wait_tulip(host) == -1)
+				return -1;
 			break;
 
 		case DATA_IN:	/* Data in phase                */
-			return (tul_xpad_in(pCurHcb));
+			return initio_xpad_in(host);
 
 		case DATA_OUT:	/* Data out phase               */
-			return (tul_xpad_out(pCurHcb));
+			return initio_xpad_out(host);
 
 		default:
-			return (tul_bad_seq(pCurHcb));
+			return initio_bad_seq(host);
 		}
 	}
 }
 
-/***************************************************************************/
-int tul_state_7(HCS * pCurHcb)
+/**
+ *	initio_state_7		-	SCSI state machine
+ *	@host: InitIO host we are controlling
+ *
+ */
+
+int initio_state_7(struct initio_host * host)
 {
 	int cnt, i;
 
@@ -1893,1139 +1685,1040 @@
 	printk("-s7-");
 #endif
 	/* flush SCSI FIFO */
-	cnt = TUL_RD(pCurHcb->HCS_Base, TUL_SFifoCnt) & 0x1F;
+	cnt = inb(host->addr + TUL_SFifoCnt) & 0x1F;
 	if (cnt) {
 		for (i = 0; i < cnt; i++)
-			TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
+			inb(host->addr + TUL_SFifo);
 	}
-	switch (pCurHcb->HCS_Phase) {
+	switch (host->phase) {
 	case DATA_IN:		/* Data in phase                */
 	case DATA_OUT:		/* Data out phase               */
-		return (tul_bad_seq(pCurHcb));
+		return initio_bad_seq(host);
 	default:
-		return (6);	/* Go to state 6                */
+		return 6;	/* Go to state 6                */
 	}
 }
 
-/***************************************************************************/
-int tul_xfer_data_in(HCS * pCurHcb)
+/**
+ *	initio_xfer_data_in	-	Commence data input
+ *	@host: InitIO host in use
+ *
+ *	Commence a block of data transfer. The transfer itself will
+ *	be managed by the controller and we will get a completion (or
+ *	failure) interrupt.
+ */
+ 
+static int initio_xfer_data_in(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 
-	if ((pCurScb->SCB_Flags & SCF_DIR) == SCF_DOUT) {
-		return (6);	/* wrong direction */
-	}
-	TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, pCurScb->SCB_BufLen);
+	if ((scb->flags & SCF_DIR) == SCF_DOUT)
+		return 6;	/* wrong direction */
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_DMA_IN);	/* 7/25/95 */
+	outl(scb->buflen, host->addr + TUL_SCnt0);
+	outb(TSC_XF_DMA_IN, host->addr + TUL_SCmd);	/* 7/25/95 */
 
-	if (pCurScb->SCB_Flags & SCF_SG) {	/* S/G xfer */
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XCntH, ((ULONG) pCurScb->SCB_SGLen) << 3);
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XAddH, pCurScb->SCB_BufPtr);
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_SG_IN);
+	if (scb->flags & SCF_SG) {	/* S/G xfer */
+		outl(((u32) scb->sglen) << 3, host->addr + TUL_XCntH);
+		outl(scb->bufptr, host->addr + TUL_XAddH);
+		outb(TAX_SG_IN, host->addr + TUL_XCmd);
 	} else {
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XCntH, pCurScb->SCB_BufLen);
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XAddH, pCurScb->SCB_BufPtr);
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_X_IN);
+		outl(scb->buflen, host->addr + TUL_XCntH);
+		outl(scb->bufptr, host->addr + TUL_XAddH);
+		outb(TAX_X_IN, host->addr + TUL_XCmd);
 	}
-	pCurScb->SCB_NxtStat = 0x5;
-	return (0);		/* return to OS, wait xfer done , let jas_isr come in */
+	scb->next_state = 0x5;
+	return 0;		/* return to OS, wait xfer done , let jas_isr come in */
 }
 
+/**
+ *	initio_xfer_data_out	-	Commence data output
+ *	@host: InitIO host in use
+ *
+ *	Commence a block of data transfer. The transfer itself will
+ *	be managed by the controller and we will get a completion (or
+ *	failure) interrupt.
+ */
 
-/***************************************************************************/
-int tul_xfer_data_out(HCS * pCurHcb)
+static int initio_xfer_data_out(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 
-	if ((pCurScb->SCB_Flags & SCF_DIR) == SCF_DIN) {
-		return (6);	/* wrong direction */
-	}
-	TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, pCurScb->SCB_BufLen);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_DMA_OUT);
+	if ((scb->flags & SCF_DIR) == SCF_DIN)
+		return 6;	/* wrong direction */
 
-	if (pCurScb->SCB_Flags & SCF_SG) {	/* S/G xfer */
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XCntH, ((ULONG) pCurScb->SCB_SGLen) << 3);
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XAddH, pCurScb->SCB_BufPtr);
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_SG_OUT);
+	outl(scb->buflen, host->addr + TUL_SCnt0);
+	outb(TSC_XF_DMA_OUT, host->addr + TUL_SCmd);
+
+	if (scb->flags & SCF_SG) {	/* S/G xfer */
+		outl(((u32) scb->sglen) << 3, host->addr + TUL_XCntH);
+		outl(scb->bufptr, host->addr + TUL_XAddH);
+		outb(TAX_SG_OUT, host->addr + TUL_XCmd);
 	} else {
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XCntH, pCurScb->SCB_BufLen);
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_XAddH, pCurScb->SCB_BufPtr);
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_X_OUT);
+		outl(scb->buflen, host->addr + TUL_XCntH);
+		outl(scb->bufptr, host->addr + TUL_XAddH);
+		outb(TAX_X_OUT, host->addr + TUL_XCmd);
 	}
 
-	pCurScb->SCB_NxtStat = 0x5;
-	return (0);		/* return to OS, wait xfer done , let jas_isr come in */
+	scb->next_state = 0x5;
+	return 0;		/* return to OS, wait xfer done , let jas_isr come in */
 }
 
-
-/***************************************************************************/
-int tul_xpad_in(HCS * pCurHcb)
+int initio_xpad_in(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
 
-	if ((pCurScb->SCB_Flags & SCF_DIR) != SCF_NO_DCHK) {
-		pCurScb->SCB_HaStat = HOST_DO_DU;	/* over run             */
-	}
+	if ((scb->flags & SCF_DIR) != SCF_NO_DCHK)
+		scb->hastat = HOST_DO_DU;	/* over run             */
 	for (;;) {
-		if (pCurTcb->TCS_JS_Period & TSC_WIDE_SCSI)
-			TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 2);
+		if (active_tc->js_period & TSC_WIDE_SCSI)
+			outl(2, host->addr + TUL_SCnt0);
 		else
-			TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
+			outl(1, host->addr + TUL_SCnt0);
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-		if ((wait_tulip(pCurHcb)) == -1) {
-			return (-1);
+		outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
+		if (host->phase != DATA_IN) {
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+			return 6;
 		}
-		if (pCurHcb->HCS_Phase != DATA_IN) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-			return (6);
-		}
-		TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
+		inb(host->addr + TUL_SFifo);
 	}
 }
 
-int tul_xpad_out(HCS * pCurHcb)
+int initio_xpad_out(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
 
-	if ((pCurScb->SCB_Flags & SCF_DIR) != SCF_NO_DCHK) {
-		pCurScb->SCB_HaStat = HOST_DO_DU;	/* over run             */
-	}
+	if ((scb->flags & SCF_DIR) != SCF_NO_DCHK)
+		scb->hastat = HOST_DO_DU;	/* over run             */
 	for (;;) {
-		if (pCurTcb->TCS_JS_Period & TSC_WIDE_SCSI)
-			TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 2);
+		if (active_tc->js_period & TSC_WIDE_SCSI)
+			outl(2, host->addr + TUL_SCnt0);
 		else
-			TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
+			outl(1, host->addr + TUL_SCnt0);
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 0);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-		if ((wait_tulip(pCurHcb)) == -1) {
-			return (-1);
-		}
-		if (pCurHcb->HCS_Phase != DATA_OUT) {	/* Disable wide CPU to allow read 16 bits */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-			return (6);
+		outb(0, host->addr + TUL_SFifo);
+		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+		if ((wait_tulip(host)) == -1)
+			return -1;
+		if (host->phase != DATA_OUT) {	/* Disable wide CPU to allow read 16 bits */
+			outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+			return 6;
 		}
 	}
 }
 
-
-/***************************************************************************/
-int tul_status_msg(HCS * pCurHcb)
+int initio_status_msg(struct initio_host * host)
 {				/* status & MSG_IN */
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	BYTE msg;
+	struct scsi_ctrl_blk *scb = host->active;
+	u8 msg;
+
+	outb(TSC_CMD_COMP, host->addr + TUL_SCmd);
+	if (wait_tulip(host) == -1)
+		return -1;
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_CMD_COMP);
-	if ((wait_tulip(pCurHcb)) == -1) {
-		return (-1);
-	}
 	/* get status */
-	pCurScb->SCB_TaStat = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
+	scb->tastat = inb(host->addr + TUL_SFifo);
 
-	if (pCurHcb->HCS_Phase == MSG_OUT) {
-		if (pCurHcb->HCS_JSStatus0 & TSS_PAR_ERROR) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_PARITY);
-		} else {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_NOP);
-		}
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-		return (wait_tulip(pCurHcb));
-	}
-	if (pCurHcb->HCS_Phase == MSG_IN) {
-		msg = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
-		if (pCurHcb->HCS_JSStatus0 & TSS_PAR_ERROR) {	/* Parity error                 */
-			if ((tul_msgin_accept(pCurHcb)) == -1)
-				return (-1);
-			if (pCurHcb->HCS_Phase != MSG_OUT)
-				return (tul_bad_seq(pCurHcb));
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_PARITY);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-			return (wait_tulip(pCurHcb));
+	if (host->phase == MSG_OUT) {
+		if (host->jsstatus0 & TSS_PAR_ERROR)
+			outb(MSG_PARITY, host->addr + TUL_SFifo);
+		else
+			outb(MSG_NOP, host->addr + TUL_SFifo);
+		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+		return wait_tulip(host);
+	}
+	if (host->phase == MSG_IN) {
+		msg = inb(host->addr + TUL_SFifo);
+		if (host->jsstatus0 & TSS_PAR_ERROR) {	/* Parity error                 */
+			if ((initio_msgin_accept(host)) == -1)
+				return -1;
+			if (host->phase != MSG_OUT)
+				return initio_bad_seq(host);
+			outb(MSG_PARITY, host->addr + TUL_SFifo);
+			outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+			return wait_tulip(host);
 		}
 		if (msg == 0) {	/* Command complete             */
 
-			if ((pCurScb->SCB_TaStat & 0x18) == 0x10) {	/* No link support              */
-				return (tul_bad_seq(pCurHcb));
-			}
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_MSG_ACCEPT);
-			return tul_wait_done_disc(pCurHcb);
+			if ((scb->tastat & 0x18) == 0x10)	/* No link support              */
+				return initio_bad_seq(host);
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+			outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
+			return initio_wait_done_disc(host);
 
 		}
-		if ((msg == MSG_LINK_COMP) || (msg == MSG_LINK_FLAG)) {
-			if ((pCurScb->SCB_TaStat & 0x18) == 0x10)
-				return (tul_msgin_accept(pCurHcb));
+		if (msg == MSG_LINK_COMP || msg == MSG_LINK_FLAG) {
+			if ((scb->tastat & 0x18) == 0x10)
+				return initio_msgin_accept(host);
 		}
 	}
-	return (tul_bad_seq(pCurHcb));
+	return initio_bad_seq(host);
 }
 
 
-/***************************************************************************/
 /* scsi bus free */
-int int_tul_busfree(HCS * pCurHcb)
+int int_initio_busfree(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
+	struct scsi_ctrl_blk *scb = host->active;
 
-	if (pCurScb != NULL) {
-		if (pCurScb->SCB_Status & SCB_SELECT) {		/* selection timeout */
-			tul_unlink_pend_scb(pCurHcb, pCurScb);
-			pCurScb->SCB_HaStat = HOST_SEL_TOUT;
-			tul_append_done_scb(pCurHcb, pCurScb);
+	if (scb != NULL) {
+		if (scb->status & SCB_SELECT) {		/* selection timeout */
+			initio_unlink_pend_scb(host, scb);
+			scb->hastat = HOST_SEL_TOUT;
+			initio_append_done_scb(host, scb);
 		} else {	/* Unexpected bus free          */
-			tul_unlink_busy_scb(pCurHcb, pCurScb);
-			pCurScb->SCB_HaStat = HOST_BUS_FREE;
-			tul_append_done_scb(pCurHcb, pCurScb);
-		}
-		pCurHcb->HCS_ActScb = NULL;
-		pCurHcb->HCS_ActTcs = NULL;
-	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);		/* Flush SCSI FIFO  */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, TSC_INITDEFAULT);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);	/* Enable HW reselect       */
-	return (-1);
+			initio_unlink_busy_scb(host, scb);
+			scb->hastat = HOST_BUS_FREE;
+			initio_append_done_scb(host, scb);
+		}
+		host->active = NULL;
+		host->active_tc = NULL;
+	}
+	outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);		/* Flush SCSI FIFO  */
+	outb(TSC_INITDEFAULT, host->addr + TUL_SConfig);
+	outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);	/* Enable HW reselect       */
+	return -1;
 }
 
 
-/***************************************************************************/
-/* scsi bus reset */
-static int int_tul_scsi_rst(HCS * pCurHcb)
+/**
+ *	int_initio_scsi_rst	-	SCSI reset occurred
+ *	@host: Host seeing the reset
+ *
+ *	A SCSI bus reset has occurred. Clean up any pending transfer
+ *	the hardware is doing by DMA and then abort all active and
+ *	disconnected commands. The mid layer should sort the rest out
+ *	for us
+ */
+
+static int int_initio_scsi_rst(struct initio_host * host)
 {
-	SCB *pCurScb;
+	struct scsi_ctrl_blk *scb;
 	int i;
 
 	/* if DMA xfer is pending, abort DMA xfer */
-	if (TUL_RD(pCurHcb->HCS_Base, TUL_XStatus) & 0x01) {
-		TUL_WR(pCurHcb->HCS_Base + TUL_XCmd, TAX_X_ABT | TAX_X_CLR_FIFO);
+	if (inb(host->addr + TUL_XStatus) & 0x01) {
+		outb(TAX_X_ABT | TAX_X_CLR_FIFO, host->addr + TUL_XCmd);
 		/* wait Abort DMA xfer done */
-		while ((TUL_RD(pCurHcb->HCS_Base, TUL_Int) & 0x04) == 0);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
+		while ((inb(host->addr + TUL_Int) & 0x04) == 0)
+			cpu_relax();
+		outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 	}
 	/* Abort all active & disconnected scb */
-	while ((pCurScb = tul_pop_busy_scb(pCurHcb)) != NULL) {
-		pCurScb->SCB_HaStat = HOST_BAD_PHAS;
-		tul_append_done_scb(pCurHcb, pCurScb);
+	while ((scb = initio_pop_busy_scb(host)) != NULL) {
+		scb->hastat = HOST_BAD_PHAS;
+		initio_append_done_scb(host, scb);
 	}
-	pCurHcb->HCS_ActScb = NULL;
-	pCurHcb->HCS_ActTcs = NULL;
+	host->active = NULL;
+	host->active_tc = NULL;
 
 	/* clr sync nego. done flag */
-	for (i = 0; i < pCurHcb->HCS_MaxTar; i++) {
-		pCurHcb->HCS_Tcs[i].TCS_Flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
-	}
-	return (-1);
+	for (i = 0; i < host->max_tar; i++)
+		host->targets[i].flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
+	return -1;
 }
 
+/**
+ *	int_initio_scsi_resel	-	Reselection occured
+ *	@host: InitIO host adapter
+ *
+ *	A SCSI reselection event has been signalled and the interrupt
+ *	is now being processed. Work out which command block needs attention
+ *	and continue processing that command.
+ */
 
-/***************************************************************************/
-/* scsi reselection */
-int int_tul_resel(HCS * pCurHcb)
+int int_initio_resel(struct initio_host * host)
 {
-	SCB *pCurScb;
-	TCS *pCurTcb;
-	BYTE tag, msg = 0;
-	BYTE tar, lun;
-
-	if ((pCurScb = pCurHcb->HCS_ActScb) != NULL) {
-		if (pCurScb->SCB_Status & SCB_SELECT) {		/* if waiting for selection complete */
-			pCurScb->SCB_Status &= ~SCB_SELECT;
-		}
-		pCurHcb->HCS_ActScb = NULL;
+	struct scsi_ctrl_blk *scb;
+	struct target_control *active_tc;
+	u8 tag, msg = 0;
+	u8 tar, lun;
+
+	if ((scb = host->active) != NULL) {
+		/* FIXME: Why check and not just clear ? */
+		if (scb->status & SCB_SELECT)		/* if waiting for selection complete */
+			scb->status &= ~SCB_SELECT;
+		host->active = NULL;
 	}
 	/* --------- get target id---------------------- */
-	tar = TUL_RD(pCurHcb->HCS_Base, TUL_SBusId);
+	tar = inb(host->addr + TUL_SBusId);
 	/* ------ get LUN from Identify message----------- */
-	lun = TUL_RD(pCurHcb->HCS_Base, TUL_SIdent) & 0x0F;
+	lun = inb(host->addr + TUL_SIdent) & 0x0F;
 	/* 07/22/98 from 0x1F -> 0x0F */
-	pCurTcb = &pCurHcb->HCS_Tcs[tar];
-	pCurHcb->HCS_ActTcs = pCurTcb;
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurTcb->TCS_SConfig0);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SPeriod, pCurTcb->TCS_JS_Period);
-
+	active_tc = &host->targets[tar];
+	host->active_tc = active_tc;
+	outb(active_tc->sconfig0, host->addr + TUL_SConfig);
+	outb(active_tc->js_period, host->addr + TUL_SPeriod);
 
 	/* ------------- tag queueing ? ------------------- */
-	if (pCurTcb->TCS_DrvFlags & TCF_DRV_EN_TAG) {
-		if ((tul_msgin_accept(pCurHcb)) == -1)
-			return (-1);
-		if (pCurHcb->HCS_Phase != MSG_IN)
+	if (active_tc->drv_flags & TCF_DRV_EN_TAG) {
+		if ((initio_msgin_accept(host)) == -1)
+			return -1;
+		if (host->phase != MSG_IN)
 			goto no_tag;
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-		if ((wait_tulip(pCurHcb)) == -1)
-			return (-1);
-		msg = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);	/* Read Tag Message    */
+		outl(1, host->addr + TUL_SCnt0);
+		outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
+		msg = inb(host->addr + TUL_SFifo);	/* Read Tag Message    */
 
-		if ((msg < MSG_STAG) || (msg > MSG_OTAG))	/* Is simple Tag      */
+		if (msg < MSG_STAG || msg > MSG_OTAG)		/* Is simple Tag      */
 			goto no_tag;
 
-		if ((tul_msgin_accept(pCurHcb)) == -1)
-			return (-1);
+		if (initio_msgin_accept(host) == -1)
+			return -1;
 
-		if (pCurHcb->HCS_Phase != MSG_IN)
+		if (host->phase != MSG_IN)
 			goto no_tag;
 
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-		if ((wait_tulip(pCurHcb)) == -1)
-			return (-1);
-		tag = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);	/* Read Tag ID       */
-		pCurScb = pCurHcb->HCS_Scb + tag;
-		if ((pCurScb->SCB_Target != tar) || (pCurScb->SCB_Lun != lun)) {
-			return tul_msgout_abort_tag(pCurHcb);
-		}
-		if (pCurScb->SCB_Status != SCB_BUSY) {	/* 03/24/95             */
-			return tul_msgout_abort_tag(pCurHcb);
-		}
-		pCurHcb->HCS_ActScb = pCurScb;
-		if ((tul_msgin_accept(pCurHcb)) == -1)
-			return (-1);
+		outl(1, host->addr + TUL_SCnt0);
+		outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
+		tag = inb(host->addr + TUL_SFifo);	/* Read Tag ID       */
+		scb = host->scb + tag;
+		if (scb->target != tar || scb->lun != lun) {
+			return initio_msgout_abort_tag(host);
+		}
+		if (scb->status != SCB_BUSY) {	/* 03/24/95             */
+			return initio_msgout_abort_tag(host);
+		}
+		host->active = scb;
+		if ((initio_msgin_accept(host)) == -1)
+			return -1;
 	} else {		/* No tag               */
 	      no_tag:
-		if ((pCurScb = tul_find_busy_scb(pCurHcb, tar | (lun << 8))) == NULL) {
-			return tul_msgout_abort_targ(pCurHcb);
+		if ((scb = initio_find_busy_scb(host, tar | (lun << 8))) == NULL) {
+			return initio_msgout_abort_targ(host);
 		}
-		pCurHcb->HCS_ActScb = pCurScb;
-		if (!(pCurTcb->TCS_DrvFlags & TCF_DRV_EN_TAG)) {
-			if ((tul_msgin_accept(pCurHcb)) == -1)
-				return (-1);
+		host->active = scb;
+		if (!(active_tc->drv_flags & TCF_DRV_EN_TAG)) {
+			if ((initio_msgin_accept(host)) == -1)
+				return -1;
 		}
 	}
 	return 0;
 }
 
+/**
+ *	int_initio_bad_seq		-	out of phase
+ *	@host: InitIO host flagging event
+ *
+ *	We have ended up out of phase somehow. Reset the host controller
+ *	and throw all our toys out of the pram. Let the midlayer clean up
+ */
 
-/***************************************************************************/
-static int int_tul_bad_seq(HCS * pCurHcb)
+static int int_initio_bad_seq(struct initio_host * host)
 {				/* target wrong phase           */
-	SCB *pCurScb;
+	struct scsi_ctrl_blk *scb;
 	int i;
 
-	tul_reset_scsi(pCurHcb, 10);
+	initio_reset_scsi(host, 10);
 
-	while ((pCurScb = tul_pop_busy_scb(pCurHcb)) != NULL) {
-		pCurScb->SCB_HaStat = HOST_BAD_PHAS;
-		tul_append_done_scb(pCurHcb, pCurScb);
+	while ((scb = initio_pop_busy_scb(host)) != NULL) {
+		scb->hastat = HOST_BAD_PHAS;
+		initio_append_done_scb(host, scb);
 	}
-	for (i = 0; i < pCurHcb->HCS_MaxTar; i++) {
-		pCurHcb->HCS_Tcs[i].TCS_Flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
-	}
-	return (-1);
+	for (i = 0; i < host->max_tar; i++)
+		host->targets[i].flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
+	return -1;
 }
 
 
-/***************************************************************************/
-int tul_msgout_abort_targ(HCS * pCurHcb)
+/**
+ *	initio_msgout_abort_targ		-	abort a tag
+ *	@host: InitIO host
+ *
+ *	Abort when the target/lun does not match or when our SCB is not
+ *	busy. Used by untagged commands.
+ */
+
+static int initio_msgout_abort_targ(struct initio_host * host)
 {
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-	if (tul_msgin_accept(pCurHcb) == -1)
-		return (-1);
-	if (pCurHcb->HCS_Phase != MSG_OUT)
-		return (tul_bad_seq(pCurHcb));
+	outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN), host->addr + TUL_SSignal);
+	if (initio_msgin_accept(host) == -1)
+		return -1;
+	if (host->phase != MSG_OUT)
+		return initio_bad_seq(host);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_ABORT);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
+	outb(MSG_ABORT, host->addr + TUL_SFifo);
+	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 
-	return tul_wait_disc(pCurHcb);
+	return initio_wait_disc(host);
 }
 
-/***************************************************************************/
-int tul_msgout_abort_tag(HCS * pCurHcb)
+/**
+ *	initio_msgout_abort_tag		-	abort a tag
+ *	@host: InitIO host
+ *
+ *	Abort when the target/lun does not match or when our SCB is not
+ *	busy. Used for tagged commands.
+ */
+
+static int initio_msgout_abort_tag(struct initio_host * host)
 {
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-	if (tul_msgin_accept(pCurHcb) == -1)
-		return (-1);
-	if (pCurHcb->HCS_Phase != MSG_OUT)
-		return (tul_bad_seq(pCurHcb));
+	outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN), host->addr + TUL_SSignal);
+	if (initio_msgin_accept(host) == -1)
+		return -1;
+	if (host->phase != MSG_OUT)
+		return initio_bad_seq(host);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_ABORT_TAG);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
+	outb(MSG_ABORT_TAG, host->addr + TUL_SFifo);
+	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
 
-	return tul_wait_disc(pCurHcb);
+	return initio_wait_disc(host);
 
 }
 
-/***************************************************************************/
-int tul_msgin(HCS * pCurHcb)
+/**
+ *	initio_msgin		-	Message in
+ *	@host: InitIO Host
+ *
+ *	Process incoming message
+ */
+ 
+static int initio_msgin(struct initio_host * host)
 {
-	TCS *pCurTcb;
+	struct target_control *active_tc;
 
 	for (;;) {
+		outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-		if ((wait_tulip(pCurHcb)) == -1)
-			return (-1);
+		outl(1, host->addr + TUL_SCnt0);
+		outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
 
-		switch (TUL_RD(pCurHcb->HCS_Base, TUL_SFifo)) {
+		switch (inb(host->addr + TUL_SFifo)) {
 		case MSG_DISC:	/* Disconnect msg */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_MSG_ACCEPT);
-
-			return tul_wait_disc(pCurHcb);
-
+			outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
+			return initio_wait_disc(host);
 		case MSG_SDP:
 		case MSG_RESTORE:
 		case MSG_NOP:
-			tul_msgin_accept(pCurHcb);
+			initio_msgin_accept(host);
 			break;
-
 		case MSG_REJ:	/* Clear ATN first              */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SSignal,
-			       (TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)));
-			pCurTcb = pCurHcb->HCS_ActTcs;
-			if ((pCurTcb->TCS_Flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0) {	/* do sync nego */
-				TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-			}
-			tul_msgin_accept(pCurHcb);
+			outb((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)), 
+				host->addr + TUL_SSignal);
+			active_tc = host->active_tc;
+			if ((active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0)	/* do sync nego */
+				outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN),
+					host->addr + TUL_SSignal);
+			initio_msgin_accept(host);
 			break;
-
 		case MSG_EXTEND:	/* extended msg */
-			tul_msgin_extend(pCurHcb);
+			initio_msgin_extend(host);
 			break;
-
 		case MSG_IGNOREWIDE:
-			tul_msgin_accept(pCurHcb);
-			break;
-
-			/* get */
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-			if (wait_tulip(pCurHcb) == -1)
-				return -1;
-
-			TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 0);	/* put pad  */
-			TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);	/* get IGNORE field */
-			TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);	/* get pad */
-
-			tul_msgin_accept(pCurHcb);
+			initio_msgin_accept(host);
 			break;
-
 		case MSG_COMP:
-			{
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-				TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_MSG_ACCEPT);
-				return tul_wait_done_disc(pCurHcb);
-			}
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
+			outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
+			return initio_wait_done_disc(host);
 		default:
-			tul_msgout_reject(pCurHcb);
+			initio_msgout_reject(host);
 			break;
 		}
-		if (pCurHcb->HCS_Phase != MSG_IN)
-			return (pCurHcb->HCS_Phase);
+		if (host->phase != MSG_IN)
+			return host->phase;
 	}
 	/* statement won't reach here */
 }
 
-
-
-
-/***************************************************************************/
-int tul_msgout_reject(HCS * pCurHcb)
+static int initio_msgout_reject(struct initio_host * host)
 {
+	outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN), host->addr + TUL_SSignal);
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-
-	if ((tul_msgin_accept(pCurHcb)) == -1)
-		return (-1);
+	if (initio_msgin_accept(host) == -1)
+		return -1;
 
-	if (pCurHcb->HCS_Phase == MSG_OUT) {
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_REJ);		/* Msg reject           */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-		return (wait_tulip(pCurHcb));
+	if (host->phase == MSG_OUT) {
+		outb(MSG_REJ, host->addr + TUL_SFifo);		/* Msg reject           */
+		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+		return wait_tulip(host);
 	}
-	return (pCurHcb->HCS_Phase);
+	return host->phase;
 }
 
-
-
-/***************************************************************************/
-int tul_msgout_ide(HCS * pCurHcb)
+static int initio_msgout_ide(struct initio_host * host)
 {
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_IDE);		/* Initiator Detected Error */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-	return (wait_tulip(pCurHcb));
+	outb(MSG_IDE, host->addr + TUL_SFifo);		/* Initiator Detected Error */
+	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+	return wait_tulip(host);
 }
 
-
-/***************************************************************************/
-int tul_msgin_extend(HCS * pCurHcb)
+static int initio_msgin_extend(struct initio_host * host)
 {
-	BYTE len, idx;
+	u8 len, idx;
 
-	if (tul_msgin_accept(pCurHcb) != MSG_IN)
-		return (pCurHcb->HCS_Phase);
+	if (initio_msgin_accept(host) != MSG_IN)
+		return host->phase;
 
 	/* Get extended msg length      */
-	TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-	if (wait_tulip(pCurHcb) == -1)
-		return (-1);
+	outl(1, host->addr + TUL_SCnt0);
+	outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+	if (wait_tulip(host) == -1)
+		return -1;
 
-	len = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
-	pCurHcb->HCS_Msg[0] = len;
+	len = inb(host->addr + TUL_SFifo);
+	host->msg[0] = len;
 	for (idx = 1; len != 0; len--) {
 
-		if ((tul_msgin_accept(pCurHcb)) != MSG_IN)
-			return (pCurHcb->HCS_Phase);
-		TUL_WRLONG(pCurHcb->HCS_Base + TUL_SCnt0, 1);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_IN);
-		if (wait_tulip(pCurHcb) == -1)
-			return (-1);
-		pCurHcb->HCS_Msg[idx++] = TUL_RD(pCurHcb->HCS_Base, TUL_SFifo);
-	}
-	if (pCurHcb->HCS_Msg[1] == 1) {		/* if it's synchronous data transfer request */
-		if (pCurHcb->HCS_Msg[0] != 3)	/* if length is not right */
-			return (tul_msgout_reject(pCurHcb));
-		if (pCurHcb->HCS_ActTcs->TCS_Flags & TCF_NO_SYNC_NEGO) {	/* Set OFFSET=0 to do async, nego back */
-			pCurHcb->HCS_Msg[3] = 0;
+		if ((initio_msgin_accept(host)) != MSG_IN)
+			return host->phase;
+		outl(1, host->addr + TUL_SCnt0);
+		outb(TSC_XF_FIFO_IN, host->addr + TUL_SCmd);
+		if (wait_tulip(host) == -1)
+			return -1;
+		host->msg[idx++] = inb(host->addr + TUL_SFifo);
+	}
+	if (host->msg[1] == 1) {		/* if it's synchronous data transfer request */
+		u8 r;
+		if (host->msg[0] != 3)	/* if length is not right */
+			return initio_msgout_reject(host);
+		if (host->active_tc->flags & TCF_NO_SYNC_NEGO) {	/* Set OFFSET=0 to do async, nego back */
+			host->msg[3] = 0;
 		} else {
-			if ((tul_msgin_sync(pCurHcb) == 0) &&
-			    (pCurHcb->HCS_ActTcs->TCS_Flags & TCF_SYNC_DONE)) {
-				tul_sync_done(pCurHcb);
-				return (tul_msgin_accept(pCurHcb));
+			if (initio_msgin_sync(host) == 0 &&
+			    (host->active_tc->flags & TCF_SYNC_DONE)) {
+				initio_sync_done(host);
+				return initio_msgin_accept(host);
 			}
 		}
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-		if ((tul_msgin_accept(pCurHcb)) != MSG_OUT)
-			return (pCurHcb->HCS_Phase);
+		r = inb(host->addr + TUL_SSignal);
+		outb((r & (TSC_SET_ACK | 7)) | TSC_SET_ATN, 
+			host->addr + TUL_SSignal);
+		if (initio_msgin_accept(host) != MSG_OUT)
+			return host->phase;
 		/* sync msg out */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);
-
-		tul_sync_done(pCurHcb);
+		outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_EXTEND);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 3);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 1);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurHcb->HCS_Msg[2]);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurHcb->HCS_Msg[3]);
+		initio_sync_done(host);
 
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-		return (wait_tulip(pCurHcb));
+		outb(MSG_EXTEND, host->addr + TUL_SFifo);
+		outb(3, host->addr + TUL_SFifo);
+		outb(1, host->addr + TUL_SFifo);
+		outb(host->msg[2], host->addr + TUL_SFifo);
+		outb(host->msg[3], host->addr + TUL_SFifo);
+		outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+		return wait_tulip(host);
 	}
-	if ((pCurHcb->HCS_Msg[0] != 2) || (pCurHcb->HCS_Msg[1] != 3))
-		return (tul_msgout_reject(pCurHcb));
+	if (host->msg[0] != 2 || host->msg[1] != 3)
+		return initio_msgout_reject(host);
 	/* if it's WIDE DATA XFER REQ   */
-	if (pCurHcb->HCS_ActTcs->TCS_Flags & TCF_NO_WDTR) {
-		pCurHcb->HCS_Msg[2] = 0;
+	if (host->active_tc->flags & TCF_NO_WDTR) {
+		host->msg[2] = 0;
 	} else {
-		if (pCurHcb->HCS_Msg[2] > 2)	/* > 32 bits            */
-			return (tul_msgout_reject(pCurHcb));
-		if (pCurHcb->HCS_Msg[2] == 2) {		/* == 32                */
-			pCurHcb->HCS_Msg[2] = 1;
+		if (host->msg[2] > 2)	/* > 32 bits            */
+			return initio_msgout_reject(host);
+		if (host->msg[2] == 2) {		/* == 32                */
+			host->msg[2] = 1;
 		} else {
-			if ((pCurHcb->HCS_ActTcs->TCS_Flags & TCF_NO_WDTR) == 0) {
-				wdtr_done(pCurHcb);
-				if ((pCurHcb->HCS_ActTcs->TCS_Flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0)
-					TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
-				return (tul_msgin_accept(pCurHcb));
+			if ((host->active_tc->flags & TCF_NO_WDTR) == 0) {
+				wdtr_done(host);
+				if ((host->active_tc->flags & (TCF_SYNC_DONE | TCF_NO_SYNC_NEGO)) == 0)
+					outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN), host->addr + TUL_SSignal);
+				return initio_msgin_accept(host);
 			}
 		}
 	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
+	outb(((inb(host->addr + TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN), host->addr + TUL_SSignal);
 
-	if (tul_msgin_accept(pCurHcb) != MSG_OUT)
-		return (pCurHcb->HCS_Phase);
+	if (initio_msgin_accept(host) != MSG_OUT)
+		return host->phase;
 	/* WDTR msg out                 */
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_EXTEND);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 2);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, 3);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurHcb->HCS_Msg[2]);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-	return (wait_tulip(pCurHcb));
+	outb(MSG_EXTEND, host->addr + TUL_SFifo);
+	outb(2, host->addr + TUL_SFifo);
+	outb(3, host->addr + TUL_SFifo);
+	outb(host->msg[2], host->addr + TUL_SFifo);
+	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+	return wait_tulip(host);
 }
 
-/***************************************************************************/
-int tul_msgin_sync(HCS * pCurHcb)
+static int initio_msgin_sync(struct initio_host * host)
 {
 	char default_period;
 
-	default_period = tul_rate_tbl[pCurHcb->HCS_ActTcs->TCS_Flags & TCF_SCSI_RATE];
-	if (pCurHcb->HCS_Msg[3] > MAX_OFFSET) {
-		pCurHcb->HCS_Msg[3] = MAX_OFFSET;
-		if (pCurHcb->HCS_Msg[2] < default_period) {
-			pCurHcb->HCS_Msg[2] = default_period;
+	default_period = initio_rate_tbl[host->active_tc->flags & TCF_SCSI_RATE];
+	if (host->msg[3] > MAX_OFFSET) {
+		host->msg[3] = MAX_OFFSET;
+		if (host->msg[2] < default_period) {
+			host->msg[2] = default_period;
 			return 1;
 		}
-		if (pCurHcb->HCS_Msg[2] >= 59) {	/* Change to async              */
-			pCurHcb->HCS_Msg[3] = 0;
-		}
+		if (host->msg[2] >= 59)	/* Change to async              */
+			host->msg[3] = 0;
 		return 1;
 	}
 	/* offset requests asynchronous transfers ? */
-	if (pCurHcb->HCS_Msg[3] == 0) {
+	if (host->msg[3] == 0) {
 		return 0;
 	}
-	if (pCurHcb->HCS_Msg[2] < default_period) {
-		pCurHcb->HCS_Msg[2] = default_period;
+	if (host->msg[2] < default_period) {
+		host->msg[2] = default_period;
 		return 1;
 	}
-	if (pCurHcb->HCS_Msg[2] >= 59) {
-		pCurHcb->HCS_Msg[3] = 0;
+	if (host->msg[2] >= 59) {
+		host->msg[3] = 0;
 		return 1;
 	}
 	return 0;
 }
 
-
-/***************************************************************************/
-int wdtr_done(HCS * pCurHcb)
+static int wdtr_done(struct initio_host * host)
 {
-	pCurHcb->HCS_ActTcs->TCS_Flags &= ~TCF_SYNC_DONE;
-	pCurHcb->HCS_ActTcs->TCS_Flags |= TCF_WDTR_DONE;
+	host->active_tc->flags &= ~TCF_SYNC_DONE;
+	host->active_tc->flags |= TCF_WDTR_DONE;
 
-	pCurHcb->HCS_ActTcs->TCS_JS_Period = 0;
-	if (pCurHcb->HCS_Msg[2]) {	/* if 16 bit */
-		pCurHcb->HCS_ActTcs->TCS_JS_Period |= TSC_WIDE_SCSI;
-	}
-	pCurHcb->HCS_ActTcs->TCS_SConfig0 &= ~TSC_ALT_PERIOD;
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurHcb->HCS_ActTcs->TCS_SConfig0);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SPeriod, pCurHcb->HCS_ActTcs->TCS_JS_Period);
+	host->active_tc->js_period = 0;
+	if (host->msg[2])	/* if 16 bit */
+		host->active_tc->js_period |= TSC_WIDE_SCSI;
+	host->active_tc->sconfig0 &= ~TSC_ALT_PERIOD;
+	outb(host->active_tc->sconfig0, host->addr + TUL_SConfig);
+	outb(host->active_tc->js_period, host->addr + TUL_SPeriod);
 
 	return 1;
 }
 
-/***************************************************************************/
-int tul_sync_done(HCS * pCurHcb)
+static int initio_sync_done(struct initio_host * host)
 {
 	int i;
 
-	pCurHcb->HCS_ActTcs->TCS_Flags |= TCF_SYNC_DONE;
+	host->active_tc->flags |= TCF_SYNC_DONE;
 
-	if (pCurHcb->HCS_Msg[3]) {
-		pCurHcb->HCS_ActTcs->TCS_JS_Period |= pCurHcb->HCS_Msg[3];
+	if (host->msg[3]) {
+		host->active_tc->js_period |= host->msg[3];
 		for (i = 0; i < 8; i++) {
-			if (tul_rate_tbl[i] >= pCurHcb->HCS_Msg[2])	/* pick the big one */
+			if (initio_rate_tbl[i] >= host->msg[2])	/* pick the big one */
 				break;
 		}
-		pCurHcb->HCS_ActTcs->TCS_JS_Period |= (i << 4);
-		pCurHcb->HCS_ActTcs->TCS_SConfig0 |= TSC_ALT_PERIOD;
+		host->active_tc->js_period |= (i << 4);
+		host->active_tc->sconfig0 |= TSC_ALT_PERIOD;
 	}
-	TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, pCurHcb->HCS_ActTcs->TCS_SConfig0);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SPeriod, pCurHcb->HCS_ActTcs->TCS_JS_Period);
+	outb(host->active_tc->sconfig0, host->addr + TUL_SConfig);
+	outb(host->active_tc->js_period, host->addr + TUL_SPeriod);
 
-	return (-1);
+	return -1;
 }
 
 
-int tul_post_scsi_rst(HCS * pCurHcb)
+static int initio_post_scsi_rst(struct initio_host * host)
 {
-	SCB *pCurScb;
-	TCS *pCurTcb;
+	struct scsi_ctrl_blk *scb;
+	struct target_control *active_tc;
 	int i;
 
-	pCurHcb->HCS_ActScb = NULL;
-	pCurHcb->HCS_ActTcs = NULL;
-	pCurHcb->HCS_Flags = 0;
-
-	while ((pCurScb = tul_pop_busy_scb(pCurHcb)) != NULL) {
-		pCurScb->SCB_HaStat = HOST_BAD_PHAS;
-		tul_append_done_scb(pCurHcb, pCurScb);
+	host->active = NULL;
+	host->active_tc = NULL;
+	host->flags = 0;
+
+	while ((scb = initio_pop_busy_scb(host)) != NULL) {
+		scb->hastat = HOST_BAD_PHAS;
+		initio_append_done_scb(host, scb);
 	}
 	/* clear sync done flag         */
-	pCurTcb = &pCurHcb->HCS_Tcs[0];
-	for (i = 0; i < pCurHcb->HCS_MaxTar; pCurTcb++, i++) {
-		pCurTcb->TCS_Flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
+	active_tc = &host->targets[0];
+	for (i = 0; i < host->max_tar; active_tc++, i++) {
+		active_tc->flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE);
 		/* Initialize the sync. xfer register values to an asyn xfer */
-		pCurTcb->TCS_JS_Period = 0;
-		pCurTcb->TCS_SConfig0 = pCurHcb->HCS_SConf1;
-		pCurHcb->HCS_ActTags[0] = 0;	/* 07/22/98 */
-		pCurHcb->HCS_Tcs[i].TCS_Flags &= ~TCF_BUSY;	/* 07/22/98 */
+		active_tc->js_period = 0;
+		active_tc->sconfig0 = host->sconf1;
+		host->act_tags[0] = 0;	/* 07/22/98 */
+		host->targets[i].flags &= ~TCF_BUSY;	/* 07/22/98 */
 	}			/* for */
 
-	return (-1);
+	return -1;
 }
 
-/***************************************************************************/
-void tul_select_atn_stop(HCS * pCurHcb, SCB * pCurScb)
+static void initio_select_atn_stop(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
-	pCurScb->SCB_Status |= SCB_SELECT;
-	pCurScb->SCB_NxtStat = 0x1;
-	pCurHcb->HCS_ActScb = pCurScb;
-	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SELATNSTOP);
-	return;
+	scb->status |= SCB_SELECT;
+	scb->next_state = 0x1;
+	host->active = scb;
+	host->active_tc = &host->targets[scb->target];
+	outb(TSC_SELATNSTOP, host->addr + TUL_SCmd);
 }
 
 
-/***************************************************************************/
-void tul_select_atn(HCS * pCurHcb, SCB * pCurScb)
+static void initio_select_atn(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
 	int i;
 
-	pCurScb->SCB_Status |= SCB_SELECT;
-	pCurScb->SCB_NxtStat = 0x2;
+	scb->status |= SCB_SELECT;
+	scb->next_state = 0x2;
 
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_Ident);
-	for (i = 0; i < (int) pCurScb->SCB_CDBLen; i++)
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_CDB[i]);
-	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
-	pCurHcb->HCS_ActScb = pCurScb;
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SEL_ATN);
-	return;
+	outb(scb->ident, host->addr + TUL_SFifo);
+	for (i = 0; i < (int) scb->cdblen; i++)
+		outb(scb->cdb[i], host->addr + TUL_SFifo);
+	host->active_tc = &host->targets[scb->target];
+	host->active = scb;
+	outb(TSC_SEL_ATN, host->addr + TUL_SCmd);
 }
 
-/***************************************************************************/
-void tul_select_atn3(HCS * pCurHcb, SCB * pCurScb)
+static void initio_select_atn3(struct initio_host * host, struct scsi_ctrl_blk * scb)
 {
 	int i;
 
-	pCurScb->SCB_Status |= SCB_SELECT;
-	pCurScb->SCB_NxtStat = 0x2;
-
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_Ident);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_TagMsg);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_TagId);
-	for (i = 0; i < (int) pCurScb->SCB_CDBLen; i++)
-		TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, pCurScb->SCB_CDB[i]);
-	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
-	pCurHcb->HCS_ActScb = pCurScb;
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SEL_ATN3);
-	return;
-}
+	scb->status |= SCB_SELECT;
+	scb->next_state = 0x2;
 
-/***************************************************************************/
-/* SCSI Bus Device Reset */
-int tul_bus_device_reset(HCS * pCurHcb)
+	outb(scb->ident, host->addr + TUL_SFifo);
+	outb(scb->tagmsg, host->addr + TUL_SFifo);
+	outb(scb->tagid, host->addr + TUL_SFifo);
+	for (i = 0; i < scb->cdblen; i++)
+		outb(scb->cdb[i], host->addr + TUL_SFifo);
+	host->active_tc = &host->targets[scb->target];
+	host->active = scb;
+	outb(TSC_SEL_ATN3, host->addr + TUL_SCmd);
+}
+
+/**
+ *	initio_bus_device_reset	-	 SCSI Bus Device Reset 
+ *	@host: InitIO host to reset
+ *	
+ *	Perform a device reset and abort all pending SCBs for the
+ *	victim device
+ */
+ 
+int initio_bus_device_reset(struct initio_host * host)
 {
-	SCB *pCurScb = pCurHcb->HCS_ActScb;
-	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
-	SCB *pTmpScb, *pPrevScb;
-	BYTE tar;
+	struct scsi_ctrl_blk *scb = host->active;
+	struct target_control *active_tc = host->active_tc;
+	struct scsi_ctrl_blk *tmp, *prev;
+	u8 tar;
 
-	if (pCurHcb->HCS_Phase != MSG_OUT) {
-		return (int_tul_bad_seq(pCurHcb));	/* Unexpected phase             */
-	}
-	tul_unlink_pend_scb(pCurHcb, pCurScb);
-	tul_release_scb(pCurHcb, pCurScb);
+	if (host->phase != MSG_OUT)
+		return int_initio_bad_seq(host);	/* Unexpected phase */
+
+	initio_unlink_pend_scb(host, scb);
+	initio_release_scb(host, scb);
 
 
-	tar = pCurScb->SCB_Target;	/* target                       */
-	pCurTcb->TCS_Flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE | TCF_BUSY);
+	tar = scb->target;	/* target                       */
+	active_tc->flags &= ~(TCF_SYNC_DONE | TCF_WDTR_DONE | TCF_BUSY);
 	/* clr sync. nego & WDTR flags  07/22/98 */
 
 	/* abort all SCB with same target */
-	pPrevScb = pTmpScb = pCurHcb->HCS_FirstBusy;	/* Check Busy queue */
-	while (pTmpScb != NULL) {
-
-		if (pTmpScb->SCB_Target == tar) {
+	prev = tmp = host->first_busy;	/* Check Busy queue */
+	while (tmp != NULL) {
+		if (tmp->target == tar) {
 			/* unlink it */
-			if (pTmpScb == pCurHcb->HCS_FirstBusy) {
-				if ((pCurHcb->HCS_FirstBusy = pTmpScb->SCB_NxtScb) == NULL)
-					pCurHcb->HCS_LastBusy = NULL;
+			if (tmp == host->first_busy) {
+				if ((host->first_busy = tmp->next) == NULL)
+					host->last_busy = NULL;
 			} else {
-				pPrevScb->SCB_NxtScb = pTmpScb->SCB_NxtScb;
-				if (pTmpScb == pCurHcb->HCS_LastBusy)
-					pCurHcb->HCS_LastBusy = pPrevScb;
+				prev->next = tmp->next;
+				if (tmp == host->last_busy)
+					host->last_busy = prev;
 			}
-			pTmpScb->SCB_HaStat = HOST_ABORTED;
-			tul_append_done_scb(pCurHcb, pTmpScb);
+			tmp->hastat = HOST_ABORTED;
+			initio_append_done_scb(host, tmp);
 		}
 		/* Previous haven't change      */
 		else {
-			pPrevScb = pTmpScb;
+			prev = tmp;
 		}
-		pTmpScb = pTmpScb->SCB_NxtScb;
+		tmp = tmp->next;
 	}
-
-	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_DEVRST);
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
-
-	return tul_wait_disc(pCurHcb);
+	outb(MSG_DEVRST, host->addr + TUL_SFifo);
+	outb(TSC_XF_FIFO_OUT, host->addr + TUL_SCmd);
+	return initio_wait_disc(host);
 
 }
 
-/***************************************************************************/
-int tul_msgin_accept(HCS * pCurHcb)
+static int initio_msgin_accept(struct initio_host * host)
 {
-	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_MSG_ACCEPT);
-	return (wait_tulip(pCurHcb));
+	outb(TSC_MSG_ACCEPT, host->addr + TUL_SCmd);
+	return wait_tulip(host);
 }
 
-/***************************************************************************/
-int wait_tulip(HCS * pCurHcb)
+static int wait_tulip(struct initio_host * host)
 {
 
-	while (!((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0))
-		 & TSS_INT_PENDING));
+	while (!((host->jsstatus0 = inb(host->addr + TUL_SStatus0))
+		 & TSS_INT_PENDING))
+		 	cpu_relax();
+
+	host->jsint = inb(host->addr + TUL_SInt);
+	host->phase = host->jsstatus0 & TSS_PH_MASK;
+	host->jsstatus1 = inb(host->addr + TUL_SStatus1);
+
+	if (host->jsint & TSS_RESEL_INT)	/* if SCSI bus reset detected */
+		return int_initio_resel(host);
+	if (host->jsint & TSS_SEL_TIMEOUT)	/* if selected/reselected timeout interrupt */
+		return int_initio_busfree(host);
+	if (host->jsint & TSS_SCSIRST_INT)	/* if SCSI bus reset detected   */
+		return int_initio_scsi_rst(host);
 
-	pCurHcb->HCS_JSInt = TUL_RD(pCurHcb->HCS_Base, TUL_SInt);
-	pCurHcb->HCS_Phase = pCurHcb->HCS_JSStatus0 & TSS_PH_MASK;
-	pCurHcb->HCS_JSStatus1 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus1);
-
-	if (pCurHcb->HCS_JSInt & TSS_RESEL_INT) {	/* if SCSI bus reset detected   */
-		return (int_tul_resel(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & TSS_SEL_TIMEOUT) {	/* if selected/reselected timeout interrupt */
-		return (int_tul_busfree(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & TSS_SCSIRST_INT) {	/* if SCSI bus reset detected   */
-		return (int_tul_scsi_rst(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & TSS_DISC_INT) {	/* BUS disconnection            */
-		if (pCurHcb->HCS_Flags & HCF_EXPECT_DONE_DISC) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);		/* Flush SCSI FIFO  */
-			tul_unlink_busy_scb(pCurHcb, pCurHcb->HCS_ActScb);
-			pCurHcb->HCS_ActScb->SCB_HaStat = 0;
-			tul_append_done_scb(pCurHcb, pCurHcb->HCS_ActScb);
-			pCurHcb->HCS_ActScb = NULL;
-			pCurHcb->HCS_ActTcs = NULL;
-			pCurHcb->HCS_Flags &= ~HCF_EXPECT_DONE_DISC;
-			TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, TSC_INITDEFAULT);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);	/* Enable HW reselect       */
-			return (-1);
-		}
-		if (pCurHcb->HCS_Flags & HCF_EXPECT_DISC) {
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);		/* Flush SCSI FIFO  */
-			pCurHcb->HCS_ActScb = NULL;
-			pCurHcb->HCS_ActTcs = NULL;
-			pCurHcb->HCS_Flags &= ~HCF_EXPECT_DISC;
-			TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, TSC_INITDEFAULT);
-			TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);	/* Enable HW reselect       */
-			return (-1);
+	if (host->jsint & TSS_DISC_INT) {	/* BUS disconnection            */
+		if (host->flags & HCF_EXPECT_DONE_DISC) {
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0); /* Flush SCSI FIFO */
+			initio_unlink_busy_scb(host, host->active);
+			host->active->hastat = 0;
+			initio_append_done_scb(host, host->active);
+			host->active = NULL;
+			host->active_tc = NULL;
+			host->flags &= ~HCF_EXPECT_DONE_DISC;
+			outb(TSC_INITDEFAULT, host->addr + TUL_SConfig);
+			outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);	/* Enable HW reselect */
+			return -1;
 		}
-		return (int_tul_busfree(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & (TSS_FUNC_COMP | TSS_BUS_SERV)) {
-		return (pCurHcb->HCS_Phase);
+		if (host->flags & HCF_EXPECT_DISC) {
+			outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0); /* Flush SCSI FIFO */
+			host->active = NULL;
+			host->active_tc = NULL;
+			host->flags &= ~HCF_EXPECT_DISC;
+			outb(TSC_INITDEFAULT, host->addr + TUL_SConfig);
+			outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);	/* Enable HW reselect */
+			return -1;
+		}
+		return int_initio_busfree(host);
 	}
-	return (pCurHcb->HCS_Phase);
+	/* The old code really does the below. Can probably be removed */
+	if (host->jsint & (TSS_FUNC_COMP | TSS_BUS_SERV))
+		return host->phase;
+	return host->phase;
 }
-/***************************************************************************/
-int tul_wait_disc(HCS * pCurHcb)
-{
-
-	while (!((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0))
-		 & TSS_INT_PENDING));
 
+static int initio_wait_disc(struct initio_host * host)
+{
+	while (!((host->jsstatus0 = inb(host->addr + TUL_SStatus0)) & TSS_INT_PENDING))
+		cpu_relax();
 
-	pCurHcb->HCS_JSInt = TUL_RD(pCurHcb->HCS_Base, TUL_SInt);
+	host->jsint = inb(host->addr + TUL_SInt);
 
-	if (pCurHcb->HCS_JSInt & TSS_SCSIRST_INT) {	/* if SCSI bus reset detected   */
-		return (int_tul_scsi_rst(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & TSS_DISC_INT) {	/* BUS disconnection            */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);		/* Flush SCSI FIFO  */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, TSC_INITDEFAULT);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);	/* Enable HW reselect       */
-		pCurHcb->HCS_ActScb = NULL;
-		return (-1);
+	if (host->jsint & TSS_SCSIRST_INT)	/* if SCSI bus reset detected */
+		return int_initio_scsi_rst(host);
+	if (host->jsint & TSS_DISC_INT) {	/* BUS disconnection */
+		outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0); /* Flush SCSI FIFO */
+		outb(TSC_INITDEFAULT, host->addr + TUL_SConfig);
+		outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);	/* Enable HW reselect */
+		host->active = NULL;
+		return -1;
 	}
-	return (tul_bad_seq(pCurHcb));
+	return initio_bad_seq(host);
 }
 
-/***************************************************************************/
-int tul_wait_done_disc(HCS * pCurHcb)
+static int initio_wait_done_disc(struct initio_host * host)
 {
+	while (!((host->jsstatus0 = inb(host->addr + TUL_SStatus0))
+		 & TSS_INT_PENDING))
+		 cpu_relax();
 
+	host->jsint = inb(host->addr + TUL_SInt);
 
-	while (!((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0))
-		 & TSS_INT_PENDING));
-
-	pCurHcb->HCS_JSInt = TUL_RD(pCurHcb->HCS_Base, TUL_SInt);
+	if (host->jsint & TSS_SCSIRST_INT)	/* if SCSI bus reset detected */
+		return int_initio_scsi_rst(host);
+	if (host->jsint & TSS_DISC_INT) {	/* BUS disconnection */
+		outb(TSC_FLUSH_FIFO, host->addr + TUL_SCtrl0);		/* Flush SCSI FIFO */
+		outb(TSC_INITDEFAULT, host->addr + TUL_SConfig);
+		outb(TSC_HW_RESELECT, host->addr + TUL_SCtrl1);		/* Enable HW reselect */
+		initio_unlink_busy_scb(host, host->active);
 
-
-	if (pCurHcb->HCS_JSInt & TSS_SCSIRST_INT) {	/* if SCSI bus reset detected   */
-		return (int_tul_scsi_rst(pCurHcb));
-	}
-	if (pCurHcb->HCS_JSInt & TSS_DISC_INT) {	/* BUS disconnection            */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl0, TSC_FLUSH_FIFO);		/* Flush SCSI FIFO  */
-		TUL_WR(pCurHcb->HCS_Base + TUL_SConfig, TSC_INITDEFAULT);
-		TUL_WR(pCurHcb->HCS_Base + TUL_SCtrl1, TSC_HW_RESELECT);	/* Enable HW reselect       */
-		tul_unlink_busy_scb(pCurHcb, pCurHcb->HCS_ActScb);
-
-		tul_append_done_scb(pCurHcb, pCurHcb->HCS_ActScb);
-		pCurHcb->HCS_ActScb = NULL;
-		return (-1);
+		initio_append_done_scb(host, host->active);
+		host->active = NULL;
+		return -1;
 	}
-	return (tul_bad_seq(pCurHcb));
+	return initio_bad_seq(host);
 }
 
+/**
+ *	i91u_intr		-	IRQ handler
+ *	@irqno: IRQ number
+ *	@dev_id: IRQ identifier
+ *
+ *	Take the relevant locks and then invoke the actual isr processing
+ *	code under the lock.
+ */
+
 static irqreturn_t i91u_intr(int irqno, void *dev_id)
 {
 	struct Scsi_Host *dev = dev_id;
 	unsigned long flags;
+	int r;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
-	tul_isr((HCS *)dev->base);
+	r = initio_isr((struct initio_host *)dev->hostdata);
 	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static int tul_NewReturnNumberOfAdapters(void)
-{
-	struct pci_dev *pDev = NULL;	/* Start from none              */
-	int iAdapters = 0;
-	long dRegValue;
-	WORD wBIOS;
-	int i = 0;
-
-	init_i91uAdapter_table();
-
-	for (i = 0; i < ARRAY_SIZE(i91u_pci_devices); i++)
-	{
-		while ((pDev = pci_find_device(i91u_pci_devices[i].vendor, i91u_pci_devices[i].device, pDev)) != NULL) {
-			if (pci_enable_device(pDev))
-				continue;
-			pci_read_config_dword(pDev, 0x44, (u32 *) & dRegValue);
-			wBIOS = (UWORD) (dRegValue & 0xFF);
-			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
-				dRegValue = 0;
-			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
-				printk(KERN_WARNING 
-				       "i91u: Could not set 32 bit DMA mask\n");
-				continue;
-			}
-
-			if (Addi91u_into_Adapter_table(wBIOS,
-							(pDev->resource[0].start),
-						       	pDev->irq,
-						       	pDev->bus->number,
-					       		(pDev->devfn >> 3)
-		    		) == 0)
-				iAdapters++;
-		}
-	}
-
-	return (iAdapters);
+	if (r)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
 }
 
-static int i91u_detect(struct scsi_host_template * tpnt)
-{
-	HCS *pHCB;
-	struct Scsi_Host *hreg;
-	unsigned long i;	/* 01/14/98                     */
-	int ok = 0, iAdapters;
-	ULONG dBiosAdr;
-	BYTE *pbBiosAdr;
-
-	/* Get total number of adapters in the motherboard */
-	iAdapters = tul_NewReturnNumberOfAdapters();
-	if (iAdapters == 0)	/* If no tulip founded, return */
-		return (0);
-
-	tul_num_ch = (iAdapters > tul_num_ch) ? tul_num_ch : iAdapters;
-	/* Update actually channel number */
-	if (tul_tag_enable) {	/* 1.01i                  */
-		tul_num_scb = MAX_TARGETS * i91u_MAXQUEUE;
-	} else {
-		tul_num_scb = MAX_TARGETS + 3;	/* 1-tape, 1-CD_ROM, 1- extra */
-	}			/* Update actually SCBs per adapter */
-
-	/* Get total memory needed for HCS */
-	i = tul_num_ch * sizeof(HCS);
-	memset((unsigned char *) &tul_hcs[0], 0, i);	/* Initialize tul_hcs 0 */
-	/* Get total memory needed for SCB */
-
-	for (; tul_num_scb >= MAX_TARGETS + 3; tul_num_scb--) {
-		i = tul_num_ch * tul_num_scb * sizeof(SCB);
-		if ((tul_scb = kmalloc(i, GFP_ATOMIC | GFP_DMA)) != NULL)
-			break;
-	}
-	if (tul_scb == NULL) {
-		printk("i91u: SCB memory allocation error\n");
-		return (0);
-	}
-	memset((unsigned char *) tul_scb, 0, i);
-
-	for (i = 0, pHCB = &tul_hcs[0];		/* Get pointer for control block */
-	     i < tul_num_ch;
-	     i++, pHCB++) {
-		get_tulipPCIConfig(pHCB, i);
-
-		dBiosAdr = pHCB->HCS_BIOS;
-		dBiosAdr = (dBiosAdr << 4);
-
-		pbBiosAdr = phys_to_virt(dBiosAdr);
-
-		init_tulip(pHCB, tul_scb + (i * tul_num_scb), tul_num_scb, pbBiosAdr, 10);
-		request_region(pHCB->HCS_Base, 256, "i91u"); /* Register */ 
-
-		pHCB->HCS_Index = i;	/* 7/29/98 */
-		hreg = scsi_register(tpnt, sizeof(HCS));
-		if(hreg == NULL) {
-			release_region(pHCB->HCS_Base, 256);
-			return 0;
-		}
-		hreg->io_port = pHCB->HCS_Base;
-		hreg->n_io_port = 0xff;
-		hreg->can_queue = tul_num_scb;	/* 03/05/98                      */
-		hreg->unique_id = pHCB->HCS_Base;
-		hreg->max_id = pHCB->HCS_MaxTar;
-		hreg->max_lun = 32;	/* 10/21/97                     */
-		hreg->irq = pHCB->HCS_Intr;
-		hreg->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index           */
-		hreg->base = (unsigned long)pHCB;
-		hreg->sg_tablesize = TOTAL_SG_ENTRY;	/* Maximun support is 32 */
-
-		/* Initial tulip chip           */
-		ok = request_irq(pHCB->HCS_Intr, i91u_intr, IRQF_DISABLED | IRQF_SHARED, "i91u", hreg);
-		if (ok < 0) {
-			printk(KERN_WARNING "i91u: unable to request IRQ %d\n\n", pHCB->HCS_Intr);
-			return 0;
-		}
-	}
-
-	tpnt->this_id = -1;
-	tpnt->can_queue = 1;
 
-	return 1;
-}
+/**
+ *	initio_build_scb		-	Build the mappings and SCB
+ *	@host: InitIO host taking the command
+ *	@cblk: Firmware command block
+ *	@cmnd: SCSI midlayer command block
+ *
+ *	Translate the abstract SCSI command into a firmware command block
+ *	suitable for feeding to the InitIO host controller. This also requires
+ *	we build the scatter gather lists and ensure they are mapped properly.
+ */
 
-static void i91uBuildSCB(HCS * pHCB, SCB * pSCB, struct scsi_cmnd * SCpnt)
+static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * cblk, struct scsi_cmnd * cmnd)
 {				/* Create corresponding SCB     */
-	struct scatterlist *pSrbSG;
-	SG *pSG;		/* Pointer to SG list           */
+	struct scatterlist *sglist;
+	struct sg_entry *sg;		/* Pointer to SG list           */
 	int i;
-	long TotalLen;
+	long total_len;
 	dma_addr_t dma_addr;
 
-	pSCB->SCB_Post = i91uSCBPost;	/* i91u's callback routine      */
-	pSCB->SCB_Srb = SCpnt;
-	pSCB->SCB_Opcode = ExecSCSI;
-	pSCB->SCB_Flags = SCF_POST;	/* After SCSI done, call post routine */
-	pSCB->SCB_Target = SCpnt->device->id;
-	pSCB->SCB_Lun = SCpnt->device->lun;
-	pSCB->SCB_Ident = SCpnt->device->lun | DISC_ALLOW;
+	/* Fill in the command headers */
+	cblk->post = i91uSCBPost;	/* i91u's callback routine      */
+	cblk->srb = cmnd;
+	cblk->opcode = ExecSCSI;
+	cblk->flags = SCF_POST;	/* After SCSI done, call post routine */
+	cblk->target = cmnd->device->id;
+	cblk->lun = cmnd->device->lun;
+	cblk->ident = cmnd->device->lun | DISC_ALLOW;
 
-	pSCB->SCB_Flags |= SCF_SENSE;	/* Turn on auto request sense   */
-	dma_addr = dma_map_single(&pHCB->pci_dev->dev, SCpnt->sense_buffer,
+	cblk->flags |= SCF_SENSE;	/* Turn on auto request sense   */
+	
+	/* Map the sense buffer into bus memory */
+	dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->sense_buffer,
 				  SENSE_SIZE, DMA_FROM_DEVICE);
-	pSCB->SCB_SensePtr = cpu_to_le32((u32)dma_addr);
-	pSCB->SCB_SenseLen = cpu_to_le32(SENSE_SIZE);
-	SCpnt->SCp.ptr = (char *)(unsigned long)dma_addr;
-
-	pSCB->SCB_CDBLen = SCpnt->cmd_len;
-	pSCB->SCB_HaStat = 0;
-	pSCB->SCB_TaStat = 0;
-	memcpy(&pSCB->SCB_CDB[0], &SCpnt->cmnd, SCpnt->cmd_len);
-
-	if (SCpnt->device->tagged_supported) {	/* Tag Support                  */
-		pSCB->SCB_TagMsg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
+	cblk->senseptr = cpu_to_le32((u32)dma_addr);
+	cblk->senselen = cpu_to_le32(SENSE_SIZE);
+	cmnd->SCp.ptr = (char *)(unsigned long)dma_addr;
+	cblk->cdblen = cmnd->cmd_len;
+
+	/* Clear the returned status */
+	cblk->hastat = 0;
+	cblk->tastat = 0;
+	/* Command the command */
+	memcpy(&cblk->cdb[0], &cmnd->cmnd, cmnd->cmd_len);
+
+	/* Set up tags */
+	if (cmnd->device->tagged_supported) {	/* Tag Support                  */
+		cblk->tagmsg = SIMPLE_QUEUE_TAG;	/* Do simple tag only   */
 	} else {
-		pSCB->SCB_TagMsg = 0;	/* No tag support               */
+		cblk->tagmsg = 0;	/* No tag support               */
 	}
+	
 	/* todo handle map_sg error */
-	if (SCpnt->use_sg) {
-		dma_addr = dma_map_single(&pHCB->pci_dev->dev, &pSCB->SCB_SGList[0],
-					  sizeof(struct SG_Struc) * TOTAL_SG_ENTRY,
+	if (cmnd->use_sg) {
+		dma_addr = dma_map_single(&host->pci_dev->dev, &cblk->sglist[0],
+					  sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
 					  DMA_BIDIRECTIONAL);
-		pSCB->SCB_BufPtr = cpu_to_le32((u32)dma_addr);
-		SCpnt->SCp.dma_handle = dma_addr;
+		cblk->bufptr = cpu_to_le32((u32)dma_addr);
+		cmnd->SCp.dma_handle = dma_addr;
 
-		pSrbSG = (struct scatterlist *) SCpnt->request_buffer;
-		pSCB->SCB_SGLen = dma_map_sg(&pHCB->pci_dev->dev, pSrbSG,
-					     SCpnt->use_sg, SCpnt->sc_data_direction);
-
-		pSCB->SCB_Flags |= SCF_SG;	/* Turn on SG list flag       */
-		for (i = 0, TotalLen = 0, pSG = &pSCB->SCB_SGList[0];	/* 1.01g */
-		     i < pSCB->SCB_SGLen; i++, pSG++, pSrbSG++) {
-			pSG->SG_Ptr = cpu_to_le32((u32)sg_dma_address(pSrbSG));
-			TotalLen += pSG->SG_Len = cpu_to_le32((u32)sg_dma_len(pSrbSG));
-		}
-
-		pSCB->SCB_BufLen = (SCpnt->request_bufflen > TotalLen) ?
-		    TotalLen : SCpnt->request_bufflen;
-	} else if (SCpnt->request_bufflen) {		/* Non SG */
-		dma_addr = dma_map_single(&pHCB->pci_dev->dev, SCpnt->request_buffer,
-					  SCpnt->request_bufflen,
-					  SCpnt->sc_data_direction);
-		SCpnt->SCp.dma_handle = dma_addr;
-		pSCB->SCB_BufPtr = cpu_to_le32((u32)dma_addr);
-		pSCB->SCB_BufLen = cpu_to_le32((u32)SCpnt->request_bufflen);
-		pSCB->SCB_SGLen = 0;
-	} else {
-		pSCB->SCB_BufLen = 0;
-		pSCB->SCB_SGLen = 0;
+		sglist = (struct scatterlist *) cmnd->request_buffer;
+		cblk->sglen = dma_map_sg(&host->pci_dev->dev, sglist,
+					     cmnd->use_sg, cmnd->sc_data_direction);
+
+		cblk->flags |= SCF_SG;	/* Turn on SG list flag       */
+		for (i = 0, total_len = 0, sg = &cblk->sglist[0];	/* 1.01g */
+		     i < cblk->sglen; i++, sg++, sglist++) {
+			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
+			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+		}
+
+		cblk->buflen = (cmnd->request_bufflen > total_len) ?
+		    total_len : cmnd->request_bufflen;
+	} else if (cmnd->request_bufflen) {		/* Non SG */
+		dma_addr = dma_map_single(&host->pci_dev->dev, cmnd->request_buffer,
+					  cmnd->request_bufflen,
+					  cmnd->sc_data_direction);
+		cmnd->SCp.dma_handle = dma_addr;
+		cblk->bufptr = cpu_to_le32((u32)dma_addr);
+		cblk->buflen = cpu_to_le32((u32)cmnd->request_bufflen);
+		cblk->sglen = 0;
+	} else {	/* No data transfer required */
+		cblk->buflen = 0;
+		cblk->sglen = 0;
 	}
 }
 
+/**
+ *	i91u_queuecommand	-	Queue a new command if possible
+ *	@cmd: SCSI command block from the mid layer
+ *	@done: Completion handler
+ *
+ *	Attempts to queue a new command with the host adapter. Will return
+ *	zero if successful or indicate a host busy condition if not (which
+ *	will cause the mid layer to call us again later with the command)
+ */
+
 static int i91u_queuecommand(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
-	HCS *pHCB = (HCS *) cmd->device->host->base;
-	register SCB *pSCB;
+	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
+	struct scsi_ctrl_blk *cmnd;
 
 	cmd->scsi_done = done;
 
-	pSCB = tul_alloc_scb(pHCB);
-	if (!pSCB)
+	cmnd = initio_alloc_scb(host);
+	if (!cmnd)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	i91uBuildSCB(pHCB, pSCB, cmd);
-	tul_exec_scb(pHCB, pSCB);
+	initio_build_scb(host, cmnd, cmd);
+	initio_exec_scb(host, cmnd);
 	return 0;
 }
 
-#if 0 /* no new EH yet */
-/*
- *  Abort a queued command
- *  (commands that are on the bus can't be aborted easily)
- */
-static int i91u_abort(struct scsi_cmnd * SCpnt)
-{
-	HCS *pHCB;
-
-	pHCB = (HCS *) SCpnt->device->host->base;
-	return tul_abort_srb(pHCB, SCpnt);
-}
-
-/*
- *  Reset registers, reset a hanging bus and
- *  kill active and disconnected commands for target w/o soft reset
+/**
+ *	i91u_bus_reset		-	reset the SCSI bus
+ *	@cmnd: Command block we want to trigger the reset for
+ *
+ *	Initiate a SCSI bus reset sequence
  */
-static int i91u_reset(struct scsi_cmnd * SCpnt, unsigned int reset_flags)
-{				/* I need Host Control Block Information */
-	HCS *pHCB;
-
-	pHCB = (HCS *) SCpnt->device->host->base;
 
-	if (reset_flags & (SCSI_RESET_SUGGEST_BUS_RESET | SCSI_RESET_SUGGEST_HOST_RESET))
-		return tul_reset_scsi_bus(pHCB);
-	else
-		return tul_device_reset(pHCB, SCpnt, SCpnt->device->id, reset_flags);
-}
-#endif
-
-static int i91u_bus_reset(struct scsi_cmnd * SCpnt)
+static int i91u_bus_reset(struct scsi_cmnd * cmnd)
 {
-	HCS *pHCB;
+	struct initio_host *host;
 
-	pHCB = (HCS *) SCpnt->device->host->base;
+	host = (struct initio_host *) cmnd->device->host->hostdata;
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
-	tul_reset_scsi(pHCB, 0);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(cmnd->device->host->host_lock);
+	initio_reset_scsi(host, 0);
+	spin_unlock_irq(cmnd->device->host->host_lock);
 
 	return SUCCESS;
 }
 
-/*
- * Return the "logical geometry"
+/**
+ *	i91u_biospararm			-	return the "logical geometry
+ *	@sdev: SCSI device
+ *	@dev; Matching block device
+ *	@capacity: Sector size of drive
+ *	@info_array: Return space for BIOS geometry
+ *
+ *	Map the device geometry in a manner compatible with the host
+ *	controller BIOS behaviour. 
+ *
+ *	FIXME: limited to 2^32 sector devices.
  */
+
 static int i91u_biosparam(struct scsi_device *sdev, struct block_device *dev,
 		sector_t capacity, int *info_array)
 {
-	HCS *pHcb;		/* Point to Host adapter control block */
-	TCS *pTcb;
+	struct initio_host *host;		/* Point to Host adapter control block */
+	struct target_control *tc;
 
-	pHcb = (HCS *) sdev->host->base;
-	pTcb = &pHcb->HCS_Tcs[sdev->id];
+	host = (struct initio_host *) sdev->host->hostdata;
+	tc = &host->targets[sdev->id];
 
-	if (pTcb->TCS_DrvHead) {
-		info_array[0] = pTcb->TCS_DrvHead;
-		info_array[1] = pTcb->TCS_DrvSector;
-		info_array[2] = (unsigned long)capacity / pTcb->TCS_DrvHead / pTcb->TCS_DrvSector;
+	if (tc->heads) {
+		info_array[0] = tc->heads;
+		info_array[1] = tc->sectors;
+		info_array[2] = (unsigned long)capacity / tc->heads / tc->sectors;
 	} else {
-		if (pTcb->TCS_DrvFlags & TCF_DRV_255_63) {
+		if (tc->drv_flags & TCF_DRV_255_63) {
 			info_array[0] = 255;
 			info_array[1] = 63;
 			info_array[2] = (unsigned long)capacity / 255 / 63;
@@ -3047,7 +2740,16 @@
 	return 0;
 }
 
-static void i91u_unmap_cmnd(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
+/**
+ *	i91u_unmap_scb		-	Unmap a command
+ *	@pci_dev: PCI device the command is for
+ *	@cmnd: The command itself
+ *
+ *	Unmap any PCI mapping/IOMMU resources allocated when the command
+ *	was mapped originally as part of initio_build_scb
+ */
+
+static void i91u_unmap_scb(struct pci_dev *pci_dev, struct scsi_cmnd *cmnd)
 {
 	/* auto sense buffer */
 	if (cmnd->SCp.ptr) {
@@ -3060,7 +2762,7 @@
 	/* request buffer */
 	if (cmnd->use_sg) {
 		dma_unmap_single(&pci_dev->dev, cmnd->SCp.dma_handle,
-				 sizeof(struct SG_Struc) * TOTAL_SG_ENTRY,
+				 sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
 				 DMA_BIDIRECTIONAL);
 
 		dma_unmap_sg(&pci_dev->dev, cmnd->request_buffer,
@@ -3073,50 +2775,54 @@
 	}
 }
 
-/*****************************************************************************
- Function name  : i91uSCBPost
- Description    : This is callback routine be called when tulip finish one
-			SCSI command.
- Input          : pHCB  -       Pointer to host adapter control block.
-		  pSCB  -       Pointer to SCSI control block.
- Output         : None.
- Return         : None.
-*****************************************************************************/
-static void i91uSCBPost(BYTE * pHcb, BYTE * pScb)
-{
-	struct scsi_cmnd *pSRB;	/* Pointer to SCSI request block */
-	HCS *pHCB;
-	SCB *pSCB;
-
-	pHCB = (HCS *) pHcb;
-	pSCB = (SCB *) pScb;
-	if ((pSRB = pSCB->SCB_Srb) == 0) {
-		printk("i91uSCBPost: SRB pointer is empty\n");
+/**
+ *	i91uSCBPost		-	SCSI callback
+ *	@host: Pointer to host adapter control block.
+ *	@cmnd: Pointer to SCSI control block.
+ *
+ *	This is callback routine be called when tulip finish one
+ *	SCSI command.
+ */
 
-		tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
+static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
+{
+	struct scsi_cmnd *cmnd;	/* Pointer to SCSI request block */
+	struct initio_host *host;
+	struct scsi_ctrl_blk *cblk;
+
+	host = (struct initio_host *) host_mem;
+	cblk = (struct scsi_ctrl_blk *) cblk_mem;
+	if ((cmnd = cblk->srb) == NULL) {
+		printk(KERN_ERR "i91uSCBPost: SRB pointer is empty\n");
+		WARN_ON(1);
+		initio_release_scb(host, cblk);	/* Release SCB for current channel */
 		return;
 	}
-	switch (pSCB->SCB_HaStat) {
+	
+	/*
+	 *	Remap the firmware error status into a mid layer one
+	 */
+	switch (cblk->hastat) {
 	case 0x0:
 	case 0xa:		/* Linked command complete without error and linked normally */
 	case 0xb:		/* Linked command complete without error interrupt generated */
-		pSCB->SCB_HaStat = 0;
+		cblk->hastat = 0;
 		break;
 
 	case 0x11:		/* Selection time out-The initiator selection or target
 				   reselection was not complete within the SCSI Time out period */
-		pSCB->SCB_HaStat = DID_TIME_OUT;
+		cblk->hastat = DID_TIME_OUT;
 		break;
 
 	case 0x14:		/* Target bus phase sequence failure-An invalid bus phase or bus
 				   phase sequence was requested by the target. The host adapter
 				   will generate a SCSI Reset Condition, notifying the host with
 				   a SCRD interrupt */
-		pSCB->SCB_HaStat = DID_RESET;
+		cblk->hastat = DID_RESET;
 		break;
 
 	case 0x1a:		/* SCB Aborted. 07/21/98 */
-		pSCB->SCB_HaStat = DID_ABORT;
+		cblk->hastat = DID_ABORT;
 		break;
 
 	case 0x12:		/* Data overrun/underrun-The target attempted to transfer more data
@@ -3126,49 +2832,196 @@
 	case 0x16:		/* Invalid SCB Operation Code. */
 
 	default:
-		printk("ini9100u: %x %x\n", pSCB->SCB_HaStat, pSCB->SCB_TaStat);
-		pSCB->SCB_HaStat = DID_ERROR;	/* Couldn't find any better */
+		printk("ini9100u: %x %x\n", cblk->hastat, cblk->tastat);
+		cblk->hastat = DID_ERROR;	/* Couldn't find any better */
 		break;
 	}
 
-	pSRB->result = pSCB->SCB_TaStat | (pSCB->SCB_HaStat << 16);
+	cmnd->result = cblk->tastat | (cblk->hastat << 16);
+	WARN_ON(cmnd == NULL);
+	i91u_unmap_scb(host->pci_dev, cmnd);
+	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
+	initio_release_scb(host, cblk);	/* Release SCB for current channel */
+}
+
+static struct scsi_host_template initio_template = {
+	.proc_name		= "INI9100U",
+	.name			= "Initio INI-9X00U/UW SCSI device driver",
+	.queuecommand		= i91u_queuecommand,
+	.eh_bus_reset_handler	= i91u_bus_reset,
+	.bios_param		= i91u_biosparam,
+	.can_queue		= MAX_TARGETS * i91u_MAXQUEUE,
+	.this_id		= 1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
 
-	if (pSRB == NULL) {
-		printk("pSRB is NULL\n");
+static int initio_probe_one(struct pci_dev *pdev,
+	const struct pci_device_id *id)
+{
+	struct Scsi_Host *shost;
+	struct initio_host *host;
+	u32 reg;
+	u16 bios_seg;
+	struct scsi_ctrl_blk *scb, *tmp, *prev = NULL /* silence gcc */;
+	int num_scb, i, error;
+
+	error = pci_enable_device(pdev);
+	if (error)
+		return error;
+
+	pci_read_config_dword(pdev, 0x44, (u32 *) & reg);
+	bios_seg = (u16) (reg & 0xFF);
+	if (((reg & 0xFF00) >> 8) == 0xFF)
+		reg = 0;
+	bios_seg = (bios_seg << 8) + ((u16) ((reg & 0xFF00) >> 8));
+
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		printk(KERN_WARNING  "i91u: Could not set 32 bit DMA mask\n");
+		error = -ENODEV;
+		goto out_disable_device;
+	}
+	shost = scsi_host_alloc(&initio_template, sizeof(struct initio_host));
+	if (!shost) {
+		printk(KERN_WARNING "initio: Could not allocate host structure.\n");
+		error = -ENOMEM;
+		goto out_disable_device;
+	}
+	host = (struct initio_host *)shost->hostdata;
+	memset(host, 0, sizeof(struct initio_host));
+
+	if (!request_region(host->addr, 256, "i91u")) {
+		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
+		error = -ENODEV;
+		goto out_host_put;
 	}
 
-	i91u_unmap_cmnd(pHCB->pci_dev, pSRB);
-	pSRB->scsi_done(pSRB);	/* Notify system DONE           */
+	if (initio_tag_enable)	/* 1.01i */
+		num_scb = MAX_TARGETS * i91u_MAXQUEUE;
+	else
+		num_scb = MAX_TARGETS + 3;	/* 1-tape, 1-CD_ROM, 1- extra */
 
-	tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
-}
+	for (; num_scb >= MAX_TARGETS + 3; num_scb--) {
+		i = num_scb * sizeof(struct scsi_ctrl_blk);
+		if ((scb = kzalloc(i, GFP_DMA)) != NULL)
+			break;
+	}
+
+	if (!scb) {
+		printk(KERN_WARNING "initio: Cannot allocate SCB array.\n");
+		error = -ENOMEM;
+		goto out_release_region;
+	}
 
-/*
- * Release ressources
+	host->num_scbs = num_scb;
+	host->scb = scb;
+	host->next_pending = scb;
+	host->next_avail = scb;
+	for (i = 0, tmp = scb; i < num_scb; i++, tmp++) {
+		tmp->tagid = i;
+		if (i != 0)
+			prev->next = tmp;
+		prev = tmp;
+	}
+	prev->next = NULL;
+	host->scb_end = tmp;
+	host->first_avail = scb;
+	host->last_avail = prev;
+
+	initio_init(host, phys_to_virt(bios_seg << 4));
+
+	host->jsstatus0 = 0;
+
+	shost->io_port = host->addr;
+	shost->n_io_port = 0xff;
+	shost->can_queue = num_scb;		/* 03/05/98                      */
+	shost->unique_id = host->addr;
+	shost->max_id = host->max_tar;
+	shost->max_lun = 32;	/* 10/21/97                     */
+	shost->irq = pdev->irq;
+	shost->this_id = host->scsi_id;	/* Assign HCS index           */
+	shost->base = host->addr;
+	shost->sg_tablesize = TOTAL_SG_ENTRY;
+
+	error = request_irq(pdev->irq, i91u_intr, IRQF_DISABLED|IRQF_SHARED, "i91u", shost);
+	if (error < 0) {
+		printk(KERN_WARNING "initio: Unable to request IRQ %d\n", pdev->irq);
+		goto out_free_scbs;
+	}
+
+	pci_set_drvdata(pdev, shost);
+	host->pci_dev = pdev;
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_free_irq;
+	scsi_scan_host(shost);
+	return 0;
+out_free_irq:
+	free_irq(pdev->irq, shost);
+out_free_scbs:
+	kfree(host->scb);
+out_release_region:
+	release_region(host->addr, 256);
+out_host_put:
+	scsi_host_put(shost);
+out_disable_device:
+	pci_disable_device(pdev);
+	return error;
+}
+
+/**
+ *	initio_remove_one	-	control shutdown
+ *	@pdev:	PCI device being released
+ *
+ *	Release the resources assigned to this adapter after it has
+ *	finished being used.
  */
-static int i91u_release(struct Scsi_Host *hreg)
+
+static void initio_remove_one(struct pci_dev *pdev)
 {
-	free_irq(hreg->irq, hreg);
-	release_region(hreg->io_port, 256);
-	return 0;
-}
-MODULE_LICENSE("Dual BSD/GPL");
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct initio_host *s = (struct initio_host *)host->hostdata;
+	scsi_remove_host(host);
+	free_irq(pdev->irq, host);
+	release_region(s->addr, 256);
+	scsi_host_put(host);
+	pci_disable_device(pdev);
+}
+
+MODULE_LICENSE("GPL");
+
+static struct pci_device_id initio_pci_tbl[] = {
+	{PCI_VENDOR_ID_INIT, 0x9500, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x9400, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x9401, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INIT, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_DOMEX, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, initio_pci_tbl);
 
-static struct scsi_host_template driver_template = {
-	.proc_name	= "INI9100U",
-	.name		= i91u_REVID,
-	.detect		= i91u_detect,
-	.release	= i91u_release,
-	.queuecommand	= i91u_queuecommand,
-//	.abort		= i91u_abort,
-//	.reset		= i91u_reset,
-	.eh_bus_reset_handler = i91u_bus_reset,
-	.bios_param	= i91u_biosparam,
-	.can_queue	= 1,
-	.this_id	= 1,
-	.sg_tablesize	= SG_ALL,
-	.cmd_per_lun 	= 1,
-	.use_clustering	= ENABLE_CLUSTERING,
+static struct pci_driver initio_pci_driver = {
+	.name		= "initio",
+	.id_table	= initio_pci_tbl,
+	.probe		= initio_probe_one,
+	.remove		= __devexit_p(initio_remove_one),
 };
-#include "scsi_module.c"
 
+static int __init initio_init_driver(void)
+{
+	return pci_register_driver(&initio_pci_driver);
+}
+
+static void __exit initio_exit_driver(void)
+{
+	pci_unregister_driver(&initio_pci_driver);
+}
+
+MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
+MODULE_AUTHOR("Initio Corporation");
+MODULE_LICENSE("GPL");
+
+module_init(initio_init_driver);
+module_exit(initio_exit_driver);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/drivers/scsi/initio.h linux-2.6.22-rc1-mm1/drivers/scsi/initio.h
--- linux.vanilla-2.6.22-rc1-mm1/drivers/scsi/initio.h	2007-04-30 10:48:03.000000000 +0100
+++ linux-2.6.22-rc1-mm1/drivers/scsi/initio.h	2007-05-18 16:37:10.000000000 +0100
@@ -4,6 +4,8 @@
  * Copyright (c) 1994-1998 Initio Corporation
  * All rights reserved.
  *
+ * Cleanups (c) Copyright 2007 Red Hat <alan@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2, or (at your option)
@@ -18,27 +20,6 @@
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
@@ -56,17 +37,6 @@
 
 #include <linux/types.h>
 
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
 #define TOTAL_SG_ENTRY		32
 #define MAX_SUPPORTED_ADAPTERS  8
 #define MAX_OFFSET		15
@@ -368,55 +338,55 @@
 /************************************************************************/
 /*              Scatter-Gather Element Structure                        */
 /************************************************************************/
-typedef struct SG_Struc {
-	U32 SG_Ptr;		/* Data Pointer */
-	U32 SG_Len;		/* Data Length */
-} SG;
+struct sg_entry {
+	u32 data;		/* Data Pointer */
+	u32 len;		/* Data Length */
+};
 
 /***********************************************************************
 		SCSI Control Block
 ************************************************************************/
-typedef struct Scsi_Ctrl_Blk {
-	struct Scsi_Ctrl_Blk *SCB_NxtScb;
-	UBYTE SCB_Status;	/*4 */
-	UBYTE SCB_NxtStat;	/*5 */
-	UBYTE SCB_Mode;		/*6 */
-	UBYTE SCB_Msgin;	/*7 SCB_Res0 */
-	UWORD SCB_SGIdx;	/*8 */
-	UWORD SCB_SGMax;	/*A */
+struct scsi_ctrl_blk {
+	struct scsi_ctrl_blk *next;
+	u8 status;	/*4 */
+	u8 next_state;	/*5 */
+	u8 mode;		/*6 */
+	u8 msgin;	/*7 SCB_Res0 */
+	u16 sgidx;	/*8 */
+	u16 sgmax;	/*A */
 #ifdef ALPHA
-	U32 SCB_Reserved[2];	/*C */
+	u32 reserved[2];	/*C */
 #else
-	U32 SCB_Reserved[3];	/*C */
+	u32 reserved[3];	/*C */
 #endif
 
-	U32 SCB_XferLen;	/*18 Current xfer len           */
-	U32 SCB_TotXLen;	/*1C Total xfer len             */
-	U32 SCB_PAddr;		/*20 SCB phy. Addr. */
-
-	UBYTE SCB_Opcode;	/*24 SCB command code */
-	UBYTE SCB_Flags;	/*25 SCB Flags */
-	UBYTE SCB_Target;	/*26 Target Id */
-	UBYTE SCB_Lun;		/*27 Lun */
-	U32 SCB_BufPtr;		/*28 Data Buffer Pointer */
-	U32 SCB_BufLen;		/*2C Data Allocation Length */
-	UBYTE SCB_SGLen;	/*30 SG list # */
-	UBYTE SCB_SenseLen;	/*31 Sense Allocation Length */
-	UBYTE SCB_HaStat;	/*32 */
-	UBYTE SCB_TaStat;	/*33 */
-	UBYTE SCB_CDBLen;	/*34 CDB Length */
-	UBYTE SCB_Ident;	/*35 Identify */
-	UBYTE SCB_TagMsg;	/*36 Tag Message */
-	UBYTE SCB_TagId;	/*37 Queue Tag */
-	UBYTE SCB_CDB[12];	/*38 */
-	U32 SCB_SGPAddr;	/*44 SG List/Sense Buf phy. Addr. */
-	U32 SCB_SensePtr;	/*48 Sense data pointer */
-	void (*SCB_Post) (BYTE *, BYTE *);	/*4C POST routine */
-	struct scsi_cmnd *SCB_Srb;	/*50 SRB Pointer */
-	SG SCB_SGList[TOTAL_SG_ENTRY];	/*54 Start of SG list */
-} SCB;
+	u32 xferlen;	/*18 Current xfer len           */
+	u32 totxlen;	/*1C Total xfer len             */
+	u32 paddr;		/*20 SCB phy. Addr. */
+
+	u8 opcode;	/*24 SCB command code */
+	u8 flags;	/*25 SCB Flags */
+	u8 target;	/*26 Target Id */
+	u8 lun;		/*27 Lun */
+	u32 bufptr;		/*28 Data Buffer Pointer */
+	u32 buflen;		/*2C Data Allocation Length */
+	u8 sglen;	/*30 SG list # */
+	u8 senselen;	/*31 Sense Allocation Length */
+	u8 hastat;	/*32 */
+	u8 tastat;	/*33 */
+	u8 cdblen;	/*34 CDB Length */
+	u8 ident;	/*35 Identify */
+	u8 tagmsg;	/*36 Tag Message */
+	u8 tagid;	/*37 Queue Tag */
+	u8 cdb[12];	/*38 */
+	u32 sgpaddr;	/*44 SG List/Sense Buf phy. Addr. */
+	u32 senseptr;	/*48 Sense data pointer */
+	void (*post) (u8 *, u8 *);	/*4C POST routine */
+	struct scsi_cmnd *srb;	/*50 SRB Pointer */
+	struct sg_entry sglist[TOTAL_SG_ENTRY];	/*54 Start of SG list */
+};
 
-/* Bit Definition for SCB_Status */
+/* Bit Definition for status */
 #define SCB_RENT        0x01
 #define SCB_PEND        0x02
 #define SCB_CONTIG      0x04	/* Contigent Allegiance */
@@ -425,17 +395,17 @@
 #define SCB_DONE        0x20
 
 
-/* Opcodes of SCB_Opcode */
+/* Opcodes for opcode */
 #define ExecSCSI        0x1
 #define BusDevRst       0x2
 #define AbortCmd        0x3
 
 
-/* Bit Definition for SCB_Mode */
+/* Bit Definition for mode */
 #define SCM_RSENS       0x01	/* request sense mode */
 
 
-/* Bit Definition for SCB_Flags */
+/* Bit Definition for flags */
 #define SCF_DONE        0x01
 #define SCF_POST        0x02
 #define SCF_SENSE       0x04
@@ -492,15 +462,14 @@
 		Target Device Control Structure
 **********************************************************************/
 
-typedef struct Tar_Ctrl_Struc {
-	UWORD TCS_Flags;	/* 0 */
-	UBYTE TCS_JS_Period;	/* 2 */
-	UBYTE TCS_SConfig0;	/* 3 */
-
-	UWORD TCS_DrvFlags;	/* 4 */
-	UBYTE TCS_DrvHead;	/* 6 */
-	UBYTE TCS_DrvSector;	/* 7 */
-} TCS;
+struct target_control {
+	u16 flags;
+	u8 js_period;
+	u8 sconfig0;
+	u16 drv_flags;
+	u8 heads;
+	u8 sectors;
+};
 
 /***********************************************************************
 		Target Device Control Structure
@@ -523,62 +492,53 @@
 #define TCF_DRV_EN_TAG          0x0800
 #define TCF_DRV_255_63          0x0400
 
-typedef struct I91u_Adpt_Struc {
-	UWORD ADPT_BIOS;	/* 0 */
-	UWORD ADPT_BASE;	/* 1 */
-	UBYTE ADPT_Bus;		/* 2 */
-	UBYTE ADPT_Device;	/* 3 */
-	UBYTE ADPT_INTR;	/* 4 */
-} INI_ADPT_STRUCT;
-
-
 /***********************************************************************
 	      Host Adapter Control Structure
 ************************************************************************/
-typedef struct Ha_Ctrl_Struc {
-	UWORD HCS_Base;		/* 00 */
-	UWORD HCS_BIOS;		/* 02 */
-	UBYTE HCS_Intr;		/* 04 */
-	UBYTE HCS_SCSI_ID;	/* 05 */
-	UBYTE HCS_MaxTar;	/* 06 */
-	UBYTE HCS_NumScbs;	/* 07 */
-
-	UBYTE HCS_Flags;	/* 08 */
-	UBYTE HCS_Index;	/* 09 */
-	UBYTE HCS_HaId;		/* 0A */
-	UBYTE HCS_Config;	/* 0B */
-	UWORD HCS_IdMask;	/* 0C */
-	UBYTE HCS_Semaph;	/* 0E */
-	UBYTE HCS_Phase;	/* 0F */
-	UBYTE HCS_JSStatus0;	/* 10 */
-	UBYTE HCS_JSInt;	/* 11 */
-	UBYTE HCS_JSStatus1;	/* 12 */
-	UBYTE HCS_SConf1;	/* 13 */
-
-	UBYTE HCS_Msg[8];	/* 14 */
-	SCB *HCS_NxtAvail;	/* 1C */
-	SCB *HCS_Scb;		/* 20 */
-	SCB *HCS_ScbEnd;	/* 24 */
-	SCB *HCS_NxtPend;	/* 28 */
-	SCB *HCS_NxtContig;	/* 2C */
-	SCB *HCS_ActScb;	/* 30 */
-	TCS *HCS_ActTcs;	/* 34 */
-
-	SCB *HCS_FirstAvail;	/* 38 */
-	SCB *HCS_LastAvail;	/* 3C */
-	SCB *HCS_FirstPend;	/* 40 */
-	SCB *HCS_LastPend;	/* 44 */
-	SCB *HCS_FirstBusy;	/* 48 */
-	SCB *HCS_LastBusy;	/* 4C */
-	SCB *HCS_FirstDone;	/* 50 */
-	SCB *HCS_LastDone;	/* 54 */
-	UBYTE HCS_MaxTags[16];	/* 58 */
-	UBYTE HCS_ActTags[16];	/* 68 */
-	TCS HCS_Tcs[MAX_TARGETS];	/* 78 */
-	spinlock_t HCS_AvailLock;
-	spinlock_t HCS_SemaphLock;
+struct initio_host {
+	u16 addr;		/* 00 */
+	u16 bios_addr;		/* 02 */
+	u8 irq;			/* 04 */
+	u8 scsi_id;		/* 05 */
+	u8 max_tar;		/* 06 */
+	u8 num_scbs;		/* 07 */
+
+	u8 flags;		/* 08 */
+	u8 index;		/* 09 */
+	u8 ha_id;		/* 0A */
+	u8 config;		/* 0B */
+	u16 idmask;		/* 0C */
+	u8 semaph;		/* 0E */
+	u8 phase;		/* 0F */
+	u8 jsstatus0;		/* 10 */
+	u8 jsint;		/* 11 */
+	u8 jsstatus1;		/* 12 */
+	u8 sconf1;		/* 13 */
+
+	u8 msg[8];		/* 14 */
+	struct scsi_ctrl_blk *next_avail;	/* 1C */
+	struct scsi_ctrl_blk *scb;		/* 20 */
+	struct scsi_ctrl_blk *scb_end;		/* 24 */ /*UNUSED*/
+	struct scsi_ctrl_blk *next_pending;	/* 28 */
+	struct scsi_ctrl_blk *next_contig;	/* 2C */ /*UNUSED*/
+	struct scsi_ctrl_blk *active;		/* 30 */
+	struct target_control *active_tc;	/* 34 */
+
+	struct scsi_ctrl_blk *first_avail;	/* 38 */
+	struct scsi_ctrl_blk *last_avail;	/* 3C */
+	struct scsi_ctrl_blk *first_pending;	/* 40 */
+	struct scsi_ctrl_blk *last_pending;	/* 44 */
+	struct scsi_ctrl_blk *first_busy;	/* 48 */
+	struct scsi_ctrl_blk *last_busy;	/* 4C */
+	struct scsi_ctrl_blk *first_done;	/* 50 */
+	struct scsi_ctrl_blk *last_done;	/* 54 */
+	u8 max_tags[16];	/* 58 */
+	u8 act_tags[16];	/* 68 */
+	struct target_control targets[MAX_TARGETS];	/* 78 */
+	spinlock_t avail_lock;
+	spinlock_t semaph_lock;
 	struct pci_dev *pci_dev;
-} HCS;
+};
 
 /* Bit Definition for HCB_Config */
 #define HCC_SCSI_RESET          0x01
@@ -599,47 +559,47 @@
 *******************************************************************/
 
 typedef struct _NVRAM_SCSI {	/* SCSI channel configuration   */
-	UCHAR NVM_ChSCSIID;	/* 0Ch -> Channel SCSI ID       */
-	UCHAR NVM_ChConfig1;	/* 0Dh -> Channel config 1      */
-	UCHAR NVM_ChConfig2;	/* 0Eh -> Channel config 2      */
-	UCHAR NVM_NumOfTarg;	/* 0Fh -> Number of SCSI target */
+	u8 NVM_ChSCSIID;	/* 0Ch -> Channel SCSI ID       */
+	u8 NVM_ChConfig1;	/* 0Dh -> Channel config 1      */
+	u8 NVM_ChConfig2;	/* 0Eh -> Channel config 2      */
+	u8 NVM_NumOfTarg;	/* 0Fh -> Number of SCSI target */
 	/* SCSI target configuration    */
-	UCHAR NVM_Targ0Config;	/* 10h -> Target 0 configuration */
-	UCHAR NVM_Targ1Config;	/* 11h -> Target 1 configuration */
-	UCHAR NVM_Targ2Config;	/* 12h -> Target 2 configuration */
-	UCHAR NVM_Targ3Config;	/* 13h -> Target 3 configuration */
-	UCHAR NVM_Targ4Config;	/* 14h -> Target 4 configuration */
-	UCHAR NVM_Targ5Config;	/* 15h -> Target 5 configuration */
-	UCHAR NVM_Targ6Config;	/* 16h -> Target 6 configuration */
-	UCHAR NVM_Targ7Config;	/* 17h -> Target 7 configuration */
-	UCHAR NVM_Targ8Config;	/* 18h -> Target 8 configuration */
-	UCHAR NVM_Targ9Config;	/* 19h -> Target 9 configuration */
-	UCHAR NVM_TargAConfig;	/* 1Ah -> Target A configuration */
-	UCHAR NVM_TargBConfig;	/* 1Bh -> Target B configuration */
-	UCHAR NVM_TargCConfig;	/* 1Ch -> Target C configuration */
-	UCHAR NVM_TargDConfig;	/* 1Dh -> Target D configuration */
-	UCHAR NVM_TargEConfig;	/* 1Eh -> Target E configuration */
-	UCHAR NVM_TargFConfig;	/* 1Fh -> Target F configuration */
+	u8 NVM_Targ0Config;	/* 10h -> Target 0 configuration */
+	u8 NVM_Targ1Config;	/* 11h -> Target 1 configuration */
+	u8 NVM_Targ2Config;	/* 12h -> Target 2 configuration */
+	u8 NVM_Targ3Config;	/* 13h -> Target 3 configuration */
+	u8 NVM_Targ4Config;	/* 14h -> Target 4 configuration */
+	u8 NVM_Targ5Config;	/* 15h -> Target 5 configuration */
+	u8 NVM_Targ6Config;	/* 16h -> Target 6 configuration */
+	u8 NVM_Targ7Config;	/* 17h -> Target 7 configuration */
+	u8 NVM_Targ8Config;	/* 18h -> Target 8 configuration */
+	u8 NVM_Targ9Config;	/* 19h -> Target 9 configuration */
+	u8 NVM_TargAConfig;	/* 1Ah -> Target A configuration */
+	u8 NVM_TargBConfig;	/* 1Bh -> Target B configuration */
+	u8 NVM_TargCConfig;	/* 1Ch -> Target C configuration */
+	u8 NVM_TargDConfig;	/* 1Dh -> Target D configuration */
+	u8 NVM_TargEConfig;	/* 1Eh -> Target E configuration */
+	u8 NVM_TargFConfig;	/* 1Fh -> Target F configuration */
 } NVRAM_SCSI;
 
 typedef struct _NVRAM {
 /*----------header ---------------*/
-	USHORT NVM_Signature;	/* 0,1: Signature */
-	UCHAR NVM_Size;		/* 2:   Size of data structure */
-	UCHAR NVM_Revision;	/* 3:   Revision of data structure */
+	u16 NVM_Signature;	/* 0,1: Signature */
+	u8 NVM_Size;		/* 2:   Size of data structure */
+	u8 NVM_Revision;	/* 3:   Revision of data structure */
 	/* ----Host Adapter Structure ---- */
-	UCHAR NVM_ModelByte0;	/* 4:   Model number (byte 0) */
-	UCHAR NVM_ModelByte1;	/* 5:   Model number (byte 1) */
-	UCHAR NVM_ModelInfo;	/* 6:   Model information         */
-	UCHAR NVM_NumOfCh;	/* 7:   Number of SCSI channel */
-	UCHAR NVM_BIOSConfig1;	/* 8:   BIOS configuration 1  */
-	UCHAR NVM_BIOSConfig2;	/* 9:   BIOS configuration 2  */
-	UCHAR NVM_HAConfig1;	/* A:   Hoat adapter configuration 1 */
-	UCHAR NVM_HAConfig2;	/* B:   Hoat adapter configuration 2 */
+	u8 NVM_ModelByte0;	/* 4:   Model number (byte 0) */
+	u8 NVM_ModelByte1;	/* 5:   Model number (byte 1) */
+	u8 NVM_ModelInfo;	/* 6:   Model information         */
+	u8 NVM_NumOfCh;	/* 7:   Number of SCSI channel */
+	u8 NVM_BIOSConfig1;	/* 8:   BIOS configuration 1  */
+	u8 NVM_BIOSConfig2;	/* 9:   BIOS configuration 2  */
+	u8 NVM_HAConfig1;	/* A:   Hoat adapter configuration 1 */
+	u8 NVM_HAConfig2;	/* B:   Hoat adapter configuration 2 */
 	NVRAM_SCSI NVM_SCSIInfo[2];
-	UCHAR NVM_reserved[10];
+	u8 NVM_reserved[10];
 	/* ---------- CheckSum ----------       */
-	USHORT NVM_CheckSum;	/* 0x3E, 0x3F: Checksum of NVRam        */
+	u16 NVM_CheckSum;	/* 0x3E, 0x3F: Checksum of NVRam        */
 } NVRAM, *PNVRAM;
 
 /* Bios Configuration for nvram->BIOSConfig1                            */
@@ -681,19 +641,6 @@
 #define DISC_ALLOW              0xC0	/* Disconnect is allowed        */
 #define SCSICMD_RequestSense    0x03
 
-typedef struct _HCSinfo {
-	ULONG base;
-	UCHAR vec;
-	UCHAR bios;		/* High byte of BIOS address */
-	USHORT BaseAndBios;	/* high byte: pHcsInfo->bios,low byte:pHcsInfo->base */
-} HCSINFO;
-
-#define TUL_RD(x,y)             (UCHAR)(inb(  (int)((ULONG)(x+y)) ))
-#define TUL_RDLONG(x,y)         (ULONG)(inl((int)((ULONG)(x+y)) ))
-#define TUL_WR(     adr,data)   outb( (UCHAR)(data), (int)(adr))
-#define TUL_WRSHORT(adr,data)   outw( (UWORD)(data), (int)(adr))
-#define TUL_WRLONG( adr,data)   outl( (ULONG)(data), (int)(adr))
-
 #define SCSI_ABORT_SNOOZE 0
 #define SCSI_ABORT_SUCCESS 1
 #define SCSI_ABORT_PENDING 2

for a bit or as "initio2" so we have both for a bit then remove the old
one.


