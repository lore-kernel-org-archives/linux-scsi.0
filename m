From: Omkhar Arasaratnam <iamroot@ca.ibm.com>
Subject: [ERROR] 2.6.1 drivers/scsi/aic7xxx/aicasm fails with allmodconfig
Date: Tue, 20 Jan 2004 13:10:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074622248.6831.86.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:25252 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265641AbUATSLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 13:11:03 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0KIB2vM759506
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2004 13:11:02 -0500
Received: from www.bldcgw01.boulder.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0KIB0oY200250
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2004 13:11:01 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Seems this module fails - anyone else seeing this? 

omkhar linux-clean # make allmodconfig; make
<...snip...>
  LD [M]  drivers/scsi/aacraid/aacraid.o
  LD      drivers/scsi/aic7xxx/built-in.o
make -C drivers/scsi/aic7xxx/aicasm
yacc -d -b aicasm_gram aicasm_gram.y
mv aicasm_gram.tab.c aicasm_gram.c
mv aicasm_gram.tab.h aicasm_gram.h
yacc -d -b aicasm_macro_gram -p mm aicasm_macro_gram.y
mv aicasm_macro_gram.tab.c aicasm_macro_gram.c
mv aicasm_macro_gram.tab.h aicasm_macro_gram.h
lex  -oaicasm_scan.c aicasm_scan.l
lex  -Pmm -oaicasm_macro_scan.c aicasm_macro_scan.l
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
/tmp/cc3HQvfD.o(.text+0x1d0): In function `symtable_open':
: undefined reference to `__db185_open'
collect2: ld returned 1 exit status
make[4]: *** [aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

-- 
Omkhar

