From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: PATCH: Further aacraid work
Date: 17 Jun 2004 09:55:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087484107.2090.42.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:18904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266525AbUFQOzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 10:55:17 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-17 at 09:39, Salyzyn, Mark wrote:
> This would not be such an issue if Linux provided large SG elements
> rather than the fubar descending page order ones they issue today. If
> this could be fixed, I'd not even be interested in the optimization of
> the SG.

This is hardly a big problem, is it?  it only occurs during the first
few moments of system operation.  After that, the pages assigned to a
virtual region are pretty much random.

Fundamentally, sg lists have to operate at the level of the MMU, so
we're stuck with the page size, which is 4k on x86.  There's nothing we
can do in SCSI about this.

Of course, if you're on a platform with an IOMMU then this problem
simply doesn't exist and we can coalesce nicely.

James


