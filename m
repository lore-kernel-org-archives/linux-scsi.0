From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 5/9] osdfs: dir_inode and directory operations
Date: Thu, 30 Oct 2008 16:34:32 +0200
Message-ID: <1225377272-25348-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
List-Id: linux-scsi@vger.kernel.org

implementation of directory and inode operations.

* A directory is treated as a file, and essentially contains a list
  of <file name, inode #> pairs for files that are found in that
  directory. The object IDs correspond to the files' inode numbers
  and are allocated using a 64bit incrementing global counter.
* Each file's control block (AKA on-disk inode) is stored in its
  object's attributes. This applies to both regular files and other
  types (directories, device files, symlinks, etc.).

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/Kbuild  |    2 +-
 fs/osdfs/dir.c   |  629 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/osdfs/inode.c |  267 +++++++++++++++++++++++
 fs/osdfs/namei.c |  348 ++++++++++++++++++++++++++++++
 fs/osdfs/osdfs.h |   26 +++
 5 files changed, 1271 insertions(+), 1 deletions(-)
 create mode 100644 fs/osdfs/dir.c
 create mode 100644 fs/osdfs/namei.c

diff --git a/fs/osdfs/Kbuild b/fs/osdfs/Kbuild
index eddba6a..d6ac8d6 100644
--- a/fs/osdfs/Kbuild
+++ b/fs/osdfs/Kbuild
@@ -20,5 +20,5 @@ EXTRA_CFLAGS += -I$(OSD_INC)
 # EXTRA_CFLAGS += -DCONFIG_OSDFS_DEBUG
 endif
 
-osdfs-objs := osd.o inode.o file.o symlink.o
+osdfs-objs := osd.o inode.o file.o symlink.o namei.o dir.o
 obj-$(CONFIG_OSDFS_FS) += osdfs.o
