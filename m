From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: make asynchronous aborts mandatory
Date: Tue, 4 Nov 2014 10:52:49 -0800
Message-ID: <20141104185249.GA30233@infradead.org>
References: <1415103073-90276-1-git-send-email-hare@suse.de>
 <1415103073-90276-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKDSww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 13:52:52 -0500
Content-Disposition: inline
In-Reply-To: <1415103073-90276-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

This leaves a stale comment reference to scsi_eh_abort_cmds in libsas.
Also while grepping for that I found out that sas aborts don't work
anymore with the async abort code due to this beautiful code in
sas_eh_abort_handler:

	if (current != host->ehandler)
		return FAILED;

so you'll need another patch to fix that up.  In the longer run we
really should both kill sas_eh_abort_handler and bring SAS EH
more in line with the rest of the world.
