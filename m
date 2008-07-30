From: akpm@linux-foundation.org
Subject: [patch 02/12] aic7xxx: update .reg files
Date: Wed, 30 Jul 2008 12:44:22 -0700
Message-ID: <200807301944.m6UJiMQq012882@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYG3TpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 15:45:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, vda.linux@googlemail.com, James.Bottomley@HansenPartnership.com, hare@suse.de

From: Denys Vlasenko <vda.linux@googlemail.com>

Update .reg files, marking unused registers with dont_generate_debug_code.
Comment explains how to use it.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx.reg |  185 +++++++++++++++++++++++++++++
 drivers/scsi/aic7xxx/aic7xxx.reg |  124 +++++++++++++++++++
 2 files changed, 309 insertions(+)

diff -puN drivers/scsi/aic7xxx/aic79xx.reg~aic7xxx-update-reg-files drivers/scsi/aic7xxx/aic79xx.reg
--- a/drivers/scsi/aic7xxx/aic79xx.reg~aic7xxx-update-reg-files
+++ a/drivers/scsi/aic7xxx/aic79xx.reg
@@ -80,6 +80,17 @@ VERSION = "$Id: //depot/aic7xxx/aic7xxx/
 	}
 
 /*
+ * Registers marked "dont_generate_debug_code" are not (yet) referenced
+ * from the driver code, and this keyword inhibit generation
+ * of debug code for them.
+ *
+ * REG_PRETTY_PRINT config will complain if dont_generate_debug_code
+ * is added to the register which is referenced in the driver.
+ * Unreferenced register with no dont_generate_debug_code will result
+ * in dead code. No warning is issued.
+ */
+
+/*
  * Mode Pointer
  * Controls which of the 5, 512byte, address spaces should be used
  * as the source and destination of any register accesses in our
@@ -91,6 +102,7 @@ register MODE_PTR {
 	field	DST_MODE	0x70
 	field	SRC_MODE	0x07
 	mode_pointer
+	dont_generate_debug_code
 }
 
 const SRC_MODE_SHIFT	0
@@ -190,6 +202,7 @@ register SEQINTCODE {
 		SAW_HWERR,
 		BAD_SCB_STATUS
 	}
+	dont_generate_debug_code
 }
 
 /*
@@ -207,6 +220,7 @@ register CLRINT {
 	field	CLRSEQINT	0x04
 	field	CLRCMDINT	0x02
 	field	CLRSPLTINT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -222,6 +236,7 @@ register ERROR {
 	field	SQPARERR	0x08
 	field	ILLOPCODE	0x04
 	field	DSCTMOUT	0x02
+	dont_generate_debug_code
 }
 
 /*
@@ -255,6 +270,7 @@ register HCNTRL {
 	field	INTEN		0x02
 	field	CHIPRST		0x01
 	field	CHIPRSTACK	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -265,6 +281,7 @@ register HNSCB_QOFF {
 	access_mode	RW
 	size		2
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -274,6 +291,7 @@ register HESCB_QOFF {
 	address			0x008
 	access_mode	RW
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -311,6 +329,7 @@ register CLRSEQINTSTAT {
 	field	CLRSEQ_SCSIINT	0x04
 	field	CLRSEQ_PCIINT	0x02
 	field	CLRSEQ_SPLTINT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -320,6 +339,7 @@ register SWTIMER {
 	address			0x00E
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
@@ -330,6 +350,7 @@ register SNSCB_QOFF {
 	access_mode	RW
 	size		2
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -340,6 +361,7 @@ register SESCB_QOFF {
 	count		2
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -350,6 +372,7 @@ register SDSCB_QOFF {
 	access_mode	RW
 	modes		M_CCHAN
 	size		2
+	dont_generate_debug_code
 }
 
 /*
@@ -378,6 +401,7 @@ register QOFF_CTLSTA {
 		SCB_QSIZE_8192,
 		SCB_QSIZE_16384
 	}
+	dont_generate_debug_code
 }
 
 /*
@@ -431,6 +455,7 @@ register DSCOMMAND0 {
 	field	EXTREQLCK	0x10	/* External Request Lock */
 	field	DISABLE_TWATE	0x02	/* Rev B or greater */
 	field	CIOPARCKEN	0x01	/* Internal bus parity error enable */
