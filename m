From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [3/3] add MODULE_VERSION to drivers/scsi
Date: Thu, 22 Jul 2004 09:07:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040722140753.GA30968@lists.us.dell.com>
References: <20040721220111.GA16608@lists.us.dell.com> <20040721220258.GD16608@lists.us.dell.com> <20040722122823.GC4227@parcelfarce.linux.theplanet.co.uk> <20040722133855.GA30314@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:28271 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S265946AbUGVOIs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2004 10:08:48 -0400
Content-Disposition: inline
In-Reply-To: <20040722133855.GA30314@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com


On Thu, Jul 22, 2004 at 08:38:55AM -0500, Matt Domsch wrote:
> On Thu, Jul 22, 2004 at 01:28:23PM +0100, Matthew Wilcox wrote:
> > > +#define SYM_VERSION "2.1.18j"
> > > +#define SYM_DRIVER_NAME	"sym-" SYM_VERSION
> > 
> > Umm.  No.  This is ridiculous.  I'm not having a 51 line copyright message
> > with 2 lines of #define.  It's not even clear to me that these two lines
> > have artisitic merit.  How about putting these defines in sym_defs.h,
> > at the top?  It's already included in both sym_glue.c and sym_hipd.c by
> > being included by sym_glue.h.
> 
> Indeed, point well taken.  Done, they're now at the top of defines in
> sym_defs.h, and I've updated my BK tree accordingly.

whole patch to sym53c8xx_2 below.

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

diff -urNp --exclude-from=/mdomsch2/excludes --minimal ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_defs.h linux-2.5/drivers/scsi/sym53c8xx_2/sym_defs.h
--- ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_defs.h	2004-07-22 10:10:50.277283936 -0400
+++ linux-2.5/drivers/scsi/sym53c8xx_2/sym_defs.h	2004-07-22 10:12:02.931238856 -0400
@@ -53,6 +53,9 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
+#define SYM_VERSION "2.1.18j"
+#define SYM_DRIVER_NAME	"sym-" SYM_VERSION
+
 /*
  *  Vendor.
  */
diff -urNp --exclude-from=/mdomsch2/excludes --minimal ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c
--- ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-07-22 10:10:50.646227848 -0400
+++ linux-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-07-22 10:12:02.973232472 -0400
@@ -2283,6 +2283,7 @@ static int sym_detach(struct sym_hcb *np
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(SYM_VERSION);
 
 /*
  * Driver host template.
diff -urNp --exclude-from=/mdomsch2/excludes --minimal ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_hipd.c linux-2.5/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- ../linux-2.5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-07-22 10:10:50.736214168 -0400
+++ linux-2.5/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-07-22 10:12:02.985230648 -0400
@@ -49,10 +49,6 @@
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
  */
-
-#define SYM_VERSION "2.1.18j"
-#define SYM_DRIVER_NAME	"sym-" SYM_VERSION
-
 #include "sym_glue.h"
 #include "sym_nvram.h"
 
