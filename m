From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 16:02:25 -0600
Message-ID: <20070222220225.GC14162@beardog.cca.cpqcorp.net>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org> <20070222165123.GC2672@beardog.cca.cpqcorp.net> <20070222132434.d84d3248.akpm@linux-foundation.org> <1172180484.3378.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:49599 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXBVWCm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 17:02:42 -0500
Content-Disposition: inline
In-Reply-To: <1172180484.3378.34.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Thu, Feb 22, 2007 at 03:41:24PM -0600, James Bottomley wrote:
> On Thu, 2007-02-22 at 13:24 -0800, Andrew Morton wrote:
> > > On Thu, 22 Feb 2007 10:51:23 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > > On Wed, Feb 21, 2007 at 07:14:27PM -0800, Andrew Morton wrote:
> > > > On Wed, 21 Feb 2007 15:10:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > > > 
> > > > > Patch 1/2
> > > > > +  	if (total_size == 0xFFFFFFFF) {
> > > > 
> > > > I seem to remember having already questioned this.  total_size is sector_t, which
> > > > can be either 32-bit or 64-bit.  Are you sure that comparison works as
> > > > intended in both cases?
> > > > 
> > > > 
> > > > > +		if(total_size == 0xFFFFFFFF) {
> > > > >  			cciss_read_capacity_16(cntl_num, i, 0,
> > > > >  			&total_size, &block_size);
> > > > >  			hba[cntl_num]->cciss_read = CCISS_READ_16;
> > > > 
> > > > Here too.
> > > It has worked in all of the configs I've tested. Should I change it from sector_t to a
> > > __64? I have not tested all possible configs.
> > > 
> > 
> > I'd suggest using -1: that just works.
> 
> Actually, no, that won't work.
> 
> This is a SCSI heuristic for determining when to use the 16 byte version
> of the read capacity command.  The 10 byte command can only return 32
> bits of information (this is in sectors, so it returns up to 2TB of
> bytes).
> 
> The heuristic requirement is that if the size is exactly 0xffffffff then
> you should try the 16 byte command (which can return 64 bits of
> information).  If that fails then you assume the 0xfffffff is a real
> size otherwize, you assume it was truncated and take the real result
> from the 16 byte command.
> 
> You can see a far more elaborate version of this in operation in
> sd.c:sd_read_capacity().
> 
> The only thing I'd suggest is to use 0xFFFFFFFFULL as the constant to
> prevent sign extension issues.
> 
> James
> 
> 
Will this patch for my patch work for now?


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1abf1f5..a1f1d9f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1303,7 +1303,7 @@ static void cciss_update_drive_info(int 
 
   	/* if read_capacity returns all F's this volume is >2TB in size */
   	/* so we switch to 16-byte CDB's for all read/write ops */
-  	if (total_size == 0xFFFFFFFF) {
+  	if (total_size == 0xFFFFFFFFULL) {
 		cciss_read_capacity_16(ctlr, drv_index, 1,
 		&total_size, &block_size);
 		h->cciss_read = CCISS_READ_16;
@@ -3129,7 +3129,7 @@ #endif				/* CCISS_DEBUG */
 
 		/* If read_capacity returns all F's the logical is >2TB */
 		/* so we switch to 16-byte CDBs for all read/write ops */
-		if(total_size == 0xFFFFFFFF) {
+		if(total_size == 0xFFFFFFFFULL) {
 			cciss_read_capacity_16(cntl_num, i, 0,
 			&total_size, &block_size);
 			hba[cntl_num]->cciss_read = CCISS_READ_16;
