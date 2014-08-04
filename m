From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi/arcmsr: Add timeout module parameter
Date: Mon, 4 Aug 2014 04:15:52 -0700
Message-ID: <20140804111552.GA2494@infradead.org>
References: <alpine.GSO.2.00.1408022058560.609@hutcs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDLPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2014 07:15:53 -0400
Content-Disposition: inline
In-Reply-To: <alpine.GSO.2.00.1408022058560.609@hutcs>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ari Sundholm <asundhol@cs.hut.fi>
Cc: linux-scsi@vger.kernel.org

To modify the timeout on a queue please use blk_queue_rq_timeout in
the slave_configure method instead of poking directly into the block
timer, which won't work e.g. for the blk-mq path.

But this really needs an explanation on why you'd need a configurable
timeout to start with.

