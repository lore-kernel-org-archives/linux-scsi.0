Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B510C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 01:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F24207CB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 01:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="Bzlg9uee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgE0BFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 21:05:03 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7594 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgE0BFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 21:05:03 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecdbcb20004>; Tue, 26 May 2020 18:04:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 26 May 2020 18:05:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 26 May 2020 18:05:02 -0700
Received: from [10.2.50.17] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 May
 2020 01:05:02 +0000
Subject: Re: [PATCH v2] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     LKML <linux-kernel@vger.kernel.org>
CC:     Souptick Joarder <jrdr.linux@gmail.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>, Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20200526182709.99599-1-jhubbard@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <98b7f283-b208-d222-1d65-8a2e34d0a1af@nvidia.com>
Date:   Tue, 26 May 2020 18:05:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526182709.99599-1-jhubbard@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590541490; bh=k+7tPPYD5h+NdS6yysmsG/8IjYDDmjMzwUUxALLypYA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Bzlg9ueeG2PtNpxgtAnl9vhkNsA/2V64twVVFa9EQJ/2hDldvz6fLHZHTYGOAcqc2
         o/fcQ51QmX+myM2Y2L4IVB7qN7bxPlTwtxb2WhrnFk8jbQ8nawxtJW8d0Kj+xFkOCK
         Lw3LJzevYUoUMsTp9O/nklufJ6azyZ8EbsCSUUP5+Wz6xMcbEE32XWvOIU9DM27l63
         cdC5vyamBCbdt4LaXnldV2SiZOuvh0XJN9ackoPzJD/MkbbrdLiiSJlHot20PNSKKs
         Bg1dx3b9Amu4f6ybnWMr0rQdaOr9LGP8DcsxNGuYcGZ0GP4DxIwUI3t8XbGIhtlI6z
         633pBOPVpiY0A==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For some reason, the "convert convert" subject line is really hard to get r=
id of
from my scsi st patch. In this case, I'd dropped the patch entirely,
and recreated it with the old subject line somehow. Sorry about that
persistent typo!

I'll send a v3 if necessary, to correct that.

thanks,
John Hubbard
NVIDIA

On 2020-05-26 11:27, John Hubbard wrote:
> This code was using get_user_pages*(), in a "Case 1" scenario
> (Direct IO), using the categorization from [1]. That means that it's
> time to convert the get_user_pages*() + put_page() calls to
> pin_user_pages*() + unpin_user_pages() calls.
>=20
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
>=20
> Note that this effectively changes the code's behavior as well: it now
> ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
> is probably more accurate.
>=20
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [3]
>=20
> Also, this deletes one of the two FIXME comments (about refcounting),
> because there is nothing wrong with the refcounting at this point.
>=20
> [1] Documentation/core-api/pin_user_pages.rst
>=20
> [2] "Explicit pinning of user-space pages":
>      https://lwn.net/Articles/807108/
>=20
> [3] https://lore.kernel.org/r/20190723153640.GB720@lst.de
>=20
> Cc: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>=20
> Hi,
>=20
> As mentioned in the v1 review thread, we probably still want/need
> this. Or so I claim. :) Please see what you think...
>=20
> Changes since v1: changed the commit log, to refer to Direct IO
> (Case 1), instead of DMA/RDMA (Case 2). And added Bart to Cc.
>=20
> v1:
> https://lore.kernel.org/linux-scsi/20200519045525.2446851-1-jhubbard@nvid=
ia.com/
>=20
> thanks,
> John Hubbard
> NVIDIA
>=20
>=20
>   drivers/scsi/st.c | 20 +++++---------------
>   1 file changed, 5 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index c5f9b348b438..1e3eda9fa231 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4922,7 +4922,7 @@ static int sgl_map_user_pages(struct st_buffer *STb=
p,
>   	unsigned long end =3D (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
>   	unsigned long start =3D uaddr >> PAGE_SHIFT;
>   	const int nr_pages =3D end - start;
> -	int res, i, j;
> +	int res, i;
>   	struct page **pages;
>   	struct rq_map_data *mdata =3D &STbp->map_data;
>  =20
> @@ -4944,7 +4944,7 @@ static int sgl_map_user_pages(struct st_buffer *STb=
p,
>  =20
>           /* Try to fault in all of the necessary pages */
>           /* rw=3D=3DREAD means read from drive, write into memory area *=
/
> -	res =3D get_user_pages_fast(uaddr, nr_pages, rw =3D=3D READ ? FOLL_WRIT=
E : 0,
> +	res =3D pin_user_pages_fast(uaddr, nr_pages, rw =3D=3D READ ? FOLL_WRIT=
E : 0,
>   				  pages);
>  =20
>   	/* Errors and no page mapped should return here */
> @@ -4964,8 +4964,7 @@ static int sgl_map_user_pages(struct st_buffer *STb=
p,
>   	return nr_pages;
>    out_unmap:
>   	if (res > 0) {
> -		for (j=3D0; j < res; j++)
> -			put_page(pages[j]);
> +		unpin_user_pages(pages, res);
>   		res =3D 0;
>   	}
>   	kfree(pages);
> @@ -4977,18 +4976,9 @@ static int sgl_map_user_pages(struct st_buffer *ST=
bp,
>   static int sgl_unmap_user_pages(struct st_buffer *STbp,
>   				const unsigned int nr_pages, int dirtied)
>   {
> -	int i;
> -
> -	for (i=3D0; i < nr_pages; i++) {
> -		struct page *page =3D STbp->mapped_pages[i];
> +	/* FIXME: cache flush missing for rw=3D=3DREAD */
> +	unpin_user_pages_dirty_lock(STbp->mapped_pages, nr_pages, dirtied);
>  =20
> -		if (dirtied)
> -			SetPageDirty(page);
> -		/* FIXME: cache flush missing for rw=3D=3DREAD
> -		 * FIXME: call the correct reference counting function
> -		 */
> -		put_page(page);
> -	}
>   	kfree(STbp->mapped_pages);
>   	STbp->mapped_pages =3D NULL;
>  =20
>=20

