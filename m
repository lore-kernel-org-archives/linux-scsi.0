From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] block,scsi: verify return pointer from blk_get_request
Date: Thu, 23 May 2013 17:37:58 -0400
Message-ID: <20130523173758.39709eac@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
	<20130317224416.GA7421@kernel.dk>
	<1369341611.2374.11.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:46423 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619Ab3EWVlo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 17:41:44 -0400
In-Reply-To: <1369341611.2374.11.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>

On Fri, 24 May 2013 00:40:11 +0400
James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> Now that we see the size of the patch diff between fixing the bug and
> doing proper error returns, I'm really not convinced this should be
> done as a single bug fix patch.  The modify all error returns is big
> and if we missed one, it will cause problems that will manifest as an
> oops, so it makes a fairly compact fix a big error prone patch.
> 
> What about two patches: one to fix the actual bug (this patch), which
> could go now and one to change the return type, which would go in the
> normal merge window.

That would certainly be safer (apologies for not getting to this before
the merge window).

I can split these modifications from the return type changes tomorrow.
This would include fixes to address new and previous patch comments:

  - v1: If callers are passing in __GFP_WAIT, then blk_get_request
    should only fail if the device queue is dead, so it would be
    more appropriate to return -ENODEV.  (Jens)
  - v1: scsi_eh_lock_door is defined as void, don't return errno
    (Bart)
  - v1: drivers/block/paride/pd.c :: pd_special_command should check
    blk_get_request return value
  - v4: the error path introduced in sg_scsi_ioctl should free the
    buffer

Thanks,

-- Joe
