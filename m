From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/2] sg_ring: Gentler scsi merge
Date: Thu, 3 Jan 2008 18:00:02 +1100
Message-ID: <200801031800.02537.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:43603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYACHAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 02:00:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

OK, after wading through many scsi drivers, I decided to change tack and try 
to provide a transition path.  This is in two stages:

1) These two patches.  sg_ring used underneath, but if any driver asks for 
scsi_sglist() they get a 2.6.24-style chained sg.  No other patches are 
necessary.

2) Once all chained-sg-needing scsi drivers change to use cmd->sg (ie. 
sg_ring) directly, and the chained sg patches can be reverted.  scsi_sglist() 
and scsi_sg_count() then become:

	/* You should only use these if you never need chained sgs */
	static inline struct scatterlist *scsi_sglist(struct scsi_cmd *cmd)
	{
		BUG_ON(!list_empty(&cmd->sg->list));
		return &cmd->sg->sg[0];
	}

	static unsigned int scsi_sg_count(struct scsi_cmd *cmd)
	{
		if (!cmd->sg)
			return 0;
		BUG_ON(!list_empty(&cmd->sg->list));
		return cmd->sg->num;
	}

Thanks,
Rusty.
