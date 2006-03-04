From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: The SCSI transfer size limits in 2.6.15-rcx
Date: Sat, 4 Mar 2006 13:31:13 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603041314540.4277@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:2198 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751186AbWCDL2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 06:28:02 -0500
Received: from kai.makisara.local ([85.156.161.105])
          by fep01-app.kolumbus.fi with ESMTP
          id <20060304112758.UREC15721.fep01-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sat, 4 Mar 2006 13:27:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In order to remember what settings limit the transfer size for st, I did 
the list below. I hope it helps others, too.


The field .max_sectors in struct Scsi_Host sets the queue maximum transfer
size in 512 byte sectors. The type of the field is unsigned short, limiting
the value to 65535 * 512 = 32768 kB - 512 B. The default for SCSI midlevel is
1024 resulting in limit of 512 kB unless the HBA driver sets a larger 
limit.

The transfer size is limited by the number of scatter/gather segments and the
maximum size of the segments.

The number of segments is limited by the parameter .sg_tablesize in struct 
Scsi_Host (limiting what HBA accepts) _and_ the queue maximum number of 
segments (limiting what the HBA driver is given).

The HBA parameter .sg_tablesize is usually set to SG_ALL limiting the number
of segments to 255. The data type of .sg_tablesize is unsigned short and so
the absolute limit is 65535.

The SCSI midlevel sets the queue maximum number of segments to 
SCSI_MAX_PHYS_SEGMENTS. This is currently 128. Note that this is currently 
the number limiting the number of segments.

If the HBA driver sets .use_clustering in struct Scsi_Host to
DISABLE_CLUSTERING, the block layer sends requests containing only one page
segments. This limits the transfer size to 128 * 4 kB = 512 kB if
.sg_tablesize >= 128.

If .use_clustering set to ENABLE_CLUSTERING, the block layer tries to combine
adjacent pages to larger segments. The st and sg internal buffers are
allocated so that this succeeds. This enables passing larger request down to
the HBA. The maximum size of the segments is a queue parameter. The 
default is MAX_SEGMENT_SIZE in include/linux/blkdev.h (currently 65536). 
The SCSI midlevel could increase this using blk_queue_max_segment_size() 
but it does not do this. The maximum transfer size according to these 
queue limits is currently 128 * 64 kB = 8192 kB. This may be lower if the 
HBA's .sg_tablesize is below 128.


Here are some practical examples from my experiments verifying some of the
above. The experiments used a tape drive connected to sym53c1010 HBA.

My baseline is to hack the driver to enable clustering and to set .max_sectors
to 0xffff. This setup experimentally allows block size of 6144 kB. The driver
sets sg_tablesize to 96. According to the above, this together with the queue
maximum segment size sets the limit to 96 * 64 kB = 6144 kB. OK.

Next I hacked the HBA driver to use sg_tablesize = 128. Now the limit is 128
* 8192 kB. Verified experimentally.

The next thing was to increase the queue maximum segment size to 128 kB by
editing linux/include/blkdev.h (#define MAX_SEGMENT_SIZE (2 * 65536)). This
enabled transfers up to 16383 kB. This is below the theoretical limit of 16384
kB but in this case the limiting factor was the maximum block size of the
drive.

-- 
Kai
