From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 02 Dec 2016 15:37:07 -0500
Message-ID: <1480711027.28416.200.camel@localhost.localdomain>
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
         <yq18trzhink.fsf@sermon.lab.mkp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbcLBUhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 15:37:10 -0500
In-Reply-To: <yq18trzhink.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, Laurence Oberman <loberman@redhat.com>, Eyal Ben David <bdeyal@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Thu, 2016-12-01 at 08:40 -0500, Martin K. Petersen wrote:
> >>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
...
> Specifically, the problem appears to be caused by the removal of
> the setting of bio->bi_bdev, which would previously be set to NULL.
> If I add:
> 
> diff --git a/block/bio.c b/block/bio.c
> index 0723d4c..ecac37b 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1351,6 +1351,7 @@ struct bio *bio_map_user_iov(struct request_queue
> *q,
>         if (iter->type & WRITE)
>                 bio->bi_rw |= REQ_WRITE;
>  
> +       bio->bi_bdev = NULL;
>         bio->bi_flags |= (1 << BIO_USER_MAPPED);
>  
>         /*
> 
> Ewan> The test passes (no zero byte corruption).
> 

Adding this seemed to work on top of the commit commit id mentioned
above (37f19e57a0de3c4a3417aa13ff4d04f1e0dee4b3)
but does not help on 4.7, because the test case now takes the
bio_copy_user_iov() code path rather than bio_map_user_iov().

-Ewan



