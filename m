From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118281] New: SCSI disk driver (sd) bug (wrong max_sectors
 value)
Date: Mon, 16 May 2016 11:24:27 +0000
Message-ID: <bug-118281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbcEPLYb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 07:24:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 18387202A1
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2016 11:24:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 14A6A2026C
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2016 11:24:28 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118281

            Bug ID: 118281
           Summary: SCSI disk driver (sd) bug (wrong max_sectors value)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: alexin.ivan@gmail.com
        Regression: No

Problem: incorrect 'max_sectors_kb' value calculaton after commit
(https://github.com/torvalds/linux/commit/d0eb20a863ba7dc1d3f4b841639671f134560be2).

Examining this
code(https://github.com/torvalds/linux/blob/v4.6/drivers/scsi/sd.c#L2850):

```
//...
    /* Initial block count limit based on CDB TRANSFER LENGTH field size. */
    dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;

    /* Some devices report a maximum block count for READ/WRITE requests. */
    dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
    q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);

    /*
     * Use the device's preferred I/O size for reads and writes
     * unless the reported value is unreasonably small, large, or
     * garbage.
     */
    if (sdkp->opt_xfer_blocks &&
        sdkp->opt_xfer_blocks <= dev_max &&
        sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
        sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
//NOTE!: Assigning new 'rw_max' value in bytes here
        rw_max = q->limits.io_opt =
            sdkp->opt_xfer_blocks * sdp->sector_size;
    else
        rw_max = BLK_DEF_MAX_SECTORS;

    /* Combine with controller limits */
//NOTE!: Comparing bytes to sectors here (rw_max:bytes,
max_hw_sectros:sectors).
    q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
```

We can see that comparing 'rw_max' value (measured in bytes) to
'queue_max_hw_sectors(q)' (measured in sectors) causing error:
'max_sectors' value becomes equal to 'queue_max_hw_sectors(q)' value.

For example (assuming sector_size = 512):
Let sdkp->opt_xfer_blocks == 10160.

10160 * 512 == (rw_max = q->limits.io_opt = sdkp->opt_xfer_blocks *
sdp->sector_size)

Let also max_hw_sectors == 0xFFFF,
so, (keeping in mind 0xFFFF < 10160 * 512) 'max_sectors' value will be set to
minimal value (0xFFFF).


Another example:

```
root@srv28:~# uname -a
Linux srv28 4.4.0-22-generic #39-Ubuntu SMP Thu May 5 16:53:32 UTC 2016 x86_64
x86_64 x86_64 GNU/Linux
root@srv28:~# sg_vpd --page=0xb0 /dev/sdd | grep "Maximum transfer length"
  Maximum transfer length: 10160 blocks
root@srv28:~# cat /sys/block/dm-0/slaves/*/queue/max_hw_sectors_kb
32767
32767

```

```
root@srv32:~# uname -a
Linux srv32 3.19.0-59-generic #65~14.04.1-Ubuntu SMP Tue Apr 19 18:57:09 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux
root@srv32:~# sg_vpd --page=0xb0 /dev/sdb | grep "Maximum transfer length"
  Maximum transfer length: 10160 blocks
root@srv32:~# cat /sys/block/dm-*/slaves/*/queue/max_sectors_kb
5080
5080
5080
```

Possible bugfix (assigning correct value to 'rw_max'):

```
//...
        rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
        q->limits.io_opt = sdkp->opt_xfer_blocks * sdp->sector_size;
//...

```

Readable description:
https://gist.github.com/alexin-ivan/d23ba61dac7ae2b31acf75facad86680

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
