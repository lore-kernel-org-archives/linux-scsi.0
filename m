From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH RESEND] aic7xxx: Add a better library-dependency
 description when libdb is needed
Date: Fri, 12 Nov 2010 13:14:45 -0300
Message-ID: <1289578485.2298.0.camel@cowboy>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:41932 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753410Ab0KLQOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 11:14:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

From: Davidlohr Bueso <dave@gnu.org>

While recently building aicasm_symbol.c it failed because I didn't have the berkeley libdb, so no aicdb.h file was created. With this patch I wouldn't have had to gone to google to see what "development library" it was referring to.
make -C drivers/scsi/aic7xxx/aicasm
*** Install db development libraries
bison -d -b aicasm_gram aicasm_gram.y
mv aicasm_gram.tab.c aicasm_gram.c
mv aicasm_gram.tab.h aicasm_gram.h
bison -d -b aicasm_macro_gram -p mm aicasm_macro_gram.y
mv aicasm_macro_gram.tab.c aicasm_macro_gram.c
mv aicasm_macro_gram.tab.h aicasm_macro_gram.h
flex  -oaicasm_scan.c aicasm_scan.l
flex  -Pmm -oaicasm_macro_scan.c aicasm_macro_scan.l
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_symbol.c:48: fatal error: aicdb.h: No such file or directory
compilation terminated.
make[4]: *** [aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [drivers/scsi/aic7xxx] Error 2

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/aic7xxx/aicasm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index b98c5c1..b399d46 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -49,7 +49,7 @@ aicdb.h:
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
 		echo "#include <db_185.h>" > aicdb.h;		\
 	 else							\
-		echo "*** Install db development libraries";	\
+		echo "*** Install Berkeley DB (libdb) development libraries";	\
 	 fi
 
 clean:
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



