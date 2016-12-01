From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Thu, 01 Dec 2016 08:40:31 -0500
Message-ID: <yq18trzhink.fsf@sermon.lab.mkp.net>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
        <1479752642.19792.43.camel@localhost.localdomain>
        <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
        <1479839407.28416.21.camel@localhost.localdomain>
        <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
        <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
        <1479932524.28416.43.camel@localhost.localdomain>
        <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
        <1194718949.74785.1480096576577.JavaMail.zimbra@redhat.com>
        <1480523188.28416.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38617 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754600AbcLANlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2016 08:41:16 -0500
In-Reply-To: <1480523188.28416.94.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Wed, 30 Nov 2016 11:26:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Laurence Oberman <loberman@redhat.com>, Eyal Ben David <bdeyal@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

>> I think what we need to understand is what caused the regression in
>> the first place, I probably should have been bisecting the original
>> failure rather than trying to find where it started working.

Ewan> Bisecting leads to this commit:

commit 37f19e57a0de3c4a3417aa13ff4d04f1e0dee4b3
Author: Christoph Hellwig <hch@lst.de>
Date:   Sun Jan 18 16:16:33 2015 +0100

    block: merge __bio_map_user_iov into bio_map_user_iov
    
    And also remove the unused bdev argument.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Ming Lei <tom.leiming@gmail.com>
    Signed-off-by: Jens Axboe <axboe@fb.com>

Specifically, the problem appears to be caused by the removal of
the setting of bio->bi_bdev, which would previously be set to NULL.
If I add:

diff --git a/block/bio.c b/block/bio.c
index 0723d4c..ecac37b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1351,6 +1351,7 @@ struct bio *bio_map_user_iov(struct request_queue
*q,
        if (iter->type & WRITE)
                bio->bi_rw |= REQ_WRITE;
 
+       bio->bi_bdev = NULL;
        bio->bi_flags |= (1 << BIO_USER_MAPPED);
 
        /*

Ewan> The test passes (no zero byte corruption).

Ewan> Setting dxferp would cause map_data.null_mapped to be set before
Ewan> it is passed to blk_rq_map_user(_iov) which would cause a
Ewan> difference in behavior.

Christoph?

-- 
Martin K. Petersen	Oracle Linux Engineering
