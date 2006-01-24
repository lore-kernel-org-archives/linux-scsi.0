From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] Update aicasm
Date: Tue, 24 Jan 2006 10:41:45 +0100
Message-ID: <43D5F659.2080600@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010608010004090504080700"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:43967 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030397AbWAXJlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:41:47 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id EEBB2EB42
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 10:41:45 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010608010004090504080700
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patchset updates aicasm code with the latest fixes from adaptec.

--------------010608010004090504080700
Content-Type: text/plain;
 name="0001-aic7xxx-update-aicasm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-aic7xxx-update-aicasm"

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#22 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#23 $
  *
  * $FreeBSD$
  */
@@ -609,10 +609,10 @@ output_listing(char *ifilename)
 
 		while (line < cur_instr->srcline) {
 			fgets(buf, sizeof(buf), ifile);
-				fprintf(listfile, "\t\t%s", buf);
+				fprintf(listfile, "             \t%s", buf);
 				line++;
 		}
-		fprintf(listfile, "%03x %02x%02x%02x%02x", instrptr,
+		fprintf(listfile, "%04x %02x%02x%02x%02x", instrptr,
 #ifdef __LITTLE_ENDIAN
 			cur_instr->format.bytes[0],
 			cur_instr->format.bytes[1],
@@ -624,14 +624,23 @@ output_listing(char *ifilename)
 			cur_instr->format.bytes[1],
 			cur_instr->format.bytes[0]);
 #endif
-		fgets(buf, sizeof(buf), ifile);
-		fprintf(listfile, "\t%s", buf);
-		line++;
+		/*
+		 * Macro expansions can cause several instructions
+		 * to be output for a single source line.  Only
+		 * advance the line once in these cases.
+		 */
+		if (line == cur_instr->srcline) {
+			fgets(buf, sizeof(buf), ifile);
+			fprintf(listfile, "\t%s", buf);
+			line++;
+		} else {
+			fprintf(listfile, "\n");
+		}
 		instrptr++;
 	}
 	/* Dump the remainder of the file */
 	while(fgets(buf, sizeof(buf), ifile) != NULL)
-		fprintf(listfile, "\t\t%s", buf);
+		fprintf(listfile, "             %s", buf);
 
 	fclose(ifile);
 }
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#29 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#30 $
  *
  * $FreeBSD$
  */