diff --git a/fs/osdfs/dir.c b/fs/osdfs/dir.c
new file mode 100644
index 0000000..ba28fd6
--- /dev/null
+++ b/fs/osdfs/dir.c
@@ -0,0 +1,629 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of osdfs.
+ *
+ * osdfs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for osdfs is version 2.
+ *
+ * osdfs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with osdfs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/pagemap.h>
+#include <linux/smp_lock.h>
+#include "osdfs.h"
+
+static inline unsigned osdfs_chunk_size(struct inode *inode)
+{
+	return inode->i_sb->s_blocksize;
+}
+
+static inline void osdfs_put_page(struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+static inline unsigned long dir_pages(struct inode *inode)
+{
+	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
+}
+
+static unsigned osdfs_last_byte(struct inode *inode, unsigned long page_nr)
+{
+	unsigned last_byte = inode->i_size;
+
+	last_byte -= page_nr << PAGE_CACHE_SHIFT;
+	if (last_byte > PAGE_CACHE_SIZE)
+		last_byte = PAGE_CACHE_SIZE;
+	return last_byte;
+}
+
+static int osdfs_commit_chunk(struct page *page, unsigned from, unsigned to)
+{
+	struct inode *dir = page->mapping->host;
+	int err = 0;
+	dir->i_version++;
+	page->mapping->a_ops->commit_write(NULL, page, from, to);
+	if (IS_DIRSYNC(dir))
+		err = write_one_page(page, 1);
+	else
+		unlock_page(page);
+	return err;
+}
+
+static void osdfs_check_page(struct page *page)
+{
+	struct inode *dir = page->mapping->host;
+	unsigned chunk_size = osdfs_chunk_size(dir);
+	char *kaddr = page_address(page);
+	unsigned offs, rec_len;
+	unsigned limit = PAGE_CACHE_SIZE;
+	struct osdfs_dir_entry *p;
+	char *error;
+
+	/* if the page is the last one in the directory */
+	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
+		limit = dir->i_size & ~PAGE_CACHE_MASK;
+		if (limit & (chunk_size - 1))
+			goto Ebadsize;
+		if (!limit)
+			goto out;
+	}
+	for (offs = 0; offs <= limit - OSDFS_DIR_REC_LEN(1); offs += rec_len) {
+		p = (struct osdfs_dir_entry *)(kaddr + offs);
+		rec_len = p->rec_len;
+
+		if (rec_len < OSDFS_DIR_REC_LEN(1))
+			goto Eshort;
+		if (rec_len & 3)
+			goto Ealign;
+		if (rec_len < OSDFS_DIR_REC_LEN(p->name_len))
+			goto Enamelen;
+		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
+			goto Espan;
+	}
+	if (offs != limit)
+		goto Eend;
+out:
+	SetPageChecked(page);
+	return;
+
+Ebadsize:
+	printk(KERN_ERR "ERROR [osdfs_check_page]: "
+		"size of directory #%lu is not a multiple of chunk size",
+		dir->i_ino
+	);
+	goto fail;
+Eshort:
+	error = "rec_len is smaller than minimal";
+	goto bad_entry;
+Ealign:
+	error = "unaligned directory entry";
+	goto bad_entry;
+Enamelen:
+	error = "rec_len is too small for name_len";
+	goto bad_entry;
+Espan:
+	error = "directory entry across blocks";
+	goto bad_entry;
+bad_entry:
+	printk(KERN_ERR
+		"ERROR [osdfs_check_page]: bad entry in directory #%lu: %s - "
+		"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
+		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		(unsigned long) le32_to_cpu(p->inode),
+		rec_len, p->name_len);
+	goto fail;
+Eend:
+	p = (struct osdfs_dir_entry *)(kaddr + offs);
+	printk(KERN_ERR "ERROR [osdfs_check_page]: "
+		"entry in directory #%lu spans the page boundary"
+		"offset=%lu, inode=%lu",
+		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		(unsigned long) le32_to_cpu(p->inode));
+fail:
+	SetPageChecked(page);
+	SetPageError(page);
+}
+
+static struct page *osdfs_get_page(struct inode *dir, unsigned long n)
+{
+	struct address_space *mapping = dir->i_mapping;
+	struct page *page = read_cache_page(mapping, n,
+				(filler_t *)mapping->a_ops->readpage, NULL);
+	if (!IS_ERR(page)) {
+		wait_on_page_locked(page);
+		kmap(page);
+		if (!PageUptodate(page))
+			goto fail;
+		if (!PageChecked(page))
+			osdfs_check_page(page);
+		if (PageError(page))
+			goto fail;
+	}
+	return page;
+
+fail:
+	osdfs_put_page(page);
+	return ERR_PTR(-EIO);
+}
+
+static inline int osdfs_match(int len, const unsigned char *name,
+					struct osdfs_dir_entry *de)
+{
+	if (len != de->name_len)
+		return 0;
+	if (!de->inode)
+		return 0;
+	return !memcmp(name, de->name, len);
+}
+
+static inline
+struct osdfs_dir_entry *osdfs_next_entry(struct osdfs_dir_entry *p)
+{
+	return (struct osdfs_dir_entry *)((char *)p + p->rec_len);
+}
+
+static inline unsigned
+osdfs_validate_entry(char *base, unsigned offset, unsigned mask)
+{
+	struct osdfs_dir_entry *de = (struct osdfs_dir_entry *)(base + offset);
+	struct osdfs_dir_entry *p =
+			(struct osdfs_dir_entry *)(base + (offset&mask));
+	while ((char *)p < (char *)de) {
+		if (p->rec_len == 0)
+			break;
+		p = osdfs_next_entry(p);
+	}
+	return (char *)p - base;
+}
+
+static unsigned char osdfs_filetype_table[OSDFS_FT_MAX] = {
+	[OSDFS_FT_UNKNOWN]	= DT_UNKNOWN,
+	[OSDFS_FT_REG_FILE]	= DT_REG,
+	[OSDFS_FT_DIR]		= DT_DIR,
+	[OSDFS_FT_CHRDEV]	= DT_CHR,
+	[OSDFS_FT_BLKDEV]	= DT_BLK,
+	[OSDFS_FT_FIFO]		= DT_FIFO,
+	[OSDFS_FT_SOCK]		= DT_SOCK,
+	[OSDFS_FT_SYMLINK]	= DT_LNK,
+};
+
+#define S_SHIFT 12
+static unsigned char osdfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+	[S_IFREG >> S_SHIFT]	= OSDFS_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]	= OSDFS_FT_DIR,
+	[S_IFCHR >> S_SHIFT]	= OSDFS_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]	= OSDFS_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]	= OSDFS_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]	= OSDFS_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]	= OSDFS_FT_SYMLINK,
+};
+
+static inline
+void osdfs_set_de_type(struct osdfs_dir_entry *de, struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+	de->file_type = osdfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+}
+
+static int
+osdfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	loff_t pos = filp->f_pos;
+	struct inode *inode = filp->f_dentry->d_inode;
+	unsigned int offset = pos & ~PAGE_CACHE_MASK;
+	unsigned long n = pos >> PAGE_CACHE_SHIFT;
+	unsigned long npages = dir_pages(inode);
+	unsigned chunk_mask = ~(osdfs_chunk_size(inode)-1);
+	unsigned char *types = NULL;
+	int need_revalidate = (filp->f_version != inode->i_version);
+	int ret;
+
+	if (pos > inode->i_size - OSDFS_DIR_REC_LEN(1))
+		goto success;
+
+	types = osdfs_filetype_table;
+
+	for ( ; n < npages; n++, offset = 0) {
+		char *kaddr, *limit;
+		struct osdfs_dir_entry *de;
+		struct page *page = osdfs_get_page(inode, n);
+
+		if (IS_ERR(page)) {
+			printk(KERN_ERR "ERROR: "
+				   "bad page in #%lu",
+				   inode->i_ino);
+			filp->f_pos += PAGE_CACHE_SIZE - offset;
+			ret = -EIO;
+			goto done;
+		}
+		kaddr = page_address(page);
+		if (need_revalidate) {
+			offset = osdfs_validate_entry(kaddr, offset, chunk_mask);
+			need_revalidate = 0;
+		}
+		de = (struct osdfs_dir_entry *)(kaddr+offset);
+		limit = kaddr + osdfs_last_byte(inode, n) - OSDFS_DIR_REC_LEN(1);
+		for (; (char *)de <= limit; de = osdfs_next_entry(de)) {
+			if (de->rec_len == 0) {
+				printk(KERN_ERR "ERROR: "
+					"zero-length directory entry");
+				ret = -EIO;
+				osdfs_put_page(page);
+				goto done;
+			}
+			if (de->inode) {
+				int over;
+				unsigned char d_type = DT_UNKNOWN;
+
+				if (types && de->file_type < OSDFS_FT_MAX)
+					d_type = types[de->file_type];
+
+				offset = (char *)de - kaddr;
+				over = filldir(dirent, de->name, de->name_len,
+						(n<<PAGE_CACHE_SHIFT) | offset,
+						de->inode, d_type);
+				if (over) {
+					osdfs_put_page(page);
+					goto success;
+				}
+			}
+			filp->f_pos += de->rec_len;
+		}
+		osdfs_put_page(page);
+	}
+
+success:
+	ret = 0;
+done:
+	filp->f_version = inode->i_version;
+	return ret;
+}
+
+struct osdfs_dir_entry *osdfs_find_entry(struct inode *dir,
+			struct dentry *dentry, struct page **res_page)
+{
+	const unsigned char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned reclen = OSDFS_DIR_REC_LEN(namelen);
+	unsigned long start, n;
+	unsigned long npages = dir_pages(dir);
+	struct page *page = NULL;
+	struct osdfs_i_info *oi = OSDFS_I(dir);
+	struct osdfs_dir_entry *de;
+
+	if (npages == 0)
+		goto out;
+
+	*res_page = NULL;
+
+	start = oi->i_dir_start_lookup;
+	if (start >= npages)
+		start = 0;
+	n = start;
+	do {
+		char *kaddr;
+		page = osdfs_get_page(dir, n);
+		if (!IS_ERR(page)) {
+			kaddr = page_address(page);
+			de = (struct osdfs_dir_entry *) kaddr;
+			kaddr += osdfs_last_byte(dir, n) - reclen;
+			while ((char *) de <= kaddr) {
+				if (de->rec_len == 0) {
+					printk(KERN_ERR
+						"ERROR: osdfs_find_entry: "
+						"zero-length directory entry");
+					osdfs_put_page(page);
+					goto out;
+				}
+				if (osdfs_match(namelen, name, de))
+					goto found;
+				de = osdfs_next_entry(de);
+			}
+			osdfs_put_page(page);
+		}
+		if (++n >= npages)
+			n = 0;
+	} while (n != start);
+out:
+	return NULL;
+
+found:
+	*res_page = page;
+	oi->i_dir_start_lookup = n;
+	return de;
+}
+
+struct osdfs_dir_entry *osdfs_dotdot(struct inode *dir, struct page **p)
+{
+	struct page *page = osdfs_get_page(dir, 0);
+	struct osdfs_dir_entry *de = NULL;
+
+	if (!IS_ERR(page)) {
+		de = osdfs_next_entry(
+				(struct osdfs_dir_entry *)page_address(page));
+		*p = page;
+	}
+	return de;
+}
+
+ino_t osdfs_inode_by_name(struct inode *dir, struct dentry *dentry)
+{
+	ino_t res = 0;
+	struct osdfs_dir_entry *de;
+	struct page *page;
+
+	de = osdfs_find_entry(dir, dentry, &page);
+	if (de) {
+		res = de->inode;
+		kunmap(page);
+		page_cache_release(page);
+	}
+	return res;
+}
+
+void osdfs_set_link(struct inode *dir, struct osdfs_dir_entry *de,
+			struct page *page, struct inode *inode)
+{
+	unsigned from = (char *) de - (char *) page_address(page);
+	unsigned to = from + de->rec_len;
+	int err;
+
+	lock_page(page);
+	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	if (err)
+		BUG();
+	de->inode = inode->i_ino;
+	osdfs_set_de_type(de, inode);
+	err = osdfs_commit_chunk(page, from, to);
+	osdfs_put_page(page);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+}
+
+int osdfs_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	const unsigned char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned chunk_size = osdfs_chunk_size(dir);
+	unsigned reclen = OSDFS_DIR_REC_LEN(namelen);
+	unsigned short rec_len, name_len;
+	struct page *page = NULL;
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+	struct osdfs_dir_entry *de;
+	unsigned long npages = dir_pages(dir);
+	unsigned long n;
+	char *kaddr;
+	unsigned from, to;
+	int err;
+
+	for (n = 0; n <= npages; n++) {
+		char *dir_end;
+
+		page = osdfs_get_page(dir, n);
+		err = PTR_ERR(page);
+		if (IS_ERR(page))
+			goto out;
+		lock_page(page);
+		kaddr = page_address(page);
+		dir_end = kaddr + osdfs_last_byte(dir, n);
+		de = (struct osdfs_dir_entry *)kaddr;
+		kaddr += PAGE_CACHE_SIZE - reclen;
+		while ((char *)de <= kaddr) {
+			if ((char *)de == dir_end) {
+				name_len = 0;
+				rec_len = chunk_size;
+				de->rec_len = chunk_size;
+				de->inode = 0;
+				goto got_it;
+			}
+			if (de->rec_len == 0) {
+				printk(KERN_ERR "ERROR: osdfs_add_link: "
+					"zero-length directory entry");
+				err = -EIO;
+				goto out_unlock;
+			}
+			err = -EEXIST;
+			if (osdfs_match(namelen, name, de))
+				goto out_unlock;
+			name_len = OSDFS_DIR_REC_LEN(de->name_len);
+			rec_len = de->rec_len;
+			if (!de->inode && rec_len >= reclen)
+				goto got_it;
+			if (rec_len >= name_len + reclen)
+				goto got_it;
+			de = (struct osdfs_dir_entry *) ((char *) de + rec_len);
+		}
+		unlock_page(page);
+		osdfs_put_page(page);
+	}
+	BUG();
+	return -EINVAL;
+
+got_it:
+	from = (char *)de - (char *)page_address(page);
+	to = from + rec_len;
+	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	if (err)
+		goto out_unlock;
+	if (de->inode) {
+		struct osdfs_dir_entry *de1 =
+			(struct osdfs_dir_entry *)((char *)de + name_len);
+		de1->rec_len = rec_len - name_len;
+		de->rec_len = name_len;
+		de = de1;
+	}
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+	de->inode = inode->i_ino;
+	osdfs_set_de_type(de, inode);
+	err = osdfs_commit_chunk(page, from, to);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+	sbi->s_numfiles++;
+
+out_put:
+	osdfs_put_page(page);
+out:
+	return err;
+out_unlock:
+	unlock_page(page);
+	goto out_put;
+}
+
+int osdfs_delete_entry(struct osdfs_dir_entry *dir, struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+	char *kaddr = page_address(page);
+	unsigned from = ((char *)dir - kaddr) & ~(osdfs_chunk_size(inode)-1);
+	unsigned to = ((char *)dir - kaddr) + dir->rec_len;
+	struct osdfs_dir_entry *pde = NULL;
+	struct osdfs_dir_entry *de = (struct osdfs_dir_entry *) (kaddr + from);
+	int err;
+
+	while ((char *)de < (char *)dir) {
+		if (de->rec_len == 0) {
+			printk(KERN_ERR "ERROR: osdfs_delete_entry:"
+				"zero-length directory entry");
+			err = -EIO;
+			goto out;
+		}
+		pde = de;
+		de = osdfs_next_entry(de);
+	}
+	if (pde)
+		from = (char *)pde - (char *)page_address(page);
+	lock_page(page);
+	err = mapping->a_ops->prepare_write(NULL, page, from, to);
+	if (err)
+		BUG();
+	if (pde)
+		pde->rec_len = cpu_to_le16(to-from);
+	dir->inode = 0;
+	err = osdfs_commit_chunk(page, from, to);
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+	mark_inode_dirty(inode);
+	sbi->s_numfiles--;
+out:
+	osdfs_put_page(page);
+	return err;
+}
+
+int osdfs_make_empty(struct inode *inode, struct inode *parent)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct page *page = grab_cache_page(mapping, 0);
+	unsigned chunk_size = osdfs_chunk_size(inode);
+	struct osdfs_dir_entry *de;
+	int err;
+	void *kaddr;
+
+	if (!page)
+		return -ENOMEM;
+	err = mapping->a_ops->prepare_write(NULL, page, 0, chunk_size);
+	if (err) {
+		unlock_page(page);
+		goto fail;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	de = (struct osdfs_dir_entry *)kaddr;
+	de->name_len = 1;
+	de->rec_len = OSDFS_DIR_REC_LEN(1);
+	memcpy(de->name, ".\0\0", 4);
+	de->inode = inode->i_ino;
+	osdfs_set_de_type(de, inode);
+
+	de = (struct osdfs_dir_entry *)(kaddr + OSDFS_DIR_REC_LEN(1));
+	de->name_len = 2;
+	de->rec_len = chunk_size - OSDFS_DIR_REC_LEN(1);
+	de->inode = parent->i_ino;
+	memcpy(de->name, "..\0", 4);
+	osdfs_set_de_type(de, inode);
+	kunmap_atomic(page, KM_USER0);
+	err = osdfs_commit_chunk(page, 0, chunk_size);
+fail:
+	page_cache_release(page);
+	return err;
+}
+
+int osdfs_empty_dir(struct inode *inode)
+{
+	struct page *page = NULL;
+	unsigned long i, npages = dir_pages(inode);
+
+	for (i = 0; i < npages; i++) {
+		char *kaddr;
+		struct osdfs_dir_entry *de;
+		page = osdfs_get_page(inode, i);
+
+		if (IS_ERR(page))
+			continue;
+
+		kaddr = page_address(page);
+		de = (struct osdfs_dir_entry *)kaddr;
+		kaddr += osdfs_last_byte(inode, i) - OSDFS_DIR_REC_LEN(1);
+
+		while ((char *)de <= kaddr) {
+			if (de->rec_len == 0) {
+				printk(KERN_ERR "ERROR: osdfs_empty_dir: "
+					"zero-length directory entry");
+				printk("kaddr=%p, de=%p\n", kaddr, de);
+				goto not_empty;
+			}
+			if (de->inode != 0) {
+				/* check for . and .. */
+				if (de->name[0] != '.')
+					goto not_empty;
+				if (de->name_len > 2)
+					goto not_empty;
+				if (de->name_len < 2) {
+					if (de->inode !=
+					    inode->i_ino)
+						goto not_empty;
+				} else if (de->name[1] != '.')
+					goto not_empty;
+			}
+			de = osdfs_next_entry(de);
+		}
+		osdfs_put_page(page);
+	}
+	return 1;
+
+not_empty:
+	osdfs_put_page(page);
+	return 0;
+}
+
+struct file_operations osdfs_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.readdir	= osdfs_readdir,
+};
diff --git a/fs/osdfs/inode.c b/fs/osdfs/inode.c
index bfd82b1..478805e 100644
--- a/fs/osdfs/inode.c
+++ b/fs/osdfs/inode.c
@@ -408,6 +408,178 @@ fail:
 }
 
 /*
+ * Read an inode from the OSD, and return it as is.  We also return the size
+ * attribute in the 'sanity' argument if we got compiled with debugging turned
+ * on.
+ */
+int osdfs_get_inode(struct super_block *sb, struct osdfs_i_info *oi,
+		    struct osdfs_fcb *inode, uint64_t *sanity)
+{
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+	struct osd_request *req = NULL;
+	uint32_t page;
+	uint32_t attr;
+	uint16_t expected;
+	uint8_t *buf;
+	uint64_t o_id;
+	int ret;
+
+	o_id = oi->vfs_inode.i_ino + OSDFS_OBJ_OFF;
+
+	make_credential(oi->i_cred, sbi->s_pid, o_id);
+
+	req = prepare_osd_get_attr(sbi->s_dev, sbi->s_pid, o_id);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare get_attr failed.\n");
+		return -ENOMEM;
+	}
+
+	/* we need the inode attribute */
+	prepare_get_attr_list_add_entry(req,
+					OSD_PAGE_NUM_IBM_UOBJ_FS_DATA,
+					OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE,
+					OSDFS_INO_ATTR_SIZE);
+
+#ifdef OSDFS_DEBUG
+	/* we get the size attributes to do a sanity check */
+	prepare_get_attr_list_add_entry(req,
+					OSD_APAGE_OBJECT_INFORMATION,
+					OSD_ATTR_OI_LOGICAL_LENGTH, 8);
+#endif
+
+	ret = osdfs_sync_op(req, sbi->s_timeout, oi->i_cred);
+	if (ret)
+		goto out;
+
+	page = OSD_PAGE_NUM_IBM_UOBJ_FS_DATA;
+	attr = OSD_ATTR_NUM_IBM_UOBJ_FS_DATA_INODE;
+	expected = OSDFS_INO_ATTR_SIZE;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &buf);
+	if (ret) {
+		printk(KERN_ERR "ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	memcpy(inode, buf, sizeof(struct osdfs_fcb));
+
+#ifdef OSDFS_DEBUG
+	page = OSD_APAGE_OBJECT_INFORMATION;
+	attr = OSD_ATTR_OI_LOGICAL_LENGTH;
+	expected = 8;
+	ret = extract_next_attr_from_req(req, &page, &attr, &expected, &buf);
+	if (ret) {
+		printk(KERN_ERR "ERROR: extract attr from req failed\n");
+		goto out;
+	}
+	*sanity = be64_to_cpu(*((uint64_t *) buf));
+#endif
+
+out:
+	free_osd_req(req);
+	return ret;
+}
+
+/*
+ * Fill in an inode read from the OSD and set it up for use
+ */
+struct inode *osdfs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct osdfs_i_info *oi;
+	struct osdfs_fcb fcb;
+	struct inode *inode;
+	uint64_t sanity;
+	int ret;
+	int n;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+	oi = OSDFS_I(inode);
+
+	/* read the inode from the osd */
+	ret = osdfs_get_inode(sb, oi, &fcb, &sanity);
+	if (ret)
+		goto bad_inode;
+
+	init_waitqueue_head(&oi->i_wq);
+	SetObjCreated(oi);
+
+	/* copy stuff from on-disk struct to in-memory struct */
+	inode->i_mode = be16_to_cpu(fcb.i_mode);
+	inode->i_uid = be32_to_cpu(fcb.i_uid);
+	inode->i_gid = be32_to_cpu(fcb.i_gid);
+	inode->i_nlink = be16_to_cpu(fcb.i_links_count);
+	inode->i_ctime.tv_sec = be32_to_cpu(fcb.i_ctime);
+	inode->i_atime.tv_sec = be32_to_cpu(fcb.i_atime);
+	inode->i_mtime.tv_sec = be32_to_cpu(fcb.i_mtime);
+	inode->i_atime.tv_nsec = inode->i_mtime.tv_nsec =
+	    inode->i_ctime.tv_nsec = 0;
+	i_size_write(inode, be64_to_cpu(fcb.i_size));
+	inode->i_blkbits = OSDFS_BLKSHIFT;
+	inode->i_generation = be32_to_cpu(fcb.i_generation);
+
+#ifdef OSDFS_DEBUG
+	if ((inode->i_size != sanity) &&
+		(!osdfs_inode_is_fast_symlink(inode))) {
+		printk(KERN_WARNING
+		       "WARNING: Size of object from inode and "
+		       "attributes differ (%lld != %llu)\n",
+		       inode->i_size, sanity);
+	}
+#endif
+
+	oi->i_objs = fcb.i_objs;
+	oi->i_dir_start_lookup = 0;
+
+	if ((inode->i_nlink == 0) && (inode->i_mode == 0)) {
+		ret = -ESTALE;
+		goto bad_inode;
+	}
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		if (fcb.i_data[0])
+			inode->i_rdev = old_decode_dev(fcb.i_data[0]);
+		else
+			inode->i_rdev = new_decode_dev(fcb.i_data[1]);
+	} else
+		for (n = 0; n < OSDFS_IDATA; n++)
+			oi->i_data[n] = fcb.i_data[n];
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_op = &osdfs_file_inode_operations;
+		inode->i_fop = &osdfs_file_operations;
+		inode->i_mapping->a_ops = &osdfs_aops;
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_op = &osdfs_dir_inode_operations;
+		inode->i_fop = &osdfs_dir_operations;
+		inode->i_mapping->a_ops = &osdfs_aops;
+	} else if (S_ISLNK(inode->i_mode)) {
+		if (osdfs_inode_is_fast_symlink(inode))
+			inode->i_op = &osdfs_fast_symlink_inode_operations;
+		else {
+			inode->i_op = &osdfs_symlink_inode_operations;
+			inode->i_mapping->a_ops = &osdfs_aops;
+		}
+	} else {
+		inode->i_op = &osdfs_special_inode_operations;
+		if (fcb.i_data[0])
+			init_special_inode(inode, inode->i_mode,
+			   old_decode_dev(le32_to_cpu(fcb.i_data[0])));
+		else
+			init_special_inode(inode, inode->i_mode,
+			   new_decode_dev(le32_to_cpu(fcb.i_data[1])));
+	}
+
+	unlock_new_inode(inode);
+	return inode;
+
+bad_inode:
+	iget_failed(inode);
+	return ERR_PTR(ret);
+}
+
+/*
  * Set inode attributes - just call generic functions.
  */
 int osdfs_setattr(struct dentry *dentry, struct iattr *iattr)
