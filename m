From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/5] aic7xxx: teach aicasm to not emit unused debug code/data
Date: Fri, 25 Apr 2008 04:41:43 +0200
Message-ID: <200804250441.43480.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250434.49377.vda.linux@googlemail.com> <200804250436.01295.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nTUEIJEhj2O6zlR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:29476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYDYCm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:42:58 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3382974fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:42:56 -0700 (PDT)
In-Reply-To: <200804250436.01295.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

--Boundary-00=_nTUEIJEhj2O6zlR
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Add "dont_generate_debug_code" syntax handling to aicasm_gram.y

aic79xx.reg, aic7xxx.reg: add dont_generate_debug_code keyword
for registers which are never referenced by the driver.

aicasm.c, aicasm_symbol.[ch]: don't emit code for those regs;
also add "const" keyword to generated code in few places.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_nTUEIJEhj2O6zlR
Content-Type: text/x-diff;
  charset="koi8-r";
  name="aic_debloat_4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aic_debloat_4.diff"

--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx.reg	Thu Apr 24 07:48:38 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic79xx.reg	Fri Apr 25 04:23:56 2008
@@ -79,8 +79,14 @@
 		mvi	SEQINTCODE, code;				\
 	}
 
 /*
+ * Registers marked "dont_generate_debug_code" are not (yet) referenced
+ * from the driver code, and this keyword inhibit generation
+ * of debug code for them.
+ */
+
+/*
  * Mode Pointer
  * Controls which of the 5, 512byte, address spaces should be used
  * as the source and destination of any register accesses in our
  * register window.
@@ -90,8 +96,9 @@
 	access_mode	RW
 	field	DST_MODE	0x70
 	field	SRC_MODE	0x07
 	mode_pointer
+	dont_generate_debug_code
 }
 
 const SRC_MODE_SHIFT	0
 const DST_MODE_SHIFT	4
@@ -189,8 +196,9 @@
 		TRACEPOINT3,
 		SAW_HWERR,
 		BAD_SCB_STATUS
 	}
+	dont_generate_debug_code
 }
 
 /*
  * Clear Host Interrupt
@@ -205,8 +213,9 @@
 	field	CLRSCSIINT	0x08
 	field	CLRSEQINT	0x04
 	field	CLRCMDINT	0x02
 	field	CLRSPLTINT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Error Register
@@ -220,8 +229,9 @@
 	field	DPARERR		0x10
 	field	SQPARERR	0x08
 	field	ILLOPCODE	0x04
 	field	DSCTMOUT	0x02
+	dont_generate_debug_code
 }
 
 /*
  * Clear Error
@@ -235,8 +245,9 @@
 	field	CLRDPARERR	0x10
 	field	CLRSQPARERR	0x08
 	field	CLRILLOPCODE	0x04
 	field	CLRDSCTMOUT	0x02
+	dont_generate_debug_code
 }
 
 /*
  * Host Control Register
@@ -252,8 +263,9 @@
 	field	PAUSE		0x04
 	field	INTEN		0x02
 	field	CHIPRST		0x01
 	field	CHIPRSTACK	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Host New SCB Queue Offset
@@ -261,16 +273,18 @@
 register HNSCB_QOFF {
 	address			0x006
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * Host Empty SCB Queue Offset
  */
 register HESCB_QOFF {
 	address			0x008
 	access_mode	RW
+	dont_generate_debug_code
 }
 
 /*
  * Host Mailbox
@@ -305,8 +319,9 @@
 	field	CLRSEQ_SEQINT	0x08
 	field	CLRSEQ_SCSIINT	0x04
 	field	CLRSEQ_PCIINT	0x02
 	field	CLRSEQ_SPLTINT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Software Timer
@@ -314,8 +329,9 @@
 register SWTIMER {
 	address			0x00E
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * SEQ New SCB Queue Offset
@@ -324,8 +340,9 @@
 	address			0x010
 	access_mode	RW
 	size		2
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * SEQ Empty SCB Queue Offset
@@ -333,8 +350,9 @@
 register SESCB_QOFF {
 	address			0x012
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * SEQ Done SCB Queue Offset
@@ -343,8 +361,9 @@
 	address			0x014
 	access_mode	RW
 	modes		M_CCHAN
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * Queue Offset Control & Status
@@ -371,8 +390,9 @@
 		SCB_QSIZE_4096,
 		SCB_QSIZE_8192,
 		SCB_QSIZE_16384
 	}
+	dont_generate_debug_code
 }
 
 /*
  * Interrupt Control
@@ -422,8 +442,9 @@
 	field	MPARCKEN	0x20	/* Memory Parity Check Enable */
 	field	EXTREQLCK	0x10	/* External Request Lock */
 	field	DISABLE_TWATE	0x02	/* Rev B or greater */
 	field	CIOPARCKEN	0x01	/* Internal bus parity error enable */
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Status
@@ -450,8 +471,9 @@
 	modes		M_DFF0, M_DFF1
 	field	SG_ADDR_MASK	0xf8
 	field	ODD_SEG		0x04
 	field	LAST_SEG	0x02
