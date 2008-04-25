From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] aic7xxx: teach aicasm to not emit unused debug code/data
Date: Fri, 25 Apr 2008 15:01:41 +0200
Message-ID: <4811D635.4020904@suse.de>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250434.49377.vda.linux@googlemail.com> <200804250436.01295.vda.linux@googlemail.com> <200804250441.43480.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080209060409090007000204"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYDYNBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 09:01:46 -0400
In-Reply-To: <200804250441.43480.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This is a multi-part message in MIME format.
--------------080209060409090007000204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi Denys,

Denys Vlasenko wrote:
> Add "dont_generate_debug_code" syntax handling to aicasm_gram.y
> 
> aic79xx.reg, aic7xxx.reg: add dont_generate_debug_code keyword
> for registers which are never referenced by the driver.
> 
> aicasm.c, aicasm_symbol.[ch]: don't emit code for those regs;
> also add "const" keyword to generated code in few places.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
No.
Adding a symbol to each and every register definition
which has to be hand-crafted anyway is not the correct way.

I would prefer this: Add a 'count' variable to each symbol
which gets increased every time the symbol is referenced.
And then modify the register definition to include counts
for symbols which are referenced from the source code only
and not from the sequencer code.

This will give us an automatic usage count for the symbols
with only minimal hand-crafting.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080209060409090007000204
Content-Type: text/plain;
 name="aic7xxx-aicasm-no-unused-symbols"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-aicasm-no-unused-symbols"

