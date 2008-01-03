From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/2] sg_ring: Gentler scsi merge
Date: Thu, 03 Jan 2008 11:42:43 +0200
Message-ID: <477CAE13.1030608@panasas.com>
References: <200801031800.02537.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9045 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754586AbYACJnw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 04:43:52 -0500
In-Reply-To: <200801031800.02537.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Thu, Jan 03 2008 at 9:00 +0200, Rusty Russell <rusty@rustcorp.com.au> wrote:
> OK, after wading through many scsi drivers, I decided to change tack and try 
> to provide a transition path.  This is in two stages:
> 
> 1) These two patches.  sg_ring used underneath, but if any driver asks for 
> scsi_sglist() they get a 2.6.24-style chained sg.  No other patches are 
> necessary.
> 
> 2) Once all chained-sg-needing scsi drivers change to use cmd->sg (ie. 
> sg_ring) directly, and the chained sg patches can be reverted.  scsi_sglist() 
> and scsi_sg_count() then become:
> 
> 	/* You should only use these if you never need chained sgs */
> 	static inline struct scatterlist *scsi_sglist(struct scsi_cmd *cmd)
> 	{
> 		BUG_ON(!list_empty(&cmd->sg->list));
> 		return &cmd->sg->sg[0];
> 	}
> 
> 	static unsigned int scsi_sg_count(struct scsi_cmd *cmd)
> 	{
> 		if (!cmd->sg)
> 			return 0;
> 		BUG_ON(!list_empty(&cmd->sg->list));
> 		return cmd->sg->num;
> 	}
> 
> Thanks,
> Rusty.

Look in the mailing list archives for the scsi_sgtable patches.
These did exactly what you do here. (OK 95% ;))
(only as a scsi subsystem not as a generic sg)

Boaz

