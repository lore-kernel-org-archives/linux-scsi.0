From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, RFT] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Thu, 28 Apr 2016 00:00:36 +0200
Message-ID: <25937441.NbUvhTZ9vo@wuerfel>
References: <20160419085221.GA29087@gmail.com> <5298237.1Guzp0G04x@wuerfel> <20160427110503.GB24887@virgil.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160427110503.GB24887@virgil.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Jambor <mjambor@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, Jan Hubicka <hubicka@ucw.cz>
List-Id: linux-scsi@vger.kernel.org

This is another attempt to avoid a regression in wwn_to_u64()
after that started using get_unaligned_be64(), which in turn
ran into a bug on gcc-4.9 through 6.1.

As part of the problem is how __builtin_constant_p gets evaluated
on an argument passed by reference into an inline function, this
avoids the use of __builtin_constant_p() for all architectures
that set CONFIG_ARCH_USE_BUILTIN_BSWAP. Most architectures do not
set ARCH_SUPPORTS_OPTIMIZED_INLINING, which means they probably
do not suffer from the problem in the qla2xxx driver, but they
might still run into it elsewhere.

I have not been able to reproduce the original problem, so I don't
know if this patch solves it, but at least it leads to simpler
code doing the same thing, so at least there should be no downsides.

Please test.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

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
+#define __swab64(x) __builtin_bswap64((__u64)(x))
+#else
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
 	___constant_swab64(x) :			\
 	__fswab64(x))
+#endif
 
 /**
  * __swahw32 - return a word-swapped 32-bit value
