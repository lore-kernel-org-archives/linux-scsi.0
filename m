From: Joachim Feise <jfeise@ics.uci.edu>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Fri, 20 Feb 2004 14:13:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4036867C.60803@ics.uci.edu>
References: <403512B8.2060403@ics.uci.edu>
Reply-To: jfeise@ics.uci.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scanner2.ics.uci.edu ([128.195.1.36]:22161 "EHLO
	scanner2.ics.uci.edu") by vger.kernel.org with ESMTP
	id S261315AbUBTWMi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 17:12:38 -0500
Received: from ics.uci.edu (doric.ics.uci.edu [128.195.20.215])
	by scanner2.ics.uci.edu (8.12.10/8.12.10) with ESMTP id i1KMCJP3016422
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2004 14:12:19 -0800 (PST)
In-Reply-To: <403512B8.2060403@ics.uci.edu>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Joachim Feise wrote on 2/19/2004 11:47:

> [1.] One line summary of the problem:
> 2.6.3 hangs when writing to scsi-dvd
> 
> [2.] Full description of the problem/report:
> 
> I have a DVD drive (BTC1004) connected via an IDE-SCSI bridge to
> an Adaptec 29160 host adapter.
> With kernel 2.6.3, I experience a complete system hang whenever I try
> to record data on a DVD.
> It requires a reboot.

More info:
on the cdwrite list, somebody reported a similar problem
(http://lists.debian.org/cdwrite/2004/cdwrite-200402/msg00081.html)

His quick-n-dirty fix works for me:

--- linux-2.6.3/drivers/scsi/scsi_lib.c.orig    2004-02-17 19:57:57.000000000 -0800
+++ linux-2.6.3/drivers/scsi/scsi_lib.c 2004-02-20 13:52:46.000000000 -0800
@@ -1292,7 +1292,7 @@
         * host adapters.  A host driver can alter this mask in its
         * slave_alloc() or slave_configure() callback if necessary.
         */
-       blk_queue_dma_alignment(q, (8 - 1));
+       /* blk_queue_dma_alignment(q, (8 - 1)); */

        if (!shost->use_clustering)
                clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);

But without knowing what this particular line does, it is impossible for me
to say if commenting out the line is the right thing to do.

-Joe

