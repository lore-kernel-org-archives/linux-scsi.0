From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [24/27]
Date: Thu, 17 Feb 2005 12:37:42 -0500
Message-ID: <4214D666.7060505@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:43410 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262340AbVBQRhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:47 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbkr31610
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:46 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbkb21542
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Communicating with the sequencers.  Part 1/2.

diff -Nru a/drivers/scsi/adp94xx/adp94xx_seq.c b/drivers/scsi/adp94xx/adp94xx_seq.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/adp94xx_seq.c	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,1470 @@
+/*
+ * Adaptec ADP94xx SAS HBA device driver for Linux.
+ * Functions for interfacing with Sequencers.
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
+ * $Id: //depot/razor/linux/src/adp94xx_seq.c#62 $
+ * 
+ */	
+
+#include "adp94xx_osm.h"
+#include "adp94xx_inline.h"
+#include "adp94xx_seq.h"
+
+/*
+ * Wrappers for which particular version of sequencer code and interrupt
+ * vectors  to use.
+ */
+#define ASD_USE_A1_CODE(softc)		\
+	(softc->hw_profile.rev_id == AIC9410_DEV_REV_A1 ? 1: 0)
+
+#define ASD_SEQ_VER(seq, ver)	(seq##ver)
+
+#define ASD_INT_VEC(vec, ver)	(vec##ver)
+	
+#ifdef ASD_DEBUG
+/*
+ * Registers dump state definitions (for debug purpose).
+ */
+static void	asd_hwi_dump_cseq_state(struct asd_softc *asd);
+static void	asd_hwi_dump_lseq_state(struct asd_softc *asd, u_int lseq_id);
+
+typedef struct lseq_cio_reqs {
+	uint8_t		name[24];
+	uint16_t	offset;
+	uint16_t	width;
+	uint16_t	mode;
+} lseq_cio_regs_t;
+
+#define MD(x)	(1 << x)
+
+static lseq_cio_regs_t	LSEQmCIOREGS[] =
+{
+   {"LmMODEPTR"     ,0x00, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmALTMODE"     ,0x01, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmFLAG"        ,0x04, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmARP2INTCTL"  ,0x05, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPRGMCNT"     ,0x08,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmARP2HALTCODE",0x15, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmCURRADDR"    ,0x16,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmLASTADDR"    ,0x18,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmNXTLADDR"    ,0x1A,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnSCBPTR"    ,0x20,16, MD(0)|MD(1)|MD(2)|MD(3)},
+   {"LmMnDDBPTR"    ,0x22,16, MD(0)|MD(1)|MD(2)|MD(3)},
+   {"LmREQMBX"      ,0x30,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmRSPMBX"      ,0x34,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnINT"       ,0x38,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnINTEN"     ,0x3C,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmXMTPRIMD"    ,0x40,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmXMTPRIMCS"   ,0x44, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmCONSTAT"     ,0x45, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnDMAERRS"   ,0x46, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnSGDMAERRS" ,0x47, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnSASALIGN"  ,0x48, 8, MD(1)},
+   {"LmMnSTPALIGN"  ,0x49, 8, MD(1)},
+   {"LmALIGNMODE"   ,0x4B, 8, MD(1)},
+   {"LmMnEXPRCVCNT" ,0x4C,32, MD(0)},
+   {"LmMnXMTCNT"    ,0x4C,32, MD(1)},
+   {"LmMnCURRTAG"   ,0x54,16, MD(0)},
+   {"LmMnPREVTAG"   ,0x56,16, MD(0)},
+   {"LmMnACKOFS"    ,0x58, 8, MD(1)},
+   {"LmMnXFRLVL"    ,0x59, 8, MD(0)|MD(1)},
+   {"LmMnSGDMACTL"  ,0x5A, 8, MD(0)|MD(1)},
+   {"LmMnSGDMASTAT" ,0x5B, 8, MD(0)|MD(1)},
+   {"LmMnDDMACTL"   ,0x5C, 8, MD(0)|MD(1)},
+   {"LmMnDDMASTAT"  ,0x5D, 8, MD(0)|MD(1)},
+   {"LmMnDDMAMODE"  ,0x5E,16, MD(0)|MD(1)},
+   {"LmMnPIPECTL"   ,0x61, 8, MD(0)|MD(1)},
+   {"LmMnACTSCB"    ,0x62,16, MD(0)|MD(1)},
+   {"LmMnSGBHADR"   ,0x64, 8, MD(0)|MD(1)},
+   {"LmMnSGBADR"    ,0x65, 8, MD(0)|MD(1)},
+   {"LmMnSGDCNT"    ,0x66, 8, MD(0)|MD(1)},
+   {"LmMnSGDMADR"   ,0x68,32, MD(0)|MD(1)},
+   {"LmMnSGDMADR"   ,0x6C,32, MD(0)|MD(1)},
+   {"LmMnXFRCNT"    ,0x70,32, MD(0)|MD(1)},
+   {"LmMnXMTCRC"    ,0x74,32, MD(1)},
+   {"LmCURRTAG"     ,0x74,16, MD(0)},
+   {"LmPREVTAG"     ,0x76,16, MD(0)},
+   {"LmDPSEL"       ,0x7B, 8, MD(0)|MD(1)},
+   {"LmDPTHSTAT"    ,0x7C, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnHOLDLVL"   ,0x7D, 8, MD(0)},
+   {"LmMnSATAFS"    ,0x7E, 8, MD(1)},
+   {"LmMnCMPLTSTAT" ,0x7F, 8, MD(0)|MD(1)},
+   {"LmPRMSTAT0"    ,0x80,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPRMSTAT1"    ,0x84,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmGPRMINT"     ,0x88, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnCURRSCB"   ,0x8A,16, MD(0)},
+   {"LmPRMICODE"    ,0x8C,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnRCVCNT"    ,0x90,16, MD(0)},
+   {"LmMnBUFSTAT"   ,0x92,16, MD(0)},
+   {"LmMnXMTHDRSIZE",0x92, 8, MD(1)},
+   {"LmMnXMTSIZE"   ,0x93, 8, MD(1)},
+   {"LmMnTGTXFRCNT" ,0x94,32, MD(0)},
+   {"LmMnEXPROFS"   ,0x98,32, MD(0)},
+   {"LmMnXMTROFS"   ,0x98,32, MD(1)},
+   {"LmMnRCVROFS"   ,0x9C,32, MD(0)},
+   {"LmCONCTL"      ,0xA0,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmBITLTIMER"   ,0xA2,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmWWNLOW"      ,0xA8,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmWWNHIGH"     ,0xAC,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnFRMERR"    ,0xB0,32, MD(0)},
+   {"LmMnFRMERREN"  ,0xB4,32, MD(0)},
+   {"LmAWTIMER"     ,0xB8,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmAWTCTL"      ,0xBA, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnHDRCMPS"   ,0xC0,32, MD(0)},
+   {"LmMnXMTSTAT"   ,0xC4, 8, MD(1)},
+   {"LmHWTSTATEN"   ,0xC5, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnRRDYRC"    ,0xC6, 8, MD(0)},
+   {"LmMnRRDYTC"    ,0xC6, 8, MD(1)},
+   {"LmHWTSTAT"     ,0xC7, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnDATABUFADR",0xC8,16, MD(0)|MD(1)},
+   {"LmDWSSTATUS"   ,0xCB, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmMnACTSTAT"   ,0xCE,16, MD(0)|MD(1)},
+   {"LmMnREQSCB"    ,0xD2,16, MD(0)|MD(1)},
+   {"LmXXXPRIM"     ,0xD4,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmRCVASTAT"    ,0xD9, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmINTDIS1"     ,0xDA, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPSTORESEL"   ,0xDB, 8, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPSTORE"      ,0xDC,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPRIMSTAT0EN" ,0xE0,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmPRIMSTAT1EN" ,0xE4,32, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"LmDONETCTL"    ,0xF2,16, MD(0)|MD(1)|MD(2)|MD(3)|MD(4)|MD(5)|MD(6)|MD(7)},
+   {"", 0, 0, 0 }	/* Last entry should be NULL. */
+}; 
+
+static lseq_cio_regs_t	LSEQmOOBREGS[] =
+{
+   {"OOB_BFLTR"        ,0x100, 8, MD(5)},
+   {"OOB_INIT_MIN"     ,0x102,16, MD(5)},
+   {"OOB_INIT_MAX"     ,0x104,16, MD(5)},
+   {"OOB_INIT_NEG"     ,0x106,16, MD(5)},
+   {"OOB_SAS_MIN"      ,0x108,16, MD(5)},
+   {"OOB_SAS_MAX"      ,0x10A,16, MD(5)},
+   {"OOB_SAS_NEG"      ,0x10C,16, MD(5)},
+   {"OOB_WAKE_MIN"     ,0x10E,16, MD(5)},
+   {"OOB_WAKE_MAX"     ,0x110,16, MD(5)},
+   {"OOB_WAKE_NEG"     ,0x112,16, MD(5)},
+   {"OOB_IDLE_MAX"     ,0x114,16, MD(5)},
+   {"OOB_BURST_MAX"    ,0x116,16, MD(5)},
+   {"OOB_XMIT_BURST"   ,0x118, 8, MD(5)},
+   {"OOB_SEND_PAIRS"   ,0x119, 8, MD(5)},
+   {"OOB_INIT_IDLE"    ,0x11A, 8, MD(5)},
+   {"OOB_INIT_NEGO"    ,0x11C, 8, MD(5)},
+   {"OOB_SAS_IDLE"     ,0x11E, 8, MD(5)},
+   {"OOB_SAS_NEGO"     ,0x120, 8, MD(5)},
+   {"OOB_WAKE_IDLE"    ,0x122, 8, MD(5)},
+   {"OOB_WAKE_NEGO"    ,0x124, 8, MD(5)},
+   {"OOB_DATA_KBITS"   ,0x126, 8, MD(5)},
+   {"OOB_BURST_DATA"   ,0x128,32, MD(5)},
+   {"OOB_ALIGN_0_DATA" ,0x12C,32, MD(5)},
+   {"OOB_ALIGN_1_DATA" ,0x130,32, MD(5)},
+   {"OOB_SYNC_DATA"    ,0x134,32, MD(5)},
+   {"OOB_D10_2_DATA"   ,0x138,32, MD(5)},
+   {"OOB_PHY_RST_CNT"  ,0x13C,32, MD(5)},
+   {"OOB_SIG_GEN"      ,0x140, 8, MD(5)},
+   {"OOB_XMIT"         ,0x141, 8, MD(5)},
+   {"FUNCTION_MAKS"    ,0x142, 8, MD(5)},
+   {"OOB_MODE"         ,0x143, 8, MD(5)},
+   {"CURRENT_STATUS"   ,0x144, 8, MD(5)},
+   {"SPEED_MASK"       ,0x145, 8, MD(5)},
+   {"PRIM_COUNT"       ,0x146, 8, MD(5)},
+   {"OOB_SIGNALS"      ,0x148, 8, MD(5)},
+   {"OOB_DATA_DET"     ,0x149, 8, MD(5)},
+   {"OOB_TIME_OUT"     ,0x14C, 8, MD(5)},
+   {"OOB_TIMER_ENABLE" ,0x14D, 8, MD(5)},
+   {"OOB_STATUS"       ,0x14E, 8, MD(5)},
+   {"HOT_PLUG_DELAY"   ,0x150, 8, MD(5)},
+   {"RCD_DELAY"        ,0x151, 8, MD(5)},
+   {"COMSAS_TIMER"     ,0x152, 8, MD(5)},
+   {"SNTT_DELAY"       ,0x153, 8, MD(5)},
+   {"SPD_CHNG_DELAY"   ,0x154, 8, MD(5)},
+   {"SNLT_DELAY"       ,0x155, 8, MD(5)},
+   {"SNWT_DELAY"       ,0x156, 8, MD(5)},
+   {"ALIGN_DELAY"      ,0x157, 8, MD(5)},
+   {"INT_ENABLE_0"     ,0x158, 8, MD(5)},
+   {"INT_ENABLE_1"     ,0x159, 8, MD(5)},
+   {"INT_ENABLE_2"     ,0x15A, 8, MD(5)},
+   {"INT_ENABLE_3"     ,0x15B, 8, MD(5)},
+   {"OOB_TEST_REG"     ,0x15C, 8, MD(5)},
+   {"PHY_CONTROL_0"    ,0x160, 8, MD(5)},
+   {"PHY_CONTROL_1"    ,0x161, 8, MD(5)},
+   {"PHY_CONTROL_2"    ,0x162, 8, MD(5)},
+   {"PHY_CONTROL_3"    ,0x163, 8, MD(5)},
+   {"PHY_OOB_CAL_TX"   ,0x164, 8, MD(5)},
+   {"PHY_OOB_CAL_RX"   ,0x165, 8, MD(5)},
+   {"OOB_PHY_CAL_TX"   ,0x166, 8, MD(5)},
+   {"OOB_PHY_CAL_RX"   ,0x167, 8, MD(5)},
+   {"PHY_CONTROL_4"    ,0x168, 8, MD(5)},
+   {"PHY_TEST"         ,0x169, 8, MD(5)},
+   {"PHY_PWR_CTL"      ,0x16A, 8, MD(5)},
+   {"PHY_PWR_DELAY"    ,0x16B, 8, MD(5)},
+   {"OOB_SM_CON"       ,0x16C, 8, MD(5)},
+   {"ADDR_TRAP_1"      ,0x16D, 8, MD(5)},
+   {"ADDR_NEXT_1"      ,0x16E, 8, MD(5)},
+   {"NEXT_ST_1"        ,0x16F, 8, MD(5)},
+   {"OOB_SM_STATE"     ,0x170, 8, MD(5)},
+   {"ADDR_TRAP_2"      ,0x171, 8, MD(5)},
+   {"ADDR_NEXT_2"      ,0x172, 8, MD(5)},
+   {"NEXT_ST_2"        ,0x173, 8, MD(5)},
+   {"", 0, 0, 0 }	/* Last entry should be NULL. */
+};
+#endif /* ASD_DEBUG */
+
+/* Local functions' prototypes */
+static int	asd_hwi_verify_seqs(struct asd_softc *asd, uint8_t *code, 
+				    uint32_t code_size, uint8_t lseq_mask);
+static void	asd_hwi_init_cseq_scratch(struct asd_softc *asd);
+static void	asd_hwi_init_cseq_mip(struct asd_softc *asd);
+static void	asd_hwi_init_cseq_mdp(struct asd_softc *asd);
+static void	asd_hwi_init_cseq_cio(struct asd_softc *asd);
+static void 	asd_hwi_post_init_cseq(struct asd_softc *asd);
+static void	asd_hwi_init_scb_sites(struct asd_softc *asd);
+static void	asd_hwi_init_lseq_scratch(struct asd_softc *asd);
+static void	asd_hwi_init_lseq_mip(struct asd_softc *asd, u_int link_num);
+static void	asd_hwi_init_lseq_mdp(struct asd_softc *asd, u_int link_num);
+static void	asd_hwi_init_lseq_cio(struct asd_softc *asd, u_int link_num);
+static inline void
+		asd_swap_with_next_hscb(struct asd_softc *asd, struct scb *scb);
+      
+
+/* Sequencer misc. utilities. */
+static inline void asd_hwi_set_scbptr(struct asd_softc *asd, uint16_t val);
+static inline void asd_hwi_set_ddbptr(struct asd_softc *asd, uint16_t val);
+static inline void asd_hwi_set_scbsite_byte(struct asd_softc *asd,
+					    uint16_t site_offset, uint8_t val);
+static inline void asd_hwi_set_scbsite_word(struct asd_softc *asd,
+					    uint16_t site_offset, uint16_t val);
+static inline void asd_hwi_set_scbsite_dword(struct asd_softc *asd,
+					    uint16_t site_offset, uint32_t val);
+static inline uint8_t asd_hwi_get_scbsite_byte(struct asd_softc *asd, 
+					       uint16_t site_offset);
+static inline uint16_t asd_hwi_get_scbsite_word(struct asd_softc *asd, 
+					        uint16_t site_offset);
+static inline uint32_t asd_hwi_get_scbsite_dword(struct asd_softc *asd, 
+						 uint16_t site_offset);
+static inline void asd_hwi_set_ddbsite_byte(struct asd_softc *asd,
+					    uint16_t site_offset, uint8_t val);
+static inline void asd_hwi_set_ddbsite_word(struct asd_softc *asd,
+					    uint16_t site_offset, uint16_t val);
+static inline void asd_hwi_set_ddbsite_dword(struct asd_softc *asd,
+					    uint16_t site_offset, uint32_t val);
+static inline uint8_t asd_hwi_get_ddbsite_byte(struct asd_softc *asd, 
+					       uint16_t site_offset);
+static inline uint16_t asd_hwi_get_ddbsite_word(struct asd_softc *asd, 
+						uint16_t site_offset);
+static inline uint32_t asd_hwi_get_ddbsite_dword(struct asd_softc *asd, 
+						 uint16_t site_offset);
+
+
+/* 
+ * Function:
+ *	asd_hwi_set_scbptr()
+ *
+ * Description:
+ *      Program the SCBPTR. 
+ *	SCBPTR is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_scbptr(struct asd_softc *asd, uint16_t val)
+{
+	asd_hwi_swb_write_word(asd, CSEQm_CIO_REG(15, MnSCBPTR), val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_ddbptr()
+ *
+ * Description:
+ *      Program the DDBPTR. 
+ *	DDBPTR is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_ddbptr(struct asd_softc *asd, uint16_t val)
+{
+	asd_hwi_swb_write_word(asd, CSEQm_CIO_REG(15, MnDDBPTR), val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_scbsite_byte()
+ *
+ * Description:
+ *      Write an 8-bits value to the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_scbsite_byte(struct asd_softc *asd, uint16_t site_offset, 
+			 uint8_t val)
+{
+	asd_hwi_swb_write_byte(asd,
+			       CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset)),
+			       val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_scbsite_word()
+ *
+ * Description:
+ *      Write a 16-bits value to the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_scbsite_word(struct asd_softc *asd, uint16_t site_offset, 
+			 uint16_t val)
+{
+	asd_hwi_swb_write_word(asd,
+			       CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset)),
+			       val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_scbsite_dword()
+ *
+ * Description:
+ *      Write a 32-bits value to the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_scbsite_dword(struct asd_softc *asd, uint16_t site_offset, 
+			  uint32_t val)
+{
+	asd_hwi_swb_write_dword(asd,
+				CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset)),
+				val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_scbsite_byte()
+ *
+ * Description:
+ *      Read an 8-bits value from the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint8_t
+asd_hwi_get_scbsite_byte(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint8_t) asd_hwi_swb_read_byte(
+				asd,
+				CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_scbsite_word()
+ *
+ * Description:
+ *      Read a 16-bits value from the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint16_t
+asd_hwi_get_scbsite_word(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint16_t) asd_hwi_swb_read_word(
+				asd,
+				CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_scbsite_dword()
+ *
+ * Description:
+ *      Read a 32-bits value from the SCBSITE starting from the site_offset. 
+ *	SCBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint32_t
+asd_hwi_get_scbsite_dword(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint32_t) asd_hwi_swb_read_dword(
+				asd,
+				CSEQm_CIO_REG(15, (MnSCB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_ddbsite_byte()
+ *
+ * Description:
+ *      Write an 8-bits value to the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_ddbsite_byte(struct asd_softc *asd, uint16_t site_offset, 
+			 uint8_t val)
+{
+	asd_hwi_swb_write_byte(asd,
+			       CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset)),
+			       val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_ddbsite_word()
+ *
+ * Description:
+ *      Write a 16-bits value to the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_ddbsite_word(struct asd_softc *asd, uint16_t site_offset, 
+			 uint16_t val)
+{
+	asd_hwi_swb_write_word(asd,
+			       CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset)),
+			       val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_set_ddbsite_dword()
+ *
+ * Description:
+ *      Write a 32-bits value to the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline void
+asd_hwi_set_ddbsite_dword(struct asd_softc *asd, uint16_t site_offset, 
+			  uint32_t val)
+{
+	asd_hwi_swb_write_dword(asd,
+				CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset)),
+				val);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_ddbsite_byte()
+ *
+ * Description:
+ *      Read an 8-bits value from the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint8_t
+asd_hwi_get_ddbsite_byte(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint8_t) asd_hwi_swb_read_byte(
+				asd,
+			      	CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_ddbsite_word()
+ *
+ * Description:
+ *      Read a 16-bits value from the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint16_t
+asd_hwi_get_ddbsite_word(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint16_t) asd_hwi_swb_read_word(
+				asd,
+			      	CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_get_ddbsite_dword()
+ *
+ * Description:
+ *      Read a 32-bits value from the DDBSITE starting from the site_offset. 
+ *	DDBSITE is in Mode 15 of CSEQ CIO Bus Registers. 
+ */
+static inline uint32_t
+asd_hwi_get_ddbsite_dword(struct asd_softc *asd, uint16_t site_offset)
+{
+	return ((uint32_t) asd_hwi_swb_read_dword(
+				asd,
+			      	CSEQm_CIO_REG(15, (MnDDB_SITE + site_offset))));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_pause_cseq()
+ *
+ * Description:
+ *      Pause the Central Sequencer. 
+ */
+int
+asd_hwi_pause_cseq(struct asd_softc *asd)
+{
+	uint32_t	arp2ctl_reg;
+	uint32_t	arp2ctl;
+	uint32_t	timer_tick;
+
+	timer_tick = ASD_REG_TIMEOUT_TICK;
+	arp2ctl_reg = (uint32_t) CARP2CTL;
+	arp2ctl = asd_hwi_swb_read_dword(asd, arp2ctl_reg);
+	
+	/* Check if the CSEQ is paused. */
+	if (!(arp2ctl & PAUSED)) {
+		/* CSEQ is running. Pause it. */
+		asd_hwi_swb_write_dword(asd, arp2ctl_reg, (arp2ctl | EPAUSE));
+		/* Verify that the CSEQ is paused. */
+		do { 
+			arp2ctl = asd_hwi_swb_read_dword(asd, arp2ctl_reg);
+			if (!(arp2ctl & PAUSED)) {
+				timer_tick--;		
+				asd_delay(ASD_DELAY_COUNT);	
+			} else
+				break;
+		} while (timer_tick != 0);					
+	}		 		
+	if (timer_tick == 0) {
+		asd_log(ASD_DBG_ERROR, "Timeout expired when pausing CSEQ.\n");
+		ASD_DUMP_REG(CARP2CTL);
+		return (-1);
+	}
+
+	return (0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_unpause_cseq()
+ *
+ * Description:
+ *      Unpause the Central Sequencer. 
+ */
+int
+asd_hwi_unpause_cseq(struct asd_softc *asd)
+{
+	uint32_t	arp2ctl;
+	uint32_t	timer_tick;
+
+	timer_tick = ASD_REG_TIMEOUT_TICK;
+	arp2ctl = asd_hwi_swb_read_dword(asd, CARP2CTL);
+
+	/* Check if the CSEQ is paused. */
+	if (arp2ctl & PAUSED) {
+		/* CSEQ is currently paused. Unpause it. */
+		asd_hwi_swb_write_dword(asd, CARP2CTL, (arp2ctl & ~EPAUSE));
+		/* Verify that the CSEQ is unpaused. */
+		do { 
+			arp2ctl = asd_hwi_swb_read_dword(asd, CARP2CTL);
+			if (arp2ctl & PAUSED) {
+				timer_tick--;		
+				asd_delay(ASD_DELAY_COUNT);	
+			} else
+				break;
+		} while (timer_tick != 0);	
+	}
+	if (timer_tick == 0) {
+		asd_log(ASD_DBG_ERROR, "Timeout expired when unpausing "
+					"CSEQ.\n");
+		ASD_DUMP_REG(CARP2CTL);
+		return (-1);
+	}
+
+	return (0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_pause_lseq()
+ *
+ * Description:
+ *      Pause the Central Sequencer. 
+ */
+int	
+asd_hwi_pause_lseq(struct asd_softc *asd, uint8_t lseq_mask)
+{
+	uint32_t	arp2ctl;
+	uint32_t	timer_tick;
+	uint8_t		temp_lseq_mask;	
+	uint8_t		phy_id;
+
+	phy_id = 0;
+	temp_lseq_mask = lseq_mask;
+	timer_tick = ASD_REG_TIMEOUT_TICK;	
+	while (temp_lseq_mask) {
+		do {
+			if (temp_lseq_mask & (1 << phy_id))  
+				break;
+			else 
+				phy_id++;		
+		} while (phy_id < asd->hw_profile.max_phys);
+		
+		arp2ctl = asd_hwi_swb_read_dword(asd, LmARP2CTL(phy_id));
+		
+		/* Check if the CSEQ is paused. */
+		if (!(arp2ctl & PAUSED)) {
+			/*
+		 	 * CSEQ is running. Pause it.
+		 	 */
+			asd_hwi_swb_write_dword(asd, LmARP2CTL(phy_id), 
+						(arp2ctl | EPAUSE));
+			/* Verify that the CSEQ is paused. */
+			do { 
+				arp2ctl = asd_hwi_swb_read_dword(asd, 
+							LmARP2CTL(phy_id));
+				if (!(arp2ctl & PAUSED)) {
+					timer_tick--;		
+					asd_delay(ASD_DELAY_COUNT);	
+				} else
+					break;
+			} while (timer_tick != 0);				
+		}
+		if (timer_tick == 0) {
+			asd_log(ASD_DBG_ERROR, "Timeout expired when pausing "
+				"LSEQ %d.\n", phy_id);
+			return (-1);
+		} 	
+		temp_lseq_mask &= (~(1 << phy_id));		
+		phy_id++;
+	}
+
+	return (0);						 
+}
+
+/* 
+ * Function:
+ *	asd_hwi_unpause_cseq()
+ *
+ * Description:
+ *      Unpause the requested Link Sequencer(s). 
+ */
+int
+asd_hwi_unpause_lseq(struct asd_softc *asd, uint8_t lseq_mask)
+{
+	uint32_t	arp2ctl;
+	uint32_t	timer_tick;
+	uint8_t		temp_lseq_mask;	
+	uint8_t		phy_id;
+	
+	phy_id = 0;
+	temp_lseq_mask = lseq_mask;
+	timer_tick = ASD_REG_TIMEOUT_TICK;	
+	while (temp_lseq_mask) {
+		do {
+			if (temp_lseq_mask & (1 << phy_id))  
+				break;
+			else 
+				phy_id++;		
+		} while (phy_id < asd->hw_profile.max_phys);
+		
+		arp2ctl = asd_hwi_swb_read_dword(asd, LmARP2CTL(phy_id));	
+
+		/* Check if the LSEQ is paused. */
+		if (arp2ctl & PAUSED) {
+			/* Unpause the LSEQ. */
+			asd_hwi_swb_write_dword(asd, LmARP2CTL(phy_id), 
+					       (arp2ctl & ~EPAUSE));
+			do { 
+				arp2ctl = asd_hwi_swb_read_dword(asd, 
+							LmARP2CTL(phy_id));
+				if (arp2ctl & PAUSED) {
+					timer_tick--;		
+					asd_delay(ASD_DELAY_COUNT);	
+				} else
+					break;
+			} while (timer_tick != 0);	
+
+		}
+		if (timer_tick == 0) {
+			asd_log(ASD_DBG_ERROR, "Timeout expired when unpausing "
+					"LSEQ %d.\n", phy_id);
+			return (-1);
+		}
+		temp_lseq_mask &= (~(1 << phy_id));		
+		phy_id++;
+	}
+
+	return (0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_download_seqs()
+ *
+ * Description:
+ *      Setup the Central and Link Sequencers.
+ *	Download the sequencers microcode.  
+ */
+int	
+asd_hwi_download_seqs(struct asd_softc *asd)
+{
+	int 	error;
+
+#define ASD_SET_SEQ_VER(asd, seq)	\
+	(ASD_USE_A1_CODE(asd) == 1 ? ASD_SEQ_VER(seq, a1) :		\
+	 ASD_SEQ_VER(seq, b0))
+
+#define ASD_SEQ_SIZE(asd, seq)		\
+	(ASD_USE_A1_CODE(asd) == 1 ? sizeof(ASD_SEQ_VER(seq, a1)) :	\
+	 sizeof(ASD_SEQ_VER(seq, b0)))
+
+	/* Download the Central Sequencer code. */
+	error = ASD_HWI_DOWNLOAD_SEQS(asd, ASD_SET_SEQ_VER(asd, Cs), 
+				      ASD_SEQ_SIZE(asd, Cs),
+				      0);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "CSEQ download failed.\n");
+		goto exit;
+	}
+	
+	/* 
+	 * Download the Link Sequencers code. All of the Link Sequencers 
+	 * microcode can be downloaded at the same time.
+	 */
+	error = ASD_HWI_DOWNLOAD_SEQS(asd, ASD_SET_SEQ_VER(asd, Ls), 
+				      ASD_SEQ_SIZE(asd, Ls),
+				      asd->hw_profile.enabled_phys); 
+	if (error != 0) {
+		uint8_t		i;
+		
+		/*
+		 * If we failed to load the LSEQ all at a time. 
+		 * Try to load them one at a time.
+		 */		 
+		for (i = 0; i < asd->hw_profile.max_phys; i++) {
+			error = ASD_HWI_DOWNLOAD_SEQS(
+					asd,
+					ASD_SET_SEQ_VER(asd, Ls),
+					ASD_SEQ_SIZE(asd, Ls),
+				      	(1 << i));
+			if (error != 0)
+				break;
+
+			asd->phy_list[i]->state = ASD_PHY_OFFLINE;
+		}
+		if (error) {
+			asd_log(ASD_DBG_ERROR, "LSEQs download failed.\n");
+			goto exit;
+		}
+	}
+
+exit:
+	return (error);		  
+}
+
+#if ASD_DMA_DOWNLOAD_SEQS
+/* 
+ * Function:
+ *	asd_hwi_dma_load_seqs()
+ *
+ * Description:
+ *	Download the sequencers using Host Overlay DMA mode.  
+ */
+int
+asd_hwi_dma_load_seqs(struct asd_softc *asd, uint8_t *code,
+		      uint32_t code_size, uint8_t lseq_mask)
+{
+	struct map_node	 buf_map;	
+	bus_dma_tag_t	 buf_dmat;
+	uint32_t	 buf_size;
+	uint32_t	 comstaten_val;
+	uint32_t	 instr_size;
+	uint32_t	 timer_tick;
+	uint16_t	 ovlyaddr;
+	uint16_t	 ovlydmactl_lo;
+	uint16_t	 ovlydmactl_hi;	
+	uint8_t		*instr;	
+	uint8_t		 nseg;
+	u_int		 i;
+	int		 error;
+	
+	error = 0;
+	if (code_size % 4) {
+		/*
+		 * For PIO mode, sequencer code size must be multiple of dword.
+		 */
+		asd_log(ASD_DBG_ERROR, "SEQ code size (%d) not multiple of "
+			"dword. \n", code_size);
+		return (-1);	
+	}
+	
+	/* Save the Interrupt Mask register value. */
+	comstaten_val = asd_read_dword(asd, COMSTATEN);
+	/* 
+	 * Disable Device Communication Status interrupt and clear any 
+	 * pending interrupts.
+	 */
+	asd_write_dword(asd, COMSTATEN, 0x0);
+	asd_write_dword(asd, COMSTAT, COMSTAT_MASK);
+		
+	/* Disable CHIM interrupt and clear any pending interrupts. */
+	asd_write_dword(asd, CHIMINTEN, RST_CHIMINTEN);
+	asd_write_dword(asd, CHIMINT, CHIMINT_MASK);
+	
+	/* 
+	 * Check the limit of HW DMA transfer size.
+	 * Limit the Overlay DMA transter size to code_size at a time.
+	 */ 
+	if ((asd->hw_profile.max_scbs * ASD_SCB_SIZE) >= code_size)
+		buf_size = code_size;
+	else
+		buf_size = (asd->hw_profile.max_scbs * ASD_SCB_SIZE);	
+
+	/* Allocate a dma tag for buffer to dma-ing the instruction codes. */
+	if (asd_dma_tag_create(asd, 4, buf_size, GFP_ATOMIC, &buf_dmat) != 0)
+		return (-ENOMEM);
+
+	if (asd_dmamem_alloc(asd, buf_dmat, (void **) &buf_map.vaddr,
+			     GFP_ATOMIC, &buf_map.dmamap,
+			     &buf_map.busaddr) != 0) {
+		asd_dma_tag_destroy(asd, buf_dmat);
+		return (-ENOMEM);
+	}
+
+	instr = (uint8_t *) buf_map.vaddr;
+	
+	/* Calculate number of DMA segments needed to transfer the code. */
+	nseg = (code_size + buf_size - 1) / buf_size;
+	instr_size = buf_size;
+	ovlydmactl_lo = ovlydmactl_hi = 0;
+	ovlyaddr = 0;
+	
+	asd_log(ASD_DBG_INFO, "Downloading %s (Overlay DMA Mode) ...\n", 
+		(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+	
+	for (i = 0; i < nseg; ) {
+		memcpy(instr, &code[ovlyaddr], instr_size);
+		
+		/* Program the DMA download size. */
+		asd_write_dword(asd, OVLYDMACNT, instr_size);
+		/* 
+		 * Program the 64-bit DMA address, OVLYDMAADDR register is 
+		 * 64-bit. 
+		 */
+		asd_write_dword(asd, OVLYDMAADR0, 
+				ASD_GET_PADR(buf_map.busaddr));
+		asd_write_dword(asd, OVLYDMAADR1,
+				ASD_GET_PUADR(buf_map.busaddr));
+		
+		/* lseq_mask tells us which sequencer(s) the code is for. */
+		if (lseq_mask == 0)
+			ovlydmactl_lo = (uint16_t) OVLYCSEQ;
+		else
+			ovlydmactl_lo = (uint16_t) (((uint16_t)lseq_mask) << 8);
+		/* 
+		 * Program the OVLYADR. It increments for each dword 
+		 * instruction overlaid. 
+		 */
+		ovlydmactl_hi = (ovlyaddr / 4);
+		/*
+		 * Reset the Overlay DMA counter and buffer pointers to zero.
+		 * Also, enabled the Overlay DMA engine.
+		 */
+	       ovlydmactl_lo |= (RESETOVLYDMA | STARTOVLYDMA | OVLYHALTERR);
+		/* 
+		 * Start the DMA. We need to set the higher two bytes of 
+		 * OVLYDMACTL register before programming the lower two bytes 
+		 * as the lowest byte of OVLYDMACTL register contains 
+		 * STARTOVLYDMA bit which once is written, will start the DMA.
+		 */
+		asd_write_word(asd, (OVLYDMACTL+2), ovlydmactl_hi);
+		asd_write_word(asd, OVLYDMACTL, ovlydmactl_lo);		
+			       
+	       	timer_tick = ASD_REG_TIMEOUT_TICK;
+		do {
+			/*
+			 * Check if the Overlay DMA is still active. 
+			 * It will get reset once the transfer is done.
+			 */
+			if (asd_read_dword(asd, OVLYDMACTL) & OVLYDMAACT) {
+				timer_tick--;		
+				asd_delay(ASD_DELAY_COUNT);
+			} else
+				break;
+		} while (timer_tick != 0);
+		
+		/*
+		 * Check if the DMA transfer has completed successfully.
+		 */
+		if ((timer_tick != 0) && 
+		    (asd_read_dword(asd, COMSTAT) & OVLYDMADONE) &&
+		    (!(asd_read_dword(asd, COMSTAT) & OVLYERR)) &&
+		    (!(asd_read_dword(asd, CHIMINT) & DEVEXCEPT_MASK))) {
+			/* DMA transfer completed successfully. */
+			ovlyaddr += instr_size;
+			/*
+			 * Sanity check when we doing the last segment, 
+			 * make sure that we only transfer the remaing code
+			 * size.
+			 */ 
+			if (++i == (nseg - 1))
+				instr_size = code_size - (i * instr_size);
+		} else {
+			/* DMA transfer failed. */
+			asd_log(ASD_DBG_ERROR, "%s download failed.\n",
+				(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+			error = -1;
+			goto exit;
+		}
+	} 
+
+	/* Restore the Interrupt Mask. */
+	asd_write_dword(asd, COMSTATEN, comstaten_val);	
+
+	/* Verify that the sequencer is downloaded properly. */
+	asd_log(ASD_DBG_INFO, "Verifying %s ...\n", 
+		(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+	if (asd_hwi_verify_seqs(asd, code, code_size, lseq_mask) != 0) {
+		asd_log(ASD_DBG_ERROR, "%s verify failed.\n",
+			(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+		error = -1;
+		goto exit;
+	}
+	asd_log(ASD_DBG_INFO, "%s verified successfully.\n", 
+		(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+
+exit:
+	asd_free_dma_mem(asd, buf_dmat, &buf_map);
+	
+	return (error);
+}
+
+#else
+
+/* 
+ * Function:
+ *	asd_hwi_pio_load_seqs()
+ *
+ * Description:
+ *	Download the sequencers using PIO mode.  
+ */
+int
+asd_hwi_pio_load_seqs(struct asd_softc *asd, uint8_t*code,
+		      uint32_t code_size, uint8_t lseq_mask)
+{
+	uint32_t	reg_val;
+	uint32_t	instr;
+	uint32_t	i;
+	
+	if (code_size % 4) {
+		/*
+		 * For PIO mode, sequencer code size must be multiple of dword.
+		 */
+		asd_log(ASD_DBG_ERROR, "SEQ code size (%d) not multiple of "
+			"dword. \n", code_size);	
+		return (-1);
+	}
+	/* Set to PIO Mode */
+	reg_val = PIOCMODE;
+		
+	/* lseq_mask tells us which sequencer(s) the code is for. */
+	if (lseq_mask != 0)
+		reg_val |= (uint32_t) (((uint16_t) lseq_mask) << 8);
+	else
+		reg_val |= OVLYCSEQ;
+
+	/*
+	 * Progam the sequencer RAM address, which sequencer(s) to load and the
+	 * download mode.
+	 */	
+	/* Program the download size. */
+	asd_write_dword(asd, OVLYDMACNT, code_size);
+	asd_write_dword(asd, OVLYDMACTL, reg_val); 	
+	
+	asd_log(ASD_DBG_INFO, "Downloading %s (PIO Mode) ...\n", 
+		(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+	/* Download the instr 4 bytes a time. */
+	for (i = 0; i < (code_size/4); i++) {
+		instr = *(uint32_t *) &code[i*4];
+		/* The sequencer is little-endian. */
+		instr = asd_htole32(instr);
+		asd_write_dword(asd, SPIODATA, instr);	
+	}
+	
+	/*
+	 * TBRV : Check Device Exception Error ??
+	 */
+	 
+	/* Clear the PIO mode bit and enabled Overlay Halt Error. */
+	reg_val = (reg_val & ~PIOCMODE) | OVLYHALTERR;
+	asd_write_dword(asd, OVLYDMACTL, reg_val);
+	
+	/* Verify that the sequencer is downloaded properly. */
+	asd_log(ASD_DBG_INFO,
+		"Verifying %s ...\n", (lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+	if (asd_hwi_verify_seqs(asd, code, code_size, lseq_mask) != 0) {
+		asd_log(ASD_DBG_ERROR, "%s verify failed.\n",
+			(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+		return (-1);
+	}
+	asd_log(ASD_DBG_INFO, "%s verified successfully.\n", 
+		(lseq_mask == 0 ? "CSEQ" : "LSEQ"));
+
+	return (0);
+}
+#endif
+
+/* 
+ * Function:
+ *	asd_hwi_verify_seqs()
+ *
+ * Description:
+ *	Verify the downloaded sequencer.  
+ */
+static int
+asd_hwi_verify_seqs(struct asd_softc *asd, uint8_t *code, 
+		    uint32_t code_size, uint8_t lseq_mask)
+{
+	int		error;
+	uint32_t	base_addr;
+	uint32_t	page_offset;
+	uint32_t	instr;
+	uint32_t	i;
+	uint8_t		temp_lseq_mask;	
+	uint8_t		phy_id;
+
+	error = 0;
+	phy_id = 0;
+	temp_lseq_mask = lseq_mask;	
+	do {	
+		if (temp_lseq_mask == 0) {
+			/* Get CSEQ Instruction RAM base addr. */
+			base_addr = CSEQ_RAM_REG_BASE_ADR;
+		} else {
+			for ( ; phy_id < asd->hw_profile.max_phys; phy_id++) {
+				if (temp_lseq_mask & (1 << phy_id)) {
+					temp_lseq_mask &= ~(1 << phy_id);
+					break;
+				}
+			}
+			
+			/* Get the LmSEQ Instruction RAM base addr. */
+			base_addr = (uint32_t) LmSEQRAM(phy_id);;
+			/*
+			 * Set the LmSEQ Instruction Memory Page to 0.
+			 * LmSEQRAM is mapped 4KB in internal memory space.
+			 */
+			asd_hwi_swb_write_dword(asd, LmBISTCTL1(phy_id), 0);
+		}	
+		
+		page_offset = 0;
+		for (i = 0; i < (code_size/4); i++) {
+			if ((base_addr != CSEQ_RAM_REG_BASE_ADR) && (i > 0) &&
+			    ((i % 1024) == 0)) {
+				/*
+			 	 * For LSEQ, we need to adjust the LmSEQ 
+				 * Instruction Memory page to the next 4KB page
+				 * once we past the page boundary.
+				 */
+				asd_hwi_swb_write_dword(asd, 
+							LmBISTCTL1(phy_id), 
+							((i / 1024) <<
+							 LmRAMPAGE_LSHIFT));
+				page_offset = 0;		 
+			}				  
+		
+			/* 
+		 	 * Compare dword at a time since Instruction RAM page is
+		 	 * dword accessible read only.
+		 	 */ 
+			instr = asd_htole32(*(uint32_t *)&code[i*4]);
+			if (instr != asd_hwi_swb_read_dword(asd, 
+					base_addr + page_offset)) {
+				/* Code doesn't match. */
+				error = -1;
+				break;
+			}
+			page_offset += 4;
+		}
+		/* Done verifing the sequencer(s). */
+		if (temp_lseq_mask == 0)
+			break;
+	} while (error == 0);
+
+	return (error);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_setup_seqs()
+ *
+ * Description:
+ *	Setup and initialize Central and Link sequencers.  
+ */
+void
+asd_hwi_setup_seqs(struct asd_softc *asd)
+{
+	int 		link_num;
+	uint8_t		enabled_phys;
+
+#define ASD_SET_INT_VEC(asd, vec)	\
+	(ASD_USE_A1_CODE(asd) == 1 ? ASD_INT_VEC(vec, A1) :	\
+	 ASD_INT_VEC(vec, B0))
+
+	/* Initialize CSEQ Scratch RAM registers. */
+	asd_hwi_init_cseq_scratch(asd);
+	
+	/* Initialize LmSEQ Scratch RAM registers. */
+	asd_hwi_init_lseq_scratch(asd);
+
+	/* Initialize SCB sites. */
+	asd_hwi_init_scb_sites(asd);
+
+	/* Initialize CSEQ CIO registers. */
+	asd_hwi_init_cseq_cio(asd);
+		
+	/* Initialize LmSEQ CIO registers. */
+	link_num = 0;
+	enabled_phys = asd->hw_profile.enabled_phys;
+
+	while (enabled_phys != 0) { 
+		for ( ; link_num < asd->hw_profile.max_phys; link_num++) {
+			if (enabled_phys & (1 << link_num)) {
+				enabled_phys &= ~(1 << link_num);
+				break;
+			} 
+		}
+		
+		asd_hwi_init_lseq_cio(asd, link_num);
+	}
+
+	asd_hwi_post_init_cseq(asd);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_cseq_init_scratch()
+ *
+ * Description:
+ *	Setup and initialize Central sequencers. Initialiaze the mode 
+ *	independent and dependent scratch page to the default settings.
+ */
+static void
+asd_hwi_init_cseq_scratch(struct asd_softc *asd)
+{
+	/* Reset SCBPRO count register. */
+	asd_write_dword(asd, SCBPRO, asd->qinfifonext);
+
+	/* Initialize CSEQ Mode Independent Page. */
+	asd_hwi_init_cseq_mip(asd);
+	/* Initialize CSEQ Mode Dependent Page. */
+	asd_hwi_init_cseq_mdp(asd);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_cseq_mip()
+ *
+ * Description:
+ *	Initialize CSEQ Mode Independent Pages 4-7.	 
+ */
+static void
+asd_hwi_init_cseq_mip(struct asd_softc *asd)
+{
+	uint8_t		free_scb_mask;
+	u_int		i;
+	
+	/* CSEQ Mode Independent , page 4 setup. */
+	asd_hwi_swb_write_word(asd, CSEQ_Q_EXE_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_EXE_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_DONE_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_DONE_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_SEND_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_SEND_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_DMA2CHIM_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_DMA2CHIM_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_COPY_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_COPY_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_REG0, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_REG1, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_REG2, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_REG3, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_LINK_CTL_Q_MAP, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_SCRATCH_FLAGS, 0x0);
+
+	/* CSEQ Mode Independent , page 5 setup. */
+	/* Calculate the free scb mask. */
+	free_scb_mask = (uint8_t) ((~(((asd->hw_profile.max_scbs * 
+					ASD_SCB_SIZE) / 128) - 1)) >> 8);
+
+	asd_hwi_swb_write_byte(asd, CSEQ_FREE_SCB_MASK, free_scb_mask);
+			       		       
+	/* 
+	 * Fill BUILTIN_FREE_SCB_HEAD with the first scb no. and 
+	 * BUILTIN_FREE_SCB_TAIL with the last scb no.
+	 */
+	asd_hwi_swb_write_word(asd, CSEQ_BUILTIN_FREE_SCB_HEAD, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_BUILTIN_FREE_SCB_TAIL,
+			      ((((ASD_MAX_SCB_SITES-1) & 0xFF) == 0xFF) ?
+			      (ASD_MAX_SCB_SITES-2) : (ASD_MAX_SCB_SITES-1))); 
+		
+	/* Extended SCB sites are not being used now. */
+	asd_hwi_swb_write_word(asd, CSEQ_EXTNDED_FREE_SCB_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_EXTNDED_FREE_SCB_TAIL, 0xFFFF);
+
+	/* CSEQ Mode Independent , page 6 setup. */
+	asd_hwi_swb_write_word(asd, CSEQ_INT_ROUT_RET_ADDR0, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_INT_ROUT_RET_ADDR1, 0x0);	
+	asd_hwi_swb_write_word(asd, CSEQ_INT_ROUT_SCBPTR, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_INT_ROUT_MODE, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_ISR_SCRATCH_FLAGS, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_ISR_SAVE_SINDEX, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_ISR_SAVE_DINDEX, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_SLS_SAVE_ACCUM, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_SLS_SAVE_SINDEX, 0x0);
+	
+	/* CSEQ Mode Independent , page 7 setup. */
+	for (i = 0; i < 8; i = i+4) {
+		asd_hwi_swb_write_dword(asd,
+				       (CSEQ_EMPTY_REQ_QUEUE + i),
+					0x0);
+		asd_hwi_swb_write_dword(asd,
+				       (CSEQ_EMPTY_REQ_COUNT + i),
+					0x0);	
+	}
+	/* Initialize Q_EMPTY_HEAD and Q_EMPTY_TAIL. */
+	asd_hwi_swb_write_word(asd, CSEQ_Q_EMPTY_HEAD, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_Q_EMPTY_TAIL, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_NEED_EMPTY_SCB, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_EMPTY_REQ_HEAD, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_EMPTY_REQ_TAIL, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_EMPTY_SCB_OFFSET, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_PRIMITIVE_DATA, 0x0);
+	asd_hwi_swb_write_dword(asd, CSEQ_TIMEOUT_CONSTANT, 0x0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_cseq_mdp()
+ *
+ * Description:
+ *	Initialize CSEQ Mode Dependent Pages.	 
+ */
+static void	
+asd_hwi_init_cseq_mdp(struct asd_softc *asd)
+{
+	u_int	i;
+	u_int	mode_offset; 
+	
+	mode_offset = CSEQ_PAGE_SIZE * 2;
+	
+	/* CSEQ Mode Dependent 0-7, page 0 setup. */
+	for (i = 0; i < 8; i++) {
+		asd_hwi_swb_write_word(asd, ((i * mode_offset) + 
+				       CSEQ_LRM_SAVE_SINDEX), 0x0);
+		asd_hwi_swb_write_word(asd, ((i * mode_offset) + 
+				       CSEQ_LRM_SAVE_SCBPTR), 0x0);
+		asd_hwi_swb_write_word(asd, ((i * mode_offset) + 
+				       CSEQ_Q_LINK_HEAD), 0xFFFF);
+		asd_hwi_swb_write_word(asd, ((i * mode_offset) +
+				       CSEQ_Q_LINK_TAIL), 0xFFFF);
+	}
+	
+	/* CSEQ Mode Dependent 0-7, page 1 and 2 shall be ignored. */
+
+	/* CSEQ Mode Dependent 8, page 0 setup. */
+	asd_hwi_swb_write_word(asd, CSEQ_RET_ADDR, 0xFFFF);
+	asd_hwi_swb_write_word(asd, CSEQ_RET_SCBPTR, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_SAVE_SCBPTR, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_EMPTY_TRANS_CTX, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_RESP_LEN, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_TMF_SCBPTR, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_GLOBAL_PREV_SCB, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_GLOBAL_HEAD, 0x0);
+	asd_hwi_swb_write_byte(asd, CSEQ_TMF_OPCODE, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_CLEAR_LU_HEAD, 0x0);
+	asd_hwi_swb_write_word(asd, CSEQ_FIRST_INV_SCB_SITE,
+			       ASD_MAX_SCB_SITES);
+	asd_hwi_swb_write_word(asd, CSEQ_FIRST_INV_DDB_SITE, ASD_MAX_DDBS);
+
+	/* CSEQ Mode Dependent 8, page 1 setup. */
+	asd_hwi_swb_write_dword(asd, CSEQ_LUN_TO_CLEAR, 0x0);
+	asd_hwi_swb_write_dword(asd, (CSEQ_LUN_TO_CLEAR + 4), 0x0);
+	asd_hwi_swb_write_dword(asd, CSEQ_LUN_TO_CHECK, 0x0);
+	asd_hwi_swb_write_dword(asd, (CSEQ_LUN_TO_CHECK + 4), 0x0);
+
+	/* CSEQ Mode Dependent 8, page 2 setup. */
+	/* Advertise the first SCB site address to the sequencer. */
+	asd_hwi_set_hw_addr(asd, CSEQ_Q_NEW_POINTER,
+			    asd->next_queued_hscb_busaddr);
+
+	/* Advertise the first Done List address to the sequencer.*/
+	asd_hwi_set_hw_addr(asd, CSEQ_Q_DONE_BASE,
+			    asd->shared_data_map.busaddr);
+
+	/* 
+	 * Initialize the Q_DONE_POINTER with the least significant bytes of 
+	 * the first Done List address.
+	 */
+	asd_hwi_swb_write_dword(asd, CSEQ_Q_DONE_POINTER,
+				ASD_GET_PADR(asd->shared_data_map.busaddr));
+
+	asd_hwi_swb_write_byte(asd, CSEQ_Q_DONE_PASS, ASD_QDONE_PASS_DEF);
+	
+	/* CSEQ Mode Dependent 8, page 3 shall be ignored. */
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_cseq_cio()
+ *
+ * Description:
+ *	Initialize CSEQ CIO Registers.	 
+ */
+static void
+asd_hwi_init_cseq_cio(struct asd_softc *asd)
+{
+	uint8_t		dl_bits;
+	u_int		i;
+	
+	/* Enabled ARP2HALTC (ARP2 Halted from Halt Code Write). */
+	asd_hwi_swb_write_byte(asd, CARP2INTEN, EN_ARP2HALTC);
+
+	/* Initialize CSEQ Scratch Page to 0x04. */
+	asd_hwi_swb_write_byte(asd, CSCRATCHPAGE, 0x04);
+	
+	/* Initialize CSEQ Mode[0-8] Dependent registers. */	
+	for (i = 0; i < 9; i++) 
+		/* Initialize Scratch Page to 0. */
+		asd_hwi_swb_write_byte(asd, CMnSCRATCHPAGE(i), 0x0);
+	
+	/* 
+	 * CSEQCOMINTEN, CSEQDLCTL, and CSEQDLOFFS are in Mode 8.
+	 */
+	asd_hwi_swb_write_byte(asd, CSEQCOMINTEN, 0x0);
+	
+	/*
+	 * Get the DONELISTSIZE bits by calculate number of DL entry 
+	 * available and set the value to the DoneList Control register.
+	 */
+	dl_bits = ffs(asd->dl_wrap_mask + 1);
+	
+	/* Minimum amount of done lists is 4. Reduce dl_bits by 3. */
+	dl_bits -= 3;
+	asd_hwi_swb_write_byte(asd, CSEQDLCTL, 
+		((asd_hwi_swb_read_byte(asd, CSEQDLCTL) & 
+		 ~DONELISTSIZE_MASK) | dl_bits));
+	
+	asd_hwi_swb_write_byte(asd, CSEQDLOFFS, 0);
+	asd_hwi_swb_write_byte(asd, (CSEQDLOFFS+1), 0);
+
+	/* Reset the Producer mailbox. */
+	asd_write_dword(asd, SCBPRO, 0x0);				
+
+	/* Intialize CSEQ Mode 11 Interrupt Vectors. */
+	asd_hwi_swb_write_word(asd, CM11INTVEC0, 
+			      ((ASD_SET_INT_VEC(asd, CSEQ_INT_VEC0)) / 4));
+	asd_hwi_swb_write_word(asd, CM11INTVEC1,
+			      ((ASD_SET_INT_VEC(asd, CSEQ_INT_VEC1)) / 4));
+	asd_hwi_swb_write_word(asd, CM11INTVEC2,
+			      ((ASD_SET_INT_VEC(asd, CSEQ_INT_VEC2)) / 4));
+
+	/* Reset the ARP2 Program Count. */
+	asd_hwi_swb_write_word(asd, CPRGMCNT, (CSEQ_IDLE_LOOP_ENTRY / 4));
+
+	for (i = 0; i < 8; i++) {
+		/* Intialize Mode n Link m Interrupt Enable. */
+		asd_hwi_swb_write_dword(asd, CMnINTEN(i), EN_CMnRSPMBXF);
+		/* Initialize Mode n Request Mailbox. */
+		asd_hwi_swb_write_dword(asd, CMnREQMBX(i), 0x0);	
+	}
+
+	/* Reset the Consumer mailbox. */
+	asd_hwi_swb_write_dword(asd, CSEQCON, 0x0);
+}
+
+/* 
+ * Function:
+ *	asd_hwi_init_scb_sites()
+ *
+ * Description:
+ *	Initialize HW SCB sites.	 
+ */
+static void
+asd_hwi_init_scb_sites(struct asd_softc *asd)
+{
+	uint16_t	site_no;
+	uint16_t	next_site_no;
+	u_int		i;
+ 
+	for (site_no = 0; site_no < ASD_MAX_SCB_SITES; site_no++) {
+		/* 
+		 * Adjust to the SCB site that we want to access in command
+		 * context memory.
+		 */	 
+		asd_hwi_set_scbptr(asd, site_no);
+		
+		/* Initialize all fields in the SCB site to 0. */
+		for (i = 0; i < ASD_SCB_SIZE; i += 4)
+			asd_hwi_set_scbsite_dword(asd, i, 0x0);
+
+		/*
+		 * Workaround needed by SEQ to fix a SATA issue is to skip
+	      	 * including scb sites that ended with FFh in the sequencer
+		 * free list.
+		 */
+		if ((site_no & 0xF0FF) == 0x00FF)
+			continue;
+		
+		/*
+		 * For every SCB site, we need to initialize the following 
+		 * fields: Q_NEXT, SCB_OPCODE, SCB_FLAGS, and SG Element Flag.
+		 */
+
+		next_site_no = ((((site_no+1) & 0xF0FF) == 0x00FF) ?
+				  (site_no+2) : (site_no+1));
+
+		/* 
+	 	 * Set the Q_NEXT of last usable SCB site to 0xFFFF.
+	 	 */
+		if (next_site_no >= ASD_MAX_SCB_SITES)
+			next_site_no = 0xFFFF;
+
+		/* 
+		 * Initialize Q_NEXT field to point to the next SCB site.
+		 */
+		asd_hwi_set_scbsite_word(asd, SCB_SITE_Q_NEXT, next_site_no);
+		
+		/* Initialize SCB Site Opcode field. */
+		asd_hwi_set_scbsite_byte(asd, 
+					 offsetof(struct hscb_header, opcode),
+					 0xFF);	
+
+		/* Initialize SCB Site Flags field. */
+		asd_hwi_set_scbsite_byte(asd, SCB_SITE_FLAGS, 0x01);	
+		/* 
+		 * Set the first SG Element flag to no data transfer.
+		 * Also set Domain Select to OffChip memory. 
+		 */
+		asd_hwi_set_scbsite_byte(asd, 
+					 offsetof(struct asd_ssp_task_hscb,
+					 	  sg_elements[0].flags),
+					 SG_NO_DATA);
+	}
+}

