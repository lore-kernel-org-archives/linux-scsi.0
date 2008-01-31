From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 06:10:25 -0800
Message-ID: <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34183 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755054AbYAaORd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 09:17:33 -0500
In-Reply-To: <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

Greetings Geert and Co,

I have a related patch that I have been using with ps3rom.c for some
time that fixes a bug in fs/bio.c that assumes 512 byte sectors for
ATAPI operations.  This bug actually exists for all non 512 byte sector
devices go through this code path (I found it with
scsi_execute_async()), but I first ran into this issue with ps3rom.c
because max_sectors (32) is small enough to trigger the bug assuming 51=
2
byte sectors during typical ATAPI READ_10 ops with iSCSI/HD.  Because
typical max_sector settings for libata and USB are much higher, I have
never ran into this issue outside of ps3rom.c, but the bug exists
nevertheless..

The current patch assumes 512 byte sectors, and adds a sector_size
parameter to drivers/scsi/scsi_lib.c:scsi_req_map_sg() to change it for
passed struct request.  I know that some folks talked about killing
scsi_execute_async() and fixing this problem elsewhere, but until then
please consider this patch.  Any input is also appreciated.

:-)

--nab

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a417a6f..caa399c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -297,7 +297,8 @@ static int scsi_bi_endio(struct bio *bio, unsigned
int bytes_done, int error)
  * sent to use, as some ULDs use that struct to only organize the
pages.
  */
 static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl=
,
-                          int nsegs, unsigned bufflen, gfp_t gfp)
+                          int nsegs, unsigned bufflen, gfp_t gfp,
+                          unsigned int sector_size)
 {
        struct request_queue *q =3D rq->q;
        int nr_pages =3D (bufflen + sgl[0].offset + PAGE_SIZE - 1) >>
PAGE_SHIFT;
@@ -325,6 +326,8 @@ static int scsi_req_map_sg(struct request *rq,
struct scatterlist *sgl,
                                        goto free_bios;
                                }
                                bio->bi_end_io =3D scsi_bi_endio;
+                               if (sector_size !=3D bio->bi_sector_siz=
e)
+                                       bio->bi_sector_size =3D
sector_size;
                        }
=20
                        if (bio_add_pc_page(q, bio, page, bytes, off) !=
=3D
@@ -399,7 +402,8 @@ int scsi_execute_async(struct scsi_device *sdev,
const unsigned char *cmd,
        req->cmd_flags |=3D REQ_QUIET;
=20
        if (use_sg)
-               err =3D scsi_req_map_sg(req, buffer, use_sg, bufflen,
gfp);
+               err =3D scsi_req_map_sg(req, buffer, use_sg, bufflen, g=
fp,
+                               sdev->sector_size);
        else if (bufflen)
                err =3D blk_rq_map_kern(req->q, req, buffer, bufflen,
gfp);
=20

diff --git a/fs/bio.c b/fs/bio.c
index 29a44c1..00e0490 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -188,8 +188,10 @@ struct bio *bio_alloc(gfp_t gfp_mask, int
nr_iovecs)
 {
        struct bio *bio =3D bio_alloc_bioset(gfp_mask, nr_iovecs,
fs_bio_set);
=20
-       if (bio)
+       if (bio) {
+               bio->bi_sector_size =3D 512;
                bio->bi_destructor =3D bio_fs_destructor;
+       }
=20
        return bio;
 }
@@ -328,7 +330,7 @@ static int __bio_add_page(struct request_queue *q,
struct bio *bio, struct page
        if (unlikely(bio_flagged(bio, BIO_CLONED)))
                return 0;
=20
-       if (((bio->bi_size + len) >> 9) > max_sectors)
+       if (((bio->bi_size + len) / bio->bi_sector_size) > max_sectors)
                return 0;
=20
        /*
@@ -352,8 +354,9 @@ static int __bio_add_page(struct request_queue *q,
struct bio *bio, struct page
                }
        }
=20
-       if (bio->bi_vcnt >=3D bio->bi_max_vecs)
+       if (bio->bi_vcnt >=3D bio->bi_max_vecs) {
                return 0;
+       }
=20
        /*
         * we might lose a segment or two here, but rather that than
@@ -1026,7 +1029,7 @@ void bio_endio(struct bio *bio, unsigned int
bytes_done, int error)
        }
=20
        bio->bi_size -=3D bytes_done;
-       bio->bi_sector +=3D (bytes_done >> 9);
+       bio->bi_sector +=3D (bytes_done / bio->bi_sector_size);
=20
        if (bio->bi_end_io)
                bio->bi_end_io(bio, bytes_done, error);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1ddef34..e9ed1d1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -105,6 +105,7 @@ struct bio {
        unsigned int            bi_hw_back_size;
=20
        unsigned int            bi_max_vecs;    /* max bvl_vecs we can
hold */
+       unsigned int            bi_sector_size; /* sector size */
=20
        struct bio_vec          *bi_io_vec;     /* the actual vec list
*/



On Thu, 2008-01-31 at 14:28 +0100, Geert Uytterhoeven wrote:
> On Tue, 29 Jan 2008, Aegis Lin wrote:
> > Quite minor patch, but from the context it should be desired
> > that 64KB is available for ATAPI transferrring.
> > (Historically) in SCSI/block layer sector size is defined as
> > 512 during sector-byte calculation. Originally in ps3rom.c
> > CD_FRAMESIZE was used, which makes
> > /sys/block/sr0/queue/max_sectors_kb
> > to be limited to 16KB.
>=20
> Can I please have a Signed-off-by?
>=20
> > diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> > index 17b4a7c..cc7062b 100644
> > --- a/drivers/scsi/ps3rom.c
> > +++ b/drivers/scsi/ps3rom.c
> > @@ -35,7 +35,7 @@
> > =20
> >  #define BOUNCE_SIZE			(64*1024)
> > =20
> > -#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
> > +#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / 512)
> > =20
> > =20
> >  struct ps3rom_private {
>=20
> Indeed, scsi_host_template.max_sectors seems to be just passed to the=
 block
> layer, so it concerns 512-byte sectors.
>=20
> Furthermore, drivers/cdrom/cdrom.c:cdrom_read_cdda_bpc() seems to han=
dle the
> conversion from raw CD frame sizes to 512-byte sectors, and limit the=
 requested
> number of sectors if needed.
>=20
> However, I didn't find where it handles conversion from CD data frame=
 sizes to
> 512-byte sectors.
>=20
> Am I missing something?
>=20
> With kind regards,
>=20
> Geert Uytterhoeven
> Software Architect
>=20
> Sony Network and Software Technology Center Europe
> The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem=
 =C2=B7 Belgium
>=20
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
>=20
> Sony Network and Software Technology Center Europe
> A division of Sony Service Centre (Europe) N.V.
> Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 =
Belgium
> VAT BE 0413.825.160 =C2=B7 RPR Brussels
> Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
