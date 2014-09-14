From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/20] scsi_error: format abort error message
Date: Sun, 14 Sep 2014 09:40:00 -0700
Message-ID: <20140914164000.GA12072@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-21-git-send-email-hare@suse.de>
 <20140906003305.GA18426@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C77D3B@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaINQkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Sep 2014 12:40:07 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C77D3B@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, Sep 13, 2014 at 01:07:11AM +0000, Elliott, Robert (Server Storage) wrote:
> > I've not seen an answer to my question in reply to the previous version
> > of this.  Why would you do pretty printing of a variable that can just
> > return SUCCESS or FAILURE?
> 
> Is there anything prohibiting the scsi_eh_abort_handler provided by
> the LLD from returning any of the other values like NEEDS_RETRY?

Right now there is nothing prohibiting them from returning any possible
value, but we only handle SUCCESS specially and treat everything else
as FAILED.

If anyone is motivated enough to make this cleaner we should add a
WARN_ON for any other value as it's a driver bug.
