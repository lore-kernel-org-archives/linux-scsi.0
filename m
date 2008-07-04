From: akpm@linux-foundation.org
Subject: [patch 01/16] aic7xxx: introduce "dont_generate_debug_code" keyword in aicasm parser
Date: Thu, 03 Jul 2008 23:47:22 -0700
Message-ID: <200807040647.m646lMNc017469@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYGDGr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:47:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, vda.linux@googlemail.com, James.Bottomley@HansenPartnership.com, hare@suse.de

From: Denys Vlasenko <vda.linux@googlemail.com>

aic7xxx still contains ~30kb of dead code if pretty printing of registers
is requested. These patches deal with it.

Size differences:

   text    data     bss     dec     hex filename
DEBUG_ENABLE+PRETTY_PRINT:
 234697    2362    1188  238247   3a2a7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 205092    2362    1188  208642   32f02 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+PRETTY_PRINT:
 227272    2362    1172  230806   38596 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 197671    2362    1172  201205   311f5 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
DEBUG_ENABLE+NO_PRETTY_PRINT:
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+NO_PRETTY_PRINT:
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o


This patch:

Introduce "dont_generate_debug_code" keyword in aicasm parser.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y   |   10 ++++++++++
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l   |    1 +
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c |    3 +++
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h |    3 ++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_gram.y~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -147,6 +147,8 @@ void yyerror(const char *string);
 
 %token T_ACCESS_MODE
 
+%token T_DONT_GENERATE_DEBUG_CODE
+
 %token T_MODES
 
 %token T_DEFINE
@@ -357,6 +359,7 @@ reg_attribute:
 |	size
 |	count
 |	access_mode
+|	dont_generate_debug_code
 |	modes
 |	field_defn
 |	enum_defn
@@ -410,6 +413,13 @@ access_mode:
 	}
 ;
 
+dont_generate_debug_code:
+	T_DONT_GENERATE_DEBUG_CODE
+	{
+		cur_symbol->dont_generate_debug_code = 1;
+	}
+;
+
 modes:
 	T_MODES mode_list
 	{
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_scan.l~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -164,6 +164,7 @@ download		{ return T_DOWNLOAD; }
 address			{ return T_ADDRESS; }
 count			{ return T_COUNT; }
 access_mode		{ return T_ACCESS_MODE; }
+dont_generate_debug_code { return T_DONT_GENERATE_DEBUG_CODE; }
 modes			{ return T_MODES; }
 RW|RO|WO		{
 				 if (strcmp(yytext, "RW") == 0)
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -539,6 +539,9 @@ symtable_dump(FILE *ofile, FILE *dfile)
 	aic_print_include(dfile, stock_include_file);
 	SLIST_FOREACH(curnode, &registers, links) {
 
+		if (curnode->symbol->dont_generate_debug_code)
+			continue;
+
 		switch(curnode->symbol->type) {
 		case REGISTER:
 		case SCBLOC:
diff -puN drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h~aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser
+++ a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -137,7 +137,8 @@ typedef struct symbol {
 		struct label_info *linfo;
 		struct cond_info  *condinfo;
 		struct macro_info *macroinfo;
-	}info;
+	} info;
+	int	dont_generate_debug_code;
 } symbol_t;
 
 typedef struct symbol_ref {
_
