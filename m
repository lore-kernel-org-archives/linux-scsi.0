From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI
 53C1030
Date: Fri, 17 Aug 2007 23:40:05 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708172333310.11211@filesrv1.baby-dragons.com>
References: <20070814232827.GA24388@lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.system-techniques.com ([204.91.156.41]:41512 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXHRGkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Aug 2007 02:40:12 -0400
In-Reply-To: <20070814232827.GA24388@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric ,

On Tue, 14 Aug 2007, Eric Moore wrote:
> Per request from Matthew Wilcox - using PCI_VENDOR_ATTO.
>
> Add support for ATTO UL4D, they are rebranded 53C1030.
> The changes are
> 1. Adding a new PCI vendor ID in pci table
> 2. The spi_port_page_2 is in different format than that of LSI generic
> spi_port_page_2 and hence mapping code is added.

 	Having a ul4d I decided to try out the patch you provided .  But ...

  root@(none):/usr/src/linux-2.6.22.1-iop1 # patch -p1 < ~/atto-ul4d-mptfusion.patch
patching file drivers/message/fusion/Kconfig
patching file drivers/message/fusion/mptbase.c
Hunk #1 succeeded at 4653 (offset -235 lines).
patching file drivers/message/fusion/mptbase.h
Hunk #1 succeeded at 193 (offset -1 lines).
patching file drivers/message/fusion/mptspi.c
Hunk #1 succeeded at 1189 (offset -1 lines).


root@(none):/usr/src/linux-2.6.22.1-iop1 # ( time make V=1 KBUILD_VERBOSE=1 INSTALL_PATH=/boot clean all install modules_install ) 2>&1 | tee ../linux-2.6.22.1c-reiser-xfs-lmsensors-EMMENSE-DEBUGGING_minus-I_oat-W_iop-patches-atto-ul4d-patch.log
...snip...
make -f scripts/Makefile.build obj=drivers/message
make -f scripts/Makefile.build obj=drivers/message/fusion
   gcc -m32 -Wp,-MD,drivers/message/fusion/.mptbase.o.d  -nostdinc -isystem 
/usr/lib/gcc/i486-slackware-linux/3.4.6/include -D__KERNEL__ -Iinclude  -include 
include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -O2 -pipe -msoft-float -mregparm=3 
-freg-struct-return -mpreferred-stack-boundary=2 -fno-unit-at-a-time -march=i686 
-ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 
-Iinclude/asm-i386/mach-default -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g  -Wdeclaration-after-statement 
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(mptbase)" 
-D"KBUILD_MODNAME=KBUILD_STR(mptbase)" -c -o drivers/message/fusion/mptbase.o 
drivers/message/fusion/mptbase.c
drivers/message/fusion/mptbase.c: In function `mpt_GetScsiPortSettings':
drivers/message/fusion/mptbase.c:4656: error: `PCI_VENDOR_ID_ATTO' undeclared (first use in this function)
drivers/message/fusion/mptbase.c:4656: error: (Each undeclared identifier is reported only once
drivers/message/fusion/mptbase.c:4656: error: for each function it appears in.)
make[3]: *** [drivers/message/fusion/mptbase.o] Error 1
make[2]: *** [drivers/message/fusion] Error 2
make[1]: *** [drivers/message] Error 2
make: *** [drivers] Error 2


  root@(none):/usr/src/linux # scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux (none) 2.6.21.5 #3 SMP Thu Jul 26 03:58:54 UTC 2007 i686 pentium4 i386 
GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.10
pcmciautils            014
pcmcia-cs              3.2.8
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
