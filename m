From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: [Bug 11800] New: building SES support fails w/ gcc-3.4.5
Date: Thu, 23 Oct 2008 12:14:39 -0400
Message-ID: <200810231614.m9NGEg1p019191@colby.verdasys.com>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
 <20081021155240.851b69c3.akpm@linux-foundation.org>
 <200810221943.m9MJh8bR031381@colby.verdasys.com>
 <20081022133046.0fa7de8a.akpm@linux-foundation.org>
 <1224710227.6851.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colby.verdasys.com ([69.20.67.85]:40985 "EHLO
	colby.verdasys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYJWQPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 12:15:14 -0400
In-Reply-To: <1224710227.6851.50.camel@localhost.localdomain>
References: <bug-11800-11613@http.bugzilla.kernel.org/>
 <20081021155240.851b69c3.akpm@linux-foundation.org>
 <200810221943.m9MJh8bR031381@colby.verdasys.com>
 <20081022133046.0fa7de8a.akpm@linux-foundation.org>
 <1224710227.6851.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

At 17:17 10/22/2008, James Bottomley wrote:
 >On Wed, 2008-10-22 at 13:30 -0700, Andrew Morton wrote:
 >> OK, it's here:
 >>
 >> 	buf = kmalloc(vpd_len, GFP_KERNEL);
 >>
 >> it's a gcc bug.
 >>
 >> Please see if you can find some way to make it go away - perhaps change
 >> vpd_len's type to `int', things like that.
 >>
 >> Or use a different compiler version :(

i'm not worried about compiling this.  i already did a compilation 
without it and i'll be fine without SES.  i just selected it on the 
off chance i'd find time to play with it.  i was just doing my duty 
of reporting this to save others the trouble.

 >Could it be an optimisation issue?  The static oversize test relies on
 >the compiler optimising away a leg that can never be reached if the size
 >is under the max. If you do a make V=1 you'll see what optimisation
 >flags the compiler is using ... if it's -O2 then yes, the compiler
 >should be optimising stuff away and it's a clear compiler problem.  If
 >it's anything else, we might have a mis setting of the optimisation
 >level in the kernel build.

looks to me like -Os:
---
beej@dell linux-2.6.27.1]$ make V=1 drivers/scsi/ses.s
rm -f include/config/kernel.release
echo 2.6.27.1 > include/config/kernel.release
set -e; :; mkdir -p include/linux/; 	(echo \#define 
LINUX_VERSION_CODE 132635; echo '#define KERNEL_VERSION(a,b,c) (((a) 
<< 16) + ((b) << 8) + (c))';) < 
/usr/local/src/kernel/linux-2.6.27.1/Makefile > 
include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp 
-s include/linux/version.h include/linux/version.h.tmp; then rm -f 
include/linux/version.h.tmp; else :; mv -f 
include/linux/version.h.tmp include/linux/version.h; fi
set -e; :; mkdir -p include/linux/; 	if [ `echo -n "2.6.27.1" | wc -c 
` -gt 64 ]; then echo '"2.6.27.1" exceeds 64 characters' >&2; exit 1; 
fi; (echo \#define UTS_RELEASE \"2.6.27.1\";) < 
include/config/kernel.release > include/linux/utsrelease.h.tmp; if [ 
-r include/linux/utsrelease.h ] && cmp -s include/linux/utsrelease.h 
include/linux/utsrelease.h.tmp; then rm -f 
include/linux/utsrelease.h.tmp; else :; mv -f 
include/linux/utsrelease.h.tmp include/linux/utsrelease.h; fi
set -e; if [ -L include/asm ]; then asmlink=`readlink include/asm | 
cut -d '-' -f 2`; if [ "$asmlink" != "x86" ]; then echo "ERROR: the 
symlink include/asm points to asm-$asmlink but asm-x86 was expected"; 
echo "       set ARCH or save .config and run 'make mrproper' to fix 
it"; exit 1; fi; fi
if [ ! -L include/asm ]; then echo '  SYMLINK include/asm -> 
include/asm-x86'; if [ ! -d include/asm-x86 ]; then mkdir -p 
include/asm-x86; fi; ln -fsn asm-x86 include/asm; fi
mkdir -p .tmp_versions
make -f scripts/Makefile.build obj=scripts/basic
make -f scripts/Makefile.build obj=.
mkdir -p kernel/
mkdir -p arch/x86/kernel/
make -f scripts/Makefile.build obj=. missing-syscalls
   /bin/sh scripts/checksyscalls.sh gcc 
-Wp,-MD,./.missing-syscalls.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-redhat-linux/3.4.5/include -D__KERNEL__ 
-Iinclude  -I/usr/local/src/kernel/linux-2.6.27.1/arch/x86/include 
-include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Os -m64 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-DCONFIG_AS_CFI=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 
-mno-3dnow -Iinclude/asm-x86/mach-default -fomit-frame-pointer -g 
-Wdeclaration-after-statement  -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(missing_syscalls)" 
-D"KBUILD_MODNAME=KBUILD_STR(missing_syscalls)"
make -f scripts/Makefile.build obj=scripts
make -f scripts/Makefile.build obj=scripts/genksyms
make -f scripts/Makefile.build obj=scripts/mod
make -f scripts/Makefile.build obj=drivers/scsi drivers/scsi/ses.s
   gcc -Wp,-MD,drivers/scsi/.ses.s.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-redhat-linux/3.4.5/include -D__KERNEL__ 
-Iinclude  -I/usr/local/src/kernel/linux-2.6.27.1/arch/x86/include 
-include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Os -m64 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-DCONFIG_AS_CFI=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 
-mno-3dnow -Iinclude/asm-x86/mach-default -fomit-frame-pointer -g 
-Wdeclaration-after-statement  -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(ses)" 
-D"KBUILD_MODNAME=KBUILD_STR(ses)" -fverbose-asm -S -o 
drivers/scsi/ses.s drivers/scsi/ses.c
---

i'm happy to run any other easy-to-do tests in case you don't have 
access to a CentOS 4 box, but it should be easy to repro for anybody 
else that does.

cheers,
marc

