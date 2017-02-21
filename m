From: Jan Kara <jack@suse.cz>
Subject: Re: Manual driver binding and unbinding broken for SCSI
Date: Tue, 21 Feb 2017 18:14:41 +0100
Message-ID: <20170221171441.GA15875@quack2.suse.cz>
References: <20170218003015.GA19776@vader.DHCP.thefacebook.com>
 <1487378636.4351.45.camel@HansenPartnership.com>
 <20170220021958.GA26238@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753514AbdBUROp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 12:14:45 -0500
Content-Disposition: inline
In-Reply-To: <20170220021958.GA26238@vader>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Sun 19-02-17 18:19:58, Omar Sandoval wrote:
> On Fri, Feb 17, 2017 at 04:43:56PM -0800, James Bottomley wrote:
> > This seems to be related to a 0day test we got on the block tree,
> > details here:
> > 
> > http://marc.info/?t=148624068800001
> > 
> > I root caused the above to something not being released when it should
> > be, so it looks like you have the same problem.  It seems to be a
> > recent commit in the block tree, so could you bisect it since you have
> > a nice reproducer?
> 
> These appear to actually be two separate issues.
> 
> The unbind followed by bind crash only happens with scsi-mq. It reproes
> since at least 4.0.
> 
> The unbind followed by a new device coming up crash happens both with
> and without scsi-mq. The earliest version I was able to check for that
> was 4.6, which did reproduce.
> 
> I'll see if I can get some more info on these two issues separately.

Actually, the second issue is only a warning right? And if I understand the
issue correctly, it should be fixed by either Dan's patches in linux-block
or my patch 4 in the series which matches your test results. So that is
dealt with. I have no idea about the first issue though.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
