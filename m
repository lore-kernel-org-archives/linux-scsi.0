Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652B1C47420
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14AEB2311D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYYTFfMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgIYQTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729337AbgIYQTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CZzTv3hBY/mUlwQevJcuf6ALk7r9I6yfAL5YgetwTXE=;
        b=dYYTFfMa4Sp8hgIsP6oA4mi7npNVQLZHCnZHaIvf4G2EDnyc6zJBmjIoxEV1SXLokpkVJ2
        +7pAAx6vQw0sVqJS9YNFeobxpuX6hgHMhuB/B6IkIs+BaiK9eNa86pJcRjCen8sR4pEvs9
        joQcdJ54DhbvjSa2E/ivG1vAi2c3p54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-ITFCUEKKPZ6J5olKVgEi9g-1; Fri, 25 Sep 2020 12:19:32 -0400
X-MC-Unique: ITFCUEKKPZ6J5olKVgEi9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37A3010BBECF;
        Fri, 25 Sep 2020 16:19:31 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E3035D9DC;
        Fri, 25 Sep 2020 16:19:30 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 00/12] Add persistent durable identifier to storage log messages
Date:   Fri, 25 Sep 2020 11:19:17 -0500
Message-Id: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Today users have no easy way to correlate kernel log messages for storage
devices across reboots, device dynamic add/remove, or when the device is
physically or logically moved from from system to system.  This is due
to the existing log IDs which identify how the device is attached and not
a unique ID of what is attached.  Additionally, even when the attachment
hasn't changed, it's not always obvious which messages belong to the
device as the different areas in the storage stack use different
identifiers, eg. (sda, sata1.00, sd 0:0:0:0).

This change addresses this by adding a unique ID to each log
message.  It couples the existing structured key/value logging capability
and VPD 0x83 device identification.  The structured key/value data is not
visible in normal viewing and is not seen in the dmesg output or journal
output unless you go looking for it by dumping the output as JSON.

Some examples of logs filtered for a specific device utilizing this patch
series.

$ journalctl -b  _KERNEL_DURABLE_NAME="`cat /sys/block/sdb/device/wwid`" 
| cut -c 25- | fmt -t
l: scsi 1:0:0:0: Attached scsi generic sg1 type 0
l: sd 1:0:0:0: [sdb] 209715200 512-byte logical blocks: (107 GB/100 GiB)
l: sd 1:0:0:0: [sdb] Write Protect is off
l: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
l: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
   support DPO or FUA
l: sd 1:0:0:0: [sdb] Attached SCSI disk
l: ata2.00: exception Emask 0x0 SAct 0x8 SErr 0x8 action 0x6 frozen
l: ata2.00: failed command: READ FPDMA QUEUED
l: ata2.00: cmd 60/01:18:10:27:00/00:00:00:00:00/40 tag 3 ncq dma 512
            in res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
l: ata2.00: status: { DRDY }
l: ata2.00: configured for UDMA/100
l: ata2.00: device reported invalid CHS sector 0
l: ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x4000 action 0x6 frozen
l: ata2.00: failed command: READ FPDMA QUEUED
l: ata2.00: cmd 60/01:70:10:27:00/00:00:00:00:00/40 tag 14 ncq dma 512
            in res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
l: ata2.00: status: { DRDY }
l: ata2.00: configured for UDMA/100
l: ata2.00: device reported invalid CHS sector 0
l: ata2.00: exception Emask 0x0 SAct 0x80000000 SErr 0x80000000 action
            0x6 frozen
l: ata2.00: failed command: READ FPDMA QUEUED
l: ata2.00: cmd 60/01:f8:10:27:00/00:00:00:00:00/40 tag 31 ncq dma 512
            in res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
l: ata2.00: status: { DRDY }
l: ata2.00: configured for UDMA/100
l: ata2.00: NCQ disabled due to excessive errors
l: ata2.00: exception Emask 0x0 SAct 0x40000 SErr 0x40000 action 0x6
            frozen
l: ata2.00: failed command: READ FPDMA QUEUED
l: ata2.00: cmd 60/01:90:10:27:00/00:00:00:00:00/40 tag 18 ncq dma 512
            in res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
l: ata2.00: status: { DRDY }
l: ata2.00: configured for UDMA/100

$ journalctl -b  _KERNEL_DURABLE_NAME="`cat /sys/block/nvme0n1/wwid`" 
| cut -c 25- | fmt -t
l: blk_update_request: critical medium error, dev nvme0n1, sector 10000
   op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 0
