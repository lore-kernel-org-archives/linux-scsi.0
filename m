From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Thu, 22 Sep 2005 23:12:31 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509222309390.6022@kai.makisara.local>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
 <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>
 <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max>
 <432D97F2.5040508@cs.wisc.edu> <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
 <432D9D53.3070706@cs.wisc.edu> <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>
 <432F100D.7050007@cs.wisc.edu> <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:13533 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1030298AbVIVUHE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 16:07:04 -0400
In-Reply-To: <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, 20 Sep 2005, Kai Makisara wrote:

...
> If I try 5121 kB, write fails as is expected but not completely nicely. 
> Here are some test printks:
> 
> scsi_req_map_sg: q->back_merge failed, i=10
> st 1:0:5:0: extraneous data discarded.
> st 1:0:5:0: COMMAND FAILED (87 0 1).
> sym: cmd: 0x0a 0x00 0x50 0x04 0x00 0x00
> st: cmd=0x0a result=0x70000 resid=0 sense[0]=0x00 sense[2]=0x00
> 
> scsi_req_map_sg fails as it should but still a bogus SCSI command is sent. 
> I think the reason for this is simple but I don't want to delay the good 
> news by trying to debug this.
> 
The reason was simple: scsi_req_map_sg did not set err when q->back_merge 
failed. The patch at the end fixes the problem (I am not sure what would 
be the correct error code).

-- 
Kai

--- linux-2.6.14-rc1-blk3/drivers/scsi/scsi_lib.c.old	2005-09-22 22:57:53.000000000 +0300
+++ linux-2.6.14-rc1-blk3/drivers/scsi/scsi_lib.c	2005-09-22 22:58:14.000000000 +0300
@@ -360,6 +360,7 @@
 			blk_rq_bio_prep(q, rq, bio);
 		else if (!q->back_merge_fn(q, rq, bio)) {
 			bio_endio(bio, bio->bi_size, 0);
+			err = -ENOMEM;
 			goto free_bios;
 		} else {
 			rq->biotail->bi_next = bio;
