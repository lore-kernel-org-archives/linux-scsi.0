Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F29C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708252065D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kVVHus2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgGNVSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:18:37 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20892 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594761517; x=1626297517;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Eii7FmfTiwjXtaWeM5VI3cqCVXCyz8WbJm0iTlMDWJs=;
  b=kVVHus2PHjq3i+ziCcrND1PXldELov17MAses7XbS5ikQM1FDMPUReQp
   DdFlEdc8VJ2JA6+Cm3FTYtd0N+p9YlzHdCmZiD3I2asKdAoLYwIebJcgq
   yOX4DkP25MRDEvfLw+c00AcX/kAHM3Y45heqTmYQTv6zXc2nOL8QTasNB
   1owWw5wpNoNmfEHO+uArk88sGTvWuGxQtBY77GT1b1sVdh9jT50zjUj8N
   +1iKN1sDq1606AR7XdMwyYk1et1Y/3kerp7YDqAyCxnVYxaV4h8p3I+z3
   zIjwQ/LnWLjTWZzPW3VR4vM9ngT8Rd7QjKt+GJO4/qRZs5lby7TLVHxPF
   A==;
IronPort-SDR: vIkvKDXrQogmZl1IHB4mazvAyLWTQxPlvpOhWHJHojCsDp4S5gnBvH6gLNEP5rsjxgLizVeutd
 8K8kaRYrQQqUECpt+cxcgiXYX/Sib/CAkXaG1z/jC1A8VqkC2d71XXBtUfYbKv47zZJhC/9Z2n
 lhG0860Rt1F28gH5WtA1ClrMCU5dYmJORnZe3D6ws5TRaw+UYUa62v6dKm2203xF1NNj8ErrYT
 xtJzk7XrQPXchZ07AYOEnDyVxbzDedyNGoIOQDtpENdGynJweHwbbdVmEUEFjczZZZUZz0X7PK
 iGw=
X-IronPort-AV: E=Sophos;i="5.75,352,1589212800"; 
   d="scan'208";a="251722322"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 05:18:36 +0800
IronPort-SDR: yxCyiQCl6J9TlnWkcAbuSiL9Zeudg4ZC2C+rIlriLM9PmnrYVB9/rsUA3yW/3UI3vENUOQCQrm
 MV+iIri0AQphI8KBy2Eg1wx1PrlIFzNg8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 14:07:02 -0700
IronPort-SDR: k7z3BG/rBj8iFCvPyvk0k3PKbnvggxnH2BwR5yWdE3n5oHKB7mt35lSX0qKzIUfr8NJIC1e2Oq
 dUHvmegCmbjw==
WDCIronportException: Internal
Received: from usa003306.ad.shared (HELO localhost.hgst.com) ([10.86.57.226])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Jul 2020 14:18:33 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/2] Export max open zones and max active zones to sysfs
Date:   Tue, 14 Jul 2020 23:18:22 +0200
Message-Id: <20200714211824.759224-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export max open zones and max active zones to sysfs.

This patch series in based on Jens's linux-block/for-next branch.

All zoned block devices in the kernel utilize the "zoned block device
support" (CONFIG_BLK_DEV_ZONED).

The Zoned Namespace Command Set Specification defines two different
resource limits: Max Open Resources and Max Active Resources.

The ZAC and ZBC standards define a MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE
REQUIRED ZONES field.


Since the ZNS Max Open Resources field has the same purpose as the ZAC/ZBC
field, (the ZNS field is 0's based, the ZAC/ZBC field isn't), create a
common "max_open_zones" definition in the sysfs documentation, and export
both the ZNS field and the ZAC/ZBC field according to this new common
definition.

The ZNS Max Active Resources field does not have an equivalent field in
ZAC/ZBC, however, since both ZAC/ZBC and ZNS utilize the "zoned block
device support" in the kernel, create a "max_active_zones" definition in
the sysfs documentation, similar to "max_open_zones", and export it
according to this new definition. For ZAC/ZBC devices, this field will be
exported as 0, meaning "no limit".

Changes since v2:
-Picked up Damien's Reviewed-by tags.
-Update Documentation/ABI/testing/sysfs-block in addition to
 Documentation/block/queue-sysfs.rst (Greg).
-Added bdev_max_open_zones()/bdev_max_active_zones() helpers
 (Johannes).

Niklas Cassel (2):
  block: add max_open_zones to blk-sysfs
  block: add max_active_zones to blk-sysfs

 Documentation/ABI/testing/sysfs-block | 18 ++++++++++
 Documentation/block/queue-sysfs.rst   | 14 ++++++++
 block/blk-sysfs.c                     | 27 +++++++++++++++
 drivers/nvme/host/zns.c               |  2 ++
 drivers/scsi/sd_zbc.c                 |  5 +++
 include/linux/blkdev.h                | 50 +++++++++++++++++++++++++++
 6 files changed, 116 insertions(+)

-- 
2.26.2

