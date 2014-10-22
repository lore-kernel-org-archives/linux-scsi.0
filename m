From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/18] dm: remove num_write_bios
Date: Wed, 22 Oct 2014 09:25:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220924370.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The target can set the function num_write_bios - dm will issue this
callback to ask the target how many bios does it want to receive.

This was intended for the dm-cache target, but it is not useable due to a
race condition (see the description of
e2e74d617eadc15f601983270c4f4a6935c5a943). num_write_bios is unused, so we
remove it.

Note that we deliberately leave the for loop in __clone_and_map_data_bio -
it will be used in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |    6 ------
 include/linux/device-mapper.h |   15 ---------------
 2 files changed, 21 deletions(-)

Index: linux-3.18-rc1/drivers/md/dm.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm.c	2014-10-21 00:53:43.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm.c	2014-10-21 00:53:47.000000000 +0200
@@ -1433,12 +1433,6 @@ static void __clone_and_map_data_bio(str
 	unsigned target_bio_nr;
 	unsigned num_target_bios = 1;
 
-	/*
-	 * Does the target want to receive duplicate copies of the bio?
-	 */
-	if (bio_data_dir(bio) == WRITE && ti->num_write_bios)
-		num_target_bios = ti->num_write_bios(ti, bio);
-
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
 		tio = alloc_tio(ci, ti, target_bio_nr);
 		tio->len_ptr = len;
Index: linux-3.18-rc1/include/linux/device-mapper.h
===================================================================
--- linux-3.18-rc1.orig/include/linux/device-mapper.h	2014-10-21 00:53:43.000000000 +0200
+++ linux-3.18-rc1/include/linux/device-mapper.h	2014-10-21 00:53:47.000000000 +0200
@@ -184,14 +184,6 @@ struct target_type {
 #define DM_TARGET_IMMUTABLE		0x00000004
 #define dm_target_is_immutable(type)	((type)->features & DM_TARGET_IMMUTABLE)
 
-/*
- * Some targets need to be sent the same WRITE bio severals times so
- * that they can send copies of it to different devices.  This function
- * examines any supplied bio and returns the number of copies of it the
- * target requires.
- */
-typedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct bio *bio);
-
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
@@ -231,13 +223,6 @@ struct dm_target {
 	 */
 	unsigned per_bio_data_size;
 
-	/*
-	 * If defined, this function is called to find out how many
-	 * duplicate bios should be sent to the target when writing
-	 * data.
-	 */
-	dm_num_write_bios_fn num_write_bios;
-
 	/* target specific data */
 	void *private;
 
