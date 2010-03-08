From: adam radford <aradford@gmail.com>
Subject: [PATCH] 3ware force 60 second timeout
Date: Mon, 8 Mar 2010 12:37:46 -0800
Message-ID: <b1bc6a001003081237j792f7cack436a0233e67097a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636c5c2b7b240420481500907
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65523 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0CHUhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 15:37:48 -0500
Received: by gwb15 with SMTP id 15so3161311gwb.19
        for <linux-scsi@vger.kernel.org>; Mon, 08 Mar 2010 12:37:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

--001636c5c2b7b240420481500907
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This small patch forces 60 second timeouts for the older 3w-xxxx &
3w-9xxx drivers for systems
that don't contain the udev rule for setting scsi timeouts to 60 seconds.

Signed-off-by: Adam Radford <aradford@gmail.com>

-Adam

Note:  This patch is included in-line below and also as an attachment.

diff -Naur linux-2.6.33-git15/drivers/scsi/3w-9xxx.c
linux-2.6.33-git16/drivers/scsi/3w-9xxx.c
--- linux-2.6.33-git15/drivers/scsi/3w-9xxx.c	2010-02-24
10:52:17.000000000 -0800
+++ linux-2.6.33-git16/drivers/scsi/3w-9xxx.c	2010-03-08
11:30:08.000000000 -0800
@@ -1,10 +1,11 @@
 /*
    3w-9xxx.c -- 3ware 9000 Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@amcc.com>
-   Modifications By: Tom Couch <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
+   Modifications By: Tom Couch <linuxraid@lsi.com>

    Copyright (C) 2004-2009 Applied Micro Circuits Corporation.
+   Copyright (C) 2010 LSI Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -40,10 +41,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@amcc.com
+   linuxraid@lsi.com

    For more information, goto:
-   http://www.amcc.com
+   http://www.lsi.com

    Note: This version of the driver does not contain a bundled firmware
          image.
@@ -77,6 +78,7 @@
                  Use pci_resource_len() for ioremap().
    2.26.02.012 - Add power management support.
    2.26.02.013 - Fix bug in twa_load_sgl().
+   2.26.02.014 - Force 60 second timeout default.
 */

 #include <linux/module.h>
@@ -101,14 +103,14 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.013"
+#define TW_DRIVER_VERSION "2.26.02.014"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
 extern struct timezone sys_tz;

 /* Module parameters */
-MODULE_AUTHOR ("AMCC");
+MODULE_AUTHOR ("LSI");
 MODULE_DESCRIPTION ("3ware 9000 Storage Controller Linux Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(TW_DRIVER_VERSION);
@@ -1989,6 +1991,15 @@
 		scsi_dma_unmap(cmd);
 } /* End twa_unmap_scsi_data() */

+/* This function gets called when a disk is coming on-line */
+static int twa_slave_configure(struct scsi_device *sdev)
+{
+	/* Force 60 second timeout */
+	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+
+	return 0;
+} /* End twa_slave_configure() */
+
 /* scsi_host_template initializer */
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
@@ -1998,6 +2009,7 @@
 	.bios_param		= twa_scsi_biosparam,
 	.change_queue_depth	= twa_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
+	.slave_configure	= twa_slave_configure,
 	.this_id		= -1,
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
diff -Naur linux-2.6.33-git15/drivers/scsi/3w-9xxx.h
linux-2.6.33-git16/drivers/scsi/3w-9xxx.h
--- linux-2.6.33-git15/drivers/scsi/3w-9xxx.h	2010-02-24
10:52:17.000000000 -0800
+++ linux-2.6.33-git16/drivers/scsi/3w-9xxx.h	2010-03-08
11:30:09.000000000 -0800
@@ -1,10 +1,11 @@
 /*
    3w-9xxx.h -- 3ware 9000 Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@amcc.com>
-   Modifications By: Tom Couch <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
+   Modifications By: Tom Couch <linuxraid@lsi.com>

    Copyright (C) 2004-2009 Applied Micro Circuits Corporation.
+   Copyright (C) 2010 LSI Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -40,10 +41,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@amcc.com
+   linuxraid@lsi.com

    For more information, goto:
-   http://www.amcc.com
+   http://www.lsi.com
 */

 #ifndef _3W_9XXX_H
