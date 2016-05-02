From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Mon, 02 May 2016 23:48:19 +0200
Message-ID: <1780465.XdtPJpi8Tt@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:49739 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbcEBVtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 17:49:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jpoimboe@redhat.com, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

This is another attempt to avoid a regression in wwn_to_u64() after
that started using get_unaligned_be64(), which in turn ran into a
bug on gcc-4.9 through 6.1.

The regression got introduced due to the combination of two
separate workarounds (e3bde9568d99 and ef3fb2422ffe) that each
try to sidestep distinct problems with gcc behavior (code growth
and increased stack usage). Unfortunately after both have been
applied, a more series gcc bug has been uncovered, leading to
incorrect object code that discards part of a function and
causes undefined behavior.

As part of this problem is how __builtin_constant_p gets evaluated
on an argument passed by reference into an inline function, this
avoids the use of __builtin_constant_p() for all architectures
that set CONFIG_ARCH_USE_BUILTIN_BSWAP. Most architectures do not
set ARCH_SUPPORTS_OPTIMIZED_INLINING, which means they probably
do not suffer from the problem in the qla2xxx driver, but they
might still run into it elsewhere.

Both of the original workarounds were only merged in the 4.6 kernel,
and the bug that is fixed by this patch should only appear if
both are there, so we probably don't need to backport the fix.
On the other hand, it works by simplifying the code path and
should not have any negative effects.

Link: https://lkml.org/lkml/headers/2016/4/12/1103
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70232
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
Fixes: e3bde9568d99 ("include/linux/unaligned: force inlining of byteswap operations")
Fixes: ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")
Tested-by: Josh Poimboeuf <jpoimboe@redhat.com> # on gcc-5.3
Tested-by: Quinn Tran <quinn.tran@qlogic.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----
This contains the extra cast to fix up 64-bit builds, and has
an expanded changelog, compared to the original version.

diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
index 3f10e5317b46..de56fd54428d 100644
--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -45,9 +45,7 @@
 
 static inline __attribute_const__ __u16 __fswab16(__u16 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP16__
-	return __builtin_bswap16(val);
-#elif defined (__arch_swab16)
+#if defined (__arch_swab16)
 	return __arch_swab16(val);
 #else
 	return ___constant_swab16(val);
@@ -56,9 +54,7 @@ static inline __attribute_const__ __u16 __fswab16(__u16 val)
 
 static inline __attribute_const__ __u32 __fswab32(__u32 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP32__
-	return __builtin_bswap32(val);
-#elif defined(__arch_swab32)
+#if defined(__arch_swab32)
 	return __arch_swab32(val);
 #else
 	return ___constant_swab32(val);
@@ -67,9 +63,7 @@ static inline __attribute_const__ __u32 __fswab32(__u32 val)
 
 static inline __attribute_const__ __u64 __fswab64(__u64 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP64__
-	return __builtin_bswap64(val);
-#elif defined (__arch_swab64)
+#if defined (__arch_swab64)
 	return __arch_swab64(val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
@@ -102,28 +96,40 @@ static inline __attribute_const__ __u32 __fswahb32(__u32 val)
  * __swab16 - return a byteswapped 16-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP16__
+#define __swab16(x) __builtin_bswap16((__u16)(x))
+#else
 #define __swab16(x)				\
 	(__builtin_constant_p((__u16)(x)) ?	\
 	___constant_swab16(x) :			\
 	__fswab16(x))
+#endif
 
 /**

  * __swab32 - return a byteswapped 32-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP32__
+#define __swab32(x) __builtin_bswap32((__u32)(x))
+#else
 #define __swab32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
 	___constant_swab32(x) :			\
 	__fswab32(x))
+#endif
 
 /**
  * __swab64 - return a byteswapped 64-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP64__
+#define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
+#else
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
 	___constant_swab64(x) :			\
 	__fswab64(x))
+#endif
 
 /**
  * __swahw32 - return a word-swapped 32-bit value

