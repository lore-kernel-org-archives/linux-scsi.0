From: Clay Haapala <chaapala@cisco.com>
Subject: Re: [PATCH] Add CRC32C chksums to crypto routines
Date: Wed, 14 Jan 2004 16:12:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujzncq2n8w.fsf@chaapala-lnx2.cisco.com>
References: <Xine.LNX.4.44.0401141643560.12649-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:20548 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S264310AbUANWMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 17:12:39 -0500
In-Reply-To: <Xine.LNX.4.44.0401141643560.12649-100000@thoron.boston.redhat.com> (James
 Morris's message of "Wed, 14 Jan 2004 16:45:49 -0500 (EST)")
List-Id: linux-scsi@vger.kernel.org
To: James Morris <jmorris@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

On Wed, 14 Jan 2004, James Morris stated:
> On Wed, 14 Jan 2004, Clay Haapala wrote:
> 
>> This patch against 2.6.1 adds CRC32C checksumming capabilities to
>> the crypto routines.  The structure of it is based wholly on the
>> existing digest (md5) routines, the main difference being that
>> chksums are often used in an "accumulator" fashion, effectively
>> requiring one to set the seed, and the digest algorithms don't do
>> that.
> 
> This looks interesting; do you know of any other chksum algorithms
> which might need to be implemented in the kernel?
> 
I reference the one other user of CRC32C in my code, that would be the
sctp network driver, at this time.

Of course, there is library/crc32, which I did make an attempt to
implement companion code to it, but we really need the "work over
scatterlists" feature of the crypto routines.

I took the design goals the of the library/crc32 routines (flexible
XOR policy, flexible initial values) and tried to allow that in the
crypto chksum routines.  CRC32 could be moved into it, but the uses of
CRC32 are often quick accumulation over packet fragments, rather than
computing digests over scatterlists describing would can be many K of
data.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
	 Funny, I didn't think Haliburton was into aerospace.
