Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D42C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6223D24683
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rgJxAW3t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJJrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:12 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833633; x=1615369633;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GyC1mD96+zGq46P5GliCSzs31JbPFVwVSe4iMip55ZQ=;
  b=rgJxAW3t1k09l98+mauju1MsXC5px6pimWOJIjX8NpqYNVUFRHZ5E29Y
   52RvJVMwpiV2S/1n42GBzpyO3dh8eoIN4O7O8zmcz2hPGPFZmO/DWptEi
   Rx3kr9HomAyPyguheEzx3CSrwaEcXBBpIi0K7gZ9nurR1vIFAbQYlj63s
   fCAapORcmC0LIqIUOWyeY426oe3gy9k6a4dRLBH9E3JLkhB7D09ckwAlQ
   qiv5qyk4d/MeI/phDd3US+uh7tMV6lW3wCLjvxjI6FxJi97MEqT61HRal
   BDLuIkGTDPpoGZ3XSyaKDec69vxlIq8INg2wLwalGdmb0PWOGzOAVOF6R
   A==;
IronPort-SDR: Qj7ETQC9aWIrIUXM82ZHJVTmyOEYEF0IKdPf4GzXjhokYTqrXm1lVmFIRPmTS/PeQ7wML54lyE
 BmVVngzZS96V18UqbG/bbjROO3JP5Zlh/kmbdnotXiK/ukAfX36ro0UnPSAeeld0OjhKYaAcVI
 VlAuDR9KvyqTzyoV6EZ0EoPk0m2ubY7lD3OnHgYk6NNDrq8G2YRuZ2iIUXZ9tB54imsLZK1ERS
 by2lOI2KQi8zSihzAMQaObM1V7g22wdKUmeBXzEy5qD/sOGz/5OvpTS+Vca/M0xRPVSpUAr8R1
 u9c=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082772"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:13 +0800
IronPort-SDR: 7GkqxOTxxvCl8nR5LHtF+zvCaPzTHlowqVeqXU97gzZaNUjNpT1pQ/RQp4qC1vcTaNyEw6V4/E
 9ln2XBpfY1Czhbd8qotTEIiq9TR/VrLIWBybcVH+yyFn83Evd0DEhdtNh8c1vrd+E/IGuZJRs3
 bbW1NAh88G6lzEJD/B7WEdBErNUm3w8lBInW02mdXL7nwBBGNo0ivJ8Duv0f96ER/XVIU/kbMO
 z7sESn+KB/Bi3i4GuwyChbL8MUVS7mIBFNfzwM1/5L/Q36AHfL4C5qOnStq4oQqAEgiN0qw+Mh
 rcYF8uGljnxA9/hpjwl85nHb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:52 -0700
IronPort-SDR: DjILSwMrU4PEVbUV49zhF+G1O6ErZ0CzqmHdWEVU9CHGrNa5/I3GXNKXIuGYN5lYgM6924q5hP
 9PyuP6hEM/BCz9wbn4iETlhaj/NeOUhs8JrLHZ/bpRNR4jY7Fwl2Y9buy7dUOOjp45zBmwQpCp
 Rd1LETfk53vKN+eyqH/AynGpSbZ3EfScHmvcIEPwia1dQvMCn3/QLsXc6QrnMyk05o7IOXxcXu
 d583+t66Q3Xyps8wdiYutaOxTmp5DJRh9Iuebb8XOyRUNhJqdNAZ2s59ZlNNXtBwl1r422MhuM
 XLk=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:10 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 00/11] Introduce Zone Append for writing to zoned block devices
Date:   Tue, 10 Mar 2020 18:46:42 +0900
Message-Id: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The upcoming NVMe ZNS Specification will define a new type of write
command for zoned block devices, zone append.

When when writing to a zoned block device using zone append, the start
sector of the write is pointing at the start LBA of the zone to write to.
Upon completion the block device will respond with the position the data
has been placed in the zone. This from a high level perspective can be
seen like a file system's block allocator, where the user writes to a
file and the file-system takes care of the data placement on the device.

In order to fully exploit the new zone append command in file-systems and
other interfaces above the block layer, we choose to emulate zone append
in SCSI and null_blk. This way we can have a single write path for both
file-systems and other interfaces above the block-layer, like io_uring on
zoned block devices, without having to care too much about the underlying
characteristics of the device itself.

The emulation works by providing a cache of each zone's write pointer, so
zone append issued to the disk can be translated to a write with a
starting LBA of the write pointer. This LBA is used as input zone number
for the write pointer lookup in the zone write pointer offset cache and
the cached offset is then added to the LBA to get the actual position to
write the data. In SCSI we then turn the REQ_OP_ZONE_APPEND request into a
WRITE(16) command. Upon successful completion of the WRITE(16), the cache
will be updated to the new write pointer location and the written sector
will be noted in the request. On error the cache entry will be marked as
invalid and on the next write an update of the write pointer will be
scheduled, before issuing the actual write.

In order to reduce memory consumption, the only cached item is the offset
of the write pointer from the start of the zone, everything else can be
calculated. On an example drive with 52156 zones, the additional memory
consumption of the cache is thus 52156 * 4 = 208624 Bytes or 51 4k Byte
pages. The performance impact is neglectable for a spinning drive.

For null_blk the emulation is way simpler, as null_blk's zoned block
device emulation support already caches the write pointer position, so we
only need to report the position back to the upper layers. Additional
caching is not needed here.

Testing has been conducted by translating RWF_APPEND DIOs into
REQ_OP_ZONE_APPEND commands in the block device's direct I/O function and
injecting errors by bypassing the block layer interface and directly
writing to the disc via the SCSI generic interface.

The whole series is relative to Jens' block-5.6 branch 14afc5936197
("block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()").

Damien Le Moal (2):
  null_blk: Support REQ_OP_ZONE_APPEND
  block: Introduce zone write pointer offset caching

Johannes Thumshirn (8):
  block: provide fallbacks for blk_queue_zone_is_seq and
    blk_queue_zone_no
  block: introduce bio_add_append_page
  block: introduce BLK_STS_ZONE_RESOURCE
  block: introduce blk_req_zone_write_trylock
  block: factor out requeue handling from dispatch code
  block: delay un-dispatchable request
  scsi: sd_zbc: factor out sanity checks for zoned commands
  scsi: sd_zbc: emulate ZONE_APPEND commands

Keith Busch (1):
  block: Introduce REQ_OP_ZONE_APPEND

 block/bio.c                    |  41 +++-
 block/blk-core.c               |  49 +++++
 block/blk-map.c                |   2 +-
 block/blk-mq.c                 |  54 +++++-
 block/blk-settings.c           |  16 ++
 block/blk-sysfs.c              |  15 +-
 block/blk-zoned.c              |  83 +++++++-
 block/blk.h                    |   4 +-
 drivers/block/null_blk_main.c  |   9 +-
 drivers/block/null_blk_zoned.c |  21 +-
 drivers/scsi/scsi_lib.c        |   1 +
 drivers/scsi/sd.c              |  28 ++-
 drivers/scsi/sd.h              |  35 +++-
 drivers/scsi/sd_zbc.c          | 344 +++++++++++++++++++++++++++++++--
 include/linux/bio.h            |   3 +-
 include/linux/blk_types.h      |  14 ++
 include/linux/blkdev.h         |  42 +++-
 17 files changed, 701 insertions(+), 60 deletions(-)

-- 
2.24.1

