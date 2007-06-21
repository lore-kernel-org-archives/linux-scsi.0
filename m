From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 1/6] ps3: Preallocate bootmem memory for the PS3 FLASH ROM
	storage driver
Date: Thu, 21 Jun 2007 16:14:20 +0200
Message-ID: <20070621141515.167502000@pademelon.sonytel.be>
References: <20070621141419.480922000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1404345469=="
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
List-Id: linux-scsi@vger.kernel.org

--===============1404345469==
Content-Disposition: inline; filename=ps3-stable/ps3stor_flash_bootmem.diff

Preallocate 256 KiB of bootmem memory for the PS3 FLASH ROM storage driver.
This can be disabled by passing `ps3flash=off' on the kernel command line.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
v3:
  - Allow to disable ps3flash (and the preallocated 256 KiB buffer) using
    `ps3flash=off'

 arch/powerpc/platforms/ps3/setup.c |   31 ++++++++++++++++++++++++++++++-
 include/asm-powerpc/ps3.h          |    1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -107,7 +107,8 @@ static void ps3_panic(char *str)
 	while(1);
 }
 
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
 
+#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
 struct ps3_prealloc ps3fb_videomemory = {
 	.name = "ps3fb videomemory",
 	.size = CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
@@ -146,6 +149,30 @@ early_param("ps3fb", early_parse_ps3fb);
 #define prealloc_ps3fb_videomemory()	do { } while (0)
 #endif
 
+#if defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
+struct ps3_prealloc ps3flash_bounce_buffer = {
+	.name = "ps3flash bounce buffer",
+	.size = 256*1024,
+	.align = 256*1024
+};
+EXPORT_SYMBOL_GPL(ps3flash_bounce_buffer);
+#define prealloc_ps3flash_bounce_buffer()	prealloc(&ps3flash_bounce_buffer)
+
+static int __init early_parse_ps3flash(char *p)
+{
+	if (!p)
+		return 1;
+
+	if (!strcmp(p, "off"))
+		ps3flash_bounce_buffer.size = 0;
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
 	enum {DABR_USER = 1, DABR_KERNEL = 2,};
@@ -175,6 +202,8 @@ static void __init ps3_setup_arch(void)
 #endif
 
 	prealloc_ps3fb_videomemory();
+	prealloc_ps3flash_bounce_buffer();
+
 	ppc_md.power_save = ps3_power_save;
 
 	DBG(" <- %s:%d\n", __func__, __LINE__);
--- a/include/asm-powerpc/ps3.h
+++ b/include/asm-powerpc/ps3.h
@@ -427,6 +427,7 @@ struct ps3_prealloc {
 };
 
 extern struct ps3_prealloc ps3fb_videomemory;
+extern struct ps3_prealloc ps3flash_bounce_buffer;
 
 
 #endif

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619


--===============1404345469==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
--===============1404345469==--
