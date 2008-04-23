From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup aic7xxx firmware build
Date: Wed, 23 Apr 2008 11:39:49 +0200
Message-ID: <480F03E5.9050000@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020409090004080706080103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYDWJjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 05:39:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020409090004080706080103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi James,

the last aicasm fix uncovered a flaw in the aicasm code,
ie the range checking in type_check() was never called
properly.
This patch fixes this up and also disables the unused
16bit instruction.

This is actually a resend of an earlier patch, which
appearently got lost somehow.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------020409090004080706080103
Content-Type: text/plain;
 name="aic7xxx-fix-type_check-in-aicasm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-fix-type_check-in-aicasm"

aic7xxx: Update type check in aicasm grammar
    
The function type_check() in aicasm grammar code was
never used properly due to a bug.
This patch fixes it up and ensures it's only called if appropriate.

In addition the unused 16bit instruction are disabled, but left in
the code for reference.
    
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 702e2db..5a8bfc9 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -101,11 +101,12 @@ static void format_3_instr(int opcode, symbol_ref_t *src,
 			   expression_t *immed, symbol_ref_t *address);
 static void test_readable_symbol(symbol_t *symbol);
 static void test_writable_symbol(symbol_t *symbol);
-static void type_check(symbol_t *symbol, expression_t *expression, int and_op);
+static void type_check(symbol_ref_t *sym, expression_t *expression, int and_op);
 static void make_expression(expression_t *immed, int value);
 static void add_conditional(symbol_t *symbol);
 static void add_version(const char *verstring);
 static int  is_download_const(expression_t *immed);
+static int  is_location_address(symbol_t *symbol);
 void yyerror(const char *string);
 
 #define SRAM_SYMNAME "SRAM_BASE"
@@ -192,10 +193,10 @@ void yyerror(const char *string);
 
 %token <value> T_OR
 
-/* 16 bit extensions */
-%token <value> T_OR16 T_AND16 T_XOR16 T_ADD16
-%token <value> T_ADC16 T_MVI16 T_TEST16 T_CMP16 T_CMPXCHG
-
+/* 16 bit extensions, not implemented 
+ * %token <value> T_OR16 T_AND16 T_XOR16 T_ADD16
+ * %token <value> T_ADC16 T_MVI16 T_TEST16 T_CMP16 T_CMPXCHG
+ */
 %token T_RET
 
 %token T_NOP
@@ -214,7 +215,7 @@ void yyerror(const char *string);
 
 %type <expression> expression immediate immediate_or_a
 
-%type <value> export ret f1_opcode f2_opcode f4_opcode jmp_jc_jnc_call jz_jnz je_jne
+%type <value> export ret f1_opcode f2_opcode jmp_jc_jnc_call jz_jnz je_jne
 
 %type <value> mode_value mode_list macro_arglist
 
@@ -313,13 +314,13 @@ reg_definition:
 				stop("Register multiply defined", EX_DATAERR);
 				/* NOTREACHED */
 			}
-			cur_symbol = $1; 
+			cur_symbol = $1;
 			cur_symbol->type = cur_symtype;
 			initialize_symbol(cur_symbol);
 		}
 		reg_attribute_list
 	'}'
