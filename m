From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force inlining of some byteswap operations)
Date: Sat, 16 Apr 2016 09:42:37 +0200
Message-ID: <148417843.qlNmZC1Fkn@wuerfel>
References: <1454615136-32308-2-git-send-email-dvlasenk@redhat.com> <570FCEB7.1070200@redhat.com> <20160415054518.GA28079@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160415054518.GA28079@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday 15 April 2016 07:45:19 Ingo Molnar wrote:
> 
> * Denys Vlasenko <dvlasenk@redhat.com> wrote:
> 
> > > In fact, the following patch seems to fix it:
> > > 
> > > diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> > > index bf66ea6..56b9e81 100644
> > > --- a/include/scsi/scsi_transport_fc.h
> > > +++ b/include/scsi/scsi_transport_fc.h
> > > @@ -796,7 +796,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
> > >  	return result;
> > >  }
> > >  
> > > -static inline u64 wwn_to_u64(u8 *wwn)
> > > +static __always_inline u64 wwn_to_u64(u8 *wwn)
> > >  {
> > >  	return get_unaligned_be64(wwn);
> > >  }
> > 
> > It is not a guarantee.
> 
> Of course it's a workaround - but is there any deterministic way to turn off this 
> GCC bug (by activating some GCC command line switch), or do we have to live with 
> objtool warning about this GCC?
> 
> Which, by the way, is pretty cool!

I have done a patch for the asm-generic/unaligned handling recently that
reworks the implementation to avoid an ARM specific bug (gcc uses certain
CPU instructions that require aligned data when we tell it that unaligned
data is not).

It changes the code enough that the gcc bug might not be triggered any more,
aside from generating far superior code in some cases.

I thought I had submitted that patch before, but I can't find a version
with a proper changelog any more now, so I probably haven't. However, I did
all the research to show that it only makes things better on ARM and x86
except in cases where the gcc inliner happens to pick a different set of
functions to be inline (these have a 50:50 chance of better vs worse, the
result on average seems to be the same).

	Arnd

commit 752b719f6675be02a3dd29fe5d92b2f380b5743d
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Mar 4 16:15:20 2016 +0100

    asm-generic: always use struct based unaligned access
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 1ac097279db1..e8f5523eeb0a 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -3,29 +3,19 @@
 
 /*
  * This is the most generic implementation of unaligned accesses
- * and should work almost anywhere.
+ * and should work almost anywhere, we trust that the compiler
+ * knows how to handle unaligned accesses.
  */
 #include <asm/byteorder.h>
 
-/* Set by the arch if it can handle unaligned accesses in hardware. */
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-# include <linux/unaligned/access_ok.h>
-#endif
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/generic.h>
 
 #if defined(__LITTLE_ENDIAN)
-# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-#  include <linux/unaligned/le_struct.h>
-#  include <linux/unaligned/be_byteshift.h>
-# endif
-# include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_le
 # define put_unaligned	__put_unaligned_le
 #elif defined(__BIG_ENDIAN)
-# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-#  include <linux/unaligned/be_struct.h>
-#  include <linux/unaligned/le_byteshift.h>
-# endif
-# include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_be
 # define put_unaligned	__put_unaligned_be
 #else
diff --git a/include/linux/unaligned/be_struct.h b/include/linux/unaligned/be_struct.h
index 132415836c50..9ab8c53bb3fe 100644
--- a/include/linux/unaligned/be_struct.h
+++ b/include/linux/unaligned/be_struct.h
@@ -2,35 +2,36 @@
 #define _LINUX_UNALIGNED_BE_STRUCT_H
 
 #include <linux/unaligned/packed_struct.h>
+#include <asm/byteorder.h>
 
 static inline u16 get_unaligned_be16(const void *p)
 {
-	return __get_unaligned_cpu16((const u8 *)p);
+	return be16_to_cpu((__le16 __force)__get_unaligned_cpu16((const u8 *)p));
 }
 
 static inline u32 get_unaligned_be32(const void *p)
 {
-	return __get_unaligned_cpu32((const u8 *)p);
+	return be32_to_cpu((__le32 __force)__get_unaligned_cpu32((const u8 *)p));
 }
 
 static inline u64 get_unaligned_be64(const void *p)
 {
-	return __get_unaligned_cpu64((const u8 *)p);
+	return be64_to_cpu((__le64 __force)__get_unaligned_cpu64((const u8 *)p));
 }
 
 static inline void put_unaligned_be16(u16 val, void *p)
 {
-	__put_unaligned_cpu16(val, p);
+	__put_unaligned_cpu16((u16 __force)cpu_to_be16(val), p);
 }
 
 static inline void put_unaligned_be32(u32 val, void *p)
 {
-	__put_unaligned_cpu32(val, p);
+	__put_unaligned_cpu32((u32 __force)cpu_to_be32(val), p);
 }
 
 static inline void put_unaligned_be64(u64 val, void *p)
 {
-	__put_unaligned_cpu64(val, p);
+	__put_unaligned_cpu64((u64 __force)cpu_to_be64(val), p);
 }
 
 #endif /* _LINUX_UNALIGNED_BE_STRUCT_H */
diff --git a/include/linux/unaligned/le_struct.h b/include/linux/unaligned/le_struct.h
index 088c4572faa8..64171ad0b100 100644
--- a/include/linux/unaligned/le_struct.h
+++ b/include/linux/unaligned/le_struct.h
@@ -2,35 +2,36 @@
 #define _LINUX_UNALIGNED_LE_STRUCT_H
 
 #include <linux/unaligned/packed_struct.h>
+#include <asm/byteorder.h>
 
 static inline u16 get_unaligned_le16(const void *p)
 {
-	return __get_unaligned_cpu16((const u8 *)p);
+	return le16_to_cpu((__le16 __force)__get_unaligned_cpu16((const u8 *)p));
 }
 
 static inline u32 get_unaligned_le32(const void *p)
 {
-	return __get_unaligned_cpu32((const u8 *)p);
+	return le32_to_cpu((__le32 __force)__get_unaligned_cpu32((const u8 *)p));
 }
 
 static inline u64 get_unaligned_le64(const void *p)
 {
-	return __get_unaligned_cpu64((const u8 *)p);
+	return le64_to_cpu((__le64 __force)__get_unaligned_cpu64((const u8 *)p));
 }
 
 static inline void put_unaligned_le16(u16 val, void *p)
 {
-	__put_unaligned_cpu16(val, p);
+	__put_unaligned_cpu16((u16 __force)cpu_to_le16(val), p);
 }
 
 static inline void put_unaligned_le32(u32 val, void *p)
 {
-	__put_unaligned_cpu32(val, p);
+	__put_unaligned_cpu32((u32 __force)cpu_to_le32(val), p);
 }
 
 static inline void put_unaligned_le64(u64 val, void *p)
 {
-	__put_unaligned_cpu64(val, p);
+	__put_unaligned_cpu64((u64 __force)cpu_to_le64(val), p);
 }
 
 #endif /* _LINUX_UNALIGNED_LE_STRUCT_H */
