Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482D8C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 04:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2848E206D4
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 04:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="Su9d2uKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgESEz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 00:55:28 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19216 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgESEz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 00:55:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec366710000>; Mon, 18 May 2020 21:54:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 18 May 2020 21:55:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 18 May 2020 21:55:27 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 04:55:27 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 19 May 2020 04:55:27 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.55.90]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ec366be0004>; Mon, 18 May 2020 21:55:27 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: st: convert convert get_user_pages() --> pin_user_pages()
Date:   Mon, 18 May 2020 21:55:25 -0700
Message-ID: <20200519045525.2446851-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589864049; bh=y7ZGqZbOGTyig85XFWwJiWU7MUjiGK9+NipTHeZgGFw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=Su9d2uKPrbXNdMUViNd/L97OsaxGH5Lzxmux/E2Z7MUnViIh8lQIHtnbUnvbqi1j/
         97TS6KfQPJGFKGgdH3XzjOJmm8S2Wg4k+gVIzjb463PrMGc88/xp21URtukEyobu6e
         b+kt6SjwznwV5S6bDizkhw0JAz6kdKlO9MaHMRNTDTkGwUsZ89KDY4cvtHA/pYYkNx
         950uAI5boUlAlxVr7MFFsIfodnuHP8tyf3jOQP0xE6TCycw2MUbjd+KDnjEqXClTIY
         D5cNLd404vW9JqoTda/1QcPb7kHdq78ZjVC+b7HCOOaRjmDKRoO6wQSyAbaBJLmrUV
         YoxhrAHMykE0Q==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code was using get_user_pages*(), in a "Case 2" scenario
(DMA/RDMA), using the categorization from [1]. That means that it's
time to convert the get_user_pages*() + put_page() calls to
pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

Note that this effectively changes the code's behavior as well: it now
ultimately calls set_page_dirty_lock(), instead of SetPageDirty().This
is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [3]

Also, this deletes one of the two FIXME comments (about refcounting),
because there is nothing wrong with the refcounting at this point.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

[3] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: "Kai M=C3=A4kisara" <Kai.Makisara@kolumbus.fi>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/scsi/st.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c5f9b348b438..0369c7edfd94 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4922,7 +4922,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 	unsigned long end =3D (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start =3D uaddr >> PAGE_SHIFT;
 	const int nr_pages =3D end - start;
-	int res, i, j;
+	int res, i;
 	struct page **pages;
 	struct rq_map_data *mdata =3D &STbp->map_data;
=20
@@ -4944,7 +4944,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
=20
         /* Try to fault in all of the necessary pages */
         /* rw=3D=3DREAD means read from drive, write into memory area */
-	res =3D get_user_pages_fast(uaddr, nr_pages, rw =3D=3D READ ? FOLL_WRITE =
: 0,
+	res =3D pin_user_pages_fast(uaddr, nr_pages, rw =3D=3D READ ? FOLL_WRITE =
: 0,
 				  pages);
=20
 	/* Errors and no page mapped should return here */
@@ -4964,8 +4964,7 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 	return nr_pages;
  out_unmap:
 	if (res > 0) {
-		for (j=3D0; j < res; j++)
-			put_page(pages[j]);
+		unpin_user_pages(pages, res);
 		res =3D 0;
 	}
 	kfree(pages);
@@ -4977,18 +4976,10 @@ static int sgl_map_user_pages(struct st_buffer *STb=
p,
 static int sgl_unmap_user_pages(struct st_buffer *STbp,
 				const unsigned int nr_pages, int dirtied)
 {
-	int i;
+	/* FIXME: cache flush missing for rw=3D=3DREAD */
=20
-	for (i=3D0; i < nr_pages; i++) {
-		struct page *page =3D STbp->mapped_pages[i];
+	unpin_user_pages_dirty_lock(STbp->mapped_pages, nr_pages, dirtied);
=20
-		if (dirtied)
-			SetPageDirty(page);
-		/* FIXME: cache flush missing for rw=3D=3DREAD
-		 * FIXME: call the correct reference counting function
-		 */
-		put_page(page);
-	}
 	kfree(STbp->mapped_pages);
 	STbp->mapped_pages =3D NULL;
=20
--=20
2.26.2

