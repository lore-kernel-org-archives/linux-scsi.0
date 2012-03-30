From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 2/4] scsi: replace sd_format_disk_name() to disk_name_format()
Date: Fri, 30 Mar 2012 17:53:03 +0800
Message-ID: <4F75827F.2010002@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

  Since "sd_format_disk_name()"has been copied into block
core as "disk_name_format()", the original function should
be removed, and the place used original function should be
replaced by the renamed function.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  sd.c |   48 +-----------------------------------------------
  1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 09e3df4..b82156a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2525,52 +2525,6 @@ static void sd_unlock_native_capacity(struct 
gendisk *disk)
                 sdev->host->hostt->unlock_native_capacity(sdev);
  }

-/**
- *     sd_format_disk_name - format disk name
- *     @prefix: name prefix - ie. "sd" for SCSI disks
- *     @index: index of the disk to format name for
- *     @buf: output buffer
- *     @buflen: length of the output buffer
- *
- *     SCSI disk names starts at sda.  The 26th device is sdz and the
- *     27th is sdaa.  The last one for two lettered suffix is sdzz
- *     which is followed by sdaaa.
- *
- *     This is basically 26 base counting with one extra 'nil' entry
- *     at the beginning from the second digit on and can be
- *     determined using similar method as 26 base conversion with the
- *     index shifted -1 after each digit is computed.
- *
- *     CONTEXT:
- *     Don't care.
- *
- *     RETURNS:
- *     0 on success, -errno on failure.
- */
-static int sd_format_disk_name(char *prefix, int index, char *buf, int 
buflen)
-{
-       const int base = 'z' - 'a' + 1;
-       char *begin = buf + strlen(prefix);
-       char *end = buf + buflen;
-       char *p;
-       int unit;
-
-       p = end - 1;
-       *p = '\0';
-       unit = base;
-       do {
-               if (p == begin)
-                       return -EINVAL;
-               *--p = 'a' + (index % unit);
-               index = (index / unit) - 1;
-       } while (index >= 0);
-
-       memmove(begin, p, end - p);
-       memcpy(buf, prefix, strlen(prefix));
-
-       return 0;
-}
-
  /*
   * The asynchronous part of sd_probe
   */
@@ -2685,7 +2639,7 @@ static int sd_probe(struct device *dev)
                 goto out_put;
         }

-       error = sd_format_disk_name("sd", index, gd->disk_name, 
DISK_NAME_LEN);
+       error = disk_name_format("sd", index, gd->disk_name, DISK_NAME_LEN);
         if (error) {
                 sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name 
length exceeded.\n");
                 goto out_free_index;
