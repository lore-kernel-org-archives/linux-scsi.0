From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] dmraid: make nv use alt_size if available
Date: Sun, 01 Feb 2009 12:01:04 +0900
Message-ID: <49851070.7030306@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	<49851012.8070904@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49851012.8070904@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
List-Id: linux-scsi@vger.kernel.org

nv puts metatdata at the end of a device, so it's important that
dmraid and BIOS agree where the end of the device is.  Later kernel
exports the BIOS as via sysfs and it's available as di->alt_sectors.
Use it if available.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/format/ataraid/nv.c |   15 +++++++++++----
 lib/format/ataraid/nv.h |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/lib/format/ataraid/nv.c b/lib/format/ataraid/nv.c
index 893cc3a..bd4589c 100644
--- a/lib/format/ataraid/nv.c
+++ b/lib/format/ataraid/nv.c
@@ -216,9 +216,16 @@ static int setup_rd(struct lib_context *lc, struct raid_dev *rd,
 static struct raid_dev *
 nv_read(struct lib_context *lc, struct dev_info *di)
 {
-	return read_raid_dev(lc, di, NULL,
-			     sizeof(struct nv), NV_CONFIGOFFSET,
-			     to_cpu, is_nv, NULL, setup_rd, handler);
+	uint64_t sectors = di->alt_sectors ? di->alt_sectors : di->sectors;
+	struct raid_dev *rd;
+
+	rd = read_raid_dev(lc, di, NULL, sizeof(struct nv),
+			   NV_CONFIGOFFSET(sectors),
+			   to_cpu, is_nv, NULL, setup_rd, handler);
+	if (rd && di->alt_sectors)
+		log_notice(lc, "%s: using BIOS sectors %"PRIu64,
+			   di->path, di->alt_sectors);
+	return rd;
 }
 
 /* Write private RAID metadata to device */
@@ -427,7 +434,7 @@ setup_rd(struct lib_context *lc, struct raid_dev *rd,
 	if (!(rd->meta_areas = alloc_meta_areas(lc, rd, handler, 1)))
 		return 0;
 
-	rd->meta_areas->offset = NV_CONFIGOFFSET >> 9;
+	rd->meta_areas->offset = info->u64 >> 9;
 	rd->meta_areas->size = sizeof(*nv);
 	rd->meta_areas->area = (void *) nv;
 
diff --git a/lib/format/ataraid/nv.h b/lib/format/ataraid/nv.h
index 020900c..cca32da 100644
--- a/lib/format/ataraid/nv.h
+++ b/lib/format/ataraid/nv.h
@@ -23,7 +23,7 @@
 
 #include <stdint.h>
 
-#define	NV_CONFIGOFFSET		((di->sectors - 2) << 9)
+#define	NV_CONFIGOFFSET(sects)	(((sects) - 2) << 9)
 #define	NV_DATAOFFSET		0
 
 #define NV_ID_LENGTH		8
-- 
1.6.0.2
