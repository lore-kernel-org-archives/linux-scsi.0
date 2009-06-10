From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Wed, 10 Jun 2009 19:01:39 +0900
Message-ID: <20090610190109N.fujita.tomonori@lab.ntt.co.jp>
References: <4A2F7B0F.1030205@panasas.com>
	<20090610183618T.fujita.tomonori@lab.ntt.co.jp>
	<4A2F8151.3010104@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37409 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZFJKBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 06:01:49 -0400
In-Reply-To: <4A2F8151.3010104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 10 Jun 2009 12:48:01 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > BTW, if you try to find a bio leak in the BSG SMP path, I guess that
> > it's worth looking at the bounce path. There might be a leak.
> 
> once a request was put on the queue, or even before that, once some
> memory was mapped. blk_end_request must be called by someone.
> More and more code relays on that. Not doing so is just plain playing
> with fire. Will you not agree?

As I said, I'll fix SMP BSG path to call blk_end_request_all().

IMO, the block layer API is vague before Tejun's recent
cleanups. Seems that everyone uses it (and its internal) in their own
ways. But now we should use it in the consistent way.
