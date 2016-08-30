From: Andy Grover <agrover@redhat.com>
Subject: Should queue_max_hw_sectors() always be <= max_dev_sectors?
Date: Tue, 30 Aug 2016 09:54:05 -0700
Message-ID: <202d350b-0e59-1a10-4b65-3563f0afa084@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Martin, (you're the last person to touch this? :)

If I create a local SCSI device using LIO's loopback fabric, and backed 
by a file, /sys/block/sda/queue/max_hw_sectors_kb reports 32767. This 
reflects the loopback scsi_host_template reporting 65536 max_sectors, 
but that's the "controller" -- the actual device reports via the Block 
Limits VPD of supporting a max size of 16384 512-byte blocks.

Therefore, using max_hw_sectors_kb will give a wrong impression for what 
the max data size that can be issued to the device is -- 32767KiB 
instead of 8192KiB. Should max_hw_sectors_kb be reported as the lesser 
of max_hw_sectors and max_dev_sectors? Something like:

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1196,7 +1196,7 @@ static inline unsigned int 
queue_max_sectors(struct request_queue *q)

  static inline unsigned int queue_max_hw_sectors(struct request_queue *q)
  {
-       return q->limits.max_hw_sectors;
+       return min_not_zero(q->limits.max_hw_sectors, 
q->limits.max_dev_sectors);
  }

...because limits.max_hw_sectors internally seems to be just the 
controller limit, but what users of queue_max_hw_sectors (including 
sysfs) really want is the lesser of limits.max_hw_sectors and 
limits.max_dev_sectors.

BTW the docs say:

max_hw_sectors_kb (RO)
----------------------
This is the maximum number of kilobytes supported in a single data transfer.

Thanks -- Regards -- Andy