diff --git a/drivers/scsi/aic7xxx/aic79xx.reg b/drivers/scsi/aic7xxx/aic79xx.reg
index 6ab514d..cca16fc 100644
--- a/drivers/scsi/aic7xxx/aic79xx.reg
+++ b/drivers/scsi/aic7xxx/aic79xx.reg
@@ -198,6 +198,7 @@ register SEQINTCODE {
 register CLRINT {
 	address			0x003
 	access_mode	WO
+	count		19
 	field	CLRHWERRINT	0x80 /* Rev B or greater */
 	field	CLRBRKADRINT	0x40
 	field	CLRSWTMINT	0x20
@@ -245,6 +246,7 @@ register CLRERR {
 register HCNTRL {
 	address			0x005
 	access_mode	RW
+	count		12
 	field	SEQ_RESET	0x80 /* Rev B or greater */
 	field	POWRDN		0x40
 	field	SWINT		0x10
@@ -262,6 +264,7 @@ register HNSCB_QOFF {
 	address			0x006
 	access_mode	RW
 	size		2
+	count		2
 }
 
 /*
@@ -270,6 +273,7 @@ register HNSCB_QOFF {
 register HESCB_QOFF {
 	address			0x008
 	access_mode	RW
+	count		2
 }
 
 /*
@@ -287,6 +291,7 @@ register HS_MAILBOX {
  */
 register SEQINTSTAT {
 	address			0x00C
+	count		1
 	access_mode	RO
 	field	SEQ_SWTMRTO	0x10
 	field	SEQ_SEQINT	0x08
@@ -332,6 +337,7 @@ register SNSCB_QOFF {
  */
 register SESCB_QOFF {
 	address			0x012
+	count		2
 	access_mode	RW
 	modes		M_CCHAN
 }
@@ -397,6 +403,7 @@ register DFCNTRL {
 	address			0x019
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	count		11
 	field	PRELOADEN	0x80
 	field	SCSIENWRDIS	0x40	/* Rev B only. */
 	field	SCSIEN		0x20
@@ -415,6 +422,7 @@ register DFCNTRL {
  */
 register DSCOMMAND0 {
 	address			0x019
+	count		1
 	access_mode	RW
 	modes		M_CFG
 	field	CACHETHEN	0x80	/* Cache Threshold enable */
@@ -580,6 +588,7 @@ register DFF_THRSH {
 	address			0x088
 	access_mode	RW
 	modes		M_CFG
+	count		1
 	field	WR_DFTHRSH	0x70 {
 		WR_DFTHRSH_MIN,
 		WR_DFTHRSH_25,
@@ -800,6 +809,7 @@ register PCIXCTL {
 	address			0x093
 	access_mode	RW
 	modes		M_CFG
+	count		1
 	field	SERRPULSE	0x80
 	field	UNEXPSCIEN	0x20
 	field	SPLTSMADIS	0x10
@@ -844,6 +854,7 @@ register DCHSPLTSTAT0 {
 	address			0x096
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	count		2
 	field	STAETERM	0x80
 	field	SCBCERR		0x40
 	field	SCADERR		0x20
@@ -895,6 +906,7 @@ register DCHSPLTSTAT1 {
 	address			0x097
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	count		2
 	field	RXDATABUCKET	0x01
 }
 
@@ -1048,6 +1060,7 @@ register SGSPLTSTAT0 {
 	address			0x09E
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	count		2
 	field	STAETERM	0x80
 	field	SCBCERR		0x40
 	field	SCADERR		0x20
@@ -1065,6 +1078,7 @@ register SGSPLTSTAT1 {
 	address			0x09F
 	access_mode	RW
 	modes		M_DFF0, M_DFF1
+	count		2
 	field	RXDATABUCKET	0x01
 }
 
@@ -1086,6 +1100,7 @@ register DF0PCISTAT {
 	address			0x0A0
 	access_mode	RW
 	modes		M_CFG
+	count		1
 	field	DPE		0x80
 	field	SSE		0x40
 	field	RMA		0x20
@@ -1184,6 +1199,7 @@ register TARGPCISTAT {
 	address			0x0A7
 	access_mode	RW
 	modes		M_CFG
+	count		5
 	field	DPE		0x80
 	field	SSE		0x40
 	field	STA		0x08
@@ -1198,6 +1214,7 @@ register LQIN {
 	address			0x020
 	access_mode	RW
 	size		20
+	count		2
 	modes		M_DFF0, M_DFF1, M_SCSI
 }
 
@@ -1229,6 +1246,7 @@ register LUNPTR {
 	address			0x022
 	access_mode	RW
 	modes		M_CFG
+	count		2
 }
 
 /*
@@ -1259,6 +1277,7 @@ register CMDLENPTR {
 	address			0x025
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1270,6 +1289,7 @@ register ATTRPTR {
 	address			0x026
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1281,6 +1301,7 @@ register FLAGPTR {
 	address			0x027
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1291,6 +1312,7 @@ register CMDPTR {
 	address			0x028
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1301,6 +1323,7 @@ register QNEXTPTR {
 	address			0x029
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1323,6 +1346,7 @@ register ABRTBYTEPTR {
 	address			0x02B
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1333,6 +1357,7 @@ register ABRTBITPTR {
 	address			0x02C
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1370,6 +1395,7 @@ register LUNLEN {
 	address			0x030
 	access_mode	RW
 	modes		M_CFG
+	count		2
 	mask		ILUNLEN	0x0F
 	mask		TLUNLEN	0xF0
 }
@@ -1383,6 +1409,7 @@ register CDBLIMIT {
 	address			0x031
 	access_mode	RW
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -1394,6 +1421,7 @@ register MAXCMD {
 	address			0x032
 	access_mode	RW
 	modes		M_CFG
+	count		9
 }
 
 /*
@@ -1458,6 +1486,7 @@ register LQCTL1 {
 	address			0x038
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		2
 	field	PCI2PCI		0x04
 	field	SINGLECMD	0x02
 	field	ABORTPENDING	0x01
@@ -1470,6 +1499,7 @@ register LQCTL2 {
 	address			0x039
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		5
 	field	LQIRETRY	0x80
 	field	LQICONTINUE	0x40
 	field	LQITOIDLE	0x20
@@ -1528,6 +1558,7 @@ register SCSISEQ1 {
 	address			0x03B
 	access_mode	RW
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		8
 	field	MANUALCTL	0x40
 	field	ENSELI		0x20
 	field	ENRSELI		0x10
@@ -1667,6 +1698,9 @@ register SCSISIGO {
 	}
 }
 
+/*
+ * SCSI Control Signal In
+ */
 register SCSISIGI {
 	address			0x041
 	access_mode	RO
@@ -1703,6 +1737,7 @@ register MULTARGID {
 	access_mode	RW
 	modes		M_CFG
 	size		2
+	count		2
 }
 
 /*
@@ -1758,6 +1793,7 @@ register TARGIDIN {
 	address			0x048
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		2
 	field	CLKOUT		0x80
 	field	TARGID		0x0F
 }
@@ -1798,6 +1834,7 @@ register OPTIONMODE {
 	address			0x04A
 	access_mode	RW
 	modes		M_CFG
+	count		4
 	field	BIOSCANCTL		0x80
 	field	AUTOACKEN		0x40
 	field	BIASCANCTL		0x20
@@ -1850,6 +1887,7 @@ register SIMODE0 {
 	address			0x04B
 	access_mode	RW
 	modes		M_CFG
+	count		8
 	field	ENSELDO		0x40
 	field	ENSELDI		0x20
 	field	ENSELINGO	0x10
@@ -1945,6 +1983,7 @@ register PERRDIAG {
 	address			0x04E
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		3
 	field	HIZERO		0x80
 	field	HIPERR		0x40
 	field	PREVPHASE	0x20
@@ -1962,6 +2001,7 @@ register LQISTATE {
 	address			0x04E
 	access_mode	RO
 	modes		M_CFG
+	count		6
 }
 
 /*
@@ -1971,6 +2011,7 @@ register SOFFCNT {
 	address			0x04F
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		1
 }
 
 /*
@@ -1980,6 +2021,7 @@ register LQOSTATE {
 	address			0x04F
 	access_mode	RO
 	modes		M_CFG
+	count		2
 }
 
 /*
@@ -1989,6 +2031,7 @@ register LQISTAT0 {
 	address			0x050
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		2
 	field	LQIATNQAS	0x20
 	field	LQICRCT1	0x10
 	field	LQICRCT2	0x08
@@ -2004,6 +2047,7 @@ register CLRLQIINT0 {
 	address			0x050
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		1
 	field	CLRLQIATNQAS	0x20
 	field	CLRLQICRCT1	0x10
 	field	CLRLQICRCT2	0x08
@@ -2019,6 +2063,7 @@ register LQIMODE0 {
 	address			0x050
 	access_mode	RW
 	modes		M_CFG
+	count		3
 	field	ENLQIATNQASK	0x20
 	field	ENLQICRCT1	0x10
 	field	ENLQICRCT2	0x08
@@ -2034,6 +2079,7 @@ register LQISTAT1 {
 	address			0x051
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		3
 	field	LQIPHASE_LQ	0x80
 	field	LQIPHASE_NLQ	0x40
 	field	LQIABORT	0x20
@@ -2051,6 +2097,7 @@ register CLRLQIINT1 {
 	address			0x051
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		4
 	field	CLRLQIPHASE_LQ	0x80
 	field	CLRLQIPHASE_NLQ	0x40
 	field	CLRLIQABORT	0x20
@@ -2068,6 +2115,7 @@ register LQIMODE1 {
 	address			0x051
 	access_mode	RW
 	modes		M_CFG
+	count		4
 	field	ENLQIPHASE_LQ	0x80	/* LQIPHASE1 */
 	field	ENLQIPHASE_NLQ	0x40	/* LQIPHASE2 */
 	field	ENLIQABORT	0x20
@@ -2102,6 +2150,7 @@ register SSTAT3 {
 	address			0x053
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		3
 	field	NTRAMPERR	0x02
 	field	OSRAMPERR	0x01
 }
@@ -2113,6 +2162,7 @@ register CLRSINT3 {
 	address			0x053
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		3
 	field	CLRNTRAMPERR	0x02
 	field	CLROSRAMPERR	0x01
 }
@@ -2124,6 +2174,7 @@ register SIMODE3 {
 	address			0x053
 	access_mode	RW
 	modes		M_CFG
+	count		4
 	field	ENNTRAMPERR	0x02
 	field	ENOSRAMPERR	0x01
 }
@@ -2135,6 +2186,7 @@ register LQOSTAT0 {
 	address			0x054
 	access_mode	RO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		2
 	field	LQOTARGSCBPERR	0x10
 	field	LQOSTOPT2	0x08
 	field	LQOATNLQ	0x04
@@ -2149,6 +2201,7 @@ register CLRLQOINT0 {
 	address			0x054
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		3
 	field	CLRLQOTARGSCBPERR	0x10
 	field	CLRLQOSTOPT2		0x08
 	field	CLRLQOATNLQ		0x04
@@ -2163,6 +2216,7 @@ register LQOMODE0 {
 	address			0x054
 	access_mode	RW
 	modes		M_CFG
+	count		4
 	field	ENLQOTARGSCBPERR	0x10
 	field	ENLQOSTOPT2		0x08
 	field	ENLQOATNLQ		0x04
@@ -2191,6 +2245,7 @@ register CLRLQOINT1 {
 	address			0x055
 	access_mode	WO
 	modes		M_DFF0, M_DFF1, M_SCSI
+	count		7
 	field	CLRLQOINITSCBPERR	0x10
 	field	CLRLQOSTOPI2		0x08
 	field	CLRLQOBADQAS		0x04
@@ -2205,6 +2260,7 @@ register LQOMODE1 {
 	address			0x055
 	access_mode	RW
 	modes		M_CFG
+	count		4
 	field	ENLQOINITSCBPERR	0x10
 	field	ENLQOSTOPI2		0x08
 	field	ENLQOBADQAS		0x04
@@ -2232,6 +2288,7 @@ register OS_SPACE_CNT {
 	address			0x056
 	access_mode	RO
 	modes		M_CFG
+	count		2
 }
 
 /*
@@ -2286,13 +2343,19 @@ register NEXTSCB {
 	modes		M_SCSI
 }
 
-/* Rev B only. */
+/*
+ * LQO SCSI Control
+ * (Rev B only.)
+ */
 register LQOSCSCTL {
 	address			0x05A
 	access_mode	RW
 	size		1
 	modes		M_CFG
+	count		1
 	field		LQOH2A_VERSION	0x80
+	field		LQOBUSETDLY	0x40
+	field		LQONOHOLDLACK	0x02
 	field		LQONOCHKOVER	0x01
 }
 
@@ -2459,6 +2522,7 @@ register NEGPERIOD {
 	address			0x061
 	access_mode	RW
 	modes		M_SCSI
+	count		1
 }
 
 /*
@@ -2478,6 +2542,7 @@ register NEGOFFSET {
 	address			0x062
 	access_mode	RW
 	modes		M_SCSI
+	count		1
 }
 
 /*
@@ -2487,6 +2552,7 @@ register NEGPPROPTS {
 	address			0x063
 	access_mode	RW
 	modes		M_SCSI
+	count		1
 	field	PPROPT_PACE	0x08
 	field	PPROPT_QAS	0x04
 	field	PPROPT_DT	0x02
@@ -2516,12 +2582,19 @@ register ANNEXCOL {
 	address			0x065
 	access_mode	RW
 	modes		M_SCSI
+	count		7
 }
 
+/*
+ * SCSI Check
+ * (Rev. B only)
+ */
 register SCSCHKN {
 	address			0x066
 	access_mode	RW
 	modes		M_CFG
+	count		1
+	field	BIDICHKDIS	0x80
 	field	STSELSKIDDIS	0x40
 	field	CURRFIFODEF	0x20
 	field	WIDERESEN	0x10
@@ -2561,6 +2634,7 @@ register ANNEXDAT {
 	address			0x066
 	access_mode	RW
 	modes		M_SCSI
+	count		3
 }
 
 /*
@@ -2596,6 +2670,7 @@ register TOWNID {
 	address			0x069
 	access_mode	RW
 	modes		M_SCSI
+	count		2
 }
 
 /*
@@ -2737,6 +2812,7 @@ register SCBAUTOPTR {
 	address			0x0AB
 	access_mode	RW
 	modes		M_CFG
+	count		1
 	field	AUSCBPTR_EN	0x80
 	field	SCBPTR_ADDR	0x38
 	field	SCBPTR_OFF	0x07
@@ -2881,6 +2957,7 @@ register BRDDAT {
 	address			0x0B8
 	access_mode	RW
 	modes		M_SCSI
+	count		2
 }
 
 /*
@@ -2890,6 +2967,7 @@ register BRDCTL {
 	address			0x0B9
 	access_mode	RW
 	modes		M_SCSI
+	count		7
 	field	FLXARBACK	0x80
 	field	FLXARBREQ	0x40
 	field	BRDADDR		0x38
@@ -2905,6 +2983,7 @@ register SEEADR {
 	address			0x0BA
 	access_mode	RW
 	modes		M_SCSI
+	count		4
 }
 
 /*
@@ -2915,6 +2994,7 @@ register SEEDAT {
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	count		4
 }
 
 /*
@@ -2924,6 +3004,7 @@ register SEESTAT {
 	address			0x0BE
 	access_mode	RO
 	modes		M_SCSI
+	count		1
 	field	INIT_DONE	0x80
 	field	SEEOPCODE	0x70
 	field	LDALTID_L	0x08
@@ -2939,6 +3020,7 @@ register SEECTL {
 	address			0x0BE
 	access_mode	RW
 	modes		M_SCSI
+	count		4
 	field	SEEOPCODE	0x70 {
 		SEEOP_ERASE	0x70,
 		SEEOP_READ	0x60,
@@ -3000,6 +3082,7 @@ register DSPDATACTL {
 	address			0x0C1
 	access_mode	RW
 	modes		M_CFG
+	count		3
 	field	BYPASSENAB	0x80
 	field	DESQDIS		0x10
 	field	RCVROFFSTDIS	0x04
@@ -3058,6 +3141,7 @@ register DSPSELECT {
 	address			0x0C4
 	access_mode	RW
 	modes		M_CFG
+	count		1
 	field	AUTOINCEN	0x80
 	field	DSPSEL		0x1F
 }
@@ -3071,6 +3155,7 @@ register WRTBIASCTL {
 	address			0x0C5
 	access_mode	WO
 	modes		M_CFG
+	count		3
 	field	AUTOXBCDIS	0x80
 	field	XMITMANVAL	0x3F
 }
@@ -3196,7 +3281,8 @@ register OVLYADDR {
  */
 register SEQCTL0 {
 	address			0x0D6
-	access_mode RW
+	access_mode	RW
+	count		11
 	field	PERRORDIS	0x80
 	field	PAUSEDIS	0x40
 	field	FAILDIS		0x20
@@ -3226,7 +3312,8 @@ register SEQCTL1 {
  */
 register FLAGS {
 	address			0x0D8
-	access_mode RO
+	access_mode 	RO
+	count		23
 	field	ZERO		0x02
 	field	CARRY		0x01
 }
@@ -3255,7 +3342,8 @@ register SEQINTCTL {
  */
 register SEQRAM {
 	address			0x0DA
-	access_mode RW
+	access_mode 	RW
+	count		2
 }
 
 /*
@@ -3266,6 +3354,7 @@ register PRGMCNT {
 	address			0x0DE
 	access_mode	RW
 	size		2
+	count		5
 }
 
 /*
@@ -3273,7 +3362,7 @@ register PRGMCNT {
  */
 register ACCUM {
 	address			0x0E0
-	access_mode RW
+	access_mode 	RW
 	accumulator
 }
 
@@ -3401,6 +3490,7 @@ register INTVEC1_ADDR {
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -3412,6 +3502,7 @@ register CURADDR {
 	access_mode	RW
 	size		2
 	modes		M_SCSI
+	count		2
 }
 
 /*
@@ -3423,6 +3514,7 @@ register INTVEC2_ADDR {
 	access_mode	RW
 	size		2
 	modes		M_CFG
+	count		1
 }
 
 /*
@@ -3579,6 +3671,7 @@ scratch_ram {
 	/* Parameters for DMA Logic */
 	DMAPARAMS {
 		size		1
+		count		8
 		field	PRELOADEN	0x80
 		field	WIDEODD		0x40
 		field	SCSIEN		0x20
@@ -3648,9 +3741,11 @@ scratch_ram {
 	 */
 	KERNEL_TQINPOS {
 		size		1
+		count		1
 	}
 	TQINPOS {
 		size		1
+		count		8
 	}
 	/*
 	 * Base address of our shared data with the kernel driver in host
@@ -3681,6 +3776,7 @@ scratch_ram {
 	}
 	ARG_2 {
 		size		1
+		count		1
 		alias	RETURN_2
 	}
 
@@ -3698,6 +3794,7 @@ scratch_ram {
 	 */
 	SCSISEQ_TEMPLATE {
 		size		1
+		count		7
 		field	MANUALCTL	0x40
 		field	ENSELI		0x20
 		field	ENRSELI		0x10
@@ -3711,6 +3808,7 @@ scratch_ram {
 	 */
 	INITIATOR_TAG {
 		size		1
+		count		1
 	}
 
 	SEQ_FLAGS2 {
@@ -3777,6 +3875,7 @@ scratch_ram {
 	 */
 	CMDSIZE_TABLE {
 		size		8
+		count		8
 	}
 	/*
 	 * When an SCB with the MK_MESSAGE flag is
@@ -3803,8 +3902,8 @@ scratch_ram {
 /************************* Hardware SCB Definition ****************************/
 scb {
 	address			0x180
-	size	64
-	modes	0, 1, 2, 3
+	size		64
+	modes		0, 1, 2, 3
 	SCB_RESIDUAL_DATACNT {
 		size	4
 		alias	SCB_CDB_STORE
diff --git a/drivers/scsi/aic7xxx/aic7xxx.reg b/drivers/scsi/aic7xxx/aic7xxx.reg
index 2a10353..0d2f763 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.reg
+++ b/drivers/scsi/aic7xxx/aic7xxx.reg
@@ -238,6 +238,7 @@ register SXFRCTL2 {
 register OPTIONMODE {
 	address			0x008
 	access_mode RW
+	count		2
 	field	AUTORATEEN		0x80
 	field	AUTOACKEN		0x40
 	field	ATNMGMNTEN		0x20
@@ -254,6 +255,7 @@ register TARGCRCCNT {
 	address			0x00a
 	size	2
 	access_mode RW
+	count		2
 }
 
 /*
@@ -344,6 +346,7 @@ register SSTAT2 {
 register SSTAT3 {
 	address			0x00e
 	access_mode RO
+	count		2
 	mask	SCSICNT		0xf0
 	mask	OFFCNT		0x0f
 	mask	U2OFFCNT	0x7f
@@ -367,6 +370,7 @@ register SCSIID_ULTRA2 {
 register SIMODE0 {
 	address			0x010
 	access_mode RW
+	count		2
 	field	ENSELDO		0x40
 	field	ENSELDI		0x20
 	field	ENSELINGO	0x10
@@ -429,6 +433,7 @@ register SHADDR {
 register SELTIMER {
 	address			0x018
 	access_mode RW
+	count		1
 	field	STAGE6		0x20
 	field	STAGE5		0x10
 	field	STAGE4		0x08
@@ -467,6 +472,7 @@ register TARGID {
 	address			0x01b
 	size			2
 	access_mode RW
+	count		14
 }
 
 /*
@@ -480,6 +486,7 @@ register TARGID {
 register SPIOCAP {
 	address			0x01b
 	access_mode RW
+	count		10
 	field	SOFT1		0x80
 	field	SOFT0		0x40
 	field	SOFTCMDEN	0x20	
@@ -492,6 +499,7 @@ register SPIOCAP {
 
 register BRDCTL	{
 	address			0x01d
+	count		11
 	field	BRDDAT7		0x80
 	field	BRDDAT6		0x40
 	field	BRDDAT5		0x20
@@ -534,6 +542,7 @@ register BRDCTL	{
  */
 register SEECTL {
 	address			0x01e
+	count		11
 	field	EXTARBACK	0x80
 	field	EXTARBREQ	0x40
 	field	SEEMS		0x20
@@ -570,6 +579,7 @@ register SBLKCTL {
 register SEQCTL {
 	address			0x060
 	access_mode RW
+	count		15
 	field	PERRORDIS	0x80
 	field	PAUSEDIS	0x40
 	field	FAILDIS		0x20
@@ -590,6 +600,7 @@ register SEQCTL {
 register SEQRAM {
 	address			0x061
 	access_mode RW
+	count		2
 }
 
 /*
@@ -604,6 +615,7 @@ register SEQADDR0 {
 register SEQADDR1 {
 	address			0x063
 	access_mode RW
+	count		8
 	mask	SEQADDR1_MASK	0x01
 }
 
@@ -649,6 +661,7 @@ register NONE {
 register FLAGS {
 	address			0x06b
 	access_mode RO
+	count		18
 	field	ZERO		0x02
 	field	CARRY		0x01
 }
@@ -671,6 +684,7 @@ register FUNCTION1 {
 register STACK {
 	address			0x06f
 	access_mode RO
+	count		5
 }
 
 const	STACK_SIZE	4
@@ -692,6 +706,7 @@ register BCTL {
 register DSCOMMAND0 {
 	address			0x084
 	access_mode RW
+	count		7
 	field	CACHETHEN	0x80	/* Cache Threshold enable */
 	field	DPARCKEN	0x40	/* Data Parity Check Enable */
 	field	MPARCKEN	0x20	/* Memory Parity Check Enable */
@@ -717,6 +732,7 @@ register DSCOMMAND1 {
 register BUSTIME {
 	address			0x085
 	access_mode RW
+	count		2
 	mask	BOFF		0xf0
 	mask	BON		0x0f
 }
@@ -727,6 +743,7 @@ register BUSTIME {
 register BUSSPD {
 	address			0x086
 	access_mode RW
+	count		2
 	mask	DFTHRSH		0xc0
 	mask	STBOFF		0x38
 	mask	STBON		0x07
@@ -737,6 +754,7 @@ register BUSSPD {
 /* aic7850/55/60/70/80/95 only */
 register DSPCISTATUS {
 	address			0x086
+	count		4
 	mask	DFTHRSH_100	0xc0
 }
 
@@ -758,6 +776,7 @@ const	SEQ_MAILBOX_SHIFT	0
 register HCNTRL {
 	address			0x087
 	access_mode RW
+	count		14
 	field	POWRDN		0x40
 	field	SWINT		0x10
 	field	IRQMS		0x08
@@ -869,6 +888,7 @@ register INTSTAT {
 register ERROR {
 	address			0x092
 	access_mode RO
+	count		26
 	field	CIOPARERR	0x80	/* Ultra2 only */
 	field	PCIERRSTAT	0x40	/* PCI only */
 	field	MPARERR		0x20	/* PCI only */
@@ -885,6 +905,7 @@ register ERROR {
 register CLRINT {
 	address			0x092
 	access_mode WO
+	count		24
 	field	CLRPARERR	0x10	/* PCI only */
 	field	CLRBRKADRINT	0x08
 	field	CLRSCSIINT      0x04
@@ -943,6 +964,7 @@ register DFDAT {
 register SCBCNT {
 	address			0x09a
 	access_mode RW
+	count		1
 	field	SCBAUTO		0x80
 	mask	SCBCNT_MASK	0x1f
 }
@@ -954,6 +976,7 @@ register SCBCNT {
 register QINFIFO {
 	address			0x09b
 	access_mode RW
+	count		12
 }
 
 /*
@@ -972,11 +995,13 @@ register QINCNT	{
 register QOUTFIFO {
 	address			0x09d
 	access_mode WO
+	count		7
 }
 
 register CRCCONTROL1 {
 	address			0x09d
 	access_mode RW
+	count		3
 	field	CRCONSEEN		0x80
 	field	CRCVALCHKEN		0x40
 	field	CRCENDCHKEN		0x20
@@ -1013,6 +1038,7 @@ register SCSIPHASE {
 register SFUNCT {
 	address			0x09f
 	access_mode RW
+	count	    4
 	field	ALT_MODE	0x80
 }
 
@@ -1095,6 +1121,7 @@ scb {
 	}
 	SCB_SCSIOFFSET {
 		size	1
+		count	1
 	}
 	SCB_NEXT {
 		size	1
@@ -1118,6 +1145,7 @@ const	SG_SIZEOF	0x08		/* sizeof(struct ahc_dma) */
 register SEECTL_2840 {
 	address			0x0c0
 	access_mode RW
+	count		2
 	field	CS_2840		0x04
 	field	CK_2840		0x02
 	field	DO_2840		0x01
@@ -1126,6 +1154,7 @@ register SEECTL_2840 {
 register STATUS_2840 {
 	address			0x0c1
 	access_mode RW
+	count		4
 	field	EEPROM_TF	0x80
 	mask	BIOS_SEL	0x60
 	mask	ADSEL		0x1e
@@ -1161,6 +1190,7 @@ register CCSGCTL {
 
 register CCSCBCNT {
 	address			0xEF
+	count		1
 }
 
 register CCSCBCTL {
@@ -1187,6 +1217,7 @@ register CCSCBRAM {
 register SCBBADDR {
 	address			0x0F0
 	access_mode RW
+	count		3
 }
 
 register CCSCBPTR {
@@ -1195,6 +1226,7 @@ register CCSCBPTR {
 
 register HNSCB_QOFF {
 	address			0x0F4
+	count		4
 }
 
 register SNSCB_QOFF {
@@ -1234,6 +1266,7 @@ register DFF_THRSH {
 	mask	WR_DFTHRSH_85	0x50
 	mask	WR_DFTHRSH_90	0x60
 	mask	WR_DFTHRSH_MAX	0x70
+	count	4
 }
 
 register SG_CACHE_PRE {
@@ -1287,6 +1320,7 @@ scratch_ram {
 	ULTRA_ENB {
 		alias		CMDSIZE_TABLE
 		size		2
+		count		2
 	}
 	/*
 	 * Bit vector of targets that have disconnection disabled as set by
@@ -1296,6 +1330,7 @@ scratch_ram {
 	 */
 	DISC_DSB {
 		size		2
+		count		6
 	}
 	CMDSIZE_TABLE_TAIL {
 		size		4
@@ -1323,6 +1358,7 @@ scratch_ram {
 	/* Parameters for DMA Logic */
 	DMAPARAMS {
 		size		1
+		count		12
 		field	PRELOADEN	0x80
 		field	WIDEODD		0x40
 		field	SCSIEN		0x20
@@ -1441,6 +1477,7 @@ scratch_ram {
 	}
 	ARG_1 {
 		size		1
+		count		1
 		mask	SEND_MSG		0x80
 		mask	SEND_SENSE		0x40
 		mask	SEND_REJ		0x20
@@ -1495,6 +1532,7 @@ scratch_ram {
 		size	1
 		field	HA_274_EXTENDED_TRANS	0x01
 		alias	INITIATOR_TAG
+		count		1
 	}
 
 	SEQ_FLAGS2 {
@@ -1518,6 +1556,7 @@ scratch_ram {
 	 */
 	SCSICONF {
 		size		1
+		count		12
 		field	TERM_ENB	0x80
 		field	RESET_SCSI	0x40
 		field	ENSPCHK		0x20
@@ -1527,16 +1566,19 @@ scratch_ram {
 	INTDEF {
 		address		0x05c
 		size		1
+		count		1
 		field	EDGE_TRIG	0x80
 		mask	VECTOR		0x0f
 	}
 	HOSTCONF {
 		address		0x05d
 		size		1
+		count		1
 	}
 	HA_274_BIOSCTRL	{
 		address		0x05f
 		size		1
+		count		1
 		mask	BIOSMODE		0x30
 		mask	BIOSDISABLED		0x30	
 		field	CHANNEL_B_PRIMARY	0x08
@@ -1552,6 +1594,7 @@ scratch_ram {
 	 */
 	TARG_OFFSET {
 		size		16
+		count		1
 	}
 }
 
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
index 9241027..e4a7787 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -362,7 +362,7 @@ output_code()
 " *\n"
 "%s */\n", versions);
 
-	fprintf(ofile, "static uint8_t seqprog[] = {\n");
+	fprintf(ofile, "static const uint8_t seqprog[] = {\n");
 	for (cur_instr = STAILQ_FIRST(&seq_program);
 	     cur_instr != NULL;
 	     cur_instr = STAILQ_NEXT(cur_instr, links)) {
@@ -415,7 +415,7 @@ output_code()
 	}
 
 	fprintf(ofile,
-"static struct patch {\n"
+"static const struct patch {\n"
 "	%spatch_func_t		*patch_func;\n"
 "	uint32_t		 begin		:10,\n"
 "				 skip_instr	:10,\n"
@@ -435,7 +435,7 @@ output_code()
 	fprintf(ofile, "\n};\n\n");
 
 	fprintf(ofile,
-"static struct cs {\n"
+"static const struct cs {\n"
 "	uint16_t	begin;\n"
 "	uint16_t	end;\n"
 "} critical_sections[] = {\n");
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index e1079dd..81be6a2 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -143,6 +143,8 @@ void yyerror(const char *string);
 
 %token <value> T_ADDRESS
 
+%token T_COUNT
+
 %token T_ACCESS_MODE
 
 %token T_MODES
@@ -353,6 +355,7 @@ reg_attribute_list:
 reg_attribute:
 	reg_address
 |	size
+|	count
 |	access_mode
 |	modes
 |	field_defn
@@ -393,6 +396,13 @@ size:
 	}
 ;
 
+count:
+	T_COUNT T_NUMBER
+	{
+		cur_symbol->count += $2;
+	}
+;
+
 access_mode:
 	T_ACCESS_MODE T_MODE
 	{
@@ -801,6 +811,7 @@ scratch_ram:
 			cur_symtype = SRAMLOC;
 			cur_symbol->type = SRAMLOC;
 			initialize_symbol(cur_symbol);
+			cur_symbol->count += 1;
 		}
 		reg_address
 		{
@@ -832,6 +843,7 @@ scb:
 			initialize_symbol(cur_symbol);
 			/* 64 bytes of SCB space */
 			cur_symbol->info.rinfo->size = 64;
+			cur_symbol->count += 1;
 		}
 		reg_address
 		{
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index 62b6c1b..2c7f02d 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -162,6 +162,7 @@ register		{ return T_REGISTER; }
 const			{ yylval.value = FALSE; return T_CONST; }
 download		{ return T_DOWNLOAD; }
 address			{ return T_ADDRESS; }
+count			{ return T_COUNT; }
 access_mode		{ return T_ACCESS_MODE; }
 modes			{ return T_MODES; }
 RW|RO|WO		{
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
index f1f448d..fcd3578 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -77,6 +77,7 @@ symbol_create(char *name)
 	if (new_symbol->name == NULL)
 		 stop("Unable to strdup symbol name", EX_SOFTWARE);
 	new_symbol->type = UNINITIALIZED;
+	new_symbol->count = 1;
 	return (new_symbol);
 }
 
@@ -198,6 +199,12 @@ symtable_get(char *name)
 		}
 	}
 	memcpy(&stored_ptr, data.data, sizeof(stored_ptr));
+	stored_ptr->count++;
+	data.data = &stored_ptr;
+	if (symtable->put(symtable, &key, &data, /*flags*/0) !=0) {
+		perror("Symtable put failed");
+		exit(EX_SOFTWARE);
+	}
 	return (stored_ptr);
 }
 
@@ -256,7 +263,7 @@ symlist_add(symlist_t *symlist, symbol_t *symbol, int how)
 		    && (curnode->symbol->info.finfo->value >
 			newnode->symbol->info.finfo->value))))
 		 || (!field && (curnode->symbol->info.rinfo->address >
-		               newnode->symbol->info.rinfo->address))) {
+				newnode->symbol->info.rinfo->address))) {
 			SLIST_INSERT_HEAD(symlist, newnode, links);
 			return;
 		}
@@ -271,7 +278,7 @@ symlist_add(symlist_t *symlist, symbol_t *symbol, int how)
 
 				cursymbol = SLIST_NEXT(curnode, links)->symbol;
 				if ((field
-		  		  && (cursymbol->type > symbol->type
+				  && (cursymbol->type > symbol->type
 				   || (cursymbol->type == symbol->type
 				    && (cursymbol->info.finfo->value >
 					symbol->info.finfo->value))))
@@ -351,7 +358,7 @@ aic_print_reg_dump_types(FILE *ofile)
 {
 	if (ofile == NULL)
 		return;
-		
+
 	fprintf(ofile,
 "typedef int (%sreg_print_t)(u_int, u_int *, u_int);\n"
 "typedef struct %sreg_parse_entry {\n"
@@ -370,7 +377,7 @@ aic_print_reg_dump_start(FILE *dfile, symbol_node_t *regnode)
 		return;
 
 	fprintf(dfile,
-"static %sreg_parse_entry_t %s_parse_table[] = {\n",
+"static const %sreg_parse_entry_t %s_parse_table[] = {\n",
 		prefix,
 		regnode->symbol->name);
 }
@@ -385,7 +392,7 @@ aic_print_reg_dump_end(FILE *ofile, FILE *dfile,
 	lower_name = strdup(regnode->symbol->name);
 	if (lower_name == NULL)
 		 stop("Unable to strdup symbol name", EX_SOFTWARE);
-	
+
 	for (letter = lower_name; *letter != '\0'; letter++)
 		*letter = tolower(*letter);
 
@@ -472,6 +479,7 @@ symtable_dump(FILE *ofile, FILE *dfile)
 	DBT		 key;
 	DBT		 data;
 	int		 flag;
+	int		 reg_count = 0, reg_used = 0;
 	u_int		 i;
 
 	if (symtable == NULL)
@@ -541,6 +549,9 @@ symtable_dump(FILE *ofile, FILE *dfile)
 			int		 num_entries;
 
 			num_entries = 0;
+			reg_count++;
+			if (curnode->symbol->count == 1)
+				break;
 			fields = &curnode->symbol->info.rinfo->fields;
 			SLIST_FOREACH(fieldnode, fields, links) {
 				if (num_entries == 0)
@@ -553,11 +564,14 @@ symtable_dump(FILE *ofile, FILE *dfile)
 			}
 			aic_print_reg_dump_end(ofile, dfile,
 					       curnode, num_entries);
+			reg_used++;
 		}
 		default:
 			break;
 		}
 	}
+	fprintf(stderr, "%s: %d of %d register definitions used\n", appname,
+		reg_used, reg_count);
 
 	/* Fold in the masks and bits */
 	while (SLIST_FIRST(&masks) != NULL) {
@@ -646,7 +660,6 @@ symtable_dump(FILE *ofile, FILE *dfile)
 		free(curnode);
 	}
 
-	
 	fprintf(ofile, "\n\n/* Downloaded Constant Definitions */\n");
 
 	for (i = 0; SLIST_FIRST(&download_constants) != NULL; i++) {
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
index afc22e8..05190c1 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -128,6 +128,7 @@ typedef struct expression_info {
 typedef struct symbol {
 	char	*name;
 	symtype	type;
+	int	count;
 	union	{
 		struct reg_info	  *rinfo;
 		struct field_info *finfo;

--------------080209060409090007000204--
