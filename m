Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F682C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 10:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752E220767
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 10:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VeuX1aA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgFPK0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:26:42 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10852 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPK0E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 06:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592303164; x=1623839164;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k2wrTtH2GzrGLfrzfk/gBGspC7SuqBmLlC4focXFTlU=;
  b=VeuX1aA6acfxIQLGbEK8xzyv+NRsOQS2d1NOuQ2NBq9tYzknqkCWwIVI
   E7uoP6jNIlphyQ1UeEZMnV6IxId3S+9M6XhYkZqrtrPlpTs0qmjIAev2L
   kMfFRmwd9pKAuLUx7djCW8GoVARIBm59ZtPQMIKJDsdbNSBVk168iYxED
   Qdzb9sUWY85yeSllfbD7EwO5tWDaABASzE0pBcoe4tZKZVVF2dd3kBlLW
   NcS2pmuQyt12Uy2bO/3NGEYJjcK8mFsAYZKApiszJkfnedxyj66xs2R9Y
   izFxU4fQBGagxSyXUmWkb9K+c1flOpaozMToY9iTJWeK8gJh/fpMqYz3R
   Q==;
IronPort-SDR: 13BdIXn7vmaUhGM174zGQSQFW6eUnoeeeErBspWBe2gtUtDc1xCBpR+kPUjKjlU6EM75KK9JF0
 gSwTFuN20qiRYMGCYsO0znjljW2xjdAu8QY+6wPsWqHdTUk3bXLGMLGyqadfdail9ZXuwtUzXd
 9IRb16O/EugXeKaFyTweL6ycuw41GBic0UgFDJKIZoMdJya16eUN1DS+CA8pzPpRy7fZHu2mnf
 JivKHBCfwfanx6MtcE6bUwzNTac2FLZ6WxGXA62eJM2W1W+vnEhek8As1WCn0/LvnpJ5lxfa0r
 l+g=
X-IronPort-AV: E=Sophos;i="5.73,518,1583164800"; 
   d="scan'208";a="140383059"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2020 18:26:00 +0800
IronPort-SDR: PxLLMabxEv4N8OiX/TbggrrnRjM5Wni06yrJ7Pp7wcCKrGDT7xnm40Ws0uFobNV2JSUCrqSq6a
 TSexQfN+SyIbwsWkXN+oPNeG5VIeV0R8w=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 03:15:15 -0700
IronPort-SDR: Ds8ZpyQ1PDwkBGREw3CK27qrIdNAtRYofgjQkj3QsRgzQ3Byrn7Pe1AbLOoVBnTiJLKfPrmEOs
 Y8Sji87WubWw==
WDCIronportException: Internal
Received: from 31yhj72.ad.shared (HELO localhost.hgst.com) ([10.86.58.100])
  by uls-op-cesaip02.wdc.com with ESMTP; 16 Jun 2020 03:25:55 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] Export max open zones and max active zones to sysfs
Date:   Tue, 16 Jun 2020 12:25:44 +0200
Message-Id: <20200616102546.491961-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export max open zones and max active zones to sysfs.

This patch series depends on the Zoned Namespace Command Set series:
https://lore.kernel.org/linux-nvme/20200615233424.13458-1-keith.busch@wdc.com/


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


Niklas Cassel (2):
  block: add max_open_zones to blk-sysfs
  block: add max_active_zones to blk-sysfs

 Documentation/block/queue-sysfs.rst | 14 ++++++++++
 block/blk-sysfs.c                   | 27 +++++++++++++++++++
 drivers/nvme/host/zns.c             |  2 ++
 drivers/scsi/sd_zbc.c               |  5 ++++
 include/linux/blkdev.h              | 40 +++++++++++++++++++++++++++++
 5 files changed, 88 insertions(+)

-- 
2.26.2

