From: Olaf Hering <olh@suse.de>
Subject: Re: recent sym2 breakage
Date: Mon, 16 Aug 2004 13:37:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816113705.GA6015@suse.de>
References: <20040816000146.3f484151.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48329 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266806AbUHPLhz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 07:37:55 -0400
Content-Disposition: inline
In-Reply-To: <20040816000146.3f484151.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linuxppc64-dev@lists.linuxppc.org

 On Mon, Aug 16, Andrew Morton wrote:

>=20
> So I'm putting together 2.6.8.1-mm1, which is bigger than Ben Hur and=
 it
> seems that someone broke the sym2 driver, on ppc64 at least.
>=20
> It runs OK, but a `halt -p' spits nasty messages, then hangs.

sym2 is a bit flaky in 2.6.

Does the vanilla kernel work ok for you? You might need at least this
patch in case of rtas errors:


diff -purNX /suse/olh/kernel/kernel_exclude.txt linux-2.6.8.1.orig/arch=
/ppc64/kernel/rtas.c linux-2.6.8.1-olh/arch/ppc64/kernel/rtas.c
--- linux-2.6.8.1.orig/arch/ppc64/kernel/rtas.c	2004-08-14 12:54:50.000=
000000 +0200
+++ linux-2.6.8.1-olh/arch/ppc64/kernel/rtas.c	2004-08-15 19:19:49.0000=
00000 +0200
@@ -31,6 +31,8 @@
 #include <asm/delay.h>
 #include <asm/uaccess.h>
=20
+extern int mem_init_done;
+
 struct flash_block_list_header rtas_firmware_flash_list =3D {0, NULL};
=20
 struct rtas_t rtas =3D {=20
@@ -165,6 +167,7 @@ int rtas_call(int token, int nargs, int=20
=20
 	/* Log the error in the unlikely case that there was one. */
 	if (unlikely(logit)) {
+		if (mem_init_done)
 		buff_copy =3D kmalloc(RTAS_ERROR_LOG_MAX, GFP_ATOMIC);
 		if (buff_copy) {
 			memcpy(buff_copy, rtas_err_buf, RTAS_ERROR_LOG_MAX);

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
