From: mchristi@redhat.com
Subject: [PATCH 10/32] f2fs: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:07 -0600
Message-ID: <1446674909-5371-11-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch prepares f2fs's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/f2fs/checkpoint.c        |  6 ++++--
 fs/f2fs/data.c              | 30 ++++++++++++++++++------------
 fs/f2fs/f2fs.h              |  5 +++--
 fs/f2fs/gc.c                | 11 +++++++----
 fs/f2fs/inline.c            |  3 ++-
 fs/f2fs/node.c              | 10 ++++++----
 fs/f2fs/segment.c           |  6 ++++--
 fs/f2fs/trace.c             |  8 +++++---
 include/trace/events/f2fs.h | 34 +++++++++++++++++++++-------------
 9 files changed, 70 insertions(+), 43 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c5a38e3..ebab316 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -54,7 +54,8 @@ struct page *get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC | REQ_META | REQ_PRIO,
 		.blk_addr = index,
 		.encrypted_page = NULL,
 	};
@@ -133,7 +134,8 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC | REQ_META | REQ_PRIO,
 		.encrypted_page = NULL,
 	};
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a82abe9..fb767e4f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -107,12 +107,12 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	if (!io->bio)
 		return;
 
-	if (is_read_io(fio->rw))
+	if (is_read_io(fio->op))
 		trace_f2fs_submit_read_bio(io->sbi->sb, fio, io->bio);
 	else
 		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
 
-	submit_bio(fio->rw, io->bio);
+	submit_bio(fio->op | fio->op_flags, io->bio);
 	io->bio = NULL;
 }
 
@@ -129,10 +129,12 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
 		io->fio.type = META_FLUSH;
+		io->fio.op = REQ_OP_WRITE;
 		if (test_opt(sbi, NOBARRIER))
-			io->fio.rw = WRITE_FLUSH | REQ_META | REQ_PRIO;
+			io->fio.op_flags = WRITE_FLUSH | REQ_META | REQ_PRIO;
 		else
-			io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
+			io->fio.op_flags = WRITE_FLUSH_FUA | REQ_META |
+								REQ_PRIO;
 	}
 	__submit_merged_bio(io);
 	up_write(&io->io_rwsem);
@@ -151,14 +153,14 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	f2fs_trace_ios(fio, 0);
 
 	/* Allocate a new bio */
-	bio = __bio_alloc(fio->sbi, fio->blk_addr, 1, is_read_io(fio->rw));
+	bio = __bio_alloc(fio->sbi, fio->blk_addr, 1, is_read_io(fio->op));
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
 		return -EFAULT;
 	}
 
-	submit_bio(fio->rw, bio);
+	submit_bio(fio->op | fio->op_flags, bio);
 	return 0;
 }
 
@@ -167,7 +169,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 	struct f2fs_sb_info *sbi = fio->sbi;
 	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
 	struct f2fs_bio_info *io;
-	bool is_read = is_read_io(fio->rw);
+	bool is_read = is_read_io(fio->op);
 	struct page *bio_page;
 
 	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
@@ -180,7 +182,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
 	if (io->bio && (io->last_block_in_bio != fio->blk_addr - 1 ||
-						io->fio.rw != fio->rw))
+						io->fio.op != fio->op))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
@@ -275,7 +277,8 @@ int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index)
 	return f2fs_reserve_block(dn, index);
 }
 
-struct page *get_read_data_page(struct inode *inode, pgoff_t index, int rw)
+struct page *get_read_data_page(struct inode *inode, pgoff_t index,
+				int op_flags)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct dnode_of_data dn;
@@ -285,7 +288,8 @@ struct page *get_read_data_page(struct inode *inode, pgoff_t index, int rw)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = rw,
+		.op = REQ_OP_READ,
+		.op_flags = op_flags,
 		.encrypted_page = NULL,
 	};
 
@@ -1088,7 +1092,8 @@ static int f2fs_write_data_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
+		.op = REQ_OP_WRITE,
+		.op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0,
 		.page = page,
 		.encrypted_page = NULL,
 	};
