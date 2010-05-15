From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] block: use struct parsed_partitions *state universally in partition check code
Date: Sat, 15 May 2010 20:09:30 +0200
Message-ID: <1273946974-29131-5-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@daveml
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make the following changes to partition check code.

* Add ->bdev to struct parsed_partitions.

* Introduce read_part_sector() which is a simple wrapper around
  read_dev_sector() which takes struct parsed_partitions *state
  instead of @bdev.

* For functions which used to take @state and @bdev, drop @bdev.  For
  functions which used to take @bdev, replace it with @state.

* While updating, drop superflous checks on NULL state/bdev in ldm.c.

This cleans up the API a bit and enables better handling of IO errors
during partition check as the generic partition check code now has
much better visibility into what went wrong in the low level code
paths.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 fs/partitions/acorn.c  |   68 +++++++++++++++++-------------------
 fs/partitions/acorn.h  |   10 +++---
 fs/partitions/amiga.c  |   13 +++----
 fs/partitions/amiga.h  |    2 +-
 fs/partitions/atari.c  |    8 ++--
 fs/partitions/atari.h  |    2 +-
 fs/partitions/check.c  |    5 ++-
 fs/partitions/check.h  |    7 ++++
 fs/partitions/efi.c    |   91 ++++++++++++++++++++++-------------------------
 fs/partitions/efi.h    |    2 +-
 fs/partitions/ibm.c    |   21 +++++------
 fs/partitions/ibm.h    |    2 +-
 fs/partitions/karma.c  |    4 +-
 fs/partitions/karma.h  |    2 +-
 fs/partitions/ldm.c    |   89 +++++++++++++++++++++++-----------------------
 fs/partitions/ldm.h    |    2 +-
 fs/partitions/mac.c    |   11 +++---
 fs/partitions/mac.h    |    2 +-
 fs/partitions/msdos.c  |   85 +++++++++++++++++++-------------------------
 fs/partitions/msdos.h  |    2 +-
 fs/partitions/osf.c    |    4 +-
 fs/partitions/osf.h    |    2 +-
 fs/partitions/sgi.c    |    6 ++--
 fs/partitions/sgi.h    |    2 +-
 fs/partitions/sun.c    |    6 ++--
 fs/partitions/sun.h    |    2 +-
 fs/partitions/sysv68.c |    6 ++--
 fs/partitions/sysv68.h |    2 +-
 fs/partitions/ultrix.c |    4 +-
 fs/partitions/ultrix.h |    2 +-
 30 files changed, 225 insertions(+), 239 deletions(-)

diff --git a/fs/partitions/acorn.c b/fs/partitions/acorn.c
index a97b477..6921e78 100644
--- a/fs/partitions/acorn.c
+++ b/fs/partitions/acorn.c
@@ -70,14 +70,14 @@ struct riscix_record {
 
 #if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
 	defined(CONFIG_ACORN_PARTITION_ADFS)
-static int
-riscix_partition(struct parsed_partitions *state, struct block_device *bdev,
-		unsigned long first_sect, int slot, unsigned long nr_sects)
+static int riscix_partition(struct parsed_partitions *state,
+			    unsigned long first_sect, int slot,
+			    unsigned long nr_sects)
 {
 	Sector sect;
 	struct riscix_record *rr;
 	
-	rr = (struct riscix_record *)read_dev_sector(bdev, first_sect, &sect);
+	rr = read_part_sector(state, first_sect, &sect);
 	if (!rr)
 		return -1;
 
@@ -123,9 +123,9 @@ struct linux_part {
 
 #if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
 	defined(CONFIG_ACORN_PARTITION_ADFS)
-static int
-linux_partition(struct parsed_partitions *state, struct block_device *bdev,
-		unsigned long first_sect, int slot, unsigned long nr_sects)
+static int linux_partition(struct parsed_partitions *state,
+			   unsigned long first_sect, int slot,
+			   unsigned long nr_sects)
 {
 	Sector sect;
 	struct linux_part *linuxp;
@@ -135,7 +135,7 @@ linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 
 	put_partition(state, slot++, first_sect, size);
 
-	linuxp = (struct linux_part *)read_dev_sector(bdev, first_sect, &sect);
+	linuxp = read_part_sector(state, first_sect, &sect);
 	if (!linuxp)
 		return -1;
 
@@ -157,8 +157,7 @@ linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 #endif
 
 #ifdef CONFIG_ACORN_PARTITION_CUMANA
-int
-adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev)
+int adfspart_check_CUMANA(struct parsed_partitions *state)
 {
 	unsigned long first_sector = 0;
 	unsigned int start_blk = 0;
@@ -185,7 +184,7 @@ adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev
 		struct adfs_discrecord *dr;
 		unsigned int nr_sects;
 
-		data = read_dev_sector(bdev, start_blk * 2 + 6, &sect);
+		data = read_part_sector(state, start_blk * 2 + 6, &sect);
 		if (!data)
 			return -1;
 
@@ -217,14 +216,14 @@ adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev
 #ifdef CONFIG_ACORN_PARTITION_RISCIX
 		case PARTITION_RISCIX_SCSI:
 			/* RISCiX - we don't know how to find the next one. */
-			slot = riscix_partition(state, bdev, first_sector,
-						 slot, nr_sects);
+			slot = riscix_partition(state, first_sector, slot,
+						nr_sects);
 			break;
 #endif
 
 		case PARTITION_LINUX:
-			slot = linux_partition(state, bdev, first_sector,
-						slot, nr_sects);
+			slot = linux_partition(state, first_sector, slot,
+					       nr_sects);
 			break;
 		}
 		put_dev_sector(sect);
@@ -249,8 +248,7 @@ adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev
  *	    hda1 = ADFS partition on first drive.
  *	    hda2 = non-ADFS partition.
  */
-int
-adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
+int adfspart_check_ADFS(struct parsed_partitions *state)
 {
 	unsigned long start_sect, nr_sects, sectscyl, heads;
 	Sector sect;
@@ -259,7 +257,7 @@ adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
 	unsigned char id;
 	int slot = 1;
 
-	data = read_dev_sector(bdev, 6, &sect);
+	data = read_part_sector(state, 6, &sect);
 	if (!data)
 		return -1;
 
@@ -278,21 +276,21 @@ adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
 	/*
 	 * Work out start of non-adfs partition.
 	 */
-	nr_sects = (bdev->bd_inode->i_size >> 9) - start_sect;
+	nr_sects = (state->bdev->bd_inode->i_size >> 9) - start_sect;
 
 	if (start_sect) {
 		switch (id) {
 #ifdef CONFIG_ACORN_PARTITION_RISCIX
 		case PARTITION_RISCIX_SCSI:
 		case PARTITION_RISCIX_MFM:
-			slot = riscix_partition(state, bdev, start_sect,
-						 slot, nr_sects);
+			slot = riscix_partition(state, start_sect, slot,
+						nr_sects);
 			break;
 #endif
 
 		case PARTITION_LINUX:
-			slot = linux_partition(state, bdev, start_sect,
-						slot, nr_sects);
+			slot = linux_partition(state, start_sect, slot,
+					       nr_sects);
 			break;
 		}
 	}
@@ -308,10 +306,11 @@ struct ics_part {
 	__le32 size;
 };
 
-static int adfspart_check_ICSLinux(struct block_device *bdev, unsigned long block)
+static int adfspart_check_ICSLinux(struct parsed_partitions *state,
+				   unsigned long block)
 {
 	Sector sect;
-	unsigned char *data = read_dev_sector(bdev, block, &sect);
+	unsigned char *data = read_part_sector(state, block, &sect);
 	int result = 0;
 
 	if (data) {
@@ -349,8 +348,7 @@ static inline int valid_ics_sector(const unsigned char *data)
  *	    hda2 = ADFS partition 1 on first drive.
  *		..etc..
  */
-int
-adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
+int adfspart_check_ICS(struct parsed_partitions *state)
 {
 	const unsigned char *data;
 	const struct ics_part *p;
@@ -360,7 +358,7 @@ adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
 	/*
 	 * Try ICS style partitions - sector 0 contains partition info.
 	 */
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 	    	return -1;
 
@@ -392,7 +390,7 @@ adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
 			 * partition is.  We must not make this visible
 			 * to the filesystem.
 			 */
-			if (size > 1 && adfspart_check_ICSLinux(bdev, start)) {
+			if (size > 1 && adfspart_check_ICSLinux(state, start)) {
 				start += 1;
 				size -= 1;
 			}
@@ -446,8 +444,7 @@ static inline int valid_ptec_sector(const unsigned char *data)
  *	    hda2 = ADFS partition 1 on first drive.
  *		..etc..
  */
-int
-adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev)
+int adfspart_check_POWERTEC(struct parsed_partitions *state)
 {
 	Sector sect;
 	const unsigned char *data;
@@ -455,7 +452,7 @@ adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bd
 	int slot = 1;
 	int i;
 
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
 
@@ -508,8 +505,7 @@ static const char eesox_name[] = {
  *  1. The individual ADFS boot block entries that are placed on the disk.
  *  2. The start address of the next entry.
  */
-int
-adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev)
+int adfspart_check_EESOX(struct parsed_partitions *state)
 {
 	Sector sect;
 	const unsigned char *data;
@@ -518,7 +514,7 @@ adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev)
 	sector_t start = 0;
 	int i, slot = 1;
 
-	data = read_dev_sector(bdev, 7, &sect);
+	data = read_part_sector(state, 7, &sect);
 	if (!data)
 		return -1;
 
@@ -545,7 +541,7 @@ adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev)
 	if (i != 0) {
 		sector_t size;
 
-		size = get_capacity(bdev->bd_disk);
+		size = get_capacity(state->bdev->bd_disk);
 		put_partition(state, slot++, start, size - start);
 		printk("\n");
 	}
diff --git a/fs/partitions/acorn.h b/fs/partitions/acorn.h
index 81fd50e..ede8285 100644
--- a/fs/partitions/acorn.h
+++ b/fs/partitions/acorn.h
@@ -7,8 +7,8 @@
  *  format, and everyone stick to it?
  */
 
-int adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev);
+int adfspart_check_CUMANA(struct parsed_partitions *state);
+int adfspart_check_ADFS(struct parsed_partitions *state);
+int adfspart_check_ICS(struct parsed_partitions *state);
+int adfspart_check_POWERTEC(struct parsed_partitions *state);
+int adfspart_check_EESOX(struct parsed_partitions *state);
diff --git a/fs/partitions/amiga.c b/fs/partitions/amiga.c
index 9917a8c..ba443d4 100644
--- a/fs/partitions/amiga.c
+++ b/fs/partitions/amiga.c
@@ -23,8 +23,7 @@ checksum_block(__be32 *m, int size)
 	return sum;
 }
 
-int
-amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
+int amiga_partition(struct parsed_partitions *state)
 {
 	Sector sect;
 	unsigned char *data;
@@ -38,11 +37,11 @@ amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
 	for (blk = 0; ; blk++, put_dev_sector(sect)) {
 		if (blk == RDB_ALLOCATION_LIMIT)
 			goto rdb_done;
-		data = read_dev_sector(bdev, blk, &sect);
+		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
 				printk("Dev %s: unable to read RDB block %d\n",
-				       bdevname(bdev, b), blk);
+				       bdevname(state->bdev, b), blk);
 			res = -1;
 			goto rdb_done;
 		}
@@ -64,7 +63,7 @@ amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
 		}
 
 		printk("Dev %s: RDB in block %d has bad checksum\n",
-			       bdevname(bdev, b), blk);
+		       bdevname(state->bdev, b), blk);
 	}
 
 	/* blksize is blocks per 512 byte standard block */
@@ -75,11 +74,11 @@ amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
 	put_dev_sector(sect);
 	for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
 		blk *= blksize;	/* Read in terms partition table understands */
-		data = read_dev_sector(bdev, blk, &sect);
+		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
 				printk("Dev %s: unable to read partition block %d\n",
-				       bdevname(bdev, b), blk);
+				       bdevname(state->bdev, b), blk);
 			res = -1;
 			goto rdb_done;
 		}
