From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bugme-new] [Bug 9901] New: kernel panic in stex modules (?)
Date: Thu, 07 Feb 2008 10:02:17 +0900
Message-ID: <20080207100217K.fujita.tomonori@lab.ntt.co.jp>
References: <bug-9901-10286@http.bugzilla.kernel.org/>
	<20080206101502.ba8746a6.akpm@linux-foundation.org>
	<1202322400.3112.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:52632 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbYBGBCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 20:02:33 -0500
In-Reply-To: <1202322400.3112.96.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tomof@acm.org, bugme-daemon@bugzilla.kernel.org, dairinin@gmail.com

On Wed, 06 Feb 2008 12:26:39 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-02-06 at 10:15 -0800, Andrew Morton wrote:
> > On Wed,  6 Feb 2008 09:40:15 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9901
> > > 
> > >            Summary: kernel panic in stex modules (?)
> > >            Product: IO/Storage
> > >            Version: 2.5
> > >      KernelVersion: 2.6.24
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: Serial ATA
> > >         AssignedTo: jgarzik@pobox.com
> > >         ReportedBy: dairinin@gmail.com
> > > 
> > > 
> > > Latest working kernel version: 2.6.23-r6
> > > Earliest failing kernel version: 2.6.24
> > > Distribution: Gentoo
> > > Hardware Environment: Core2D E6600, Asus p5B Dlx, 2G DDR2 667, Promise ST
> > > EX4350
> > > Software Environment: GCC 4.2.3/4.1.2, CFLAGS="-O2"
> > > 
> > > Problem Description:
> > > The problem is frequent kernel panics within the same module. Can't say what it
> > > is, but looks like it is related to dma and promise driver.
> > > The first culprit, the memory, is ok, 8 hours of memtest passed without errors.
> > > Before, kernel 2.6.23-gentoo-r6, compiled with GCC 4.1.2 worked just fine, then
> > > after upgrade to 4.2.2 th bug appeared. Upgrade to 2.6.24 didn't solve the
> > > problem. Switching back to GCC 4.1.2 made things better for a moment, crashes
> > > became less frequent and I thought compiler was the cause. But today system
> > > crashed again with same symptoms.
> > > Sorry, but I can't save crash log, so I'll provide screen "shot":
> > > http://img238.imageshack.us/my.php?image=p2030030ki1.jpg
> > > 
> > > Steps to reproduce:
> > > Boot, start FTP-server, load RAID with heavy input, in some hours it will
> > > crash. With pure reads system can run several days, heavy write load kills it
> > > much too easier.
> > > 
> > 
> > The supertrak driver has regressed in 2.6.24.  And
> > 
> > commit 9cb83c7529d929c00f37d821daed1942a1b20602
> > Author: FUJITA Tomonori <tomof@acm.org>
> > Date:   Tue Oct 16 11:24:32 2007 +0200
> > 
> >     [SCSI] add use_sg_chaining option to scsi_host_template
> >     
> > looks a likely candidate.
> > 
> > And this:
> > 
> > commit d3f46f39b7092594b498abc12f0c73b0b9913bde
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Tue Jan 15 11:11:46 2008 -0600
> > 
> >     [SCSI] remove use_sg_chaining
> > 
> > from 2.6.25 looks to be a likely fix for it.  Should it be backported?
> 
> If the patch you identify is the culprit, mine can't be the fix ... and
> it should also be present in git head.
> 
> The BUG_ON is here: isn't it?
> 
> static inline void
> dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
> 	     int direction)
> {
> 	BUG_ON(!valid_dma_direction(direction));
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 	dma_ops->unmap_sg(hwdev, sg, nents, direction);
> }
> 
> stex only does scsi_dma_unmap(), so something looks to have tampered
> with the cmnd->sc_data_direction somehow ... and I can't see how.

Surely, someone changes the cmnd->sc_data_direction, or else we should
be hit by dma_map_sg before dma_unmap_sg:

static inline int
dma_map_sg(struct device *hwdev, struct scatterlist *sg, int nents, int direction)
{
	BUG_ON(!valid_dma_direction(direction));
	return dma_ops->map_sg(hwdev, sg, nents, direction);
}
