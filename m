From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 09:48:20 +0100
Message-ID: <1337935700.2932.18.camel@dabdike.int.hansenpartnership.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
	 <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
	 <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
	 <CABE8wwtfW0FusNuOEmwMxZLVMTVSj0R9HCA5xLWidrgj_7Ax+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55831 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944Ab2EYIs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 04:48:26 -0400
In-Reply-To: <CABE8wwtfW0FusNuOEmwMxZLVMTVSj0R9HCA5xLWidrgj_7Ax+A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Fri, 2012-05-25 at 01:18 -0700, Dan Williams wrote:
> On Fri, May 25, 2012 at 12:51 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
> >> This is in preparation for teaching async_synchronize_full() to sync all
> >> pending async work, and not just on the async_running domain.  This
> >> conversion is functionally equivalent, just embedding the existing list
> >> in a new async_domain type.
> >
> > This looks good, but I want Arjan and others who invented the async code
> > to speed up boot to comment on all of this.  What was the intention of
> > async_synchronize_full() and if it wasn't to synchronise all domains,
> > should we fix the documentation and add a new primitive to do that,
> > since boot clearly assumes the all domains behaviour.
> >
> > In the mean time, this is probably all a bit much for a merge window, so
> > I'll revert
> >
> > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > Author: Dan Williams <dan.j.williams@intel.com>
> > Date:   Thu Mar 22 17:05:11 2012 -0700
> >
> >    [SCSI] sd: limit the scope of the async probe domain
> >
> > And we'll put whatever is chosen in early for the next merge window.
> >
> 
> Makes sense... but could also go ahead with the smaller fix I posted
> for 3.5.  Meelis confirms it is working.

OK, that's what I hadn't seen.  I can't think of another way we could
fail at the moment, except in suspend/resume because the
scsi_complete_async_scans will be a nop. Can someone test the
suspend/resume case?


There is actually one good thing to come out of this:  Rafael's commit

commit c751085943362143f84346d274e0011419c84202
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Apr 12 20:06:56 2009 +0200

    PM/Hibernate: Wait for SCSI devices scan to complete during resume

Actually broke the scsi_wait_scan module, because for modular SCSI
(which is effectively all distributions) its scsi_complete_async_scans()
is also a nop.  I assume this means that no distributions rely on it any
more and we can remove it?

> Otherwise this leaves the pending libsas suspend/resume support in
> limbo, since it will certainly deadlock in the case where any device
> fails, or is slow to come back from resume.

I appreciate this is a bug, but it's not quite as serious as breaking
suspend and hibernate ... can we demonstrate they're still working?

James