diff --git a/fs/partitions/amiga.h b/fs/partitions/amiga.h
index 2f3e9ce..d094585 100644
--- a/fs/partitions/amiga.h
+++ b/fs/partitions/amiga.h
@@ -2,5 +2,5 @@
  *  fs/partitions/amiga.h
  */
 
-int amiga_partition(struct parsed_partitions *state, struct block_device *bdev);
+int amiga_partition(struct parsed_partitions *state);
 
diff --git a/fs/partitions/atari.c b/fs/partitions/atari.c
index 1f3572d..4439ff1 100644
--- a/fs/partitions/atari.c
+++ b/fs/partitions/atari.c
@@ -30,7 +30,7 @@ static inline int OK_id(char *s)
 		memcmp (s, "RAW", 3) == 0 ;
 }
 
-int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
+int atari_partition(struct parsed_partitions *state)
 {
 	Sector sect;
 	struct rootsector *rs;
@@ -42,12 +42,12 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 	int part_fmt = 0; /* 0:unknown, 1:AHDI, 2:ICD/Supra */
 #endif
 
-	rs = (struct rootsector *) read_dev_sector(bdev, 0, &sect);
+	rs = read_part_sector(state, 0, &sect);
 	if (!rs)
 		return -1;
 
 	/* Verify this is an Atari rootsector: */
-	hd_size = bdev->bd_inode->i_size >> 9;
+	hd_size = state->bdev->bd_inode->i_size >> 9;
 	if (!VALID_PARTITION(&rs->part[0], hd_size) &&
 	    !VALID_PARTITION(&rs->part[1], hd_size) &&
 	    !VALID_PARTITION(&rs->part[2], hd_size) &&
@@ -84,7 +84,7 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 		printk(" XGM<");
 		partsect = extensect = be32_to_cpu(pi->st);
 		while (1) {
-			xrs = (struct rootsector *)read_dev_sector(bdev, partsect, &sect2);
+			xrs = read_part_sector(state, partsect, &sect2);
 			if (!xrs) {
 				printk (" block %ld read failed\n", partsect);
 				put_dev_sector(sect);
diff --git a/fs/partitions/atari.h b/fs/partitions/atari.h
index 63186b0..fe2d32a 100644
--- a/fs/partitions/atari.h
+++ b/fs/partitions/atari.h
@@ -31,4 +31,4 @@ struct rootsector
   u16 checksum;			/* checksum for bootable disks */
 } __attribute__((__packed__));
 
-int atari_partition(struct parsed_partitions *state, struct block_device *bdev);
+int atari_partition(struct parsed_partitions *state);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 4f1fee0..a19995c 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -45,7 +45,7 @@ extern void md_autodetect_dev(dev_t dev);
 
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
-static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
+static int (*check_part[])(struct parsed_partitions *) = {
 	/*
 	 * Probe partition formats with tables at disk address 0
 	 * that also have an ADFS boot block at 0xdc0.
@@ -165,6 +165,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (!state)
 		return NULL;
 
+	state->bdev = bdev;
 	disk_name(hd, 0, state->name);
 	printk(KERN_INFO " %s:", state->name);
 	if (isdigit(state->name[strlen(state->name)-1]))
@@ -174,7 +175,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
-		res = check_part[i++](state, bdev);
+		res = check_part[i++](state);
 		if (res < 0) {
 			/* We have hit an I/O error which we don't report now.
 		 	* But record it, and let the others do their job.
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index 98dbe1a..4b31a97 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -6,6 +6,7 @@
  * description.
  */
 struct parsed_partitions {
+	struct block_device *bdev;
 	char name[BDEVNAME_SIZE];
 	struct {
 		sector_t from;
@@ -16,6 +17,12 @@ struct parsed_partitions {
 	int limit;
 };
 
+static inline void *read_part_sector(struct parsed_partitions *state,
+				     sector_t n, Sector *p)
+{
+	return read_dev_sector(state->bdev, n, p);
+}
+
 static inline void
 put_partition(struct parsed_partitions *p, int n, sector_t from, sector_t size)
 {
diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 91babda..9e346c1 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -140,8 +140,7 @@ efi_crc32(const void *buf, unsigned long len)
  *  the part[0] entry for this disk, and is the number of
  *  physical sectors available on the disk.
  */
-static u64
-last_lba(struct block_device *bdev)
+static u64 last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
@@ -181,27 +180,28 @@ is_pmbr_valid(legacy_mbr *mbr)
 
 /**
  * read_lba(): Read bytes from disk, starting at given LBA
- * @bdev
+ * @state
  * @lba
  * @buffer
  * @size_t
  *
- * Description:  Reads @count bytes from @bdev into @buffer.
+ * Description: Reads @count bytes from @state->bdev into @buffer.
  * Returns number of bytes read on success, 0 on error.
  */
-static size_t
-read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
+static size_t read_lba(struct parsed_partitions *state,
+		       u64 lba, u8 *buffer, size_t count)
 {
 	size_t totalreadcount = 0;
+	struct block_device *bdev = state->bdev;
 	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
 
-	if (!bdev || !buffer || lba > last_lba(bdev))
+	if (!buffer || lba > last_lba(bdev))
                 return 0;
 
 	while (count) {
 		int copied = 512;
 		Sector sect;
-		unsigned char *data = read_dev_sector(bdev, n++, &sect);
+		unsigned char *data = read_part_sector(state, n++, &sect);
 		if (!data)
 			break;
 		if (copied > count)
@@ -217,19 +217,20 @@ read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 
 /**
  * alloc_read_gpt_entries(): reads partition entries from disk
- * @bdev
+ * @state
  * @gpt - GPT header
  * 
  * Description: Returns ptes on success,  NULL on error.
  * Allocates space for PTEs based on information found in @gpt.
  * Notes: remember to free pte when you're done!
  */
-static gpt_entry *
-alloc_read_gpt_entries(struct block_device *bdev, gpt_header *gpt)
+static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
+					 gpt_header *gpt)
 {
 	size_t count;
 	gpt_entry *pte;
-	if (!bdev || !gpt)
+
+	if (!gpt)
 		return NULL;
 
 	count = le32_to_cpu(gpt->num_partition_entries) *
@@ -240,7 +241,7 @@ alloc_read_gpt_entries(struct block_device *bdev, gpt_header *gpt)
 	if (!pte)
 		return NULL;
 
-	if (read_lba(bdev, le64_to_cpu(gpt->partition_entry_lba),
+	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
                      (u8 *) pte,
 		     count) < count) {
 		kfree(pte);
@@ -252,27 +253,24 @@ alloc_read_gpt_entries(struct block_device *bdev, gpt_header *gpt)
 
 /**
  * alloc_read_gpt_header(): Allocates GPT header, reads into it from disk
- * @bdev
+ * @state
  * @lba is the Logical Block Address of the partition table
  * 
  * Description: returns GPT header on success, NULL on error.   Allocates
- * and fills a GPT header starting at @ from @bdev.
+ * and fills a GPT header starting at @ from @state->bdev.
  * Note: remember to free gpt when finished with it.
  */
-static gpt_header *
-alloc_read_gpt_header(struct block_device *bdev, u64 lba)
+static gpt_header *alloc_read_gpt_header(struct parsed_partitions *state,
+					 u64 lba)
 {
 	gpt_header *gpt;
-	unsigned ssz = bdev_logical_block_size(bdev);
-
-	if (!bdev)
-		return NULL;
+	unsigned ssz = bdev_logical_block_size(state->bdev);
 
 	gpt = kzalloc(ssz, GFP_KERNEL);
 	if (!gpt)
 		return NULL;
 
-	if (read_lba(bdev, lba, (u8 *) gpt, ssz) < ssz) {
+	if (read_lba(state, lba, (u8 *) gpt, ssz) < ssz) {
 		kfree(gpt);
                 gpt=NULL;
 		return NULL;
@@ -283,7 +281,7 @@ alloc_read_gpt_header(struct block_device *bdev, u64 lba)
 
 /**
  * is_gpt_valid() - tests one GPT header and PTEs for validity
- * @bdev
+ * @state
  * @lba is the logical block address of the GPT header to test
  * @gpt is a GPT header ptr, filled on return.
  * @ptes is a PTEs ptr, filled on return.
@@ -291,16 +289,15 @@ alloc_read_gpt_header(struct block_device *bdev, u64 lba)
  * Description: returns 1 if valid,  0 on error.
  * If valid, returns pointers to newly allocated GPT header and PTEs.
  */
-static int
-is_gpt_valid(struct block_device *bdev, u64 lba,
-	     gpt_header **gpt, gpt_entry **ptes)
+static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
+			gpt_header **gpt, gpt_entry **ptes)
 {
 	u32 crc, origcrc;
 	u64 lastlba;
 
-	if (!bdev || !gpt || !ptes)
+	if (!ptes)
 		return 0;
-	if (!(*gpt = alloc_read_gpt_header(bdev, lba)))
+	if (!(*gpt = alloc_read_gpt_header(state, lba)))
 		return 0;
 
 	/* Check the GUID Partition Table signature */
@@ -336,7 +333,7 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 	/* Check the first_usable_lba and last_usable_lba are
 	 * within the disk.
 	 */
-	lastlba = last_lba(bdev);
+	lastlba = last_lba(state->bdev);
 	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
 		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
@@ -350,7 +347,7 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 		goto fail;
 	}
 
-	if (!(*ptes = alloc_read_gpt_entries(bdev, *gpt)))
+	if (!(*ptes = alloc_read_gpt_entries(state, *gpt)))
 		goto fail;
 
 	/* Check the GUID Partition Entry Array CRC */
@@ -495,7 +492,7 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
 
 /**
  * find_valid_gpt() - Search disk for valid GPT headers and PTEs
- * @bdev
+ * @state
  * @gpt is a GPT header ptr, filled on return.
  * @ptes is a PTEs ptr, filled on return.
  * Description: Returns 1 if valid, 0 on error.
@@ -508,24 +505,25 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, u64 lastlba)
  * This protects against devices which misreport their size, and forces
  * the user to decide to use the Alternate GPT.
  */
-static int
-find_valid_gpt(struct block_device *bdev, gpt_header **gpt, gpt_entry **ptes)
+static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
+			  gpt_entry **ptes)
 {
 	int good_pgpt = 0, good_agpt = 0, good_pmbr = 0;
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
 	legacy_mbr *legacymbr;
 	u64 lastlba;
-	if (!bdev || !gpt || !ptes)
+
+	if (!ptes)
 		return 0;
 
-	lastlba = last_lba(bdev);
+	lastlba = last_lba(state->bdev);
         if (!force_gpt) {
                 /* This will be added to the EFI Spec. per Intel after v1.02. */
                 legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
                 if (legacymbr) {
-                        read_lba(bdev, 0, (u8 *) legacymbr,
-                                 sizeof (*legacymbr));
+                        read_lba(state, 0, (u8 *) legacymbr,
+				 sizeof (*legacymbr));
                         good_pmbr = is_pmbr_valid(legacymbr);
                         kfree(legacymbr);
                 }
@@ -533,15 +531,14 @@ find_valid_gpt(struct block_device *bdev, gpt_header **gpt, gpt_entry **ptes)
                         goto fail;
         }
 
-	good_pgpt = is_gpt_valid(bdev, GPT_PRIMARY_PARTITION_TABLE_LBA,
+	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt)
-		good_agpt = is_gpt_valid(bdev,
+		good_agpt = is_gpt_valid(state,
 					 le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
         if (!good_agpt && force_gpt)
-                good_agpt = is_gpt_valid(bdev, lastlba,
-                                         &agpt, &aptes);
+                good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
 
         /* The obviously unsuccessful case */
         if (!good_pgpt && !good_agpt)
@@ -583,9 +580,8 @@ find_valid_gpt(struct block_device *bdev, gpt_header **gpt, gpt_entry **ptes)
 }
 
 /**
- * efi_partition(struct parsed_partitions *state, struct block_device *bdev)
+ * efi_partition(struct parsed_partitions *state)
  * @state
- * @bdev
  *
  * Description: called from check.c, if the disk contains GPT
  * partitions, sets up partition entries in the kernel.
@@ -602,15 +598,14 @@ find_valid_gpt(struct block_device *bdev, gpt_header **gpt, gpt_entry **ptes)
  *  1 if successful
  *
  */
-int
-efi_partition(struct parsed_partitions *state, struct block_device *bdev)
+int efi_partition(struct parsed_partitions *state)
 {
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
 	u32 i;
-	unsigned ssz = bdev_logical_block_size(bdev) / 512;
+	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
 
-	if (!find_valid_gpt(bdev, &gpt, &ptes) || !gpt || !ptes) {
+	if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
 		kfree(ptes);
 		return 0;
@@ -623,7 +618,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 		u64 size = le64_to_cpu(ptes[i].ending_lba) -
 			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
 
-		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
+		if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
 			continue;
 
 		put_partition(state, i+1, start * ssz, size * ssz);
diff --git a/fs/partitions/efi.h b/fs/partitions/efi.h
index 6998b58..b69ab72 100644
--- a/fs/partitions/efi.h
+++ b/fs/partitions/efi.h
@@ -110,7 +110,7 @@ typedef struct _legacy_mbr {
 } __attribute__ ((packed)) legacy_mbr;
 
 /* Functions */
-extern int efi_partition(struct parsed_partitions *state, struct block_device *bdev);
+extern int efi_partition(struct parsed_partitions *state);
 
 #endif
 
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index fc71aab..3e73de5 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -58,9 +58,9 @@ cchhb2blk (struct vtoc_cchhb *ptr, struct hd_geometry *geo) {
 
 /*
  */
-int
-ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
+int ibm_partition(struct parsed_partitions *state)
 {
+	struct block_device *bdev = state->bdev;
 	int blocksize, res;
 	loff_t i_size, offset, size, fmt_size;
 	dasd_information2_t *info;
@@ -100,7 +100,8 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 	/*
 	 * Get volume label, extract name and type.
 	 */
-	data = read_dev_sector(bdev, info->label_block*(blocksize/512), &sect);
+	data = read_part_sector(state, info->label_block*(blocksize/512),
+				&sect);
 	if (data == NULL)
 		goto out_readerr;
 
@@ -193,8 +194,8 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 			 */
 			blk = cchhb2blk(&label->vol.vtoc, geo) + 1;
 			counter = 0;
-			data = read_dev_sector(bdev, blk * (blocksize/512),
-					       &sect);
+			data = read_part_sector(state, blk * (blocksize/512),
+						&sect);
 			while (data != NULL) {
 				struct vtoc_format1_label f1;
 
@@ -208,9 +209,8 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 				    || f1.DS1FMTID == _ascebc['7']
 				    || f1.DS1FMTID == _ascebc['9']) {
 					blk++;
-					data = read_dev_sector(bdev, blk *
-							       (blocksize/512),
-								&sect);
+					data = read_part_sector(state,
+						blk * (blocksize/512), &sect);
 					continue;
 				}
 
@@ -230,9 +230,8 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 					      size * (blocksize >> 9));
 				counter++;
 				blk++;
-				data = read_dev_sector(bdev,
-						       blk * (blocksize/512),
-						       &sect);
+				data = read_part_sector(state,
+						blk * (blocksize/512), &sect);
 			}
 
 			if (!data)
diff --git a/fs/partitions/ibm.h b/fs/partitions/ibm.h
index 31f85a6..08fb080 100644
--- a/fs/partitions/ibm.h
+++ b/fs/partitions/ibm.h
@@ -1 +1 @@
-int ibm_partition(struct parsed_partitions *, struct block_device *);
+int ibm_partition(struct parsed_partitions *);
diff --git a/fs/partitions/karma.c b/fs/partitions/karma.c
index 176d89b..1cc928b 100644
--- a/fs/partitions/karma.c
+++ b/fs/partitions/karma.c
@@ -9,7 +9,7 @@
 #include "check.h"
 #include "karma.h"
 
-int karma_partition(struct parsed_partitions *state, struct block_device *bdev)
+int karma_partition(struct parsed_partitions *state)
 {
 	int i;
 	int slot = 1;
@@ -29,7 +29,7 @@ int karma_partition(struct parsed_partitions *state, struct block_device *bdev)
 	} __attribute__((packed)) *label;
 	struct d_partition *p;
 
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
 
diff --git a/fs/partitions/karma.h b/fs/partitions/karma.h
index ecf7d3f..c764b2e 100644
--- a/fs/partitions/karma.h
+++ b/fs/partitions/karma.h
@@ -4,5 +4,5 @@
 
 #define KARMA_LABEL_MAGIC		0xAB56
 
-int karma_partition(struct parsed_partitions *state, struct block_device *bdev);
+int karma_partition(struct parsed_partitions *state);
 
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 8652fb9..3ceca05 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -309,7 +309,7 @@ static bool ldm_compare_tocblocks (const struct tocblock *toc1,
 
 /**
  * ldm_validate_privheads - Compare the primary privhead with its backups
- * @bdev:  Device holding the LDM Database
+ * @state: Partition check state including device holding the LDM Database
  * @ph1:   Memory struct to fill with ph contents
  *
  * Read and compare all three privheads from disk.
@@ -321,8 +321,8 @@ static bool ldm_compare_tocblocks (const struct tocblock *toc1,
  * Return:  'true'   Success
  *          'false'  Error
  */
-static bool ldm_validate_privheads (struct block_device *bdev,
-				    struct privhead *ph1)
+static bool ldm_validate_privheads(struct parsed_partitions *state,
+				   struct privhead *ph1)
 {
 	static const int off[3] = { OFF_PRIV1, OFF_PRIV2, OFF_PRIV3 };
 	struct privhead *ph[3] = { ph1 };
@@ -332,7 +332,7 @@ static bool ldm_validate_privheads (struct block_device *bdev,
 	long num_sects;
 	int i;
 
-	BUG_ON (!bdev || !ph1);
+	BUG_ON (!state || !ph1);
 
 	ph[1] = kmalloc (sizeof (*ph[1]), GFP_KERNEL);
 	ph[2] = kmalloc (sizeof (*ph[2]), GFP_KERNEL);
@@ -346,8 +346,8 @@ static bool ldm_validate_privheads (struct block_device *bdev,
 
 	/* Read and parse privheads */
 	for (i = 0; i < 3; i++) {
-		data = read_dev_sector (bdev,
-			ph[0]->config_start + off[i], &sect);
+		data = read_part_sector(state, ph[0]->config_start + off[i],
+					&sect);
 		if (!data) {
 			ldm_crit ("Disk read failed.");
 			goto out;
@@ -363,7 +363,7 @@ static bool ldm_validate_privheads (struct block_device *bdev,
 		}
 	}
 
-	num_sects = bdev->bd_inode->i_size >> 9;
+	num_sects = state->bdev->bd_inode->i_size >> 9;
 
 	if ((ph[0]->config_start > num_sects) ||
 	   ((ph[0]->config_start + ph[0]->config_size) > num_sects)) {
@@ -397,20 +397,20 @@ out:
 
 /**
  * ldm_validate_tocblocks - Validate the table of contents and its backups
- * @bdev:  Device holding the LDM Database
- * @base:  Offset, into @bdev, of the database
+ * @state: Partition check state including device holding the LDM Database
+ * @base:  Offset, into @state->bdev, of the database
  * @ldb:   Cache of the database structures
  *
  * Find and compare the four tables of contents of the LDM Database stored on
- * @bdev and return the parsed information into @toc1.
+ * @state->bdev and return the parsed information into @toc1.
  *
  * The offsets and sizes of the configs are range-checked against a privhead.
  *
  * Return:  'true'   @toc1 contains validated TOCBLOCK info
  *          'false'  @toc1 contents are undefined
  */
-static bool ldm_validate_tocblocks(struct block_device *bdev,
-	unsigned long base, struct ldmdb *ldb)
+static bool ldm_validate_tocblocks(struct parsed_partitions *state,
+				   unsigned long base, struct ldmdb *ldb)
 {
 	static const int off[4] = { OFF_TOCB1, OFF_TOCB2, OFF_TOCB3, OFF_TOCB4};
 	struct tocblock *tb[4];
@@ -420,7 +420,7 @@ static bool ldm_validate_tocblocks(struct block_device *bdev,
 	int i, nr_tbs;
 	bool result = false;
 
-	BUG_ON(!bdev || !ldb);
+	BUG_ON(!state || !ldb);
 	ph = &ldb->ph;
 	tb[0] = &ldb->toc;
 	tb[1] = kmalloc(sizeof(*tb[1]) * 3, GFP_KERNEL);
@@ -437,7 +437,7 @@ static bool ldm_validate_tocblocks(struct block_device *bdev,
 	 * skip any that fail as long as we get at least one valid TOCBLOCK.
 	 */
 	for (nr_tbs = i = 0; i < 4; i++) {
-		data = read_dev_sector(bdev, base + off[i], &sect);
+		data = read_part_sector(state, base + off[i], &sect);
 		if (!data) {
 			ldm_error("Disk read failed for TOCBLOCK %d.", i);
 			continue;
@@ -473,7 +473,7 @@ err:
 
 /**
  * ldm_validate_vmdb - Read the VMDB and validate it
- * @bdev:  Device holding the LDM Database
+ * @state: Partition check state including device holding the LDM Database
  * @base:  Offset, into @bdev, of the database
  * @ldb:   Cache of the database structures
  *
@@ -483,8 +483,8 @@ err:
  * Return:  'true'   @ldb contains validated VBDB info
  *          'false'  @ldb contents are undefined
  */
-static bool ldm_validate_vmdb (struct block_device *bdev, unsigned long base,
-			       struct ldmdb *ldb)
+static bool ldm_validate_vmdb(struct parsed_partitions *state,
+			      unsigned long base, struct ldmdb *ldb)
 {
 	Sector sect;
 	u8 *data;
@@ -492,12 +492,12 @@ static bool ldm_validate_vmdb (struct block_device *bdev, unsigned long base,
 	struct vmdb *vm;
 	struct tocblock *toc;
 
-	BUG_ON (!bdev || !ldb);
+	BUG_ON (!state || !ldb);
 
 	vm  = &ldb->vm;
 	toc = &ldb->toc;
 
-	data = read_dev_sector (bdev, base + OFF_VMDB, &sect);
+	data = read_part_sector(state, base + OFF_VMDB, &sect);
 	if (!data) {
 		ldm_crit ("Disk read failed.");
 		return false;
@@ -534,21 +534,21 @@ out:
 
 /**
  * ldm_validate_partition_table - Determine whether bdev might be a dynamic disk
- * @bdev:  Device holding the LDM Database
+ * @state: Partition check state including device holding the LDM Database
  *
  * This function provides a weak test to decide whether the device is a dynamic
  * disk or not.  It looks for an MS-DOS-style partition table containing at
  * least one partition of type 0x42 (formerly SFS, now used by Windows for
  * dynamic disks).
  *
- * N.B.  The only possible error can come from the read_dev_sector and that is
+ * N.B.  The only possible error can come from the read_part_sector and that is
  *       only likely to happen if the underlying device is strange.  If that IS
  *       the case we should return zero to let someone else try.
  *
- * Return:  'true'   @bdev is a dynamic disk
- *          'false'  @bdev is not a dynamic disk, or an error occurred
+ * Return:  'true'   @state->bdev is a dynamic disk
+ *          'false'  @state->bdev is not a dynamic disk, or an error occurred
  */
-static bool ldm_validate_partition_table (struct block_device *bdev)
+static bool ldm_validate_partition_table(struct parsed_partitions *state)
 {
 	Sector sect;
 	u8 *data;
@@ -556,9 +556,9 @@ static bool ldm_validate_partition_table (struct block_device *bdev)
 	int i;
 	bool result = false;
 
-	BUG_ON (!bdev);
+	BUG_ON(!state);
 
-	data = read_dev_sector (bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data) {
 		ldm_crit ("Disk read failed.");
 		return false;
@@ -1391,8 +1391,8 @@ static bool ldm_frag_commit (struct list_head *frags, struct ldmdb *ldb)
 
 /**
  * ldm_get_vblks - Read the on-disk database of VBLKs into memory
- * @bdev:  Device holding the LDM Database
- * @base:  Offset, into @bdev, of the database
+ * @state: Partition check state including device holding the LDM Database
+ * @base:  Offset, into @state->bdev, of the database
  * @ldb:   Cache of the database structures
  *
  * To use the information from the VBLKs, they need to be read from the disk,
@@ -1401,8 +1401,8 @@ static bool ldm_frag_commit (struct list_head *frags, struct ldmdb *ldb)
  * Return:  'true'   All the VBLKs were read successfully
  *          'false'  An error occurred
  */
-static bool ldm_get_vblks (struct block_device *bdev, unsigned long base,
-			   struct ldmdb *ldb)
+static bool ldm_get_vblks(struct parsed_partitions *state, unsigned long base,
+			  struct ldmdb *ldb)
 {
 	int size, perbuf, skip, finish, s, v, recs;
 	u8 *data = NULL;
@@ -1410,7 +1410,7 @@ static bool ldm_get_vblks (struct block_device *bdev, unsigned long base,
 	bool result = false;
 	LIST_HEAD (frags);
 
-	BUG_ON (!bdev || !ldb);
+	BUG_ON(!state || !ldb);
 
 	size   = ldb->vm.vblk_size;
 	perbuf = 512 / size;
@@ -1418,7 +1418,7 @@ static bool ldm_get_vblks (struct block_device *bdev, unsigned long base,
 	finish = (size * ldb->vm.last_vblk_seq) >> 9;
 
 	for (s = skip; s < finish; s++) {		/* For each sector */
-		data = read_dev_sector (bdev, base + OFF_VMDB + s, &sect);
+		data = read_part_sector(state, base + OFF_VMDB + s, &sect);
 		if (!data) {
 			ldm_crit ("Disk read failed.");
 			goto out;
@@ -1474,8 +1474,7 @@ static void ldm_free_vblks (struct list_head *lh)
 
 /**
  * ldm_partition - Find out whether a device is a dynamic disk and handle it
- * @pp:    List of the partitions parsed so far
- * @bdev:  Device holding the LDM Database
+ * @state: Partition check state including device holding the LDM Database
  *
  * This determines whether the device @bdev is a dynamic disk and if so creates
  * the partitions necessary in the gendisk structure pointed to by @hd.
@@ -1485,21 +1484,21 @@ static void ldm_free_vblks (struct list_head *lh)
  * example, if the device is hda, we would have: hda1: LDM database, hda2, hda3,
  * and so on: the actual data containing partitions.
  *
- * Return:  1 Success, @bdev is a dynamic disk and we handled it
- *          0 Success, @bdev is not a dynamic disk
+ * Return:  1 Success, @state->bdev is a dynamic disk and we handled it
+ *          0 Success, @state->bdev is not a dynamic disk
  *         -1 An error occurred before enough information had been read
- *            Or @bdev is a dynamic disk, but it may be corrupted
+ *            Or @state->bdev is a dynamic disk, but it may be corrupted
  */
-int ldm_partition (struct parsed_partitions *pp, struct block_device *bdev)
+int ldm_partition(struct parsed_partitions *state)
 {
 	struct ldmdb  *ldb;
 	unsigned long base;
 	int result = -1;
 
-	BUG_ON (!pp || !bdev);
+	BUG_ON(!state);
 
 	/* Look for signs of a Dynamic Disk */
-	if (!ldm_validate_partition_table (bdev))
+	if (!ldm_validate_partition_table(state))
 		return 0;
 
 	ldb = kmalloc (sizeof (*ldb), GFP_KERNEL);
@@ -1509,15 +1508,15 @@ int ldm_partition (struct parsed_partitions *pp, struct block_device *bdev)
 	}
 
 	/* Parse and check privheads. */
-	if (!ldm_validate_privheads (bdev, &ldb->ph))
+	if (!ldm_validate_privheads(state, &ldb->ph))
 		goto out;		/* Already logged */
 
 	/* All further references are relative to base (database start). */
 	base = ldb->ph.config_start;
 
 	/* Parse and check tocs and vmdb. */
-	if (!ldm_validate_tocblocks (bdev, base, ldb) ||
-	    !ldm_validate_vmdb      (bdev, base, ldb))
+	if (!ldm_validate_tocblocks(state, base, ldb) ||
+	    !ldm_validate_vmdb(state, base, ldb))
 	    	goto out;		/* Already logged */
 
 	/* Initialize vblk lists in ldmdb struct */
@@ -1527,13 +1526,13 @@ int ldm_partition (struct parsed_partitions *pp, struct block_device *bdev)
 	INIT_LIST_HEAD (&ldb->v_comp);
 	INIT_LIST_HEAD (&ldb->v_part);
 
-	if (!ldm_get_vblks (bdev, base, ldb)) {
+	if (!ldm_get_vblks(state, base, ldb)) {
 		ldm_crit ("Failed to read the VBLKs from the database.");
 		goto cleanup;
 	}
 
 	/* Finally, create the data partition devices. */
-	if (ldm_create_data_partitions (pp, ldb)) {
+	if (ldm_create_data_partitions(state, ldb)) {
 		ldm_debug ("Parsed LDM database successfully.");
 		result = 1;
 	}
diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
index 30e08e8..d1fb50b 100644
--- a/fs/partitions/ldm.h
+++ b/fs/partitions/ldm.h
@@ -209,7 +209,7 @@ struct ldmdb {				/* Cache of the database */
 	struct list_head v_part;
 };
 
-int ldm_partition (struct parsed_partitions *state, struct block_device *bdev);
+int ldm_partition(struct parsed_partitions *state);
 
 #endif /* _FS_PT_LDM_H_ */
 
diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..13e27b0 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -27,7 +27,7 @@ static inline void mac_fix_string(char *stg, int len)
 		stg[i] = 0;
 }
 
-int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
+int mac_partition(struct parsed_partitions *state)
 {
 	int slot = 1;
 	Sector sect;
@@ -42,7 +42,7 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 	struct mac_driver_desc *md;
 
 	/* Get 0th block and look at the first partition map entry. */
-	md = (struct mac_driver_desc *) read_dev_sector(bdev, 0, &sect);
+	md = read_part_sector(state, 0, &sect);
 	if (!md)
 		return -1;
 	if (be16_to_cpu(md->signature) != MAC_DRIVER_MAGIC) {
@@ -51,7 +51,7 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 	}
 	secsize = be16_to_cpu(md->block_size);
 	put_dev_sector(sect);
-	data = read_dev_sector(bdev, secsize/512, &sect);
+	data = read_part_sector(state, secsize/512, &sect);
 	if (!data)
 		return -1;
 	part = (struct mac_partition *) (data + secsize%512);
@@ -64,7 +64,7 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 	for (blk = 1; blk <= blocks_in_map; ++blk) {
 		int pos = blk * secsize;
 		put_dev_sector(sect);
-		data = read_dev_sector(bdev, pos/512, &sect);
+		data = read_part_sector(state, pos/512, &sect);
 		if (!data)
 			return -1;
 		part = (struct mac_partition *) (data + pos%512);
@@ -123,7 +123,8 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 	}
 #ifdef CONFIG_PPC_PMAC
 	if (found_root_goodness)
-		note_bootable_part(bdev->bd_dev, found_root, found_root_goodness);
+		note_bootable_part(state->bdev->bd_dev, found_root,
+				   found_root_goodness);
 #endif
 
 	put_dev_sector(sect);
diff --git a/fs/partitions/mac.h b/fs/partitions/mac.h
index bbf26e1..3c7d984 100644
--- a/fs/partitions/mac.h
+++ b/fs/partitions/mac.h
@@ -41,4 +41,4 @@ struct mac_driver_desc {
     /* ... more stuff */
 };
 
-int mac_partition(struct parsed_partitions *state, struct block_device *bdev);
+int mac_partition(struct parsed_partitions *state);
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 90be97f..645a68d 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -64,7 +64,7 @@ msdos_magic_present(unsigned char *p)
 #define AIX_LABEL_MAGIC2	0xC2
 #define AIX_LABEL_MAGIC3	0xD4
 #define AIX_LABEL_MAGIC4	0xC1
-static int aix_magic_present(unsigned char *p, struct block_device *bdev)
+static int aix_magic_present(struct parsed_partitions *state, unsigned char *p)
 {
 	struct partition *pt = (struct partition *) (p + 0x1be);
 	Sector sect;
@@ -85,7 +85,7 @@ static int aix_magic_present(unsigned char *p, struct block_device *bdev)
 			is_extended_partition(pt))
 			return 0;
 	}
-	d = read_dev_sector(bdev, 7, &sect);
+	d = read_part_sector(state, 7, &sect);
 	if (d) {
 		if (d[0] == '_' && d[1] == 'L' && d[2] == 'V' && d[3] == 'M')
 			ret = 1;
@@ -105,15 +105,14 @@ static int aix_magic_present(unsigned char *p, struct block_device *bdev)
  * only for the actual data partitions.
  */
 
-static void
-parse_extended(struct parsed_partitions *state, struct block_device *bdev,
-			sector_t first_sector, sector_t first_size)
+static void parse_extended(struct parsed_partitions *state,
+			   sector_t first_sector, sector_t first_size)
 {
 	struct partition *p;
 	Sector sect;
 	unsigned char *data;
 	sector_t this_sector, this_size;
-	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
+	sector_t sector_size = bdev_logical_block_size(state->bdev) / 512;
 	int loopct = 0;		/* number of links followed
 				   without finding a data partition */
 	int i;
@@ -126,7 +125,7 @@ parse_extended(struct parsed_partitions *state, struct block_device *bdev,
 			return;
 		if (state->next == state->limit)
 			return;
-		data = read_dev_sector(bdev, this_sector, &sect);
+		data = read_part_sector(state, this_sector, &sect);
 		if (!data)
 			return;
 
@@ -198,9 +197,8 @@ done:
 /* james@bpgc.com: Solaris has a nasty indicator: 0x82 which also
    indicates linux swap.  Be careful before believing this is Solaris. */
 
-static void
-parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
-			sector_t offset, sector_t size, int origin)
+static void parse_solaris_x86(struct parsed_partitions *state,
+			      sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 	Sector sect;
@@ -208,7 +206,7 @@ parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
 	int i;
 	short max_nparts;
 
-	v = (struct solaris_x86_vtoc *)read_dev_sector(bdev, offset+1, &sect);
+	v = read_part_sector(state, offset + 1, &sect);
 	if (!v)
 		return;
 	if (le32_to_cpu(v->v_sanity) != SOLARIS_X86_VTOC_SANE) {
@@ -245,16 +243,15 @@ parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
  * Create devices for BSD partitions listed in a disklabel, under a
  * dos-like partition. See parse_extended() for more information.
  */
-static void
-parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin, char *flavour,
-		int max_partitions)
+static void parse_bsd(struct parsed_partitions *state,
+		      sector_t offset, sector_t size, int origin, char *flavour,
+		      int max_partitions)
 {
 	Sector sect;
 	struct bsd_disklabel *l;
 	struct bsd_partition *p;
 
-	l = (struct bsd_disklabel *)read_dev_sector(bdev, offset+1, &sect);
+	l = read_part_sector(state, offset + 1, &sect);
 	if (!l)
 		return;
 	if (le32_to_cpu(l->d_magic) != BSD_DISKMAGIC) {
@@ -291,33 +288,28 @@ parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
 }
 #endif
 
-static void
-parse_freebsd(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin)
+static void parse_freebsd(struct parsed_partitions *state,
+			  sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
-	parse_bsd(state, bdev, offset, size, origin,
-			"bsd", BSD_MAXPARTITIONS);
+	parse_bsd(state, offset, size, origin, "bsd", BSD_MAXPARTITIONS);
 #endif
 }
 
-static void
-parse_netbsd(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin)
+static void parse_netbsd(struct parsed_partitions *state,
+			 sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
-	parse_bsd(state, bdev, offset, size, origin,
-			"netbsd", BSD_MAXPARTITIONS);
+	parse_bsd(state, offset, size, origin, "netbsd", BSD_MAXPARTITIONS);
 #endif
 }
 
-static void
-parse_openbsd(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin)
+static void parse_openbsd(struct parsed_partitions *state,
+			  sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
-	parse_bsd(state, bdev, offset, size, origin,
-			"openbsd", OPENBSD_MAXPARTITIONS);
+	parse_bsd(state, offset, size, origin, "openbsd",
+		  OPENBSD_MAXPARTITIONS);
 #endif
 }
 
@@ -325,16 +317,15 @@ parse_openbsd(struct parsed_partitions *state, struct block_device *bdev,
  * Create devices for Unixware partitions listed in a disklabel, under a
  * dos-like partition. See parse_extended() for more information.
  */
-static void
-parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin)
+static void parse_unixware(struct parsed_partitions *state,
+			   sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_UNIXWARE_DISKLABEL
 	Sector sect;
 	struct unixware_disklabel *l;
 	struct unixware_slice *p;
 
-	l = (struct unixware_disklabel *)read_dev_sector(bdev, offset+29, &sect);
+	l = read_part_sector(state, offset + 29, &sect);
 	if (!l)
 		return;
 	if (le32_to_cpu(l->d_magic) != UNIXWARE_DISKMAGIC ||
@@ -365,9 +356,8 @@ parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
  * Anand Krishnamurthy <anandk@wiproge.med.ge.com>
  * Rajeev V. Pillai    <rajeevvp@yahoo.com>
  */
-static void
-parse_minix(struct parsed_partitions *state, struct block_device *bdev,
-		sector_t offset, sector_t size, int origin)
+static void parse_minix(struct parsed_partitions *state,
+			sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_MINIX_SUBPARTITION
 	Sector sect;
@@ -375,7 +365,7 @@ parse_minix(struct parsed_partitions *state, struct block_device *bdev,
 	struct partition *p;
 	int i;
 
-	data = read_dev_sector(bdev, offset, &sect);
+	data = read_part_sector(state, offset, &sect);
 	if (!data)
 		return;
 
@@ -404,8 +394,7 @@ parse_minix(struct parsed_partitions *state, struct block_device *bdev,
 
 static struct {
 	unsigned char id;
-	void (*parse)(struct parsed_partitions *, struct block_device *,
-			sector_t, sector_t, int);
+	void (*parse)(struct parsed_partitions *, sector_t, sector_t, int);
 } subtypes[] = {
 	{FREEBSD_PARTITION, parse_freebsd},
 	{NETBSD_PARTITION, parse_netbsd},
@@ -417,16 +406,16 @@ static struct {
 	{0, NULL},
 };
  
-int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
+int msdos_partition(struct parsed_partitions *state)
 {
-	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
+	sector_t sector_size = bdev_logical_block_size(state->bdev) / 512;
 	Sector sect;
 	unsigned char *data;
 	struct partition *p;
 	struct fat_boot_sector *fb;
 	int slot;
 
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
 	if (!msdos_magic_present(data + 510)) {
@@ -434,7 +423,7 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 		return 0;
 	}
 
-	if (aix_magic_present(data, bdev)) {
+	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
 		printk( " [AIX]");
 		return 0;
@@ -503,7 +492,7 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 			put_partition(state, slot, start, n);
 
 			printk(" <");
-			parse_extended(state, bdev, start, size);
+			parse_extended(state, start, size);
 			printk(" >");
 			continue;
 		}
@@ -532,8 +521,8 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 
 		if (!subtypes[n].parse)
 			continue;
-		subtypes[n].parse(state, bdev, start_sect(p)*sector_size,
-						nr_sects(p)*sector_size, slot);
+		subtypes[n].parse(state, start_sect(p) * sector_size,
+				  nr_sects(p) * sector_size, slot);
 	}
 	put_dev_sector(sect);
 	return 1;
diff --git a/fs/partitions/msdos.h b/fs/partitions/msdos.h
index 01e5e0b..38c781c 100644
--- a/fs/partitions/msdos.h
+++ b/fs/partitions/msdos.h
@@ -4,5 +4,5 @@
 
 #define MSDOS_LABEL_MAGIC		0xAA55
 
-int msdos_partition(struct parsed_partitions *state, struct block_device *bdev);
+int msdos_partition(struct parsed_partitions *state);
 
diff --git a/fs/partitions/osf.c b/fs/partitions/osf.c
index c05c17b..fc22b85 100644
--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
@@ -10,7 +10,7 @@
 #include "check.h"
 #include "osf.h"
 
-int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
+int osf_partition(struct parsed_partitions *state)
 {
 	int i;
 	int slot = 1;
@@ -49,7 +49,7 @@ int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 	} * label;
 	struct d_partition * partition;
 
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
 
diff --git a/fs/partitions/osf.h b/fs/partitions/osf.h
index 427b8ea..20ed231 100644
--- a/fs/partitions/osf.h
+++ b/fs/partitions/osf.h
@@ -4,4 +4,4 @@
 
 #define DISKLABELMAGIC (0x82564557UL)
 
-int osf_partition(struct parsed_partitions *state, struct block_device *bdev);
+int osf_partition(struct parsed_partitions *state);
diff --git a/fs/partitions/sgi.c b/fs/partitions/sgi.c
index ed5ac83..43b1df9 100644
--- a/fs/partitions/sgi.c
+++ b/fs/partitions/sgi.c
@@ -27,7 +27,7 @@ struct sgi_disklabel {
 	__be32 _unused1;			/* Padding */
 };
 
-int sgi_partition(struct parsed_partitions *state, struct block_device *bdev)
+int sgi_partition(struct parsed_partitions *state)
 {
 	int i, csum;
 	__be32 magic;
@@ -39,7 +39,7 @@ int sgi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	struct sgi_partition *p;
 	char b[BDEVNAME_SIZE];
 
-	label = (struct sgi_disklabel *) read_dev_sector(bdev, 0, &sect);
+	label = read_part_sector(state, 0, &sect);
 	if (!label)
 		return -1;
 	p = &label->partitions[0];
@@ -57,7 +57,7 @@ int sgi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	}
 	if(csum) {
 		printk(KERN_WARNING "Dev %s SGI disklabel: csum bad, label corrupted\n",
-		       bdevname(bdev, b));
+		       bdevname(state->bdev, b));
 		put_dev_sector(sect);
 		return 0;
 	}
diff --git a/fs/partitions/sgi.h b/fs/partitions/sgi.h
index 5d5595c..b9553eb 100644
--- a/fs/partitions/sgi.h
+++ b/fs/partitions/sgi.h
@@ -2,7 +2,7 @@
  *  fs/partitions/sgi.h
  */
 
-extern int sgi_partition(struct parsed_partitions *state, struct block_device *bdev);
+extern int sgi_partition(struct parsed_partitions *state);
 
 #define SGI_LABEL_MAGIC 0x0be5a941
 
diff --git a/fs/partitions/sun.c b/fs/partitions/sun.c
index c95e6a6..a32660e 100644
--- a/fs/partitions/sun.c
+++ b/fs/partitions/sun.c
@@ -10,7 +10,7 @@
 #include "check.h"
 #include "sun.h"
 
-int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
+int sun_partition(struct parsed_partitions *state)
 {
 	int i;
 	__be16 csum;
@@ -61,7 +61,7 @@ int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
 	int use_vtoc;
 	int nparts;
 
-	label = (struct sun_disklabel *)read_dev_sector(bdev, 0, &sect);
+	label = read_part_sector(state, 0, &sect);
 	if (!label)
 		return -1;
 
@@ -78,7 +78,7 @@ int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
 		csum ^= *ush--;
 	if (csum) {
 		printk("Dev %s Sun disklabel: Csum bad, label corrupted\n",
-		       bdevname(bdev, b));
+		       bdevname(state->bdev, b));
 		put_dev_sector(sect);
 		return 0;
 	}
diff --git a/fs/partitions/sun.h b/fs/partitions/sun.h
index 7f864d1..2424baa 100644
--- a/fs/partitions/sun.h
+++ b/fs/partitions/sun.h
@@ -5,4 +5,4 @@
 #define SUN_LABEL_MAGIC          0xDABE
 #define SUN_VTOC_SANITY          0x600DDEEE
 
-int sun_partition(struct parsed_partitions *state, struct block_device *bdev);
+int sun_partition(struct parsed_partitions *state);
diff --git a/fs/partitions/sysv68.c b/fs/partitions/sysv68.c
index 4eba27b..9030c86 100644
--- a/fs/partitions/sysv68.c
+++ b/fs/partitions/sysv68.c
@@ -46,7 +46,7 @@ struct slice {
 };
 
 
-int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
+int sysv68_partition(struct parsed_partitions *state)
 {
 	int i, slices;
 	int slot = 1;
@@ -55,7 +55,7 @@ int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
 	struct dkblk0 *b;
 	struct slice *slice;
 
-	data = read_dev_sector(bdev, 0, &sect);
+	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
 
@@ -68,7 +68,7 @@ int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
 	i = be32_to_cpu(b->dk_ios.ios_slcblk);
 	put_dev_sector(sect);
 
-	data = read_dev_sector(bdev, i, &sect);
+	data = read_part_sector(state, i, &sect);
 	if (!data)
 		return -1;
 
diff --git a/fs/partitions/sysv68.h b/fs/partitions/sysv68.h
index fa733f6..bf2f5ff 100644
--- a/fs/partitions/sysv68.h
+++ b/fs/partitions/sysv68.h
@@ -1 +1 @@
-extern int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev);
+extern int sysv68_partition(struct parsed_partitions *state);
diff --git a/fs/partitions/ultrix.c b/fs/partitions/ultrix.c
index ec852c1..db9eef2 100644
--- a/fs/partitions/ultrix.c
+++ b/fs/partitions/ultrix.c
@@ -9,7 +9,7 @@
 #include "check.h"
 #include "ultrix.h"
 
-int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev)
+int ultrix_partition(struct parsed_partitions *state)
 {
 	int i;
 	Sector sect;
@@ -26,7 +26,7 @@ int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev)
 #define PT_MAGIC	0x032957	/* Partition magic number */
 #define PT_VALID	1		/* Indicates if struct is valid */
 
-	data = read_dev_sector(bdev, (16384 - sizeof(*label))/512, &sect);
+	data = read_part_sector(state, (16384 - sizeof(*label))/512, &sect);
 	if (!data)
 		return -1;
 	
diff --git a/fs/partitions/ultrix.h b/fs/partitions/ultrix.h
index a74bf8e..a3cc00b 100644
--- a/fs/partitions/ultrix.h
+++ b/fs/partitions/ultrix.h
@@ -2,4 +2,4 @@
  *  fs/partitions/ultrix.h
  */
 
-int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev);
+int ultrix_partition(struct parsed_partitions *state);
-- 
1.6.4.2

