From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 6 Aug 2008 18:21:18 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0808061815360.27392@blonde.site>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>  <Pine.LNX.4.64.0808061629220.10184@blonde.site>
  <1218040613.7493.13.camel@localhost.localdomain> <1218041582.7493.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60112 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYHFRV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 13:21:29 -0400
In-Reply-To: <1218041582.7493.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, James Bottomley wrote:
> On Wed, 2008-08-06 at 09:36 -0700, James Bottomley wrote:
> > On Wed, 2008-08-06 at 16:34 +0100, Hugh Dickins wrote:
> > >   PQual=0  Device_type=0  RMB=1  version=0x00  [no conformance
> > > claimed]
> > 
> > We could try using this as the trigger.  I assume all DIF supporting
> > devices must also claim conformance to SPC3/SBC2 or higher?
> 
> Just to formalise it, that would be this patch.  Hugh, could you try it?

Almost: I had to #include <scsi/scsi.h> to get SCSI_2 for the build
somewhere (and a SCSI_2 seems to be worth 1 more than anyone else's 2),
then it worked just fine for me thanks.

Hugh

p.s. sorry for losing an I from the "[SCSI]" Subject

--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <scsi/scsi.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -426,7 +427,7 @@ static inline int scsi_device_enclosure(
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
-	return sdev->inquiry[5] & (1<<0);
+	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
