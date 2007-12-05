From: malahal@us.ibm.com
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Wed, 5 Dec 2007 12:40:03 -0800
Message-ID: <20071205204003.GA29267@us.ibm.com>
References: <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com> <20071203024945.GO2584@parisc-linux.org> <20071203234703.GA16786@us.ibm.com> <20071204090053.GF23294@kernel.dk> <20071205200549.GA29135@us.ibm.com> <20071205201038.GE29561@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54027 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXLEUka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 15:40:30 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB5KeFgo031524
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 15:40:15 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB5Ke5IT500120
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 15:40:15 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB5Ke4pS002004
	for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 15:40:04 -0500
Content-Disposition: inline
In-Reply-To: <20071205201038.GE29561@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com

Jens Axboe [jens.axboe@oracle.com] wrote:
> ->timeout isn't used very much, so should not be too much work to
> console the two.
> 
> If you see any specific obstacles, do list them!

I believe it is used in blk_add_timer() which may be called:
1) First time sending the command to LLDs
   No problem. It would be set to correct value at that time.
2) called from blk_rq_timed_out() in response to BLK_EH_RESET_TIMER
   Without the actual timeout value, there is no way to res-set timer
   correctly.
3) Retry
   Same #2.

The other way is to remove the deadline field. That poses timing out
issues.

Thanks, Malahal.
