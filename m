From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Thu, 31 Oct 2013 08:49:05 -0700
Message-ID: <20131031154905.GA10451@infradead.org>
References: <1383224573-113346-1-git-send-email-hare@suse.de>
 <1383224573-113346-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3JaPtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2013 11:49:14 -0400
Content-Disposition: inline
In-Reply-To: <1383224573-113346-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

Looks reasonable to me, but a few minor nitpicks:

> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	if (scsi_host_eh_past_deadline(sdev->host)) {

I don't have the implementation of scsi_host_eh_past_deadline in my
local tree, but do we really need the host lock for it?

> +int
> +scsi_abort_command(struct scsi_cmnd *scmd)

Semms like this should be static and not exported in the current version
of the code?

