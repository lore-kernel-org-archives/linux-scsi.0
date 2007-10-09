From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 9 Oct 2007 06:00:48 -0600
Message-ID: <20071009120048.GB13842@parisc-linux.org>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49590 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXJIMAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 08:00:51 -0400
Content-Disposition: inline
In-Reply-To: <20071009053610.GA17794@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Mon, Oct 08, 2007 at 10:36:10PM -0700, malahal@us.ibm.com wrote:
> Thank you Randy, Jens for your suggestions. I folded the second patch as
> it is just a clean up. Here is the fixed one patch version.

I was thinking about this (in the context of shrinking scsi_cmnd --
obviously, things are not improved if we simply move the timer to request
instead of scsi_cmnd).  Why do we need a timer _per request_?  We don't
need one per network packet.  I appreciate we had one per scsi_cmnd and
this patch is just moving it upwards in the hierarchy, but perhaps we
can do better.

What if we have one timer per request queue instead?  It needs to expire
as soon as the earliest request timer would expire, then needs to be
reset to the next earliest one.  We might walk the request queue more
frequently, but we'd save 48 bytes in the struct request.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
