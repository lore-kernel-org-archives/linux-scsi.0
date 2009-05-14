From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Thu, 14 May 2009 12:46:07 -0400
Message-ID: <1242319567.17083.2.camel@mulgrave.int.hansenpartnership.com>
References: <4A0307F4.50205@panasas.com> <20090512112539.GH4140@kernel.dk>
	 <4A0AD8FA.6030903@panasas.com>  <4A0ADAEF.3040501@panasas.com>
	 <1242226048.4728.24.camel@mulgrave.int.hansenpartnership.com>
	 <4A0C3086.2010802@panasas.com>
	 <1242315327.11484.2.camel@mulgrave.int.hansenpartnership.com>
	 <4A0C4295.4080101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57348 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbZENQqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 12:46:08 -0400
In-Reply-To: <4A0C4295.4080101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, 2009-05-14 at 19:11 +0300, Boaz Harrosh wrote:
> On 05/14/2009 06:35 PM, James Bottomley wrote:
> <snip>
> >>
> >> I see that you rebased by now, though I suspect the fc's blk_end_request
> >> call will fail to build if merged with block tree.
> > 
> > Yes, that's the bit we need a postmerge tree for.  It has to build on
> > it's own in scsi-misc, but it's making use of an API Tejun is altering,
> > so the block postmerge has to do the API alteration based on the SCSI
> > tree.
> > 
> 
> Tejun's cleanup is a bit tricky and cross trees wide. It will need to be
> completely postponed to post merge which will be a pity since there are
> so many patches ontop of it in block-next. Unless we want to sacrifice
> the build ability of the tree between block-merge and the fixup to this driver.
> 
> Perhaps you could do a scsi-post-merge tree that has only this driver, already
> with the new needed code?

If necessary.  However, the disadvantage of doing it this way around is
that I have to squash together the two patches (FC transport patch and
the update to tejun's API) otherwise we get a bisection break.

James


