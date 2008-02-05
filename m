From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic7xxx build failure
Date: Tue, 05 Feb 2008 12:30:56 -0600
Message-ID: <1202236256.3133.52.camel@localhost.localdomain>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
	 <1202235484.3133.49.camel@localhost.localdomain>
	 <20080205182441.GF505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46009 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbYBESbI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 13:31:08 -0500
In-Reply-To: <20080205182441.GF505@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Tue, 2008-02-05 at 20:24 +0200, Adrian Bunk wrote:
> On Tue, Feb 05, 2008 at 12:18:04PM -0600, James Bottomley wrote:
> > 
> > On Tue, 2008-02-05 at 19:40 +0200, Adrian Bunk wrote:
> > > Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> > > compilation:
> > > 
> > > <--  snip  -->
> > > 
> > > $ make O=../out/x86-full
> > > ...
> > >   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
> > >   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
> > >   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> > > gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> > > gcc: no input files
> > > make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> > 
> > Could you run this with V=1 to get us a verbose output of what the exact
> > files gcc is failing on are?
> 
> make -f /home/bunk/linux/kernel-2.6/git/linux-2.6/scripts/Makefile.build obj=drivers/scsi
> make -f /home/bunk/linux/kernel-2.6/git/linux-2.6/scripts/Makefile.build obj=drivers/scsi/aacraid
> (cat /dev/null; ) > drivers/scsi/aacraid/modules.order
> make -f /home/bunk/linux/kernel-2.6/git/linux-2.6/scripts/Makefile.build obj=drivers/scsi/aic7xxx
>   cat /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped > drivers/scsi/aic7xxx/aic79xx_seq.h
>   cat /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped > drivers/scsi/aic7xxx/aic79xx_reg.h
>   gcc -Wp,-MD,drivers/scsi/aic7xxx/.aic79xx_core.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux-gnu/4.2.3/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/bunk/linux/kernel-2.6/git/linux-2.6/include -include include/linux/autoconf.h -I/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/aic7xxx -Idrivers/scsi/aic7xxx -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -m32 -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 -march=athlon -ffreestanding -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -I/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-x86/mach-generic -Iinclude/asm-x86/mach-gen
 eric -I/home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-x86/mach-default -Iinclude/asm-x86/mach-default -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign -I/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi -Idrivers/scsi  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(aic79xx_core)"  -D"KBUILD_MODNAME=KBUILD_STR(aic79xx)" -c -o drivers/scsi/aic7xxx/aic79xx_core.o drivers/scsi/aic7xxx/aic79xx_core.c
> gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> gcc: no input files
> make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> make[3]: *** [drivers/scsi/aic7xxx] Error 2
> make[2]: *** [drivers/scsi] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2

Do I assume from this that you have different source and object
directories?  There shouldn't be a failure if this is building
in /home/bunk/linux/kernel-2.6/git/linux-2.6/ because the source file
should be there.

James


