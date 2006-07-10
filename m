From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] include/scsi/libsas.h should #include <linux/scatterlist.h>
Date: Mon, 10 Jul 2006 20:33:02 +0200
Message-ID: <20060710183302.GE13938@stusta.de>
References: <20060709021106.9310d4d1.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:30473 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S965124AbWGJSdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 14:33:03 -0400
Content-Disposition: inline
In-Reply-To: <20060709021106.9310d4d1.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sun, Jul 09, 2006 at 02:11:06AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-mm6:
>...
>  git-sas.patch
>...
>  git trees
>...

This patch fixes the following compile error (on s390):

<--  snip  -->

...
  CC      drivers/scsi/sas/sas_init.o
In file included from drivers/scsi/sas/sas_internal.h:31,
                 from drivers/scsi/sas/sas_init.c:35:
include/scsi/libsas.h:479: error: field 'smp_req' has incomplete type
include/scsi/libsas.h:480: error: field 'smp_resp' has incomplete type
make[3]: *** [drivers/scsi/sas/sas_init.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc1-mm1-full/include/scsi/libsas.h.old	2006-07-10 18:19:10.000000000 +0200
+++ linux-2.6.18-rc1-mm1-full/include/scsi/libsas.h	2006-07-10 18:19:53.000000000 +0200
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <scsi/sas.h>
 #include <linux/list.h>
+#include <linux/scatterlist.h>
 #include <asm/semaphore.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>

