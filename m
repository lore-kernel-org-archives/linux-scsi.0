From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Thu, 5 Apr 2012 16:32:45 +0800
Message-ID: <20120405083245.GA19508@localhost.amd.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
 <CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
 <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
> >
> > Another thing to consider is, user might want to eject the tray by
> > software like the
> > eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
> > thinking how to do this correctly.
> 
> Assume eject /dev/sr0 is implemented as:
> 
> int fd = open("/dev/sr0", ...)
> ioctl(fd, CDROMEJECT)
> 

Indeed, it is implemented as this :-)

> We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
> 

I prefer we do this in sr_block_ioctl.
Suppose the ODD is now runtime suspended and received an ioctl:
if the ioctl's cmd is CDROMEJECT, resume it.
For other cases, return an error code like EPERM.
When done, according to the result of ioctl: if success, leave it resumed;
if failed, put it back to sleep.

Something like this:

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..aa6e920 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
        struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
        struct scsi_device *sdev = cd->device;
        void __user *argp = (void __user *)arg;
-       int ret;
+       int ret, rpm_resumed = 0;
 
        mutex_lock(&sr_mutex);
 
+       if (pm_runtime_suspended(&sdev->sdev_gendev)) {
+               if (cmd == CDROMEJECT) {
+                       scsi_autopm_get_device(sdev);
+                       rpm_resumed = 1;
+               }
+               else {
+                       ret = -EPERM;
+                       goto out;
+               }
+       }
+
        /*
         * Send SCSI addressing ioctls directly to mid level, send other
         * ioctls to cdrom/block level.
@@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
        ret = scsi_ioctl(sdev, cmd, argp);
 
 out:
+       if (rpm_resumed && ret)
+               scsi_autopm_put_device(sdev);
+
        mutex_unlock(&sr_mutex);
        return ret;
 }

Does this work?

-Aaron


