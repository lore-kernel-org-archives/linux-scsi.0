From: adam radford <aradford@gmail.com>
Subject: [PATCH] old 3ware scsi_dma_unmap fix
Date: Mon, 11 May 2009 14:55:55 -0700
Message-ID: <b1bc6a000905111455n68dc3d7ejd71cd3e3fc1d2b69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001e680f120cf070a20469aa0ae1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:28087 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbZEKVzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 17:55:55 -0400
Received: by yx-out-2324.google.com with SMTP id 3so1822377yxj.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2009 14:55:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable@kernel.org

--001e680f120cf070a20469aa0ae1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch for the old 3w-xxxx driver is for 2.6.30-rc6 and is similar
to the recent one I sent for the 3w-9xxx driver.

This patch fixes the following regression that occurred during the
scsi_dma_map()/unmap()
changes when compiling with CONFIG_DMA_API_DEBUG=y :

WARNING: at lib/dma-debug.c:496 check_unmap+0x142/0x542()
Hardware name:
3w-xxxx 0000:02:02.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000000000000] [size=36
bytes]

James, could you please apply this?

Thanks,

-Adam

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: This patch is included in-line below and also as an attachment
in case Gmail hoses the patch.

diff -Naur linux-2.6.30-rc5/drivers/scsi/3w-xxxx.c
linux-2.6.30-rc5.new/drivers/scsi/3w-xxxx.c
--- linux-2.6.30-rc5/drivers/scsi/3w-xxxx.c	2009-03-23 16:12:14.000000000 -0700
+++ linux-2.6.30-rc5.new/drivers/scsi/3w-xxxx.c	2009-05-11
11:40:32.000000000 -0700
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.

    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -1294,7 +1294,8 @@
 {
 	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");

-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End tw_unmap_scsi_data() */

 /* This function will reset a device extension */
diff -Naur linux-2.6.30-rc5/drivers/scsi/3w-xxxx.h
linux-2.6.30-rc5.new/drivers/scsi/3w-xxxx.h
--- linux-2.6.30-rc5/drivers/scsi/3w-xxxx.h	2009-05-11 11:25:33.000000000 -0700
+++ linux-2.6.30-rc5.new/drivers/scsi/3w-xxxx.h	2009-05-11
11:40:37.000000000 -0700
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2009 3ware Inc.

    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>

--001e680f120cf070a20469aa0ae1
Content-Type: text/x-patch; charset=US-ASCII; name="3ware_old_unmap.patch"
Content-Disposition: attachment; filename="3ware_old_unmap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fulpmykz0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzAtcmM1L2RyaXZlcnMvc2NzaS8zdy14eHh4LmMgbGludXgt
Mi42LjMwLXJjNS5uZXcvZHJpdmVycy9zY3NpLzN3LXh4eHguYwotLS0gbGludXgtMi42LjMwLXJj
NS9kcml2ZXJzL3Njc2kvM3cteHh4eC5jCTIwMDktMDMtMjMgMTY6MTI6MTQuMDAwMDAwMDAwIC0w
NzAwCisrKyBsaW51eC0yLjYuMzAtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvM3cteHh4eC5jCTIwMDkt
MDUtMTEgMTE6NDA6MzIuMDAwMDAwMDAwIC0wNzAwCkBAIC02LDcgKzYsNyBAQAogICAgCQkgICAg
IEFybmFsZG8gQ2FydmFsaG8gZGUgTWVsbyA8YWNtZUBjb25lY3RpdmEuY29tLmJyPgogICAgICAg
ICAgICAgICAgICAgICAgQnJhZCBTdHJhbmQgPGxpbnV4QDN3YXJlLmNvbT4KIAotICAgQ29weXJp
Z2h0IChDKSAxOTk5LTIwMDcgM3dhcmUgSW5jLgorICAgQ29weXJpZ2h0IChDKSAxOTk5LTIwMDkg
M3dhcmUgSW5jLgogCiAgICBLZXJuZWwgY29tcGF0aWJsaXR5IEJ5OiAJQW5kcmUgSGVkcmljayA8
YW5kcmVAc3VzZS5jb20+CiAgICBOb24tQ29weXJpZ2h0IChDKSAyMDAwCUFuZHJlIEhlZHJpY2sg
PGFuZHJlQHN1c2UuY29tPgpAQCAtMTI5NCw3ICsxMjk0LDggQEAKIHsKIAlkcHJpbnRrKEtFUk5f
V0FSTklORyAiM3cteHh4eDogdHdfdW5tYXBfc2NzaV9kYXRhKClcbiIpOwogCi0Jc2NzaV9kbWFf
dW5tYXAoY21kKTsKKwlpZiAoY21kLT5TQ3AucGhhc2UgPT0gVFdfUEhBU0VfU0dMSVNUKQorCQlz
Y3NpX2RtYV91bm1hcChjbWQpOwogfSAvKiBFbmQgdHdfdW5tYXBfc2NzaV9kYXRhKCkgKi8KIAog
LyogVGhpcyBmdW5jdGlvbiB3aWxsIHJlc2V0IGEgZGV2aWNlIGV4dGVuc2lvbiAqLwpkaWZmIC1O
YXVyIGxpbnV4LTIuNi4zMC1yYzUvZHJpdmVycy9zY3NpLzN3LXh4eHguaCBsaW51eC0yLjYuMzAt
cmM1Lm5ldy9kcml2ZXJzL3Njc2kvM3cteHh4eC5oCi0tLSBsaW51eC0yLjYuMzAtcmM1L2RyaXZl
cnMvc2NzaS8zdy14eHh4LmgJMjAwOS0wNS0xMSAxMToyNTozMy4wMDAwMDAwMDAgLTA3MDAKKysr
IGxpbnV4LTIuNi4zMC1yYzUubmV3L2RyaXZlcnMvc2NzaS8zdy14eHh4LmgJMjAwOS0wNS0xMSAx
MTo0MDozNy4wMDAwMDAwMDAgLTA3MDAKQEAgLTYsNyArNiw3IEBACiAgICAJCSAgICAgQXJuYWxk
byBDYXJ2YWxobyBkZSBNZWxvIDxhY21lQGNvbmVjdGl2YS5jb20uYnI+CiAgICAgICAgICAgICAg
ICAgICAgICBCcmFkIFN0cmFuZCA8bGludXhAM3dhcmUuY29tPgogCi0gICBDb3B5cmlnaHQgKEMp
IDE5OTktMjAwNyAzd2FyZSBJbmMuCisgICBDb3B5cmlnaHQgKEMpIDE5OTktMjAwOSAzd2FyZSBJ
bmMuCiAKICAgIEtlcm5lbCBjb21wYXRpYmxpdHkgQnk6CUFuZHJlIEhlZHJpY2sgPGFuZHJlQHN1
c2UuY29tPgogICAgTm9uLUNvcHlyaWdodCAoQykgMjAwMAlBbmRyZSBIZWRyaWNrIDxhbmRyZUBz
dXNlLmNvbT4K
--001e680f120cf070a20469aa0ae1--
