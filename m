From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Mon, 28 Jun 2010 17:25:36 +0200
Message-ID: <20100628152536.GA16013@lst.de>
References: <20100627110712.GA14511@lst.de> <20100627212952D.fujita.tomonori@lab.ntt.co.jp> <20100628075738.GA26606@lst.de> <20100628171218Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100628171218Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 28, 2010 at 05:14:28PM +0900, FUJITA Tomonori wrote:
> > While I see the problems with leaking ressources in that case I still
> > can't quite explain the hang I see.
> 
> Any way to reproduce the hang without ssd drives?

Actually the SSDs don't fully hang, they just causes lots of I/O errors
and hit the error handler hard.  The hard hang is when running under
qemu.  Apply the patch below, then create an if=scsi drive that resides
on an XFS filesystem, and you'll have scsi TP support in the guest:


Index: qemu/hw/scsi-disk.c
===================================================================
--- qemu.orig/hw/scsi-disk.c	2010-06-26 14:40:42.580004436 +0200
+++ qemu/hw/scsi-disk.c	2010-06-26 14:59:20.338020011 +0200
@@ -397,6 +397,7 @@ static int scsi_disk_emulate_inquiry(SCS
         }
         case 0xb0: /* block device characteristics */
         {
+            static const int trim_sectors = (2 * 1024 * 1024) / 512;
             unsigned int min_io_size =
                     s->qdev.conf.min_io_size / s->qdev.blocksize;
             unsigned int opt_io_size =
@@ -416,6 +417,12 @@ static int scsi_disk_emulate_inquiry(SCS
             outbuf[13] = (opt_io_size >> 16) & 0xff;
             outbuf[14] = (opt_io_size >> 8) & 0xff;
             outbuf[15] = opt_io_size & 0xff;
+
+            /* optimal unmap granularity */
+            outbuf[28] = (trim_sectors >> 24) & 0xff;
+            outbuf[29] = (trim_sectors >> 16) & 0xff;
+            outbuf[30] = (trim_sectors >> 8) & 0xff;
+            outbuf[31] = trim_sectors & 0xff;
             break;
         }
         default:
@@ -824,6 +831,11 @@ static int scsi_disk_emulate_command(SCS
             outbuf[11] = 0;
             outbuf[12] = 0;
             outbuf[13] = get_physical_block_exp(&s->qdev.conf);
+
+            /* set TPE and TPRZ bits if the format supports discard */
+            if (bdrv_is_discardable(s->bs))
+                outbuf[14] = 0x80 | 0x40;
+
             /* Protection, exponent and lowest lba field left blank. */
             buflen = req->cmd.xfer;
             break;
@@ -988,6 +1000,28 @@ static int32_t scsi_send_command(SCSIDev
         r->sector_count = len * s->cluster_size;
         is_write = 1;
         break;
+    case WRITE_SAME_16:
+//        printf("WRITE SAME(16) (sector %" PRId64 ", count %d)\n", lba, len);
+
+//        if (lba + len > s->max_lba)
+        if (lba > s->max_lba)
+            goto illegal_lba; // check the condition code
+        /*
+         * We only support WRITE SAME with the unmap bit set for now.
+         */
+        if (!(buf[1] & 0x8))
+            goto fail;
+
+        rc = bdrv_discard(s->bs, lba * s->cluster_size, len * s->cluster_size);
+        if (rc < 0) {
+            /* XXX: better error code ?*/
+            goto fail;
+        }
+
+        scsi_req_set_status(&r->req, GOOD, NO_SENSE);
+        scsi_req_complete(&r->req);
+        scsi_remove_request(r);
+        return 0;
     default:
 	DPRINTF("Unknown SCSI command (%2.2x)\n", buf[0]);
     fail:
Index: qemu/hw/scsi-defs.h
===================================================================
--- qemu.orig/hw/scsi-defs.h	2010-06-26 14:40:42.589025947 +0200
+++ qemu/hw/scsi-defs.h	2010-06-26 14:40:43.820253983 +0200
@@ -84,6 +84,7 @@
 #define MODE_SENSE_10         0x5a
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
+#define WRITE_SAME_16         0x93
 #define MAINTENANCE_IN        0xa3
 #define MAINTENANCE_OUT       0xa4
 #define MOVE_MEDIUM           0xa5
Index: qemu/block.c
===================================================================
--- qemu.orig/block.c	2010-06-26 14:40:42.597004296 +0200
+++ qemu/block.c	2010-06-26 14:40:43.824253703 +0200
@@ -1286,6 +1286,11 @@ int bdrv_is_sg(BlockDriverState *bs)
     return bs->sg;
 }
 
+int bdrv_is_discardable(BlockDriverState *bs)
+{
+    return bs->discardable;
+}
+
 int bdrv_enable_write_cache(BlockDriverState *bs)
 {
     return bs->enable_write_cache;
@@ -1431,6 +1436,13 @@ int bdrv_has_zero_init(BlockDriverState
     return 1;
 }
 
+int bdrv_discard(BlockDriverState *bs, int64_t sector_num, int nb_sectors)
+{
+    if (!bs->drv || !bs->drv->bdrv_discard)
+        return -ENOTSUP;
+    return bs->drv->bdrv_discard(bs, sector_num, nb_sectors);
+}
+
 /*
  * Returns true iff the specified sector is present in the disk image. Drivers
  * not implementing the functionality are assumed to not support backing files,
Index: qemu/block.h
===================================================================
--- qemu.orig/block.h	2010-06-26 14:40:42.606004157 +0200
+++ qemu/block.h	2010-06-26 14:40:43.831254122 +0200
@@ -135,6 +135,7 @@ void bdrv_flush(BlockDriverState *bs);
 void bdrv_flush_all(void);
 void bdrv_close_all(void);
 
+int bdrv_discard(BlockDriverState *bs, int64_t sector_num, int nb_sectors);
 int bdrv_has_zero_init(BlockDriverState *bs);
 int bdrv_is_allocated(BlockDriverState *bs, int64_t sector_num, int nb_sectors,
 	int *pnum);
@@ -162,6 +163,7 @@ BlockErrorAction bdrv_get_on_error(Block
 int bdrv_is_removable(BlockDriverState *bs);
 int bdrv_is_read_only(BlockDriverState *bs);
 int bdrv_is_sg(BlockDriverState *bs);
+int bdrv_is_discardable(BlockDriverState *bs);
 int bdrv_enable_write_cache(BlockDriverState *bs);
 int bdrv_is_inserted(BlockDriverState *bs);
 int bdrv_media_changed(BlockDriverState *bs);
Index: qemu/block/raw-posix.c
===================================================================
--- qemu.orig/block/raw-posix.c	2010-06-26 14:40:42.614025947 +0200
+++ qemu/block/raw-posix.c	2010-06-26 14:42:33.449255585 +0200
@@ -68,6 +68,10 @@
 #include <sys/diskslice.h>
 #endif
 
+#ifdef CONFIG_XFS
+#include <xfs/xfs.h>
+#endif
+
 //#define DEBUG_FLOPPY
 
 //#define DEBUG_BLOCK
@@ -117,6 +121,9 @@ typedef struct BDRVRawState {
     int use_aio;
     void *aio_ctx;
 #endif
+#ifdef CONFIG_XFS
+    int is_xfs : 1;
+#endif
     uint8_t* aligned_buf;
 } BDRVRawState;
 
@@ -189,6 +196,13 @@ static int raw_open_common(BlockDriverSt
 #endif
     }
 
+#ifdef CONFIG_XFS
+    if (platform_test_xfs_fd(s->fd)) {
+        s->is_xfs = 1;
+        bs->discardable = 1;
+    }
+#endif
+
     return 0;
 
 out_free_buf:
@@ -731,6 +745,36 @@ static void raw_flush(BlockDriverState *
     qemu_fdatasync(s->fd);
 }
 
+#ifdef CONFIG_XFS
+static int xfs_discard(BDRVRawState *s, int64_t sector_num, int nb_sectors)
+{
+    struct xfs_flock64 fl;
+
+    memset(&fl, 0, sizeof(fl));
+    fl.l_whence = SEEK_SET;
+    fl.l_start = sector_num << 9;
+    fl.l_len = (int64_t)nb_sectors << 9;
+
+    if (xfsctl(NULL, s->fd, XFS_IOC_UNRESVSP64, &fl) < 0) {
+        printf("cannot punch hole (%s)\n", strerror(errno));
+        return -errno;
+    }
+
+    return 0;
+}
+#endif
+
+static int raw_discard(BlockDriverState *bs, int64_t sector_num, int nb_sectors)
+{
+    BDRVRawState *s = bs->opaque;
+
+#ifdef CONFIG_XFS
+    if (s->is_xfs)
+        return xfs_discard(s, sector_num, nb_sectors);
+#endif
+
+    return -EOPNOTSUPP;
+}
 
 static QEMUOptionParameter raw_create_options[] = {
     {
@@ -752,6 +796,7 @@ static BlockDriver bdrv_file = {
     .bdrv_close = raw_close,
     .bdrv_create = raw_create,
     .bdrv_flush = raw_flush,
+    .bdrv_discard = raw_discard,
 
     .bdrv_aio_readv = raw_aio_readv,
     .bdrv_aio_writev = raw_aio_writev,
Index: qemu/block_int.h
===================================================================
--- qemu.orig/block_int.h	2010-06-26 14:40:42.636003738 +0200
+++ qemu/block_int.h	2010-06-26 14:40:43.843033002 +0200
@@ -73,6 +73,8 @@ struct BlockDriver {
         BlockDriverCompletionFunc *cb, void *opaque);
     BlockDriverAIOCB *(*bdrv_aio_flush)(BlockDriverState *bs,
         BlockDriverCompletionFunc *cb, void *opaque);
+    int (*bdrv_discard)(BlockDriverState *bs, int64_t sector_num,
+                        int nb_sectors);
 
     int (*bdrv_aio_multiwrite)(BlockDriverState *bs, BlockRequest *reqs,
         int num_reqs);
@@ -141,6 +143,7 @@ struct BlockDriverState {
     int encrypted; /* if true, the media is encrypted */
     int valid_key; /* if true, a valid encryption key has been set */
     int sg;        /* if true, the device is a /dev/sg* */
+    int discardable;/* if true the device supports TRIM/UNMAP */
     /* event callback when inserting/removing */
     void (*change_cb)(void *opaque);
     void *change_opaque;
Index: qemu/configure
===================================================================
--- qemu.orig/configure	2010-06-26 14:40:42.644003947 +0200
+++ qemu/configure	2010-06-26 14:40:43.850005973 +0200
@@ -272,6 +272,7 @@ xen=""
 linux_aio=""
 attr=""
 vhost_net=""
+xfs=""
 
 gprof="no"
 debug_tcg="no"
@@ -1284,6 +1285,27 @@ EOF
 fi
 
 ##########################################
+# xfsctl() probe, used for raw-posix
+if test "$xfs" != "no" ; then
+  cat > $TMPC << EOF
+#include <xfs/xfs.h>
+int main(void)
+{
+    xfsctl(NULL, 0, 0, NULL);
+    return 0;
+}
+EOF
+  if compile_prog "" "" ; then
+    xfs="yes"
+  else
+    if test "$xfs" = "yes" ; then
+      feature_not_found "uuid"
+    fi
+    xfs=no
+  fi
+fi
+
+##########################################
 # vde libraries probe
 if test "$vde" != "no" ; then
   vde_libs="-lvdeplug"
@@ -2115,6 +2137,7 @@ echo "preadv support    $preadv"
 echo "fdatasync         $fdatasync"
 echo "uuid support      $uuid"
 echo "vhost-net support $vhost_net"
+echo "xfsctl support    $xfs"
 
 if test $sdl_too_old = "yes"; then
 echo "-> Your SDL version is too old - please upgrade to have SDL support"
@@ -2235,6 +2258,9 @@ fi
 if test "$uuid" = "yes" ; then
   echo "CONFIG_UUID=y" >> $config_host_mak
 fi
+if test "$xfs" = "yes" ; then
+  echo "CONFIG_XFS=y" >> $config_host_mak
+fi
 qemu_version=`head $source_path/VERSION`
 echo "VERSION=$qemu_version" >>$config_host_mak
 echo "PKGVERSION=$pkgversion" >>$config_host_mak
Index: qemu/block/raw.c
===================================================================
--- qemu.orig/block/raw.c	2010-06-26 14:40:42.628004296 +0200
+++ qemu/block/raw.c	2010-06-26 14:40:43.852014913 +0200
@@ -6,6 +6,7 @@
 static int raw_open(BlockDriverState *bs, int flags)
 {
     bs->sg = bs->file->sg;
+    bs->discardable = bs->file->discardable;
     return 0;
 }
 
@@ -65,6 +66,11 @@ static int raw_probe(const uint8_t *buf,
    return 1; /* everything can be opened as raw image */
 }
 
+static int raw_discard(BlockDriverState *bs, int64_t sector_num, int nb_sectors)
+{
+    return bdrv_discard(bs->file, sector_num, nb_sectors);
+}
+
 static int raw_is_inserted(BlockDriverState *bs)
 {
     return bdrv_is_inserted(bs->file);
@@ -125,6 +131,7 @@ static BlockDriver bdrv_raw = {
     .bdrv_aio_readv     = raw_aio_readv,
     .bdrv_aio_writev    = raw_aio_writev,
     .bdrv_aio_flush     = raw_aio_flush,
+    .bdrv_discard	= raw_discard,
 
     .bdrv_is_inserted   = raw_is_inserted,
     .bdrv_eject         = raw_eject,
