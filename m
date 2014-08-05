From: Ari Sundholm <asundhol@cs.hut.fi>
Subject: Re: [PATCH] scsi/arcmsr: Add timeout module parameter
Date: Tue, 5 Aug 2014 16:10:08 +0300 (EEST)
Message-ID: <alpine.GSO.2.00.1408051559160.13057@hutcs>
References: <alpine.GSO.2.00.1408022058560.609@hutcs> <20140804111552.GA2494@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.hut.fi ([130.233.192.7]:48085 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbaHENKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 09:10:11 -0400
In-Reply-To: <20140804111552.GA2494@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


On Mon, 4 Aug 2014, Christoph Hellwig wrote:

> To modify the timeout on a queue please use blk_queue_rq_timeout in
> the slave_configure method instead of poking directly into the block
> timer, which won't work e.g. for the blk-mq path.

I see. It seems the way the driver Areca offers on its download page does 
this is wrong, then, as all I did was I ported the feature from there.
 
> But this really needs an explanation on why you'd need a configurable
> timeout to start with.

A colleague of mine has experienced problems with disks not supporting 
TLER performing lengthy error recovery, hitting a timeout. He has 
mitigated this problem by configuring the timeout to be long enough to 
allow for the error recovery to finish. And again, the driver offered by 
Areca supports this feature, so it seems they have their reasons as well.

Best regards,
Ari Sundholm
asundhol@cs.hut.fi

