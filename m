From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 10 Feb 2014 04:09:06 -0800
Message-ID: <20140210120906.GA24795@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124021.286457268@bombadil.infradead.org>
 <1391705819.22335.8.camel@dabdike>
 <52F3C21F.70409@acm.org>
 <1391723900.14985.3.camel@haakon3.risingtidesystems.com>
 <52F4B622.1070900@acm.org>
 <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
 <52F60E61.5040609@acm.org>
 <1391934408.25121.3.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBJMJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 07:09:12 -0500
Content-Disposition: inline
In-Reply-To: <1391934408.25121.3.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>

On Sun, Feb 09, 2014 at 12:26:48AM -0800, Nicholas A. Bellinger wrote:
> Again, try NOP'ing all REQ_TYPE_FS type commands immediately in
> ->queuecommand() in order to determine a baseline without any other LLD
> overhead involved.

Seems like this duplicates the fake_rw parameter.  Removing the needless
host_lock in queuecommand and maybe a few more optimizations would
certainly be more useful than duplicating the fake_rw parameter.