+	dont_generate_debug_code
 }
 
 register SG_CACHE_SHADOW {
 	address			0x01B
@@ -472,8 +494,9 @@
 	modes		M_CFG
 	field	RESET_HARB	0x80
 	field	RETRY_SWEN	0x08
 	field	USE_TIME	0x07
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Host Address
@@ -482,8 +505,9 @@
 	address			0x070
 	access_mode	RW
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Host Overlay DMA Address
@@ -492,8 +516,9 @@
 	address			0x070
 	access_mode	RW
 	size		8
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * PCI PLL Delay.
@@ -503,8 +528,9 @@
 	access_mode	RW
 	size		1
 	modes		M_CFG
 	field	SPLIT_DROP_REQ	0x80
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Host Count
@@ -513,8 +539,9 @@
 	address			0x078
 	access_mode	RW
 	size		3
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Host Overlay DMA Count
@@ -523,8 +550,9 @@
 	address			0x078
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Host Overlay DMA Enable
@@ -532,8 +560,9 @@
 register HODMAEN {
 	address			0x07A
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Scatter/Gather Host Address
@@ -542,8 +571,9 @@
 	address			0x07C
 	access_mode	RW
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * SCB Host Address
@@ -552,8 +582,9 @@
 	address			0x07C
 	access_mode	RW
 	size		8
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * Scatter/Gather Host Count
@@ -561,8 +592,9 @@
 register SGHCNT {
 	address			0x084
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * SCB Host Count
@@ -570,8 +602,9 @@
 register SCBHCNT {
 	address			0x084
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Threshold
@@ -599,8 +632,9 @@
 		RD_DFTHRSH_85,
 		RD_DFTHRSH_90,
 		RD_DFTHRSH_MAX
 	}
+	dont_generate_debug_code
 }
 
 /*
  * ROM Address
@@ -608,8 +642,9 @@
 register ROMADDR {
 	address			0x08A
 	access_mode	RW
 	size		3
+	dont_generate_debug_code
 }
 
 /*
  * ROM Control
@@ -620,16 +655,18 @@
 	field	ROMOP		0xE0
 	field	ROMSPD		0x18
 	field	REPEAT		0x02
 	field	RDY		0x01
+	dont_generate_debug_code
 }
 
 /*
  * ROM Data
  */
 register ROMDATA {
 	address			0x08E
 	access_mode	RW
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Receive Message 0
@@ -639,8 +676,9 @@
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field		CDNUM	0xF8
 	field		CFNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * CMC Recieve Message 0
@@ -650,8 +688,9 @@
 	access_mode	RO
 	modes		M_CCHAN
 	field		CDNUM	0xF8
 	field		CFNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Recieve Message 0
@@ -661,8 +700,9 @@
 	access_mode	RO
 	modes		M_SCSI
 	field		CDNUM	0xF8
 	field		CFNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * Relaxed Order Enable
@@ -676,8 +716,9 @@
 	field	CMCROEN		0x08
 	field	SGROEN		0x04
 	field	DCH1ROEN	0x02
 	field	DCH0ROEN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Receive Message 1
@@ -686,8 +727,9 @@
 	address			0x091
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	CBNUM		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * CMC Recieve Message 1
@@ -696,8 +738,9 @@
 	address			0x091
 	access_mode	RO
 	modes		M_CCHAN
 	field	CBNUM		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Recieve Message 1
@@ -706,8 +749,9 @@
 	address			0x091
 	access_mode	RO
 	modes		M_SCSI
 	field	CBNUM		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * No Snoop Enable
@@ -721,8 +765,9 @@
 	field	CMCNSEN		0x08
 	field	SGNSEN		0x04
 	field	DCH1NSEN	0x02
 	field	DCH0NSEN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Receive Message 2
@@ -731,8 +776,9 @@
 	address			0x092
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	MINDEX		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * CMC Recieve Message 2
@@ -741,8 +787,9 @@
 	address			0x092
 	access_mode	RO
 	modes		M_CCHAN
 	field	MINDEX		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Recieve Message 2
@@ -751,8 +798,9 @@
 	address			0x092
 	access_mode	RO
 	modes		M_SCSI
 	field	MINDEX		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * Outstanding Split Transactions
@@ -760,8 +808,9 @@
 register OST {
 	address			0x092
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Receive Message 3
@@ -770,8 +819,9 @@
 	address			0x093
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	MCLASS		0x0F
+	dont_generate_debug_code
 }
 
 /*
  * CMC Recieve Message 3
@@ -780,8 +830,9 @@
 	address			0x093
 	access_mode	RO
 	modes		M_CCHAN
 	field	MCLASS		0x0F
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Recieve Message 3
@@ -790,8 +841,9 @@
 	address			0x093
 	access_mode	RO
 	modes		M_SCSI
 	field	MCLASS		0x0F
+	dont_generate_debug_code
 }
 
 /*
  * PCI-X Control
@@ -806,8 +858,9 @@
 	field	SPLTSTADIS	0x08
 	field	SRSPDPEEN	0x04
 	field	TSCSERREN	0x02
 	field	CMPABCDIS	0x01
+	dont_generate_debug_code
 }
 
 /*
  * CMC Sequencer Byte Count
@@ -815,8 +868,9 @@
 register CMCSEQBCNT {
 	address			0x094
 	access_mode	RO
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Sequencer Byte Count
@@ -824,8 +878,9 @@
 register OVLYSEQBCNT {
 	address			0x094
 	access_mode	RO
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Sequencer Byte Count
@@ -834,8 +889,9 @@
 	address			0x094
 	access_mode	RO
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Split Status 0
@@ -851,8 +907,9 @@
 	field	CNTNOTCMPLT	0x08
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
  * CMC Split Status 0
@@ -868,8 +925,9 @@
 	field	CNTNOTCMPLT	0x08
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Split Status 0
@@ -885,8 +943,9 @@
 	field	CNTNOTCMPLT	0x08
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data Channel Split Status 1
@@ -895,8 +954,9 @@
 	address			0x097
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
  * CMC Split Status 1
@@ -905,8 +965,9 @@
 	address			0x097
 	access_mode	RW
 	modes		M_CCHAN
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Overlay Split Status 1
@@ -915,8 +976,9 @@
 	address			0x097
 	access_mode	RW
 	modes		M_SCSI
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
  * S/G Receive Message 0
@@ -926,8 +988,9 @@
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field		CDNUM	0xF8
 	field		CFNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * S/G Receive Message 1
@@ -936,8 +999,9 @@
 	address			0x099
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	CBNUM		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * S/G Receive Message 2
@@ -946,8 +1010,9 @@
 	address			0x09A
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	MINDEX		0xFF
+	dont_generate_debug_code
 }
 
 /*
  * S/G Receive Message 3
@@ -956,8 +1021,9 @@
 	address			0x09B
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
 	field	MCLASS		0x0F
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Address 0
@@ -966,8 +1032,9 @@
 	address			0x098
 	access_mode	RO
 	modes		M_SCSI
 	field	LOWER_ADDR	0x7F
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Address 1
@@ -977,8 +1044,9 @@
 	access_mode	RO
 	modes		M_SCSI
 	field	REQ_DNUM	0xF8
 	field	REQ_FNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Address 2
@@ -987,8 +1055,9 @@
 	address			0x09A
 	access_mode	RO
 	modes		M_SCSI
 	field	REQ_BNUM	0xFF
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Address 3
@@ -998,8 +1067,9 @@
 	access_mode	RO
 	modes		M_SCSI
 	field	RLXORD		020
 	field	TAG_NUM		0x1F
+	dont_generate_debug_code
 }
 
 /*
  * SG Sequencer Byte Count
@@ -1007,8 +1077,9 @@
 register SGSEQBCNT {
 	address			0x09C
 	access_mode	RO
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Attribute 0
@@ -1017,8 +1088,9 @@
 	address			0x09C
 	access_mode	RO
 	modes		M_SCSI
 	field	LOWER_BCNT	0xFF
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Attribute 1
@@ -1028,8 +1100,9 @@
 	access_mode	RO
 	modes		M_SCSI
 	field	CMPLT_DNUM	0xF8
 	field	CMPLT_FNUM	0x07
+	dont_generate_debug_code
 }
 
 /*
  * Slave Split Out Attribute 2
@@ -1039,8 +1112,9 @@
 	access_mode	RO
 	size		2
 	modes		M_SCSI
 	field	CMPLT_BNUM	0xFF
+	dont_generate_debug_code
 }
 /*
  * S/G Split Status 0
  */
@@ -1055,8 +1129,9 @@
 	field	CNTNOTCMPLT	0x08
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
  * S/G Split Status 1
@@ -1065,8 +1140,9 @@
 	address			0x09F
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Special Function
@@ -1076,8 +1152,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	TEST_GROUP	0xF0
 	field	TEST_NUM	0x0F
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO 0 PCI Status 
@@ -1093,8 +1170,9 @@
 	field	SCAAPERR	0x08
 	field	RDPERR		0x04
 	field	TWATERR		0x02
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO 1 PCI Status 
@@ -1110,8 +1188,9 @@
 	field	SCAAPERR	0x08
 	field	RDPERR		0x04
 	field	TWATERR		0x02
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * S/G PCI Status 
@@ -1126,8 +1205,9 @@
 	field	RTA		0x10
 	field	SCAAPERR	0x08
 	field	RDPERR		0x04
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * CMC PCI Status 
@@ -1143,8 +1223,9 @@
 	field	SCAAPERR	0x08
 	field	RDPERR		0x04
 	field	TWATERR		0x02
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Overlay PCI Status 
@@ -1159,8 +1240,9 @@
 	field	RTA		0x10
 	field	SCAAPERR	0x08
 	field	RDPERR		0x04
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * PCI Status for MSI Master DMA Transfer
@@ -1174,8 +1256,9 @@
 	field	RTA		0x10
 	field	CLRPENDMSI	0x08
 	field	TWATERR		0x02
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
  * PCI Status for Target
@@ -1187,8 +1270,9 @@
 	field	DPE		0x80
 	field	SSE		0x40
 	field	STA		0x08
 	field	TWATERR		0x02
+	dont_generate_debug_code
 }
 
 /*
  * LQ Packet In
@@ -1198,8 +1282,9 @@
 	address			0x020
 	access_mode	RW
 	size		20
 	modes		M_DFF0, M_DFF1, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * SCB Type Pointer
@@ -1208,8 +1293,9 @@
 register TYPEPTR {
 	address			0x020
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Queue Tag Pointer
@@ -1218,8 +1304,9 @@
 register TAGPTR {
 	address			0x021
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Logical Unit Number Pointer
@@ -1228,8 +1315,9 @@
 register LUNPTR {
 	address			0x022
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data Length Pointer
@@ -1238,8 +1326,9 @@
 register DATALENPTR {
 	address			0x023
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Status Length Pointer
@@ -1248,8 +1337,9 @@
 register STATLENPTR {
 	address			0x024
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Command Length Pointer
@@ -1258,8 +1348,9 @@
 register CMDLENPTR {
 	address			0x025
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Task Attribute Pointer
@@ -1269,8 +1360,9 @@
 register ATTRPTR {
 	address			0x026
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Task Management Flags Pointer
@@ -1280,8 +1372,9 @@
 register FLAGPTR {
 	address			0x027
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Command Pointer
@@ -1290,8 +1383,9 @@
 register CMDPTR {
 	address			0x028
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Queue Next Pointer
@@ -1300,8 +1394,9 @@
 register QNEXTPTR {
 	address			0x029
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * SCSI ID Pointer
@@ -1311,8 +1406,9 @@
 register IDPTR {
 	address			0x02A
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Command Aborted Byte Pointer
@@ -1322,8 +1418,9 @@
 register ABRTBYTEPTR {
 	address			0x02B
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Command Aborted Bit Pointer
@@ -1332,8 +1429,9 @@
 register ABRTBITPTR {
 	address			0x02C
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Rev B or greater.
@@ -1341,8 +1439,9 @@
 register MAXCMDBYTES {
 	address			0x02D
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Rev B or greater.
@@ -1350,8 +1449,9 @@
 register MAXCMD2RCV {
 	address			0x02E
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Rev B or greater.
@@ -1359,8 +1459,9 @@
 register SHORTTHRESH {
 	address			0x02F
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Logical Unit Number Length
@@ -1371,8 +1472,9 @@
 	access_mode	RW
 	modes		M_CFG
 	mask		ILUNLEN	0x0F
 	mask		TLUNLEN	0xF0
+	dont_generate_debug_code
 }
 const LUNLEN_SINGLE_LEVEL_LUN 0xF
 
 /*
@@ -1382,8 +1484,9 @@
 register CDBLIMIT {
 	address			0x031
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Maximum Commands
@@ -1393,8 +1496,9 @@
 register MAXCMD {
 	address			0x032
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Maximum Command Counter
@@ -1403,8 +1507,9 @@
 register MAXCMDCNT {
 	address			0x033
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * LQ Packet Reserved Bytes
@@ -1414,18 +1519,21 @@
 register LQRSVD01 {
 	address			0x034
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 register LQRSVD16 {
 	address			0x035
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 register LQRSVD17 {
 	address			0x036
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Command Reserved 0
@@ -1435,8 +1543,9 @@
 register CMDRSVD0 {
 	address			0x037
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * LQ Manager Control 0
@@ -1448,8 +1557,9 @@
 	field	LQITARGCLT	0xC0
 	field	LQIINITGCLT	0x30
 	field	LQ0TARGCLT	0x0C
 	field	LQ0INITGCLT	0x03
+	dont_generate_debug_code
 }
 
 /*
  * LQ Manager Control 1
@@ -1460,8 +1570,9 @@
 	modes		M_DFF0, M_DFF1, M_SCSI
 	field	PCI2PCI		0x04
 	field	SINGLECMD	0x02
 	field	ABORTPENDING	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQ Manager Control 2
@@ -1477,8 +1588,9 @@
 	field	LQORETRY	0x08
 	field	LQOCONTINUE	0x04
 	field	LQOTOIDLE	0x02
 	field	LQOPAUSE	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI RAM BIST0
@@ -1492,8 +1604,9 @@
 	field	GSBISTRUN	0x10
 	field	OSBISTERR	0x04
 	field	OSBISTDONE	0x02
 	field	OSBISTRUN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Sequence Control0
@@ -1518,8 +1631,9 @@
 	modes		M_CFG
 	field	NTBISTERR	0x04
 	field	NTBISTDONE	0x02
 	field	NTBISTRUN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Sequence Control 1
@@ -1546,8 +1660,9 @@
 	field	DFON		0x80
 	field	DFPEXP		0x40
 	field	BIOSCANCELEN	0x10
 	field	SPIOEN		0x08
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Transfer Control 1
@@ -1562,8 +1677,9 @@
 	field	STIMESEL	0x18
 	field	ENSTIMER	0x04
 	field	ACTNEGEN	0x02
 	field	STPWEN		0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Transfer Control 2
@@ -1574,8 +1690,9 @@
 	modes		M_SCSI
 	field	AUTORSTDIS	0x10
 	field	CMDDMAEN	0x08
 	field	ASU		0x07
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Bus Initiator IDs
@@ -1585,8 +1702,9 @@
 	address			0x03C
 	access_mode	RW
 	modes		M_CFG
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * Data Length Counters
@@ -1596,8 +1714,9 @@
 	address			0x03C
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
 	size		3
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Status
@@ -1634,8 +1753,9 @@
 	address			0x03E
 	access_mode	RW
 	modes		M_CFG
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Control Signal Out
@@ -1664,8 +1784,9 @@
 		P_MESGOUT	CDO|MSGO,
 		P_STATUS	CDO|IOO,
 		P_MESGIN	CDO|IOO|MSGO
 	}
+	dont_generate_debug_code
 }
 
 register SCSISIGI {
 	address			0x041
@@ -1702,8 +1823,9 @@
 	address			0x040
 	access_mode	RW
 	modes		M_CFG
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Phase
@@ -1728,8 +1850,9 @@
 register SCSIDAT0_IMG {
 	address			0x043
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Latched Data
@@ -1738,8 +1861,9 @@
 	address			0x044
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Data Bus
@@ -1759,8 +1883,9 @@
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
 	field	CLKOUT		0x80
 	field	TARGID		0x0F
+	dont_generate_debug_code
 }
 
 /*
  * Selection/Reselection ID
@@ -1788,8 +1913,9 @@
 	field	DIAGLEDON	0x40
 	field	ENAB40		0x08	/* LVD transceiver active */
 	field	ENAB20		0x04	/* SE/HVD transceiver active */
 	field	SELWIDE		0x02
+	dont_generate_debug_code
 }
 
 /*
  * Option Mode
@@ -1804,8 +1930,9 @@
 	field	BUSFREEREV		0x10
 	field	ENDGFORMCHK		0x04
 	field	AUTO_MSGOUT_DE		0x02
 	mask	OPTIONMODE_DEFAULTS	AUTO_MSGOUT_DE
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Status 0
@@ -1838,8 +1965,9 @@
 	field	CLRIOERR	0x08
 	field	CLROVERRUN	0x04
 	field	CLRSPIORDY	0x02
 	field	CLRARBDO	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Interrupt Mode 0
@@ -1890,8 +2018,9 @@
 	field	CLRBUSFREE	0x08
 	field	CLRSCSIPERR	0x04
 	field	CLRSTRB2FAST	0x02
 	field	CLRREQINIT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Status 2
@@ -1923,8 +2052,9 @@
 	field	CLRNONPACKREQ	0x20
 	field	CLRWIDE_RES	0x04	/* Modes 0 and 1 only */
 	field	CLRSDONE	0x02	/* Modes 0 and 1 only */
 	field	CLRDMADONE	0x01	/* Modes 0 and 1 only */
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Interrupt Mode 2
@@ -1935,8 +2065,9 @@
 	modes		M_CFG
 	field	ENWIDE_RES	0x04
 	field	ENSDONE		0x02
 	field	ENDMADONE	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Physical Error Diagnosis
@@ -1961,8 +2092,9 @@
 register LQISTATE {
 	address			0x04E
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Offset Count
@@ -1979,8 +2111,9 @@
 register LQOSTATE {
 	address			0x04F
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * LQI Manager Status
@@ -2009,8 +2142,9 @@
 	field	CLRLQICRCT2	0x08
 	field	CLRLQIBADLQT	0x04
 	field	CLRLQIATNLQ	0x02
 	field	CLRLQIATNCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQI Manager Interrupt Mode 0
@@ -2024,8 +2158,9 @@
 	field	ENLQICRCT2	0x08
 	field	ENLQIBADLQT	0x04
 	field	ENLQIATNLQ	0x02
 	field	ENLQIATNCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQI Manager Status 1
@@ -2058,8 +2193,9 @@
 	field	CLRLQICRCI_NLQ	0x08
 	field	CLRLQIBADLQI	0x04
 	field	CLRLQIOVERI_LQ	0x02
 	field	CLRLQIOVERI_NLQ	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQI Manager Interrupt Mode 1
@@ -2075,8 +2211,9 @@
 	field	ENLQICRCI_NLQ	0x08	/* LQICRCI2 */
 	field	ENLQIBADLQI	0x04
 	field	ENLQIOVERI_LQ	0x02	/* LQIOVERI1 */
 	field	ENLQIOVERI_NLQ	0x01	/* LQIOVERI2 */
+	dont_generate_debug_code
 }
 
 /*
  * LQI Manager Status 2
@@ -2114,8 +2251,9 @@
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
 	field	CLRNTRAMPERR	0x02
 	field	CLROSRAMPERR	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Interrupt Mode 3
@@ -2125,8 +2263,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	ENNTRAMPERR	0x02
 	field	ENOSRAMPERR	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQO Manager Status 0
@@ -2153,8 +2292,9 @@
 	field	CLRLQOSTOPT2		0x08
 	field	CLRLQOATNLQ		0x04
 	field	CLRLQOATNPKT		0x02
 	field	CLRLQOTCRC		0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQO Manager Interrupt Mode 0
@@ -2167,8 +2307,9 @@
 	field	ENLQOSTOPT2		0x08
 	field	ENLQOATNLQ		0x04
 	field	ENLQOATNPKT		0x02
 	field	ENLQOTCRC		0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQO Manager Status 1
@@ -2195,8 +2336,9 @@
 	field	CLRLQOSTOPI2		0x08
 	field	CLRLQOBADQAS		0x04
 	field	CLRLQOBUSFREE		0x02
 	field	CLRLQOPHACHGINPKT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQO Manager Interrupt Mode 1
@@ -2209,8 +2351,9 @@
 	field	ENLQOSTOPI2		0x08
 	field	ENLQOBADQAS		0x04
 	field	ENLQOBUSFREE		0x02
 	field	ENLQOPHACHGINPKT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * LQO Manager Status 2
@@ -2231,8 +2374,9 @@
 register OS_SPACE_CNT {
 	address			0x056
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Interrupt Mode 1
@@ -2260,8 +2404,9 @@
 	address			0x058
 	access_mode	RO
 	size		2
 	modes		M_DFF0, M_DFF1, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO SCSI Transfer Control
@@ -2283,8 +2428,9 @@
 	address			0x05A
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /* Rev B only. */
 register LQOSCSCTL {
@@ -2293,8 +2439,9 @@
 	size		1
 	modes		M_CFG
 	field		LQOH2A_VERSION	0x80
 	field		LQONOCHKOVER	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SEQ Interrupts
@@ -2325,8 +2472,9 @@
 	field	CLRCFG4ISTAT	0x08
 	field	CLRCFG4TSTAT	0x04
 	field	CLRCFG4ICMD	0x02
 	field	CLRCFG4TCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SEQ Interrupt Enabled (Shared)
@@ -2351,8 +2499,9 @@
 	address			0x05C
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Status
@@ -2377,8 +2526,9 @@
 	address			0x05d
 	access_mode	RW
 	modes		M_CFG
 	field	CRCVALCHKEN		0x40
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Test Control
@@ -2388,8 +2538,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	CNTRTEST	0x08
 	field	SEL_TXPLL_DEBUG	0x04
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Queue Tag
@@ -2398,8 +2549,9 @@
 	address			0x05E
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Last SCSI Control Block
@@ -2408,8 +2560,9 @@
 	address			0x05E
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * SCSI I/O Cell Power-down Control
@@ -2420,8 +2573,9 @@
 	modes		M_CFG
 	field	DISABLE_OE	0x80
 	field	PDN_IDIST	0x04
 	field	PDN_DIFFSENSE	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Shaddow Host Address.
@@ -2430,8 +2584,9 @@
 	address			0x060
 	access_mode	RO
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Data Group CRC Interval.
@@ -2440,8 +2595,9 @@
 	address			0x060
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data Transfer Negotiation Address
@@ -2449,8 +2605,9 @@
 register NEGOADDR {
 	address			0x060
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data Transfer Negotiation Data - Period Byte
@@ -2458,8 +2615,9 @@
 register NEGPERIOD {
 	address			0x061
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Packetized CRC Interval
@@ -2468,8 +2626,9 @@
 	address			0x062
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data Transfer Negotiation Data - Offset Byte
@@ -2477,8 +2636,9 @@
 register NEGOFFSET {
 	address			0x062
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data Transfer Negotiation Data - PPR Options
@@ -2490,8 +2650,9 @@
 	field	PPROPT_PACE	0x08
 	field	PPROPT_QAS	0x04
 	field	PPROPT_DT	0x02
 	field	PPROPT_IUT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data Transfer Negotiation Data -  Connection Options
@@ -2506,8 +2667,9 @@
 	field	ENSLOWCRC	0x08
 	field	ENAUTOATNI	0x04
 	field	ENAUTOATNO	0x02
 	field	WIDEXFER	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Negotiation Table Annex Column Index.
@@ -2515,8 +2677,9 @@
 register ANNEXCOL {
 	address			0x065
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 register SCSCHKN {
 	address			0x066
@@ -2528,8 +2691,9 @@
 	field	SDONEMSKDIS	0x08
 	field	DFFACTCLR	0x04
 	field	SHVALIDSTDIS	0x02
 	field	LSTSGCLRDIS	0x01
+	dont_generate_debug_code
 }
 
 const AHD_ANNEXCOL_PER_DEV0	4
 const AHD_NUM_PER_DEV_ANNEXCOLS	4
@@ -2560,8 +2724,9 @@
 register ANNEXDAT {
 	address			0x066
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Initiator's Own Id.
@@ -2570,8 +2735,9 @@
 register IOWNID {
 	address			0x067
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * 960MHz Phase-Locked Loop Control 0
@@ -2586,8 +2752,9 @@
 	field	PLL_ENLUD	0x08
 	field	PLL_ENLPF	0x04
 	field	PLL_DLPF	0x02
 	field	PLL_ENFBM	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Target Own Id
@@ -2595,8 +2762,9 @@
 register TOWNID {
 	address			0x069
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * 960MHz Phase-Locked Loop Control 1
@@ -2607,8 +2775,9 @@
 	modes		M_CFG
 	field	PLL_CNTEN	0x80
 	field	PLL_CNTCLR	0x40
 	field	PLL_RST		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Expander Signature
@@ -2616,8 +2785,9 @@
 register XSIG {
 	address			0x06A
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Shadow Byte Count
@@ -2626,8 +2796,9 @@
 	address			0x068
 	access_mode	RW
 	size		3
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Selection Out ID
@@ -2645,8 +2816,9 @@
 	address			0x06A
 	access_mode	RO
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * 400-MHz Phase-Locked Loop Control 0
@@ -2661,8 +2833,9 @@
 	field	PLL_ENLUD	0x08
 	field	PLL_ENLPF	0x04
 	field	PLL_DLPF	0x02
 	field	PLL_ENFBM	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Arbitration Fairness
@@ -2671,8 +2844,9 @@
 	address			0x06C
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * 400-MHz Phase-Locked Loop Control 1
@@ -2683,8 +2857,9 @@
 	modes		M_CFG
 	field	PLL_CNTEN	0x80
 	field	PLL_CNTCLR	0x40
 	field	PLL_RST		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Arbitration Unfairness
@@ -2693,8 +2868,9 @@
 	address			0x06E
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * 400-MHz Phase-Locked Loop Test Count
@@ -2703,8 +2879,9 @@
 	address			0x06E
 	access_mode	RO
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * SCB Page Pointer
@@ -2713,8 +2890,9 @@
 	address			0x0A8
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1, M_CCHAN, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * CMC SCB Array Count
@@ -2724,8 +2902,9 @@
 register CCSCBACNT {
 	address			0x0AB
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * SCB Autopointer
@@ -2739,8 +2918,9 @@
 	modes		M_CFG
 	field	AUSCBPTR_EN	0x80
 	field	SCBPTR_ADDR	0x38
 	field	SCBPTR_OFF	0x07
+	dont_generate_debug_code
 }
 
 /*
  * CMC SG Ram Address Pointer
@@ -2748,8 +2928,9 @@
 register CCSGADDR {
 	address			0x0AC
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * CMC SCB RAM Address Pointer
@@ -2757,8 +2938,9 @@
 register CCSCBADDR {
 	address			0x0AC
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * CMC SCB Ram Back-up Address Pointer
@@ -2768,8 +2950,9 @@
 register CCSCBADR_BK {
 	address			0x0AC
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * CMC SG Control
@@ -2813,8 +2996,9 @@
 	field	SG_BIST_FAIL		0x20
 	field	SG_BIST_EN		0x10
 	field	CMC_BUFFER_BIST_FAIL	0x02
 	field	CMC_BUFFER_BIST_EN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * CMC SG RAM Data Port
@@ -2822,8 +3006,9 @@
 register CCSGRAM {
 	address			0x0B0
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * CMC SCB RAM Data Port
@@ -2831,8 +3016,9 @@
 register CCSCBRAM {
 	address			0x0B0
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
  * Flex DMA Address.
@@ -2841,8 +3027,9 @@
 	address			0x0B0
 	access_mode	RW
 	size		3
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Flex DMA Byte Count
@@ -2851,8 +3038,9 @@
 	address			0x0B3
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Flex DMA Status
@@ -2862,8 +3050,9 @@
 	access_mode	RW
 	modes		M_SCSI
 	field	FLEXDMAERR	0x02
 	field	FLEXDMADONE	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Flex DMA Data Port
@@ -2871,8 +3060,9 @@
 register FLEXDATA {
 	address			0x0B6
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Board Data
@@ -2880,8 +3070,9 @@
 register BRDDAT {
 	address			0x0B8
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Board Control
@@ -2895,8 +3086,9 @@
 	field	BRDADDR		0x38
 	field	BRDEN		0x04
 	field	BRDRW		0x02
 	field	BRDSTB		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Serial EEPROM Address
@@ -2904,8 +3096,9 @@
 register SEEADR {
 	address			0x0BA
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Serial EEPROM Data
@@ -2914,8 +3107,9 @@
 	address			0x0BC
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Serial EEPROM Status
@@ -2929,8 +3123,9 @@
 	field	LDALTID_L	0x08
 	field	SEEARBACK	0x04
 	field	SEEBUSY		0x02
 	field	SEESTART	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Serial EEPROM Control
@@ -2953,8 +3148,9 @@
 	mask	SEEOP_WALL	0x40
 	mask	SEEOP_EWDS	0x40
 	field	SEERST		0x02
 	field	SEESTART	0x01
+	dont_generate_debug_code
 }
 
 const SEEOP_ERAL_ADDR	0x80
 const SEEOP_EWEN_ADDR	0xC0
@@ -2967,8 +3163,9 @@
 register SCBCNT {
 	address			0x0BF
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Write Address
@@ -2978,8 +3175,9 @@
 	address			0x0C0
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * DSP Filter Control
@@ -2990,8 +3188,9 @@
 	modes		M_CFG
 	field	FLTRDISABLE	0x20
 	field	EDGESENSE	0x10
 	field	DSPFCNTSEL	0x0F
+	dont_generate_debug_code
 }
 
 /*
  * DSP Data Channel Control
@@ -3003,8 +3202,9 @@
 	field	BYPASSENAB	0x80
 	field	DESQDIS		0x10
 	field	RCVROFFSTDIS	0x04
 	field	XMITOFFSTDIS	0x02
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Read Address
@@ -3014,8 +3214,9 @@
 	address			0x0C2
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * DSP REQ Control
@@ -3025,8 +3226,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	MANREQCTL	0xC0
 	field	MANREQDLY	0x3F
+	dont_generate_debug_code
 }
 
 /*
  * DSP ACK Control
@@ -3036,8 +3238,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	MANACKCTL	0xC0
 	field	MANACKDLY	0x3F
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Data
@@ -3048,8 +3251,9 @@
 register DFDAT {
 	address			0x0C4
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * DSP Channel Select
@@ -3059,8 +3263,9 @@
 	access_mode	RW
 	modes		M_CFG
 	field	AUTOINCEN	0x80
 	field	DSPSEL		0x1F
+	dont_generate_debug_code
 }
 
 const NUMDSPS 0x14
 
@@ -3072,8 +3277,9 @@
 	access_mode	WO
 	modes		M_CFG
 	field	AUTOXBCDIS	0x80
 	field	XMITMANVAL	0x3F
+	dont_generate_debug_code
 }
 
 /*
  * Currently the WRTBIASCTL is the same as the default.
@@ -3088,8 +3294,9 @@
 	access_mode	WO
 	modes		M_CFG
 	field	AUTORBCDIS	0x80
 	field	RCVRMANVAL	0x3F
+	dont_generate_debug_code
 }
 
 /*
  * Write Bias Calculator
@@ -3097,8 +3304,9 @@
 register WRTBIASCALC {
 	address			0x0C7
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Pointers
@@ -3108,8 +3316,9 @@
 register DFPTRS {
 	address			0x0C8
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Receiver Bias Calculator
@@ -3117,8 +3326,9 @@
 register RCVRBIASCALC {
 	address			0x0C8
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Backup Read Pointer
@@ -3129,8 +3339,9 @@
 	address			0x0C9
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Skew Calculator
@@ -3138,8 +3349,9 @@
 register SKEWCALC {
 	address			0x0C9
 	access_mode	RO
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Debug Control
@@ -3153,8 +3365,9 @@
 	field	DFF_DIR_ERR		0x08
 	field	DFF_RAMBIST_FAIL	0x04
 	field	DFF_RAMBIST_DONE	0x02
 	field	DFF_RAMBIST_EN		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Space Count
@@ -3164,8 +3377,9 @@
 	address			0x0CC
 	access_mode	RO
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Data FIFO Byte Count
@@ -3175,8 +3389,9 @@
 	address			0x0CE
 	access_mode	RO
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Program Overlay Address.
@@ -3186,8 +3401,9 @@
 	address			0x0D4
 	modes		M_SCSI
 	size		2
 	access_mode	RW
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Control 0
@@ -3217,8 +3433,9 @@
 	field	OVRLAY_DATA_CHK	0x08
 	field	RAMBIST_DONE	0x04
 	field	RAMBIST_FAIL	0x02
 	field	RAMBIST_EN	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Flags
@@ -3228,8 +3445,9 @@
 	address			0x0D8
 	access_mode RO
 	field	ZERO		0x02
 	field	CARRY		0x01
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Interrupt Control
@@ -3255,8 +3473,9 @@
  */
 register SEQRAM {
 	address			0x0DA
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Program Counter
@@ -3265,8 +3484,9 @@
 register PRGMCNT {
 	address			0x0DE
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * Accumulator
@@ -3274,8 +3494,9 @@
 register ACCUM {
 	address			0x0E0
 	access_mode RW
 	accumulator
+	dont_generate_debug_code
 }
 
 /*
  * Source Index Register
@@ -3290,8 +3511,9 @@
 	address			0x0E2
 	access_mode	RW
 	size		2
 	sindex
+	dont_generate_debug_code
 }
 
 /*
  * Destination Index Register
@@ -3300,8 +3522,9 @@
 register DINDEX {
 	address			0x0E4
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
  * Break Address
@@ -3309,14 +3532,16 @@
  */
 register BRKADDR0 {
 	address			0x0E6
 	access_mode	RW
+	dont_generate_debug_code
 }
 
 register BRKADDR1 {
 	address			0x0E6
 	access_mode	RW
 	field	BRKDIS		0x80	/* Disable Breakpoint */
+	dont_generate_debug_code
 }
 
 /*
  * All Ones
@@ -3325,8 +3550,9 @@
 register ALLONES {
 	address			0x0E8
 	access_mode RO
 	allones
+	dont_generate_debug_code
 }
 
 /*
  * All Zeros
@@ -3335,8 +3561,9 @@
 register ALLZEROS {
 	address			0x0EA
 	access_mode RO
 	allzeros
+	dont_generate_debug_code
 }
 
 /*
  * No Destination
@@ -3345,8 +3572,9 @@
 register NONE {
 	address			0x0EA
 	access_mode WO
 	none
+	dont_generate_debug_code
 }
 
 /*
  * Source Index Indirect
@@ -3355,8 +3583,9 @@
  */
 register SINDIR	{
 	address			0x0EC
 	access_mode RO
+	dont_generate_debug_code
 }
 
 /*
  * Destination Index Indirect
@@ -3365,8 +3594,9 @@
  */
 register DINDIR	 {
 	address			0x0ED
 	access_mode WO
+	dont_generate_debug_code
 }
 
 /*
  * Function One
@@ -3379,8 +3609,9 @@
  */
 register FUNCTION1 {
 	address			0x0F0
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Stack
@@ -3389,8 +3620,9 @@
  */
 register STACK {
 	address			0x0F2
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Interrupt Vector 1 Address
@@ -3400,8 +3632,9 @@
 	address			0x0F4
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Current Address
@@ -3411,8 +3644,9 @@
 	address			0x0F4
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
  * Interrupt Vector 2 Address
@@ -3422,8 +3656,9 @@
 	address			0x0F6
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
  * Last Address
@@ -3433,15 +3668,17 @@
 	address			0x0F6
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 register AHD_PCI_CONFIG_BASE {
 	address			0x100
 	access_mode	RW
 	size		256
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /* ---------------------- Scratch RAM Offsets ------------------------- */
 scratch_ram {
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx.reg	Thu Apr 24 07:48:38 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic7xxx.reg	Fri Apr 25 04:24:14 2008
@@ -50,8 +50,14 @@
  * Adaptec's Technical Documents Department 1-800-934-2766
  */
 
 /*
+ * Registers marked "dont_generate_debug_code" are not (yet) referenced
+ * from the driver code, and this keyword inhibit generation
+ * of debug code for them.
+ */
+
+/*
  * SCSI Sequence Control (p. 3-11).
  * Each bit, when set starts a specific SCSI sequence on the bus
  */
 register SCSISEQ {
@@ -96,8 +102,9 @@
 	mask	STIMESEL	0x18
 	field	ENSTIMER	0x04
 	field	ACTNEGEN	0x02
 	field	STPWEN		0x01	/* Powered Termination */
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Control Signal Read Register (p. 3-15).
@@ -154,8 +161,9 @@
 	mask	P_COMMAND	CDI
 	mask	P_MESGOUT	CDI|MSGI
 	mask	P_STATUS	CDI|IOI
 	mask	P_MESGIN	CDI|IOI|MSGI
+	dont_generate_debug_code
 }
 
 /* 
  * SCSI Rate Control (p. 3-17).
@@ -193,8 +201,9 @@
 	 * and narrow mode.
 	 */
 	alias	SCSIOFFSET
 	mask	SOFS_ULTRA2	0x7f		/* Sync offset U2 chips */
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Latched Data (p. 3-19).
@@ -204,13 +213,15 @@
  */
 register SCSIDATL {
 	address			0x006
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register SCSIDATH {
 	address			0x007
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Transfer Count (pp. 3-19,20)
@@ -222,8 +233,9 @@
 register STCNT {
 	address			0x008
 	size	3
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /* ALT_MODE registers (Ultra2 and Ultra160 chips) */
 register SXFRCTL2 {
@@ -231,8 +243,9 @@
 	access_mode RW
 	field	AUTORSTDIS	0x10
 	field	CMDDMAEN	0x08
 	mask	ASYNC_SETUP	0x07
+	dont_generate_debug_code
 }
 
 /* ALT_MODE register on Ultra160 chips */
 register OPTIONMODE {
@@ -246,15 +259,17 @@
 	field	SCSIDATL_IMGEN		0x04
 	field	AUTO_MSGOUT_DE		0x02
 	field	DIS_MSGIN_DUALEDGE	0x01
 	mask	OPTIONMODE_DEFAULTS	AUTO_MSGOUT_DE|DIS_MSGIN_DUALEDGE
+	dont_generate_debug_code
 }
 
 /* ALT_MODE register on Ultra160 chips */
 register TARGCRCCNT {
 	address			0x00a
 	size	2
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Clear SCSI Interrupt 0 (p. 3-20)
@@ -268,8 +283,9 @@
 	field	CLRSELINGO	0x10
 	field	CLRSWRAP	0x08
 	field	CLRIOERR	0x08	/* Ultra2 Only */
 	field	CLRSPIORDY	0x02
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Status 0 (p. 3-21)
@@ -303,8 +319,9 @@
 	field	CLRBUSFREE	0x08
 	field	CLRSCSIPERR	0x04
 	field	CLRPHASECHG	0x02
 	field	CLRREQINIT	0x01
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Status 1 (p. 3-24)
@@ -356,8 +373,9 @@
 	address			0x00f
 	access_mode RW
 	mask	TID		0xf0		/* Target ID mask */
 	mask	OID		0x0f		/* Our ID mask */
+	dont_generate_debug_code
 }
 
 /*
  * SCSI Interrupt Mode 1 (p. 3-28)
@@ -406,8 +424,9 @@
 
 register SCSIBUSH {
 	address			0x013
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * SCSI/Host Address (p. 3-30)
@@ -420,8 +439,9 @@
 register SHADDR {
 	address			0x014
 	size	4
 	access_mode RO
+	dont_generate_debug_code
 }
 
 /*
  * Selection Timeout Timer (p. 3-30)
@@ -435,8 +455,9 @@
 	field	STAGE3		0x04
 	field	STAGE2		0x02
 	field	STAGE1		0x01
 	alias	TARGIDIN
+	dont_generate_debug_code
 }
 
 /*
  * Selection/Reselection ID (p. 3-31)
@@ -447,8 +468,9 @@
 	address			0x019
 	access_mode RW
 	mask	SELID_MASK	0xf0
 	field	ONEBIT		0x08
+	dont_generate_debug_code
 }
 
 register SCAMCTL {
 	address			0x01a
@@ -457,8 +479,9 @@
 	field	CLRSCAMSELID	0x40
 	field	ALTSTIM		0x20
 	field	DFLTTID		0x10
 	mask	SCAMLVL		0x03
+	dont_generate_debug_code
 }
 
 /*
  * Target Mode Selecting in ID bitmask (aic7890/91/96/97)
@@ -466,8 +489,9 @@
 register TARGID {
 	address			0x01b
 	size			2
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Serial Port I/O Cabability register (p. 4-95 aic7860 Data Book)
@@ -487,8 +511,9 @@
 	field	SEEPROM		0x08	/* External serial eeprom logic */
 	field	EEPROM		0x04	/* Writable external BIOS ROM */
 	field	ROM		0x02	/* Logic for accessing external ROM */
 	field	SSPIOCPS	0x01	/* Termination and cable detection */
+	dont_generate_debug_code
 }
 
 register BRDCTL	{
 	address			0x01d
@@ -505,8 +530,9 @@
 	field	BRDDAT3		0x08
 	field	BRDDAT2		0x04
 	field	BRDRW_ULTRA2	0x02
 	field	BRDSTB_ULTRA2	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Serial EEPROM Control (p. 4-92 in 7870 Databook)
@@ -541,8 +567,9 @@
 	field	SEECS		0x08
 	field	SEECK		0x04
 	field	SEEDO		0x02
 	field	SEEDI		0x01
+	dont_generate_debug_code
 }
 /*
  * SCSI Block Control (p. 3-32)
  * Controls Bus type and channel selection.  In a twin channel configuration
@@ -589,8 +616,9 @@
  */
 register SEQRAM {
 	address			0x061
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Sequencer Address Registers (p. 3-35)
@@ -598,14 +626,16 @@
  */
 register SEQADDR0 {
 	address			0x062
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register SEQADDR1 {
 	address			0x063
 	access_mode RW
 	mask	SEQADDR1_MASK	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Accumulator
@@ -614,64 +644,76 @@
 register ACCUM {
 	address			0x064
 	access_mode RW
 	accumulator
+	dont_generate_debug_code
+	dont_generate_debug_code
 }
 
 register SINDEX	{
 	address			0x065
 	access_mode RW
 	sindex
+	dont_generate_debug_code
 }
 
 register DINDEX {
 	address			0x066
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register ALLONES {
 	address			0x069
 	access_mode RO
 	allones
+	dont_generate_debug_code
 }
 
 register ALLZEROS {
 	address			0x06a
 	access_mode RO
 	allzeros
+	dont_generate_debug_code
 }
 
 register NONE {
 	address			0x06a
 	access_mode WO
 	none
+	dont_generate_debug_code
 }
 
 register FLAGS {
 	address			0x06b
 	access_mode RO
 	field	ZERO		0x02
 	field	CARRY		0x01
+	dont_generate_debug_code
 }
 
 register SINDIR	{
 	address			0x06c
 	access_mode RO
+	dont_generate_debug_code
 }
 
 register DINDIR	 {
 	address			0x06d
 	access_mode WO
+	dont_generate_debug_code
 }
 
 register FUNCTION1 {
 	address			0x06e
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register STACK {
 	address			0x06f
 	access_mode RO
+	dont_generate_debug_code
 }
 
 const	STACK_SIZE	4
 
@@ -682,8 +724,9 @@
 	address			0x084
 	access_mode RW
 	field	ACE		0x08
 	field	ENABLE		0x01
+	dont_generate_debug_code
 }
 
 /*
  * On the aic78X0 chips, Board Control is replaced by the DSCommand
@@ -700,16 +743,18 @@
 	field	INTSCBRAMSEL	0x08	/* Internal SCB RAM Select */
 	field	RAMPS		0x04	/* External SCB RAM Present */
 	field	USCBSIZE32	0x02	/* Use 32byte SCB Page Size */
 	field	CIOPARCKEN	0x01	/* Internal bus parity error enable */
+	dont_generate_debug_code
 }
 
 register DSCOMMAND1 {
 	address			0x085
 	access_mode RW
 	mask	DSLATT		0xfc	/* PCI latency timer (non-ultra2) */
 	field	HADDLDSEL1	0x02	/* Host Address Load Select Bits */
 	field	HADDLDSEL0	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Bus On/Off Time (p. 3-44) aic7770 only
@@ -718,8 +763,9 @@
 	address			0x085
 	access_mode RW
 	mask	BOFF		0xf0
 	mask	BON		0x0f
+	dont_generate_debug_code
 }
 
 /*
  * Bus Speed (p. 3-45) aic7770 only
@@ -731,22 +777,25 @@
 	mask	STBOFF		0x38
 	mask	STBON		0x07
 	mask	DFTHRSH_100	0xc0
 	mask	DFTHRSH_75	0x80
+	dont_generate_debug_code
 }
 
 /* aic7850/55/60/70/80/95 only */
 register DSPCISTATUS {
 	address			0x086
 	mask	DFTHRSH_100	0xc0
+	dont_generate_debug_code
 }
 
 /* aic7890/91/96/97 only */
 register HS_MAILBOX {
 	address			0x086
 	mask	HOST_MAILBOX	0xF0
 	mask	SEQ_MAILBOX	0x0F
 	mask	HOST_TQINPOS	0x80	/* Boundary at either 0 or 128 */
+	dont_generate_debug_code
 }
 
 const	HOST_MAILBOX_SHIFT	4
 const	SEQ_MAILBOX_SHIFT	0
@@ -764,8 +813,9 @@
 	field	PAUSE		0x04
 	field	INTEN		0x02
 	field	CHIPRST		0x01
 	field	CHIPRSTACK	0x01
+	dont_generate_debug_code
 }
 
 /*
  * Host Address (p. 3-48)
@@ -775,14 +825,16 @@
 register HADDR {
 	address			0x088
 	size	4
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register HCNT {
 	address			0x08c
 	size	3
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * SCB Pointer (p. 3-49)
@@ -790,8 +842,9 @@
  */
 register SCBPTR {
 	address			0x090
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Interrupt Status (p. 3-50)
@@ -858,8 +911,9 @@
 	mask	OUT_OF_RANGE	0xe0|SEQINT
 
 	mask	SEQINT_MASK	0xf0|SEQINT	/* SEQINT Status Codes */
 	mask	INT_PEND  (BRKADRINT|SEQINT|SCSIINT|CMDCMPLT)
+	dont_generate_debug_code
 }
 
 /*
  * Hard Error (p. 3-53)
@@ -889,8 +943,9 @@
 	field	CLRBRKADRINT	0x08
 	field	CLRSCSIINT      0x04
 	field	CLRCMDINT 	0x02
 	field	CLRSEQINT 	0x01
+	dont_generate_debug_code
 }
 
 register DFCNTRL {
 	address			0x093
@@ -922,18 +977,21 @@
 
 register DFWADDR {
 	address			0x95
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register DFRADDR {
 	address			0x97
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register DFDAT {
 	address			0x099
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * SCB Auto Increment (p. 3-59)
@@ -944,8 +1002,9 @@
 	address			0x09a
 	access_mode RW
 	field	SCBAUTO		0x80
 	mask	SCBCNT_MASK	0x1f
+	dont_generate_debug_code
 }
 
 /*
  * Queue In FIFO (p. 3-60)
@@ -953,8 +1012,9 @@
  */
 register QINFIFO {
 	address			0x09b
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
  * Queue In Count (p. 3-60)
@@ -962,8 +1022,9 @@
  */
 register QINCNT	{
 	address			0x09c
 	access_mode RO
+	dont_generate_debug_code
 }
 
 /*
  * Queue Out FIFO (p. 3-61)
@@ -971,8 +1032,9 @@
  */
 register QOUTFIFO {
 	address			0x09d
 	access_mode WO
+	dont_generate_debug_code
 }
 
 register CRCCONTROL1 {
 	address			0x09d
@@ -982,8 +1044,9 @@
 	field	CRCENDCHKEN		0x20
 	field	CRCREQCHKEN		0x10
 	field	TARGCRCENDEN		0x08
 	field	TARGCRCCNTEN		0x04
+	dont_generate_debug_code
 }
 
 
 /*
@@ -992,8 +1055,9 @@
  */
 register QOUTCNT {
 	address			0x09e
 	access_mode RO
+	dont_generate_debug_code
 }
 
 register SCSIPHASE {
 	address			0x09e
@@ -1013,8 +1077,9 @@
 register SFUNCT {
 	address			0x09f
 	access_mode RW
 	field	ALT_MODE	0x80
+	dont_generate_debug_code
 }
 
 /*
  * SCB Definition (p. 5-4)
@@ -1120,8 +1185,9 @@
 	access_mode RW
 	field	CS_2840		0x04
 	field	CK_2840		0x02
 	field	DO_2840		0x01
+	dont_generate_debug_code
 }
 
 register STATUS_2840 {
 	address			0x0c1
@@ -1129,39 +1195,46 @@
 	field	EEPROM_TF	0x80
 	mask	BIOS_SEL	0x60
 	mask	ADSEL		0x1e
 	field	DI_2840		0x01
+	dont_generate_debug_code
 }
 
 /* --------------------- AIC-7870-only definitions -------------------- */
 
 register CCHADDR {
 	address			0x0E0
 	size 8
+	dont_generate_debug_code
 }
 
 register CCHCNT {
 	address			0x0E8
+	dont_generate_debug_code
 }
 
 register CCSGRAM {
 	address			0x0E9
+	dont_generate_debug_code
 }
 
 register CCSGADDR {
 	address			0x0EA
+	dont_generate_debug_code
 }
 
 register CCSGCTL {
 	address			0x0EB
 	field	CCSGDONE	0x80
 	field	CCSGEN		0x08
 	field	SG_FETCH_NEEDED 0x02	/* Bit used for software state */
 	field	CCSGRESET	0x01
+	dont_generate_debug_code
 }
 
 register CCSCBCNT {
 	address			0xEF
+	dont_generate_debug_code
 }
 
 register CCSCBCTL {
 	address			0x0EE
@@ -1170,40 +1243,48 @@
 	field	CCARREN		0x10
 	field	CCSCBEN		0x08
 	field	CCSCBDIR	0x04
 	field	CCSCBRESET	0x01
+	dont_generate_debug_code
 }
 
 register CCSCBADDR {
 	address			0x0ED
+	dont_generate_debug_code
 }
 
 register CCSCBRAM {
 	address			0xEC
+	dont_generate_debug_code
 }
 
 /*
  * SCB bank address (7895/7896/97 only)
  */
 register SCBBADDR {
 	address			0x0F0
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register CCSCBPTR {
 	address			0x0F1
+	dont_generate_debug_code
 }
 
 register HNSCB_QOFF {
 	address			0x0F4
+	dont_generate_debug_code
 }
 
 register SNSCB_QOFF {
 	address			0x0F6
+	dont_generate_debug_code
 }
 
 register SDSCB_QOFF {
 	address			0x0F8
+	dont_generate_debug_code
 }
 
 register QOFF_CTLSTA {
 	address			0x0FA
@@ -1211,8 +1292,9 @@
 	field	SNSCB_ROLLOVER	0x20
 	field	SDSCB_ROLLOVER	0x10
 	mask	SCB_QSIZE	0x07
 	mask	SCB_QSIZE_256	0x06
+	dont_generate_debug_code
 }
 
 register DFF_THRSH {
 	address			0x0FB
@@ -1233,24 +1315,27 @@
 	mask	WR_DFTHRSH_75	0x40
 	mask	WR_DFTHRSH_85	0x50
 	mask	WR_DFTHRSH_90	0x60
 	mask	WR_DFTHRSH_MAX	0x70
+	dont_generate_debug_code
 }
 
 register SG_CACHE_PRE {
 	access_mode WO
 	address			0x0fc
 	mask	SG_ADDR_MASK	0xf8
 	field	LAST_SEG	0x02
 	field	LAST_SEG_DONE	0x01
+	dont_generate_debug_code
 }
 
 register SG_CACHE_SHADOW {
 	access_mode RO
 	address			0x0fc
 	mask	SG_ADDR_MASK	0xf8
 	field	LAST_SEG	0x02
 	field	LAST_SEG_DONE	0x01
+	dont_generate_debug_code
 }
 /* ---------------------- Scratch RAM Offsets ------------------------- */
 /* These offsets are either to values that are initialized by the board's
  * BIOS or are specified by the sequencer code.
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aicasm/aicasm.c	Fri Apr 25 04:14:19 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aicasm/aicasm.c	Thu Apr 24 08:11:47 2008
@@ -361,9 +361,9 @@
 " *		 from the following source files:\n"
 " *\n"
 "%s */\n", versions);
 
-	fprintf(ofile, "static uint8_t seqprog[] = {\n");
+	fprintf(ofile, "static const uint8_t seqprog[] = {\n");
 	for (cur_instr = STAILQ_FIRST(&seq_program);
 	     cur_instr != NULL;
 	     cur_instr = STAILQ_NEXT(cur_instr, links)) {
 
@@ -414,9 +414,9 @@
 			cur_node->symbol->name);
 	}
 
 	fprintf(ofile,
-"static struct patch {\n"
+"static const struct patch {\n"
 "	%spatch_func_t		*patch_func;\n"
 "	uint32_t		 begin		:10,\n"
 "				 skip_instr	:10,\n"
 "				 skip_patch	:12;\n"
@@ -434,9 +434,9 @@
 
 	fprintf(ofile, "\n};\n\n");
 
 	fprintf(ofile,
-"static struct cs {\n"
+"static const struct cs {\n"
 "	uint16_t	begin;\n"
 "	uint16_t	end;\n"
 "} critical_sections[] = {\n");
 
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	Fri Apr 25 02:49:37 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	Fri Apr 25 01:29:31 2008
@@ -144,8 +144,10 @@
 %token <value> T_ADDRESS
 
 %token T_ACCESS_MODE
 
+%token T_DONT_GENERATE_DEBUG_CODE
+
 %token T_MODES
 
 %token T_DEFINE
 
@@ -353,8 +355,9 @@
 reg_attribute:
 	reg_address
 |	size
 |	access_mode
+|	dont_generate_debug_code
 |	modes
 |	field_defn
 |	enum_defn
 |	mask_defn
@@ -396,8 +399,15 @@
 access_mode:
 	T_ACCESS_MODE T_MODE
 	{
 		cur_symbol->info.rinfo->mode = $2;
+	}
+;
+
+dont_generate_debug_code:
+	T_DONT_GENERATE_DEBUG_CODE
+	{
+		cur_symbol->dont_generate_debug_code = 1;
 	}
 ;
 
 modes:
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l	Fri Apr 25 02:49:37 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l	Fri Apr 25 01:34:51 2008
@@ -162,8 +162,9 @@
 const			{ yylval.value = FALSE; return T_CONST; }
 download		{ return T_DOWNLOAD; }
 address			{ return T_ADDRESS; }
 access_mode		{ return T_ACCESS_MODE; }
+dont_generate_debug_code { return T_DONT_GENERATE_DEBUG_CODE; }
 modes			{ return T_MODES; }
 RW|RO|WO		{
 				 if (strcmp(yytext, "RW") == 0)
 					yylval.value = RW;
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c	Fri Apr 25 01:40:02 2008
@@ -369,9 +369,9 @@
 	if (dfile == NULL)
 		return;
 
 	fprintf(dfile,
-"static %sreg_parse_entry_t %s_parse_table[] = {\n",
+"static const %sreg_parse_entry_t %s_parse_table[] = {\n",
 		prefix,
 		regnode->symbol->name);
 }
 
@@ -529,8 +529,11 @@
 	aic_print_reg_dump_types(ofile);
 	aic_print_file_prologue(dfile);
 	aic_print_include(dfile, stock_include_file);
 	SLIST_FOREACH(curnode, &registers, links) {
+
+		if (curnode->symbol->dont_generate_debug_code)
+			continue;
 
 		switch(curnode->symbol->type) {
 		case REGISTER:
 		case SCBLOC:
--- scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h	Fri Apr 25 01:30:02 2008
@@ -135,9 +135,10 @@
 		struct alias_info *ainfo;
 		struct label_info *linfo;
 		struct cond_info  *condinfo;
 		struct macro_info *macroinfo;
-	}info;
+	} info;
+	int	dont_generate_debug_code;
 } symbol_t;
 
 typedef struct symbol_ref {
 	symbol_t *symbol;

--Boundary-00=_nTUEIJEhj2O6zlR--
