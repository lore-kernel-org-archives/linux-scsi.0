From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch] zfcp: fix initialization of FSF timer
Date: Wed, 28 Mar 2007 14:20:40 +0200
Message-ID: <20070328122039.GB28667@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63669 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXC1MUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 08:20:43 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l2SCKgMW080706
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 12:20:42 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2SCKf1Z1442014
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 14:20:41 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2SCKfgq028782
	for <linux-scsi@vger.kernel.org>; Wed, 28 Mar 2007 14:20:41 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: swen@vnet.ibm.com, heiko.carstens@de.ibm.com

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Correctly initialize the timer for FSF requests with jiffies + timeout.

Cc: Swen Schillig <swen@vnet.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

Please consider this patch for 2.6.21.

 drivers/s390/scsi/zfcp_erp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux/drivers/s390/scsi/zfcp_erp.c.orig	2007-03-07 09:53:22.000000000 +0100
+++ linux/drivers/s390/scsi/zfcp_erp.c	2007-03-07 09:53:35.000000000 +0100
@@ -186,7 +186,7 @@
 {
 	fsf_req->timer.function = zfcp_fsf_request_timeout_handler;
 	fsf_req->timer.data = (unsigned long) fsf_req->adapter;
-	fsf_req->timer.expires = timeout;
+	fsf_req->timer.expires = jiffies + timeout;
 	add_timer(&fsf_req->timer);
 }
 