@@ -422,3 +594,98 @@ int osdfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	error = inode_setattr(inode, iattr);
 	return error;
 }
+
+/*
+ * Callback function from osdfs_new_inode().  The important thing is that we
+ * set the ObjCreated flag so that other methods know that the object exists on
+ * the OSD.
+ */
+void create_done(struct osd_request *req, void *p)
+{
+	struct inode *inode = (struct inode *)p;
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+	int ret;
+
+	ret = check_ok(req);
+	free_osd_req(req);
+	atomic_dec(&sbi->s_curr_pending);
+
+	if (ret)
+		make_bad_inode(inode);
+	else
+		SetObjCreated(oi);
+
+	atomic_dec(&inode->i_count);
+}
+
+/*
+ * Set up a new inode and create an object for it on the OSD
+ */
+struct inode *osdfs_new_inode(struct inode *dir, int mode)
+{
+	struct super_block *sb;
+	struct inode *inode;
+	struct osdfs_i_info *oi;
+	struct osdfs_sb_info *sbi;
+	struct osd_request *req = NULL;
+	int ret;
+
+	sb = dir->i_sb;
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	oi = OSDFS_I(inode);
+
+	init_waitqueue_head(&oi->i_wq);
+	SetObj2BCreated(oi);
+
+	sbi = sb->s_fs_info;
+
+	sb->s_dirt = 1;
+	inode->i_uid = current->fsuid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode->i_gid = current->fsgid;
+	inode->i_mode = mode;
+
+	inode->i_ino = sbi->s_nextid++;
+	inode->i_blkbits = OSDFS_BLKSHIFT;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_size = 0;
+	spin_lock(&sbi->s_next_gen_lock);
+	inode->i_generation = sbi->s_next_generation++;
+	spin_unlock(&sbi->s_next_gen_lock);
+	insert_inode_hash(inode);
+
+	mark_inode_dirty(inode);
+
+	req = prepare_osd_create(sbi->s_dev, sbi->s_pid,
+			       inode->i_ino + OSDFS_OBJ_OFF);
+	if (!req) {
+		printk(KERN_ERR "ERROR: prepare_osd_create failed\n");
+		return ERR_PTR(-EIO);
+	}
+
+	make_credential(oi->i_cred, sbi->s_pid, inode->i_ino + OSDFS_OBJ_OFF);
+
+	/* increment the refcount so that the inode will still be around when we
+	 * reach the callback
+	 */
+	atomic_inc(&inode->i_count);
+
+	ret = osdfs_async_op(req, create_done, (void *)inode, oi->i_cred);
+	if (ret) {
+		atomic_dec(&inode->i_count);
+		free_osd_req(req);
+		return ERR_PTR(-EIO);
+	}
+	atomic_inc(&sbi->s_curr_pending);
+
+	return inode;
+}
+
diff --git a/fs/osdfs/namei.c b/fs/osdfs/namei.c
new file mode 100644
index 0000000..b747e90
--- /dev/null
+++ b/fs/osdfs/namei.c
@@ -0,0 +1,348 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of osdfs.
+ *
+ * osdfs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for osdfs is version 2.
+ *
+ * osdfs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with osdfs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "osdfs.h"
+
+static inline void osdfs_inc_count(struct inode *inode)
+{
+	inode->i_nlink++;
+	mark_inode_dirty(inode);
+}
+
+static inline void osdfs_dec_count(struct inode *inode)
+{
+	inode->i_nlink--;
+	mark_inode_dirty(inode);
+}
+
+static inline int osdfs_add_nondir(struct dentry *dentry, struct inode *inode)
+{
+	int err = osdfs_add_link(dentry, inode);
+	if (!err) {
+		d_instantiate(dentry, inode);
+		return 0;
+	}
+	osdfs_dec_count(inode);
+	iput(inode);
+	return err;
+}
+
+static struct dentry *osdfs_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	struct inode *inode;
+	ino_t ino;
+
+	if (dentry->d_name.len > OSDFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	ino = osdfs_inode_by_name(dir, dentry);
+	inode = NULL;
+	if (ino) {
+		inode = osdfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+	if (inode)
+		return d_splice_alias(inode, dentry);
+	d_add(dentry, inode);
+	return NULL;
+}
+
+static int osdfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			 struct nameidata *nd)
+{
+	struct inode *inode = osdfs_new_inode(dir, mode);
+	int err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		inode->i_op = &osdfs_file_inode_operations;
+		inode->i_fop = &osdfs_file_operations;
+		inode->i_mapping->a_ops = &osdfs_aops;
+		mark_inode_dirty(inode);
+		err = osdfs_add_nondir(dentry, inode);
+	}
+	return err;
+}
+
+static int osdfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		       dev_t rdev)
+{
+	struct inode *inode;
+	int err;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	inode = osdfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		init_special_inode(inode, inode->i_mode, rdev);
+		mark_inode_dirty(inode);
+		err = osdfs_add_nondir(dentry, inode);
+	}
+	return err;
+}
+
+static int osdfs_symlink(struct inode *dir, struct dentry *dentry,
+			  const char *symname)
+{
+	struct super_block *sb = dir->i_sb;
+	int err = -ENAMETOOLONG;
+	unsigned l = strlen(symname)+1;
+	struct inode *inode;
+
+	if (l > sb->s_blocksize)
+		goto out;
+
+	inode = osdfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	if (l > sizeof(OSDFS_I(inode)->i_data)) {
+		/* slow symlink */
+		inode->i_op = &osdfs_symlink_inode_operations;
+		inode->i_mapping->a_ops = &osdfs_aops;
+		err = page_symlink(inode, symname, l);
+		memset((char *)(OSDFS_I(inode)->i_data), 0, OSDFS_IDATA);
+		if (err)
+			goto out_fail;
+	} else {
+		/* fast symlink */
+		inode->i_op = &osdfs_fast_symlink_inode_operations;
+		memcpy((char *)(OSDFS_I(inode)->i_data), symname, l);
+		inode->i_size = l-1;
+	}
+	mark_inode_dirty(inode);
+
+	err = osdfs_add_nondir(dentry, inode);
+out:
+	return err;
+
+out_fail:
+	osdfs_dec_count(inode);
+	iput(inode);
+	goto out;
+}
+
+static int osdfs_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+
+	if (inode->i_nlink >= OSDFS_LINK_MAX)
+		return -EMLINK;
+
+	inode->i_ctime = CURRENT_TIME;
+	osdfs_inc_count(inode);
+	atomic_inc(&inode->i_count);
+
+	return osdfs_add_nondir(dentry, inode);
+}
+
+static int osdfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+	int err = -EMLINK;
+
+	if (dir->i_nlink >= OSDFS_LINK_MAX)
+		goto out;
+
+	osdfs_inc_count(dir);
+
+	inode = osdfs_new_inode(dir, S_IFDIR | mode);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out_dir;
+
+	inode->i_op = &osdfs_dir_inode_operations;
+	inode->i_fop = &osdfs_dir_operations;
+	inode->i_mapping->a_ops = &osdfs_aops;
+
+	osdfs_inc_count(inode);
+
+	err = osdfs_make_empty(inode, dir);
+	if (err)
+		goto out_fail;
+
+	err = osdfs_add_link(dentry, inode);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+out:
+	return err;
+
+out_fail:
+	osdfs_dec_count(inode);
+	osdfs_dec_count(inode);
+	iput(inode);
+out_dir:
+	osdfs_dec_count(dir);
+	goto out;
+}
+
+static int osdfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct osdfs_dir_entry *de;
+	struct page *page;
+	int err = -ENOENT;
+
+	de = osdfs_find_entry(dir, dentry, &page);
+	if (!de)
+		goto out;
+
+	err = osdfs_delete_entry(de, page);
+	if (err)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+	osdfs_dec_count(inode);
+	err = 0;
+out:
+	return err;
+}
+
+static int osdfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	int err = -ENOTEMPTY;
+
+	if (osdfs_empty_dir(inode)) {
+		err = osdfs_unlink(dir, dentry);
+		if (!err) {
+			inode->i_size = 0;
+			osdfs_dec_count(inode);
+			osdfs_dec_count(dir);
+		}
+	}
+	return err;
+}
+
+static int osdfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *dir_page = NULL;
+	struct osdfs_dir_entry *dir_de = NULL;
+	struct page *old_page;
+	struct osdfs_dir_entry *old_de;
+	int err = -ENOENT;
+
+	old_de = osdfs_find_entry(old_dir, old_dentry, &old_page);
+	if (!old_de)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		err = -EIO;
+		dir_de = osdfs_dotdot(old_inode, &dir_page);
+		if (!dir_de)
+			goto out_old;
+	}
+
+	if (new_inode) {
+		struct page *new_page;
+		struct osdfs_dir_entry *new_de;
+
+		err = -ENOTEMPTY;
+		if (dir_de && !osdfs_empty_dir(new_inode))
+			goto out_dir;
+
+		err = -ENOENT;
+		new_de = osdfs_find_entry(new_dir, new_dentry, &new_page);
+		if (!new_de)
+			goto out_dir;
+		osdfs_inc_count(old_inode);
+		osdfs_set_link(new_dir, new_de, new_page, old_inode);
+		new_inode->i_ctime = CURRENT_TIME;
+		if (dir_de)
+			new_inode->i_nlink--;
+		osdfs_dec_count(new_inode);
+	} else {
+		if (dir_de) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= OSDFS_LINK_MAX)
+				goto out_dir;
+		}
+		osdfs_inc_count(old_inode);
+		err = osdfs_add_link(new_dentry, old_inode);
+		if (err) {
+			osdfs_dec_count(old_inode);
+			goto out_dir;
+		}
+		if (dir_de)
+			osdfs_inc_count(new_dir);
+	}
+
+	old_inode->i_ctime = CURRENT_TIME;
+
+	osdfs_delete_entry(old_de, old_page);
+	osdfs_dec_count(old_inode);
+
+	if (dir_de) {
+		osdfs_set_link(old_inode, dir_de, dir_page, new_dir);
+		osdfs_dec_count(old_dir);
+	}
+	return 0;
+
+
+out_dir:
+	if (dir_de) {
+		kunmap(dir_page);
+		page_cache_release(dir_page);
+	}
+out_old:
+	kunmap(old_page);
+	page_cache_release(old_page);
+out:
+	return err;
+}
+
+struct inode_operations osdfs_dir_inode_operations = {
+	.create 	= osdfs_create,
+	.lookup 	= osdfs_lookup,
+	.link   	= osdfs_link,
+	.unlink 	= osdfs_unlink,
+	.symlink	= osdfs_symlink,
+	.mkdir  	= osdfs_mkdir,
+	.rmdir  	= osdfs_rmdir,
+	.mknod  	= osdfs_mknod,
+	.rename 	= osdfs_rename,
+	.setattr	= osdfs_setattr,
+};
+
+struct inode_operations osdfs_special_inode_operations = {
+	.setattr	= osdfs_setattr,
+};
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
index 29e7d7b..00c89f7 100644
--- a/fs/osdfs/osdfs.h
+++ b/fs/osdfs/osdfs.h
@@ -106,6 +106,11 @@ static inline struct osdfs_i_info *OSDFS_I(struct inode *inode)
 	return container_of(inode, struct osdfs_i_info, vfs_inode);
 }
 
