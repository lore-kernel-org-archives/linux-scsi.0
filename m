From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 1/4] dm-mpath: add a path selector interface
Date: Fri, 12 Sep 2008 10:52:18 -0400 (EDT)
Message-ID: <20080912.105218.88470004.k-ueda@ct.jp.nec.com>
References: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, stefan.bader@canonical.com
List-Id: linux-scsi@vger.kernel.org

This patch adds a new hook for dm path selector: start_io.
Target drivers should call this hook before submitting I/O to
the selected path.
Path selectors can use it to start accounting of the I/O.
(e.g. counting the number of in-flight I/Os.)

The code is based on the patch posted by Stefan Bader:
https://www.redhat.com/archives/dm-devel/2005-October/msg00050.html


Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c         |    3 +++
 drivers/md/dm-path-selector.h |    1 +
 2 files changed, 4 insertions(+)

Index: 2.6.27-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.27-rc6/drivers/md/dm-mpath.c
@@ -343,6 +343,9 @@ static int map_io(struct multipath *m, s
 
 	mpio->pgpath = pgpath;
 
+	if (r == DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
+		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path);
+
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return r;
Index: 2.6.27-rc6/drivers/md/dm-path-selector.h
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm-path-selector.h
+++ 2.6.27-rc6/drivers/md/dm-path-selector.h
@@ -75,6 +75,7 @@ struct path_selector_type {
 	int (*status) (struct path_selector *ps, struct dm_path *path,
 		       status_type_t type, char *result, unsigned int maxlen);
 
+	int (*start_io) (struct path_selector *ps, struct dm_path *path);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path);
 };
 
