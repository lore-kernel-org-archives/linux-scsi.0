From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [18/27]
Date: Thu, 17 Feb 2005 12:37:14 -0500
Message-ID: <4214D64A.7000801@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:25746 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262315AbVBQRh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:27 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbIr31416
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:18 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbIb21416
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hardware registers macro definitions.  Part 1/2.

diff -Nru a/drivers/scsi/adp94xx/adp94xx_reg.h b/drivers/scsi/adp94xx/adp94xx_reg.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/adp94xx_reg.h	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,1224 @@
+/*
+ * Adaptec ADP94xx SAS HBA device driver for Linux.
+ * Hardware registers defintions.
+ *
+ * Written by : David Chaw <david_chaw@adaptec.com>
+ *   
+ * Copyright (c) 2004 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * $Id: //depot/razor/linux/src/adp94xx_reg.h#43 $
+ * 
+ */	
+
+#ifndef ADP94XX_REG_H
+#define ADP94XX_REG_H
+
+/* 
+ * Temporarily definition for which sequencer to use. 
+ * Enabled all three versions, during runtime driver will decide which code
+ * to load based on the controller attached. 
+ */
+#define SAS_SEQUENCER_A1	1		/*
+						 * SAS Sequencer for A1 board
+						 * and COMSTOCK (RTL #14).
+						 */
+#define SAS_SEQUENCER_B0	1		/*
+						 * SAS Sequencer for B0 board
+						 * or latest COMSTOCK RTL.
+						 */
+#define SAS_COMSTOCK_SUPPORT	0		/* 
+						 * Specific workaround logic
+						 * for COMSTOCK support.
+						 */
+#define SAS_ENABLE_NOTIFY	1		/*
+						 * Issue NOTIFY (ENABLE SPINUP)
+						 * primitive to the drive.
+						 */
+
+/*
+ * Common definitions.
+ */
+#define SCB_SIZE		128		/* Max SCB size */
+#define DDB_SIZE		64		/* Max DDB size */
+#define CSCRMEM_SIZE		1024		/* CSEQ Scratch Memory size */
+#define LSCRMEM_SIZE		512		/* LSEQ Scratch Memory size */
+#define CSEQ_MODE_PAGE_SIZE	0x200		/* CSEQ mode page size */
+#define LmSEQ_MODE_PAGE_SIZE	0x200		/* LmSEQ mode page size */
+#define LmSEQ_HOST_REG_SIZE   	0x4000		/* LmSEQ Host Register size */
+
+ 
+/********************** COM_SAS registers definition **************************/
+
+/* 
+ * CHIM Registers, Address Range : (0x00-0xFF) 
+ */
+#define CHIM_REG_BASE_ADR		0xB8000000 
+
+#define COMBIST		0x00
+
+/* bits 31:24 */
+#define		L7BLKRST		0x80000000     
+#define		L6BLKRST		0x40000000     
+#define		L5BLKRST		0x20000000     
+#define		L4BLKRST		0x10000000     
+#define		L3BLKRST		0x08000000    
+#define		L2BLKRST		0x04000000    
+#define		L1BLKRST		0x02000000     
+#define		L0BLKRST		0x01000000     
+#define		LmBLKRST		0xFF000000 
+#define LmBLKRST_COMBIST(phyid)		(1 << (24 + phyid))
+
+#define		OCMBLKRST		0x00400000
+#define		CTXMEMBLKRST		0x00200000     
+#define		CSEQBLKRST		0x00100000     
+#define		EXSIBLKRST		0x00040000     
+#define		DPIBLKRST		0x00020000     
+#define		DFIFBLKRST		0x00010000     
+#define		HARDRST			0x00000200     
+#define		COMBLKRST		0x00000100     
+#define		FRCDFPERR		0x00000080     
+#define		FRCCIOPERR		0x00000020 
+#define		FRCBISTERR		0x00000010     
+#define		COMBISTEN		0x00000004
+#define		COMBISTDONE		0x00000002	/* ro */
+#define 	COMBISTFAIL		0x00000001	/* ro */
+
+#define COMSTAT		0x04
+
+#define		REQMBXREAD		0x00000040
+#define 	RSPMBXAVAIL		0x00000020
+#define 	CSBUFPERR		0x00000008
+#define		OVLYERR			0x00000004
+#define 	CSERR			0x00000002
+#define		OVLYDMADONE		0x00000001
+
+#define		COMSTAT_MASK		(REQMBXREAD | RSPMBXAVAIL | \
+					 CSBUFPERR | OVLYERR | CSERR |\
+					 OVLYDMADONE)
+					 
+#define COMSTATEN	0x08
+
+#define		EN_REQMBXREAD		0x00000040
+#define		EN_RSPMBXAVAIL		0x00000020
+#define		EN_CSBUFPERR		0x00000008
+#define		EN_OVLYERR		0x00000004
+#define		EN_CSERR		0x00000002
+#define		EN_OVLYDONE		0x00000001 
+
+#define SCBPRO		0x0C
+
+#define		SCBCONS_MASK		0xFFFF0000
+#define		SCBPRO_MASK		0x0000FFFF
+
+#define CHIMREQMBX	0x10	
+
+#define CHIMRSPMBX	0x14
+
+#define CHIMINT		0x18
+
+#define		EXT_INT0		0x00000800
+#define		EXT_INT1		0x00000400
+#define		PORRSTDET		0x00000200
+#define		HARDRSTDET		0x00000100
+#define		DLAVAILQ		0x00000080	/* ro */
+#define		HOSTERR			0x00000040
+#define		INITERR			0x00000020
+#define		DEVINT			0x00000010
+#define		COMINT			0x00000008
+#define		DEVTIMER2		0x00000004
+#define		DEVTIMER1		0x00000002
+#define		DLAVAIL			0x00000001
+
+#define		CHIMINT_MASK		(HOSTERR | INITERR | DEVINT | COMINT |\
+					 DEVTIMER2 | DEVTIMER1 | DLAVAIL)
+					 
+#define 	DEVEXCEPT_MASK		(HOSTERR | INITERR | DEVINT | COMINT)
+
+#define CHIMINTEN	0x1C
+
+#define		RST_EN_EXT_INT1		0x01000000
+#define		RST_EN_EXT_INT0		0x00800000
+#define		RST_EN_HOSTERR		0x00400000    
+#define		RST_EN_INITERR		0x00200000
+#define		RST_EN_DEVINT		0x00100000
+#define		RST_EN_COMINT		0x00080000
+#define		RST_EN_DEVTIMER2	0x00040000
+#define		RST_EN_DEVTIMER1	0x00020000
+#define		RST_EN_DLAVAIL		0x00010000
+#define		SET_EN_EXT_INT1		0x00000100
+#define		SET_EN_EXT_INT0		0x00000080
+#define		SET_EN_HOSTERR		0x00000040
+#define		SET_EN_INITERR		0x00000020
+#define		SET_EN_DEVINT		0x00000010
+#define		SET_EN_COMINT		0x00000008
+#define		SET_EN_DEVTIMER2	0x00000004
+#define		SET_EN_DEVTIMER1	0x00000002
+#define		SET_EN_DLAVAIL		0x00000001
+
+#define		RST_CHIMINTEN		(RST_EN_HOSTERR | RST_EN_INITERR | \
+					 RST_EN_DEVINT | RST_EN_COMINT | \
+					 RST_EN_DEVTIMER2 | RST_EN_DEVTIMER1 |\
+					 RST_EN_DLAVAIL)
+					 
+#define		SET_CHIMINTEN		(SET_EN_HOSTERR | SET_EN_INITERR |\
+					 SET_EN_DEVINT | SET_EN_COMINT |\
+					 SET_EN_DLAVAIL)
+					 
+#define OVLYDMACTL	0x20
+
+#define		OVLYADR_MASK		0x07FF0000
+#define		OVLYLSEQ_MASK		0x0000FF00
+#define		OVLYCSEQ		0x00000080
+#define		OVLYHALTERR		0x00000040
+#define		PIOCMODE		0x00000020
+#define		RESETOVLYDMA		0x00000008	/* wo */
+#define		STARTOVLYDMA		0x00000004
+#define		STOPOVLYDMA		0x00000002	/* wo */
+#define		OVLYDMAACT		0x00000001	/* ro */ 
+
+#define OVLYDMACNT	0x24
+
+#define		OVLYDOMAIN1		0x20000000	/* ro */
+#define		OVLYDOMAIN0		0x10000000
+#define		OVLYBUFADR_MASK		0x007F0000
+#define		OVLYDMACNT_MASK		0x00003FFF
+
+#define OVLYDMAADR0	0x28
+
+#define OVLYDMAADR1	0x2C
+
+#define DMAERR		0x30
+
+#define		OVLYERRSTAT_MASK	0x0000FF00	/* ro */
+#define		CSERRSTAT_MASK		0x000000FF	/* ro */
+
+#define SPIODATA	0x34
+
+/* 0x38 - 0x3C are reserved  */
+
+#define T1CNTRLR	0x40
+
+#define		T1DONE			0x00010000	/* ro */
+#define		TIMER64			0x00000400
+#define		T1ENABLE		0x00000200
+#define		T1RELOAD		0x00000100
+#define		T1PRESCALER_MASK	0x00000003
+
+#define	T1CMPR		0x44
+
+#define T1CNTR		0x48
+
+#define T2CNTRLR	0x4C
+
+#define		T2DONE			0x00010000	/* ro */
+#define		T2ENABLE		0x00000200
+#define		T2RELOAD		0x00000100
+#define		T2PRESCALER_MASK	0x00000003
+
+#define	T2CMPR		0x50
+
+#define T2CNTR		0x54
+
+/* 0x58h - 0xFCh are reserved */
+
+/* 
+ * DCH_SAS Registers, Address Range : (0x800-0xFFF) 
+ */
+#define DCH_SAS_REG_BASE_ADR		0xB8000000
+
+#define CMDCTXBASE	0x800
+
+#define DEVCTXBASE	0x808
+
+#define CTXDOMAIN	0x810
+
+#define		DEVCTXDOMAIN1		0x00000008	/* ro */
+#define		DEVCTXDOMAIN0		0x00000004
+#define		CMDCTXDOMAIN1		0x00000002	/* ro */
+#define		CMDCTXDOMAIN0		0x00000001
+
+#define DCHCTL		0x814
+
+#define		OCMBISTREPAIR		0x00080000
+#define		OCMBISTEN		0x00040000     
+#define		OCMBISTDN		0x00020000	/* ro */
+#define		OCMBISTFAIL		0x00010000	/* ro */   
+#define		DDBBISTEN		0x00004000  
+#define		DDBBISTDN		0x00002000	/* ro */ 
+#define		DDBBISTFAIL		0x00001000	/* ro */
+#define		SCBBISTEN		0x00000400     
+#define		SCBBISTDN		0x00000200	/* ro */    
+#define		SCBBISTFAIL		0x00000100	/* ro */
+   
+#define		MEMSEL_MASK		0x000000E0  
+#define		MEMSEL_CCM_LSEQ		0x00000000   
+#define		MEMSEL_CCM_IOP		0x00000020   
+#define		MEMSEL_CCM_SASCTL	0x00000040   
+#define		MEMSEL_DCM_LSEQ		0x00000060  
+#define		MEMSEL_DCM_IOP		0x00000080 
+#define		MEMSEL_OCM		0x000000A0
+
+#define		FRCERR			0x00000010 
+#define		AUTORLS			0x00000001
+
+#define DCHREVISION	0x818
+
+#define		CTXMEMSIZE_MASK		0x80000000	/* ro */
+#define		CTXMEMSIZE_64K		0x80000000	
+#define		CTXMEMSIZE_32K		0x00000000	
+
+#define		DCHREVISION_MASK	0x000000FF
+
+#define DCHSTATUS	0x81C
+
+#define		EN_CFIFTOERR		0x00020000   
+#define		CFIFTOERR		0x00000200  
+#define		CSEQINT			0x00000100	/* ro */ 
+#define		LSEQ7INT		0x00000080	/* ro */
+#define		LSEQ6INT		0x00000040	/* ro */   
+#define		LSEQ5INT		0x00000020	/* ro */  
+#define		LSEQ4INT		0x00000010	/* ro */ 
+#define		LSEQ3INT		0x00000008	/* ro */
+#define		LSEQ2INT		0x00000004	/* ro */  
+#define		LSEQ1INT		0x00000002	/* ro */ 
+#define		LSEQ0INT		0x00000001	/* ro */
+
+#define		LSEQINT_MASK		(LSEQ7INT | LSEQ6INT | LSEQ5INT |\
+					 LSEQ4INT | LSEQ3INT | LSEQ2INT	|\
+					 LSEQ1INT | LSEQ0INT)
+			
+/* 0x820h - 0xFFCh are reserved */
+
+/* 
+ * ARP2 External Processor Registers, Address Range : (0x00-0x1F) 
+ */
+#define ARP2CTL		0x00
+
+#define		FRCSCRPERR		0x00040000     
+#define		FRCARP2PERR		0x00020000    
+#define		FRCARP2ILLOPC		0x00010000   
+#define		ENWAITTO		0x00008000  
+#define		PERRORDIS		0x00004000 
+#define		FAILDIS			0x00002000
+#define		CIOPERRDIS		0x00001000    
+#define		BREAKEN3		0x00000800    
+#define		BREAKEN2		0x00000400   
+#define		BREAKEN1		0x00000200  
+#define		BREAKEN0		0x00000100 
+#define		EPAUSE			0x00000008
+#define		PAUSED			0x00000004	/* ro */
+#define		STEP			0x00000002
+#define		ARP2RESET		0x00000001	/* wo */
+
+#define ARP2INT		0x04
+
+#define		HALTCODE_MASK		0x00FF0000	/* ro */   
+#define		ARP2WAITTO		0x00000100     
+#define		ARP2HALTC		0x00000080    
+#define		ARP2ILLOPC		0x00000040   
+#define		ARP2PERR		0x00000020  
+#define		ARP2CIOPERR		0x00000010 
+#define		ARP2BREAK3		0x00000008
+#define		ARP2BREAK2		0x00000004    
+#define		ARP2BREAK1		0x00000002   
+#define		ARP2BREAK0		0x00000001  
+
+#define ARP2INTEN	0x08
+
+#define		EN_ARP2WAITTO		0x00000100    
+#define		EN_ARP2HALTC		0x00000080   
+#define		EN_ARP2ILLOPC		0x00000040  
+#define		EN_ARP2PERR		0x00000020 
+#define		EN_ARP2CIOPERR		0x00000010
+#define		EN_ARP2BREAK3		0x00000008   
+#define		EN_ARP2BREAK2		0x00000004  
+#define		EN_ARP2BREAK1		0x00000002 
+#define		EN_ARP2BREAK0		0x00000001
+
+#define ARP2BREAKADR01	0x0C
+
+#define		BREAKADR1_MASK		0x0FFF0000
+#define		BREAKADR0_MASK		0x00000FFF
+
+#define	ARP2BREAKADR23	0x10
+
+#define		BREAKADR3_MASK		0x0FFF0000
+#define		BREAKADR2_MASK		0x00000FFF
+
+/* 0x14h - 0x1Ch are reserved */
+
+/* 
+ * ARP2 Registers, Address Range : (0x00-0x1F)
+ * The definitions have the same address offset for CSEQ and LmSEQ 
+ * CIO Bus Registers.
+ */
+#define MODEPTR		0x00
+
+#define		DSTMODE			0xF0
+#define		SRCMODE			0x0F
+
+#define ALTMODE		0x01
+
+#define		ALTDMODE		0xF0
+#define		ALTSMODE		0x0F
+
+#define ATOMICXCHG	0x02
+
+#define FLAG		0x04
+
+#define		INTCODE_MASK		0xF0
+#define		ALTMODEV2		0x04
+#define		CARRY_INT		0x02
+#define		CARRY			0x01
+
+#define ARP2INTCTL	0x05
+
+#define 	PAUSEDIS		0x80
+#define		RSTINTCTL		0x40
+#define		POPALTMODE		0x08
+#define		ALTMODEV		0x04
+#define		INTMASK			0x02
+#define		IRET			0x01
+
+#define STACK		0x06
+
+#define FUNCTION1	0x07
+
+#define PRGMCNT		0x08
+
+#define ACCUM		0x0A
+
+#define SINDEX		0x0C
+
+#define DINDEX		0x0E
+
+#define ALLONES		0x10
+
+#define ALLZEROS	0x11
+
+#define SINDIR		0x12
+
+#define DINDIR		0x13
+
+#define JUMLDIR		0x14
+
+#define ARP2HALTCODE	0x15
+
+#define CURRADDR	0x16
+
+#define LASTADDR	0x18
+
+#define NXTLADDR	0x1A
+
+#define DBGPORTPTR	0x1C
+
+#define DBGPORT		0x1D
+
+/*
+ * CIO Registers.
+ * The definitions have the same address offset for CSEQ and LmSEQ 
+ * CIO Bus Registers.
+ */ 
+#define MnSCBPTR      	0x20
+
+#define MnDDBPTR      	0x22
+
+#define SCRATCHPAGE	0x24
+
+#define MnSCRATCHPAGE	0x25
+
+#define SCRATCHPAGESV	0x26
+
+#define MnSCRATCHPAGESV	0x27
+
+#define MnDMAERRS	0x46
+
+#define MnSGDMAERRS	0x47
+
+#define MnSGBUF		0x53
+
+#define MnSGDMASTAT	0x5b
+
+#define MnDDMACTL	0x5c	/* RAXOR.rspec.fm rev 1.5 is wrong */
+
+#define MnDDMASTAT	0x5d	/* RAXOR.rspec.fm rev 1.5 is wrong */
+
+#define MnDDMAMODE	0x5e	/* RAXOR.rspec.fm rev 1.5 is wrong */
+
+#define MnDMAENG	0x60
+
+#define MnPIPECTL	0x61
+
+#define MnSGBADR	0x65
+
+#define MnSCB_SITE	0x100
+
+#define MnDDB_SITE	0x180
+
+/*
+ * The common definitions below have the same address offset for both 
+ * CSEQ and LmSEQ.
+ */
+#define BISTCTL0	0x4C	
+
+#define BISTCTL1	0x50
+
+#define MAPPEDSCR	0x800 
+  
+/* 
+ * CSEQ Host Register, Address Range : (0x000-0xFFC)
+ */
+#define CSEQ_HOST_REG_BASE_ADR		0xB8001000
+
+#define CARP2CTL			(CSEQ_HOST_REG_BASE_ADR	+ ARP2CTL)
+
+#define CARP2INT			(CSEQ_HOST_REG_BASE_ADR	+ ARP2INT)
+
+#define CARP2INTEN			(CSEQ_HOST_REG_BASE_ADR	+ ARP2INTEN)
+
+#define CARP2BREAKADR01			(CSEQ_HOST_REG_BASE_ADR+ARP2BREAKADR01)
+
+#define CARP2BREAKADR23			(CSEQ_HOST_REG_BASE_ADR+ARP2BREAKADR23)
+
+#define CBISTCTL			(CSEQ_HOST_REG_BASE_ADR	+ BISTCTL1)
+
+#define		CSEQRAMBISTEN		0x00000040		
+#define		CSEQRAMBISTDN		0x00000020	/* ro */	
+#define		CSEQRAMBISTFAIL		0x00000010	/* ro */
+#define		CSEQSCRBISTEN		0x00000004
+#define		CSEQSCRBISTDN		0x00000002	/* ro */
+#define		CSEQSCRBISTFAIL		0x00000001	/* ro */
+
+#define CMAPPEDSCR			(CSEQ_HOST_REG_BASE_ADR	+ MAPPEDSCR) 
+
+/* 
+ * CSEQ CIO Bus Registers, Address Range : (0x0000-0x1FFC)
+ * 16 modes, each mode is 512 bytes.
+ * Unless specified, the register should valid for all modes.
+ */
+#define CSEQ_CIO_REG_BASE_ADR		0xB8002000
+
+#define CSEQm_CIO_REG(Mode, Reg) \
+		(CSEQ_CIO_REG_BASE_ADR  + \
+		((uint32_t) (Mode) * CSEQ_MODE_PAGE_SIZE) + (uint32_t) (Reg))
+
+#define CMODEPTR	(CSEQ_CIO_REG_BASE_ADR + MODEPTR)
+
+#define CALTMODE	(CSEQ_CIO_REG_BASE_ADR + ALTMODE)
+
+#define CATOMICXCHG	(CSEQ_CIO_REG_BASE_ADR + ATOMICXCHG)
+
+#define CFLAG		(CSEQ_CIO_REG_BASE_ADR + FLAG)
+
+#define CARP2INTCTL	(CSEQ_CIO_REG_BASE_ADR + ARP2INTCTL)
+
+#define CSTACK		(CSEQ_CIO_REG_BASE_ADR + STACK)
+
+#define CFUNCTION1	(CSEQ_CIO_REG_BASE_ADR + FUNCTION1)
+
+#define CPRGMCNT	(CSEQ_CIO_REG_BASE_ADR + PRGMCNT)
+
+#define CACCUM		(CSEQ_CIO_REG_BASE_ADR + ACCUM)
+
+#define CSINDEX		(CSEQ_CIO_REG_BASE_ADR + SINDEX)
+
+#define CDINDEX		(CSEQ_CIO_REG_BASE_ADR + DINDEX)
+
+#define CALLONES	(CSEQ_CIO_REG_BASE_ADR + ALLONES)
+
+#define CALLZEROS	(CSEQ_CIO_REG_BASE_ADR + ALLZEROS)
+
+#define CSINDIR		(CSEQ_CIO_REG_BASE_ADR + SINDIR)
+
+#define CDINDIR		(CSEQ_CIO_REG_BASE_ADR + DINDIR)
+
+#define CJUMLDIR	(CSEQ_CIO_REG_BASE_ADR + JUMLDIR)
+
+#define CARP2HALTCODE	(CSEQ_CIO_REG_BASE_ADR + ARP2HALTCODE)
+
+#define CCURRADDR	(CSEQ_CIO_REG_BASE_ADR + CURRADDR)
+
+#define CLASTADDR	(CSEQ_CIO_REG_BASE_ADR + LASTADDR)
+
+#define CNXTLADDR	(CSEQ_CIO_REG_BASE_ADR + NXTLADDR)
+
+#define CDBGPORTPTR	(CSEQ_CIO_REG_BASE_ADR + DBGPORTPTR)
+
+#define CDBGPORT	(CSEQ_CIO_REG_BASE_ADR + DBGPORT)
+
+#define CSCRATCHPAGE	(CSEQ_CIO_REG_BASE_ADR + SCRATCHPAGE)
+	
+#define CMnSCRATCHPAGE(Mode)		CSEQm_CIO_REG(Mode, MnSCRATCHPAGE)	
+
+#define CLINKCON	(CSEQ_CIO_REG_BASE_ADR + 0x28)
+
+#define	CCIOAACESS	(CSEQ_CIO_REG_BASE_ADR + 0x2C)
+	
+/* mode 0-7 */	
+#define CMnREQMBX(Mode)			CSEQm_CIO_REG(Mode, 0x30)
+
+/* mode 8 */
+#define CSEQCON				CSEQm_CIO_REG(8, 0x30)
+
+/* mode 0-7 */ 
+#define CMnRSPMBX(Mode)			CSEQm_CIO_REG(Mode, 0x34)
+
+/* mode 8 */
+#define CSEQCOMCTL			CSEQm_CIO_REG(8, 0x34)
+
+/* mode 8 */
+#define CSEQCOMSTAT			CSEQm_CIO_REG(8, 0x35)
+
+/* mode 8 */
+#define CSEQCOMINTEN			CSEQm_CIO_REG(8, 0x36)
+
+/* mode 8 */
+#define CSEQCOMDMACTL			CSEQm_CIO_REG(8, 0x37)
+
+#define		CSHALTERR		0x10		
+#define		RESETCSDMA		0x08		/* wo */
+#define		STARTCSDMA		0x04
+#define		STOPCSDMA		0x02		/* wo */
+#define		CSDMAACT		0x01		/* ro */
+	
+/* mode 0-7 */
+#define CMnINT(Mode)			CSEQm_CIO_REG(Mode, 0x38)
+
+#define		CMnREQMBXE		0x02
+#define		CMnRSPMBXF		0x01
+#define		CMnINT_MASK		0x00000003
+
+/* mode 8 */
+#define CSEQREQMBX			CSEQm_CIO_REG(8, 0x38)
+
+/* mode 0-7 */
+#define CMnINTEN(Mode)			CSEQm_CIO_REG(Mode, 0x3C)
+	
+#define		EN_CMnRSPMBXF		0x01
+
+/* mode 8 */
+#define CSEQRSPMBX			CSEQm_CIO_REG(8, 0x3C)
+
+/* mode 8 */
+#define CSDMAADR			CSEQm_CIO_REG(8, 0x40)
+
+/* mode 8 */
+#define CSDMACNT			CSEQm_CIO_REG(8, 0x48)
+
+/* mode 8 */
+#define CSEQDLCTL			CSEQm_CIO_REG(8, 0x4D)
+
+#define		DONELISTEND		0x10
+#define 	DONELISTSIZE_MASK	0x0F
+#define		DONELISTSIZE_8ELEM	0x01
+#define		DONELISTSIZE_16ELEM	0x02
+#define		DONELISTSIZE_32ELEM	0x03
+#define		DONELISTSIZE_64ELEM	0x04
+#define		DONELISTSIZE_128ELEM	0x05
+#define		DONELISTSIZE_256ELEM	0x06
+#define		DONELISTSIZE_512ELEM	0x07
+#define		DONELISTSIZE_1024ELEM	0x08
+#define		DONELISTSIZE_2048ELEM	0x09
+#define		DONELISTSIZE_4096ELEM	0x0A
+#define		DONELISTSIZE_8192ELEM	0x0B
+#define		DONELISTSIZE_16384ELEM	0x0C
+
+/* mode 8 */
+#define CSEQDLOFFS			CSEQm_CIO_REG(8, 0x4E)
+
+/* mode 11 */
+#define CM11INTVEC0			CSEQm_CIO_REG(11, 0x50)
+
+/* mode 11 */
+#define CM11INTVEC1			CSEQm_CIO_REG(11, 0x52)
+
+/* mode 11 */
+#define CM11INTVEC2			CSEQm_CIO_REG(11, 0x54)
+
+#define	CCONMSK	  			(CSEQ_CIO_REG_BASE_ADR + 0x60)
+
+#define	CCONEXIST			(CSEQ_CIO_REG_BASE_ADR + 0x61)
+
+#define	CCONMODE			(CSEQ_CIO_REG_BASE_ADR + 0x62)
+
+#define CTIMERCALC			(CSEQ_CIO_REG_BASE_ADR + 0x64)
+
+#define CINTDIS				(CSEQ_CIO_REG_BASE_ADR + 0x68)
+
+/* mode 8 */
+#define CSBUFFER			CSEQm_CIO_REG(11, 0x6C)
+
+#define	CSCRATCH			(CSEQ_CIO_REG_BASE_ADR + 0x1C0)
+
+/* mode 0-8 */
+#define CMnSCRATCH(Mode)		CSEQm_CIO_REG(Mode, 0x1E0)
+
+/* 
+ * CSEQ Mapped Instruction RAM Page, Address Range : (0x0000-0x1FFC)
+ */
+#define CSEQ_RAM_REG_BASE_ADR		0xB8004000
+
+/*
+ * The common definitions below have the same address offset for all the Link
+ * sequencers.
+ */
+#define MODECTL		0x40
+
+#define DBGMODE		0x44
+
+#define CONTROL		0x48
+#define LEDTIMER		0x00010000
+#define LEDTIMERS_10us		0x00000000
+#define LEDTIMERS_1ms		0x00000800
+#define LEDTIMERS_100ms		0x00001000
+#define LEDMODE_TXRX		0x00000000
+#define LEDMODE_CONNECTED	0x00000200
+#define LEDPOL			0x00000100
+
+#define LSEQRAM		0x1000
+  
+/* 
+ * LmSEQ Host Registers, Address Range : (0x0000-0x3FFC)
+ */
+#define LSEQ0_HOST_REG_BASE_ADR		0xB8020000
+#define LSEQ1_HOST_REG_BASE_ADR		0xB8024000
+#define LSEQ2_HOST_REG_BASE_ADR		0xB8028000
+#define LSEQ3_HOST_REG_BASE_ADR		0xB802C000
+#define LSEQ4_HOST_REG_BASE_ADR		0xB8030000
+#define LSEQ5_HOST_REG_BASE_ADR		0xB8034000
+#define LSEQ6_HOST_REG_BASE_ADR		0xB8038000
+#define LSEQ7_HOST_REG_BASE_ADR		0xB803C000
+
+#define LmARP2CTL(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) + \
+					ARP2CTL)
+
+#define LmARP2INT(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) + \
+					ARP2INT)
+
+#define LmARP2INTEN(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					ARP2INTEN)
+
+#define LmDBGMODE(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					DBGMODE)
+
+#define LmCONTROL(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					CONTROL)
+
+#define LmARP2BREAKADR01(LinkNum)	(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					ARP2BREAKADR01)
+					
+#define LmARP2BREAKADR23(LinkNum)	(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					ARP2BREAKADR23)	
+				
+#define LmMODECTL(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					MODECTL)
+
+#define		LmAUTODISCI		0x08000000                     
+#define		LmDSBLBITLT		0x04000000  
+#define		LmDSBLANTT		0x02000000  
+#define		LmDSBLCRTT		0x01000000 
+#define		LmDSBLCONT		0x00000100
+#define		LmPRIMODE		0x00000080   
+#define		LmDSBLHOLD		0x00000040  
+#define		LmDISACK		0x00000020 
+#define		LmBLIND48		0x00000010
+#define		LmRCVMODE_MASK		0x0000000C   
+#define		LmRCVMODE_PLD		0x00000000  
+#define		LmRCVMODE_HPC		0x00000004 
+					
+#define LmDBGMODE(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					DBGMODE)
+
+#define		LmFRCPERR		0x80000000  
+#define		LmMEMSEL_MASK		0x30000000 
+#define		LmFRCRBPERR		0x00000000
+#define		LmFRCTBPERR		0x10000000   
+#define		LmFRCSGBPERR		0x20000000   
+#define		LmFRCARBPERR		0x30000000  
+#define		LmRCVIDW		0x00080000 
+#define		LmINVDWERR		0x00040000
+#define		LmRCVDISP		0x00004000
+#define		LmDISPERR		0x00002000
+#define		LmDSBLDSCR		0x00000800
+#define		LmDSBLSCR		0x00000400
+#define		LmFRCNAK		0x00000200
+#define		LmFRCROFS		0x00000100
+#define		LmFRCCRC		0x00000080  
+#define		LmFRMTYPE_MASK		0x00000070 
+#define		LmSG_DATA		0x00000000
+#define		LmSG_COMMAND		0x00000010   
+#define		LmSG_TASK		0x00000020  
+#define		LmSG_TGTXFER		0x00000030 
+#define		LmSG_RESPONSE		0x00000040
+#define		LmSG_IDENADDR		0x00000050  
+#define		LmSG_OPENADDR		0x00000060  
+#define		LmDISCRCGEN		0x00000008 
+#define		LmDISCRCCHK		0x00000004
+#define		LmSSXMTFRM		0x00000002  
+#define		LmSSRCVFRM		0x00000001
+
+#define LmCONTROL(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					CONTROL)
+					 
+#define		LmSTEPXMTFRM		0x00000002
+#define		LmSTEPRCVFRM		0x00000001
+
+#define LmBISTCTL0(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					BISTCTL0)
+
+#define		ARBBISTEN		0x40000000 
+#define		ARBBISTDN		0x20000000	/* ro */
+#define		ARBBISTFAIL		0x10000000	/* ro */  
+#define		TBBISTEN		0x00000400   
+#define		TBBISTDN		0x00000200	/* ro */  
+#define		TBBISTFAIL		0x00000100	/* ro */ 
+#define		RBBISTEN		0x00000040
+#define		RBBISTDN		0x00000020	/* ro */   
+#define		RBBISTFAIL		0x00000010	/* ro */  
+#define		SGBISTEN		0x00000004 
+#define		SGBISTDN		0x00000002	/* ro */
+#define		SGBISTFAIL		0x00000001	/* ro */
+
+#define LmBISTCTL1(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	\
+					(LinkNum*LmSEQ_HOST_REG_SIZE) +	\
+					BISTCTL1)
+
+#define		LmRAMPAGE1		0x00000200   
+#define		LmRAMPAGE0		0x00000100  
+#define		LmIMEMBISTEN		0x00000040 
+#define		LmIMEMBISTDN		0x00000020	/* ro */
+#define		LmIMEMBISTFAIL		0x00000010	/* ro */  
+#define		LmSCRBISTEN		0x00000004 
+#define		LmSCRBISTDN		0x00000002	/* ro */ 
+#define		LmSCRBISTFAIL		0x00000001	/* ro */
+#define		LmRAMPAGE		(LmRAMPAGE1 + LmRAMPAGE0)
+#define		LmRAMPAGE_LSHIFT	0x8
+
+#define LmSCRATCH(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	  \
+					(LinkNum * LmSEQ_HOST_REG_SIZE) + \
+					MAPPEDSCR)
+
+#define LmSEQRAM(LinkNum)		(LSEQ0_HOST_REG_BASE_ADR +	  \
+					(LinkNum * LmSEQ_HOST_REG_SIZE) + \
+					LSEQRAM)
+
+/* 
+ * LmSEQ CIO Bus Register, Address Range : (0x0000-0xFFC)
+ * 8 modes, each mode is 512 bytes.
+ * Unless specified, the register should valid for all modes.
+ */
+#define LmSEQ_CIOBUS_REG_BASE		0x2000
+
+#define  LmSEQ_PHY_BASE(Mode, LinkNum) \
+		(LSEQ0_HOST_REG_BASE_ADR + \
+		(LmSEQ_HOST_REG_SIZE * (uint32_t) (LinkNum)) + \
+		LmSEQ_CIOBUS_REG_BASE + \
+		((uint32_t) (Mode) * LmSEQ_MODE_PAGE_SIZE))
+
+#define  LmSEQ_PHY_REG(Mode, LinkNum, Reg) \
+		(LSEQ0_HOST_REG_BASE_ADR + \
+		(LmSEQ_HOST_REG_SIZE * (uint32_t) (LinkNum)) + \
+		LmSEQ_CIOBUS_REG_BASE + \
+		((uint32_t) (Mode) * LmSEQ_MODE_PAGE_SIZE) + (uint32_t) (Reg))
+
+#define LmMODEPTR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, MODEPTR)
+
+#define LmALTMODE(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ALTMODE)
+
+#define LmATOMICXCHG(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ATOMICXCHG)
+
+#define LmFLAG(LinkNum)			LmSEQ_PHY_REG(0, LinkNum, FLAG)
+
+#define LmARP2INTCTL(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ARP2INTCTL)
+
+#define LmSTACK(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, STACK)
+
+#define LmFUNCTION1(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, FUNCTION1)
+
+#define LmPRGMCNT(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, PRGMCNT)
+
+#define LmACCUM(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ACCUM)
+
+#define LmSINDEX(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, SINDEX)
+
+#define LmDINDEX(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, DINDEX)
+
+#define LmALLONES(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ALLONES)
+
+#define LmALLZEROS(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ALLZEROS)
+
+#define LmSINDIR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, SINDIR)
+
+#define LmDINDIR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, DINDIR)
+
+#define LmJUMLDIR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, JUMLDIR)
+
+#define LmARP2HALTCODE(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, ARP2HALTCODE)
+
+#define LmCURRADDR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, CURRADDR)
+
+#define LmLASTADDR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, LASTADDR)
+
+#define LmNXTLADDR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, NXTLADDR)
+
+#define LmDBGPORTPTR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, DBGPORTPTR)
+
+#define LmDBGPORT(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, DBGPORT)
+	
+#define LmSCRATCHPAGE(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, SCRATCHPAGE)
+
+#define LmMnSCRATCHPAGE(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 	\
+						      MnSCRATCHPAGE)	
+
+#define LmTIMERCALC(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x28)
+
+#define LmREQMBX(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x30)
+
+#define LmRSPMBX(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x34)
+
+#define LmMnINT(LinkNum, Mode)		LmSEQ_PHY_REG(Mode, LinkNum, 0x38)
+
+#define		LmACKREQ		0x08000000   
+#define		LmNAKREQ		0x04000000   
+#define		LmMnXMTERR		0x02000000   
+#define		LmM5OOBSVC		0x01000000   
+#define		LmHWTINT		0x00800000   
+#define		LmMnCTXDONE		0x00100000   
+#define		LmM2REQMBXF		0x00080000   
+#define		LmM2RSPMBXE		0x00040000   
+#define		LmMnDMAERR		0x00020000   
+#define		LmRCVPRIM		0x00010000   
+#define		LmRCVERR		0x00008000   
+#define		LmADDRRCV		0x00004000   
+#define		LmMnHDRMISS		0x00002000   
+#define		LmMnWAITSCB		0x00001000   
+#define		LmMnRLSSCB		0x00000800   
+#define		LmMnSAVECTX		0x00000400  
+#define		LmMnFETCHSG		0x00000200 
+#define		LmMnLOADCTX		0x00000100
+#define		LmMnCFGICL		0x00000080   
+#define		LmMnCFGSATA		0x00000040  
+#define		LmMnCFGEXPSATA		0x00000020 
+#define		LmMnCFGCMPLT		0x00000010   
+#define		LmMnCFGRBUF		0x00000008 
+#define		LmMnSAVETTR		0x00000004
+#define		LmMnCFGRDAT		0x00000002 
+#define		LmMnCFGHDR		0x00000001  
+
+#define		LmM0INTMASK		0xFFFFFFFF
+#define		LmM1INTMASK		0xFFFFFFFF
+#define		LmM2INTMASK		0xFFFFFFFF
+#define		LmM5INTMASK		0xFFFFFFFF
+
+#define LmMnINTEN(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x3C)
+
+#define		EN_LmACKREQ		0x08000000   
+#define		EN_LmNAKREQ		0x04000000   
+#define		EN_LmMnXMTERR		0x02000000   
+#define		EN_LmM5OOBSVC		0x01000000   
+#define		EN_LmHWTINT		0x00800000   
+#define		EN_LmMnCTXDONE		0x00100000   
+#define		EN_LmM2REQMBXF		0x00080000   
+#define		EN_LmM2RSPMBXE		0x00040000   
+#define		EN_LmMnDMAERR		0x00020000   
+#define		EN_LmRCVPRIM		0x00010000   
+#define		EN_LmRCVERR		0x00008000   
+#define		EN_LmADDRRCV		0x00004000   
+#define		EN_LmMnHDRMISS		0x00002000   
+#define		EN_LmMnWAITSCB		0x00001000   
+#define		EN_LmMnRLSSCB		0x00000800   
+#define		EN_LmMnSAVECTX		0x00000400  
+#define		EN_LmMnFETCHSG		0x00000200 
+#define		EN_LmMnLOADCTX		0x00000100
+#define		EN_LmMnCFGICL		0x00000080   
+#define		EN_LmMnCFGSATA		0x00000040  
+#define		EN_LmMnCFGEXPSATA	0x00000020 
+#define		EN_LmMnCFGCMPLT		0x00000010   
+#define		EN_LmMnCFGRBUF		0x00000008 
+#define		EN_LmMnSAVETTR		0x00000004
+#define		EN_LmMnCFGRDAT		0x00000002 
+#define		EN_LmMnCFGHDR		0x00000001 
+
+#define		LmM0INTEN_MASK		(EN_LmMnCFGCMPLT | EN_LmMnCFGRBUF | \
+					 EN_LmMnSAVETTR | EN_LmMnCFGRDAT | \
+					 EN_LmMnCFGHDR | EN_LmRCVERR | \
+					 EN_LmADDRRCV | EN_LmMnHDRMISS | \
+					 EN_LmMnRLSSCB | EN_LmMnSAVECTX | \
+					 EN_LmMnFETCHSG | EN_LmMnLOADCTX | \
+					 EN_LmHWTINT | EN_LmMnCTXDONE | \
+					 EN_LmRCVPRIM | EN_LmMnCFGSATA | \
+					 EN_LmMnCFGEXPSATA | EN_LmMnDMAERR)
+
+#define		LmM1INTEN_MASK		(EN_LmMnCFGCMPLT | EN_LmADDRRCV | \
+					 EN_LmMnRLSSCB | EN_LmMnSAVECTX | \
+					 EN_LmMnFETCHSG | EN_LmMnLOADCTX | \
+					 EN_LmMnXMTERR | EN_LmHWTINT | \
+					 EN_LmMnCTXDONE | EN_LmRCVPRIM | \
+					 EN_LmRCVERR | EN_LmMnDMAERR)
+
+#define		LmM2INTEN_MASK		(EN_LmADDRRCV | EN_LmHWTINT | \
+					 EN_LmM2REQMBXF | EN_LmRCVPRIM | \
+					 EN_LmRCVERR)
+
+#define		LmM5INTEN_MASK		(EN_LmADDRRCV | EN_LmM5OOBSVC | \
+					 EN_LmHWTINT | EN_LmRCVPRIM | \
+					 EN_LmRCVERR)
+
+#define LmXMTPRIMD(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x40)
+
+#define LmXMTPRIMCS(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x44)
+
+#define LmCONSTAT(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x45)
+
+#define LmMnDMAERRS(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x46)
+
+#define LmMnSGDMAERRS(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x47)
+
+#define LmM0EXPHDRP(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x48)
+
+#define LmM1SASALIGN(LinkNum)		LmSEQ_PHY_REG(1, LinkNum, 0x48)
+#define SAS_ALIGN_DEFAULT		0xFF
+
+#define LmM0MSKHDRP(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x49)
+
+#define LmM1STPALIGN(LinkNum)		LmSEQ_PHY_REG(1, LinkNum, 0x49)
+#define STP_ALIGN_DEFAULT		0x1F
+
+#define LmM0RCVHDRP(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x4A)
+
+#define LmM1XMTHDRP(LinkNum)		LmSEQ_PHY_REG(1, LinkNum, 0x4A)
+
+#define LmM0ICLADR(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x4B)
+
+#define LmM1ALIGNMODE(LinkNum)		LmSEQ_PHY_REG(1, LinkNum, 0x4B)
+
+#define		LmDISALIGN		0x20
+#define		LmROTSTPALIGN		0x10
+#define		LmSTPALIGN		0x08
+#define		LmROTNOTIFY		0x04
+#define		LmDUALALIGN		0x02
+#define		LmROTALIGN		0x01
+
+#define LmM0EXPRCVNT(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x4C)
+
+#define LmM1XMTCNT(LinkNum)		LmSEQ_PHY_REG(1, LinkNum, 0x4C)
+
+#define LmMnBUFSTAT(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x4E)     
+
+#define		LmMnBUFPERR		0x01
+
+/* mode 0-1 */		
+#define LmMnXFRLVL(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x59)
+
+#define		LmMnXFRLVL_128		0x05
+#define		LmMnXFRLVL_256		0x04
+#define		LmMnXFRLVL_512		0x03
+#define		LmMnXFRLVL_1024		0x02
+#define		LmMnXFRLVL_1536		0x01
+#define		LmMnXFRLVL_2048		0x00
+
+ /* mode 0-1 */
+#define LmMnSGDMACTL(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x5A)
+
+#define 	LmMnRESETSG		0x04
+#define 	LmMnSTOPSG		0x02
+#define 	LmMnSTARTSG		0x01
+
+/* mode 0-1 */
+#define LmMnSGDMASTAT(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x5B)
+
+/* mode 0-1 */
+#define LmMnDDMACTL(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x5C)
+
+#define 	LmMnFLUSH		0x40		/* wo */		
+#define 	LmMnRLSRTRY		0x20		/* wo */
+#define 	LmMnDISCARD		0x10		/* wo */
+#define 	LmMnRESETDAT		0x08		/* wo */
+#define 	LmMnSUSDAT		0x04		/* wo */
+#define 	LmMnSTOPDAT		0x02		/* wo */
+#define 	LmMnSTARTDAT		0x01		/* wo */
+
+/* mode 0-1 */
+#define LmMnDDMASTAT(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x5D)
+
+#define		LmMnDPEMPTY		0x80
+#define		LmMnFLUSHING		0x40
+#define		LmMnDDMAREQ		0x20
+#define		LmMnHDMAREQ		0x10
+#define		LmMnDATFREE		0x08
+#define		LmMnDATSUS		0x04
+#define		LmMnDATACT		0x02
+#define		LmMnDATEN		0x01
+
+/* mode 0-1 */
+#define LmMnDDMAMODE(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x5E)
+
+#define 	LmMnDMATYPE_NORMAL		0x0000
+#define 	LmMnDMATYPE_HOST_ONLY_TX	0x0001
+#define 	LmMnDMATYPE_DEVICE_ONLY_TX	0x0002
+#define 	LmMnDMATYPE_INVALID		0x0003
+#define 	LmMnDMATYPE_MASK	0x0003
+
+#define 	LmMnDMAWRAP		0x0004
+#define 	LmMnBITBUCKET		0x0008
+#define 	LmMnDISHDR		0x0010
+#define 	LmMnSTPCRC		0x0020
+#define 	LmXTEST			0x0040
+#define 	LmMnDISCRC		0x0080
+#define 	LmMnENINTLK		0x0100
+#define 	LmMnADDRFRM		0x0400
+#define 	LmMnENXMTCRC		0x0800
+
+/* mode 0-1 */
+#define LmMnXFRCNT(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x70)
+
+/* mode 0-1 */
+#define LmMnDPSEL(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x7B)
+#define 	LmMnDPSEL_MASK		0x07
+#define 	LmMnEOLPRE		0x40
+#define 	LmMnEOSPRE		0x80
+
+/* Registers used in conjunction with LmMnDPSEL and LmMnDPACC registers */
+/* Receive Mode n = 0 */
+#define LmMnHRADDR			0x00
+#define LmMnHBYTECNT			0x01
+#define LmMnHREWIND			0x02
+#define LmMnDWADDR			0x03
+#define LmMnDSPACECNT			0x04
+#define LmMnDFRMSIZE			0x05
+
+/* Registers used in conjunction with LmMnDPSEL and LmMnDPACC registers */
+/* Transmit Mode n = 1 */
+#define LmMnHWADDR			0x00
+#define LmMnHSPACECNT			0x01
+/* #define LmMnHREWIND			0x02 */
+#define LmMnDRADDR			0x03
+#define LmMnDBYTECNT			0x04
+/* #define LmMnDFRMSIZE			0x05 */
+
+/* mode 0-1 */
+#define LmMnDPACC(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x78)
+#define 	LmMnDPACC_MASK		0x00FFFFFF
+
+/* mode 0-1 */
+#define LmMnHOLDLVL(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x7D)
+#define		LmMnHOLD_INIT_VALUE	0x28
+
+#define LmPRMSTAT0(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x80)
+#define LmPRMSTAT0BYTE0			0x80
+#define LmPRMSTAT0BYTE1			0x81
+#define LmPRMSTAT0BYTE2			0x82
+#define LmPRMSTAT0BYTE3			0x83
+
+#define		LmUNKNOWNP		0x20000000  
+#define		LmBREAK			0x10000000  
+#define		LmDONE			0x08000000 
+#define		LmOPENACPT		0x04000000
+#define		LmOPENRJCT		0x02000000  
+#define		LmOPENRTRY		0x01000000   
+#define		LmCLOSERV1		0x00800000  
+#define		LmCLOSERV0		0x00400000   
+#define		LmCLOSENORM		0x00200000   
+#define		LmCLOSECLAF		0x00100000  
+#define		LmNOTIFYRV2		0x00080000   
+#define		LmNOTIFYRV1		0x00040000  
+#define		LmNOTIFYNORM		0x00020000   
+#define		LmNOTIFYSPIN		0x00010000  
+#define		LmBROADRV4		0x00008000   
+#define		LmBROADRV3		0x00004000  
+#define		LmBROADRV2		0x00002000
+#define		LmBROADRV1		0x00001000  
+#define		LmBROADRV0		0x00000800 
+#define		LmBROADRVCH1		0x00000400
+#define		LmBROADRVCH0		0x00000200   
+#define		LmBROADCH		0x00000100  
+#define		LmAIPRVWP		0x00000080 
+#define		LmAIPWP			0x00000040
+#define		LmAIPWD			0x00000020  
+#define		LmAIPWC			0x00000010 
+#define		LmAIPRV2		0x00000008 
+#define		LmAIPRV1		0x00000004  
+#define		LmAIPRV0		0x00000002 
+#define		LmAIPNRML		0x00000001	
+
+#define		LmBROADCAST_MASK	(LmBROADCH | LmBROADRVCH0 | \
+					 LmBROADRVCH1)
+                            
+#define		LmPRMSTAT0CLR_MASK	0xFFFFFFFF
+
+#define LmPRMSTAT1(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0x84)
+#define LmPRMSTAT1BYTE0			0x84
+#define LmPRMSTAT1BYTE1			0x85
+#define LmPRMSTAT1BYTE2			0x86
+#define LmPRMSTAT1BYTE3			0x87
+
+#define		LmBREAK_DET		0x04000000
+#define		LmCLOSE_DET		0x02000000
+#define		LmDONE_DET		0x01000000	
+#define		LmXRDY			0x00040000   
+#define 	LmSYNCSRST		0x00020000   
+#define 	LmSYNC			0x00010000   
+#define 	LmXHOLD			0x00008000   
+#define 	LmRRDY			0x00004000   
+#define 	LmHOLD			0x00002000   
+#define 	LmROK			0x00001000   
+#define 	LmRIP			0x00000800  
+#define 	LmCRBLK			0x00000400 
+#define 	LmACK			0x00000200
+#define 	LmNAK			0x00000100   
+#define 	LmHARDRST		0x00000080  
+#define 	LmERROR			0x00000040 
+#define 	LmRERR			0x00000020
+#define 	LmPMREQP		0x00000010   
+#define 	LmPMREQS		0x00000008  
+#define 	LmPMACK			0x00000004 
+#define 	LmPMNAK			0x00000002
+#define 	LmDMAT			0x00000001
+
+#define		LmPRMSTAT1CLR_MASK	0xFFFFFFFF
+
+/* mode 1 */

