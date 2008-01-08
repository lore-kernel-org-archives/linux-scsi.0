From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: add call to flush_kernel_dcache_page for
 architectures that require it.
Date: Tue, 8 Jan 2008 12:09:32 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC622@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC622ADPE2K703adaptecc_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:43850 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbYAHUJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:09:36 -0500
Received: from ADPE2K702.adaptec.com (adpe2k702.adaptec.com [10.25.8.26])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id CB31123B2CF
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 12:09:35 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC622ADPE2K703adaptecc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Some architectures require a call to flush_kernel_dcache_page for processor=
 spoofed DMA operations.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 aachba.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c     2008-01-08 15:01:21.503932722 -0500
+++ b/drivers/scsi/aacraid/aachba.c     2008-01-08 15:02:35.849634368 -0500
@@ -31,9 +31,9 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
-#include <linux/dma-mapping.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
+#include <linux/highmem.h> /* For flush_kernel_dcache_page */

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -366,6 +366,9 @@
        if (buf && transfer_len > 0)
                memcpy(buf + offset, data, transfer_len);

+#ifdef ARCH_HAS_FLUSH_ANON_PAGE
+       flush_kernel_dcache_page(kmap_atomic_to_page(buf - sg->offset));
+#endif
        kunmap_atomic(buf - sg->offset, KM_IRQ0);

 }

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC622ADPE2K703adaptecc_
Content-Type: application/octet-stream; name="aacraid_flush_dcache3.patch"
Content-Description: aacraid_flush_dcache3.patch
Content-Disposition: attachment; filename="aacraid_flush_dcache3.patch";
	size=777; creation-date="Tue, 08 Jan 2008 12:03:28 GMT";
	modification-date="Tue, 08 Jan 2008 12:03:28 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMDggMTU6MDE6MjEuNTAzOTMyNzIyIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMDggMTU6MDI6MzUuODQ5NjM0MzY4IC0wNTAwCkBAIC0zMSw5ICsz
MSw5IEBACiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRp
b24uaD4KICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KLSNpbmNsdWRlIDxsaW51eC9kbWEtbWFw
cGluZy5oPgogI2luY2x1ZGUgPGFzbS9zZW1hcGhvcmUuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vz
cy5oPgorI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4gLyogRm9yIGZsdXNoX2tlcm5lbF9kY2Fj
aGVfcGFnZSAqLwogCiAjaW5jbHVkZSA8c2NzaS9zY3NpLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3Np
X2NtbmQuaD4KQEAgLTM2Niw2ICszNjYsOSBAQAogCWlmIChidWYgJiYgdHJhbnNmZXJfbGVuID4g
MCkKIAkJbWVtY3B5KGJ1ZiArIG9mZnNldCwgZGF0YSwgdHJhbnNmZXJfbGVuKTsKIAorI2lmZGVm
IEFSQ0hfSEFTX0ZMVVNIX0FOT05fUEFHRQorCWZsdXNoX2tlcm5lbF9kY2FjaGVfcGFnZShrbWFw
X2F0b21pY190b19wYWdlKGJ1ZiAtIHNnLT5vZmZzZXQpKTsKKyNlbmRpZgogCWt1bm1hcF9hdG9t
aWMoYnVmIC0gc2ctPm9mZnNldCwgS01fSVJRMCk7CiAKIH0K

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC622ADPE2K703adaptecc_--
