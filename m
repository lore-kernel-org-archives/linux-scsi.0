From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 5/5] blk_end_request: userspace
 multipath-tools for request-based dm
Date: Fri, 31 Aug 2007 18:46:16 -0400 (EDT)
Message-ID: <20070831.184616.111210109.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch changes multipath-tools to use request-based dm-multipath.
This patch should be applied on top of 8/28/2007 git multipath-tools.

Request-based dm itself is still under development and not ready
for inclusion.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 devmapper.c |    2 ++
 1 files changed, 2 insertions(+)

diff -rupN git-multipath-tools-20070828/libmultipath/devmapper.c rqdm-multipath-tools/libmultipath/devmapper.c
--- git-multipath-tools-20070828/libmultipath/devmapper.c	2007-08-28 17:05:25.000000000 -0400
+++ rqdm-multipath-tools/libmultipath/devmapper.c	2007-08-28 17:50:47.000000000 -0400
@@ -174,6 +174,7 @@ dm_simplecmd (int task, const char *name
 #ifdef LIBDM_API_FLUSH
 	dm_task_no_flush(dmt);          /* for DM_DEVICE_SUSPEND/RESUME */
 #endif
+	dm_task_request_base(dmt);
 
 	r = dm_task_run (dmt);
 
@@ -211,6 +212,7 @@ dm_addmap (int task, const char *name, c
 	}
 
 	dm_task_no_open_count(dmt);
+	dm_task_request_base(dmt);
 
 	r = dm_task_run (dmt);
 