+	dont_generate_debug_code
 }
 
 /*
@@ -459,6 +484,7 @@ register SG_CACHE_PRE {
 	field	SG_ADDR_MASK	0xf8
 	field	ODD_SEG		0x04
 	field	LAST_SEG	0x02
+	dont_generate_debug_code
 }
 
 register SG_CACHE_SHADOW {
@@ -491,6 +517,7 @@ register HADDR {
 	access_mode	RW
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -522,6 +549,7 @@ register HCNT {
 	access_mode	RW
 	size		3
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -551,6 +579,7 @@ register SGHADDR {
 	access_mode	RW
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -561,6 +590,7 @@ register SCBHADDR {
 	access_mode	RW
 	size		8
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -570,6 +600,7 @@ register SGHCNT {
 	address			0x084
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -579,6 +610,7 @@ register SCBHCNT {
 	address			0x084
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -609,6 +641,7 @@ register DFF_THRSH {
 		RD_DFTHRSH_90,
 		RD_DFTHRSH_MAX
 	}
+	dont_generate_debug_code
 }
 
 /*
@@ -817,6 +850,7 @@ register PCIXCTL {
 	field	SRSPDPEEN	0x04
 	field	TSCSERREN	0x02
 	field	CMPABCDIS	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -863,6 +897,7 @@ register DCHSPLTSTAT0 {
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -908,6 +943,7 @@ register DCHSPLTSTAT1 {
 	modes		M_DFF0, M_DFF1
 	count		2
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1069,6 +1105,7 @@ register SGSPLTSTAT0 {
 	field	RXOVRUN		0x04
 	field	RXSCEMSG	0x02
 	field	RXSPLTRSP	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1080,6 +1117,7 @@ register SGSPLTSTAT1 {
 	modes		M_DFF0, M_DFF1
 	count		2
 	field	RXDATABUCKET	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1091,6 +1129,7 @@ register SFUNCT {
 	modes		M_CFG
 	field	TEST_GROUP	0xF0
 	field	TEST_NUM	0x0F
+	dont_generate_debug_code
 }
 
 /*
@@ -1109,6 +1148,7 @@ register DF0PCISTAT {
 	field	RDPERR		0x04
 	field	TWATERR		0x02
 	field	DPR		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1204,6 +1244,7 @@ register TARGPCISTAT {
 	field	SSE		0x40
 	field	STA		0x08
 	field	TWATERR		0x02
+	dont_generate_debug_code
 }
 
 /*
@@ -1216,6 +1257,7 @@ register LQIN {
 	size		20
 	count		2
 	modes		M_DFF0, M_DFF1, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -1247,6 +1289,7 @@ register LUNPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -1278,6 +1321,7 @@ register CMDLENPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1290,6 +1334,7 @@ register ATTRPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1302,6 +1347,7 @@ register FLAGPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1313,6 +1359,7 @@ register CMDPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1324,6 +1371,7 @@ register QNEXTPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1347,6 +1395,7 @@ register ABRTBYTEPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1358,6 +1407,7 @@ register ABRTBITPTR {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1398,6 +1448,7 @@ register LUNLEN {
 	count		2
 	mask		ILUNLEN	0x0F
 	mask		TLUNLEN	0xF0
+	dont_generate_debug_code
 }
 const LUNLEN_SINGLE_LEVEL_LUN 0xF
 
@@ -1410,6 +1461,7 @@ register CDBLIMIT {
 	access_mode	RW
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -1422,6 +1474,7 @@ register MAXCMD {
 	access_mode	RW
 	modes		M_CFG
 	count		9
+	dont_generate_debug_code
 }
 
 /*
@@ -1432,6 +1485,7 @@ register MAXCMDCNT {
 	address			0x033
 	access_mode	RW
 	modes		M_CFG
+	dont_generate_debug_code
 }
 
 /*
@@ -1490,6 +1544,7 @@ register LQCTL1 {
 	field	PCI2PCI		0x04
 	field	SINGLECMD	0x02
 	field	ABORTPENDING	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1508,6 +1563,7 @@ register LQCTL2 {
 	field	LQOCONTINUE	0x04
 	field	LQOTOIDLE	0x02
 	field	LQOPAUSE	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1578,6 +1634,7 @@ register SXFRCTL0 {
 	field	DFPEXP		0x40
 	field	BIOSCANCELEN	0x10
 	field	SPIOEN		0x08
+	dont_generate_debug_code
 }
 
 /*
@@ -1594,6 +1651,7 @@ register SXFRCTL1 {
 	field	ENSTIMER	0x04
 	field	ACTNEGEN	0x02
 	field	STPWEN		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1696,6 +1754,7 @@ register SCSISIGO {
 		P_STATUS	CDO|IOO,
 		P_MESGIN	CDO|IOO|MSGO
 	}
+	dont_generate_debug_code
 }
 
 /*
@@ -1738,6 +1797,7 @@ register MULTARGID {
 	modes		M_CFG
 	size		2
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -1774,6 +1834,7 @@ register SCSIDAT {
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
 	size		2
+	dont_generate_debug_code
 }
 
 /*
@@ -1796,6 +1857,7 @@ register TARGIDIN {
 	count		2
 	field	CLKOUT		0x80
 	field	TARGID		0x0F
+	dont_generate_debug_code
 }
 
 /*
@@ -1825,6 +1887,7 @@ register SBLKCTL {
 	field	ENAB40		0x08	/* LVD transceiver active */
 	field	ENAB20		0x04	/* SE/HVD transceiver active */
 	field	SELWIDE		0x02
+	dont_generate_debug_code
 }
 
 /*
@@ -1842,6 +1905,7 @@ register OPTIONMODE {
 	field	ENDGFORMCHK		0x04
 	field	AUTO_MSGOUT_DE		0x02
 	mask	OPTIONMODE_DEFAULTS	AUTO_MSGOUT_DE
+	dont_generate_debug_code
 }
 
 /*
@@ -1876,6 +1940,7 @@ register CLRSINT0 {
 	field	CLROVERRUN	0x04
 	field	CLRSPIORDY	0x02
 	field	CLRARBDO	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1929,6 +1994,7 @@ register CLRSINT1 {
 	field	CLRSCSIPERR	0x04
 	field	CLRSTRB2FAST	0x02
 	field	CLRREQINIT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -1962,6 +2028,7 @@ register CLRSINT2 {
 	field	CLRWIDE_RES	0x04	/* Modes 0 and 1 only */
 	field	CLRSDONE	0x02	/* Modes 0 and 1 only */
 	field	CLRDMADONE	0x01	/* Modes 0 and 1 only */
+	dont_generate_debug_code
 }
 
 /*
@@ -2002,6 +2069,7 @@ register LQISTATE {
 	access_mode	RO
 	modes		M_CFG
 	count		6
+	dont_generate_debug_code
 }
 
 /*
@@ -2022,6 +2090,7 @@ register LQOSTATE {
 	access_mode	RO
 	modes		M_CFG
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -2054,6 +2123,7 @@ register CLRLQIINT0 {
 	field	CLRLQIBADLQT	0x04
 	field	CLRLQIATNLQ	0x02
 	field	CLRLQIATNCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2070,6 +2140,7 @@ register LQIMODE0 {
 	field	ENLQIBADLQT	0x04
 	field	ENLQIATNLQ	0x02
 	field	ENLQIATNCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2106,6 +2177,7 @@ register CLRLQIINT1 {
 	field	CLRLQIBADLQI	0x04
 	field	CLRLQIOVERI_LQ	0x02
 	field	CLRLQIOVERI_NLQ	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2124,6 +2196,7 @@ register LQIMODE1 {
 	field	ENLQIBADLQI	0x04
 	field	ENLQIOVERI_LQ	0x02	/* LQIOVERI1 */
 	field	ENLQIOVERI_NLQ	0x01	/* LQIOVERI2 */