@@ -157,6 +157,8 @@ static int  is_download_const(expression
 
 %token T_END_CS
 
+%token T_PAD_PAGE
+
 %token T_FIELD
 
 %token T_ENUM
@@ -189,6 +191,10 @@ static int  is_download_const(expression
 
 %token <value> T_OR
 
+/* 16 bit extensions */
+%token <value> T_OR16 T_AND16 T_XOR16 T_ADD16
+%token <value> T_ADC16 T_MVI16 T_TEST16 T_CMP16 T_CMPXCHG
+
 %token T_RET
 
 %token T_NOP
@@ -207,7 +213,7 @@ static int  is_download_const(expression
 
 %type <expression> expression immediate immediate_or_a
 
-%type <value> export ret f1_opcode f2_opcode jmp_jc_jnc_call jz_jnz je_jne
+%type <value> export ret f1_opcode f2_opcode f4_opcode jmp_jc_jnc_call jz_jnz je_jne
 
 %type <value> mode_value mode_list macro_arglist
 
@@ -1304,6 +1310,15 @@ f2_opcode:
 |	T_ROR { $$ = AIC_OP_ROR; }
 ;
 
+f4_opcode:
+	T_OR16	{ $$ = AIC_OP_OR16; }
+|	T_AND16 { $$ = AIC_OP_AND16; }
+|	T_XOR16 { $$ = AIC_OP_XOR16; }
+|	T_ADD16 { $$ = AIC_OP_ADD16; }
+|	T_ADC16 { $$ = AIC_OP_ADC16; }
+|	T_MVI16 { $$ = AIC_OP_MVI16; }
+;
+
 code:
 	f2_opcode destination ',' expression opt_source ret ';'
 	{
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
@@ -37,13 +37,14 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#11 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#12 $
  *
  * $FreeBSD$
  */
 
 #include <asm/byteorder.h>
 
+/* 8bit ALU logic operations */
 struct ins_format1 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
@@ -62,6 +63,7 @@ struct ins_format1 {
 #endif
 };
 
+/* 8bit ALU shift/rotate operations */
 struct ins_format2 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	shift_control	: 8,
@@ -80,6 +82,7 @@ struct ins_format2 {
 #endif
 };
 
+/* 8bit branch control operations */
 struct ins_format3 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
@@ -96,10 +99,68 @@ struct ins_format3 {
 #endif
 };
 
+/* 16bit ALU logic operations */
+struct ins_format4 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			destination	: 9,
+			ret		: 1,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			ret		: 1,
+			destination	: 9,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/* 16bit branch control operations */
+struct ins_format5 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/*  Far branch operations */
+struct ins_format6 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	page		: 3,
+			opcode_ext	: 5,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 5,
+			page		: 3;
+#endif
+};
+
 union ins_formats {
 		struct ins_format1 format1;
 		struct ins_format2 format2;
 		struct ins_format3 format3;
+		struct ins_format4 format4;
+		struct ins_format5 format5;
+		struct ins_format6 format6;
 		uint8_t		   bytes[4];
 		uint32_t	   integer;
 };
@@ -118,6 +179,8 @@ struct instruction {
 #define	AIC_OP_ROL	0x5
 #define	AIC_OP_BMOV	0x6
 
+#define	AIC_OP_MVI16	0x7
+
 #define	AIC_OP_JMP	0x8
 #define AIC_OP_JC	0x9
 #define AIC_OP_JNC	0xa
@@ -131,3 +194,26 @@ struct instruction {
 #define	AIC_OP_SHL	0x10
 #define	AIC_OP_SHR	0x20
 #define	AIC_OP_ROR	0x30
+
+/* 16bit Ops. Low byte main opcode.  High byte extended opcode. */ 
+#define	AIC_OP_OR16	0x8005
+#define	AIC_OP_AND16	0x8105
+#define	AIC_OP_XOR16	0x8205
+#define	AIC_OP_ADD16	0x8305
+#define	AIC_OP_ADC16	0x8405
+#define AIC_OP_JNE16	0x8805
+#define AIC_OP_JNZ16	0x8905
+#define AIC_OP_JE16	0x8C05
+#define AIC_OP_JZ16	0x8B05
+#define AIC_OP_JMP16	0x9005
+#define AIC_OP_JC16	0x9105
+#define AIC_OP_JNC16	0x9205
+#define AIC_OP_CALL16	0x9305
+#define AIC_OP_CALL16	0x9305
+
+/* Page extension is low three bits of second opcode byte. */
+#define AIC_OP_JMPF	0xA005
+#define AIC_OP_CALLF	0xB005
+#define AIC_OP_JCF	0xC005
+#define AIC_OP_JNCF	0xD005
+#define AIC_OP_CMPXCHG	0xE005
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#19 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#20 $
  *
  * $FreeBSD$
  */
@@ -132,7 +132,7 @@ if[ \t]*\(		{
 						*string_buf_ptr++ = *yptr++;
 				}
 			}
-
+else			{ return T_ELSE; }
 VERSION			{ return T_VERSION; }
 PREFIX			{ return T_PREFIX; }
 PATCH_ARG_LIST		{ return T_PATCH_ARG_LIST; }
@@ -173,10 +173,6 @@ RW|RO|WO		{
 					yylval.value = WO;
 				 return T_MODE;
 			}
-BEGIN_CRITICAL		{ return T_BEGIN_CS; }
-END_CRITICAL		{ return T_END_CS; }
-SET_SRC_MODE		{ return T_SET_SRC_MODE; }
-SET_DST_MODE		{ return T_SET_DST_MODE; }
 field			{ return T_FIELD; }
 enum			{ return T_ENUM; }
 mask			{ return T_MASK; }
@@ -192,6 +188,13 @@ none			{ return T_NONE; }
 sindex			{ return T_SINDEX; }
 A			{ return T_A; }
 
+	/* Instruction Formatting */
+PAD_PAGE		{ return T_PAD_PAGE; }
+BEGIN_CRITICAL		{ return T_BEGIN_CS; }
+END_CRITICAL		{ return T_END_CS; }
+SET_SRC_MODE		{ return T_SET_SRC_MODE; }
+SET_DST_MODE		{ return T_SET_DST_MODE; }
+
 	/* Opcodes */
 shl			{ return T_SHL; }
 shr			{ return T_SHR; }
@@ -223,7 +226,17 @@ and			{ return T_AND;	}
 or			{ return T_OR;	}
 ret			{ return T_RET; }
 nop			{ return T_NOP; }
-else			{ return T_ELSE; }
+
+	/* ARP2 16bit extensions */
+or16			{ return T_OR16; }
+and16			{ return T_AND16; }
+xor16			{ return T_XOR16; }
+add16			{ return T_ADD16; }
+adc16			{ return T_ADC16; }
+mvi16			{ return T_MVI16; }
+test16			{ return T_TEST16; }
+cmp16			{ return T_CMP16; }
+cmpxchg			{ return T_CMPXCHG; }
 
 	/* Allowed Symbols */
 \<\<			{ return T_EXPR_LSHIFT; }

--------------010608010004090504080700--
