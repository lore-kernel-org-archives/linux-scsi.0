From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 11:00:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400D5E9F.8030802@us.ibm.com>
References: <20040120132052.GA6740@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:51156 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265572AbUATRAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 12:00:33 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> We all know talk is cheap, so here's a first draft patch to allow LLDDs
> to get control first after a command timeout.  Justin, does this look
> okay for you?  BTW, your drivers are the last ones using scsi_add_timer
> from outside the midlayer, if we could get rid of that we'd be able to
> keep the interface private.

If we get rid of scsi_add_timer, could we have a scsi_mod_timer? In the 
ipr driver I submitted, I would like to be able to simply double the 
timeout value, I don't necessarily want to change the timeout policy. 
The adapter firmware is already timing each command, so I would like to 
use that as the primary timing mechanism if possible.

For normal SCSI devices under this adapter I could change the philosophy 
and not let the adapter time the commands, but for disk array devices, 
the timeout value for reads/writes is too short.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

