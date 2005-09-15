From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH ] fusion SAS support (mptsas driver)
Date: Thu, 15 Sep 2005 13:17:14 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0407A5B2@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5BA2A.143DB720"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42480 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964896AbVIOTRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 15:17:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5BA2A.143DB720
Content-Type: text/plain;
	charset="iso-8859-1"

On Thursday, September 15, 2005 6:22 AM, Christoph Hellwig wrote:
> 
> On Wed, Sep 14, 2005 at 06:09:10PM -0600, Moore, Eric Dean wrote:
> > I've reviewed patches today: 
> > [PATCH 1/2] fusion core changes for SAS support
> > [PATCH 2/2] fusion SAS support (mptsas driver)
> > (However the driver oops when loading - sent
> > email earlier today on that).
> > 
> > 
> > These previous patches were posted last Friday
> > seem fine, however I recommend we add the following 
> > changes, and I've provided a patch attached to this email.
> 
> Looks good to me, except for the spurious scsi_print_command prototype
> in mptscsih.h.  However this will conflict really badly with James
> generic DV work..
>

The attached patch addresses that concern.  

James - please apply.

I'm satisfied with the two patches that Christoph 
supplied last week; along with my post yesterday
and this attached patch.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>




 


------_=_NextPart_000_01C5BA2A.143DB720
Content-Type: application/octet-stream;
	name="mptfusion.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-09-14 17:23:32.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-09-15 12:46:28.000000000 =
-0600=0A=
@@ -62,6 +62,7 @@=0A=
 #include <scsi/scsi_device.h>=0A=
 #include <scsi/scsi_host.h>=0A=
 #include <scsi/scsi_tcq.h>=0A=
+#include <scsi/scsi_dbg.h>=0A=
 =0A=
 #include "mptbase.h"=0A=
 #include "mptscsih.h"=0A=
diff -uarN b/drivers/message/fusion/mptscsih.h =
a/drivers/message/fusion/mptscsih.h=0A=
--- b/drivers/message/fusion/mptscsih.h	2005-09-14 17:15:30.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.h	2005-09-15 12:45:52.000000000 =
-0600=0A=
@@ -106,4 +106,3 @@=0A=
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);=0A=
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int =
qdepth);=0A=
 extern void mptscsih_timer_expired(unsigned long data);=0A=
-extern void scsi_print_command(struct scsi_cmnd *cmd);=0A=

------_=_NextPart_000_01C5BA2A.143DB720--
