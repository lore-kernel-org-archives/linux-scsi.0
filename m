From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 21 Nov 2003 12:18:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujn0apwpp2.fsf@chaapala-lnx2.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com>
	<20031027153932.A16679@infradead.org>
	<yqujvfpdwu4f.fsf@chaapala-lnx2.cisco.com>
	<20031121173236.GX30485@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:13404 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S264405AbTKUSSW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 13:18:22 -0500
In-Reply-To: <20031121173236.GX30485@parcelfarce.linux.theplanet.co.uk> (Matthew
 Wilcox's message of "Fri, 21 Nov 2003 17:32:36 +0000")
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, Krishna Murthy <krmurthy@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Fri, 21 Nov 2003, Matthew Wilcox spake thusly:
> On Fri, Nov 21, 2003 at 10:42:40AM -0600, Clay Haapala wrote:
>> On Mon, 27 Oct 2003, Christoph Hellwig said:
>> > 
>> > highlevel:
>> > 	- kill md5.c and iscsi-crc.c and use common cryptoapi
>> > 	md5 / common crc code instead.
>> 
>> md5: That appears straight-forward, and has been implemented,
>> subject to testing.  SELECT CRYPTO and SELECT MD5 makes it
>> available in the kernel.
>> 
>> crc32: Ah, the iSCSI crc32 uses a different polynomial (stronger)
>> than Ethernet and the rest.  We argued during the RFC process for
>> just using Ethernet's as good enough, but were voted down.  So we
>> are stuck with a separate implementation in this case.
> 
> OK, but please convert it to live in the crypto/ directory and use
> the crypto interfaces.  That way if some unrelated project decides
> to implement the same algorithm, we don't end up with two copies of
> it.

I'm happy to do that.  Having established that it is not a redundant
implementation, though, I would like to have it not be a factor with
respect to driver inclusion, as there are bigger fish to fry.

That being said, I'll probably jump on it, anyway.

Question:  Should the implementation use the crypto api
or be added to the lib/crc32 code?
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
     Well, looks like hypocrisy is back on the airwaves.
       C'mon, Rush!  Do the crime, do the time, right?
