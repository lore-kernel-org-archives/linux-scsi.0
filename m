From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aic7xxx: Update type check in aicasm grammar
Date: Tue, 08 Apr 2008 15:09:23 +0200
Message-ID: <47FB6E83.5050403@suse.de>
References: <47FB64A1.7010000@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040907010504090502060604"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYDHNJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2008 09:09:25 -0400
In-Reply-To: <47FB64A1.7010000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040907010504090502060604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

And this time with patch.

Grmbl.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------040907010504090502060604
Content-Type: text/plain;
 name="aic7xxx-fix-type_check-in-aicasm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-fix-type_check-in-aicasm"

commit b2ff705006a37b87368085624b88cbd987e9edb6
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Apr 8 13:34:15 2008 +0200

    aic7xxx: Update type check in aicasm grammar
    
    The function type_check() in aicasm was never be used properly;
    fix it up and only call it when appropriate.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 702e2db..e292520 100644
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
@@ -1357,6 +1358,7 @@ code:
 code:
 	T_OR reg_symbol ',' immediate jmp_jc_jnc_call address ';'
 	{
+		type_check(&$2, &$4, AIC_OP_OR);
 		format_3_instr($5, &$2, &$4, &$6);
 	}
 ;
@@ -1528,7 +1530,7 @@ initialize_symbol(symbol_t *symbol)
 		       sizeof(struct cond_info));
 		break;
 	case MACRO:
-		symbol->info.macroinfo = 
+		symbol->info.macroinfo =
 		    (struct macro_info *)malloc(sizeof(struct macro_info));
 		if (symbol->info.macroinfo == NULL) {
 			stop("Can't create macro info", EX_SOFTWARE);
@@ -1552,7 +1554,6 @@ add_macro_arg(const char *argtext, int argnum)
 	struct macro_arg *marg;
 	int i;
 	int retval;
-		
 
 	if (cur_symbol == NULL || cur_symbol->type != MACRO) {
 		stop("Invalid current symbol for adding macro arg",
@@ -1633,8 +1634,10 @@ format_1_instr(int opcode, symbol_ref_t *dest, expression_t *immed,
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
@@ -1766,9 +1769,6 @@ format_3_instr(int opcode, symbol_ref_t *src,
 	/* Test register permissions */
 	test_readable_symbol(src->symbol);
 
-	/* Ensure that immediate makes sense for this source */
-	type_check(src->symbol, immed, opcode);
-
 	/* Allocate sequencer space for the instruction and fill it out */
 	instr = seq_alloc();
 	f3_instr = &instr->format.format3;
@@ -1797,7 +1797,6 @@ format_3_instr(int opcode, symbol_ref_t *src,
 static void
 test_readable_symbol(symbol_t *symbol)
 {
-	
 	if ((symbol->info.rinfo->modes & (0x1 << src_mode)) == 0) {
 		snprintf(errbuf, sizeof(errbuf),
 			"Register %s unavailable in source reg mode %d",
@@ -1815,7 +1814,6 @@ test_readable_symbol(symbol_t *symbol)
 static void
 test_writable_symbol(symbol_t *symbol)
 {
-	
 	if ((symbol->info.rinfo->modes & (0x1 << dst_mode)) == 0) {
 		snprintf(errbuf, sizeof(errbuf),
 			"Register %s unavailable in destination reg mode %d",
@@ -1831,25 +1829,34 @@ test_writable_symbol(symbol_t *symbol)
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
@@ -1959,3 +1966,13 @@ is_download_const(expression_t *immed)
 
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

--------------040907010504090502060604--
