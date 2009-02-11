From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH -stable 2.6.28.x] sg: avoid blk_put_request/blk_rq_unmap_user
 in interrupt
Date: Wed, 11 Feb 2009 08:42:51 -0500
Message-ID: <4992D5DB.6070307@interlog.com>
References: <20090211145014C.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45180 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZBKHnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 02:43:01 -0500
In-Reply-To: <20090211145014C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stable@kernel.org, hias@horus.com, rjw@sisk.pl, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> This patch is against 2.6.28.x, fixes a regression from 2.6.27.
> 
> This is the modified version of the following patch that is planed to
> merged into 2.6.30-rc1 in scsi-misc tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=b35fe25ae156830f85a305afaba837b084458e7a
> 
> scsi-misc tree has other patches to fix sg oops so the above patch
> can't be cleanly applied to 2.6.28.x. These patches are too large for
> 2.6.28.x (needs more testings) so sg in 2.6.28.x still has the oops
> bugs for now even with this patch. I expect that these patches will go
> into stable trees too after 2.6.30-rc1 (that is, after more people
> test them).
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH -stable 2.6.28.x] sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
> 
> This fixes the following oops:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12612
> 
> You can reproduce this bug by interrupting a program before a sg
> response completes. This leads to the special sg state (the orphan
> state), then sg calls blk_put_request in interrupt (rq->end_io).
> 
> The above bug report shows the recursive lock problem because sg calls
> blk_put_request in interrupt. We could call __blk_put_request here
> instead however we also need to handle blk_rq_unmap_user here, which
> can't be called in interrupt too.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