diff -Naur linux-2.6.33-git15/drivers/sc
si/3w-xxxx.c linux-2.6.33-git16/drivers/scsi/3w-xxxx.c
--- linux-2.6.33-git15/drivers/scsi/3w-xxxx.c	2010-02-24
10:52:17.000000000 -0800
+++ linux-2.6.33-git16/drivers/scsi/3w-xxxx.c	2010-03-08
11:30:18.000000000 -0800
@@ -1,12 +1,12 @@
 /*
    3w-xxxx.c -- 3ware Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2009 3ware Inc.
+   Copyright (C) 1999-2010 3ware Inc.

    Kernel compatibility By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -47,10 +47,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@amcc.com
+   linuxraid@lsi.com

    For more information, goto:
-   http://www.amcc.com
+   http://www.lsi.com

    History
    -------
@@ -194,6 +194,7 @@
    1.26.02.002 - Free irq handler in __tw_shutdown().
                  Turn on RCD bit for caching mode page.
                  Serialize reset code.
+   1.26.02.003 - Force 60 second timeout default.
 */

 #include <linux/module.h>
@@ -218,13 +219,13 @@
 #include "3w-xxxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.002"
+#define TW_DRIVER_VERSION "1.26.02.003"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;

 /* Module parameters */
-MODULE_AUTHOR("AMCC");
+MODULE_AUTHOR("LSI");
 MODULE_DESCRIPTION("3ware Storage Controller Linux Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(TW_DRIVER_VERSION);
@@ -2244,6 +2245,15 @@
 	__tw_shutdown(tw_dev);
 } /* End tw_shutdown() */

+/* This function gets called when a disk is coming online */
+static int tw_slave_configure(struct scsi_device *sdev)
+{
+	/* Force 60 second timeout */
+	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+
+	return 0;
+} /* End tw_slave_configure() */
+
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware Storage Controller",
@@ -2252,6 +2262,7 @@
 	.bios_param		= tw_scsi_biosparam,
 	.change_queue_depth	= tw_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
+	.slave_configure	= tw_slave_configure,
 	.this_id		= -1,
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
diff -Naur linux-2.6.33-git15/drivers/scsi/3w-xxxx.h
linux-2.6.33-git16/drivers/scsi/3w-xxxx.h
--- linux-2.6.33-git15/drivers/scsi/3w-xxxx.h	2010-02-24
10:52:17.000000000 -0800
+++ linux-2.6.33-git16/drivers/scsi/3w-xxxx.h	2010-03-08
11:30:21.000000000 -0800
@@ -1,12 +1,12 @@
 /*
    3w-xxxx.h -- 3ware Storage Controller device driver for Linux.

-   Written By: Adam Radford <linuxraid@amcc.com>
+   Written By: Adam Radford <linuxraid@lsi.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2009 3ware Inc.
+   Copyright (C) 1999-2010 3ware Inc.

    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -45,10 +45,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Bugs/Comments/Suggestions should be mailed to:
-   linuxraid@amcc.com
+   linuxraid@lsi.com

    For more information, goto:
-   http://www.amcc.com
+   http://www.lsi.com
 */

 #ifndef _3W_XXXX_H

