From: jiangyiwen <jiangyiwen@huawei.com>
Subject: [PATCH v2 hulk-4.1-next 2/7] 9p: ->evict_inode() should kick out
 ->i_data, not, ->i_mapping
Date: Fri, 19 Jan 2018 11:46:18 +0800
Message-ID: <5A616A0A.1090001@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:44817 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754836AbeASDqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 22:46:54 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 41DE44FCE0076
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2018 11:46:51 +0800 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Wangguoli (Andy)" <andy.wangguoli@huawei.com>, Veaceslav Falico <veaceslav.falico@huawei.com>, "Antonios Motakis (Tony)" <Antonios.Motakis@huawei.com>, Eduard Shishkin <Eduard.Shishkin@huawei.com>, "zhangwei (CR)" <zhangwei555@huawei.com>, wick.wei@huawei.com, caihaomin <caihaomin@huawei.com>

mainline inclusion
from v4.4-rc5
commit 4ad78628445d26e5e9487b2e8f23274ad7b0f5d3
category: bugfix
bugzilla: 4404
DTS: NA
CVE: NA
补丁作用：对于块设备文件而言，->i_mapping与
普通文件不相同，如果文件中的数据来自于块设备
文件，则其->i_mapping将指向的是bdevfs inode
（master inode）的i_data，而->i_data实际是
empty的，因此在evict_inode的时候不应该释放
->i_mapping（bdevfs_inode->i_data）的所有
pagecache；同时->i_mapping只有在文件被打开
的时候才能访问，此时已经是文件被关闭时不应
该访问该变量。

-------------------
[ Upstream commit 4ad78628445d26e5e9487b2e8f23274ad7b0f5d3 ]

For block devices the pagecache is associated with the inode
on bdevfs, not with the aliasing ones on the mountable filesystems.
The latter have its own ->i_data empty and ->i_mapping pointing
to the (unique per major/minor) bdevfs inode.  That guarantees
cache coherence between all block device inodes with the same
device number.

Eviction of an alias inode has no business trying to evict the
pages belonging to bdevfs one; moreover, ->i_mapping is only
safe to access when the thing is opened.  At the time of
->evict_inode() the victim is definitely *not* opened.  We are
about to kill the address space embedded into struct inode
(inode->i_data) and that's what we need to empty of any pages.

9p instance tries to empty inode->i_mapping instead, which is
both unsafe and bogus - if we have several device nodes with
the same device number in different places, closing one of them
should not try to empty the (shared) page cache.

Fortunately, other instances in the tree are OK; they are
evicting from &inode->i_data instead, as 9p one should.

Cc: stable@vger.kernel.org # v2.6.32+, ones prior to 2.6.36 need only half of that
Reported-by: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Tested-by: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/9p/vfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3d1f365..9b96add 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -451,9 +451,9 @@ void v9fs_evict_inode(struct inode *inode)
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);

-	truncate_inode_pages_final(inode->i_mapping);
+	truncate_inode_pages_final(&inode->i_data);
 	clear_inode(inode);
-	filemap_fdatawrite(inode->i_mapping);
+	filemap_fdatawrite(&inode->i_data);

 	v9fs_cache_inode_put_cookie(inode);
 	/* clunk the fid stashed in writeback_fid */
-- 
1.8.3.1
