From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Fri, 9 Mar 2007 10:36:54 -0800
Message-ID: <20070309183654.GB7977@kroah.com>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net> <1173288505.3771.33.camel@mulgrave.il.steeleye.com> <20070307174021.GA25066@kroah.com> <20070307111616.16e5e641.akpm@linux-foundation.org> <1173315014.3771.51.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767459AbXCISix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2007 13:38:53 -0500
Content-Disposition: inline
In-Reply-To: <1173315014.3771.51.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 07, 2007 at 07:50:14PM -0500, James Bottomley wrote:
> On Wed, 2007-03-07 at 11:16 -0800, Andrew Morton wrote:
> > Achim did reply:  http://lkml.org/lkml/2007/2/23/138
> 
> Ah ... OK; sorry, I'm parochial ... if it didn't appear on linux-scsi,
> you can usually assume I haven't seen it.
> 
> > So we don't know what the patch does, but it should be merged into
> > -stable
> > (and mainline, heaven forfend)
> 
> Well ... I would, except what this patch does is to initialise the
> command sg_ranz field (for both 64 bit and 32 bit commands).  If you
> look in the code just below the patch application at the 
> 
> if (scp->use_sg) {
> ...
> } else if (scp->request_bufflen) {
> ...
> }
> 
> You'll find a line setting these parameters in each of the cases of the
> if statement.  So the bug appears to be that there's a missing else
> clause to this if, which would initialise the zero transfer commands.
> Is that a correct analysis?

Well, as no one has really responded to this thread about what the patch
really does, and it's not in even James's tree yet, I've dropped it from
-stable.

If James does send it to Linus, I'll be glad to reconsider it at that
time.

thanks,

greg k-h
