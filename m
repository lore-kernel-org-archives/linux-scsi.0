From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx/aicasm build failure w/gcc-3.4.6
Date: Tue, 22 May 2007 09:26:22 -0500
Message-ID: <1179843982.3738.5.camel@mulgrave.il.steeleye.com>
References: <20070522115130.9B959DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36890 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755383AbXEVO0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 10:26:25 -0400
In-Reply-To: <20070522115130.9B959DBA1@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2007-05-22 at 06:51 -0500, Bob Tracy wrote:
> Second try: originally reported this back on April 17th.  2.6.X
> kernel builds started failing after I upgraded my compiler from
> gcc-3.3.X to gcc-3.4.6:
> 
> make -C drivers/scsi/aic7xxx/aicasm
> (...)
> gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
> aicasm_gram.y:1948: error: conflicting types for 'yyerror'
> aicasm_gram.tab.c:3004: error: previous implicit declaration of 'yyerror' was here
> aicasm_macro_gram.y:162: error: conflicting types for 'mmerror'
> aicasm_macro_gram.tab.c:1196: error: previous implicit declaration of 'mmerror' was here
> 
> As a workaround, commenting out or deleting the "void" declarations
> for yyerror() and mmerror() in the respective ".y" files fixes the
> problem.

We really don't want gcc making assumptions about prototypes ... even if
it's getting them right in all likelihood (doubtless unprototyped
assumed functions will become a warning and then an error in later gcc
versions ...), so this is a better fix

James

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index c328596..6066998 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -106,6 +106,7 @@ static void make_expression(expression_t *immed, int value);
 static void add_conditional(symbol_t *symbol);
 static void add_version(const char *verstring);
 static int  is_download_const(expression_t *immed);
+void yyerror(const char *string);
 
 #define SRAM_SYMNAME "SRAM_BASE"
 #define SCB_SYMNAME "SCB_BASE"
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
index 439f760..ff46aa6 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
@@ -65,6 +65,7 @@
 static symbol_t *macro_symbol;
 
 static void add_macro_arg(const char *argtext, int position);
+void mmerror(const char *string);
 
 %}
 


