From: rct@gherkin.frus.com (Bob Tracy)
Subject: [BUG] aic7xxx/aicasm build failure w/gcc-3.4.6
Date: Tue, 17 Apr 2007 13:46:44 -0500 (CDT)
Message-ID: <20070417184644.A8A41DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:37527 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbXDQTIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2007 15:08:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(Sent to linux-kernel yesterday.  Forgot to "Cc:" here.)

This showed up during a 2.6.21-rc7 build after I upgraded gcc from 3.3
to 3.4 on a Slackware system:

make -C drivers/scsi/aic7xxx/aicasm
(...)
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_gram.y:1948: error: conflicting types for 'yyerror'
aicasm_gram.tab.c:3004: error: previous implicit declaration of 'yyerror' was here
aicasm_macro_gram.y:162: error: conflicting types for 'mmerror'
aicasm_macro_gram.tab.c:1196: error: previous implicit declaration of 'mmerror' was here

As a workaround, deleting the "void" declarations for yyerror() and
mmerror() in the respective ".y" files fixes the problem.  gcc-3.3
may have been warning about the type conflicts, but I didn't notice:
gcc-3.4 treats them as errors, so I *did* notice :-).

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
