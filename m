From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/6] bsg: add sg_io_v4 structure
Date: Fri, 22 Dec 2006 13:46:35 +0900
Message-ID: <20061222134635M.fujita.tomonori@lab.ntt.co.jp>
References: <20061220101314.GL5010@kernel.dk>
	<20061221072942N.fujita.tomonori@lab.ntt.co.jp>
	<20061221072809.GM10535@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:47109 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945924AbWLVEqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2006 23:46:21 -0500
In-Reply-To: <20061221072809.GM10535@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, dougg@torque.net

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/6] bsg: add sg_io_v4 structure
Date: Thu, 21 Dec 2006 08:28:23 +0100

> On Thu, Dec 21 2006, FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH 4/6] bsg: add sg_io_v4 structure
> > Date: Wed, 20 Dec 2006 11:13:14 +0100
> > 
> > > On Wed, Dec 20 2006, FUJITA Tomonori wrote:
> > > > This patch adds sg_io_v4 structure that Doug proposed last month.
> > > > 
> > > > There's one major change from the RFC. I dropped iovec, which needs
> > > > compat stuff. The bsg code simply calls blk_rq_map_user against
> > > > dout_xferp/din_xferp. So if possible, the page frames are directly
> > > > mapped. If not possible, the block layer allocates new page frames and
> > > > does memory copies.
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > ---
> > > >  include/linux/bsg.h |   43 +++++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 43 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/include/linux/bsg.h b/include/linux/bsg.h
> > > > index dc0d728..0d212cc 100644
> > > > --- a/include/linux/bsg.h
> > > > +++ b/include/linux/bsg.h
> > > > @@ -1,6 +1,47 @@
> > > >  #ifndef BSG_H
> > > >  #define BSG_H
> > > >  
> > > > +struct sg_io_v4 {
> > > > +	int32_t guard;		/* [i] 'Q' to differentiate from v3 */
> > > > +	uint32_t protocol;	/* [i] 0 -> SCSI , .... */
> > > 
> > > I prefer using the u32 types and so on for explicitly sized variables.
> > > I'll make that change.
> > 
> > I see though we need to use __u32 instead of u32, don't we?
> 
> Yep, we should.

Are you waiting for a patch?

---
>From 94512209b34bf05ff8ee7830889cd811f0ef17fe Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 22 Dec 2006 09:23:03 +0900
Subject: [PATCH] Replace s32, u32 and u64 with __s32, __u32 and __u64 in bsg.h for userspace

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---
 include/linux/bsg.h |   58 +++++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index f968726..2154a6d 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -2,42 +2,42 @@ #ifndef BSG_H
 #define BSG_H
 
 struct sg_io_v4 {
-	s32 guard;		/* [i] 'Q' to differentiate from v3 */
-	u32 protocol;		/* [i] 0 -> SCSI , .... */
-	u32 subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
+	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
+	__u32 protocol;		/* [i] 0 -> SCSI , .... */
+	__u32 subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
 				   management function, .... */
 
-	u32 request_len;	/* [i] in bytes */
-	u64 request;		/* [i], [*i] {SCSI: cdb} */
-	u32 request_attr;	/* [i] {SCSI: task attribute} */
-	u32 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
-	u32 request_priority;	/* [i] {SCSI: task priority} */
-	u32 max_response_len;	/* [i] in bytes */
-	u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
+	__u32 request_len;	/* [i] in bytes */
+	__u64 request;		/* [i], [*i] {SCSI: cdb} */
+	__u32 request_attr;	/* [i] {SCSI: task attribute} */
+	__u32 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
+	__u32 request_priority;	/* [i] {SCSI: task priority} */
+	__u32 max_response_len;	/* [i] in bytes */
+	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
 
 	/* "din_" for data in (from device); "dout_" for data out (to device) */
-	u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
-	u32 din_xfer_len;	/* [i] bytes to be transferred from device */
-	u64 dout_xferp;		/* [i], [*i] */
-	u64 din_xferp;		/* [i], [*o] */
+	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
+	__u64 dout_xferp;	/* [i], [*i] */
+	__u64 din_xferp;	/* [i], [*o] */
 
-	u32 timeout;		/* [i] units: millisecond */
-	u32 flags;		/* [i] bit mask */
-	u64 usr_ptr;		/* [i->o] unused internally */
-	u32 spare_in;		/* [i] */
+	__u32 timeout;		/* [i] units: millisecond */
+	__u32 flags;		/* [i] bit mask */
+	__u64 usr_ptr;		/* [i->o] unused internally */
+	__u32 spare_in;		/* [i] */
 
-	u32 driver_status;	/* [o] 0 -> ok */
-	u32 transport_status;	/* [o] 0 -> ok */
-	u32 device_status;	/* [o] {SCSI: command completion status} */
-	u32 retry_delay;	/* [o] {SCSI: status auxiliary information} */
-	u32 info;		/* [o] additional information */
-	u32 duration;		/* [o] time to complete, in milliseconds */
-	u32 response_len;	/* [o] bytes of response actually written */
-	s32 din_resid;		/* [o] actual_din_xfer_len - din_xfer_len */
-	u32 generated_tag;	/* [o] {SCSI: task tag that transport chose} */
-	u32 spare_out;		/* [o] */
+	__u32 driver_status;	/* [o] 0 -> ok */
+	__u32 transport_status;	/* [o] 0 -> ok */
+	__u32 device_status;	/* [o] {SCSI: command completion status} */
+	__u32 retry_delay;	/* [o] {SCSI: status auxiliary information} */
+	__u32 info;		/* [o] additional information */
+	__u32 duration;		/* [o] time to complete, in milliseconds */
+	__u32 response_len;	/* [o] bytes of response actually written */
+	__s32 din_resid;	/* [o] actual_din_xfer_len - din_xfer_len */
+	__u32 generated_tag;	/* [o] {SCSI: task tag that transport chose} */
+	__u32 spare_out;	/* [o] */
 
-	u32 padding;
+	__u32 padding;
 };
 
 #ifdef __KERNEL__
-- 
1.4.3.2

