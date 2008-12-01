From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: integrate blk_end_bidi_request into
 blk_end_request
Date: Mon, 1 Dec 2008 18:59:40 +0900
Message-ID: <20081201185955R.fujita.tomonori@lab.ntt.co.jp>
References: <493274A7.5050404@panasas.com>
	<20081201170000N.fujita.tomonori@lab.ntt.co.jp>
	<4933B198.7090309@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33534 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYLAJ76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 04:59:58 -0500
In-Reply-To: <4933B198.7090309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, 01 Dec 2008 11:42:48 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> >> No. I do not want a loop to calculate the size here. This is ugly.
> >> I have this information, and I just lost it do to BAD API.
> > 
> > IMO, being ugly is better than confusing people.
> 
> Come on man. Ugly was an understatement. Can't you see?
> Make a loop for information we have and decided to drop on the floor.

Honestly, I can't see. Whatever you call the patch, the current API is
worse than it for me.


> > Do you think that the current API is good, which make developers
> > always wrongly use it and feel that they have to ask how to use and
> > add comments about necessary tricks to use it?
> > 
> 
> No I think (and said) that the API is crap. But not that bad that I want to
> take the effort and change it.
> 
> > 
> >> Since we do not want to change all users of blk_end_request. (We should,
> >> but we are too lazy. I'm). Then please just let blk_end_bidi_request()
> >> be. Confused users will be corrected.
> > 
> > No. blk_end_bidi_request interface and the name is confusing. So
> > forcing everyone to use blk_end_bidi_request doesn't help.
> > 
> 
> We should rename blk_end_bidi_request => blk_end_request() and
> change all users to add an extra 0, and the original blk_end_request()
> should be dropped.

That might be better than the current situation but why do we need
bidi_bytes (number of bytes to complete for bidi) in blk_end_request?

Having bidi_bytes is theoretically correct but we always must complete
all the bytes with bidi. Do you say that someone might need it in the
future?
