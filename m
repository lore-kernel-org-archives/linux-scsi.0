From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 1/6] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
Date: Wed, 04 Jul 2007 15:22:13 +0200
Message-ID: <20070704132346.174381000@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46160 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759596AbXGDNYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 09:24:51 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_flash_bootmem.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>

Preallocate 256 KiB of bootmem memory for the PS3 FLASH ROM storage dri=
ver.
This can be disabled by passing `ps3flash=3Doff' on the kernel command =
line.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
v3:
  - Allow to disable ps3flash (and the preallocated 256 KiB buffer) usi=
ng
    `ps3flash=3Doff'

 arch/powerpc/platforms/ps3/setup.c |   31 ++++++++++++++++++++++++++++=
++-
 include/asm-powerpc/ps3.h          |    1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -107,7 +107,8 @@ static void ps3_panic(char *str)
 	while(1);
 }
=20
-#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE) || \
+    defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
 static void prealloc(struct ps3_prealloc *p)
 {
 	if (!p->size)
@@ -123,7 +124,9 @@ static void prealloc(struct ps3_prealloc
 	printk(KERN_INFO "%s: %lu bytes at %p\n", p->name, p->size,
 	       p->address);
 }
+#endif
=20
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
 struct ps3_prealloc ps3fb_videomemory =3D {
 	.name =3D "ps3fb videomemory",
 	.size =3D CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
@@ -146,6 +149,30 @@ early_param("ps3fb", early_parse_ps3fb);
 #define prealloc_ps3fb_videomemory()	do { } while (0)
 #endif
=20
+#if defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
+struct ps3_prealloc ps3flash_bounce_buffer =3D {
+	.name =3D "ps3flash bounce buffer",
+	.size =3D 256*1024,
+	.align =3D 256*1024
+};
+EXPORT_SYMBOL_GPL(ps3flash_bounce_buffer);
+#define prealloc_ps3flash_bounce_buffer()	prealloc(&ps3flash_bounce_bu=
ffer)
+
+static int __init early_parse_ps3flash(char *p)
+{
+	if (!p)
+		return 1;
+
+	if (!strcmp(p, "off"))
+		ps3flash_bounce_buffer.size =3D 0;
+
+	return 0;
+}
+early_param("ps3flash", early_parse_ps3flash);
+#else
+#define prealloc_ps3flash_bounce_buffer()	do { } while (0)
+#endif
+
 static int ps3_set_dabr(u64 dabr)
 {
 	enum {DABR_USER =3D 1, DABR_KERNEL =3D 2,};
@@ -175,6 +202,8 @@ static void __init ps3_setup_arch(void)
 #endif
=20
 	prealloc_ps3fb_videomemory();
+	prealloc_ps3flash_bounce_buffer();
+
 	ppc_md.power_save =3D ps3_power_save;
=20
 	DBG(" <- %s:%d\n", __func__, __LINE__);
--- a/include/asm-powerpc/ps3.h
+++ b/include/asm-powerpc/ps3.h
@@ -427,6 +427,7 @@ struct ps3_prealloc {
 };
=20
 extern struct ps3_prealloc ps3fb_videomemory;
+extern struct ps3_prealloc ps3flash_bounce_buffer;
=20
=20
 #endif

--=20
With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
=46ax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Be=
lgium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
=46ortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
