From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: Further aacraid work
Date: 17 Jun 2004 11:37:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087490225.2210.48.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com>
	<1087484107.2090.42.camel@mulgrave>
	<yqujzn72uov6.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:46730 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266564AbUFQQiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 12:38:46 -0400
In-Reply-To: <yqujzn72uov6.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-17 at 11:32, Clay Haapala wrote:
> Today's scatterlists already handle entries with a size greater than
> MMU pagelength, even on x86, right?  We have seen it in iSCSI driver
> testing, though it is not the usual case.  crypto/digests.c:update()
> function was recently patched to handle the case and properly kmap()
> the additional memory represented by the sg entry.

Yes.  The bio layer does two operations on sg elements: clustering and
virtual merging.  Clustering tries to coalesce two adjacent I/O pages
that also happen to be adjacent in memory physical space.  virtual
merging uses an IOMMU to place non-physically-adjacent pages at adjacent
locations in bus physical space.

> So, on regular x86 this is a matter of convenience/timing, and the
> page assignments will tend toward, but not always be, random 1-page
> entries as the system is used.

That's what the jury is out on, I think.  The question is could we
improve the chances of clustering by altering the way the vm allocator
works.

James


