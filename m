From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Tue, 19 Feb 2008 00:24:37 +0900
Message-ID: <20080219002439Y.tomof@acm.org>
References: <20080218233719R.tomof@acm.org>
	<20080218144652.GE23197@kernel.dk>
	<1203347347.3324.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55385 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbYBRPZP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 10:25:15 -0500
In-Reply-To: <1203347347.3324.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: jens.axboe@oracle.com, tomof@acm.org, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, 18 Feb 2008 09:09:07 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2008-02-18 at 15:46 +0100, Jens Axboe wrote:
> > Seems symmetric to me now, either we fail and everything is cleaned up,
> > or return success. What remains?
> 
> My main symmetry complaint was the API:  The map takes a request, the
> unmap takes a bio.

Yeah, it would be nice if we avoid such code:

blk_rq_map_user(q, rq, ...)
bio = rq->bio
blk_execute_rq(q, ...
blk_rq_unmap_user(bio);

I think that none of the users of blk_rq_map_user is interested in
bio, the details of how kernel manage I/Os. At least, we can remove
bio stuff in bsg if blk_rq_map_user and blk_rq_unmap_user take
requests.
