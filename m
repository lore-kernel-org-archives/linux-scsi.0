From: Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH 1/6] lib: string: add function strtolower()
Date: Thu, 30 Jun 2016 16:50:07 -0700
Message-ID: <1467330612-26242-2-git-send-email-mmayer@broadcom.com>
References: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1467330612-26242-1-git-send-email-mmayer@broadcom.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>
Cc: Markus Mayer <mmayer@broadcom.com>, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-acpi@vger.kernel.org, devel@acpica.org, speakup@linux-speakup.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a function called strtolower() to convert strings to lower case
in-place, overwriting the original string.

This seems to be a recurring requirement in the kernel that is
currently being solved by several duplicated implementations doing the
same thing.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---
 include/linux/string.h |  1 +
 lib/string.c           | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a..aad605e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -116,6 +116,7 @@ extern void * memchr(const void *,int,__kernel_size_t);
 #endif
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
+char *strtolower(char *s);
 
 extern void kfree_const(const void *x);
 
diff --git a/lib/string.c b/lib/string.c
index ed83562..6e3b560 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -952,3 +952,17 @@ char *strreplace(char *s, char old, char new)
 	return s;
 }
 EXPORT_SYMBOL(strreplace);
+
+char *strtolower(char *s)
+{
+	char *p;
+
+        if (unlikely(!s))
+                return NULL;
+
+	for (p = s; *p; p++)
+		*p = tolower(*p);
+
+	return s;
+}
+EXPORT_SYMBOL(strtolower);
-- 
2.7.4

