From: John Donnelly <jpd_hp_linux_scsi@yahoo.com>
Subject: 2.6-test4: mpspec.h:6:25: mach_mpspec.h: Missing file
Date: Thu, 4 Sep 2003 15:19:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904221927.22799.qmail@web20703.mail.yahoo.com>
References: <20030903170256.GA18025@fs.tum.de>
Reply-To: dead_emaill@nospam.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-818752078-1062713967=:22782"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web20703.mail.yahoo.com ([216.136.226.176]:21084 "HELO
	web20703.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265510AbTIDWT2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2003 18:19:28 -0400
In-Reply-To: <20030903170256.GA18025@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--0-818752078-1062713967=:22782
Content-Type: text/plain; charset=us-ascii
Content-Id: 
Content-Disposition: inline

Hi. 
I'm trying to build a (add-on) module 
on a machine booted from a 2.6-test4 kernel,
And keep running into this error. I've 
included the  gcc command line, sample
and the fatal error that mach_mpspec.h can't be found.

I built the kernel as :

make defconfig; 

It is a 2W SMP (Compaq ML850)
2 modes to select enet & SCSI device

make

My general question is, should I include the 

-I/work/src/<build>/include/asm-i386/mach-generic/mach_mpspec.h

in my gcc command line or is my build area incorrect
is
some way that the correct mpspec.h file can't be found ?

Thx. JD.

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
--0-818752078-1062713967=:22782
Content-Type: text/plain; name="test.txt"
Content-Description: test.txt
Content-Disposition: inline; filename="test.txt"

In file included from /work/src/linux-2.6.0-test4/include/asm/smp.h:18,
                 from /work/src/linux-2.6.0-test4/include/linux/smp.h:17,
                 from /work/src/linux-2.6.0-test4/include/linux/topology.h:33,
                 from /work/src/linux-2.6.0-test4/include/linux/mmzone.h:294,
                 from /work/src/linux-2.6.0-test4/include/linux/gfp.h:4,
                 from /work/src/linux-2.6.0-test4/include/linux/slab.h:15,
                 from test.c:8:
/work/src/linux-2.6.0-test4/include/asm/mpspec.h:6:25: mach_mpspec.h: No such file or directory
/work/src/linux-2.6.0-test4/include/asm/mpspec.h:8: `MAX_MP_BUSSES' undeclared here (not in a function)



 gcc -g -D__KERNEL__ -DMODULE -I/work/src/linux-2.6.0-test4/include \
	-I/work/src/linux-2.6.0-test4/drivers/scsi -c test.c

//  -- snip sample 

#include <linux/version.h>	// 2.6 ++
#include <linux/config.h>	// 2.6 ++
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/spinlock.h>
#include <asm/io.h>
#include <asm/system.h>
#include <linux/slab.h>
#include <linux/interrupt.h>  

#define MEMORY_TABLE_SIZE	512

void *
my_kmalloc(unsigned int size, char *id)
{
	char *ptr ;
	if ((ptr =
	     kmalloc(size,
		     (in_interrupt()? GFP_ATOMIC : GFP_KERNEL))) == NULL) {
		kprintf("Cannot allocate %u bytes for %s\n", size, id);
	}
}



--0-818752078-1062713967=:22782--
