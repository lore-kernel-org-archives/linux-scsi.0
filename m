From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Sat, 10 Jun 2006 10:36:22 -0500
Message-ID: <1149953782.3335.7.camel@mulgrave.il.steeleye.com>
References: <200605101704.27491.linux@highpoint-tech.com>
	 <200605121107.48597.linux@highpoint-tech.com>
	 <200605161438.09717.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50854 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751158AbWFJPgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 11:36:31 -0400
In-Reply-To: <200605161438.09717.linux@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Tue, 2006-05-16 at 14:38 +0800, HighPoint Linux Team wrote: 
	_req = get_req(hba);
	if (_req == NULL) {
		dprintk("hptiop_queuecmd : no free req\n");
		scp->result = DID_BUS_BUSY << 16;
		goto cmd_done;
	}

This should be doing a return SCSI_MLQUEUE_HOST_BUSY.  DID_BUS_BUSY
doesn't do the resource contention counting that you want
(MLQUEUE_HOST_BUSY will wait until a command returns ... presumably
freeing up resources before trying another).


	/*
	 * hptiop_shutdown will flash controller cache.
	 */
	if (scp->cmnd[0] == SYNCHRONIZE_CACHE)  {
		scp->result = DID_OK<<16;
		goto cmd_done;
	}

Are you really sure you want to do this?  It looks like we'll be doing
this in cases where shutdown won't be called (like suspend). 

	host->can_queue = le32_to_cpu(iop_config.max_requests);
	host->cmd_per_lun = le32_to_cpu(iop_config.max_requests);

You might want to think about adjusting this.  For the single LUN case,
it's fine.  For the multi-lun case it may allow commands to a single LUN
to starve everything else.

However, these are minor points ... I'll put the driver in and you can
fix them up later.

James


