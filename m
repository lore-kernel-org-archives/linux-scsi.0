From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 19:33:17 +0000
Message-ID: <1234985597.3225.62.camel@localhost.localdomain>
References: <499B46B2.5040601@kernel.org>
	 <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
	 <499B6BF7.9090300@kernel.org>
	 <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	 <499B724A.2040408@kernel.org>
	 <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	 <499B774C.5010705@kernel.org>
	 <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	 <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>
	 <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
	 <20090218100448.7f7c5b86.akpm@linux-foundation.org>
	 <1234982285.3225.42.camel@localhost.localdomain>
	 <20090218111510.b720aacb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58321 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbZBRTdW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 14:33:22 -0500
In-Reply-To: <20090218111510.b720aacb.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@lang.hm, matthew@wil.cx, yinghai@kernel.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Wed, 2009-02-18 at 11:15 -0800, Andrew Morton wrote:
> On Wed, 18 Feb 2009 18:38:04 +0000
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2009-02-18 at 10:04 -0800, Andrew Morton wrote:
> > > On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:
> > > 
> > > > On Wed, 18 Feb 2009, Matthew Wilcox wrote:
> > > > 
> > > > > On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
> > > > >>
> > > > >> Impact: workaround BIOS that doesn't enable that bit
> > > > >>
> > > > >> David reported that LSI sas doesn't work with MSI.
> > > > >> it turns out that BIOS doesn't enable HT MSI
> > > > >> 8132 does support HT MSI.
> > > > >> add quirk to enable it
> > > > >>
> > > > >> Reported-by: David Lang <david@lang.hm>
> > > > >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > > > >
> > > > > Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> > > > >
> > > > > Jesse, I think this should go into Linus' tree sooner rather than later.
> > > > 
> > > > please forward to -stable as well. this is a regression since the card 
> > > > works with older kernels.
> > > > 
> > > 
> > > Which kernel version introduced the regression?
> > 
> > Technically, it's not a regression.  The MSI problem has always been
> > there, it was just exposed when the SAS card switched to using MSI by
> > default.  It's fixed by the bridge quirk  ... of course it's unclear how
> > many more bridges with problems there are.
> > 
> > > Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
> > > well, to fix this regression?
> > 
> > No ... it's a separate issue.  MSI was enabled for fusion SAS in 2.6.26;
> > the problem msi patch which the above corrects actually has the effect
> > of disabling MSI for fusion and went into 2.6.29-rc2, which isn't a
> > kernel that's been tested here.
> 
> <scratches head>

OK, back on the ball; the names of the patches you're referring to are
in master:/home/akpm/public_html/mmotm/broken-out

> So it should be the case that _either_ of
> mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch and
> pci-enable-msi-on-8132.patch would fix David's machine?

No.  pci-enable-msi-on-8132.patch alone should fix the box.  Without it,
the MSI routing isn't working properly.

The fact that MSI is affecting fusion is caused by this patch:

commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
Author: Prakash, Sathya <sathya.prakash@lsi.com>
Date:   Fri Mar 7 15:53:21 2008 +0530

    [SCSI] mpt fusion: Enable MSI by default for SAS controllers
 
However that wasn't correctly implemented and had to be fixed, but the
bottom line is that with this patch as fixes, fusion now tries to enable
MSI for the SAS card (and has since 2.6.26)

A recent patch that went in to 2.6.29-rc2 was

commit e382968ba618e016ff7922dff9a6140c2f9108c8
Author: Kashyap, Desai <kashyap.desai@lsi.com>
Date:   Thu Jan 8 14:27:16 2009 +0530

    [SCSI] mpt fusion: Add separate msi enable disable for FC,SPI,SAS

This was misimplemented and actually disables MSI globally in the driver
(contrary to what LSI wanted to do).

What mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch is fix this and
re-enable MSI by default on SAS cards (going back to the position we
were in after 23a274c8a5adafc74a66f16988776fc7dd6f6e51).

What I'm saying is I'm happy to wait for LSI to sort out the current
mess ... hopefully dynamically, and in the meantime, MSI being globally
disabled for fusion isn't really a problem.

James