+/*
+ * Maximum count of links to a file
+ */
+#define OSDFS_LINK_MAX           32000
+
 /*************************
  * function declarations *
  *************************/
@@ -179,11 +184,28 @@ void free_osd_req(struct osd_request *req);
 
 /* inode.c               */
 void osdfs_truncate(struct inode *inode);
+extern struct inode *osdfs_iget(struct super_block *, unsigned long);
+struct inode *osdfs_new_inode(struct inode *, int);
 int osdfs_setattr(struct dentry *, struct iattr *);
 
+/* dir.c:                */
+int osdfs_add_link(struct dentry *, struct inode *);
+ino_t osdfs_inode_by_name(struct inode *, struct dentry *);
+int osdfs_delete_entry(struct osdfs_dir_entry *, struct page *);
+int osdfs_make_empty(struct inode *, struct inode *);
+struct osdfs_dir_entry *osdfs_find_entry(struct inode *, struct dentry *,
+					 struct page **);
+int osdfs_empty_dir(struct inode *);
+struct osdfs_dir_entry *osdfs_dotdot(struct inode *, struct page **);
+void osdfs_set_link(struct inode *, struct osdfs_dir_entry *, struct page *,
+		    struct inode *);
+
 /*********************
  * operation vectors *
  *********************/
+/* dir.c:            */
+extern struct file_operations osdfs_dir_operations;
+
 /* file.c            */
 extern struct inode_operations osdfs_file_inode_operations;
 extern struct file_operations osdfs_file_operations;
@@ -191,6 +213,10 @@ extern struct file_operations osdfs_file_operations;
 /* inode.c           */
 extern struct address_space_operations osdfs_aops;
 
+/* namei.c           */
+extern struct inode_operations osdfs_dir_inode_operations;
+extern struct inode_operations osdfs_special_inode_operations;
+
 /* symlink.c         */
 extern struct inode_operations osdfs_symlink_inode_operations;
 extern struct inode_operations osdfs_fast_symlink_inode_operations;
-- 
1.6.0.1

