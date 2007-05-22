From: rct@gherkin.frus.com (Bob Tracy)
Subject: [PATCH] aic7xxx/aicasm build failure w/gcc-3.4.6
Date: Tue, 22 May 2007 06:51:30 -0500 (CDT)
Message-ID: <20070522115130.9B959DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=ELM836723380-3472-0_
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:37538 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbXEVLvc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 07:51:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org


--ELM836723380-3472-0_
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII

Second try: originally reported this back on April 17th.  2.6.X
kernel builds started failing after I upgraded my compiler from
gcc-3.3.X to gcc-3.4.6:

make -C drivers/scsi/aic7xxx/aicasm
(...)
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_gram.y:1948: error: conflicting types for 'yyerror'
aicasm_gram.tab.c:3004: error: previous implicit declaration of 'yyerror' was here
aicasm_macro_gram.y:162: error: conflicting types for 'mmerror'
aicasm_macro_gram.tab.c:1196: error: previous implicit declaration of 'mmerror' was here

As a workaround, commenting out or deleting the "void" declarations
for yyerror() and mmerror() in the respective ".y" files fixes the
problem.  A patch to illustrate the offending code is attached, but
there's no "signed-off by" line because I'm certain the final form of
the patch will be different.  The patch applies cleanly to at least
2.6.21 and later kernels.  gcc-3.3 may have been warning about the
type conflicts, but I didn't notice: gcc-3.4 treats the type conflicts
as errors, so I *did* notice :-).

Here's the "gcc -v" output:

Reading specs from /usr/lib/gcc/i486-slackware-linux/3.4.6/specs
Configured with: ../gcc-3.4.6/configure --prefix=/usr --enable-shared --enable-threads=posix --enable-__cxa_atexit --disable-checking --with-gnu-ld --verbose --target=i486-slackware-linux --host=i486-slackware-linux
Thread model: posix
gcc version 3.4.6

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------

--ELM836723380-3472-0_
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: attachment; filename=patch22_aicasm

--- linux/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y.orig	2006-02-06 06:00:58.000000000 -0600
+++ linux/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	2007-04-16 12:31:08.000000000 -0500
@@ -1943,7 +1943,7 @@
 	versions[newlen + oldlen + 1] = '\0';
 }
 
-void
+/* void */
 yyerror(const char *string)
 {
 	stop(string, EX_DATAERR);
--- linux/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y.orig	2002-12-24 07:09:30.000000000 -0600
+++ linux/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y	2007-04-16 12:32:48.000000000 -0500
@@ -157,7 +157,7 @@
 	}
 }
 
-void
+/* void */
 mmerror(const char *string)
 {
 	stop(string, EX_DATAERR);

--ELM836723380-3472-0_--
