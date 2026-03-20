Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53583D566B;
	Fri, 20 Mar 2026 22:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774046435; cv=none; b=cipCTZJwcXYO2QLmNzWfT+n0a3VCw4IFmg0vRxkBUiMF7ba44aeYnq3nIlkQwr+CUiwunLo2DhXql47q+/MlIFI9Hz81E06UTjzbtnjWU89OVyOY0rCgSUOXXUQoePr+i2RKhtuHnyMtQ/mimwKYi70GAguoWHvSpFmLp7iJ8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774046435; c=relaxed/simple;
	bh=zfhQBezGG5IcURkg0NJT+vOaS0gfqxyLqpHHVrI7cmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6u4wDGpZz2kPJqT9Vrgf7o/CPaqnW7AJnY0y/W/EfX4OteVclHaeApuGijfLWFlK4UXgGwAq7ywZD3UZv9wXJHpSf/k+koujIhEahA/0mWXerqbhqdu3yfHwxkUijZjpzY6eK6cB8FUh0P97BxRlh78XG5/uS5nRNkYGIwcjJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oc7nm0wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oc7nm0wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D30C2BCB0;
	Fri, 20 Mar 2026 22:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046434;
	bh=zfhQBezGG5IcURkg0NJT+vOaS0gfqxyLqpHHVrI7cmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc7nm0wvIPI8zRhE2sWNIsoZqJNkcj0rKW7f0P6BhLrYg79O6iX1NqkqqQ80fWOR1
	 /8lL3U0nYtBz34iD8QnhN/OAO9e3BhyKs/Tr+e4lZC2PPMPfdc1irVXs0TrXzvdrLL
	 GULWFOngwHrBiDXdseBMhd9km9NNqODvNvAPRUS667fmC5Z/ZQzeO+wNaVlOCHXIt5
	 pWhoTCZSaXBw8Qo2kr5dSs59RKsbk9m0efXCfRx5rgsTQGkqEayyuTYSQSjLqw56b+
	 eHlg1g5RfTijTn5ubMEusLGvXB8kf3KoxQPbuktXUTyTEnRV487+vCsOxH0mhJsV3K
	 VEOZGrCj6xEOg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 10/21] fs: afs: restore mmap_prepare implementation
Date: Fri, 20 Mar 2026 22:39:36 +0000
Message-ID: <ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
of the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare is called
pre-merge, and may then be merged, nor that mmap_prepare can fail to map
due to an out of memory error.

This change was therefore since reverted.

Both of those are cases in which we should not be incrementing a reference
count.

With the newly added vm_ops->mapped callback available, we can simply
defer this operation to that callback which is only invoked once the
mapping is successfully in place (but not yet visible to userspace as the
mmap and VMA write locks are held).

This allows us to once again reimplement the .mmap_prepare implementation
for this file system.

Therefore add afs_mapped() to implement this callback for AFS, and remove
the code doing so in afs_mmap_prepare().

Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
consistent in how the vnode is accessed.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/afs/file.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 74d04af51ff4..85696ac984cc 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -19,7 +19,7 @@
 #include <trace/events/netfs.h>
 #include "internal.h"

-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
+static int afs_file_mmap_prepare(struct vm_area_desc *desc);

 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
@@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
 static void afs_vm_open(struct vm_area_struct *area);
 static void afs_vm_close(struct vm_area_struct *area);
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);

 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -35,7 +37,7 @@ const struct file_operations afs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= afs_file_read_iter,
 	.write_iter	= netfs_file_write_iter,
-	.mmap		= afs_file_mmap,
+	.mmap_prepare	= afs_file_mmap_prepare,
 	.splice_read	= afs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= afs_fsync,
@@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
 };

 static const struct vm_operations_struct afs_vm_ops = {
+	.mapped		= afs_mapped,
 	.open		= afs_vm_open,
 	.close		= afs_vm_close,
 	.fault		= filemap_fault,
@@ -492,34 +495,47 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
 /*
  * Handle setting up a memory mapping on an AFS file.
  */
-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int afs_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	int ret;

-	afs_add_open_mmap(vnode);
+	ret = generic_file_mmap_prepare(desc);
+	if (ret)
+		return ret;

-	ret = generic_file_mmap(file, vma);
-	if (ret == 0)
-		vma->vm_ops = &afs_vm_ops;
-	else
-		afs_drop_open_mmap(vnode);
+	desc->vm_ops = &afs_vm_ops;
 	return ret;
 }

+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
+	return 0;
+}
+
 static void afs_vm_open(struct vm_area_struct *vma)
 {
-	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
 }

 static void afs_vm_close(struct vm_area_struct *vma)
 {
-	afs_drop_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_drop_open_mmap(vnode);
 }

 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
+	struct file *file = vmf->vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));

 	if (afs_check_validity(vnode))
 		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
--
2.53.0
