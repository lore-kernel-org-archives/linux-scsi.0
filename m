From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 19:13:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210260013.g9Q0DP105454@localhost.localdomain>
References: <pbadari@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_13117629260"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id RAA01410
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 17:13:36 -0700
In-Reply-To: Message from Badari Pulavarty <pbadari@us.ibm.com>
   of "Fri, 25 Oct 2002 15:23:09 PDT." <200210252223.g9PMN9a17551@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

This is a multipart MIME message.

--==_Exmh_13117629260
Content-Type: text/plain; charset=us-ascii

pbadari@us.ibm.com said:
> I Just tried the patch. No Luck. I get same panic as before... I am
> using qla2x00src-v6.03.00b6 driver on qla2200 fc controllers. 

Well, yours may be a qla bug.

However, I've tracked down my hang problem:  If a command is pushed back into 
the block queue as a REQ_SPECIAL using the blk_insert_request() API, it never 
has REQ_CMD cleared.  Eventually it comes back into scsi_request_fn() with 
both REQ_CMD and REQ_SPECIAL set.  This causes the I/O to be initialised again.

The fix is to clear REQ_CMD in blk_insert_request().

This may also be the cause of Patrick's Incorrect number of segments error.

James


--==_Exmh_13117629260
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/block/ll_rw_blk.c 1.123 vs edited =====
--- 1.123/drivers/block/ll_rw_blk.c	Fri Oct 18 12:41:37 2002
+++ edited/drivers/block/ll_rw_blk.c	Fri Oct 25 18:48:12 2002
@@ -1374,6 +1374,7 @@
 	 * must not attempt merges on this) and that it acts as a soft
 	 * barrier
 	 */
+	rq->flags &= ~REQ_CMD;
 	rq->flags |= REQ_SPECIAL | REQ_BARRIER;
 
 	rq->special = data;

--==_Exmh_13117629260--


