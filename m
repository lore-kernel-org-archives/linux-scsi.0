From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EH method APIs
Date: Fri, 4 Apr 2014 00:42:07 -0700
Message-ID: <20140404074207.GA7586@infradead.org>
References: <20140404070408.GA30326@infradead.org>
 <533E5C81.60409@suse.de>
 <20140404072400.GA23630@infradead.org>
 <533E6116.2090206@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaDDHmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 03:42:11 -0400
Content-Disposition: inline
In-Reply-To: <533E6116.2090206@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 04, 2014 at 09:36:54AM +0200, Hannes Reinecke wrote:
> Have to look into this. Problem is that some eh_XXX callback
> implementations actually are using the command to send the TMF;
> will need to look into them how and if they could be changed.

That's indeed a bit of a problem, guess we need to do an audit
on how the commands are used at the moment.

> Actually, alongside with that change I would update the arguments
> to the callback functions to align with the strategy level;
> eh_device_reset() would be getting struct scsi_device as argument,
> eh_target_reset() would get getting struct scsi_target as argument etc.
> 
> So the actual SCSI EH would not be tied to struct scsi_cmnd, and we
> would just be needing something to send TUR etc in the course of
> SCSI EH.

Right.  I think the commands should go through the normal BLOCK_PC code
path, we'd just need to make sure they get priority in the request
allocator.
