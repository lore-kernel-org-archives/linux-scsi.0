From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 08:52:00 -0500
Message-ID: <1216216320.3230.1.camel@localhost.localdomain>
References: <1216138543.3312.60.camel@localhost.localdomain>
	 <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu>
	 <20080716131543.GA3673@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57913 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985AbYGPNwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 09:52:06 -0400
In-Reply-To: <20080716131543.GA3673@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2008-07-16 at 15:15 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > scsi_cmnd.h depends on symbols defined in blkdev.h. The fix is to 
> > > include blkdev.h as well.
> > 
> > that wont work - a better replacement fix is the one below. The 
> > problem is that scsi.h is included even on !CONFIG_BLOCK and then the 
> > BLK_MAX_CDB symbol is meaningless.
> 
> -v3 .. the new methods need to be under #ifdef CONFIG_BLOCK as well. 
> Note my patch is just a quick RFC, this can probably be done cleaner.

Erm, Ingo, if you'd just follow linux-next instead of your own tree,
you'd see there's already a fix for this.

James

----

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/compat_ioctl.c to handle CONFIG_BLOCK=n, CONFIG_SCSI=n
to avoid build errors:

In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h:27:25: warning:
"BLK_MAX_CDB" is not defined
linux-next-20080708/include/scsi/scsi_cmnd.h:28:3: error: #error
MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h: In function
'scsi_bidi_cmnd':
linux-next-20080708/include/scsi/scsi_cmnd.h:182: error: implicit
declaration of function 'blk_bidi_rq'
linux-next-20080708/include/scsi/scsi_cmnd.h:183: error: dereferencing
pointer to incomplete type
linux-next-20080708/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080708/include/scsi/scsi_cmnd.h:189: error: dereferencing
pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/compat_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20080708.orig/fs/compat_ioctl.c
+++ linux-next-20080708/fs/compat_ioctl.c
@@ -68,9 +68,11 @@
 #include <linux/capi.h>
 #include <linux/gigaset_dev.h>
 
+#ifdef CONFIG_BLOCK
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <linux/ethtool.h>
@@ -1965,6 +1967,7 @@ COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_FONTRESET)
 COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
+#ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
 COMPATIBLE_IOCTL(SCSI_IOCTL_DOORLOCK)
@@ -1974,6 +1977,7 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_GET_BUS_NUMB
 COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
 COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
+#endif
 /* Big T */
 COMPATIBLE_IOCTL(TUNSETNOCSUM)
 COMPATIBLE_IOCTL(TUNSETDEBUG)
@@ -2044,6 +2048,7 @@ COMPATIBLE_IOCTL(SIOCGIFVLAN)
 COMPATIBLE_IOCTL(SIOCSIFVLAN)
 COMPATIBLE_IOCTL(SIOCBRADDBR)
 COMPATIBLE_IOCTL(SIOCBRDELBR)
+#ifdef CONFIG_BLOCK
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
@@ -2068,6 +2073,7 @@ COMPATIBLE_IOCTL(SG_SCSI_RESET)
 COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
 COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
 COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
+#endif
 /* PPP stuff */
 COMPATIBLE_IOCTL(PPPIOCGFLAGS)
 COMPATIBLE_IOCTL(PPPIOCSFLAGS)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/


