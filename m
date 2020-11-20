Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE474C56201
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 14:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566572236F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 14:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GDlyFebe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKTOHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 09:07:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:54535 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgKTOG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 09:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605881203;
        bh=zAP6uB+ZuVfJQTRZsHbh9PuVIDjQBNHLT3316VQk/sc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=GDlyFebeRtGTFMdIxXDYQC6wQmW4pyEYoKNqtDIWsMiZgzjYiaZaAxZ4Bv0XpLgoO
         5Gk2kc1zLaw5dZfXUitPuVYqjSkPApOW+HEo1vDzwbGAw9QmqQplOhKHumIs5ObLYa
         QIt5pU/PBv+13PBV15iApJaATWAv29A4aVLSf8co=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([84.179.249.86]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MXXyP-1kkl4821ZH-00Z0Po; Fri, 20
 Nov 2020 15:06:43 +0100
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de, axboe@kernel.dk,
        hpa@zytor.com, debian-powerpc@lists.debian.org,
        Thomas Schmitt <scdbackup@gmx.net>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH] isofs: fix Oops with zisofs and large PAGE_SIZE
Date:   Fri, 20 Nov 2020 15:06:33 +0100
Message-Id: <20201120140633.1673-1-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QmZkG7PRLjD/Js21gHVZPpypVekUjFJVPAJaQMfsBC+opDc5R2l
 QYkKsjAgrCdPgz/4RrrFvo+J67e09puOz0zLpra1EqXlEuuXK6C82e6o3nI/xF2A1ggb8Aw
 WbRMUHK7vel4iO5iiGib6T18WV1A42AgMJBmpigqsufKxIAh0Z/83c/DRXIo+Yzro17qYrD
 FkjKeWmx/NUgwLhbbwfRg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wnzSlLVIzTM=:DDwJrwgJ9yuLVhpabYTqSP
 rxy8vCSQOxo3f33wi9+wzerp482+RQywGBEnrICXlU8Nn+FrayfiJ+bWm1uXW9dxJCtqPAH9v
 2Vh3cdTUSiKAdY4ytBdbN09YVdtkXlWUadR6vXkR0MHoBZDZ6aYERP8qlRwimlnMGD+K2NbOj
 qArDEBWRY46aGkjSDFewze+cFk88xlnnWZ2Xyvi96Q3j6yMOnN/FSlv4k2NAYfmNNJHCzJTVY
 dh5m4ooHDmL/QfzkSFh+nh6bvNlQLjptviDMwjFWIj/+CZDSR1SHYb08MwC+hRhHmyjB7GQNc
 R+4sQQmLWFXW02NJqlnSH8QwyUiPuxHRRz3imj8J261HGjPyo0bwe6DVzKd7UJ3rOgP74dvD0
 qMnZTq4/0H53wrVD5hVyfZc5DTLu/UKmqB25p2/SE1Ape/a2R/+tqwEKiU5xHrXoFYIzAEA5v
 B+Y8iiZG4suwy3LgQbNfeHjWw+BltXOS6n7SLWAyVgInnjU2dfoXRGx7VEUtVbXHibUMKOIwr
 fyLdgYUeoKIplHIL/Hrtfo2kWy7WUJkMnw697E5RsoJWs1AV/ojfx5KI5jE+MvaTI5gLMOfAh
 6W11QtoMbTJ84eymC29IbDDCfZmS10OvgzyJwzDGKgAvL8mk0sX69r03QrqqA7lYu81cxNbcs
 QSX0sV1f2MIX8wUgCwCZNf3B8Hg8jIIVedyaNPNqUr/xjps08e6fS82FSxaYXGkcDY31dkFGz
 Q4b2MEZ6OJa2P/Oairhexi3BPZ3hsFIb55mBcWOBr+u73O5stNniMuHXdIlt9Zk8or/te8ZKu
 bNDmFZWPzBJnFTh10C4522YoCDlc87rkYY52pFCsJ+pQXwd2Tu/QWBISBCgf58ewbEVKDsaOp
 cNgvr4SbwqlqRW1INg3w==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a "5.9.0-1-powerpc64" system with PAGE_SIZE 64 KiB, the attempt to read
a zisofs compressed file with zisofs block size 32 KiB yields a kernel
Oops if the file contains sparse blocks of 32 KiB all zeros.

