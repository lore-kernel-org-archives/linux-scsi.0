Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A13C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 091BA2084D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtD2PWwe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733309AbgFWTR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:17:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733270AbgFWTR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 15:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+P9zuie6AFghJynlgBPJee7CZBCUK+HjLwj4LjvUfdA=;
        b=NtD2PWwexaPULR1rZ9drxkpy0nmhAzK3GGA7PWb7VSlL5uUpmhqwkDywXEdtGKbxhOnLLq
        iOsDgGAj5GNfIMH91dejfjAU2IvjE4yjl/HOmy2vTguE+c0lAGs5xpebMdc22c/h1K7fOI
        5/vRmYhc9JTrX3D3/6idVWcfIrJACGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-SRktsXZjOoGgfa2J1jEq8g-1; Tue, 23 Jun 2020 15:17:53 -0400
X-MC-Unique: SRktsXZjOoGgfa2J1jEq8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD14D8031C2;
        Tue, 23 Jun 2020 19:17:51 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E869C71699;
        Tue, 23 Jun 2020 19:17:50 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 0/8] Add persistent durable identifier to storage log messages
Date:   Tue, 23 Jun 2020 14:17:41 -0500
Message-Id: <20200623191749.115200-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
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
and VPD 0x83 device identification.


An example of logs filtered for a specific device utilizing this patch
series.

$ journalctl -b  _KERNEL_DURABLE_NAME="`cat /sys/block/sdb/device/wwid`"
| cut -c 25- | fmt -t
9-08-22 13:21:35 CDT, end at Wed 2020-05-13 15:40:26 CDT. --
l: scsi 1:0:0:0: Attached scsi generic sg1 type 0
l: sd 1:0:0:0: [sdb] 209715200 512-byte logical blocks: (107 GB/100 GiB)
l: sd 1:0:0:0: [sdb] Write Protect is off
l: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
l: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
   support DPO or FUA
l: sd 1:0:0:0: [sdb] Attached SCSI disk
l: sd 1:0:0:0: ata2.00: exception Emask 0x0 SAct 0x800000 SErr 0x800000
   action 0x6 frozen
l: sd 1:0:0:0: ata2.00: failed command: READ FPDMA QUEUED
l: sd 1:0:0:0: ata2.00: cmd 60/20:b8:10:27:00/00:00:00:00:00/40 tag 23
            ncq dma 16384 in res 40/00:00:00:4f:c2/00:00:00:00:00/00
            Emask 0x4 (timeout)
l: sd 1:0:0:0: ata2.00: status: { DRDY }
l: sd 1:0:0:0: ata2.00: configured for UDMA/100
l: sd 1:0:0:0: [sdb] tag#23 FAILED Result: hostbyte=DID_OK
            driverbyte=DRIVER_SENSE cmd_age=30s
l: sd 1:0:0:0: [sdb] tag#23 Sense Key : Illegal Request [current]
l: sd 1:0:0:0: [sdb] tag#23 Add. Sense: Unaligned write command
l: sd 1:0:0:0: [sdb] tag#23 CDB: Read(10) 28 00 00 00 27 10 00 00 20 00
l: block sdb: blk_update_request: I/O error, dev sdb, sector 10000 op
            0x0:(READ) flags 0x80700 phys_seg 4 prio class 0
l: sd 1:0:0:0: ata2.00: exception Emask 0x0 SAct 0x2 SErr 0x2 action
            0x6 frozen
l: sd 1:0:0:0: ata2.00: failed command: READ FPDMA QUEUED
l: sd 1:0:0:0: ata2.00: cmd 60/08:08:10:27:00/00:00:00:00:00/40 tag 1 ncq
            dma 4096 in res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
            (timeout)
l: sd 1:0:0:0: ata2.00: status: { DRDY }
l: sd 1:0:0:0: ata2.00: configured for UDMA/100
l: sd 1:0:0:0: ata2.00: exception Emask 0x0 SAct 0x800000 SErr 0x800000
            action 0x6 frozen
l: sd 1:0:0:0: ata2.00: failed command: READ FPDMA QUEUED
l: sd 1:0:0:0: ata2.00: cmd 60/08:b8:10:27:00/00:00:00:00:00/40 tag 23 ncq
            dma 4096 in res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4
            (timeout)
l: sd 1:0:0:0: ata2.00: status: { DRDY }
l: sd 1:0:0:0: ata2.00: configured for UDMA/100
l: sd 1:0:0:0: ata2.00: NCQ disabled due to excessive errors
l: sd 1:0:0:0: ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x4000
            action 0x6 frozen
l: sd 1:0:0:0: ata2.00: failed command: READ FPDMA QUEUED
l: sd 1:0:0:0: ata2.00: cmd 60/08:70:10:27:00/00:00:00:00:00/40 tag 14 ncq
            dma 4096 in res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
            (timeout)
l: sd 1:0:0:0: ata2.00: status: { DRDY }
l: sd 1:0:0:0: ata2.00: configured for UDMA/100
l: sd 1:0:0:0: ata2.00: device reported invalid CHS sector 0

This change is incomplete.  With the plethora of different logging
techniques utilized in the kernel it will take some coordinated effort
and additional changes.  I tried a few different approaches, to cover
as much as I could without resorting to changing every print statement
in all the storage layers, but maybe there is a better,
more elegant approach?

I believe having this functionality is very useful and important for
system configurations of all sizes.  I mentioned this change briefly in:
https://lore.kernel.org/lkml/30f29fe6-8445-0016-8cdc-3ef99d43fbf5@redhat.com/

Questions
1. Where is the best place to put the durable_name callback function?
2. What is best "KEY" value?
3. Should we re-work the message contents themselves to remove any redundant
   information that is included when using dev_printk? ref. 
   https://lore.kernel.org/linux-scsi/e12aeb9e-fe5d-5b5e-d190-401997cecc34@redhat.com/#t


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

Tony Asleson (8):
  struct device: Add function callback durable_name
  create_syslog_header: Add durable name
  print_req_error: Use dev_printk
  buffer_io_error: Use dev_printk
  ata_dev_printk: Use dev_printk
  scsi: Add durable_name for dev_printk
  nvme: Add durable name for dev_printk
  dev_vprintk_emit: Increase hdr size

 block/blk-core.c           |  5 ++++-
 drivers/ata/libata-core.c  | 10 +++++++---
 drivers/base/core.c        | 31 ++++++++++++++++++++++++++++++-
 drivers/nvme/host/core.c   | 18 ++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 14 ++++++++++++++
 drivers/scsi/scsi_sysfs.c  | 23 +++++++++++++++++++++++
 drivers/scsi/sd.c          |  2 ++
 fs/buffer.c                | 10 ++++++++--
 include/linux/device.h     |  4 ++++
 include/scsi/scsi_device.h |  3 +++
 10 files changed, 113 insertions(+), 7 deletions(-)


base-commit: 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
-- 
2.25.4

