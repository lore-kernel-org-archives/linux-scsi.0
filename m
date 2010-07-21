From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] BISECTED x86: avoid qword access in memcpy_*io
Date: Wed, 21 Jul 2010 10:21:36 +0900
Message-ID: <4C464BA0.20609@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Brian Gerst <brgerst@gmail.com>
List-Id: linux-scsi@vger.kernel.org

With v2.6.35-rc5, my x86-64 server doesn't boot but reports a
Completer Abort on lpfc card.

The result of git-bisect is:
  6175ddf06b6172046a329e3abfd9c901a43efd2e is the first bad commit
  commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
  Author: Brian Gerst <brgerst@gmail.com>
  Date:   Fri Feb 5 09:37:07 2010 -0500
    x86: Clean up mem*io functions.

What I found are:
 - memcpy for 64bit uses movq if count >= 64 (arch/x86/lib/memcpy_64.S)
 - memcpy_toio and memcpy_fromio have changed to use this memcpy by
   the above commit.
 - my debug shows that lpfc calls memcpy_toio with not-qword-aligned
   addresses and count >= 64, e.g.:
     memcpy_toio(0xffffc900118de004, 0xffff88047293d614, 124);
   and it seems that it comes from:
   [drivers/scsi/lpfc/lpfc_sli.c]
    4929   /* First copy mbox command data to HBA SLIM, skip past first
    4930      word */
    4931   to_slim = phba->MBslimaddr + sizeof (uint32_t);
    4932   lpfc_memcpy_to_slim(to_slim, &mb->un.varWords[0],
    4933               MAILBOX_CMD_SIZE - sizeof (uint32_t));

Still I'm not sure what is wrong in software or hardware, however
I suppose that qword access to iomem is not always safe, so it will
be OK to back to use __inline_memcpy which uses movsl.

I confirmed that my server (w/ lpfc) boots with 35-rc5 + this patch.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/io.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..e15a74a 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -227,13 +227,21 @@ memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
 static inline void
 memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
 {
+#ifdef CONFIG_X86_64
+	__inline_memcpy(dst, (const void __force *)src, count);
+#else
 	memcpy(dst, (const void __force *)src, count);
+#endif
 }
 
 static inline void
 memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 {
+#ifdef CONFIG_X86_64
+	__inline_memcpy((void __force *)dst, src, count);
+#else
 	memcpy((void __force *)dst, src, count);
+#endif
 }
 
 /*
-- 
1.7.1.1
