From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] FC Pass Thru support
Date: Wed, 15 Apr 2009 14:59:56 +0200
Message-ID: <20090415125956.GA12670@schmichrtp.de.ibm.com>
References: <1238088799.19995.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:57084 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZDOM77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 08:59:59 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n3FCxvsj018986
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 12:59:57 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3FCxvBW2928712
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 13:59:57 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3FCxvhJ026218
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 13:59:57 +0100
Content-Disposition: inline
In-Reply-To: <1238088799.19995.3.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 26, 2009 at 01:33:19PM -0400, James Smart wrote:
> 
> All,
> 
> Attached is the ELS/CT pass-thru patch for the FC Transport. The patch
> creates a generic framework that lays on top of bsg and the SGIO v4 ioctl
> in order to pass transaction requests to LLDD's.
> 
> The interface supports the following operations:
>   On an fc_host basis:
>     Request login to the specified N_Port_ID, creating an fc_rport.
>     Request logout of the specified N_Port_ID, deleting an fc_rport
>     Send ELS request to specified N_Port_ID w/o requiring a login, and
>       wait for ELS response.
>     Send CT request to specified N_Port_ID and wait for CT response.
>       Login is required, but LLDD is allowed to manage login and decide
>       whether it stays in place after the request is satisfied.
>     Vendor-Unique request. Allows a LLDD-specific request to be passed
>       to the LLDD, and the passing of a response back to the application.
>   On an fc_rport basis:
>     Send ELS request to nport and wait for ELS response.
>     Send CT request to nport and wait for CT response.
> 
> The patch also exports several headers from include/scsi such that
> they can be available to user-space applications:
>   include/scsi/scsi.h
>   include/scsi/scsi_netlink.h
>   include/scsi/scsi_netlink_fc.h
>   include/scsi/scsi_bsg_fc.h
> 
> For further information, refer to the last RFC:
> http://marc.info/?l=linux-scsi&m=123436574018579&w=2

This patch triggers the warning WARN_ON(!irqs_disabled()) in
blk_remove_plug, and the description of __blk_run_queue states:

/**
 * __blk_run_queue - run a single device queue
 * @q:  The queue to run
 *
 * Description:
 *    See @blk_run_queue. This variant must be called with the queue
 *    lock held and interrupts disabled.
 *
 */

I assume to get this right, fc_bsg_goose_queue should disable
interrupts when taking the queue lock. See patch below.

Christof
---
 drivers/scsi/scsi_transport_fc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c	2009-04-14 14:29:25.000000000 +0200
+++ b/drivers/scsi/scsi_transport_fc.c	2009-04-14 14:31:41.000000000 +0200
@@ -3707,13 +3707,14 @@ static void
 fc_bsg_goose_queue(struct fc_rport *rport)
 {
 	int flagset;
+	unsigned long flags;
 
 	if (!rport->rqst_q)
 		return;
 
 	get_device(&rport->dev);
 
-	spin_lock(rport->rqst_q->queue_lock);
+	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
 	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
 		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
 	if (flagset)
@@ -3721,7 +3722,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 	__blk_run_queue(rport->rqst_q);
 	if (flagset)
 		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock(rport->rqst_q->queue_lock);
+	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
 
 	put_device(&rport->dev);
 }
