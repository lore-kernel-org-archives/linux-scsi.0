From: Clay Haapala <chaapala@cisco.com>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 11:32:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujzn72uov6.fsf@chaapala-lnx2.cisco.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com>
	<1087484107.2090.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:10606 "EHLO
	rtp-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S266563AbUFQQch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 12:32:37 -0400
In-Reply-To: <1087484107.2090.42.camel@mulgrave> (James Bottomley's message
 of
	"17 Jun 2004 09:55:03 -0500")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 17 Jun 2004, James Bottomley spake thusly:
> On Thu, 2004-06-17 at 09:39, Salyzyn, Mark wrote:
>> This would not be such an issue if Linux provided large SG elements
>> rather than the fubar descending page order ones they issue today. If
>> this could be fixed, I'd not even be interested in the optimization of
>> the SG.
> 
> This is hardly a big problem, is it?  it only occurs during the first
> few moments of system operation.  After that, the pages assigned to a
> virtual region are pretty much random.
> 
> Fundamentally, sg lists have to operate at the level of the MMU, so
> we're stuck with the page size, which is 4k on x86.  There's nothing we
> can do in SCSI about this.
> 
> Of course, if you're on a platform with an IOMMU then this problem
> simply doesn't exist and we can coalesce nicely.
> 
> James

Just to see if my understanding is on track ...

Today's scatterlists already handle entries with a size greater than
MMU pagelength, even on x86, right?  We have seen it in iSCSI driver
testing, though it is not the usual case.  crypto/digests.c:update()
function was recently patched to handle the case and properly kmap()
the additional memory represented by the sg entry.

So, on regular x86 this is a matter of convenience/timing, and the
page assignments will tend toward, but not always be, random 1-page
entries as the system is used.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
	       Overheard somewhere in Washington D.C.:
		  "Doh!  Invaded the wrong country!"
