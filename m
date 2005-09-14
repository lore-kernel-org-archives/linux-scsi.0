From: Anton Blanchard <anton@samba.org>
Subject: Re: 2.6.13-mm3 and 2.6.14-rc1 both broken (SCSI?)
Date: Thu, 15 Sep 2005 00:09:29 +1000
Message-ID: <20050914140928.GD30336@krispykreme>
References: <20050728025840.0596b9cb.akpm@osdl.org> <319880000.1126708349@[10.10.2.4]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:5001 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S965217AbVINOlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 10:41:25 -0400
Content-Disposition: inline
In-Reply-To: <319880000.1126708349@[10.10.2.4]>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


Hi,

> Heh, when I said "wheeeeeee - it all works" (with flip fixes) ... 
> I spoke too soon.
> 
> It's now broken in both -mm3 and -git 
> Some scsi problem on one of hte power boxes:
> 
> http://test.kernel.org/12729/debug/console.log
> 
> Attached scsi disk sdb at scsi0, channel 0, id 9, lun 0
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
> sdc: Spinning up disk....<6> target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
>  target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)

Try this dodgy workaround.

Anton

Index: build/drivers/scsi/scsi_lib.c
===================================================================
--- build.orig/drivers/scsi/scsi_lib.c	2005-09-14 18:23:34.000000000 +1000
+++ build/drivers/scsi/scsi_lib.c	2005-09-14 18:27:33.000000000 +1000
@@ -188,7 +188,7 @@
 	 * function.  The SCSI request function detects the blocked condition
 	 * and plugs the queue appropriately.
          */
-	scsi_unprep_request(req);
+	//scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
