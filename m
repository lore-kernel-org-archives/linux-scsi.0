Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1BDC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 10:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2255F2067B
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 10:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgFEKSC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 06:18:02 -0400
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:56502 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgFEKSC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 06:18:02 -0400
Received: from imac.makisara.private (85-131-115-176.bb.dnainternet.fi [85.131.115.176])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
        id d43b4859-a715-11ea-ba22-005056bd6ce9;
        Fri, 05 Jun 2020 13:17:58 +0300 (EEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20200526182709.99599-1-jhubbard@nvidia.com>
Date:   Fri, 5 Jun 2020 13:17:58 +0300
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <73970197-B412-4DD5-BA26-845355AA037B@kolumbus.fi>
References: <20200526182709.99599-1-jhubbard@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 26. May 2020, at 21.27, John Hubbard <jhubbard@nvidia.com> wrote:
> 
> This code was using get_user_pages*(), in a "Case 1" scenario
> (Direct IO), using the categorization from [1]. That means that it's
> time to convert the get_user_pages*() + put_page() calls to
> pin_user_pages*() + unpin_user_pages() calls.
> 
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
> 
> Note that this effectively changes the code's behavior as well: it now
> ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
> is probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [3]
> 
> Also, this deletes one of the two FIXME comments (about refcounting),
> because there is nothing wrong with the refcounting at this point.
> 
> [1] Documentation/core-api/pin_user_pages.rst
> 
> [2] "Explicit pinning of user-space pages":
>    https://lwn.net/Articles/807108/
> 
> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Cc: "Kai Mäkisara (Kolumbus)" <kai.makisara@kolumbus.fi>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

> ---
> 
> Hi,
> 
> As mentioned in the v1 review thread, we probably still want/need
> this. Or so I claim. :) Please see what you think...
> 
> Changes since v1: changed the commit log, to refer to Direct IO
> (Case 1), instead of DMA/RDMA (Case 2). And added Bart to Cc.
> 
> v1:
> https://lore.kernel.org/linux-scsi/20200519045525.2446851-1-jhubbard@nvidia.com/
> 
> thanks,
> John Hubbard
> NVIDIA

I am not a memory management expert, but looks correct and necessary to me
with the current gup implementation. (You can changed Acked-by to
Reviewed-by if it is necessary and you accept this as a review.)

Thanks,
Kai

> 
> drivers/scsi/st.c | 20 +++++---------------
> 1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index c5f9b348b438..1e3eda9fa231 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4922,7 +4922,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
> 	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 	unsigned long start = uaddr >> PAGE_SHIFT;
> 	const int nr_pages = end - start;
> -	int res, i, j;
> +	int res, i;
> 	struct page **pages;
> 	struct rq_map_data *mdata = &STbp->map_data;
> 
> @@ -4944,7 +4944,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
> 
>         /* Try to fault in all of the necessary pages */
>         /* rw==READ means read from drive, write into memory area */
> -	res = get_user_pages_fast(uaddr, nr_pages, rw == READ ? FOLL_WRITE : 0,
> +	res = pin_user_pages_fast(uaddr, nr_pages, rw == READ ? FOLL_WRITE : 0,
> 				  pages);
> 
> 	/* Errors and no page mapped should return here */
> @@ -4964,8 +4964,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
> 	return nr_pages;
>  out_unmap:
> 	if (res > 0) {
> -		for (j=0; j < res; j++)
> -			put_page(pages[j]);
> +		unpin_user_pages(pages, res);
> 		res = 0;
> 	}
> 	kfree(pages);
> @@ -4977,18 +4976,9 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
> static int sgl_unmap_user_pages(struct st_buffer *STbp,
> 				const unsigned int nr_pages, int dirtied)
> {
> -	int i;
> -
> -	for (i=0; i < nr_pages; i++) {
> -		struct page *page = STbp->mapped_pages[i];
> +	/* FIXME: cache flush missing for rw==READ */
> +	unpin_user_pages_dirty_lock(STbp->mapped_pages, nr_pages, dirtied);
> 
> -		if (dirtied)
> -			SetPageDirty(page);
> -		/* FIXME: cache flush missing for rw==READ
> -		 * FIXME: call the correct reference counting function
> -		 */
> -		put_page(page);
> -	}
> 	kfree(STbp->mapped_pages);
> 	STbp->mapped_pages = NULL;
> 
> -- 
> 2.26.2
> 

