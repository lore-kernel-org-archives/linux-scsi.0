From: Clay Haapala <chaapala@cisco.com>
Subject: Re: [PATCH] Add CRC32C chksums to crypto routines
Date: Mon, 19 Jan 2004 15:15:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yquj8yk31vxy.fsf@chaapala-lnx2.cisco.com>
References: <Xine.LNX.4.44.0401191512140.1564-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55425 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S263539AbUASVP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:15:58 -0500
In-Reply-To: <Xine.LNX.4.44.0401191512140.1564-100000@thoron.boston.redhat.com> (James
 Morris's message of "Mon, 19 Jan 2004 15:13:15 -0500 (EST)")
List-Id: linux-scsi@vger.kernel.org
To: James Morris <jmorris@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

On Mon, 19 Jan 2004, James Morris stated:
> On Wed, 14 Jan 2004, Clay Haapala wrote:
> 
>> This patch against 2.6.1 adds CRC32C checksumming capabilities to
>> the crypto routines.  The structure of it is based wholly on the
>> existing digest (md5) routines, the main difference being that
>> chksums are often used in an "accumulator" fashion, effectively
>> requiring one to set the seed, and the digest algorithms don't do
>> that.
> 
> Looks good to me.
> 
In other email, Matt Mackall suggested a slightly different
integration with the kernel that would allow more general usage of the
CRC32C.  His suggestion was to put the implementation under /lib, next
to the crc32 routines, and make the crypto routine a wrapper that calls
it.  Selecting the CRYPTO_CRC32C module would SELECT the lib CRC32C
module, in other words.

The benefit of this would be to allow easy usage by other routines
(with no premption side-affects, a concern Matt has) while still being
there for routines that process scatterlist.  And the table/code is
still in one place.

Patch to follow in a day or two, after I can test it.  Implementation
was simple.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
	 Funny, I didn't think Haliburton was into aerospace.
