From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and
	request
Date: Thu, 9 Jul 2009 09:37:46 -0400
Message-ID: <20090709133746.GA21929@infradead.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZGINh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 09:37:56 -0400
Content-Disposition: inline
In-Reply-To: <4A553DA4.4080408@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
> What's more disturbing to me is the different between RQ and BIO
> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
> positions.  Sadly it seems it's already too late to change that.  I
> personally an not a big fan of simple accessors or flags defined as
> bit positions.  They seem to obscure things without much benefit.

flags as bit positions generally only make sense if you use
test/set/clear_bit, otherwise they just confuse things.  And the
accessors are pretty annoying, especially in the block layer.  Trying to
find the places where a BIO flag has an actual effect is pretty painful
due to the mix of the different flags and the accessors.