@@ -1449,7 +1454,8 @@ put_next:
 		struct f2fs_io_info fio = {
 			.sbi = sbi,
 			.type = DATA,
-			.rw = READ_SYNC,
+			.op = REQ_OP_READ,
+			.op_flags = READ_SYNC,
 			.blk_addr = dn.data_blkaddr,
 			.page = page,
 			.encrypted_page = NULL,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f1a90ff..c839abb 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -667,13 +667,14 @@ enum page_type {
 struct f2fs_io_info {
 	struct f2fs_sb_info *sbi;	/* f2fs_sb_info pointer */
 	enum page_type type;	/* contains DATA/NODE/META/META_FLUSH */
-	int rw;			/* contains R/RS/W/WS with REQ_META/REQ_PRIO */
+	int op;			/* contains REQ_OP_ */
+	int op_flags;		/* rq_flag_bits */
 	block_t blk_addr;	/* block address to be written */
 	struct page *page;	/* page to be written */
 	struct page *encrypted_page;	/* encrypted page */
 };
 
-#define is_read_io(rw)	(((rw) & 1) == READ)
+#define is_read_io(rw)	(rw == READ)
 struct f2fs_bio_info {
 	struct f2fs_sb_info *sbi;	/* f2fs superblock */
 	struct bio *bio;		/* bios to merge */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 782b8e7..64cb127 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -531,7 +531,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = READ_SYNC,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC,
 		.encrypted_page = NULL,
 	};
 	struct dnode_of_data dn;
@@ -590,7 +591,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	f2fs_wait_on_page_writeback(dn.node_page, NODE);
 	allocate_data_block(fio.sbi, NULL, fio.blk_addr,
 					&fio.blk_addr, &sum, CURSEG_COLD_DATA);
-	fio.rw = WRITE_SYNC;
+	fio.op = REQ_OP_WRITE;
+	fio.op_flags = WRITE_SYNC;
 	f2fs_submit_page_mbio(&fio);
 
 	dn.data_blkaddr = fio.blk_addr;
@@ -624,7 +626,8 @@ static void move_data_page(struct inode *inode, block_t bidx, int gc_type)
 		struct f2fs_io_info fio = {
 			.sbi = F2FS_I_SB(inode),
 			.type = DATA,
-			.rw = WRITE_SYNC,
+			.op = REQ_OP_WRITE,
+			.op_flags = WRITE_SYNC,
 			.page = page,
 			.encrypted_page = NULL,
 		};
@@ -705,7 +708,7 @@ next_step:
 
 			start_bidx = start_bidx_of_node(nofs, F2FS_I(inode));
 			data_page = get_read_data_page(inode,
-					start_bidx + ofs_in_node, READA);
+					start_bidx + ofs_in_node, REQ_RAHEAD);
 			if (IS_ERR(data_page)) {
 				iput(inode);
 				continue;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3d143be..65748d7 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -111,7 +111,8 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(dn->inode),
 		.type = DATA,
-		.rw = WRITE_SYNC | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_PRIO,
 		.page = page,
 		.encrypted_page = NULL,
 	};
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 27d1a74..a3561a1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1001,14 +1001,15 @@ fail:
  * 0: f2fs_put_page(page, 0)
  * LOCKED_PAGE or error: f2fs_put_page(page, 1)
  */
-static int read_node_page(struct page *page, int rw)
+static int read_node_page(struct page *page, int op_flags)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	struct node_info ni;
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = NODE,
-		.rw = rw,
+		.op = REQ_OP_READ,
+		.op_flags = op_flags,
 		.page = page,
 		.encrypted_page = NULL,
 	};
@@ -1046,7 +1047,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 	if (!apage)
 		return;
 
-	err = read_node_page(apage, READA);
+	err = read_node_page(apage, REQ_RAHEAD);
 	f2fs_put_page(apage, err ? 1 : 0);
 }
 
@@ -1305,7 +1306,8 @@ static int f2fs_write_node_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = NODE,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
+		.op = REQ_OP_WRITE,
+		.op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0,
 		.page = page,
 		.encrypted_page = NULL,
 	};
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7d2972b..14402c6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -228,7 +228,8 @@ int commit_inmem_pages(struct inode *inode, bool abort)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = WRITE_SYNC | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_PRIO,
 		.encrypted_page = NULL,
 	};
 	int err = 0;
@@ -1286,7 +1287,8 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = WRITE_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_META | REQ_PRIO,
 		.blk_addr = page->index,
 		.page = page,
 		.encrypted_page = NULL,
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 145fb65..5b7edca 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -25,11 +25,12 @@ static inline void __print_last_io(void)
 	if (!last_io.len)
 		return;
 