l: blk_update_request: critical medium error, dev nvme0n1, sector 10000
   op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
l: Buffer I/O error on dev nvme0n1, logical block 1250, async page read

$ journalctl -b  _KERNEL_DURABLE_NAME="`cat /sys/block/sdc/device/wwid`"
| cut -c 25- | fmt -t
l: sd 8:0:0:0: Power-on or device reset occurred
l: sd 8:0:0:0: [sdc] 16777216 512-byte logical blocks: (8.59 GB/8.00 GiB)
l: sd 8:0:0:0: Attached scsi generic sg2 type 0
l: sd 8:0:0:0: [sdc] Write Protect is off
l: sd 8:0:0:0: [sdc] Mode Sense: 63 00 00 08
l: sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
   support DPO or FUA
l: sd 8:0:0:0: [sdc] Attached SCSI disk
l: sd 8:0:0:0: [sdc] tag#255 FAILED Result: hostbyte=DID_OK
   driverbyte=DRIVER_SENSE cmd_age=0s
l: sd 8:0:0:0: [sdc] tag#255 Sense Key : Medium Error [current]
l: sd 8:0:0:0: [sdc] tag#255 Add. Sense: Unrecovered read error
l: sd 8:0:0:0: [sdc] tag#255 CDB: Read(10) 28 00 00 00 27 10 00 00 01 00
l: blk_update_request: critical medium error, dev sdc, sector 10000 op
   0x0:(READ) flags 0x0 phys_seg 1 prio class 0

There should be no changes to the log message content with this patch series.
I ran release kernel and this patch series and did a compare while forcing the
kernel through the same errors paths to verify.

The first 6 commits in the patch series utilize changes needed for dev_printk
code path.  The last 6 commits in the patch add the needed changes to utilize
durable_name_printk.  The function durable_name_printk is nothing more than
a printk that adds structured key/value durable name to unmodified printk
output.  I structured it this way so only a subset of the patch series could
be theoretically applied if we cannot get agreement on complete patch series.

v2:
- Incorporated changes suggested by James Bottomley
- Removed string function which removed leading/trailing/duplicate adjacent
  spaces from generated id, value matches /sys/block/<device>/device/wwid
- Remove xfs patch, limiting changes to lower block layers
- Moved callback from struct device_type to struct device.  Struct device_type
  is typically static const and with a number of different areas using shared
  implementation of genhd unable to modify for each of the different areas.

v3:
- Increase the size of the buffers for NVMe id generation and
  dev_vprintk_emit
  
v4:
- Back out dev_printk for those locations that weren't using it before, so that
  we don't change the content of the user visible log message by using a
  function durable_name_printk.
- Remove RFC from patch series.

v5:
- Reduced stack usage for nvme wwid
- Make function ata_scsi_durable_name static, found by kernel test robot
- Incorporated suggested changes from Andy Shevchenko and Sergei Shtylyov
  * Remove unneeded line spacing
  * Correct spelling
  * Remove unneeded () in conditional operator
  * Re-worked expressions to follow common kernel patterns, added
    function dev_to_scsi_device
- Re-based for v5.8 branch

Tony Asleson (12):
  struct device: Add function callback durable_name
  create_syslog_header: Add durable name
  dev_vprintk_emit: Increase hdr size
  scsi: Add durable_name for dev_printk
  nvme: Add durable name for dev_printk
  libata: Add ata_scsi_durable_name
  libata: Make ata_scsi_durable_name static
  Add durable_name_printk
  libata: use durable_name_printk
  Add durable_name_printk_ratelimited
  print_req_error: Use durable_name_printk_ratelimited
  buffer_io_error: Use durable_name_printk_ratelimited

 block/blk-core.c           |  5 ++++-
 drivers/ata/libata-core.c  | 17 +++++++-------
 drivers/ata/libata-scsi.c  | 18 ++++++++++++---
 drivers/base/core.c        | 46 +++++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/core.c   | 18 +++++++++++++++
 drivers/scsi/scsi_lib.c    |  9 ++++++++
 drivers/scsi/scsi_sysfs.c  | 35 +++++++++++++++++++++++------
 drivers/scsi/sd.c          |  2 ++
 fs/buffer.c                | 15 +++++++++----
 include/linux/dev_printk.h | 14 ++++++++++++
 include/linux/device.h     |  4 ++++
 include/scsi/scsi_device.h |  3 +++
 12 files changed, 162 insertions(+), 24 deletions(-)


base-commit: bcf876870b95592b52519ed4aafcf9d95999bc9c
-- 
2.26.2

