From: Dan Aloni <da-x@monatomic.org>
Subject: [PATCH] scsi_execute_async() should add to the tail of the queue
Date: Tue, 19 Dec 2006 02:02:34 +0200
Message-ID: <20061219000234.GA5330@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noname.neutralserver.com ([70.84.186.210]:20611 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbWLSKcy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2006 05:32:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

Hello,

scsi_execute_async() has replaced scsi_do_req() a few versions ago, 
but it also incurred a change of behavior. I noticed that over-queuing 
a SCSI device using that function causes I/Os to be starved from 
low-level queuing for no justified reason.
 
I think it makes much more sense to perserve the original behaviour 
of scsi_do_req() and add the request to the tail of the queue.

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff -p -urN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2006-12-19 01:48:50.000000000 +0200
+++ b/drivers/scsi/scsi_lib.c	2006-12-19 01:49:35.000000000 +0200
@@ -421,7 +421,7 @@ int scsi_execute_async(struct scsi_devic
 	sioc->data = privdata;
 	sioc->done = done;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async);
+	blk_execute_rq_nowait(req->q, NULL, req, 0, scsi_end_async);
 	return 0;
 
 free_req:


-- 
Dan Aloni
XIV, http://www.xivstorage.com
