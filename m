From: Jiann-Ming Su <jsu2@emory.edu>
Subject: megaraid2 compile problems
Date: Wed, 10 Mar 2004 12:02:17 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403101146510.8009-100000@callimachus.library.emory.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from portia.cc.emory.edu ([170.140.204.3]:56040 "EHLO
	portia.cc.emory.edu") by vger.kernel.org with ESMTP id S262698AbUCJRCV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 12:02:21 -0500
List-Id: linux-scsi@vger.kernel.org
To: Atul.Mukker@lsil.com
Cc: linux-scsi@vger.kernel.org

I just downloaded megaraid v2.10.1 driver.  I'm trying to build it against
a 2.4.20 kernel from RedHat.  As background info, this kernel came only
with the megaraid1 driver.  I copied the megaraid2 from a 2.4.24 kernel 
(v2.00.9), modified the scsi/Config.in and scsi/Makefile, and was able
to build a working kernel.

However, it looks like with v2.10.1, the Scsi_Host_Template structure
has changed, and now I get the following error during compile:

  gcc -D__KERNEL__ -I/usr/src/linux-ssi/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686   -nostdinc -iwithprefix include -DKBUILD_BASENAME=megaraid2  -c -o megaraid2.o megaraid2.c
  In file included from megaraid2.c:46:
  megaraid2.h:1087:1: warning: "ASSERT" redefined
  In file included from /usr/src/linux-ssi/include/cluster/ssi/rcopy.h:27,
                   from /usr/src/linux-ssi/include/asm/uaccess.h:11,
                   from megaraid2.c:36:
  /usr/src/linux-ssi/include/cluster/assert.h:38:1: warning: this is the location of the previous definition
  megaraid2.c:5655: error: unknown field `vary_io' specified in initializer
  megaraid2.c:5655: warning: initialization makes pointer from integer without a cast
  make[3]: *** [megaraid2.o] Error 1
  make[3]: Leaving directory `/usr/src/linux-ssi/drivers/scsi'
  make[2]: *** [first_rule] Error 2
  make[2]: Leaving directory `/usr/src/linux-ssi/drivers/scsi'
  make[1]: *** [_subdir_scsi] Error 2
  make[1]: Leaving directory `/usr/src/linux-ssi/drivers'
  make: *** [_dir_drivers] Error 2

It looks like vary_io is a new field in the SHT struct that's not defined.
I flipped through the megaraid-linux-2.4.24-megaraid-2.10.1.patch and didn't
see any reference to modifying the scsi/hosts.h file which SHT is defined.

I'm wanting to try the new driver because the current one seems to have
some strange disk access latency.  On a regular basis, my terminal will
pause for a few seconds before continuing, specifically with tab 
continuation in bash and opening any file.  

-- 
Jiann-Ming Su  jsu2@emory.edu  404-712-2603
Development Team Systems Administrator
General Libraries Systems Division

