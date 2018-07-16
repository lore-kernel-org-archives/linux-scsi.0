From: Martijn Coenen <maco@android.com>
Subject: [PATCH 1/6] export: explicitly align struct kernel_symbol.
Date: Mon, 16 Jul 2018 14:21:20 +0200
Message-ID: <20180716122125.175792-2-maco@android.com>
References: <20180716122125.175792-1-maco@android.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716122125.175792-1-maco@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Martijn Coenen <maco@android.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi
List-Id: linux-scsi@vger.kernel.org

This change allows growing struct kernel_symbol without wasting bytes to
alignment.

struct kernel_symbol was already implicitly being aligned to the word
size, except on x86_64 and m68k, where it is aligned to 16 and 2 bytes,
respectively.

As far as I can tell there is no requirement for aligning struct
kernel_symbol to 16 bytes on x86_64, but gcc aligns structs to their
size, and the linker aligns the custom __ksymtab sections to the largest
data type contained within, so setting KSYM_ALIGN to 16 was necessary to
stay consistent with the code generated for non-ASM EXPORT_SYMBOL(). Now
that non-ASM EXPORT_SYMBOL() explicitly aligns to word size (8),
KSYM_ALIGN is no longer necessary.

As for m68k, struct kernel_symbol is aligned to 2 bytes even though the
structure itself is 8 bytes; using a 4-byte alignment shouldn't hurt.

I manually verified the output of the __ksymtab sections didn't change
on x86, x86_64, arm, arm64 and m68k. As expected, the section contents
didn't change, and the ELF section alignment only changed on x86_64 and
m68k. Feedback from other archs more than welcome.

Signed-off-by: Martijn Coenen <maco@android.com>
---
 arch/m68k/include/asm/export.h | 1 -
 arch/x86/include/asm/Kbuild    | 1 +
 arch/x86/include/asm/export.h  | 5 -----
 include/linux/export.h         | 1 +
 4 files changed, 2 insertions(+), 6 deletions(-)
 delete mode 100644 arch/x86/include/asm/export.h

diff --git a/arch/m68k/include/asm/export.h b/arch/m68k/include/asm/export.h
index 0af20f48bd07..b53008b67ce1 100644
--- a/arch/m68k/include/asm/export.h
+++ b/arch/m68k/include/asm/export.h
@@ -1,3 +1,2 @@
-#define KSYM_ALIGN 2
 #define KCRC_ALIGN 2
 #include <asm-generic/export.h>
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index de690c2d2e33..a0ab9ab61c75 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -8,5 +8,6 @@ generated-y += xen-hypercalls.h
 
 generic-y += dma-contiguous.h
 generic-y += early_ioremap.h
+generic-y += export.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
diff --git a/arch/x86/include/asm/export.h b/arch/x86/include/asm/export.h
deleted file mode 100644
index 2a51d66689c5..000000000000
--- a/arch/x86/include/asm/export.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifdef CONFIG_64BIT
-#define KSYM_ALIGN 16
-#endif
-#include <asm-generic/export.h>
diff --git a/include/linux/export.h b/include/linux/export.h
index b768d6dd3c90..ad6b8e697b27 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -64,6 +64,7 @@ extern struct module __this_module;
 	static const struct kernel_symbol __ksymtab_##sym		\
 	__used								\
 	__attribute__((section("___ksymtab" sec "+" #sym), used))	\
+	__attribute__((aligned(sizeof(void *))))                        \
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
 #if defined(__KSYM_DEPS__)
-- 
2.18.0.203.gfac676dfb9-goog
