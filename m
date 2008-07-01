From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 1/3] aic7xxx: introduce "dont_generate_debug_code" keyword in aicasm parser
Date: Tue, 1 Jul 2008 18:50:36 +0200
Message-ID: <200807011850.36107.vda.linux@googlemail.com>
References: <200807011848.22599.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:46479 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbYGAOuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 10:50:22 -0400
Received: by gv-out-0910.google.com with SMTP id e6so262138gvc.37
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2008 07:50:21 -0700 (PDT)
In-Reply-To: <200807011848.22599.vda.linux@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Introduce "dont_generate_debug_code" keyword in aicasm parser.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--- linux-2.6.26-rc8.org/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	Tue Jul  1 17:07:14 2008
+++ linux-2.6.26-rc8/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	Tue Jul  1 17:06:58 2008
@@ -147,6 +147,8 @@
 
 %token T_ACCESS_MODE
 
+%token T_DONT_GENERATE_DEBUG_CODE
+
 %token T_MODES
 
 %token T_DEFINE
@@ -357,6 +359,7 @@
 |	size
 |	count
 |	access_mode
+|	dont_generate_debug_code
 |	modes
 |	field_defn
 |	enum_defn
@@ -407,6 +410,13 @@
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
 
--- linux-2.6.26-rc8.org/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l	Tue Jul  1 17:07:14 2008
+++ linux-2.6.26-rc8/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l	Tue Jul  1 17:06:58 2008
@@ -164,6 +164,7 @@
 address			{ return T_ADDRESS; }
 count			{ return T_COUNT; }
 access_mode		{ return T_ACCESS_MODE; }
+dont_generate_debug_code { return T_DONT_GENERATE_DEBUG_CODE; }
 modes			{ return T_MODES; }
 RW|RO|WO		{
 				 if (strcmp(yytext, "RW") == 0)
--- linux-2.6.26-rc8.org/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c	Tue Jul  1 17:07:14 2008
+++ linux-2.6.26-rc8/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c	Tue Jul  1 17:06:58 2008
@@ -539,6 +539,9 @@
 	aic_print_include(dfile, stock_include_file);
 	SLIST_FOREACH(curnode, &registers, links) {
 
+		if (curnode->symbol->dont_generate_debug_code)
+			continue;
+
 		switch(curnode->symbol->type) {
 		case REGISTER:
 		case SCBLOC:
--- linux-2.6.26-rc8.org/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h	Tue Jul  1 17:07:14 2008
+++ linux-2.6.26-rc8/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h	Tue Jul  1 17:06:58 2008
@@ -137,7 +137,8 @@
 		struct label_info *linfo;
 		struct cond_info  *condinfo;
 		struct macro_info *macroinfo;
-	}info;
+	} info;
+	int	dont_generate_debug_code;
 } symbol_t;
 
 typedef struct symbol_ref {
