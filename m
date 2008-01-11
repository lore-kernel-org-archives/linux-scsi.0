From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: add call to flush_kernel_dcache_page for
 architectures that require it (take 2)
Date: Fri, 11 Jan 2008 11:46:44 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	 <20071101173221.2e1fea42.sfr@canb.auug.org.au>
	 <jefxzqqeha.fsf@sykes.suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC622@ADPE2K703.adaptec.com>
 <1200069662.3286.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:49291 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758923AbYAKTqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 14:46:47 -0500
In-Reply-To: <1200069662.3286.21.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The reason for the guard was for Linux Distributions that had limited their=
 list of exported APIs on architectures that did *not* require the flush_ke=
rnel_dcache_page ... Sorry for not filtering out Distribution kernel issues=
 into the list! :-)

Dropped guard in the enclosed patch.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 aachba.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c     2008-01-11 14:38:53.342378372 -0500
+++ b/drivers/scsi/aacraid/aachba.c     2008-01-11 14:39:39.364534313 -0500
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
@@ -366,6 +366,7 @@
        if (buf && transfer_len > 0)
                memcpy(buf + offset, data, transfer_len);

+       flush_kernel_dcache_page(kmap_atomic_to_page(buf - sg->offset));
        kunmap_atomic(buf - sg->offset, KM_IRQ0);

 }

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, January 11, 2008 11:41 AM
> To: Salyzyn, Mark
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: [PATCH 1/1] aacraid: add call to
> flush_kernel_dcache_page for architectures that require it.
>
> On Tue, 2008-01-08 at 12:09 -0800, Salyzyn, Mark wrote:
> > Some architectures require a call to
> flush_kernel_dcache_page for processor spoofed DMA operations.
> >
> > This attached patch is against current scsi-misc-2.6.
> >
> > ObligatoryDisclaimer: Please accept my condolences
> regarding Outlook's handling of patch attachments (inline
> gets damaged, use attachment).
> >
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> >
> >  aachba.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff -ru a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> > --- a/drivers/scsi/aacraid/aachba.c     2008-01-08
> 15:01:21.503932722 -0500
> > +++ b/drivers/scsi/aacraid/aachba.c     2008-01-08
> 15:02:35.849634368 -0500
> > @@ -31,9 +31,9 @@
> >  #include <linux/slab.h>
> >  #include <linux/completion.h>
> >  #include <linux/blkdev.h>
> > -#include <linux/dma-mapping.h>
> >  #include <asm/semaphore.h>
> >  #include <asm/uaccess.h>
> > +#include <linux/highmem.h> /* For flush_kernel_dcache_page */
> >
> >  #include <scsi/scsi.h>
> >  #include <scsi/scsi_cmnd.h>
> > @@ -366,6 +366,9 @@
> >         if (buf && transfer_len > 0)
> >                 memcpy(buf + offset, data, transfer_len);
> >
> > +#ifdef ARCH_HAS_FLUSH_ANON_PAGE
> > +       flush_kernel_dcache_page(kmap_atomic_to_page(buf -
> sg->offset));
> > +#endif
>
> This #ifdef/#endif guard is unnecessary ... flush_kernel_dcache_page()
> is available on all architectures (it's a nop on most).
>
> However, ARCH_HAS_FLUSH_ANON_PAGE is the wrong guard anyway ... that's
> for the flush_anon_page() function ...

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_flush_dcache4.patch"
Content-Description: aacraid_flush_dcache4.patch
Content-Disposition: attachment; filename="aacraid_flush_dcache4.patch";
	size=736; creation-date="Fri, 11 Jan 2008 11:40:20 GMT";
	modification-date="Fri, 11 Jan 2008 11:40:20 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMTEgMTQ6Mzg6NTMuMzQyMzc4MzcyIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMTEgMTQ6Mzk6MzkuMzY0NTM0MzEzIC0wNTAwCkBAIC0zMSw5ICsz
MSw5IEBACiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRp
b24uaD4KICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KLSNpbmNsdWRlIDxsaW51eC9kbWEtbWFw
cGluZy5oPgogI2luY2x1ZGUgPGFzbS9zZW1hcGhvcmUuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vz
cy5oPgorI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4gLyogRm9yIGZsdXNoX2tlcm5lbF9kY2Fj
aGVfcGFnZSAqLwogCiAjaW5jbHVkZSA8c2NzaS9zY3NpLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3Np
X2NtbmQuaD4KQEAgLTM2Niw2ICszNjYsNyBAQAogCWlmIChidWYgJiYgdHJhbnNmZXJfbGVuID4g
MCkKIAkJbWVtY3B5KGJ1ZiArIG9mZnNldCwgZGF0YSwgdHJhbnNmZXJfbGVuKTsKIAorCWZsdXNo
X2tlcm5lbF9kY2FjaGVfcGFnZShrbWFwX2F0b21pY190b19wYWdlKGJ1ZiAtIHNnLT5vZmZzZXQp
KTsKIAlrdW5tYXBfYXRvbWljKGJ1ZiAtIHNnLT5vZmZzZXQsIEtNX0lSUTApOwogCiB9Cg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7ADPE2K703adapte_--
