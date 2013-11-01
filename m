From: yang jun <yangjun.donglife123@gmail.com>
Subject: [PATCH][SCSI] sr: Remove sr_mutex just like sd_module to optimize
 multi-drive performance
Date: Fri, 1 Nov 2013 23:46:29 +0800
Message-ID: <CAO4Pk4xtaz2qwNJcfkNqK3CMAccGqr-i7UK+=fB0yxyoLp=tmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46732 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3KAPqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 11:46:30 -0400
Received: by mail-vc0-f176.google.com with SMTP id ia6so2991836vcb.21
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2013 08:46:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The sr_mutex is not necessary, so we can delete it.

Signed-off-by: yangjun <yangjun@kedacom.com>
---
 drivers/cdrom/cdrom.c |    6 +++---
 drivers/scsi/sr.c     |    7 -------
 include/linux/cdrom.h |    2 +-
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..b1a5240 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -988,7 +988,7 @@ int cdrom_open(struct cdrom_device_info *cdi,
struct block_device *bdev, fmode_t

  /* if this was a O_NONBLOCK open and we should honor the flags,
  * do a quick open without drive/disc integrity checks. */
- cdi->use_count++;
+ atomic_inc(cdi->use_count);
  if ((mode & FMODE_NDELAY) && (cdi->options & CDO_USE_FFLAGS)) {
  ret = cdi->ops->open(cdi, 1);
  } else {
@@ -1020,7 +1020,7 @@ err_release:
  }
  cdi->ops->release(cdi);
 err:
- cdi->use_count--;
+ atomic_dec(cdi->use_count);
  return ret;
 }

@@ -1196,7 +1196,7 @@ void cdrom_release(struct cdrom_device_info
*cdi, fmode_t mode)
  cdinfo(CD_CLOSE, "entering cdrom_release\n");

  if (cdi->use_count > 0)
- cdi->use_count--;
+ atomic_dec(cdi->use_count);

  if (cdi->use_count == 0) {
  cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 119d67f..08c415c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -76,7 +76,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
  CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
  CDC_MRW|CDC_MRW_W|CDC_RAM)

-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
@@ -530,24 +529,20 @@ static int sr_block_open(struct block_device
*bdev, fmode_t mode)
  struct scsi_cd *cd;
  int ret = -ENXIO;

- mutex_lock(&sr_mutex);
  cd = scsi_cd_get(bdev->bd_disk);
  if (cd) {
  ret = cdrom_open(&cd->cdi, bdev, mode);
  if (ret)
  scsi_cd_put(cd);
  }
- mutex_unlock(&sr_mutex);
  return ret;
 }

 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
  struct scsi_cd *cd = scsi_cd(disk);
- mutex_lock(&sr_mutex);
  cdrom_release(&cd->cdi, mode);
  scsi_cd_put(cd);
- mutex_unlock(&sr_mutex);
 }

 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode,
unsigned cmd,
@@ -560,7 +555,6 @@ static int sr_block_ioctl(struct block_device
*bdev, fmode_t mode, unsigned cmd,

  scsi_autopm_get_device(cd->device);

- mutex_lock(&sr_mutex);

  /*
  * Send SCSI addressing ioctls directly to mid level, send other
@@ -590,7 +584,6 @@ static int sr_block_ioctl(struct block_device
*bdev, fmode_t mode, unsigned cmd,
  ret = scsi_ioctl(sdev, cmd, argp);

 out:
- mutex_unlock(&sr_mutex);
  scsi_autopm_put_device(cd->device);
  return ret;
 }
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 8609d57..5e67186 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -49,7 +49,7 @@ struct cdrom_device_info {
  unsigned mc_flags : 2; /* media change buffer flags */
  unsigned int vfs_events; /* cached events for vfs path */
  unsigned int ioctl_events; /* cached events for ioctl path */
-     int use_count;                  /* number of times device opened */
+     atomic_t use_count;             /* number of times device opened */
      char name[20];                  /* name of the device type */
 /* per-device flags */
         __u8 sanyo_slot : 2; /* Sanyo 3 CD changer support */
--
