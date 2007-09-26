From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/5] fix iommu sg list merge problem
Date: Wed, 26 Sep 2007 23:34:49 +0900
Message-ID: <20070925200025O.tomof@acm.org>
References: <20070925142141N.tomof@acm.org>
	<20070926100221.GW4239@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47149 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbXIZOgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 10:36:10 -0400
In-Reply-To: <20070926100221.GW4239@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: muli@il.ibm.com
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 26 Sep 2007 12:02:21 +0200
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Wed, Sep 26, 2007 at 05:57:57PM +0900, FUJITA Tomonori wrote:
> 
> > iommu code merges sg lists without considering lld's restrictions so
> > some llds need a workaround to split sg lists again. This patchset
> > fixes iommu to handle lld's max segment size limit properly.
> 
> The patches look reasonable to me.
> 
> > This patchset includes only the x86_64 iommu patch
> 
> There are multiple x86-64 IOMMUs, but only GART is in-tree and
> supports merging.
> 
> > but my git tree includes x86_64, ppc, ia64, parisc, and alpha
> > patches. As far as I know, thye are all the iommu code that merges
> > sg lists. The iommu patchse are only compile tested.
> > 
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git iommu
> 
> Do you think it will be possible to abstract the merging code into
> common code, rather than duplicating it for every IOMMU?

Yeah, I thought about it and it's possible (but not so easy). parisc
has IOMMU merging helper code and two parisc IOMMUs use it. ia64
sba_iommu is almost identical to parisc code. x86_64 gart, power, and
alpha do in their own way. But I think that we can merging helper code
useful for all.

I'll see what we can have after fixing the mering problem.
