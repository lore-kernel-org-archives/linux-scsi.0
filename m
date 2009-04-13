From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
 blk_rq_map_kern_sgl()
Date: Mon, 13 Apr 2009 19:07:58 +0900
Message-ID: <20090413190747V.fujita.tomonori@lab.ntt.co.jp>
References: <49D39DBC.3000206@panasas.com>
	<20090413164146J.fujita.tomonori@lab.ntt.co.jp>
	<49E3080F.7080206@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59479 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZDMKJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2009 06:09:03 -0400
In-Reply-To: <49E3080F.7080206@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 18:38:23 +0900
Tejun Heo <tj@kernel.org> wrote:

> FUJITA Tomonori wrote:
> >> I thought that was agreed and done? What is left to do for that to go
> >> in.
> > 
> > I've converted all the users (sg, st, osst). Nothing is left. So we
> > don't need this.
> 
> Yeah, pulled it.  Okay, so we can postpone diddling with request
> mapping for now.  I'll re-post fixes only from this and the previous
> patchset and proceed with other patchsets.

To be honest, I don't think that we can clean up the block
mapping. For example, blk_rq_map_kern_prealloc() in your patchset
doesn't look cleanup to me. It's just moving a hack from ide to the
block (well, I have to admit that I did the same thing when I
converted sg/st/osst...).

We can't have good API with insane users. I don't want to ask this
publicly but don't we have any chance to merge the old ide code and
libata?
