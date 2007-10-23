From: Dave Jones <davej@redhat.com>
Subject: Re: Add ACCUSYS RAID driver for Linux i386/x86-64
Date: Mon, 22 Oct 2007 23:07:02 -0400
Message-ID: <20071023030701.GC7793@redhat.com>
References: <cbc61c0d0710220317w68f4f119xceb10192f2ad0158@mail.gmail.com> <cbc61c0d0710221845h46f40d6p435f994b88a92b89@mail.gmail.com> <20071022.190253.95509114.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbXJWDHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 23:07:08 -0400
Content-Disposition: inline
In-Reply-To: <20071022.190253.95509114.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: accusys.sw5@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:02:53PM -0700, David Miller wrote:
 > From: "Peter Chan" <accusys.sw5@gmail.com>
 > Date: Tue, 23 Oct 2007 09:45:48 +0800
 > 
 > > Add linux-scsi and linux-kernel in mail group.
 > 
 > Please do not post your driver as a "RAR" attachment,
 > not only are most Linux folks not familiar with this
 > archive format, it is also an attachment type rejected
 > by just about every large email service provider out
 > there.

Before resubmitting this in a different format, this looks
like it will need quite a bit of work before it's
in mergable state.

Just from a quick skim..

* Why are there separate drivers for i386 and x86-64 ?
  (With i386 and x86-64 now being one arch/ this makes even
   less sense)
  Typically in Linux we have one driver capable of driving
  the hardware, regardless of which architecture it's running on.

  The differences between the two seem to be locking related,
  which makes this look even more odd.

* lots of #ifdef LINUX_VERSION_CODE > 2.5.0 and similar.
  These should just be removed.

* None of this should be necessary..

#include <linux/version.h>

#if defined(CONFIG_MODVERSIONS) && !defined(MODVERSIONS)
        #define MODVERSIONS
#endif

/* modversions.h should be before module.h */
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)
        #if defined(MODVERSIONS)
                #include <config/modversions.h>
        #endif
#endif


* Don't use absolute paths in includes
       #include "/usr/src/linux/drivers/scsi/scsi.h"
        #include "/usr/src/linux/drivers/scsi/hosts.h"
        #include "/usr/src/linux/drivers/scsi/constants.h"
        #include "/usr/src/linux/drivers/scsi/sd.h"

  There's no guarantee (or need) for kernel source to be there.

* Instead of reinventing a linked list implementation, use
  the one from <linux/list.h>

* Use <linux/types.h> instead of reinventing your own.

* Remove pointless wrappers like..

#define iowrite32 writel
#define ioread32 readl

  and just use the functions directly.

* This raises some eyebrows..

        #include "/usr/src/linux/drivers/scsi/scsi_module.c"

  Asides from the absolute path problem, no new drivers
  should be using this file. There's even a helpful comment
  inside that file telling you this.

* This isn't nice..

#define AllocRequestIndex(ResIndex)\
{\
        /*DISABLE_IRQ();*/\
        AllocRequest++;\
        if (RequestHead == NULL) PANIC("Request FULL");\
        ResIndex = RequestHead;\
        ResIndex->InUsed = TRUE;\
        RequestHead = RequestHead->Next;\
        /*ENABLE_IRQ();*/\
}

  Drivers should never panic the box unless something
  seriously critical is happening. An allocation failure
  doesn't sound particularly catastrophic.

* You don't need to redefine the SCSI opcodes, they are
  already defined for you in <scsi/scsi.h>


I stopped reading at this point.  There's probably more lurking
under that, and scripts/checkpatch.pl will probably pick up
another bunch of nits.

	Dave

-- 
http://www.codemonkey.org.uk