-	trace_printk("%3x:%3x %4x %-16s %2x %5x %12x %4x\n",
+	trace_printk("%3x:%3x %4x %-16s %2x %5x %5x %12x %4x\n",
 			last_io.major, last_io.minor,
 			last_io.pid, "----------------",
 			last_io.type,
-			last_io.fio.rw, last_io.fio.blk_addr,
+			last_io.fio.op, last_io.fio.op_flags,
+			last_io.fio.blk_addr,
 			last_io.len);
 	memset(&last_io, 0, sizeof(last_io));
 }
@@ -100,7 +101,8 @@ void f2fs_trace_ios(struct f2fs_io_info *fio, int flush)
 	if (last_io.major == major && last_io.minor == minor &&
 			last_io.pid == pid &&
 			last_io.type == __file_type(inode, pid) &&
-			last_io.fio.rw == fio->rw &&
+			last_io.fio.op == fio->op &&
+			last_io.fio.op_flags == fio->op_flags &&
 			last_io.fio.blk_addr + last_io.len == fio->blk_addr) {
 		last_io.len++;
 		return;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index a019465..0c7301b 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -55,17 +55,21 @@ TRACE_DEFINE_ENUM(CP_DISCARD);
 		{ IPU,		"IN-PLACE" },				\
 		{ OPU,		"OUT-OF-PLACE" })
 
-#define F2FS_BIO_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
+#define F2FS_BIO_FLAG_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
 #define F2FS_BIO_EXTRA_MASK(t)	(t & (REQ_META | REQ_PRIO))
 
-#define show_bio_type(type)	show_bio_base(type), show_bio_extra(type)
+#define show_bio_type(op, op_flags) show_bio_op(op), 			\
+			show_bio_op_flags(op_flags), show_bio_extra(op_flags)
 
-#define show_bio_base(type)						\
-	__print_symbolic(F2FS_BIO_MASK(type),				\
+#define show_bio_op(op)							\
+	__print_symbolic(op,						\
 		{ READ, 		"READ" },			\
+		{ WRITE, 		"WRITE" })
+
+#define show_bio_op_flags(flags)					\
+	__print_symbolic(F2FS_BIO_FLAG_MASK(flags),			\
 		{ READA, 		"READAHEAD" },			\
 		{ READ_SYNC, 		"READ_SYNC" },			\
-		{ WRITE, 		"WRITE" },			\
 		{ WRITE_SYNC, 		"WRITE_SYNC" },			\
 		{ WRITE_FLUSH,		"WRITE_FLUSH" },		\
 		{ WRITE_FUA, 		"WRITE_FUA" },			\
@@ -700,7 +704,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__field(ino_t, ino)
 		__field(pgoff_t, index)
 		__field(block_t, blkaddr)
-		__field(int, rw)
+		__field(int, op)
+		__field(int, op_flags)
 		__field(int, type)
 	),
 
@@ -709,16 +714,17 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__entry->ino		= page->mapping->host->i_ino;
 		__entry->index		= page->index;
 		__entry->blkaddr	= fio->blk_addr;
-		__entry->rw		= fio->rw;
+		__entry->op		= fio->op;
+		__entry->op_flags	= fio->op_flags;
 		__entry->type		= fio->type;
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
-		"blkaddr = 0x%llx, rw = %s%s, type = %s",
+		"blkaddr = 0x%llx, rw = %s%s%s, type = %s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
 		(unsigned long long)__entry->blkaddr,
-		show_bio_type(__entry->rw),
+		show_bio_type(__entry->op, __entry->op_flags),
 		show_block_type(__entry->type))
 );
 
@@ -749,7 +755,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(int,	rw)
+		__field(int,	op)
+		__field(int,	op_flags)
 		__field(int,	type)
 		__field(sector_t,	sector)
 		__field(unsigned int,	size)
@@ -757,15 +764,16 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->rw		= fio->rw;
+		__entry->op		= fio->op;
+		__entry->op_flags	= fio->op_flags;
 		__entry->type		= fio->type;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->size		= bio->bi_iter.bi_size;
 	),
 
-	TP_printk("dev = (%d,%d), %s%s, %s, sector = %lld, size = %u",
+	TP_printk("dev = (%d,%d), %s%s%s, %s, sector = %lld, size = %u",
 		show_dev(__entry),
-		show_bio_type(__entry->rw),
+		show_bio_type(__entry->op, __entry->op_flags),
 		show_block_type(__entry->type),
 		(unsigned long long)__entry->sector,
 		__entry->size)
-- 
1.8.3.1