--001636c5c2b7b240420481500907
Content-Type: text/x-patch; charset=US-ASCII; name="3ware_linux-2.6.33-git16.patch"
Content-Disposition: attachment; filename="3ware_linux-2.6.33-git16.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6jqfzg50

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzMtZ2l0MTUvZHJpdmVycy9zY3NpLzN3LTl4eHguYyBsaW51
eC0yLjYuMzMtZ2l0MTYvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gbGludXgtMi42LjMzLWdp
dDE1L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMJMjAxMC0wMi0yNCAxMDo1MjoxNy4wMDAwMDAwMDAg
LTA4MDAKKysrIGxpbnV4LTIuNi4zMy1naXQxNi9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMTAt
MDMtMDggMTE6MzA6MDguMDAwMDAwMDAwIC0wODAwCkBAIC0xLDEwICsxLDExIEBACiAvKgogICAg
M3ctOXh4eC5jIC0tIDN3YXJlIDkwMDAgU3RvcmFnZSBDb250cm9sbGVyIGRldmljZSBkcml2ZXIg
Zm9yIExpbnV4LgogCi0gICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBhbWNj
LmNvbT4KLSAgIE1vZGlmaWNhdGlvbnMgQnk6IFRvbSBDb3VjaCA8bGludXhyYWlkQGFtY2MuY29t
PgorICAgV3JpdHRlbiBCeTogQWRhbSBSYWRmb3JkIDxsaW51eHJhaWRAbHNpLmNvbT4KKyAgIE1v
ZGlmaWNhdGlvbnMgQnk6IFRvbSBDb3VjaCA8bGludXhyYWlkQGxzaS5jb20+CiAKICAgIENvcHly
aWdodCAoQykgMjAwNC0yMDA5IEFwcGxpZWQgTWljcm8gQ2lyY3VpdHMgQ29ycG9yYXRpb24uCisg
ICBDb3B5cmlnaHQgKEMpIDIwMTAgTFNJIENvcnBvcmF0aW9uLgogCiAgICBUaGlzIHByb2dyYW0g
aXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQog
ICAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBh
cyBwdWJsaXNoZWQgYnkKQEAgLTQwLDEwICs0MSwxMCBAQAogICAgRm91bmRhdGlvbiwgSW5jLiwg
NTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcgIFVTQQog
CiAgICBCdWdzL0NvbW1lbnRzL1N1Z2dlc3Rpb25zIHNob3VsZCBiZSBtYWlsZWQgdG86Ci0gICBs
aW51eHJhaWRAYW1jYy5jb20KKyAgIGxpbnV4cmFpZEBsc2kuY29tCiAKICAgIEZvciBtb3JlIGlu
Zm9ybWF0aW9uLCBnb3RvOgotICAgaHR0cDovL3d3dy5hbWNjLmNvbQorICAgaHR0cDovL3d3dy5s
c2kuY29tCiAKICAgIE5vdGU6IFRoaXMgdmVyc2lvbiBvZiB0aGUgZHJpdmVyIGRvZXMgbm90IGNv
bnRhaW4gYSBidW5kbGVkIGZpcm13YXJlCiAgICAgICAgICBpbWFnZS4KQEAgLTc3LDYgKzc4LDcg
QEAKICAgICAgICAgICAgICAgICAgVXNlIHBjaV9yZXNvdXJjZV9sZW4oKSBmb3IgaW9yZW1hcCgp
LgogICAgMi4yNi4wMi4wMTIgLSBBZGQgcG93ZXIgbWFuYWdlbWVudCBzdXBwb3J0LgogICAgMi4y
Ni4wMi4wMTMgLSBGaXggYnVnIGluIHR3YV9sb2FkX3NnbCgpLgorICAgMi4yNi4wMi4wMTQgLSBG
b3JjZSA2MCBzZWNvbmQgdGltZW91dCBkZWZhdWx0LgogKi8KIAogI2luY2x1ZGUgPGxpbnV4L21v
ZHVsZS5oPgpAQCAtMTAxLDE0ICsxMDMsMTQgQEAKICNpbmNsdWRlICIzdy05eHh4LmgiCiAKIC8q
IEdsb2JhbHMgKi8KLSNkZWZpbmUgVFdfRFJJVkVSX1ZFUlNJT04gIjIuMjYuMDIuMDEzIgorI2Rl
ZmluZSBUV19EUklWRVJfVkVSU0lPTiAiMi4yNi4wMi4wMTQiCiBzdGF0aWMgVFdfRGV2aWNlX0V4
dGVuc2lvbiAqdHdhX2RldmljZV9leHRlbnNpb25fbGlzdFtUV19NQVhfU0xPVF07CiBzdGF0aWMg
dW5zaWduZWQgaW50IHR3YV9kZXZpY2VfZXh0ZW5zaW9uX2NvdW50Owogc3RhdGljIGludCB0d2Ff
bWFqb3IgPSAtMTsKIGV4dGVybiBzdHJ1Y3QgdGltZXpvbmUgc3lzX3R6OwogCiAvKiBNb2R1bGUg
cGFyYW1ldGVycyAqLwotTU9EVUxFX0FVVEhPUiAoIkFNQ0MiKTsKK01PRFVMRV9BVVRIT1IgKCJM
U0kiKTsKIE1PRFVMRV9ERVNDUklQVElPTiAoIjN3YXJlIDkwMDAgU3RvcmFnZSBDb250cm9sbGVy
IExpbnV4IERyaXZlciIpOwogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogTU9EVUxFX1ZFUlNJT04o
VFdfRFJJVkVSX1ZFUlNJT04pOwpAQCAtMTk4OSw2ICsxOTkxLDE1IEBACiAJCXNjc2lfZG1hX3Vu
bWFwKGNtZCk7CiB9IC8qIEVuZCB0d2FfdW5tYXBfc2NzaV9kYXRhKCkgKi8KIAorLyogVGhpcyBm
dW5jdGlvbiBnZXRzIGNhbGxlZCB3aGVuIGEgZGlzayBpcyBjb21pbmcgb24tbGluZSAqLworc3Rh
dGljIGludCB0d2Ffc2xhdmVfY29uZmlndXJlKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldikKK3sK
KwkvKiBGb3JjZSA2MCBzZWNvbmQgdGltZW91dCAqLworCWJsa19xdWV1ZV9ycV90aW1lb3V0KHNk
ZXYtPnJlcXVlc3RfcXVldWUsIDYwICogSFopOworCisJcmV0dXJuIDA7Cit9IC8qIEVuZCB0d2Ff
c2xhdmVfY29uZmlndXJlKCkgKi8KKwogLyogc2NzaV9ob3N0X3RlbXBsYXRlIGluaXRpYWxpemVy
ICovCiBzdGF0aWMgc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSBkcml2ZXJfdGVtcGxhdGUgPSB7
CiAJLm1vZHVsZQkJCT0gVEhJU19NT0RVTEUsCkBAIC0xOTk4LDYgKzIwMDksNyBAQAogCS5iaW9z
X3BhcmFtCQk9IHR3YV9zY3NpX2Jpb3NwYXJhbSwKIAkuY2hhbmdlX3F1ZXVlX2RlcHRoCT0gdHdh
X2NoYW5nZV9xdWV1ZV9kZXB0aCwKIAkuY2FuX3F1ZXVlCQk9IFRXX1FfTEVOR1RILTIsCisJLnNs
YXZlX2NvbmZpZ3VyZQk9IHR3YV9zbGF2ZV9jb25maWd1cmUsCiAJLnRoaXNfaWQJCT0gLTEsCiAJ
LnNnX3RhYmxlc2l6ZQkJPSBUV19BUEFDSEVfTUFYX1NHTF9MRU5HVEgsCiAJLm1heF9zZWN0b3Jz
CQk9IFRXX01BWF9TRUNUT1JTLApkaWZmIC1OYXVyIGxpbnV4LTIuNi4zMy1naXQxNS9kcml2ZXJz
L3Njc2kvM3ctOXh4eC5oIGxpbnV4LTIuNi4zMy1naXQxNi9kcml2ZXJzL3Njc2kvM3ctOXh4eC5o
Ci0tLSBsaW51eC0yLjYuMzMtZ2l0MTUvZHJpdmVycy9zY3NpLzN3LTl4eHguaAkyMDEwLTAyLTI0
IDEwOjUyOjE3LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjMzLWdpdDE2L2RyaXZlcnMv
c2NzaS8zdy05eHh4LmgJMjAxMC0wMy0wOCAxMTozMDowOS4wMDAwMDAwMDAgLTA4MDAKQEAgLTEs
MTAgKzEsMTEgQEAKIC8qCiAgICAzdy05eHh4LmggLS0gM3dhcmUgOTAwMCBTdG9yYWdlIENvbnRy
b2xsZXIgZGV2aWNlIGRyaXZlciBmb3IgTGludXguCiAKLSAgIFdyaXR0ZW4gQnk6IEFkYW0gUmFk
Zm9yZCA8bGludXhyYWlkQGFtY2MuY29tPgotICAgTW9kaWZpY2F0aW9ucyBCeTogVG9tIENvdWNo
IDxsaW51eHJhaWRAYW1jYy5jb20+CisgICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4
cmFpZEBsc2kuY29tPgorICAgTW9kaWZpY2F0aW9ucyBCeTogVG9tIENvdWNoIDxsaW51eHJhaWRA
bHNpLmNvbT4KIAogICAgQ29weXJpZ2h0IChDKSAyMDA0LTIwMDkgQXBwbGllZCBNaWNybyBDaXJj
dWl0cyBDb3Jwb3JhdGlvbi4KKyAgIENvcHlyaWdodCAoQykgMjAxMCBMU0kgQ29ycG9yYXRpb24u
CiAKICAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0
ZSBpdCBhbmQvb3IgbW9kaWZ5CiAgICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5l
cmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQpAQCAtNDAsMTAgKzQxLDEwIEBACiAg
ICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBN
QSAgMDIxMTEtMTMwNyAgVVNBCiAKICAgIEJ1Z3MvQ29tbWVudHMvU3VnZ2VzdGlvbnMgc2hvdWxk
IGJlIG1haWxlZCB0bzoKLSAgIGxpbnV4cmFpZEBhbWNjLmNvbQorICAgbGludXhyYWlkQGxzaS5j
b20KIAogICAgRm9yIG1vcmUgaW5mb3JtYXRpb24sIGdvdG86Ci0gICBodHRwOi8vd3d3LmFtY2Mu
Y29tCisgICBodHRwOi8vd3d3LmxzaS5jb20KICovCiAKICNpZm5kZWYgXzNXXzlYWFhfSApkaWZm
IC1OYXVyIGxpbnV4LTIuNi4zMy1naXQxNS9kcml2ZXJzL3Njc2kvM3cteHh4eC5jIGxpbnV4LTIu
Ni4zMy1naXQxNi9kcml2ZXJzL3Njc2kvM3cteHh4eC5jCi0tLSBsaW51eC0yLjYuMzMtZ2l0MTUv
ZHJpdmVycy9zY3NpLzN3LXh4eHguYwkyMDEwLTAyLTI0IDEwOjUyOjE3LjAwMDAwMDAwMCAtMDgw
MAorKysgbGludXgtMi42LjMzLWdpdDE2L2RyaXZlcnMvc2NzaS8zdy14eHh4LmMJMjAxMC0wMy0w
OCAxMTozMDoxOC4wMDAwMDAwMDAgLTA4MDAKQEAgLTEsMTIgKzEsMTIgQEAKIC8qIAogICAgM3ct
eHh4eC5jIC0tIDN3YXJlIFN0b3JhZ2UgQ29udHJvbGxlciBkZXZpY2UgZHJpdmVyIGZvciBMaW51
eC4KIAotICAgV3JpdHRlbiBCeTogQWRhbSBSYWRmb3JkIDxsaW51eHJhaWRAYW1jYy5jb20+Cisg
ICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBsc2kuY29tPgogICAgTW9kaWZp
Y2F0aW9ucyBCeTogSm9lbCBKYWNvYnNvbiA8bGludXhAM3dhcmUuY29tPgogICAgCQkgICAgIEFy
bmFsZG8gQ2FydmFsaG8gZGUgTWVsbyA8YWNtZUBjb25lY3RpdmEuY29tLmJyPgogICAgICAgICAg
ICAgICAgICAgICAgQnJhZCBTdHJhbmQgPGxpbnV4QDN3YXJlLmNvbT4KIAotICAgQ29weXJpZ2h0
IChDKSAxOTk5LTIwMDkgM3dhcmUgSW5jLgorICAgQ29weXJpZ2h0IChDKSAxOTk5LTIwMTAgM3dh
cmUgSW5jLgogCiAgICBLZXJuZWwgY29tcGF0aWJpbGl0eSBCeTogCUFuZHJlIEhlZHJpY2sgPGFu
ZHJlQHN1c2UuY29tPgogICAgTm9uLUNvcHlyaWdodCAoQykgMjAwMAlBbmRyZSBIZWRyaWNrIDxh
bmRyZUBzdXNlLmNvbT4KQEAgLTQ3LDEwICs0NywxMCBAQAogICAgRm91bmRhdGlvbiwgSW5jLiwg
NTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcgIFVTQSAK
IAogICAgQnVncy9Db21tZW50cy9TdWdnZXN0aW9ucyBzaG91bGQgYmUgbWFpbGVkIHRvOiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAKLSAgIGxpbnV4cmFpZEBhbWNjLmNvbQorICAgbGludXhy
YWlkQGxzaS5jb20KIAogICAgRm9yIG1vcmUgaW5mb3JtYXRpb24sIGdvdG86Ci0gICBodHRwOi8v
d3d3LmFtY2MuY29tCisgICBodHRwOi8vd3d3LmxzaS5jb20KIAogICAgSGlzdG9yeQogICAgLS0t
LS0tLQpAQCAtMTk0LDYgKzE5NCw3IEBACiAgICAxLjI2LjAyLjAwMiAtIEZyZWUgaXJxIGhhbmRs
ZXIgaW4gX190d19zaHV0ZG93bigpLgogICAgICAgICAgICAgICAgICBUdXJuIG9uIFJDRCBiaXQg
Zm9yIGNhY2hpbmcgbW9kZSBwYWdlLgogICAgICAgICAgICAgICAgICBTZXJpYWxpemUgcmVzZXQg
Y29kZS4KKyAgIDEuMjYuMDIuMDAzIC0gRm9yY2UgNjAgc2Vjb25kIHRpbWVvdXQgZGVmYXVsdC4K
ICovCiAKICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KQEAgLTIxOCwxMyArMjE5LDEzIEBACiAj
aW5jbHVkZSAiM3cteHh4eC5oIgogCiAvKiBHbG9iYWxzICovCi0jZGVmaW5lIFRXX0RSSVZFUl9W
RVJTSU9OICIxLjI2LjAyLjAwMiIKKyNkZWZpbmUgVFdfRFJJVkVSX1ZFUlNJT04gIjEuMjYuMDIu
MDAzIgogc3RhdGljIFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldmljZV9leHRlbnNpb25fbGlz
dFtUV19NQVhfU0xPVF07CiBzdGF0aWMgaW50IHR3X2RldmljZV9leHRlbnNpb25fY291bnQgPSAw
Owogc3RhdGljIGludCB0d2VfbWFqb3IgPSAtMTsKIAogLyogTW9kdWxlIHBhcmFtZXRlcnMgKi8K
LU1PRFVMRV9BVVRIT1IoIkFNQ0MiKTsKK01PRFVMRV9BVVRIT1IoIkxTSSIpOwogTU9EVUxFX0RF
U0NSSVBUSU9OKCIzd2FyZSBTdG9yYWdlIENvbnRyb2xsZXIgTGludXggRHJpdmVyIik7CiBNT0RV
TEVfTElDRU5TRSgiR1BMIik7CiBNT0RVTEVfVkVSU0lPTihUV19EUklWRVJfVkVSU0lPTik7CkBA
IC0yMjQ0LDYgKzIyNDUsMTUgQEAKIAlfX3R3X3NodXRkb3duKHR3X2Rldik7CiB9IC8qIEVuZCB0
d19zaHV0ZG93bigpICovCiAKKy8qIFRoaXMgZnVuY3Rpb24gZ2V0cyBjYWxsZWQgd2hlbiBhIGRp
c2sgaXMgY29taW5nIG9ubGluZSAqLworc3RhdGljIGludCB0d19zbGF2ZV9jb25maWd1cmUoc3Ry
dWN0IHNjc2lfZGV2aWNlICpzZGV2KQoreworCS8qIEZvcmNlIDYwIHNlY29uZCB0aW1lb3V0ICov
CisJYmxrX3F1ZXVlX3JxX3RpbWVvdXQoc2Rldi0+cmVxdWVzdF9xdWV1ZSwgNjAgKiBIWik7CisK
KwlyZXR1cm4gMDsKK30gLyogRW5kIHR3X3NsYXZlX2NvbmZpZ3VyZSgpICovCisKIHN0YXRpYyBz
dHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlIGRyaXZlcl90ZW1wbGF0ZSA9IHsKIAkubW9kdWxlCQkJ
PSBUSElTX01PRFVMRSwKIAkubmFtZQkJCT0gIjN3YXJlIFN0b3JhZ2UgQ29udHJvbGxlciIsCkBA
IC0yMjUyLDYgKzIyNjIsNyBAQAogCS5iaW9zX3BhcmFtCQk9IHR3X3Njc2lfYmlvc3BhcmFtLAog
CS5jaGFuZ2VfcXVldWVfZGVwdGgJPSB0d19jaGFuZ2VfcXVldWVfZGVwdGgsCiAJLmNhbl9xdWV1
ZQkJPSBUV19RX0xFTkdUSC0yLAorCS5zbGF2ZV9jb25maWd1cmUJPSB0d19zbGF2ZV9jb25maWd1
cmUsCiAJLnRoaXNfaWQJCT0gLTEsCiAJLnNnX3RhYmxlc2l6ZQkJPSBUV19NQVhfU0dMX0xFTkdU
SCwKIAkubWF4X3NlY3RvcnMJCT0gVFdfTUFYX1NFQ1RPUlMsCmRpZmYgLU5hdXIgbGludXgtMi42
LjMzLWdpdDE1L2RyaXZlcnMvc2NzaS8zdy14eHh4LmggbGludXgtMi42LjMzLWdpdDE2L2RyaXZl
cnMvc2NzaS8zdy14eHh4LmgKLS0tIGxpbnV4LTIuNi4zMy1naXQxNS9kcml2ZXJzL3Njc2kvM3ct
eHh4eC5oCTIwMTAtMDItMjQgMTA6NTI6MTcuMDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYu
MzMtZ2l0MTYvZHJpdmVycy9zY3NpLzN3LXh4eHguaAkyMDEwLTAzLTA4IDExOjMwOjIxLjAwMDAw
MDAwMCAtMDgwMApAQCAtMSwxMiArMSwxMiBAQAogLyogCiAgICAzdy14eHh4LmggLS0gM3dhcmUg
U3RvcmFnZSBDb250cm9sbGVyIGRldmljZSBkcml2ZXIgZm9yIExpbnV4LgogICAgCi0gICBXcml0
dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBhbWNjLmNvbT4KKyAgIFdyaXR0ZW4gQnk6
IEFkYW0gUmFkZm9yZCA8bGludXhyYWlkQGxzaS5jb20+CiAgICBNb2RpZmljYXRpb25zIEJ5OiBK
b2VsIEphY29ic29uIDxsaW51eEAzd2FyZS5jb20+CiAgICAJCSAgICAgQXJuYWxkbyBDYXJ2YWxo
byBkZSBNZWxvIDxhY21lQGNvbmVjdGl2YS5jb20uYnI+CiAgICAgICAgICAgICAgICAgICAgICBC
cmFkIFN0cmFuZCA8bGludXhAM3dhcmUuY29tPgogCi0gICBDb3B5cmlnaHQgKEMpIDE5OTktMjAw
OSAzd2FyZSBJbmMuCisgICBDb3B5cmlnaHQgKEMpIDE5OTktMjAxMCAzd2FyZSBJbmMuCiAKICAg
IEtlcm5lbCBjb21wYXRpYmxpdHkgQnk6CUFuZHJlIEhlZHJpY2sgPGFuZHJlQHN1c2UuY29tPgog
ICAgTm9uLUNvcHlyaWdodCAoQykgMjAwMAlBbmRyZSBIZWRyaWNrIDxhbmRyZUBzdXNlLmNvbT4K
QEAgLTQ1LDEwICs0NSwxMCBAQAogICAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNl
LCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcgIFVTQSAKIAogICAgQnVncy9Db21t
ZW50cy9TdWdnZXN0aW9ucyBzaG91bGQgYmUgbWFpbGVkIHRvOiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAKLSAgIGxpbnV4cmFpZEBhbWNjLmNvbQorICAgbGludXhyYWlkQGxzaS5jb20KICAg
IAogICAgRm9yIG1vcmUgaW5mb3JtYXRpb24sIGdvdG86Ci0gICBodHRwOi8vd3d3LmFtY2MuY29t
CisgICBodHRwOi8vd3d3LmxzaS5jb20KICovCiAKICNpZm5kZWYgXzNXX1hYWFhfSAo=
--001636c5c2b7b240420481500907--
