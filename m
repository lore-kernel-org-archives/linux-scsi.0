From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Thu, 25 Jan 2007 22:35:47 +0100 (CET)
Message-ID: <tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14 Jan, James Bottomley wrote:
> The block layer currently provides sector (512) byte alignment
> guarantees.  However, there has been talk in SCSI of reducing that to
> word (4) since that's what most intelligent PCI controllers can cope
> with.  If you have any alignment constraints, they should be expressed
> in the slave configure.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: sbp2: lower block queue alignment requirement

The old setting is copy & waste from usb-storage and doesn't apply to
sbp2.  There is only 4-byte alignment required for everything, except
for S/G table elements which have to be 8-byte aligned according to the
SBP-2 spec.  (They happen to be ____cacheline_aligned in our
implementation.  Whether that's good is another question.)

We now simply don't tune block queue alignment at all.  The default
alignment would surely never become anything else than a multiple of 4,
else tons of calls to blk_queue_dma_alignment would have to be added
everywhere in drivers/...

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
@@ -51,7 +51,6 @@
  * Grep for inline FIXME comments below.
  */
 
-#include <linux/blkdev.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -2012,7 +2011,6 @@ static int sbp2scsi_slave_configure(stru
 {
 	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
 
-	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
 	sdev->use_10_for_rw = 1;
 
 	if (sdev->type == TYPE_ROM)



-- 
Stefan Richter
-=====-=-=== ---= ==--=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
