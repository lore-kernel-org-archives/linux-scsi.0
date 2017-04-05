From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: problem with discard granularity in sd
Date: Tue, 04 Apr 2017 20:12:20 -0400
Message-ID: <yq1d1crvhjv.fsf@oracle.com>
References: <CA+Xd3XHp381w87Fr5_HGU5gBpWMSRSwD+pRacGkHu7Rp7CYUfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33080 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752834AbdDEAMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 20:12:31 -0400
In-Reply-To: <CA+Xd3XHp381w87Fr5_HGU5gBpWMSRSwD+pRacGkHu7Rp7CYUfg@mail.gmail.com>
        (David Buckley's message of "Fri, 31 Mar 2017 09:52:38 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Buckley <dbuckley@oreilly.com>
Cc: linux-scsi@vger.kernel.org

David Buckley <dbuckley@oreilly.com> writes:

David,

> They result in discard granularity being forced to logical block size
> if the disk reports LBPRZ is enabled (which the netapp luns do).

Block zeroing and unmapping are currently sharing some plumbing and that
has lead to some compromises. In this case a bias towards ensuring data
integrity for zeroing at the expense of not aligning unmap requests.

Christoph has worked on separating those two functions. His code is
currently under review.

> I'm not sure of the implications of either the netapp changes, though
> reporting 4k logical blocks seems potential as this is supported in
> newer OS at least.

Yes, but it may break legacy applications that assume a 512-byte logical
block size.

> The sd change potentially would at least partially undo the patches
> referenced above.  But it would seem that (assuming an aligned
> filesystem with 4k blocks and minimum_io_size=4096) there is no
> possibility of a partial block discard or advantage to sending the
> discard requests in 512 blocks?

The unmap granularity inside a device is often much, much bigger than
4K. So aligning to that probably won't make a difference. And it's
imperative to filesystems that zeroing works at logical block size
granularity.

The expected behavior for a device is that it unmaps whichever full
unmap granularity chunks are described by a received request. And then
explicitly zeroes any partial chunks at the head and tail. So I am
surprised you see no reclamation whatsoever.

With the impending zero/unmap separation things might fare better. But
I'd still like to understand the behavior you observe. Please provide
the output of:

sg_vpd -p lbpv /dev/sdN
sg_vpd -p bl /dev/sdN

for one of the LUNs and I'll take a look.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
