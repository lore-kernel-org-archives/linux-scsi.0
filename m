From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/4] bsg: add SCSI transport-level request support
Date: Sat, 09 Jun 2007 22:16:43 +0900
Message-ID: <20070609221643M.fujita.tomonori@lab.ntt.co.jp>
References: <20070608133042I.fujita.tomonori@lab.ntt.co.jp>
	<20070609125936.GB1714@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:59471 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXFINQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jun 2007 09:16:41 -0400
In-Reply-To: <20070609125936.GB1714@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pw@osc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 3/4] bsg: add SCSI transport-level request support
Date: Sat, 9 Jun 2007 08:59:36 -0400

> fujita.tomonori@lab.ntt.co.jp wrote on Sat, 09 Jun 2007 00:12 +0900:
> > SCSI transport-level requests such as SAS management protocol (SMP)
> > skip blk_verify_command().
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/bsg.c         |   27 +++++++++++++++++++++------
> >  include/linux/bsg.h |    6 ++++++
> >  2 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 13ecc95..f2a9979 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -208,7 +208,11 @@ static int blk_fill_sgv4_hdr_rq(request_
> >  	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
> >  			   hdr->request_len))
> >  		return -EFAULT;
> > -	if (blk_verify_command(rq->cmd, has_write_perm))
> > +
> > +	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
> > +		if (blk_verify_command(rq->cmd, has_write_perm))
> > +			return -EPERM;
> > +	} else if (capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> 
> Do you mean !capable here?

Yeah, thanks. Seems that I added the wrong check after James tested
the SMP passthru patches.

Jens, here's an updated version.


>From e40b88ab7e1f295362139a504f7178f93e5e1da7 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 9 Jun 2007 22:08:03 +0900
Subject: [PATCH] bsg: add SCSI transport-level request support

SCSI transport-level requests such as SAS management protocol (SMP)
skip blk_verify_command().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |   27 +++++++++++++++++++++------
 include/linux/bsg.h |    6 ++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 13ecc95..461c9f5 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -208,7 +208,11 @@ static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, has_write_perm))
+
+	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
+		if (blk_verify_command(rq->cmd, has_write_perm))
+			return -EPERM;
+	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	/*
@@ -232,6 +236,8 @@ static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
 static int
 bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 {
+	int ret = 0;
+
 	if (hdr->guard != 'Q')
 		return -EINVAL;
 	if (hdr->request_len > BLK_MAX_CDB)
@@ -240,13 +246,22 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
 
-	/* not supported currently */
-	if (hdr->protocol || hdr->subprotocol)
-		return -EINVAL;
+	switch (hdr->protocol) {
+	case BSG_PROTOCOL_SCSI:
+		switch (hdr->subprotocol) {
+		case BSG_SUB_PROTOCOL_SCSI_CMD:
+		case BSG_SUB_PROTOCOL_SCSI_TRANSPORT:
+			break;
+		default:
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
 
 	*rw = hdr->dout_xfer_len ? WRITE : READ;
-
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0dd01f9..bd998ca 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -1,6 +1,12 @@
 #ifndef BSG_H
 #define BSG_H
 
+#define BSG_PROTOCOL_SCSI		0
+
+#define BSG_SUB_PROTOCOL_SCSI_CMD	0
+#define BSG_SUB_PROTOCOL_SCSI_TMF	1
+#define BSG_SUB_PROTOCOL_SCSI_TRANSPORT	2
+
 struct sg_io_v4 {
 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
-- 
1.4.4.4

