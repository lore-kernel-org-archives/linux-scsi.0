From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH -mm 0/3] convert IOMMUs to use iova
Date: Sat, 3 Nov 2007 03:11:29 +0900
Message-ID: <20071103031349S.tomof@acm.org>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
	<20071102171227.GH7975@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:41979 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXKBSRR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Nov 2007 14:17:17 -0400
In-Reply-To: <20071102171227.GH7975@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: muli@il.ibm.com
Cc: tomof@acm.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Fri, 2 Nov 2007 19:12:27 +0200
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Sat, Nov 03, 2007 at 02:05:39AM +0900, FUJITA Tomonori wrote:
> 
> > This patchset convert the PPC64 IOMMU to use the iova code for free
> > area management.
> > 
> > The IOMMUs ignores low level drivers' restrictions, the maximum
> > segment size and segment boundary.
> > 
> > I fixed the former:
> > 
> > http://thread.gmane.org/gmane.linux.scsi/35602
> > 
> > The latter makes the free area management complicated. I'd like to
> > convert IOMMUs to use the iova code (that intel-iommu introduced)
> > for free area management and enable iova to handle segment boundary
> > restrictions, rather than fixing all the IOMMUs' free area
> > management,
> 
> In general it sounds like a great idea, but have you looked at what
> impact this has on the performance of the IO path?

Not yet. And I have access to only an entry-class pSeries server so I
would appreciate it if POWERPC people try the patchset with high-end
servers.

The patchset doesn't use the tricks that the current POWERPC IOMMU use
to improve performance (Anton and Olof told me about them, Thanks!)
. So I might need to modify iova for them.

I think that it's difficult to use some tricks used in the IOMMUs with
the iova even if we modify the iova. If the iova degrades performance,
I think that it would be better to have new IOMMU library code to use
simply a bit map that most of the IOMMUs use.

Another possible factor to degrade performance is that we can't
allocate areas for map_sg at one stroke like some of the IOMMUs do.
We need to allocate an area per sg segment to handle segment boundary.
If it's unacceptable, I guess that there is only one way, LLDs
allocate many sg entries and then the IOMMU splits the sg entryes.