BUG: Unable to handle kernel data access on read at 0xfff01417f3f98000
Faulting instruction address: 0xc0000000000ad4b0
Oops: Kernel access of bad area, sig: 11 [#1]
BE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048 NUMA pSeries
Modules linked in: isofs(E) loop(E) sg(E) drm(E)
  drm_panel_orientation_quirks(E) ip_tables(E) x_tables(E)
  autofs4(E) ext4(E) crc16(E) mb>
CPU: 0 PID: 12433 Comm: md5sum Tainted: G            E
  5.9.0-1-powerpc64 #1 Debian 5.9.1-1
NIP:  c0000000000ad4b0 LR: c008000001086628 CTR: 0000000000000200
[... lines "REGS:" to "GPR28:" skipped ...]
NIP [c0000000000ad4b0] .memset+0x68/0x104
LR [c008000001086628]  .zisofs_readpage+0xbd8/0xd90 [isofs]
Call Trace:
[c0000003f40fb650] [c008000001085ec0] .zisofs_readpage+0x470/0xd90 [isofs]
(unreliable)
[c0000003f40fb830] [c0000000003a4d08] .read_pages+0x2f8/0x390
[c0000003f40fb900] [c0000000003a53b4] .page_cache_readahead_unbounded
+0x224/0x2f0
[c0000003f40fba20] [c0000000003960c4] .generic_file_buffered_read
+0x704/0xcf0
[...]

Userland experiences a segmentation fault.

This happened when the first 32 KiB of the original uncompressed file were
not all 0, but the next 32 KiB were all 0.

Cause is the handling of sparse compression blocks in function
zisofs_uncompress_block(). It does does not take into account that the
compression block contains less data than the page can take, but rather
zeros the whole page and returns as decompressed data amount the PAGE_SIZE
instead of the zisofs block size.
This causes the wrong impression with the caller zisofs_fill_pages()
that an incomplete page should be padded up:

        if (poffset && *pages) {
                memset(page_address(*pages) + poffset, 0,
                       PAGE_SIZE - poffset);

poffset is 32 KiB from the wrong decompressed amount of 32K + 64K instead
of the correct 32K + 32K, which would have yielded poffset 0.
But at that time the pages pointer has already moved beyond the end of
the allocated array of page structs (which has only 1 element).

Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
Tested-by: Anatoly Pugachev <matorola@gmail.com>
=2D--
 fs/isofs/compress.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index bc12ac7e2312..15a5b4e63f97 100644
=2D-- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -43,6 +43,7 @@ static loff_t zisofs_uncompress_block(struct inode *inod=
e, loff_t block_start,
 				      int *errp)
 {
 	unsigned int zisofs_block_shift =3D ISOFS_I(inode)->i_format_parm[1];
+	unsigned long zisofs_block_size =3D 1UL << zisofs_block_shift;
 	unsigned int bufsize =3D ISOFS_BUFFER_SIZE(inode);
 	unsigned int bufshift =3D ISOFS_BUFFER_BITS(inode);
 	unsigned int bufmask =3D bufsize - 1;
@@ -57,21 +58,39 @@ static loff_t zisofs_uncompress_block(struct inode *in=
ode, loff_t block_start,
 	blkcnt_t blocknum;
 	struct buffer_head **bhs;
 	int curbh, curpage;
+	loff_t zeros_count =3D 0;
+	unsigned int zeros_chunk;

-	if (block_size > deflateBound(1UL << zisofs_block_shift)) {
+	if (block_size > deflateBound(zisofs_block_size)) {
 		*errp =3D -EIO;
 		return 0;
 	}
 	/* Empty block? */
 	if (block_size =3D=3D 0) {
+		/*
+		 * If poffset is > 0 take care to fill only a part of pages[0].
+		 * This is supposed to happen only if
+		 *   zisofs_block_size < PAGE_SIZE
+		 * pcount is then supposed to be 1, but better enforce the
+		 * loop end after the first pass.
+		 */
 		for ( i =3D 0 ; i < pcount ; i++ ) {
-			if (!pages[i])
-				continue;
-			memset(page_address(pages[i]), 0, PAGE_SIZE);
-			flush_dcache_page(pages[i]);
-			SetPageUptodate(pages[i]);
+			zeros_chunk =3D min_t(unsigned long, PAGE_SIZE - poffset,
+					    zisofs_block_size);
+			zeros_count +=3D zeros_chunk;
+			if (pages[i]) {
+				memset(page_address(pages[i]) + poffset, 0,
+				       zeros_chunk);
+				if (poffset + zeros_chunk >=3D PAGE_SIZE) {
+					flush_dcache_page(pages[i]);
+					SetPageUptodate(pages[i]);
+				}
+			}
+			poffset =3D 0;
+			if (zisofs_block_size < PAGE_SIZE)
+				break;
 		}
-		return ((loff_t)pcount) << PAGE_SHIFT;
+		return zeros_count;
 	}

 	/* Because zlib is not thread-safe, do all the I/O at the top. */
=2D-
2.20.1

