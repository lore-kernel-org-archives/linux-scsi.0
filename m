From: Jens Axboe <jaxboe@fusionio.com>
Subject: scsi_transport_fc.c:fc_bsg_remove()
Date: Fri, 4 Mar 2011 13:43:18 +0100
Message-ID: <4D70DE66.8030201@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:34271 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525Ab1CDMnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 07:43:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: James Smart <james.smart@emulex.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>

Hi,

I came across this piece of code in the above mentioned function:

        /* need the lock to fetch a request
         * this may fetch the same reqeust as the previous pass
         */
         req = blk_fetch_request(q);
         /* save requests in use and starved */
         counts = q->rq.count[0] + q->rq.count[1] +
                  q->rq.starved[0] + q->rq.starved[1];

WTF? First of all, each request is ended if non-NULL. So why would it be
returning the same request as the previous pass? Secondly, what is the
below sum hoping to accomplish? It's a gross layering violation.

-- 
Jens Axboe