-		{                    
+		{
 			/*
 			 * Default to allowing everything in for registers
 			 * with no bit or mask definitions.
@@ -349,7 +350,7 @@ reg_attribute_list:
 |	reg_attribute_list reg_attribute
 ;
 
-reg_attribute:		
+reg_attribute:
 	reg_address
 |	size
 |	access_mode
@@ -641,14 +642,14 @@ expression:
 			       &($1.referenced_syms),
 			       &($3.referenced_syms));
 	}
-| 	expression T_EXPR_LSHIFT expression
+|	expression T_EXPR_LSHIFT expression
 	{
 		$$.value = $1.value << $3.value;
 		symlist_merge(&$$.referenced_syms,
 			       &$1.referenced_syms,
 			       &$3.referenced_syms);
 	}
-| 	expression T_EXPR_RSHIFT expression
+|	expression T_EXPR_RSHIFT expression
 	{
 		$$.value = $1.value >> $3.value;
 		symlist_merge(&$$.referenced_syms,
@@ -714,7 +715,7 @@ expression:
 ;
 
 constant:
-	T_CONST T_SYMBOL expression 
+	T_CONST T_SYMBOL expression
 	{
 		if ($2->type != UNINITIALIZED) {
 			stop("Re-definition of symbol as a constant",
@@ -1311,14 +1312,18 @@ f2_opcode:
 |	T_ROR { $$ = AIC_OP_ROR; }
 ;
 
-f4_opcode:
-	T_OR16	{ $$ = AIC_OP_OR16; }
-|	T_AND16 { $$ = AIC_OP_AND16; }
-|	T_XOR16 { $$ = AIC_OP_XOR16; }
-|	T_ADD16 { $$ = AIC_OP_ADD16; }
-|	T_ADC16 { $$ = AIC_OP_ADC16; }
-|	T_MVI16 { $$ = AIC_OP_MVI16; }
-;
+/*
+ * 16bit opcodes, not used
+ *
+ *f4_opcode:
+ *	T_OR16	{ $$ = AIC_OP_OR16; }
+ *|	T_AND16 { $$ = AIC_OP_AND16; }
+ *|	T_XOR16 { $$ = AIC_OP_XOR16; }
+ *|	T_ADD16 { $$ = AIC_OP_ADD16; }
+ *|	T_ADC16 { $$ = AIC_OP_ADC16; }
+ *|	T_MVI16 { $$ = AIC_OP_MVI16; }
+ *;
+ */
 
 code:
 	f2_opcode destination ',' expression opt_source ret ';'
@@ -1357,6 +1362,7 @@ code:
 code:
 	T_OR reg_symbol ',' immediate jmp_jc_jnc_call address ';'
 	{
+		type_check(&$2, &$4, AIC_OP_OR);
 		format_3_instr($5, &$2, &$4, &$6);
 	}
 ;
@@ -1528,7 +1534,7 @@ initialize_symbol(symbol_t *symbol)
 		       sizeof(struct cond_info));
 		break;
 	case MACRO:
-		symbol->info.macroinfo = 
+		symbol->info.macroinfo =
 		    (struct macro_info *)malloc(sizeof(struct macro_info));
 		if (symbol->info.macroinfo == NULL) {
 			stop("Can't create macro info", EX_SOFTWARE);
@@ -1552,7 +1558,6 @@ add_macro_arg(const char *argtext, int argnum)
 	struct macro_arg *marg;
 	int i;
 	int retval;
-		
 
 	if (cur_symbol == NULL || cur_symbol->type != MACRO) {
 		stop("Invalid current symbol for adding macro arg",
@@ -1633,8 +1638,10 @@ format_1_instr(int opcode, symbol_ref_t *dest, expression_t *immed,
 	test_writable_symbol(dest->symbol);
 	test_readable_symbol(src->symbol);
 
-	/* Ensure that immediate makes sense for this destination */
-	type_check(dest->symbol, immed, opcode);
+	if (!is_location_address(dest->symbol)) {
+		/* Ensure that immediate makes sense for this destination */
+		type_check(dest, immed, opcode);
+	}
 
 	/* Allocate sequencer space for the instruction and fill it out */
 	instr = seq_alloc();
@@ -1766,9 +1773,6 @@ format_3_instr(int opcode, symbol_ref_t *src,
 	/* Test register permissions */
 	test_readable_symbol(src->symbol);
 
-	/* Ensure that immediate makes sense for this source */
-	type_check(src->symbol, immed, opcode);
-
 	/* Allocate sequencer space for the instruction and fill it out */
 	instr = seq_alloc();
 	f3_instr = &instr->format.format3;
@@ -1797,7 +1801,6 @@ format_3_instr(int opcode, symbol_ref_t *src,
 static void
 test_readable_symbol(symbol_t *symbol)
 {
-	
 	if ((symbol->info.rinfo->modes & (0x1 << src_mode)) == 0) {
 		snprintf(errbuf, sizeof(errbuf),
 			"Register %s unavailable in source reg mode %d",
@@ -1815,7 +1818,6 @@ test_readable_symbol(symbol_t *symbol)
 static void
 test_writable_symbol(symbol_t *symbol)
 {
-	
 	if ((symbol->info.rinfo->modes & (0x1 << dst_mode)) == 0) {
 		snprintf(errbuf, sizeof(errbuf),
 			"Register %s unavailable in destination reg mode %d",
@@ -1831,25 +1833,34 @@ test_writable_symbol(symbol_t *symbol)
 }
 
 static void
-type_check(symbol_t *symbol, expression_t *expression, int opcode)
+type_check(symbol_ref_t *sym, expression_t *expression, int opcode)
 {
+	symbol_t *symbol = sym->symbol;
 	symbol_node_t *node;
 	int and_op;
+	int8_t value, mask;
 
 	and_op = FALSE;
-	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || opcode == AIC_OP_JZ)
-		and_op = TRUE;
-
 	/*
 	 * Make sure that we aren't attempting to write something
 	 * that hasn't been defined.  If this is an and operation,
 	 * this is a mask, so "undefined" bits are okay.
 	 */
-	if (and_op == FALSE
-	 && (expression->value & ~symbol->info.rinfo->valid_bitmask) != 0) {
+	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ ||
+	    opcode == AIC_OP_JZ  || opcode == AIC_OP_JNE ||
+	    opcode == AIC_OP_BMOV)
+		and_op = TRUE;
+
+	/*
+	 * Defaulting to 8 bit logic
+	 */
+	mask = (int8_t)~symbol->info.rinfo->valid_bitmask;
+	value = (int8_t)expression->value;
+
+	if (and_op == FALSE && (mask & value) != 0 ) {
 		snprintf(errbuf, sizeof(errbuf),
 			 "Invalid bit(s) 0x%x in immediate written to %s",
-			 expression->value & ~symbol->info.rinfo->valid_bitmask,
+			 (mask & value),
 			 symbol->name);
 		stop(errbuf, EX_DATAERR);
 		/* NOTREACHED */
@@ -1959,3 +1970,13 @@ is_download_const(expression_t *immed)
 
 	return (FALSE);
 }
+
+static int
+is_location_address(symbol_t *sym)
+{
+	if (sym->type == SCBLOC ||
+	    sym->type == SRAMLOC)
+		return (TRUE);
+	return (FALSE);
+}
+
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index 7c3983f..62b6c1b 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -228,15 +228,15 @@ ret			{ return T_RET; }
 nop			{ return T_NOP; }
 
 	/* ARP2 16bit extensions */
-or16			{ return T_OR16; }
-and16			{ return T_AND16; }
-xor16			{ return T_XOR16; }
-add16			{ return T_ADD16; }
-adc16			{ return T_ADC16; }
-mvi16			{ return T_MVI16; }
-test16			{ return T_TEST16; }
-cmp16			{ return T_CMP16; }
-cmpxchg			{ return T_CMPXCHG; }
+	/* or16			{ return T_OR16; } */
+	/* and16			{ return T_AND16; }*/
+	/* xor16			{ return T_XOR16; }*/
+	/* add16			{ return T_ADD16; }*/
+	/* adc16			{ return T_ADC16; }*/
+	/* mvi16			{ return T_MVI16; }*/
+	/* test16			{ return T_TEST16; }*/
+	/* cmp16			{ return T_CMP16; }*/
+	/* cmpxchg			{ return T_CMPXCHG; }*/
 
 	/* Allowed Symbols */
 \<\<			{ return T_EXPR_LSHIFT; }

--------------020409090004080706080103--
