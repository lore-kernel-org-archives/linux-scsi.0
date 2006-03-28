From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] sas transport: ref count update
Date: Tue, 28 Mar 2006 16:08:45 +0100
Message-ID: <20060328150845.GB17420@infradead.org>
References: <20060322214119.GA661@us.ibm.com> <20060322214221.GB661@us.ibm.com> <20060325035648.GB19970@us.ibm.com> <1143304763.3049.34.camel@mulgrave.il.steeleye.com> <20060327173728.GB29353@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:62381 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750841AbWC1PI5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:08:57 -0500
Content-Disposition: inline
In-Reply-To: <20060327173728.GB29353@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Mar 27, 2006 at 09:37:28AM -0800, Mike Anderson wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > On Fri, 2006-03-24 at 19:56 -0800, Mike Anderson wrote:
> > > Can I get your comment(s) on this change.
> > 
> > This looks correct as far as it goes, but it's not complete.
> > sas_phy_free() and sas_rphy_free() now do too many parent puts with this
> > change (actually, two too many in each case, which looks like a bug in
> > the original code).  There also looks to be two spurious puts in the
> > rphy (for expander and end device) allocation error paths (again, a bug
> > in the original code).
> 
> ok, here is an updated patch that covers these cases also. I moved to
> using the releases functions in the *_free() cases also as it seems like a
> good idea to use the release functions if you can. I have compiled and
> tested it on a aic based system, but it does not call the free functions.

the _free cases only existed because I didn't want to go through all
the driver model ->release stuff initially.  now that you do that the
_free functions can be removed.

