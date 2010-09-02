From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: question about drivers/scsi/scsi_transport_fc.c
Date: Thu, 2 Sep 2010 12:53:26 +0200
Message-ID: <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44014 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0IBKx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 06:53:56 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o82Aref1028964
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 10:53:40 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o82ArbKj3866748
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 12:53:38 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o82ArZZW007514
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 12:53:36 +0200
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, joe@perches.com

On Sat, Aug 28, 2010 at 07:11:12PM +0200, Julia Lawall wrote:
> The function fc_bsg_goose_queue in the file drivers/scsi/scsi_transport_fc.c
> contains the following code:
> 
>         flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
>                   !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> 
> I have the impression that this is always 0.  QUEUE_FLAG_REENTER is 
> defined with quite a lot of other constants, so I don't really have a 
> guess as to what was intended.

I just came across the code in scsi_run_queue in
drivers/scsi/scsi_lib.c. It looks like the check of QUEUE_FLAG_REENTER
in fc_bsg_goose_queue is modeled after the check in scsi_run_queue.

The check in scsi_run_queue has been introduced with this commit,
maybe this helps understanding the code:

commit 04846f25920d4b05d6040c531cc601049260db52
Author: Andreas Herrmann <aherrman@de.ibm.com>
Date:   Wed Aug 9 17:31:16 2006 +0200

    [SCSI] limit recursion when flushing shost->starved_list

--
Christof
