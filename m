From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
Date: Thu, 14 Oct 2010 15:36:41 +0900
Message-ID: <20101014153641E.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
	<1287015899.10264.394.camel@mulgrave.site>
	<1287016477.10264.418.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:34624 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0JNGiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 02:38:52 -0400
In-Reply-To: <1287016477.10264.418.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 20:34:37 -0400
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2010-10-13 at 20:24 -0400, James Bottomley wrote:
> > On Wed, 2010-10-13 at 16:49 -0700, Linus Torvalds wrote:
> > > On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
> > > <James.Bottomley@suse.de> wrote:
> > > > This patch set fixes a couple of longstanding bugs in SCSI.  The VPD
> > > > patch fix a possible buffer overrun in the VPD code (only tripped if the
> > > > device has a huge number of VPD pages).  The other is where the status
> > > > return code on our BSG interface is wrongly right shifted one place.
> > > 
> > > Umm. That other patch seems to be utter crap.
> > > 
> > > > -       hdr->device_status = status_byte(rq->errors);
> > > > +       hdr->device_status = rq->errors && 0xff;
> > > 
> > > That's pure shit. Please look at it for one second, and don't send me
> > > crap like this.
> > 
> > What's wrong with it? device_status() is an ancient SCSI-1 macro that
> > dates from the time the status was left shifted by 1, which makes the
> > value wrong according to the sg interface spec.  We should really remove
> > it, but there's still a few ancient drivers using it.  the SG interface
> > requires the full status byte, which is what the bottom most byte of
> > req_errors is ... hence the change.
> 
> OK, right ... several people pointed out in private email that it was &&
> not & ... I'll fix it when I'm slightly less jet lagged.

Really sorry about that.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: fix incorrect device_status value

bsg incorrectly returns sg's masked_status value for device_status.

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..0c00870 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -426,7 +426,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
-- 
1.7.1


