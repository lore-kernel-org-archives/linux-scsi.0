From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] kill hotplug init/exit section annotations
Date: Thu, 31 Jan 2008 09:57:31 -0600
Message-ID: <1201795051.3131.13.camel@localhost.localdomain>
References: <20080130200336.GN29368@does.not.exist>
	 <1201726817.3292.84.camel@localhost.localdomain>
	 <20080130212011.GA26621@uranus.ravnborg.org>
	 <1201729295.3292.94.camel@localhost.localdomain>
	 <20080130223219.GT29368@does.not.exist>
	 <20080131074436.GA31966@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39986 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764855AbYAaP5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 10:57:38 -0500
In-Reply-To: <20080131074436.GA31966@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

No-one seems to see much value in these, and they cause about 90% of our
problems with __init/__exit markers, so simply eliminate them.  Rather
than run over the whole tree removing them, this patch #defines them to
be nops.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

I'll probably be going after __exit after this one, but it makes sense
to split them up, since the hotplug annotation removal looks
uncontroversial, whereas __exit and discard section removal might
produce more robust debate.  I also think doing the hotplug removal
gives us 90% of the benefits and removes 90% of the section mismatch
problems.

James


diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f784d2f..5099021 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,46 +9,11 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
-/* The actual configuration determine if the init/exit sections
- * are handled as text/data or they can be discarded (which
- * often happens at runtime)
- */
-#ifdef CONFIG_HOTPLUG
-#define DEV_KEEP(sec)    *(.dev##sec)
-#define DEV_DISCARD(sec)
-#else
-#define DEV_KEEP(sec)
-#define DEV_DISCARD(sec) *(.dev##sec)
-#endif
-
-#ifdef CONFIG_HOTPLUG_CPU
-#define CPU_KEEP(sec)    *(.cpu##sec)
-#define CPU_DISCARD(sec)
-#else
-#define CPU_KEEP(sec)
-#define CPU_DISCARD(sec) *(.cpu##sec)
-#endif
-
-#if defined(CONFIG_MEMORY_HOTPLUG)
-#define MEM_KEEP(sec)    *(.mem##sec)
-#define MEM_DISCARD(sec)
-#else
-#define MEM_KEEP(sec)
-#define MEM_DISCARD(sec) *(.mem##sec)
-#endif
-
-
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
 	*(.ref.data)							\
-	DEV_KEEP(init.data)						\
-	DEV_KEEP(exit.data)						\
-	CPU_KEEP(init.data)						\
-	CPU_KEEP(exit.data)						\
-	MEM_KEEP(init.data)						\
-	MEM_KEEP(exit.data)						\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
@@ -171,12 +136,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		DEV_KEEP(init.rodata)					\
-		DEV_KEEP(exit.rodata)					\
-		CPU_KEEP(init.rodata)					\
-		CPU_KEEP(exit.rodata)					\
-		MEM_KEEP(init.rodata)					\
-		MEM_KEEP(exit.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -208,12 +167,6 @@
 		*(.ref.text)						\
 		*(.text.init.refok)					\
 		*(.exit.text.refok)					\
-	DEV_KEEP(init.text)						\
-	DEV_KEEP(exit.text)						\
-	CPU_KEEP(init.text)						\
-	CPU_KEEP(exit.text)						\
-	MEM_KEEP(init.text)						\
-	MEM_KEEP(exit.text)
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -241,33 +194,15 @@
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
-	DEV_DISCARD(init.data)						\
-	DEV_DISCARD(init.rodata)					\
-	CPU_DISCARD(init.data)						\
-	CPU_DISCARD(init.rodata)					\
-	MEM_DISCARD(init.data)						\
-	MEM_DISCARD(init.rodata)
 
 #define INIT_TEXT							\
 	*(.init.text)							\
-	DEV_DISCARD(init.text)						\
-	CPU_DISCARD(init.text)						\
-	MEM_DISCARD(init.text)
 
 #define EXIT_DATA							\
 	*(.exit.data)							\
-	DEV_DISCARD(exit.data)						\
-	DEV_DISCARD(exit.rodata)					\
-	CPU_DISCARD(exit.data)						\
-	CPU_DISCARD(exit.rodata)					\
-	MEM_DISCARD(exit.data)						\
-	MEM_DISCARD(exit.rodata)
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
-	DEV_DISCARD(exit.text)						\
-	CPU_DISCARD(exit.text)						\
-	MEM_DISCARD(exit.text)
 
 		/* DWARF debug sections.
 		Symbols in the DWARF debugging sections are relative to
diff --git a/include/linux/init.h b/include/linux/init.h
index 2efbda0..225bd1c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -81,29 +81,28 @@
 
 #define __exit          __section(.exit.text) __exitused __cold
 
-/* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
-#define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __section(.devinit.rodata)
-#define __devexit        __section(.devexit.text) __exitused __cold
-#define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __section(.devexit.rodata)
-
-/* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
-#define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold
-#define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+/* Legacy: originally used for HOTPLUG */
+#define __devinit        
+#define __devinitdata
+#define __devinitconst
+#define __devexit
+#define __devexitdata
+#define __devexitconst
+
+#define __cpuinit
+#define __cpuinitdata
+#define __cpuinitconst
+#define __cpuexit
+#define __cpuexitdata
+#define __cpuexitconst
 
 /* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(.meminit.text) __cold
-#define __meminitdata    __section(.meminit.data)
-#define __meminitconst   __section(.meminit.rodata)
-#define __memexit        __section(.memexit.text) __exitused __cold
-#define __memexitdata    __section(.memexit.data)
-#define __memexitconst   __section(.memexit.rodata)
+#define __meminit
+#define __meminitdata
+#define __meminitconst
+#define __memexit
+#define __memexitdata
+#define __memexitconst
 
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
@@ -111,14 +110,14 @@
 
 #define __INITDATA	.section	".init.data","aw"
 
-#define __DEVINIT        .section	".devinit.text", "ax"
-#define __DEVINITDATA    .section	".devinit.data", "aw"
+#define __DEVINIT
+#define __DEVINITDATA
 
-#define __CPUINIT        .section	".cpuinit.text", "ax"
-#define __CPUINITDATA    .section	".cpuinit.data", "aw"
+#define __CPUINIT
+#define __CPUINITDATA
 
-#define __MEMINIT        .section	".meminit.text", "ax"
-#define __MEMINITDATA    .section	".meminit.data", "aw"
+#define __MEMINIT
+#define __MEMINITDATA
 
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"


