From: "Tom 'spot' Callaway" <tcallawa@redhat.com>
Subject: [PATCH] Build mptspi.c on architectures where CONFIG_PM is unset
Date: Sat, 03 Jun 2006 09:36:47 -0500
Message-ID: <1149345407.14611.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57759 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1030306AbWFCOgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2006 10:36:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
Cc: davem@davemloft.net

When trying to build mpt* for sparc64 (my T2000 needs mptsas and
friends), I noticed that mptspi.o was not building:

  CC [M]  drivers/message/fusion/mptspi.o
drivers/message/fusion/mptspi.c: In function `mptspi_resume':
drivers/message/fusion/mptspi.c:844: error: implicit declaration of
function `mptscsih_resume'
drivers/message/fusion/mptspi.c: At top level:
drivers/message/fusion/mptspi.c:839: warning: 'mptspi_resume' defined
but not used
make[3]: *** [drivers/message/fusion/mptspi.o] Error 1
make[2]: *** [drivers/message/fusion] Error 2
make[1]: *** [drivers/message] Error 2

sparc64 does not have CONFIG_PM defined, and mptscsih_resume is wrapped
in an #ifdef CONFIG_PM in mptscsih.h. mptscsih_resume is only used in
the mptspi_resume function in mptspi.c, and its only call is in the
pci_driver struct (and that call is also #ifdef CONFIG_PM). In order to
get the code to compile, I just needed to wrap the actual function in
#ifdef CONFIG_PM, which is what this patch does. I can confirm that it
gets the module building again without errors.

Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>

--- linux-2.6.16-sparc64/drivers/message/fusion/mptspi.c.BAD
+++ linux-2.6.16-sparc64/drivers/message/fusion/mptspi.c
@@ -831,6 +831,7 @@
 	return rc;
 }
 
+#ifdef CONFIG_PM
 /*
  * spi module resume handler
  */
@@ -846,6 +847,7 @@
 
 	return rc;
 }
+#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/

~spot
-- 
Tom "spot" Callaway: Red Hat Senior Sales Engineer || GPG ID: 93054260
Fedora Extras Steering Committee Member (RPM Standards and Practices)
Aurora Linux Project Leader: http://auroralinux.org
Lemurs, llamas, and sparcs, oh my!