+	dont_generate_debug_code
 }
 
 /*
@@ -2165,6 +2238,7 @@ register CLRSINT3 {
 	count		3
 	field	CLRNTRAMPERR	0x02
 	field	CLROSRAMPERR	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2177,6 +2251,7 @@ register SIMODE3 {
 	count		4
 	field	ENNTRAMPERR	0x02
 	field	ENOSRAMPERR	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2207,6 +2282,7 @@ register CLRLQOINT0 {
 	field	CLRLQOATNLQ		0x04
 	field	CLRLQOATNPKT		0x02
 	field	CLRLQOTCRC		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2222,6 +2298,7 @@ register LQOMODE0 {
 	field	ENLQOATNLQ		0x04
 	field	ENLQOATNPKT		0x02
 	field	ENLQOTCRC		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2251,6 +2328,7 @@ register CLRLQOINT1 {
 	field	CLRLQOBADQAS		0x04
 	field	CLRLQOBUSFREE		0x02
 	field	CLRLQOPHACHGINPKT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2266,6 +2344,7 @@ register LQOMODE1 {
 	field	ENLQOBADQAS		0x04
 	field	ENLQOBUSFREE		0x02
 	field	ENLQOPHACHGINPKT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2289,6 +2368,7 @@ register OS_SPACE_CNT {
 	access_mode	RO
 	modes		M_CFG
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -2318,6 +2398,7 @@ register GSFIFO {
 	access_mode	RO
 	size		2
 	modes		M_DFF0, M_DFF1, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2341,6 +2422,7 @@ register NEXTSCB {
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2357,6 +2439,7 @@ register LQOSCSCTL {
 	field		LQOBUSETDLY	0x40
 	field		LQONOHOLDLACK	0x02
 	field		LQONOCHKOVER	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2389,6 +2472,7 @@ register CLRSEQINTSRC {
 	field	CLRCFG4TSTAT	0x04
 	field	CLRCFG4ICMD	0x02
 	field	CLRCFG4TCMD	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2415,6 +2499,7 @@ register CURRSCB {
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2472,6 +2557,7 @@ register LASTSCB {
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2494,6 +2580,7 @@ register SHADDR {
 	access_mode	RO
 	size		8
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -2513,6 +2600,7 @@ register NEGOADDR {
 	address			0x060
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2523,6 +2611,7 @@ register NEGPERIOD {
 	access_mode	RW
 	modes		M_SCSI
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -2543,6 +2632,7 @@ register NEGOFFSET {
 	access_mode	RW
 	modes		M_SCSI
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -2557,6 +2647,7 @@ register NEGPPROPTS {
 	field	PPROPT_QAS	0x04
 	field	PPROPT_DT	0x02
 	field	PPROPT_IUT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2573,6 +2664,7 @@ register NEGCONOPTS {
 	field	ENAUTOATNI	0x04
 	field	ENAUTOATNO	0x02
 	field	WIDEXFER	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2583,6 +2675,7 @@ register ANNEXCOL {
 	access_mode	RW
 	modes		M_SCSI
 	count		7
+	dont_generate_debug_code
 }
 
 /*
@@ -2602,6 +2695,7 @@ register SCSCHKN {
 	field	DFFACTCLR	0x04
 	field	SHVALIDSTDIS	0x02
 	field	LSTSGCLRDIS	0x01
+	dont_generate_debug_code
 }
 
 const AHD_ANNEXCOL_PER_DEV0	4
@@ -2635,6 +2729,7 @@ register ANNEXDAT {
 	access_mode	RW
 	modes		M_SCSI
 	count		3
+	dont_generate_debug_code
 }
 
 /*
@@ -2645,6 +2740,7 @@ register IOWNID {
 	address			0x067
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2671,6 +2767,7 @@ register TOWNID {
 	access_mode	RW
 	modes		M_SCSI
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -2702,6 +2799,7 @@ register SHCNT {
 	access_mode	RW
 	size		3
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -2789,6 +2887,7 @@ register SCBPTR {
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1, M_CCHAN, M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -2816,6 +2915,7 @@ register SCBAUTOPTR {
 	field	AUSCBPTR_EN	0x80
 	field	SCBPTR_ADDR	0x38
 	field	SCBPTR_OFF	0x07
+	dont_generate_debug_code
 }
 
 /*
@@ -2825,6 +2925,7 @@ register CCSGADDR {
 	address			0x0AC
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -2834,6 +2935,7 @@ register CCSCBADDR {
 	address			0x0AC
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -2899,6 +3001,7 @@ register CCSGRAM {
 	address			0x0B0
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -2908,6 +3011,7 @@ register CCSCBRAM {
 	address			0x0B0
 	access_mode	RW
 	modes		M_CCHAN
+	dont_generate_debug_code
 }
 
 /*
@@ -2958,6 +3062,7 @@ register BRDDAT {
 	access_mode	RW
 	modes		M_SCSI
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -2974,6 +3079,7 @@ register BRDCTL {
 	field	BRDEN		0x04
 	field	BRDRW		0x02
 	field	BRDSTB		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -2984,6 +3090,7 @@ register SEEADR {
 	access_mode	RW
 	modes		M_SCSI
 	count		4
+	dont_generate_debug_code
 }
 
 /*
@@ -2995,6 +3102,7 @@ register SEEDAT {
 	size		2
 	modes		M_SCSI
 	count		4
+	dont_generate_debug_code
 }
 
 /*
@@ -3011,6 +3119,7 @@ register SEESTAT {
 	field	SEEARBACK	0x04
 	field	SEEBUSY		0x02
 	field	SEESTART	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -3036,6 +3145,7 @@ register SEECTL {
 	mask	SEEOP_EWDS	0x40
 	field	SEERST		0x02
 	field	SEESTART	0x01
+	dont_generate_debug_code
 }
 
 const SEEOP_ERAL_ADDR	0x80
@@ -3050,6 +3160,7 @@ register SCBCNT {
 	address			0x0BF
 	access_mode	RW
 	modes		M_SCSI
+	dont_generate_debug_code
 }
 
 /*
@@ -3061,6 +3172,7 @@ register DFWADDR {
 	access_mode	RW
 	size		2
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -3087,6 +3199,7 @@ register DSPDATACTL {
 	field	DESQDIS		0x10
 	field	RCVROFFSTDIS	0x04
 	field	XMITOFFSTDIS	0x02
+	dont_generate_debug_code
 }
 
 /*
@@ -3132,6 +3245,7 @@ register DFDAT {
 	address			0x0C4
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	dont_generate_debug_code
 }
 
 /*
@@ -3144,6 +3258,7 @@ register DSPSELECT {
 	count		1
 	field	AUTOINCEN	0x80
 	field	DSPSEL		0x1F
+	dont_generate_debug_code
 }
 
 const NUMDSPS 0x14
@@ -3158,6 +3273,7 @@ register WRTBIASCTL {
 	count		3
 	field	AUTOXBCDIS	0x80
 	field	XMITMANVAL	0x3F
+	dont_generate_debug_code
 }
 
 /*
@@ -3316,6 +3432,7 @@ register FLAGS {
 	count		23
 	field	ZERO		0x02
 	field	CARRY		0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -3344,6 +3461,7 @@ register SEQRAM {
 	address			0x0DA
 	access_mode 	RW
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -3355,6 +3473,7 @@ register PRGMCNT {
 	access_mode	RW
 	size		2
 	count		5
+	dont_generate_debug_code
 }
 
 /*
@@ -3364,6 +3483,7 @@ register ACCUM {
 	address			0x0E0
 	access_mode 	RW
 	accumulator
+	dont_generate_debug_code
 }
 
 /*
@@ -3380,6 +3500,7 @@ register SINDEX	{
 	access_mode	RW
 	size		2
 	sindex
+	dont_generate_debug_code
 }
 
 /*
@@ -3390,6 +3511,7 @@ register DINDEX {
 	address			0x0E4
 	access_mode	RW
 	size		2
+	dont_generate_debug_code
 }
 
 /*
@@ -3415,6 +3537,7 @@ register ALLONES {
 	address			0x0E8
 	access_mode RO
 	allones
+	dont_generate_debug_code
 }
 
 /*
@@ -3425,6 +3548,7 @@ register ALLZEROS {
 	address			0x0EA
 	access_mode RO
 	allzeros
+	dont_generate_debug_code
 }
 
 /*
@@ -3435,6 +3559,7 @@ register NONE {
 	address			0x0EA
 	access_mode WO
 	none
+	dont_generate_debug_code
 }
 
 /*
@@ -3445,6 +3570,7 @@ register NONE {
 register SINDIR	{
 	address			0x0EC
 	access_mode RO
+	dont_generate_debug_code
 }
 
 /*
@@ -3455,6 +3581,7 @@ register SINDIR	{
 register DINDIR	 {
 	address			0x0ED
 	access_mode WO
+	dont_generate_debug_code
 }
 
 /*
@@ -3479,6 +3606,7 @@ register FUNCTION1 {
 register STACK {
 	address			0x0F2
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
@@ -3491,6 +3619,7 @@ register INTVEC1_ADDR {
 	size		2
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -3503,6 +3632,7 @@ register CURADDR {
 	size		2
 	modes		M_SCSI
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -3515,6 +3645,7 @@ register INTVEC2_ADDR {
 	size		2
 	modes		M_CFG
 	count		1
+	dont_generate_debug_code
 }
 
 /*
@@ -3543,12 +3674,14 @@ scratch_ram {
 	modes	0, 1, 2, 3
 	REG0 {
 		size		2
+		dont_generate_debug_code
 	}
 	REG1 {
 		size		2
 	}
 	REG_ISR {
 		size		2
+		dont_generate_debug_code
 	}
 	SG_STATE {
 		size		1
@@ -3572,9 +3705,11 @@ scratch_ram {
 	modes	0, 1, 2, 3
 	LONGJMP_ADDR {
 		size		2
+		dont_generate_debug_code
 	}
 	ACCUM_SAVE {
 		size		1
+		dont_generate_debug_code
 	}
 }
 
@@ -3591,18 +3726,22 @@ scratch_ram {
 	 */
 	WAITING_SCB_TAILS {
 		size		32
+		dont_generate_debug_code
 	}
 	WAITING_TID_HEAD {
 		size		2
+		dont_generate_debug_code
 	}
 	WAITING_TID_TAIL {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * SCBID of the next SCB in the new SCB queue.
 	 */
 	NEXT_QUEUED_SCB_ADDR {
 		size		4
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that have
@@ -3611,6 +3750,7 @@ scratch_ram {
 	 */
 	COMPLETE_SCB_HEAD {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * The list of completed SCBs in
@@ -3618,6 +3758,7 @@ scratch_ram {
 	 */
 	COMPLETE_SCB_DMAINPROG_HEAD {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that have
@@ -3626,6 +3767,7 @@ scratch_ram {
 	 */
 	COMPLETE_DMA_SCB_HEAD {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * tail of list of SCBs that have
@@ -3634,6 +3776,7 @@ scratch_ram {
 	 */
 	COMPLETE_DMA_SCB_TAIL {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that have
@@ -3643,6 +3786,7 @@ scratch_ram {
 	 */
 	COMPLETE_ON_QFREEZE_HEAD {
 		size		2
+		dont_generate_debug_code
 	}
 	/*
 	 * Counting semaphore to prevent new select-outs
@@ -3667,6 +3811,7 @@ scratch_ram {
 	 */
 	MSG_OUT {
 		size		1
+		dont_generate_debug_code
 	}
 	/* Parameters for DMA Logic */
 	DMAPARAMS {
@@ -3682,6 +3827,7 @@ scratch_ram {
 		field	DIRECTION	0x04	/* Set indicates PCI->SCSI */
 		field	FIFOFLUSH	0x02
 		field	FIFORESET	0x01
+		dont_generate_debug_code
 	}
 	SEQ_FLAGS {
 		size		1
@@ -3703,9 +3849,11 @@ scratch_ram {
 	 */
 	SAVED_SCSIID {
 		size		1
+		dont_generate_debug_code
 	}
 	SAVED_LUN {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * The last bus phase as seen by the sequencer. 
@@ -3733,6 +3881,7 @@ scratch_ram {
 	 */
 	QOUTFIFO_ENTRY_VALID_TAG {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * Kernel and sequencer offsets into the queue of
@@ -3742,10 +3891,12 @@ scratch_ram {
 	KERNEL_TQINPOS {
 		size		1
 		count		1
+		dont_generate_debug_code
 	}
 	TQINPOS {
 		size		1
 		count		8
+		dont_generate_debug_code
 	}
 	/*
 	 * Base address of our shared data with the kernel driver in host
@@ -3754,6 +3905,7 @@ scratch_ram {
 	 */
 	SHARED_DATA_ADDR {
 		size		4
+		dont_generate_debug_code
 	}
 	/*
 	 * Pointer to location in host memory for next
@@ -3761,6 +3913,7 @@ scratch_ram {
 	 */
 	QOUTFIFO_NEXT_ADDR {
 		size		4
+		dont_generate_debug_code
 	}
 	ARG_1 {
 		size		1
@@ -3773,11 +3926,13 @@ scratch_ram {
 		mask	CONT_MSG_LOOP_READ	0x03
 		mask	CONT_MSG_LOOP_TARG	0x02
 		alias	RETURN_1
+		dont_generate_debug_code
 	}
 	ARG_2 {
 		size		1
 		count		1
 		alias	RETURN_2
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3785,6 +3940,7 @@ scratch_ram {
 	 */
 	LAST_MSG {
 		size		1
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3801,6 +3957,7 @@ scratch_ram {
 		field	MANUALP		0x0C
 		field	ENAUTOATNP	0x02
 		field	ALTSTIM		0x01
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3809,6 +3966,7 @@ scratch_ram {
 	INITIATOR_TAG {
 		size		1
 		count		1
+		dont_generate_debug_code
 	}
 
 	SEQ_FLAGS2 {
@@ -3820,6 +3978,7 @@ scratch_ram {
 
 	ALLOCFIFO_SCBPTR {
 		size		2
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3829,6 +3988,7 @@ scratch_ram {
 	 */
 	INT_COALESCING_TIMER {
 		size		2
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3838,6 +3998,7 @@ scratch_ram {
 	 */
 	INT_COALESCING_MAXCMDS {
 		size		1
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3846,6 +4007,7 @@ scratch_ram {
 	 */
 	INT_COALESCING_MINCMDS {
 		size		1
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3853,6 +4015,7 @@ scratch_ram {
 	 */
 	CMDS_PENDING {
 		size		2
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3860,6 +4023,7 @@ scratch_ram {
 	 */
 	INT_COALESCING_CMDCOUNT {
 		size		1
+		dont_generate_debug_code
 	}
 
 	/*
@@ -3868,6 +4032,7 @@ scratch_ram {
 	 */
 	LOCAL_HS_MAILBOX {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * Target-mode CDB type to CDB length table used
@@ -3876,6 +4041,7 @@ scratch_ram {
 	CMDSIZE_TABLE {
 		size		8
 		count		8
+		dont_generate_debug_code
 	}
 	/*
 	 * When an SCB with the MK_MESSAGE flag is
@@ -3908,25 +4074,31 @@ scb {
 		size	4
 		alias	SCB_CDB_STORE
 		alias	SCB_HOST_CDB_PTR
+		dont_generate_debug_code
 	}
 	SCB_RESIDUAL_SGPTR {
 		size	4
 		field	SG_ADDR_MASK		0xf8	/* In the last byte */
 		field	SG_OVERRUN_RESID	0x02	/* In the first byte */
 		field	SG_LIST_NULL		0x01	/* In the first byte */
+		dont_generate_debug_code
 	}
 	SCB_SCSI_STATUS {
 		size	1
 		alias	SCB_HOST_CDB_LEN
+		dont_generate_debug_code
 	}
 	SCB_TARGET_PHASES {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_TARGET_DATA_DIR {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_TARGET_ITAG {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_SENSE_BUSADDR {
 		/*
@@ -3936,10 +4108,12 @@ scb {
 		 */
 		size	4
 		alias	SCB_NEXT_COMPLETE
+		dont_generate_debug_code
 	}
 	SCB_TAG {
 		alias	SCB_FIFO_USE_COUNT
 		size	2
+		dont_generate_debug_code
 	}
 	SCB_CONTROL {
 		size	1
@@ -3959,6 +4133,7 @@ scb {
 	SCB_LUN {
 		size	1
 		field	LID	0xff
+		dont_generate_debug_code
 	}
 	SCB_TASK_ATTRIBUTE {
 		size	1
@@ -3967,16 +4142,20 @@ scb {
 		 * ignore wide residue message handling.
 		 */
 		field	SCB_XFERLEN_ODD	0x01
+		dont_generate_debug_code
 	}
 	SCB_CDB_LEN {
 		size	1
 		field	SCB_CDB_LEN_PTR	0x80	/* CDB in host memory */
+		dont_generate_debug_code
 	}
 	SCB_TASK_MANAGEMENT {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_DATAPTR {
 		size	8
+		dont_generate_debug_code
 	}
 	SCB_DATACNT {
 		/*
@@ -3986,22 +4165,27 @@ scb {
 		size	4
 		field	SG_LAST_SEG		0x80	/* In the fourth byte */
 		field	SG_HIGH_ADDR_BITS	0x7F	/* In the fourth byte */
+		dont_generate_debug_code
 	}
 	SCB_SGPTR {
 		size	4
 		field	SG_STATUS_VALID	0x04	/* In the first byte */
 		field	SG_FULL_RESID	0x02	/* In the first byte */
 		field	SG_LIST_NULL	0x01	/* In the first byte */
+		dont_generate_debug_code
 	}
 	SCB_BUSADDR {
 		size	4
+		dont_generate_debug_code
 	}
 	SCB_NEXT {
 		alias	SCB_NEXT_SCB_BUSADDR
 		size	2
+		dont_generate_debug_code
 	}
 	SCB_NEXT2 {
 		size	2
+		dont_generate_debug_code
 	}
 	SCB_SPARE {
 		size	8
@@ -4009,6 +4193,7 @@ scb {
 	}
 	SCB_DISCONNECTED_LISTS {
 		size	8
+		dont_generate_debug_code
 	}
 }
 
diff -puN drivers/scsi/aic7xxx/aic7xxx.reg~aic7xxx-update-reg-files drivers/scsi/aic7xxx/aic7xxx.reg
--- a/drivers/scsi/aic7xxx/aic7xxx.reg~aic7xxx-update-reg-files
+++ a/drivers/scsi/aic7xxx/aic7xxx.reg
@@ -51,6 +51,17 @@ VERSION = "$Id: //depot/aic7xxx/aic7xxx/
  */
 
 /*
+ * Registers marked "dont_generate_debug_code" are not (yet) referenced
+ * from the driver code, and this keyword inhibit generation
+ * of debug code for them.
+ *
+ * REG_PRETTY_PRINT config will complain if dont_generate_debug_code
+ * is added to the register which is referenced in the driver.
+ * Unreferenced register with no dont_generate_debug_code will result
+ * in dead code. No warning is issued.
+ */
+
+/*
  * SCSI Sequence Control (p. 3-11).
  * Each bit, when set starts a specific SCSI sequence on the bus
  */
@@ -97,6 +108,7 @@ register SXFRCTL1 {
 	field	ENSTIMER	0x04
 	field	ACTNEGEN	0x02
 	field	STPWEN		0x01	/* Powered Termination */
+	dont_generate_debug_code
 }
 
 /*
@@ -155,6 +167,7 @@ register SCSISIGO {
 	mask	P_MESGOUT	CDI|MSGI
 	mask	P_STATUS	CDI|IOI
 	mask	P_MESGIN	CDI|IOI|MSGI
+	dont_generate_debug_code
 }
 
 /* 
@@ -194,6 +207,7 @@ register SCSIID	{
 	 */
 	alias	SCSIOFFSET
 	mask	SOFS_ULTRA2	0x7f		/* Sync offset U2 chips */
+	dont_generate_debug_code
 }
 
 /*
@@ -205,6 +219,7 @@ register SCSIID	{
 register SCSIDATL {
 	address			0x006
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register SCSIDATH {
@@ -223,6 +238,7 @@ register STCNT {
 	address			0x008
 	size	3
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /* ALT_MODE registers (Ultra2 and Ultra160 chips) */
@@ -248,6 +264,7 @@ register OPTIONMODE {
 	field	AUTO_MSGOUT_DE		0x02
 	field	DIS_MSGIN_DUALEDGE	0x01
 	mask	OPTIONMODE_DEFAULTS	AUTO_MSGOUT_DE|DIS_MSGIN_DUALEDGE
+	dont_generate_debug_code
 }
 
 /* ALT_MODE register on Ultra160 chips */
@@ -256,6 +273,7 @@ register TARGCRCCNT {
 	size	2
 	access_mode RW
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -271,6 +289,7 @@ register CLRSINT0 {
 	field	CLRSWRAP	0x08
 	field	CLRIOERR	0x08	/* Ultra2 Only */
 	field	CLRSPIORDY	0x02
+	dont_generate_debug_code
 }
 
 /*
@@ -306,6 +325,7 @@ register CLRSINT1 {
 	field	CLRSCSIPERR	0x04
 	field	CLRPHASECHG	0x02
 	field	CLRREQINIT	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -360,6 +380,7 @@ register SCSIID_ULTRA2 {
 	access_mode RW
 	mask	TID		0xf0		/* Target ID mask */
 	mask	OID		0x0f		/* Our ID mask */
+	dont_generate_debug_code
 }
 
 /*
@@ -425,6 +446,7 @@ register SHADDR {
 	address			0x014
 	size	4
 	access_mode RO
+	dont_generate_debug_code
 }
 
 /*
@@ -441,6 +463,7 @@ register SELTIMER {
 	field	STAGE2		0x02
 	field	STAGE1		0x01
 	alias	TARGIDIN
+	dont_generate_debug_code
 }
 
 /*
@@ -453,6 +476,7 @@ register SELID {
 	access_mode RW
 	mask	SELID_MASK	0xf0
 	field	ONEBIT		0x08
+	dont_generate_debug_code
 }
 
 register SCAMCTL {
@@ -473,6 +497,7 @@ register TARGID {
 	size			2
 	access_mode RW
 	count		14
+	dont_generate_debug_code
 }
 
 /*
@@ -495,6 +520,7 @@ register SPIOCAP {
 	field	EEPROM		0x04	/* Writable external BIOS ROM */
 	field	ROM		0x02	/* Logic for accessing external ROM */
 	field	SSPIOCPS	0x01	/* Termination and cable detection */
+	dont_generate_debug_code
 }
 
 register BRDCTL	{
@@ -514,6 +540,7 @@ register BRDCTL	{
 	field	BRDDAT2		0x04
 	field	BRDRW_ULTRA2	0x02
 	field	BRDSTB_ULTRA2	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -551,6 +578,7 @@ register SEECTL {
 	field	SEECK		0x04
 	field	SEEDO		0x02
 	field	SEEDI		0x01
+	dont_generate_debug_code
 }
 /*
  * SCSI Block Control (p. 3-32)
@@ -601,6 +629,7 @@ register SEQRAM {
 	address			0x061
 	access_mode RW
 	count		2
+	dont_generate_debug_code
 }
 
 /*
@@ -610,6 +639,7 @@ register SEQRAM {
 register SEQADDR0 {
 	address			0x062
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register SEQADDR1 {
@@ -617,6 +647,7 @@ register SEQADDR1 {
 	access_mode RW
 	count		8
 	mask	SEQADDR1_MASK	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -627,35 +658,41 @@ register ACCUM {
 	address			0x064
 	access_mode RW
 	accumulator
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
@@ -664,16 +701,19 @@ register FLAGS {
 	count		18
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
@@ -685,6 +725,7 @@ register STACK {
 	address			0x06f
 	access_mode RO
 	count		5
+	dont_generate_debug_code
 }
 
 const	STACK_SIZE	4
@@ -716,6 +757,7 @@ register DSCOMMAND0 {
 	field	RAMPS		0x04	/* External SCB RAM Present */
 	field	USCBSIZE32	0x02	/* Use 32byte SCB Page Size */
 	field	CIOPARCKEN	0x01	/* Internal bus parity error enable */
+	dont_generate_debug_code
 }
 
 register DSCOMMAND1 {
@@ -724,6 +766,7 @@ register DSCOMMAND1 {
 	mask	DSLATT		0xfc	/* PCI latency timer (non-ultra2) */
 	field	HADDLDSEL1	0x02	/* Host Address Load Select Bits */
 	field	HADDLDSEL0	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -735,6 +778,7 @@ register BUSTIME {
 	count		2
 	mask	BOFF		0xf0
 	mask	BON		0x0f
+	dont_generate_debug_code
 }
 
 /*
@@ -749,6 +793,7 @@ register BUSSPD {
 	mask	STBON		0x07
 	mask	DFTHRSH_100	0xc0
 	mask	DFTHRSH_75	0x80
+	dont_generate_debug_code
 }
 
 /* aic7850/55/60/70/80/95 only */
@@ -756,6 +801,7 @@ register DSPCISTATUS {
 	address			0x086
 	count		4
 	mask	DFTHRSH_100	0xc0
+	dont_generate_debug_code
 }
 
 /* aic7890/91/96/97 only */
@@ -764,6 +810,7 @@ register HS_MAILBOX {
 	mask	HOST_MAILBOX	0xF0
 	mask	SEQ_MAILBOX	0x0F
 	mask	HOST_TQINPOS	0x80	/* Boundary at either 0 or 128 */
+	dont_generate_debug_code
 }
 
 const	HOST_MAILBOX_SHIFT	4
@@ -784,6 +831,7 @@ register HCNTRL {
 	field	INTEN		0x02
 	field	CHIPRST		0x01
 	field	CHIPRSTACK	0x01
+	dont_generate_debug_code
 }
 
 /*
@@ -795,12 +843,14 @@ register HADDR {
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
@@ -810,6 +860,7 @@ register HCNT {
 register SCBPTR {
 	address			0x090
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
@@ -878,6 +929,7 @@ register INTSTAT {
 
 	mask	SEQINT_MASK	0xf0|SEQINT	/* SEQINT Status Codes */
 	mask	INT_PEND  (BRKADRINT|SEQINT|SCSIINT|CMDCMPLT)
+	dont_generate_debug_code
 }
 
 /*
@@ -911,6 +963,7 @@ register CLRINT {
 	field	CLRSCSIINT      0x04
 	field	CLRCMDINT 	0x02
 	field	CLRSEQINT 	0x01
+	dont_generate_debug_code
 }
 
 register DFCNTRL {
@@ -944,6 +997,7 @@ register DFSTATUS {
 register DFWADDR {
 	address			0x95
 	access_mode RW
+	dont_generate_debug_code
 }
 
 register DFRADDR {
@@ -954,6 +1008,7 @@ register DFRADDR {
 register DFDAT {
 	address			0x099
 	access_mode RW
+	dont_generate_debug_code
 }
 
 /*
@@ -967,6 +1022,7 @@ register SCBCNT {
 	count		1
 	field	SCBAUTO		0x80
 	mask	SCBCNT_MASK	0x1f
+	dont_generate_debug_code
 }
 
 /*
@@ -977,6 +1033,7 @@ register QINFIFO {
 	address			0x09b
 	access_mode RW
 	count		12
+	dont_generate_debug_code
 }
 
 /*
@@ -996,6 +1053,7 @@ register QOUTFIFO {
 	address			0x09d
 	access_mode WO
 	count		7
+	dont_generate_debug_code
 }
 
 register CRCCONTROL1 {
@@ -1008,6 +1066,7 @@ register CRCCONTROL1 {
 	field	CRCREQCHKEN		0x10
 	field	TARGCRCENDEN		0x08
 	field	TARGCRCCNTEN		0x04
+	dont_generate_debug_code
 }
 
 
@@ -1040,6 +1099,7 @@ register SFUNCT {
 	access_mode RW
 	count	    4
 	field	ALT_MODE	0x80
+	dont_generate_debug_code
 }
 
 /*
@@ -1053,24 +1113,31 @@ scb {
 		size	4
 		alias	SCB_RESIDUAL_DATACNT
 		alias	SCB_CDB_STORE
+		dont_generate_debug_code
 	}
 	SCB_RESIDUAL_SGPTR {
 		size	4
+		dont_generate_debug_code
 	}
 	SCB_SCSI_STATUS {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_TARGET_PHASES {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_TARGET_DATA_DIR {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_TARGET_ITAG {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_DATAPTR {
 		size	4
+		dont_generate_debug_code
 	}
 	SCB_DATACNT {
 		/*
@@ -1080,12 +1147,14 @@ scb {
 		size	4
 		field	SG_LAST_SEG		0x80	/* In the fourth byte */
 		mask	SG_HIGH_ADDR_BITS	0x7F	/* In the fourth byte */
+		dont_generate_debug_code
 	}
 	SCB_SGPTR {
 		size	4
 		field	SG_RESID_VALID	0x04	/* In the first byte */
 		field	SG_FULL_RESID	0x02	/* In the first byte */
 		field	SG_LIST_NULL	0x01	/* In the first byte */
+		dont_generate_debug_code
 	}
 	SCB_CONTROL {
 		size	1
@@ -1115,22 +1184,27 @@ scb {
 	}
 	SCB_CDB_LEN {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_SCSIRATE {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_SCSIOFFSET {
 		size	1
 		count	1
+		dont_generate_debug_code
 	}
 	SCB_NEXT {
 		size	1
+		dont_generate_debug_code
 	}
 	SCB_64_SPARE {
 		size	16
 	}
 	SCB_64_BTT {
 		size	16
+		dont_generate_debug_code
 	}
 }
 
@@ -1149,6 +1223,7 @@ register SEECTL_2840 {
 	field	CS_2840		0x04
 	field	CK_2840		0x02
 	field	DO_2840		0x01
+	dont_generate_debug_code
 }
 
 register STATUS_2840 {
@@ -1159,6 +1234,7 @@ register STATUS_2840 {
 	mask	BIOS_SEL	0x60
 	mask	ADSEL		0x1e
 	field	DI_2840		0x01
+	dont_generate_debug_code
 }
 
 /* --------------------- AIC-7870-only definitions -------------------- */
@@ -1166,18 +1242,22 @@ register STATUS_2840 {
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
@@ -1186,11 +1266,13 @@ register CCSGCTL {
 	field	CCSGEN		0x08
 	field	SG_FETCH_NEEDED 0x02	/* Bit used for software state */
 	field	CCSGRESET	0x01
+	dont_generate_debug_code
 }
 
 register CCSCBCNT {
 	address			0xEF
 	count		1
+	dont_generate_debug_code
 }
 
 register CCSCBCTL {
@@ -1201,14 +1283,17 @@ register CCSCBCTL {
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
@@ -1218,23 +1303,28 @@ register SCBBADDR {
 	address			0x0F0
 	access_mode RW
 	count		3
+	dont_generate_debug_code
 }
 
 register CCSCBPTR {
 	address			0x0F1
+	dont_generate_debug_code
 }
 
 register HNSCB_QOFF {
 	address			0x0F4
 	count		4
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
@@ -1244,6 +1334,7 @@ register QOFF_CTLSTA {
 	field	SDSCB_ROLLOVER	0x10
 	mask	SCB_QSIZE	0x07
 	mask	SCB_QSIZE_256	0x06
+	dont_generate_debug_code
 }
 
 register DFF_THRSH {
@@ -1267,6 +1358,7 @@ register DFF_THRSH {
 	mask	WR_DFTHRSH_90	0x60
 	mask	WR_DFTHRSH_MAX	0x70
 	count	4
+	dont_generate_debug_code
 }
 
 register SG_CACHE_PRE {
@@ -1275,6 +1367,7 @@ register SG_CACHE_PRE {
 	mask	SG_ADDR_MASK	0xf8
 	field	LAST_SEG	0x02
 	field	LAST_SEG_DONE	0x01
+	dont_generate_debug_code
 }
 
 register SG_CACHE_SHADOW {
@@ -1283,6 +1376,7 @@ register SG_CACHE_SHADOW {
 	mask	SG_ADDR_MASK	0xf8
 	field	LAST_SEG	0x02
 	field	LAST_SEG_DONE	0x01
+	dont_generate_debug_code
 }
 /* ---------------------- Scratch RAM Offsets ------------------------- */
 /* These offsets are either to values that are initialized by the board's
@@ -1309,6 +1403,7 @@ scratch_ram {
 	BUSY_TARGETS {
 		alias		TARG_SCSIRATE
 		size		16
+		dont_generate_debug_code
 	}
 	/*
 	 * Bit vector of targets that have ULTRA enabled as set by
@@ -1321,6 +1416,7 @@ scratch_ram {
 		alias		CMDSIZE_TABLE
 		size		2
 		count		2
+		dont_generate_debug_code
 	}
 	/*
 	 * Bit vector of targets that have disconnection disabled as set by
@@ -1331,6 +1427,7 @@ scratch_ram {
 	DISC_DSB {
 		size		2
 		count		6
+		dont_generate_debug_code
 	}
 	CMDSIZE_TABLE_TAIL {
 		size		4
@@ -1341,12 +1438,14 @@ scratch_ram {
 	 */
 	MWI_RESIDUAL {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * SCBID of the next SCB to be started by the controller.
 	 */
 	NEXT_QUEUED_SCB {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * Single byte buffer used to designate the type or message
@@ -1354,6 +1453,7 @@ scratch_ram {
 	 */
 	MSG_OUT {
 		size		1
+		dont_generate_debug_code
 	}
 	/* Parameters for DMA Logic */
 	DMAPARAMS {
@@ -1369,6 +1469,7 @@ scratch_ram {
 		field	DIRECTION	0x04	/* Set indicates PCI->SCSI */
 		field	FIFOFLUSH	0x02
 		field	FIFORESET	0x01
+		dont_generate_debug_code
 	}
 	SEQ_FLAGS {
 		size		1
@@ -1390,9 +1491,11 @@ scratch_ram {
 	 */
 	SAVED_SCSIID {
 		size		1
+		dont_generate_debug_code
 	}
 	SAVED_LUN {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * The last bus phase as seen by the sequencer. 
@@ -1417,6 +1520,7 @@ scratch_ram {
 	 */
 	WAITING_SCBH {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that are
@@ -1425,6 +1529,7 @@ scratch_ram {
 	 */
 	DISCONNECTED_SCBH {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that are
@@ -1432,6 +1537,7 @@ scratch_ram {
 	 */
 	FREE_SCBH {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * head of list of SCBs that have
@@ -1446,6 +1552,7 @@ scratch_ram {
 	 */
 	HSCB_ADDR {
 		size		4
+		dont_generate_debug_code
 	}
 	/*
 	 * Base address of our shared data with the kernel driver in host
@@ -1454,15 +1561,19 @@ scratch_ram {
 	 */
 	SHARED_DATA_ADDR {
 		size		4
+		dont_generate_debug_code
 	}
 	KERNEL_QINPOS {
 		size		1
+		dont_generate_debug_code
 	}
 	QINPOS {
 		size		1
+		dont_generate_debug_code
 	}
 	QOUTPOS {
 		size		1
+		dont_generate_debug_code
 	}
 	/*
 	 * Kernel and sequencer offsets into the queue of
@@ -1471,9 +1582,11 @@ scratch_ram {
 	 */
 	KERNEL_TQINPOS {
 		size		1
+		dont_generate_debug_code
 	}
 	TQINPOS {
 		size		1
+		dont_generate_debug_code
 	}
 	ARG_1 {
 		size		1
@@ -1486,10 +1599,12 @@ scratch_ram {
 		mask	CONT_MSG_LOOP		0x04
 		mask	CONT_TARG_SESSION	0x02
 		alias	RETURN_1
+		dont_generate_debug_code
 	}
 	ARG_2 {
 		size		1
 		alias	RETURN_2
+		dont_generate_debug_code
 	}
 
 	/*
@@ -1498,6 +1613,7 @@ scratch_ram {
 	LAST_MSG {
 		size		1
 		alias	TARG_IMMEDIATE_SCB
+		dont_generate_debug_code
 	}
 
 	/*
@@ -1513,6 +1629,7 @@ scratch_ram {
 		field	ENAUTOATNO	0x08
 		field	ENAUTOATNI	0x04
 		field	ENAUTOATNP	0x02
+		dont_generate_debug_code
 	}
 }
 
@@ -1533,12 +1650,14 @@ scratch_ram {
 		field	HA_274_EXTENDED_TRANS	0x01
 		alias	INITIATOR_TAG
 		count		1
+		dont_generate_debug_code
 	}
 
 	SEQ_FLAGS2 {
 		size	1
 		field	SCB_DMA			0x01
 		field	TARGET_MSG_PENDING	0x02
+		dont_generate_debug_code
 	}
 }
 
@@ -1562,6 +1681,7 @@ scratch_ram {
 		field	ENSPCHK		0x20
 		mask	HSCSIID		0x07	/* our SCSI ID */
 		mask	HWSCSIID	0x0f	/* our SCSI ID if Wide Bus */
+		dont_generate_debug_code
 	}
 	INTDEF {
 		address		0x05c
@@ -1569,11 +1689,13 @@ scratch_ram {
 		count		1
 		field	EDGE_TRIG	0x80
 		mask	VECTOR		0x0f
+		dont_generate_debug_code
 	}
 	HOSTCONF {
 		address		0x05d
 		size		1
 		count		1
+		dont_generate_debug_code
 	}
 	HA_274_BIOSCTRL	{
 		address		0x05f
@@ -1582,6 +1704,7 @@ scratch_ram {
 		mask	BIOSMODE		0x30
 		mask	BIOSDISABLED		0x30	
 		field	CHANNEL_B_PRIMARY	0x08
+		dont_generate_debug_code
 	}
 }
 
@@ -1595,6 +1718,7 @@ scratch_ram {
 	TARG_OFFSET {
 		size		16
 		count		1
+		dont_generate_debug_code
 	}
 }
 
_
