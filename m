From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 21:23:27 +0200
Message-ID: <201205252123.27869.rjw@sisk.pl>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com> <CABE8wwtfW0FusNuOEmwMxZLVMTVSj0R9HCA5xLWidrgj_7Ax+A@mail.gmail.com> <1337935700.2932.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337935700.2932.18.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, mroos@linux.ee, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>
List-Id: linux-scsi@vger.kernel.org

On Friday, May 25, 2012, James Bottomley wrote:
> On Fri, 2012-05-25 at 01:18 -0700, Dan Williams wrote:
> > On Fri, May 25, 2012 at 12:51 AM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> > > On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
> > >> This is in preparation for teaching async_synchronize_full() to sync all
> > >> pending async work, and not just on the async_running domain.  This
> > >> conversion is functionally equivalent, just embedding the existing list
> > >> in a new async_domain type.
> > >
> > > This looks good, but I want Arjan and others who invented the async code
> > > to speed up boot to comment on all of this.  What was the intention of
> > > async_synchronize_full() and if it wasn't to synchronise all domains,
> > > should we fix the documentation and add a new primitive to do that,
> > > since boot clearly assumes the all domains behaviour.
> > >
> > > In the mean time, this is probably all a bit much for a merge window, so
> > > I'll revert
> > >
> > > commit a7a20d103994fd760766e6c9d494daa569cbfe06
> > > Author: Dan Williams <dan.j.williams@intel.com>
> > > Date:   Thu Mar 22 17:05:11 2012 -0700
> > >
> > >    [SCSI] sd: limit the scope of the async probe domain
> > >
> > > And we'll put whatever is chosen in early for the next merge window.
> > >
> > 
> > Makes sense... but could also go ahead with the smaller fix I posted
> > for 3.5.  Meelis confirms it is working.
> 
> OK, that's what I hadn't seen.  I can't think of another way we could
> fail at the moment, except in suspend/resume because the
> scsi_complete_async_scans will be a nop. Can someone test the
> suspend/resume case?
> 
> 
> There is actually one good thing to come out of this:  Rafael's commit
> 
> commit c751085943362143f84346d274e0011419c84202
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Sun Apr 12 20:06:56 2009 +0200
> 
>     PM/Hibernate: Wait for SCSI devices scan to complete during resume
> 
> Actually broke the scsi_wait_scan module, because for modular SCSI
> (which is effectively all distributions) its scsi_complete_async_scans()
> is also a nop.  I assume this means that no distributions rely on it any
> more and we can remove it?

Well, there still are users who build their own kernels ...

The problem was that when we had started to do the async scan, resume from
hibernation stopped working for the poeple who _had_ built-in SCSI and the
commit above was meant to address that.

Thanks,
Rafael
